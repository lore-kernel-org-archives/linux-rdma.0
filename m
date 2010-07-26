From: Tom Ammon <tom.ammon-wbocuHtxKic@public.gmane.org>
Subject: Re: more partition questions
Date: Mon, 26 Jul 2010 11:44:19 -0600
Message-ID: <4C4DC973.7090006@utah.edu>
References: <4C448DCD.80809@utah.edu>	<AANLkTikDh5Em28cj9WSy2nNC-vrcZe4MwFHOYt9OmeuU@mail.gmail.com>	<4C487D8F.80203@utah.edu>	<AANLkTinqUs3CHKW42SWUVdqLr3vX-ixMc4M8u2ZRnQfr@mail.gmail.com>	<4C48AECB.9010008@utah.edu> <AANLkTim9BGa-eFxff2yVd4MTdL_Ahx-_g69ATkEa-lmn@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTim9BGa-eFxff2yVd4MTdL_Ahx-_g69ATkEa-lmn-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hal,

On 7/22/2010 6:08 PM, Hal Rosenstock wrote:
> Tom,
>
> On Thu, Jul 22, 2010 at 4:49 PM, Tom Ammon<tom.ammon-wbocuHtxKic@public.gmane.org>  wrote:
>> Hal,
>>
>> Thanks for looking at all of this with me. ifconfig output is below.
>>
>> On 7/22/2010 12:08 PM, Hal Rosenstock wrote:
>>>
>>> Tom,
>>>
>>> On Thu, Jul 22, 2010 at 1:19 PM, Tom Ammon<tom.ammon-wbocuHtxKic@public.gmane.org>    wrote:
>>>>
>>>> Hal,
>>>>
>>>> On 7/21/2010 2:45 PM, Hal Rosenstock wrote:
>>>>>
>>>>> Hi Tom,
>>>>>
>>>>> On 7/19/10, Tom Ammon<tom.ammon-wbocuHtxKic@public.gmane.org>      wrote:
>>>>>>
>>>>>> I'm trying to set up partitions in a little test environment, and I'm
>>>>>> having trouble.
>>>>>>
>>>>>> I have opensm running on a machine attached to the fabric, and sminfo
>>>>>> on
>>>>>> the other machines confirm that this is indeed the master SM. Here's my
>>>>>> /etc/opensm/partitions.conf:
>>>>>>
>>>>>> Default=0xffff , ipoib : ALL, SELF=full ;
>>>>>> PartitionBlue=0x8004, ipoib : 0x0002c9030009cb3f=full,
>>>>>> 0x0002c90200252841=full, 0x0002c90200243471=full ;
>>>>>> PartitionRed=0x8005, ipoib : 0x0002c90200252841=full,
>>>>>> 0x0002c90200243591=full, 0x0002c9030009cb2b=full ;
>>>>>
>>>>> You don't really need the 0x8000 bit on in the pkeys but I don't think
>>>>> it does any harm.
>>>>>
>>>>>> But when I go to the machine with port GUID 0x0002c90200243471, it
>>>>>> doesn't appear that it's getting the pkey I wanted:
>>>>>>
>>>>>> [root@stagnate ~]# ibstat
>>>>>> CA 'mthca0'
>>>>>>           CA type: MT23108
>>>>>>           Number of ports: 2
>>>>>>           Firmware version: 3.3.5
>>>>>>           Hardware version: a1
>>>>>>           Node GUID: 0x0002c90200243470
>>>>>>           System image GUID: 0x0002c90200243473
>>>>>>           Port 1:
>>>>>>                   State: Active
>>>>>>                   Physical state: LinkUp
>>>>>>                   Rate: 10
>>>>>>                   Base lid: 10
>>>>>>                   LMC: 0
>>>>>>                   SM lid: 4
>>>>>>                   Capability mask: 0x02510a68
>>>>>>                   Port GUID: 0x0002c90200243471
>>>>>>           Port 2:
>>>>>>                   State: Down
>>>>>>                   Physical state: Polling
>>>>>>                   Rate: 2
>>>>>>                   Base lid: 0
>>>>>>                   LMC: 0
>>>>>>                   SM lid: 0
>>>>>>                   Capability mask: 0x02510a68
>>>>>>                   Port GUID: 0x0002c90200243472
>>>>>>
>>>>>> [root@stagnate ~]# cat /sys/class/net/ib0/pkey
>>>>>> 0xffff
>>>>>
>>>>> What does:
>>>>>
>>>>> smpquery pkeys 10 1
>>>>>
>>>>> say ? Do you see the other pkey(s) on that port ?
>>>>
>>>> [root@stagnate ~]# smpquery pkeys 10 1
>>>>    0: 0x7fff 0x8004 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>>>    8: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>>>   16: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>>>   24: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>>>   32: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>>>   40: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>>>   48: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>>>   56: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>>> 64 pkeys capacity for this port
>>>>
>>>> So I see that both 7fff and 8004 are being assigned to this port. Is that
>>>> okay?
>>>
>>> Yes.
>>>
>>>>   Is there any problem with the machine also being in the default
>>>> partition?
>>>
>>> No.
>>>
>>>> As I look around at all of the machines with smpquery, it appears that
>>>> they
>>>> are all being assigned 7fff and the pkey that I assigned in
>>>> partitions.conf.
>>>
>>> Good.
>>>
>>>> But the machine that I want to run 2 child interfaces on is having
>>>> issues.
>>>> It's at LID 7 and here's what smpquery says:
>>>>
>>>> [root@stagnate ~]# smpquery pkeys 7 1
>>>>    0: 0x7fff 0x8004 0x8005 0x0000 0x0000 0x0000 0x0000 0x0000
>>>>    8: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>>>   16: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>>>   24: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>>>   32: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>>>   40: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>>>   48: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>>>   56: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>>> 64 pkeys capacity for this port
>>>>
>>>> So that's fine, but when I try to create a child interface I get this:
>>>>
>>>> [root@labdisk01 ~]# echo 0x8004>    /sys/class/net/ib0/create_child
>>>> -bash: echo: write error: Name not unique on network
>>>
>>> I don't know what cause that error. Maybe someone else can help here.
>>>
>>> Are you sure the ib0 interface is OK ? What does ifconfig ib0 say ?
>>
>> Here's ifconfig ib0:
>>
>> ib0       Link encap:InfiniBand  HWaddr
>> 80:00:04:04:FE:80:00:00:00:00:00:00:00:00:00:00:00:00:00:00
>>           inet6 addr: fe80::202:c902:25:2841/64 Scope:Link
>>           UP BROADCAST RUNNING MULTICAST  MTU:65520  Metric:1
>>           RX packets:1 errors:0 dropped:0 overruns:0 frame:0
>>           TX packets:17 errors:0 dropped:7 overruns:0 carrier:0
>>           collisions:0 txqueuelen:256
>>           RX bytes:56 (56.0 b)  TX bytes:3529 (3.4 KiB)
>>
>>
>> Then I brought up the "sub"interfaces with "ifup ib0.8004" "ifup ib0.8005" .
>> Still get the "Name not unique on network" message if I switch the order and
>> do ifup followed by echo 0x8004....etc.
>>
>> ib0.8004  Link encap:InfiniBand  HWaddr
>> 80:00:04:06:FE:80:00:00:00:00:00:00:00:00:00:00:00:00:00:00
>>           inet addr:10.0.0.2  Bcast:10.0.0.255  Mask:255.255.255.0
>>           inet6 addr: fe80::202:c902:25:2841/64 Scope:Link
>>           UP BROADCAST RUNNING MULTICAST  MTU:65520  Metric:1
>>           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
>>           TX packets:78 errors:0 dropped:17 overruns:0 carrier:0
>>           collisions:0 txqueuelen:256
>>           RX bytes:0 (0.0 b)  TX bytes:14620 (14.2 KiB)
>>
>> ib0.8005  Link encap:InfiniBand  HWaddr
>> 80:00:04:07:FE:80:00:00:00:00:00:00:00:00:00:00:00:00:00:00
>>           inet addr:192.168.10.2  Bcast:192.168.10.255  Mask:255.255.255.0
>>           inet6 addr: fe80::202:c902:25:2841/64 Scope:Link
>>           UP BROADCAST RUNNING MULTICAST  MTU:65520  Metric:1
>>           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
>>           TX packets:72 errors:0 dropped:18 overruns:0 carrier:0
>>           collisions:0 txqueuelen:256
>>           RX bytes:0 (0.0 b)  TX bytes:14269 (13.9 KiB)
>
> Looks like none of the subinterfaces are receiving and the primary
> interface only received 1 packet.
>
> What does saquery -g show and then saquery -m<mlid>  for each mlid
> shown in the MC groups dump.
>

