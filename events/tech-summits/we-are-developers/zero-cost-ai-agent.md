https://github.com/nkthakur48/duck-norris
Nishant Kumar Thakur
Senior Computer Scientist | Adobe

Aishwarya Mathuria
Computer Scientist 2 | Adobe

Zero cost AI agent

Hugging face - open source 


model - voice (chat+streaming) + sys prompt + mem + char UI + hands (tools) + home (github pages)


Web GL past-> evolves-> webGpu (browser APi for GPU) (vulcan/metal)

Gemma2b - MLC (4 bit)


## check
chrome://gpu/

https://webgpureport.org/
is fallback to false

Live server - vs code


or `http-server .`


### exercise

```
import { CreateMLCEngine } from
  "../vendor/web-llm-local.js";

const engine = await CreateMLCEngine(
  "gemma-2-2b-it-q4f16_1-MLC", {
    initProgressCallback: ({ text }) => {
      statusEl.textContent = text;
    }
  }
);
statusEl.textContent = "Model ready!";
```
(Machine Learning Compilation for Large Language Models), 4-bit quantization (such as q4f16_1) compresses model weights to 4 bits while typically running activations/runtime in FP16 to cut memory use and speed up local inference on GPUs, browsers, and mobile devices


------


```
const response =
        await engine.chat.completions.create({
          messages: [{ role: "user", content: userText }],
          stream: true, 
        });
        let reply = "";
        for await (const chunk of chunks) { 
          reply += chunk.choices[0]?.delta.content || "";
          outputEl.textContent = reply;    // words appear as they are made
        }
        // if stream is false
      // outputEl.textContent =
      //   response.choices[0].message.content;
```


Set boundaries, be specific, Show the shape you want

You ask
a question
→
Model
"I need to look this up"
→
[TOOL weather "Tokyo"]
it writes a marker
→
Your code
runs fetch()
→
Model
answers from the result


phasers js game engine

Small L2

github.com/mlc-api/web-llm


better to use webworker

web-mcp



## Qs
- how did you add model to git (lfs?)-  - Karan - it is sharrding/ multiplexing - split model to 42 fragments. 4 gets downloaded parallelly - web mlc - split and combine
- Why not choose - Ollama - Karan - becaus eit is for backend
- Is Blazor/WASM another way to access the machine resources? - Karan - wasm is being used
- best practices - to hide Serp api type of API_key in javascript -or should we make express js type of backend?
- What are some RAG techniques - use Vercel react? use index db - index db supports semantic search