az group create -n westus3 -l westus3
az vm create \
    --resource-group westus3 \
    --name westus30\
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
az vm open-port --ids $(az vm list -g westus3 --query "[].id" -o tsv) --port '*' 
echo " open port done"

az network public-ip create -g westus3 -n myipwestus31 &
az network public-ip create -g westus3 -n myipwestus32 & 
az network public-ip create -g westus3 -n myipwestus33 &
az network public-ip create -g westus3 -n myipwestus34 & 
az network public-ip create -g westus3 -n myipwestus35 &
az network public-ip create -g westus3 -n myipwestus36 &
az network public-ip create -g westus3 -n myipwestus37 & 
az network public-ip create -g westus3 -n myipwestus38 & 
az network public-ip create -g westus3 -n myipwestus39

echo "create ip done"
echo "done"
sleep 5
for i in `seq 1 9`;
        do
	az network nic ip-config create --name ipconfigwestus3$i --nic-name westus30VMNic --public-ip-address myipwestus3$i --resource-group westus3
	done

echo "create ip config done"
echo "done"

for i in $(az vm list -g westus3 --query "[].name" -o tsv); do
	az vm run-command invoke -g westus3 -n $i --command-id RunShellScript --scripts "wget https://raw.githubusercontent.com/guidetuanhp/proxy/main/edit_network.sh && sudo bash edit_network.sh"
	done
echo "done"

for i in $(az network public-ip list -g westus3 --query "[].ipAddress" -o tsv); do
echo $i:2610 >> westus3.txt
echo $i
done
echo "show ip"
URL=$(curl -s --upload-file westus3.txt https://transfer.sh/)
echo $URL
echo "done"
