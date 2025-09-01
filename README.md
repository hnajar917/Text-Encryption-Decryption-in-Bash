# 🔐 Text Encryption & Decryption in Bash  

## 📌 Overview  
This project is a **Linux shell script** that implements a **custom text encryption and decryption mechanism** using bitwise operations, ASCII manipulation, and file handling.  
It was developed as part of a university project to demonstrate **Linux scripting, process control, and security fundamentals**.  

---

## 🚀 Features  
- ✅ **Input Validation** – accepts only alphabetical characters (A–Z, a–z).  
- 🔄 **Encryption Process**:  
  - Converts characters to ASCII values.  
  - Translates decimal → binary.  
  - Applies **XOR encryption** with a generated key.  
  - Performs a **4-bit swap** for additional obfuscation.  
  - Saves result in a cipher text file.  
- 🔓 **Decryption Process**:  
  - Reverses XOR and bit swapping.  
  - Converts binary back to ASCII.  
  - Restores original plain text.  
- 📂 **File Handling** – uses multiple temp files for each transformation step.  
- 🖥️ **Technologies**: Bash, Linux utilities (`tr`, `sed`, `awk`, `bc`).  

---

## ⚙️ Usage  
1. Clone repository:  
   ```bash
   git clone https://github.com/yourusername/text-encryption-bash.git
   cd text-encryption-bash
   chmod +x encrypt_decrypt.sh
   ```

2. Run the program:  
   ```bash
   ./encrypt_decrypt.sh
   ```

3. Follow the menu:  
   - Enter plain text → generate cipher text.  
   - Decrypt cipher text → restore original text.  

---

## 🧑‍💻 Example  

**Plaintext Input:**  
```
HELLO
```

**Cipher Text (binary form):**  
```
01001100 11001010 ...
```

**Decrypted Output:**  
```
HELLO
```

---

## 🎯 Learning Outcomes  
- Mastered **Bash scripting & process automation**.  
- Gained experience with **binary/decimal conversions** and **XOR encryption**.  
- Learned **file handling & text manipulation** in Linux.  
- Built an end-to-end **encryption/decryption system** without external libraries.  

---
