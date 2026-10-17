
## quantum internet?

The quantum internet is envisioned as a global network that leverages quantum entanglement and quantum states to transmit information securely and efficiently.
Unlike the conventional internet that relies on classical bits (0s and 1s), a quantum internet distributes non-classical correlations (entanglement) and quantum states across vast distances. A practical definition provided by the text is a network that offers network-accessible primitives such as "entanglement as a service" (delivering Bell pairs between nodes with a specified fidelity and rate) to enable secure key establishment, quantum clock synchronization, and distributed quantum computing.

Entanglement Distribution Across Networks

Entanglement creates strong correlations between measurements that cannot be explained by classical physics. While these correlations cannot be used for faster-than-light communication on their own, they become highly useful when combined with classical communication.
• The Infrastructure: Entanglement distribution is achieved through various mediums, including photon transmission over optical fibers and satellite links.
• The Challenge: Quantum states are inherently fragile. Maintaining their integrity over long distances remains a key challenge due to environmental interactions. In fiber links, transmission is limited by attenuation and noise, while free-space and satellite links must contend with pointing errors, atmospheric turbulence, and background light.

Quantum Repeaters and Network Security

Because quantum signals cannot be perfectly copied or amplified without destroying the state (due to the no-cloning theorem), traditional classical amplifiers cannot be used to extend signal ranges.
• Quantum Repeaters: These are specialized quantum devices designed to overcome attenuation and decoherence. They extend the range of entanglement distribution and facilitate quantum error correction.
• Two Main Categories:
	1. Purification-based repeaters: These trade additional entanglement attempts for higher fidelity via distillation.
	2. Error-corrected repeaters: These encode local qubits to tolerate loss and operational errors at the cost of requiring a significantly higher qubit overhead.
Choosing the right design depends heavily on the target distance, required performance metrics, and available hardware capabilities.