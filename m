From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: more partition questions
Date: Thu, 22 Jul 2010 20:08:30 -0400
Message-ID: <AANLkTim9BGa-eFxff2yVd4MTdL_Ahx-_g69ATkEa-lmn@mail.gmail.com>
References: <4C448DCD.80809@utah.edu>
	<AANLkTikDh5Em28cj9WSy2nNC-vrcZe4MwFHOYt9OmeuU@mail.gmail.com>
	<4C487D8F.80203@utah.edu>
	<AANLkTinqUs3CHKW42SWUVdqLr3vX-ixMc4M8u2ZRnQfr@mail.gmail.com>
	<4C48AECB.9010008@utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C48AECB.9010008-wbocuHtxKic@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Ammon <tom.ammon-wbocuHtxKic@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Tom,

On Thu, Jul 22, 2010 at 4:49 PM, Tom Ammon <tom.ammon-wbocuHtxKic@public.gmane.org> wrote:
> Hal,
>
> Thanks for looking at all of this with me. ifconfig output is below.
>
> On 7/22/2010 12:08 PM, Hal Rosenstock wrote:
>>
>> Tom,
>>
>> On Thu, Jul 22, 2010 at 1:19 PM, Tom Ammon<tom.ammon-wbocuHtxKic@public.gmane.org> =C2=A0=
wrote:
>>>
>>> Hal,
>>>
>>> On 7/21/2010 2:45 PM, Hal Rosenstock wrote:
>>>>
>>>> Hi Tom,
>>>>
>>>> On 7/19/10, Tom Ammon<tom.ammon-wbocuHtxKic@public.gmane.org> =C2=A0 =C2=A0wrote:
>>>>>
>>>>> I'm trying to set up partitions in a little test environment, and=
 I'm