Here's the saquery output:

[root@labdisk01 network-scripts]# saquery -g
MCMemberRecord group dump:
                 MGID....................ff12:401b:8004::1
                 Mlid....................0xC003
                 Mtu.....................0x84
                 pkey....................0x8004
                 Rate....................0x83
                 SL......................0x0
MCMemberRecord group dump:
                 MGID....................ff12:401b:8004::fb
                 Mlid....................0xC00C
                 Mtu.....................0x84
                 pkey....................0x8004
                 Rate....................0x83
                 SL......................0x0
MCMemberRecord group dump:
                 MGID....................ff12:401b:8004::ffff:ffff
                 Mlid....................0xC002
                 Mtu.....................0x84
                 pkey....................0x8004
                 Rate....................0x83
                 SL......................0x0
MCMemberRecord group dump:
                 MGID....................ff12:401b:8005::1
                 Mlid....................0xC005
                 Mtu.....................0x84
                 pkey....................0x8005
                 Rate....................0x83
                 SL......................0x0
MCMemberRecord group dump:
                 MGID....................ff12:401b:8005::fb
                 Mlid....................0xC00D
                 Mtu.....................0x84
                 pkey....................0x8005
                 Rate....................0x83
                 SL......................0x0
MCMemberRecord group dump:
                 MGID....................ff12:401b:8005::ffff:ffff
                 Mlid....................0xC004
                 Mtu.....................0x84
                 pkey....................0x8005
                 Rate....................0x83
                 SL......................0x0
