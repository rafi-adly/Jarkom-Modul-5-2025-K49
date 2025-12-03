# Jalankan di Osgiliath
route add -net 10.88.0.0/24 gw 10.88.2.218     
route add -net 10.88.2.0/25 gw 10.88.2.218      
route add -net 10.88.2.128/26 gw 10.88.2.210   
route add -net 10.88.2.192/29 gw 10.88.2.210    
route add -net 10.88.2.200/29 gw 10.88.2.214    
route add -net 10.88.2.224/30 gw 10.88.2.210   
route add -net 10.88.2.244/30 gw 10.88.2.218    

# Route antar router
route add -net 10.88.2.220/30 gw 10.88.2.210    
route add -net 10.88.2.240/30 gw 10.88.2.218    
route add -net 10.88.2.248/30 gw 10.88.2.218   
route add -net 10.88.2.252/30 gw 10.88.2.218
route add -net 10.88.2.232/30 gw 10.88.2.214  

echo "Routing configured!"