>>>>> having trouble.
>>>>>
>>>>> I have opensm running on a machine attached to the fabric, and sm=
info
>>>>> on
>>>>> the other machines confirm that this is indeed the master SM. Her=
e's my
>>>>> /etc/opensm/partitions.conf:
>>>>>
>>>>> Default=3D0xffff , ipoib : ALL, SELF=3Dfull ;
>>>>> PartitionBlue=3D0x8004, ipoib : 0x0002c9030009cb3f=3Dfull,
>>>>> 0x0002c90200252841=3Dfull, 0x0002c90200243471=3Dfull ;
>>>>> PartitionRed=3D0x8005, ipoib : 0x0002c90200252841=3Dfull,
>>>>> 0x0002c90200243591=3Dfull, 0x0002c9030009cb2b=3Dfull ;
>>>>
>>>> You don't really need the 0x8000 bit on in the pkeys but I don't t=
hink
>>>> it does any harm.
>>>>
>>>>> But when I go to the machine with port GUID 0x0002c90200243471, i=
t
>>>>> doesn't appear that it's getting the pkey I wanted:
>>>>>
>>>>> [root@stagnate ~]# ibstat
>>>>> CA 'mthca0'
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CA type: MT23108
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Number of ports: 2
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Firmware version: 3.3.5
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Hardware version: a1
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Node GUID: 0x0002c90200243470
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0System image GUID: 0x0002c90200=
243473
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Port 1:
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Sta=
te: Active
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Phy=
sical state: LinkUp
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Rat=
e: 10
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Bas=
e lid: 10
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LMC=
: 0
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SM =
lid: 4
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Cap=
ability mask: 0x02510a68
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Por=
t GUID: 0x0002c90200243471
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Port 2:
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Sta=
te: Down
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Phy=
sical state: Polling
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Rat=
e: 2
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Bas=
e lid: 0
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LMC=
: 0
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SM =
lid: 0
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Cap=
ability mask: 0x02510a68
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Por=
t GUID: 0x0002c90200243472
>>>>>
>>>>> [root@stagnate ~]# cat /sys/class/net/ib0/pkey
>>>>> 0xffff
>>>>
>>>> What does:
>>>>
>>>> smpquery pkeys 10 1
>>>>
>>>> say ? Do you see the other pkey(s) on that port ?
>>>
>>> [root@stagnate ~]# smpquery pkeys 10 1
>>> =C2=A0 0: 0x7fff 0x8004 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>> =C2=A0 8: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>> =C2=A016: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>> =C2=A024: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>> =C2=A032: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>> =C2=A040: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>> =C2=A048: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>> =C2=A056: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>> 64 pkeys capacity for this port
>>>
>>> So I see that both 7fff and 8004 are being assigned to this port. I=
s that
>>> okay?
>>
>> Yes.
>>
>>> =C2=A0Is there any problem with the machine also being in the defau=
lt
>>> partition?
>>
>> No.
>>
>>> As I look around at all of the machines with smpquery, it appears t=
hat
>>> they
>>> are all being assigned 7fff and the pkey that I assigned in
>>> partitions.conf.
>>
>> Good.
>>
>>> But the machine that I want to run 2 child interfaces on is having
>>> issues.
>>> It's at LID 7 and here's what smpquery says:
>>>
>>> [root@stagnate ~]# smpquery pkeys 7 1
>>> =C2=A0 0: 0x7fff 0x8004 0x8005 0x0000 0x0000 0x0000 0x0000 0x0000
>>> =C2=A0 8: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>> =C2=A016: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>> =C2=A024: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>> =C2=A032: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>> =C2=A040: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>> =C2=A048: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>> =C2=A056: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>> 64 pkeys capacity for this port
>>>
>>> So that's fine, but when I try to create a child interface I get th=
is:
>>>
>>> [root@labdisk01 ~]# echo 0x8004> =C2=A0/sys/class/net/ib0/create_ch=
ild
>>> -bash: echo: write error: Name not unique on network
>>
>> I don't know what cause that error. Maybe someone else can help here=
=2E
>>
>> Are you sure the ib0 interface is OK ? What does ifconfig ib0 say ?
>
> Here's ifconfig ib0:
>
> ib0 =C2=A0 =C2=A0 =C2=A0 Link encap:InfiniBand =C2=A0HWaddr
> 80:00:04:04:FE:80:00:00:00:00:00:00:00:00:00:00:00:00:00:00
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0inet6 addr: fe80::202:c902:25:2841/=
64 Scope:Link
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0UP BROADCAST RUNNING MULTICAST =C2=A0=
MTU:65520 =C2=A0Metric:1
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0RX packets:1 errors:0 dropped:0 ove=
rruns:0 frame:0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0TX packets:17 errors:0 dropped:7 ov=
erruns:0 carrier:0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0collisions:0 txqueuelen:256
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0RX bytes:56 (56.0 b) =C2=A0TX bytes=
:3529 (3.4 KiB)
>
>
> Then I brought up the "sub"interfaces with "ifup ib0.8004" "ifup ib0.=
8005" .
> Still get the "Name not unique on network" message if I switch the or=
der and
> do ifup followed by echo 0x8004....etc.
>
> ib0.8004 =C2=A0Link encap:InfiniBand =C2=A0HWaddr
> 80:00:04:06:FE:80:00:00:00:00:00:00:00:00:00:00:00:00:00:00
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0inet addr:10.0.0.2 =C2=A0Bcast:10.0=
=2E0.255 =C2=A0Mask:255.255.255.0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0inet6 addr: fe80::202:c902:25:2841/=
64 Scope:Link
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0UP BROADCAST RUNNING MULTICAST =C2=A0=
MTU:65520 =C2=A0Metric:1
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0RX packets:0 errors:0 dropped:0 ove=
rruns:0 frame:0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0TX packets:78 errors:0 dropped:17 o=
verruns:0 carrier:0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0collisions:0 txqueuelen:256
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0RX bytes:0 (0.0 b) =C2=A0TX bytes:1=
4620 (14.2 KiB)
>
> ib0.8005 =C2=A0Link encap:InfiniBand =C2=A0HWaddr
> 80:00:04:07:FE:80:00:00:00:00:00:00:00:00:00:00:00:00:00:00
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0inet addr:192.168.10.2 =C2=A0Bcast:=
192.168.10.255 =C2=A0Mask:255.255.255.0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0inet6 addr: fe80::202:c902:25:2841/=
64 Scope:Link
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0UP BROADCAST RUNNING MULTICAST =C2=A0=
MTU:65520 =C2=A0Metric:1
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0RX packets:0 errors:0 dropped:0 ove=
rruns:0 frame:0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0TX packets:72 errors:0 dropped:18 o=
verruns:0 carrier:0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0collisions:0 txqueuelen:256
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0RX bytes:0 (0.0 b) =C2=A0TX bytes:1=
4269 (13.9 KiB)

Looks like none of the subinterfaces are receiving and the primary
interface only received 1 packet.

What does saquery -g show and then saquery -m <mlid> for each mlid
shown in the MC groups dump.

-- Hal

> Also, here's some junk from /var/log/messages, seemed like it might b=
e
> relevant, but maybe this is just IP stuff:
>
> Jul 22 14:38:37 labdisk01 kernel: ADDRCONF(NETDEV_UP): ib0.8004: link=
 is not
