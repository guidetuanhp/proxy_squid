az group create -n mywestus3 -l westus3
az vm create \
    --resource-group mywestus3 \
    --name mywestus3 \
    --public-ip-address myipwestus30 \
    --image Canonical:UbuntuServer:18.04-LTS:latest \
    --size Standard_B1s \
    --admin-username guide \
    --admin-password Tuanhpvnu@123\
    --authentication-type all \
    --generate-ssh-keys
echo "create vm done"
echo "done"
sleep 5
az vm open-port --ids $(az vm list -g mywestus3 --query "[].id" -o tsv) --port '*' 
echo " open port done"

for i in `seq 1 9`;
        do
az network public-ip create -g mywestus3 -n myipwestus3$i
	az network nic ip-config create \
  	--resource-group mywestus3 \
  	--nic-name mywestus3VMNic\
  	--name ipconfigmywestus3$i \
  	--public-ip-address myipwestus3$i
	done
echo "create ip done"
echo "done"

for i in $(az vm list -g mywestus3 --query "[].name" -o tsv); do
	az vm run-command invoke -g mywestus3 -n $i --command-id RunShellScript --scripts "wget https://raw.githubusercontent.com/guidetuanhp/proxy/main/edit_network.sh && sudo bash edit_network.sh"
	done
echo "done"

for i in $(az network public-ip list -g mywestus3 --query "[].ipAddress" -o tsv); do
echo $i:2610 >> westus3.txt
echo $i
done
echo "show ip"
URL=$(curl -s --upload-file westus3.txt https://transfer.sh/)
echo $URL
echo "done"
