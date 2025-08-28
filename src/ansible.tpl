[webservers]
%{ for instance in webservers ~}
${instance.name} ansible_host=${instance.external_ip} fqdn=${instance.fqdn}
%{ endfor ~}

[databases]
%{ for instance in databases ~}
${instance.name} ansible_host=${instance.external_ip} fqdn=${instance.fqdn}
%{ endfor ~}

[storage]
%{ for instance in storage ~}
${instance.name} ansible_host=${instance.external_ip} fqdn=${instance.fqdn}
%{ endfor ~}
