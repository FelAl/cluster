1. настройка вагрант для подключения к qemu +
2. удаление созданных мной моих виртуалок руками в virt manager +
3. делаю один репозиторий для мастера и агента, в них пропишу начальные настройки виртуалок, 6 и 12 гигов, названия. на основе официального шаблона centos 7 minimal +
4. Делаю два vagrant up и вижу две виртуалки в virt manager +
  a) http://www.lucainvernizzi.net/blog/2014/12/03/vagrant-and-libvirt-kvm-qemu-setting-up-boxes-the-easy-way/

5. запуск мастера и настрока на нём амбари сервера(подключение vagrant ssh) +

**** https://docs.hortonworks.com/HDPDocuments/Ambari-2.2.0.0/bk_Installing_HDP_AMB/content/_set_up_the_ambari_server.html


```sh
[root@aserv ambari-server]# cat /etc/hostname
fed
[root@aserv ambari-server]# cat /etc/hosts
127.0.0.1   fed.ambari.server fed
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
127.0.1.1  fed.ambari.server fed
192.168.121.252 fed.ambari.agent
[root@aserv ambari-server]# 
```







  a) https://ambari.apache.org/1.2.0/installing-hadoop-using-ambari/content/ambari-chap1-4.html

```
hortonwork создаёт репозиторий в котором содержится почти всё что надо для их дистрибутива хадупа. в том числе и амбари
я это уже понял и сказал что старое
https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Deployment_Guide/sec-Configuring_Yum_and_Yum_Repositories.html
вот доки по хортонворксу https://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.3.2/index.html
там есть почти всё
в том числе и о амбари
https://docs.hortonworks.com/HDPDocuments/Ambari-2.1.2.1/bk_Installing_HDP_AMB/content/index.html
а вот о репках рпм https://docs.hortonworks.com/HDPDocuments/Ambari-2.1.2.1/bk_Installing_HDP_AMB/content/_download_the_ambari_repo_lnx7.html
```

`и внимательно - hdp 2.3.0 или старше`


```
кой какую картинку сложат, а дальше уже будем детально разбирать
особенно это посмотрите http://hortonworks.com/hdp/whats-new/
я постоянно в плане версия сверяюсь
```


Амбари сервес, бд
`
Enter choice (1): 1
Database name (ambari): 
Postgres schema (ambari): 
Username (ambari): 
Enter Database Password (bigdata): 
Default properties detected. Using built-in database.
Configuring ambari database...
`
6. запуск агента - и настройка его руками +

 ****  http://docs.hortonworks.com/HDPDocuments/Ambari-2.2.0.0/bk_ambari_reference_guide/content/_install_the_ambari_agents_manually.html


   a) http://www.slideshare.net/hortonworks/ambari-agentregistrationflow-17041261
   https://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.3.2/bk_installing_manually_book/content/prepare-environment.html#ref-2822d0e9-bd88-4714-910a-750c5b95a996


   настройка fqdn(делается и на агенте и на сервере)
   http://sharadchhetri.com/2014/09/27/set-hostname-fqdn-centos-7-rhel-7/
   http://askubuntu.com/questions/158957/how-to-set-the-fully-qualified-domain-name-in-12-04



7. агент подключается к мастеру +

```sh
[root@age vagrant]# cat /etc/hostname
fed
[root@age vagrant]#


[root@age vagrant]# cat /etc/hosts
127.0.0.1   age localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
127.0.1.1   fed.ambari.agent fed
192.168.121.229 fed.ambari.server
[root@age vagrant]# 
```

http://askubuntu.com/questions/158957/how-to-set-the-fully-qualified-domain-name-in-12-04


Cамая свежая документация
https://docs.hortonworks.com/index.html



На агенте, после регистрация появляется предупреждение об ntpd
```sh
[root@age vagrant]# yum install ntp
systemctl start ntpd
```
Убирает warning, почитать зачем это вообще???



8. руками настраивается хадуп кластер, запускается +
   а) https://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.3.2/bk_installing_manually_book/content/prepare-environment.html#ref-2822d0e9-bd88-4714-910a-750c5b95a996


читайте сегодня доки
заодно и это https://cwiki.apache.org/confluence/display/AMBARI/Blueprints
тоже пошагово и тоже указано что агенты до блупринтов


https://cwiki.apache.org/confluence/display/AMBARI/Ambari+Design
вникайте как работает амбари
поиграйтесь с https://cwiki.apache.org/confluence/display/AMBARI/Ambari+Shell
это ваши задачи до того как вернуться к основному
по амбари шелл я задач пару вопросов которые сразу покажут работали с ним или нет



