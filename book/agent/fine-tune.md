
## fine tune
```

[
  {
    "prompt": "Explain the function validate_user.",
    "completion": "It checks whether the user dictionary contains id, name, and email."
  },
  {
    "prompt": "Write a function to validate phone number internal style.",
    "completion": "def validate_phone(phone: str) -> bool:\n  return phone.isdigit() and len(phone) == 10"
  }
]

from transformers import AutoModelForCausalLM, AutoTokenizer, Trainer, TrainingArguments
from datasets import load_dataset

# Load model and tokenizer
model = AutoModelForCausalLM.from_pretrained("base-model")
tokenizer = AutoTokenizer.from_pretrained("base-model")

# Load the dataset
dataset = load_dataset("json", data_files="internal_data.json")

# Define training arguments
training_args = TrainingArguments(
    output_dir="./fine_tuned_model",
    per_device_train_batch_size=4,
    num_train_epochs=3
)

# Initialize the trainer
trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=dataset["train"]
)

# Start training
trainer.train()





```


## qlora Mistral-7B-Instruct using QLoRA on a Google Colab T4 GPU
https://pdfhost.io/v/VcK7gNFUY9_Qlora_llm_2026-10-31_16-41



Here is the complete 8-step fine-tuning blueprint for Mistral-7B-Instruct using QLoRA, complete with thorough explanatory documentation comments added directly to the code snippets:

---

### Step 1: Environment Setup

Install and configure the Hugging Face and TRL dependency stack required for Parameter-Efficient Fine-Tuning (PEFT) using LoRA and QLoRA.

```bash
# Keep it simple: use current Colab PyTorch + CUDA + NumPy
pip install -q --upgrade pip
pip install -q transformers accelerate datasets peft bitsandbytes einops wandb
pip install -U bitsandbytes

```

---

### Step 2: Initialization and Essential Configuration

Initialize essential hyperparameters, paths, and environment settings.

```python
import trl, transformers
import importlib, pkgutil
print(trl.__version__)

# Base pretrained model and output directory for saving checkpoints
BASE_MODEL = "mistralai/Mistral-7B-Instruct-v0.2"
OUTPUT_DIR = "/content/qlora-mistral-sysprog"

# QLoRA and training hyperparameters
USE_4BIT = True   # Enable 4-bit quantization (QLoRA enablement)
SEQ_LEN = 1024    # Maximum token length per sequence (keep 2048 for T4 comfort)
EPOCHS = 8        # Number of complete training epochs over the dataset
LR = 2e-4         # Learning rate for adapter optimization
BATCH_SIZE = 1    # Per-device training batch size
GRAD_ACCUM = 8    # Gradient accumulation steps to emulate larger effective batch size
WARMUP_RATIO = 0.03 # Fraction of total steps for learning rate warmup
SAVE_STEPS = 50   # Frequency of saving checkpoints
LOG_STEPS = 1     # Frequency of logging metrics
VAL_SET_SIZE = 0  # Set > 0 if you add a validation split

```

---

### Step 3: Data Preparation and Transformation

Load the JSON dataset and transform each record into an instruction-response format.

