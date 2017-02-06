From: feu tche <feutche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: any suggested configuration for rxe?
Date: Mon, 6 Feb 2017 09:44:01 +0000
Message-ID: <CAJ-uSQbrS3MDz0NyWv1ctKQdXG9-e633mKc5cPe5fKOuL8Bj3Q@mail.gmail.com>
References: <CAJ-uSQZcnQ+Mqj1XGuMSzP54WQi6KofDyp11dCog+bqGmL3MWA@mail.gmail.com>
 <CAG9sBKPj9wJhwZOFDXoOwH0=tBZR1pWdS6chYn_VK6SLdDQ7Xg@mail.gmail.com>
 <CAJ-uSQY50gRrQe7TAoJq3rd_MFqX8o=y_CZ=hqFJ1=WFZSg+tw@mail.gmail.com>
 <CAG9sBKPGWNrR_ejm-LxNzy5iqXKwvxUD2-mLYsGJnVw7FkxKHg@mail.gmail.com>
 <CAG9sBKMVVtUdffzH8DbS7vRzYiyAPDBn+n2MMBYvpe6SQXYHjA@mail.gmail.com>
 <CAJ-uSQb0jqewQL095i_+vtzCnPK70AnLE+XAgv_XkjxKW9jLFQ@mail.gmail.com> <c50d9d3d-f696-ed0c-f23f-1c5a8e1f0f2d@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c50d9d3d-f696-ed0c-f23f-1c5a8e1f0f2d-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

hi Yonatan,

Yes I can try single physical device, just need some time to configure.
When initially trying on vmware that was a single device, with all the
same results, so I don't think it will make any difference to be
honest. As I remember from diagrams, rxe fits just before bonding so
should work with it as well?

Thanks!

Fedor

