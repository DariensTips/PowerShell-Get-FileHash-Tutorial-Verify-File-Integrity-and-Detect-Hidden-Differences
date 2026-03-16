# PowerShell-Get-FileHash-Tutorial-Verify-File-Integrity-and-Detect-Hidden-Differences
https://www.youtube.com/watch?v=Cw2YXEqpaS8
==========
# PowerShell Get-FileHash Tutorial

Use PowerShell `Get-FileHash` to verify file integrity, compare files by their byte-level contents, validate copied files, inspect encoding differences, and hash strings by using an input stream.

This walkthrough demonstrates why file name, file size, timestamps, and even visual diffs can sometimes be misleading when determining whether two files are truly identical.

---

## What this covers

- Compare file properties and visible text measurements
- Show why timestamps and metadata are unreliable
- Compute file hashes with `Get-FileHash`
- Confirm whether a copied file matches the source
- Inspect raw file bytes with `Format-Hex`
- Review available hash algorithms
- Compare SHA1, SHA256, SHA384, SHA512, and MD5
- Hash a string by using `-InputStream`

---

## Requirements

- Windows PowerShell 5.1 or PowerShell 7+
- Windows system for the Windows examples
- Optional: WSL or Linux shell for the `touch` / `stat` examples
- Optional: VS Code with the Hex Editor extension for visual encoding comparisons

---

## Why `Get-FileHash` matters

Two files can appear identical at first glance:

- same file name
- same file size
- same timestamps
- same line count
- same character count

And yet still be different.

`Get-FileHash` solves this by computing a cryptographic hash from the file's raw bytes. If the hash values match, the file contents match. If the hash values differ, something in the underlying bytes is different.

---