```python
from datasets import load_dataset
from transformers import AutoTokenizer

# Initialize the tokenizer with fast processing enabled
tokenizer = AutoTokenizer.from_pretrained(BASE_MODEL, use_fast=True)

# Load the training and validation JSONL datasets
ds = load_dataset("json", data_files={
    "train": "/content/sample_data/sysprog_train_large.jsonl",
    "valid": "/content/sample_data/sysprog_valid_small.jsonl"
})

def to_chat_format(example):
    """Transforms raw instruction examples into chat template format."""
    user = example["instruction"]
    if example.get("input"):
        user += f"\n\nInput:\n{example['input']}"
    messages = [
        {"role": "user", "content": user},
        {"role": "assistant", "content": example["output"]}
    ]
    text = tokenizer.apply_chat_template(messages, tokenize=False, add_generation_prompt=False)
    return {"text": text}

train_ds = ds["train"].map(to_chat_format, remove_columns=[c for c in ds["train"].column_names if c != "text"])
valid_ds = ds["valid"].map(to_chat_format, remove_columns=[c for c in ds["valid"].column_names if c != "text"])

def format_example(example):
    """Formats records into explicit prompt and response blocks with EOS tokens."""
    instruction = example['instruction']
    input_text = example.get('input', "")
    output_text = example['output']
    
    # Construct prompt based on whether optional input is provided
    if input_text:
        prompt = f"### Instruction:\n{instruction}\n\n### Input:\n{input_text}\n\n### Response:\n"
    else:
        prompt = f"### Instruction:\n{instruction}\n\n### Response:\n"
        
    text = prompt + output_text + tokenizer.eos_token
    return {"text": text}

# Apply formatting, filter extra columns, and shuffle training data
train_ds = ds['train'].map(format_example)
train_ds = train_ds.remove_columns([c for c in train_ds.column_names if c != 'text'])
train_ds = train_ds.shuffle(seed=42)

```

---

### Step 4: Model Loading and Tokenizer Initialization (4-bit Quantization)

Configure 4-bit QLoRA using `bitsandbytes` to fit within the T4 GPU's VRAM constraints.

```python
from transformers import AutoTokenizer, AutoModelForCausalLM, BitsAndBytesConfig
from peft import LoraConfig, TaskType, prepare_model_for_kbit_training
import torch

# Configure BitsAndBytes for 4-bit NormalFloat (NF4) quantization
bnb_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_quant_type="nf4",
    bnb_4bit_compute_dtype=torch.float16,
    bnb_4bit_use_double_quant=True,
)

# Setup tokenizer padding configuration
tokenizer = AutoTokenizer.from_pretrained(BASE_MODEL, use_fast=True)
tokenizer.padding_side = "right"
if tokenizer.pad_token is None:
    tokenizer.pad_token = tokenizer.eos_token

# Load the base model with quantization config applied
model = AutoModelForCausalLM.from_pretrained(
    BASE_MODEL,
    quantization_config=bnb_config if USE_4BIT else None,
    device_map="auto"
)

# Disable KV cache and enable gradient checkpointing to save VRAM
model.config.use_cache = False
model.gradient_checkpointing_enable()

# Prepare model for low-precision training if 4-bit quantization is enabled
if USE_4BIT:
    model = prepare_model_for_kbit_training(model)

```

---

### Step 5: Supervised Fine-Tuning Configuration

Set up the LoRA adapters and the `SFTTrainer` configuration parameters.

```python
from trl import SFTTrainer, SFTConfig
from peft import LoraConfig, TaskType

# Define LoRA architecture parameters (rank, alpha, target projection modules)
lora_config = LoraConfig(
    r=16,
    lora_alpha=32,
    target_modules=["q_proj", "k_proj", "v_proj", "o_proj", "gate_proj", "up_proj", "down_proj"],
    lora_dropout=0.05,
    bias="none",
    task_type=TaskType.CAUSAL_LM
)

# Define supervised fine-tuning arguments and hyperparameters
sft_config = SFTConfig(
    output_dir=OUTPUT_DIR,
    num_train_epochs=EPOCHS,
    per_device_train_batch_size=BATCH_SIZE,
    gradient_accumulation_steps=GRAD_ACCUM,
    learning_rate=LR,
    lr_scheduler_type="cosine",
    warmup_ratio=WARMUP_RATIO,
    logging_steps=LOG_STEPS,
    save_steps=SAVE_STEPS,
    save_total_limit=2,
    fp16=False,
    bf16=False,
    half_precision_backend="cuda",
    optim="paged_adamw_8bit" if USE_4BIT else "adamw_torch",
    max_grad_norm=1.0,
    gradient_checkpointing=True,
    max_length=SEQ_LEN,
    dataset_text_field="text",
    packing=False,
)

# Initialize the supervised fine-tuning trainer
trainer = SFTTrainer(
    model=model,
    train_dataset=train_ds,
    args=sft_config,
    processing_class=tokenizer,
    peft_config=lora_config,
)

```

