## Prerequisites
Administrative (root or sudo) privileges on the Linux system.

Internet access to Microsoft repositories:
https://packages.microsoft.com/config/

Access to Microsoft 365 Defender portal to download onboarding package.

## Step 1: Download Installer Script
Microsoft provides an official installation script for Linux Defender.

wget https://github.com/microsoft/mdatp-xplat/raw/master/linux/installation/mde_installer.sh
chmod +x mde_installer.sh
## Step 2: Download Onboarding Package
Log in to the Microsoft 365 Defender portal: https://security.microsoft.com.

Navigate to:

Settings > Endpoints > Device management > Onboarding
Select Linux Server as the platform.

Download the onboarding package (a .zip file).

Transfer the package to the target Linux system and unzip it:

unzip MicrosoftDefenderATPOnboardingPackage.zip
This will extract a Python script, typically named:

MicrosoftDefenderATPOnboardingLinuxServer.py
## Step 3: Install and Onboard
Run the installer script with onboarding included:

sudo ./mde_installer.sh --install --onboard ./MicrosoftDefenderATPOnboardingLinuxServer.py --channel prod
--install → installs Microsoft Defender for Endpoint

--onboard → uses the onboarding script provided by Microsoft

--channel prod → ensures the stable (production) update channel is used

## Step 4: Verify Installation
After installation, verify Defender is running:

mdatp health
You should see output indicating the product is healthy and onboarded.

Notes
The script automatically configures Microsoft repositories.

Microsoft repositories are available here:
https://packages.microsoft.com/config/

Supported Linux distributions and dependencies are listed in Microsoft documentation.

## References
[Microsoft Defender for Endpoint on Linux – Installer Script](https://learn.microsoft.com/en-us/defender-endpoint/linux-installer-script)

[Microsoft Linux Packages Repository](https://learn.microsoft.com/en-us/linux/packages)
