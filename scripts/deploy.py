import subprocess
import platform
import os
import sys
import argparse

class Installer:
    def __init__(self):
        self.os_name = platform.system().lower()
    
    ### Helper method to run command in ther terminal ###
    def run_shell_command(self, command, check=False, shell=True):
        try:
            return subprocess.run(command, check=check, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, shell=shell)
        except subprocess.CalledProcessError as e:
            print(f"Error executing command: {e.cmd}")
            print(e.stderr)
            return None
    ### Helper method to check if a command is installed ###
    def is_installed(self, command):
        result = self.run_shell_command(f"command -v {command}" if self.os_name != "windows" else f"where {command}")
        return result and result.returncode == 0
    
    ### Method to install AWS CLI ###
    def install_aws_cli(self):
        if not self.is_installed("aws"):
            print("Installing AWS CLI...")
            if self.os_name == "darwin":
                self.run_shell_command('curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"')
                self.run_shell_command('sudo installer -pkg AWSCLIV2.pkg -target /')
            elif self.os_name == "windows":
                self.run_shell_command('msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi')
            elif self.os_name == "linux":
                self.run_shell_command('curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"')
                self.run_shell_command('unzip awscliv2.zip')
                self.run_shell_command('sudo ./aws/install')
        else:
            print("AWS CLI is already installed.")
    ### Method to install Terraform ###
    def install_terraform(self):
        if not self.is_installed("terraform"):
            print("Installing Terraform...")
            if self.os_name == "darwin":
                self.run_shell_command('curl -O https://releases.hashicorp.com/terraform/0.14.6/terraform_0.14.6_darwin_amd64.zip')
                self.run_shell_command('unzip terraform_0.14.6_darwin_amd64.zip')
                self.run_shell_command('sudo mv terraform /usr/local/bin/')
            elif self.os_name == "windows":
                self.run_shell_command('curl -O https://releases.hashicorp.com/terraform/0.14.6/terraform_0.14.6_windows_amd64.zip')
                self.run_shell_command('tar -xf terraform_0.14.6_windows_amd64.zip -C "C:\\Program Files"')
            elif self.os_name == "linux":
                self.run_shell_command('curl -O https://releases.hashicorp.com/terraform/0.14.6/terraform_0.14.6_linux_amd64.zip')
                self.run_shell_command('unzip terraform_0.14.6_linux_amd64.zip')
                self.run_shell_command('sudo mv terraform /usr/local/bin/')
        else:
            print("Terraform is already installed.")
    ### Method to install Terragrunt ###
    def install_terragrunt(self):
        if not self.is_installed("terragrunt"):
            print("Installing Terragrunt...")
            if self.os_name == "darwin":
                self.run_shell_command('brew install terragrunt')
            elif self.os_name == "windows":
                self.run_shell_command('choco install terragrunt')
            elif self.os_name == "linux":
                self.run_shell_command('wget -O terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v0.28.7/terragrunt_linux_amd64')
                self.run_shell_command('chmod +x terragrunt')
                self.run_shell_command('sudo mv terragrunt /usr/local/bin/')
        else:
            print("Terragrunt is already installed.")
    ### Method to run 'terragrunt apply --auto-approve' in the specified directories ###
    def run_terragrunt_apply(self, directories):
        """Runs 'terragrunt apply --auto-approve' in the specified directories."""
        original_directory = os.getcwd()
        for directory in directories:
            try:
                os.chdir(original_directory)
                os.chdir(directory)
                print(f"Applying Terragrunt configurations in {directory}...")
                result = subprocess.run(['terragrunt', 'apply', '--auto-approve'], check=True, capture_output=True, text=True)
                print(result.stdout)
            except subprocess.CalledProcessError as e:
                print(f"Error applying Terragrunt configurations in {directory}: {e.stderr}")
            except Exception as e:
                print(f"An error occurred: {e}")
            finally:
                os.chdir(original_directory)

def main():
    installer = Installer()
    installer.install_aws_cli()
    installer.install_terraform()
    installer.install_terragrunt()
    directories = ['terraform/environments/dev', 'terraform/environments/prod']
    installer.run_terragrunt_apply(directories)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-v", "--version", action="store_true", help="Prints the version")
    args = parser.parse_args()
    if args.version:
        print("Version 0.1")
    if 'TF_VAR_ECHO_TEXT' not in os.environ:
        print("Please define the TF_VAR_ECHO_TEXT environment variable.")
        sys.exit(1)
    main()