---

### Step 6: Model Training (`SFTTrainer` Execution)

Run the training loop and save the resulting LoRA adapters and tokenizer.

```python
# Execute the training process over the dataset
trainer.train()

# Save the trained LoRA adapter weights and tokenizer configuration
trainer.model.save_pretrained(OUTPUT_DIR)
tokenizer.save_pretrained(OUTPUT_DIR)

```

---

### Step 7: Apply Trained Adapters and Quick Inferencing

Load the trained adapters onto the base model to run quick inference.

```python
from transformers import AutoTokenizer, AutoModelForCausalLM, BitsAndBytesConfig
from peft import PeftModel, prepare_model_for_kbit_training
import torch

BASE_MODEL_NAME = BASE_MODEL
LORA_DIR = OUTPUT_DIR

# Re-initialize quantization configuration for inference loading
bnb_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_quant_type="nf4",
    bnb_4bit_compute_dtype=torch.float16,
    bnb_4bit_use_double_quant=True,
)

# Load and configure tokenizer for inference
tokenizer = AutoTokenizer.from_pretrained(BASE_MODEL_NAME, use_fast=True)
tokenizer.padding_side = "right"
if tokenizer.pad_token is None:
    tokenizer.pad_token = tokenizer.eos_token

# Load base model in 4-bit precision on device 0
base_model = AutoModelForCausalLM.from_pretrained(
    BASE_MODEL_NAME,
    quantization_config=bnb_config,
    device_map={"": 0}
)
base_model = prepare_model_for_kbit_training(base_model)

# Attach trained LoRA adapters onto the quantized base model
infer_model = PeftModel.from_pretrained(
    base_model,
    LORA_DIR,
    is_trainable=False,
)
infer_model.eval()
infer_model.config.use_cache = True
infer_model.config.pad_token_id = tokenizer.pad_token_id
infer_model.config.eos_token_id = tokenizer.eos_token_id
infer_model.config.bos_token_id = tokenizer.bos_token_id

def generate(prompt, max_new_tokens=360):
    """Helper function to tokenize prompts and generate model responses."""
    inputs = tokenizer(prompt, return_tensors="pt").to(infer_model.device)
    with torch.no_grad():
        outputs = infer_model.generate(
            **inputs,
            max_new_tokens=max_new_tokens,
            do_sample=True,
            temperature=0.7,
            top_p=0.9,
            top_k=50,
            repetition_penalty=1.1,
            pad_token_id=tokenizer.pad_token_id,
            eos_token_id=tokenizer.eos_token_id
        )
    return tokenizer.decode(outputs[0], skip_special_tokens=True)

```

---

### Step 8: Merge and Save the Model

Collapse the LoRA adapter weights into the quantized base model to produce a standalone, production-ready checkpoint.

```python
# Merge the low-rank LoRA weights directly into the base model layers
merged_model = infer_model.merge_and_unload()

# Save the consolidated standalone model and tokenizer
merged_model.save_pretrained(f"{OUTPUT_DIR}_merged")
tokenizer.save_pretrained(f"{OUTPUT_DIR}_merged")

```


example internet sample

`{"instruction": "Provide a minimal C snippet that demonstrates the POSIX mmap() usage with proper error handling.", "input": "", "output": "#include <stdio.h>\n#include <stdlib.h>\n#include <sys/mman.h>\n#include <sys/stat.h>\n#include <fcntl.h>\n#include <unistd.h>\n\nint main() {\n    int fd = open(\"example.txt\", O_RDWR | O_CREAT, 0644);\n    if (fd == -1) { perror(\"open\"); exit(1); }\n    off_t sz = 4096;\n    if (ftruncate(fd, sz) == -1) { perror(\"ftruncate\"); close(fd); exit(1); }\n    char *map = mmap(NULL, sz, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);\n    if (map == MAP_FAILED) { perror(\"mmap\"); close(fd); exit(1); }\n    munmap(map, sz);\n    close(fd);\n    return 0;\n}"}`


