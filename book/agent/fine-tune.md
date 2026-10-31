
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


