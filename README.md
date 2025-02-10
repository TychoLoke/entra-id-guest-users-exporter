# 🚀 Entra ID Guest Users Exporter  

This **PowerShell script**, authored by **[Tycho Löke](https://github.com/TychoLoke)**, automates the process of exporting detailed information about **guest users** from **Microsoft Entra ID** using the **Microsoft Graph API**.  

The results are saved to a **CSV file**, making it easy to analyze guest user activity, including account creation and login details.

---

## 📌 Features  
✅ **Automated Guest User Retrieval** – Fetches all guest users from Entra ID (`userType eq 'Guest'`).  
✅ **Sign-In Activity Tracking** – Includes last login date and days since the last login.  
✅ **Account Creation Insights** – Tracks account creation date and days since creation (if the user never logged in).  
✅ **Clean CSV Output** – Handles special characters (e.g., commas in names or emails) and ensures consistent formatting.  
✅ **Customizable Export Path** – Prompts users to choose where to save the exported file.  
✅ **Real-Time Updates** – Displays progress and logs activities as they happen.  
✅ **Error Handling** – Skips users with inaccessible data and logs warnings without interrupting the script.  

---

## 🛠 Prerequisites  

Before running the script, ensure you meet the following requirements:  

- **Microsoft Entra ID (formerly Azure AD)** – Your account must be linked to an Entra ID tenant.  
- **Admin Role** – Requires **User.Read.All** or higher permissions in Entra ID.  
- **Microsoft Graph PowerShell Module** – Installed automatically by the script if missing.  
- **PowerShell Execution Policy** – Must allow script execution (`Set-ExecutionPolicy RemoteSigned`).  

---

## 🚀 How to Use  

### **1️⃣ Download the Script**  
Clone this repository or download the script file manually.  

```powershell
git clone https://github.com/TychoLoke/entra-id-guest-users-exporter.git
cd entra-id-guest-users-exporter
```

### **2️⃣ Run PowerShell as Administrator**  
- Open **PowerShell** with elevated permissions (`Run as Administrator`).  

### **3️⃣ Execute the Script**  
Run the script using:  

```powershell
.\Export-EntraID-GuestUsers.ps1
```

### **4️⃣ Authenticate with Microsoft Graph**  
- A **pop-up login window** will appear.  
- Sign in with your **Global Admin** or **User Administrator** credentials.

### **5️⃣ What Happens Next?**  
✅ The script **checks for required modules** and installs them if missing.  
✅ It **connects to Microsoft Graph** via pop-up login.  
✅ Retrieves **all guest users** and gathers detailed account and login data.  
✅ Saves the report to the user-selected file path (e.g., `C:\Temp\GuestUsers.csv`).  

---

## 🔎 Notes  
- The script uses **`Microsoft.Graph.Users`** instead of the full Microsoft Graph module to optimize performance.  
- It provides **progress updates** for long-running operations.  
- The default export location can be customized by selecting a folder when prompted.  

---

## 🛠 Troubleshooting  

### ❌ Module Not Found?  
Ensure you have an internet connection and sufficient permissions to install the `Microsoft.Graph` module.  

```powershell
Install-Module Microsoft.Graph -Scope CurrentUser
```

### ❌ Script Fails to Authenticate?  
Verify your account has **Global Admin** or **User Administrator** privileges.  

### ❌ Script Hangs or Freezes?  
If processing thousands of guest users, allow the script time to complete. Progress is displayed in the PowerShell window.  

---

## 🤝 Contributing  

Want to improve this script? Contributions are welcome!  

**To contribute:**  
1. **Fork** the repository.  
2. **Create a feature branch** (`git checkout -b feature-name`).  
3. **Submit a Pull Request** with your changes.  

---

## 📜 License  

This project is licensed under the **MIT License** – feel free to use, modify, and distribute it.  

---

## 🔗 Author  

**Tycho Löke**  
GitHub: [TychoLoke](https://github.com/TychoLoke)

---

## 📋 Change Log  

### **v1.0.0** (February 2025)  
- Initial release of the script:
  - Fetches all guest users from Entra ID.
  - Exports details including account creation date, last login, and days since login/creation.
  - Supports progress updates and error handling.