MCMemberRecord group dump:
                 MGID....................ff12:401b:ffff::1
                 Mlid....................0xC001
                 Mtu.....................0x84
                 pkey....................0xFFFF
                 Rate....................0x83
                 SL......................0x0
MCMemberRecord group dump:
                 MGID....................ff12:401b:ffff::fb
                 Mlid....................0xC009
                 Mtu.....................0x84
                 pkey....................0xFFFF
                 Rate....................0x83
                 SL......................0x0
MCMemberRecord group dump:
                 MGID....................ff12:401b:ffff::ffff:ffff
                 Mlid....................0xC000
                 Mtu.....................0x84
                 pkey....................0xFFFF
                 Rate....................0x83
                 SL......................0x0
MCMemberRecord group dump:
                 MGID....................ff12:601b:8004::1
                 Mlid....................0xC013
                 Mtu.....................0x84
                 pkey....................0x8004
                 Rate....................0x83
                 SL......................0x0
MCMemberRecord group dump:
                 MGID....................ff12:601b:8004::fb
                 Mlid....................0xC00F
                 Mtu.....................0x84
                 pkey....................0x8004
                 Rate....................0x83
                 SL......................0x0
MCMemberRecord group dump:
                 MGID....................ff12:601b:8004::1:ff25:2841
                 Mlid....................0xC011
                 Mtu.....................0x84
                 pkey....................0x8004
                 Rate....................0x83
                 SL......................0x0