On 6 February 2017 at 08:15, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 2/2/2017 1:07 AM, feu tche wrote:
>>
>> hi Moni, guys,
>>
>> Sure yes I could ping, yes, no firewall or anything, in all cases that
>> was clean minimal install of Ubuntu 16.04.1 with updates and 4.9.6
>> kernel.
>> In my previous tests that was all on vmware vms on virtual network,
>> but as you asked I also decided to check on real hardware.
>>
>> I've got same results (below) between two machines with dual Intel
>> I350 and I also checked same both directions against a machine with
>> dual Mellanox ConnectX-3 Pro.
>>
>>
>> =====================================================================================
>> Client:
>>
>> root@rdma-client:~/rdma-core-master# rxe_cfg status
>> Argument "" isn't numeric in numeric eq (==) at
>> /root/rdma-core-master/providers/rxe/rxe_cfg line 140.
>>   Name   Link  Driver   Speed  NMTU  IPv4_addr       RDEV  RMTU
>>   bond0  yes   bonding         1500  147.75.100.109  rxe0  1024  (3)
>>   p1p1   yes   igb             1500
>>   p1p2   yes   igb             1500
>> root@rdma-client:~/rdma-core-master# ibv_devinfo -d rxe0
>> hca_id: rxe0
>>         transport:                      InfiniBand (0)
>>         fw_ver:                         0.0.0
>>         node_guid:                      0ec4:7aff:fe80:5d8e
>>         sys_image_guid:                 0000:0000:0000:0000
>>         vendor_id:                      0x0000
>>         vendor_part_id:                 0
>>         hw_ver:                         0x0
>>         phys_port_cnt:                  1
>>                 port:   1
>>                         state:                  PORT_ACTIVE (4)
>>                         max_mtu:                4096 (5)
>>                         active_mtu:             1024 (3)
>>                         sm_lid:                 0
>>                         port_lid:               0
>>                         port_lmc:               0x00
>>                         link_layer:             Ethernet
>>
>> root@rdma-client:~/rdma-core-master# ping 147.75.100.177
>> PING 147.75.100.177 (147.75.100.177) 56(84) bytes of data.
>> 64 bytes from 147.75.100.177: icmp_seq=1 ttl=63 time=0.451 ms
>> 64 bytes from 147.75.100.177: icmp_seq=2 ttl=63 time=0.548 ms
>> 64 bytes from 147.75.100.177: icmp_seq=3 ttl=63 time=0.548 ms
>> 64 bytes from 147.75.100.177: icmp_seq=4 ttl=63 time=0.552 ms
>>
>> root@rdma-client:~/rdma-core-master# ibv_rc_pingpong -d rxe0 -g 1 -i 1
>> -n 1 147.75.100.177
>>   local address:  LID 0x0000, QPN 0x000011, PSN 0x4af006, GID
>> ::ffff:147.75.100.109
>>   remote address: LID 0x0000, QPN 0x000011, PSN 0xf304fb, GID
>> ::ffff:147.75.100.177
>> ^C
>>
>> root@rdma-client:~/rdma-core-master# ibv_rc_pingpong -d rxe0 -g 0 -i 1
>> -n 1 147.75.100.177
>>   local address:  LID 0x0000, QPN 0x000011, PSN 0xe483d9, GID
>> fe80::ec4:7aff:fe80:5d8e
>>   remote address: LID 0x0000, QPN 0x000011, PSN 0xda937e, GID
>> fe80::ec4:7aff:fe80:5c2e
>> ^C
>>
>> ====================================================================================
>>
>> Server:
>>
>> H/W path         Device     Class          Description
>> ======================================================
>>                             system         SYS-5039MS-H12TRF (To be
>> filled by O.E.M.)
>> /0                          bus            X11SSE-F
>> /0/100                      bridge         Sky Lake Host Bridge/DRAM
>> Registers
>> /0/100/1                    bridge         Sky Lake PCIe Controller
>> (x16)
>> /0/100/1/0       p1p1       network        I350 Gigabit Network
>> Connection
>> /0/100/1/0.1     p1p2       network        I350 Gigabit Network Connection
>>
>>
>> root@rdma-server:~/rdma-core-master# rxe_cfg status
>> Argument "" isn't numeric in numeric eq (==) at
>> /root/rdma-core-master/providers/rxe/rxe_cfg line 140.
>>   Name   Link  Driver   Speed  NMTU  IPv4_addr       RDEV  RMTU
>>   bond0  yes   bonding         1500  147.75.100.177  rxe0  1024  (3)
>>   p1p1   yes   igb             1500
>>   p1p2   yes   igb             1500
>
> we never tried coupling rxe with a bond/bridge
> please retry with a real device. like the p1p1 you have there.
> thanks.
>
>> root@rdma-server:~/rdma-core-master# ibv_devinfo -d rxe0
>> hca_id: rxe0
>>         transport:                      InfiniBand (0)
>>         fw_ver:                         0.0.0
>>         node_guid:                      0ec4:7aff:fe80:5c2e
>>         sys_image_guid:                 0000:0000:0000:0000
>>         vendor_id:                      0x0000
>>         vendor_part_id:                 0
>>         hw_ver:                         0x0
>>         phys_port_cnt:                  1
>>                 port:   1
>>                         state:                  PORT_ACTIVE (4)
>>                         max_mtu:                4096 (5)
>>                         active_mtu:             1024 (3)
>>                         sm_lid:                 0
>>                         port_lid:               0
>>                         port_lmc:               0x00
>>                         link_layer:             Ethernet
>>
>> root@rdma-server:~/rdma-core-master# ibv_rc_pingpong -d rxe0 -g 1 -i 1
>>   local address:  LID 0x0000, QPN 0x000011, PSN 0xf304fb, GID
>> ::ffff:147.75.100.177
>>   remote address: LID 0x0000, QPN 0x000011, PSN 0x4af006, GID
>> ::ffff:147.75.100.109
>> Completion for unknown wr_id 0
>> parse WC failed 2
>>
>> root@rdma-server:~/rdma-core-master# ibv_rc_pingpong -d rxe0 -g 0 -i 1
>>   local address:  LID 0x0000, QPN 0x000011, PSN 0xddb87c, GID
>> fe80::ec4:7aff:fe80:5c2e
>>   remote address: LID 0x0000, QPN 0x000011, PSN 0x415a75, GID
>> fe80::ec4:7aff:fe80:5d8e
>> ^C
>>
>> Trace is attached.
>>
>> Thanks!
>>
>> Fedor
>>
>>
>> On 1 Feb 2017 09:35, "Moni Shoua" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>>
>>>
>>>>
>>>> Hi
>>>> 1. Can you ping from 192.168.237.132 to 192.168.237.133?
>>>> 2. Which Ethernet NICs are you using (vendor)?
>>>> 3. Can you please run the test with tracing on the server side (the
>>>> side you sent the log for) and attach the results
>>>> (/sys/kernel/debug/tracing/trace)
>>>>
>>>> thanks
>>>
>>>
>>> I forgot to mention that in the trace filter I'd like to see functions
>>> from ib_core, rdma_cm, ib_cm, ib_rxe
>>>
>>> Also, please check if you have a firewall (iptables) that block UDP/4791
>>>
>>> thanks
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
