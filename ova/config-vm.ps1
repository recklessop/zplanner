$vm_ip = $ENV:vm_ip
Write-Output $vm_ip

ssh -i .ssh\id_rsa.pub zplanner@$vm_ip "sudo apt update; sudo apt upgrade -y;"
ssh -i .ssh\id_rsa.pub zplanner@$vm_ip  "git clone https://github.com/recklessop/zplanner.git; cd unifi-va; sudo bash /home/zplanner/zplanner/ova/install.sh"