MCMemberRecord group dump:
                 MGID....................ff12:601b:8005::1
                 Mlid....................0xC014
                 Mtu.....................0x84
                 pkey....................0x8005
                 Rate....................0x83
                 SL......................0x0
MCMemberRecord group dump:
                 MGID....................ff12:601b:8005::fb
                 Mlid....................0xC010
                 Mtu.....................0x84
                 pkey....................0x8005
                 Rate....................0x83
                 SL......................0x0
MCMemberRecord group dump:
                 MGID....................ff12:601b:8005::1:ff25:2841
                 Mlid....................0xC012
                 Mtu.....................0x84
                 pkey....................0x8005
                 Rate....................0x83
                 SL......................0x0
MCMemberRecord group dump:
                 MGID....................ff12:601b:ffff::1
                 Mlid....................0xC008
                 Mtu.....................0x84
                 pkey....................0xFFFF
                 Rate....................0x83
                 SL......................0x0
MCMemberRecord group dump:
                 MGID....................ff12:601b:ffff::fb
                 Mlid....................0xC006
                 Mtu.....................0x84
                 pkey....................0xFFFF
                 Rate....................0x83
                 SL......................0x0
MCMemberRecord group dump:
                 MGID....................ff12:601b:ffff::1:ff09:cb2b
                 Mlid....................0xC007
                 Mtu.....................0x84
                 pkey....................0xFFFF
                 Rate....................0x83
                 SL......................0x0
MCMemberRecord group dump:
                 MGID....................ff12:601b:ffff::1:ff24:3471
                 Mlid....................0xC00B
                 Mtu.....................0x84
                 pkey....................0xFFFF
                 Rate....................0x83
                 SL......................0x0
MCMemberRecord group dump:
                 MGID....................ff12:601b:ffff::1:ff24:3591
                 Mlid....................0xC00A
                 Mtu.....................0x84
                 pkey....................0xFFFF
                 Rate....................0x83
                 SL......................0x0
MCMemberRecord group dump:
                 MGID....................ff12:601b:ffff::1:ff25:2841
                 Mlid....................0xC00E
                 Mtu.....................0x84
                 pkey....................0xFFFF
                 Rate....................0x83
                 SL......................0x0


And here's the mlid saquery information for each mlid:

[root@labdisk01 ~]# saquery -m 0xC003
                 PortGid.................fe80::2:c902:25:2841 (labdisk01 
HCA-1)
[root@labdisk01 ~]# saquery -m 0xC00C
                 PortGid.................fe80::2:c902:25:2841 (labdisk01 
HCA-1)
[root@labdisk01 ~]# saquery -m 0xC002
                 PortGid.................fe80::2:c902:25:2841 (labdisk01 
HCA-1)
[root@labdisk01 ~]# saquery -m 0xC005
                 PortGid.................fe80::2:c902:25:2841 (labdisk01 
HCA-1)
[root@labdisk01 ~]# saquery -m 0xC00D
                 PortGid.................fe80::2:c902:25:2841 (labdisk01 
HCA-1)
[root@labdisk01 ~]# saquery -m 0xC004
                 PortGid.................fe80::2:c902:25:2841 (labdisk01 
HCA-1)
[root@labdisk01 ~]# saquery -m 0xC001
                 PortGid.................fe80::2:c903:9:cb2b (occupied 
HCA-1)
                 PortGid.................fe80::2:c902:24:3471 (stagnate 
HCA-1)
                 PortGid.................fe80::2:c902:24:3591 (innovate 
HCA-1)
[root@labdisk01 ~]# saquery -m 0xC009
                 PortGid.................fe80::2:c903:9:cb2b (occupied 
HCA-1)
                 PortGid.................fe80::2:c902:24:3471 (stagnate 
HCA-1)
                 PortGid.................fe80::2:c902:24:3591 (innovate 
HCA-1)
[root@labdisk01 ~]# saquery -m 0xC000
                 PortGid.................fe80::2:c903:9:cb2b (occupied 
HCA-1)
                 PortGid.................fe80::2:c902:25:2841 (labdisk01 
HCA-1)
                 PortGid.................fe80::2:c902:24:3471 (stagnate 
HCA-1)
                 PortGid.................fe80::2:c902:24:3591 (innovate 
HCA-1)
[root@labdisk01 ~]# saquery -m 0xC013
                 PortGid.................fe80::2:c902:25:2841 (labdisk01 
HCA-1)
[root@labdisk01 ~]# saquery -m 0xC00F
                 PortGid.................fe80::2:c902:25:2841 (labdisk01 
HCA-1)
[root@labdisk01 ~]# saquery -m 0xC011
                 PortGid.................fe80::2:c902:25:2841 (labdisk01 
HCA-1)
[root@labdisk01 ~]# saquery -m 0xC014
                 PortGid.................fe80::2:c902:25:2841 (labdisk01 
HCA-1)
[root@labdisk01 ~]# saquery -m 0xC010
                 PortGid.................fe80::2:c902:25:2841 (labdisk01 
HCA-1)
[root@labdisk01 ~]# saquery -m 0xC012
                 PortGid.................fe80::2:c902:25:2841 (labdisk01 
HCA-1)
[root@labdisk01 ~]# saquery -m 0xC008
                 PortGid.................fe80::2:c903:9:cb2b (occupied 
HCA-1)
                 PortGid.................fe80::2:c902:25:2841 (labdisk01 
HCA-1)
                 PortGid.................fe80::2:c902:24:3471 (stagnate 
HCA-1)
                 PortGid.................fe80::2:c902:24:3591 (innovate 
HCA-1)
[root@labdisk01 ~]# saquery -m 0xC006
                 PortGid.................fe80::2:c903:9:cb2b (occupied 
HCA-1)
                 PortGid.................fe80::2:c902:25:2841 (labdisk01 
HCA-1)
                 PortGid.................fe80::2:c902:24:3471 (stagnate 
HCA-1)
                 PortGid.................fe80::2:c902:24:3591 (innovate 
HCA-1)
[root@labdisk01 ~]# saquery -m 0xC007
                 PortGid.................fe80::2:c903:9:cb2b (occupied 
HCA-1)
[root@labdisk01 ~]# saquery -m 0xC00B
                 PortGid.................fe80::2:c902:24:3471 (stagnate 
HCA-1)
[root@labdisk01 ~]# saquery -m 0xC00A
                 PortGid.................fe80::2:c902:24:3591 (innovate 
HCA-1)
[root@labdisk01 ~]# saquery -m 0xC00E
                 PortGid.................fe80::2:c902:25:2841 (labdisk01 
HCA-1)


What is it that we're we looking for in this output?

Tom