> ready
> Jul 22 14:38:37 labdisk01 kernel: ADDRCONF(NETDEV_CHANGE): ib0.8004: =
link
> becomes ready
> Jul 22 14:38:39 labdisk01 avahi-daemon[4056]: New relevant interface
> ib0.8004.IPv6 for mDNS.
> Jul 22 14:38:39 labdisk01 avahi-daemon[4056]: Joining mDNS multicast =
group
> on interface ib0.8004.IPv6 with address fe80::202:c902:25:2841.
> Jul 22 14:38:39 labdisk01 avahi-daemon[4056]: Registering new address=
 record
> for fe80::202:c902:25:2841 on ib0.8004.
> Jul 22 14:38:41 labdisk01 avahi-daemon[4056]: New relevant interface
> ib0.8004.IPv4 for mDNS.
> Jul 22 14:38:41 labdisk01 avahi-daemon[4056]: Joining mDNS multicast =
group
> on interface ib0.8004.IPv4 with address 10.0.0.2.
> Jul 22 14:38:41 labdisk01 avahi-daemon[4056]: Registering new address=
 record
> for 10.0.0.2 on ib0.8004.
> Jul 22 14:39:22 labdisk01 kernel: ADDRCONF(NETDEV_UP): ib0.8005: link=
 is not
> ready
> Jul 22 14:39:22 labdisk01 kernel: ADDRCONF(NETDEV_CHANGE): ib0.8005: =
link
> becomes ready
> Jul 22 14:39:24 labdisk01 avahi-daemon[4056]: New relevant interface
> ib0.8005.IPv6 for mDNS.
> Jul 22 14:39:24 labdisk01 avahi-daemon[4056]: Joining mDNS multicast =
group
> on interface ib0.8005.IPv6 with address fe80::202:c902:25:2841.
> Jul 22 14:39:24 labdisk01 avahi-daemon[4056]: Registering new address=
 record
> for fe80::202:c902:25:2841 on ib0.8005.
> Jul 22 14:39:26 labdisk01 avahi-daemon[4056]: New relevant interface
> ib0.8005.IPv4 for mDNS.
> Jul 22 14:39:26 labdisk01 avahi-daemon[4056]: Joining mDNS multicast =
group
> on interface ib0.8005.IPv4 with address 192.168.10.2.
> Jul 22 14:39:26 labdisk01 avahi-daemon[4056]: Registering new address=
 record
> for 192.168.10.2 on ib0.8005.
>
>
>
>>
>>> My plan was to create two child interfaces (0x8004 and 0x8005) and =
then
>>> ifconfig ib0.8004 and ifconfig ib0.8005 to assign them to separate
>>> subnets.
>>
>> That should be fine.
>>
>> -- Hal
>>
>>> Tom
>>>
>>>
>>>>
>>>> The pkey you are seeing is the only one for ib0 interface.
>>>>
>>>
>>>
>>>
>>>
>>>
>>>
>>>
>>>
>>>
>>>
>>>
>>>
>>>> If you want to have IPoIB interfaces on the other partitions too, =
you
>>>> need to set this up by creating a child interface on those nodes; =
you
>>>> had asked about that in a previous email
>>>> (http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg04728.h=
tml).
>>>>
>>>> -- Hal
>>>>
>>>>>
>>>>> I'm trying to run one ipoib subnet in each partition, and then
>>>>> eventually the goal is to have a different server that has 2 chil=
d
>>>>> interfaces, one on each subnet. But it doesn't appear that my par=
tition
>>>>> configuration is even correct. Is there a syntax error, or someth=
ing
>>>>> else I am missing?
>>>>>
>>>>> Thanks,
>>>>>
>>>>> Tom
>>>>>
>>>>>
>>>>>
>>>>> --
>>>>> Tom Ammon
>>>>> Network Engineer
>>>>> Office: 801.587.0976
>>>>> Mobile: 801.674.9273
>>>>>
>>>>> Center for High Performance Computing
>>>>> University of Utah
>>>>> http://www.chpc.utah.edu
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-r=
dma"
>>>>> in
>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-inf=
o.html
>>>>>
>>>
>>> --
>>> Tom Ammon
>>> Network Engineer
>>> Office: 801.587.0976
>>> Mobile: 801.674.9273
>>>
>>> Center for High Performance Computing
>>> University of Utah
>>> http://www.chpc.utah.edu
>>>
>
> --
> Tom Ammon
> Network Engineer
> Office: 801.587.0976
> Mobile: 801.674.9273
>
> Center for High Performance Computing
> University of Utah
> http://www.chpc.utah.edu
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