9. скачивание blueprint файла +

blueprints list
curl  -u admin:admin http://localhost:8080/api/v1/blueprints


get blueprint
curl  -u admin:admin http://a7cc93d5.ngrok.io/api/v1/clusters/test?format=blueprint

Загрузка blueprint файла
curl  -i -H "X-Requested-By: ambari" --data "@/home/alfe/mkdev/bigdata/cluster/testblueprint.json" -u admin:admin -X POST http://a7cc93d5.ngrok.io/api/v1/blueprints/testblueprint

curl  -i -H "X-Requested-By: ambari" --data "@/home/vagrant/testblueprint.json" -u admin:admin -X POST http://localhost:8080/api/v1/blueprints/testblueprint


10. пересоздание виртуалок, но создание кластера с помощью блупринт файла +


curl  -i -H "X-Requested-By: ambari" --data "@/home/vagrant/creationtempl.json" -u admin:admin -X POST http://localhost:8080/api/v1/clusters/test






11. перенос знаний в шеф и вагрант и реализация всего за две команды +

`важный момент - агент должен быть подключен к мастеру до загрузки блупринт файла, многие долго до этого доходят`

```
чуть что не понятно - читайте доки, непонятно после доков или непонятно что читать или "непонятные ошибки" - сразу пишите
```



```sh
alfe@rt:~$ ifconfig | sed -n 2p | cut -d ":" -f 2 | cut -d " " -f 1
192.168.0.106
```

12. Chef
http://reiddraper.com/first-chef-recipe/
   a) установка yum через chef
   b) тимплейты файлов через chef
   




13. Port forwarding. До того как порты добавились нормально с `vagrant up`

```
[root@CentOS-71-64-minimal qemu]# cat cluster_ambari_agent.xml 
<!--
WARNING: THIS IS AN AUTO-GENERATED FILE. CHANGES TO IT ARE LIKELY TO BE
OVERWRITTEN AND LOST. Changes to this xml configuration should be made using:
  virsh edit cluster_ambari_agent
or other application using the libvirt API.
-->

<domain type='kvm'>
  <name>cluster_ambari_agent</name>
  <uuid>7576904e-c09c-45bd-8b11-2d1f04998a69</uuid>
  <memory unit='KiB'>12288000</memory>
  <currentMemory unit='KiB'>12288000</currentMemory>
  <vcpu placement='static'>2</vcpu>
  <os>
    <type arch='x86_64' machine='pc-i440fx-rhel7.0.0'>hvm</type>
    <boot dev='hd'/>
  </os>
  <features>
    <acpi/>
    <apic/>
    <pae/>
  </features>
  <cpu mode='host-model'>
    <model fallback='allow'>qemu64</model>
  </cpu>
  <clock offset='utc'/>
  <on_poweroff>destroy</on_poweroff>
  <on_reboot>restart</on_reboot>
  <on_crash>destroy</on_crash>
  <devices>
    <emulator>/usr/libexec/qemu-kvm</emulator>
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2'/>
      <source file='/var/lib/libvirt/images/cluster_ambari_agent.img'/>
      <target dev='vda' bus='sata'/>
      <address type='drive' controller='0' bus='0' target='0' unit='0'/>
    </disk>
    <controller type='usb' index='0'>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x2'/>
    </controller>
    <controller type='pci' index='0' model='pci-root'/>
    <controller type='sata' index='0'>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0'/>
    </controller>
    <interface type='network'>
      <mac address='52:54:00:ea:2e:db'/>
      <source network='vagrant-libvirt'/>
      <model type='virtio'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x05' function='0x0'/>
    </interface>
    <interface type='network'>
      <mac address='52:54:00:29:9b:f8'/>
      <source network='cluster0'/>
      <model type='virtio'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x06' function='0x0'/>
    </interface>
    <serial type='pty'>
      <target port='0'/>
    </serial>
    <console type='pty'>
      <target type='serial' port='0'/>
    </console>
    <input type='mouse' bus='ps2'/>
    <input type='keyboard' bus='ps2'/>
    <graphics type='vnc' port='-1' autoport='yes' listen='127.0.0.1' keymap='en-us'>
      <listen type='address' address='127.0.0.1'/>
    </graphics>
    <video>
      <model type='cirrus' vram='16384' heads='1'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x0'/>
    </video>
    <memballoon model='virtio'>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x04' function='0x0'/>
    </memballoon>
  </devices>
</domain>
```