> -- Hal
>
>> Also, here's some junk from /var/log/messages, seemed like it might be
>> relevant, but maybe this is just IP stuff:
>>
>> Jul 22 14:38:37 labdisk01 kernel: ADDRCONF(NETDEV_UP): ib0.8004: link is not
>> ready
>> Jul 22 14:38:37 labdisk01 kernel: ADDRCONF(NETDEV_CHANGE): ib0.8004: link
>> becomes ready
>> Jul 22 14:38:39 labdisk01 avahi-daemon[4056]: New relevant interface
>> ib0.8004.IPv6 for mDNS.
>> Jul 22 14:38:39 labdisk01 avahi-daemon[4056]: Joining mDNS multicast group
>> on interface ib0.8004.IPv6 with address fe80::202:c902:25:2841.
>> Jul 22 14:38:39 labdisk01 avahi-daemon[4056]: Registering new address record
>> for fe80::202:c902:25:2841 on ib0.8004.
>> Jul 22 14:38:41 labdisk01 avahi-daemon[4056]: New relevant interface
>> ib0.8004.IPv4 for mDNS.
>> Jul 22 14:38:41 labdisk01 avahi-daemon[4056]: Joining mDNS multicast group
>> on interface ib0.8004.IPv4 with address 10.0.0.2.
>> Jul 22 14:38:41 labdisk01 avahi-daemon[4056]: Registering new address record
>> for 10.0.0.2 on ib0.8004.
>> Jul 22 14:39:22 labdisk01 kernel: ADDRCONF(NETDEV_UP): ib0.8005: link is not
>> ready
>> Jul 22 14:39:22 labdisk01 kernel: ADDRCONF(NETDEV_CHANGE): ib0.8005: link
>> becomes ready
>> Jul 22 14:39:24 labdisk01 avahi-daemon[4056]: New relevant interface
>> ib0.8005.IPv6 for mDNS.
>> Jul 22 14:39:24 labdisk01 avahi-daemon[4056]: Joining mDNS multicast group
>> on interface ib0.8005.IPv6 with address fe80::202:c902:25:2841.
>> Jul 22 14:39:24 labdisk01 avahi-daemon[4056]: Registering new address record
>> for fe80::202:c902:25:2841 on ib0.8005.
>> Jul 22 14:39:26 labdisk01 avahi-daemon[4056]: New relevant interface
>> ib0.8005.IPv4 for mDNS.
>> Jul 22 14:39:26 labdisk01 avahi-daemon[4056]: Joining mDNS multicast group
>> on interface ib0.8005.IPv4 with address 192.168.10.2.
>> Jul 22 14:39:26 labdisk01 avahi-daemon[4056]: Registering new address record
>> for 192.168.10.2 on ib0.8005.
>>
>>
>>
>>>
>>>> My plan was to create two child interfaces (0x8004 and 0x8005) and then
>>>> ifconfig ib0.8004 and ifconfig ib0.8005 to assign them to separate
>>>> subnets.
>>>
>>> That should be fine.
>>>
>>> -- Hal
>>>
>>>> Tom
>>>>
>>>>
>>>>>
>>>>> The pkey you are seeing is the only one for ib0 interface.
>>>>>
>>>>
>>>>
>>>>
>>>>
>>>>
>>>>
>>>>
>>>>
>>>>
>>>>
>>>>
>>>>
>>>>> If you want to have IPoIB interfaces on the other partitions too, you
>>>>> need to set this up by creating a child interface on those nodes; you
>>>>> had asked about that in a previous email
>>>>> (http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg04728.html).
>>>>>
>>>>> -- Hal
>>>>>
>>>>>>
>>>>>> I'm trying to run one ipoib subnet in each partition, and then
>>>>>> eventually the goal is to have a different server that has 2 child
>>>>>> interfaces, one on each subnet. But it doesn't appear that my partition
>>>>>> configuration is even correct. Is there a syntax error, or something
>>>>>> else I am missing?
>>>>>>
>>>>>> Thanks,
>>>>>>
>>>>>> Tom
>>>>>>
>>>>>>
>>>>>>
>>>>>> --
>>>>>> Tom Ammon
>>>>>> Network Engineer
>>>>>> Office: 801.587.0976
>>>>>> Mobile: 801.674.9273
>>>>>>
>>>>>> Center for High Performance Computing
>>>>>> University of Utah
>>>>>> http://www.chpc.utah.edu
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
>>>>>> in
>>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>
>>>>
>>>> --
>>>> Tom Ammon
>>>> Network Engineer
>>>> Office: 801.587.0976
>>>> Mobile: 801.674.9273
>>>>
>>>> Center for High Performance Computing
>>>> University of Utah
>>>> http://www.chpc.utah.edu
>>>>
>>
>> --
>> Tom Ammon
>> Network Engineer
>> Office: 801.587.0976
>> Mobile: 801.674.9273
>>
>> Center for High Performance Computing
>> University of Utah
>> http://www.chpc.utah.edu
>>

-- 
Tom Ammon
Network Engineer
Office: 801.587.0976
Mobile: 801.674.9273

Center for High Performance Computing
University of Utah
http://www.chpc.utah.edu
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
