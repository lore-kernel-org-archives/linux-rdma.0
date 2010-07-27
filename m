From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: more partition questions
Date: Tue, 27 Jul 2010 14:34:15 -0400
Message-ID: <AANLkTim5-5s_WXsApvfAqawNrqT_oTvVawzLaF3bx0t4@mail.gmail.com>
References: <4C448DCD.80809@utah.edu>
	<AANLkTikDh5Em28cj9WSy2nNC-vrcZe4MwFHOYt9OmeuU@mail.gmail.com>
	<4C487D8F.80203@utah.edu>
	<AANLkTinqUs3CHKW42SWUVdqLr3vX-ixMc4M8u2ZRnQfr@mail.gmail.com>
	<4C48AECB.9010008@utah.edu>
	<AANLkTim9BGa-eFxff2yVd4MTdL_Ahx-_g69ATkEa-lmn@mail.gmail.com>
	<4C4DC973.7090006@utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C4DC973.7090006-wbocuHtxKic@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Ammon <tom.ammon-wbocuHtxKic@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Tom,

On Mon, Jul 26, 2010 at 1:44 PM, Tom Ammon <tom.ammon-wbocuHtxKic@public.gmane.org> wrote:
> Hal,
>
> On 7/22/2010 6:08 PM, Hal Rosenstock wrote:
>>
>> Tom,
>>
>> On Thu, Jul 22, 2010 at 4:49 PM, Tom Ammon<tom.ammon-wbocuHtxKic@public.gmane.org> =C2=A0=
wrote:
>>>
>>> Hal,
>>>
>>> Thanks for looking at all of this with me. ifconfig output is below=
=2E
>>>
>>> On 7/22/2010 12:08 PM, Hal Rosenstock wrote:
>>>>
>>>> Tom,
>>>>
>>>> On Thu, Jul 22, 2010 at 1:19 PM, Tom Ammon<tom.ammon-wbocuHtxKic@public.gmane.org> =C2=
=A0 =C2=A0wrote:
>>>>>
>>>>> Hal,
>>>>>
>>>>> On 7/21/2010 2:45 PM, Hal Rosenstock wrote:
>>>>>>
>>>>>> Hi Tom,
>>>>>>
>>>>>> On 7/19/10, Tom Ammon<tom.ammon-wbocuHtxKic@public.gmane.org> =C2=A0 =C2=A0 =C2=A0wr=
ote:
>>>>>>>
>>>>>>> I'm trying to set up partitions in a little test environment, a=
nd I'm
>>>>>>> having trouble.
>>>>>>>
>>>>>>> I have opensm running on a machine attached to the fabric, and =
sminfo
>>>>>>> on
>>>>>>> the other machines confirm that this is indeed the master SM. H=
ere's
>>>>>>> my
>>>>>>> /etc/opensm/partitions.conf:
>>>>>>>
>>>>>>> Default=3D0xffff , ipoib : ALL, SELF=3Dfull ;
>>>>>>> PartitionBlue=3D0x8004, ipoib : 0x0002c9030009cb3f=3Dfull,
>>>>>>> 0x0002c90200252841=3Dfull, 0x0002c90200243471=3Dfull ;
>>>>>>> PartitionRed=3D0x8005, ipoib : 0x0002c90200252841=3Dfull,
>>>>>>> 0x0002c90200243591=3Dfull, 0x0002c9030009cb2b=3Dfull ;
>>>>>>
>>>>>> You don't really need the 0x8000 bit on in the pkeys but I don't=
 think
>>>>>> it does any harm.
>>>>>>
>>>>>>> But when I go to the machine with port GUID 0x0002c90200243471,=
 it
>>>>>>> doesn't appear that it's getting the pkey I wanted:
>>>>>>>
>>>>>>> [root@stagnate ~]# ibstat
>>>>>>> CA 'mthca0'
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CA type: MT23108
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Number of ports: 2
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Firmware version: 3.3.5
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Hardware version: a1
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Node GUID: 0x0002c90200243470
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0System image GUID: 0x0002c902=
00243473
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Port 1:
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0S=
tate: Active
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0P=
hysical state: LinkUp
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0R=
ate: 10
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0B=
ase lid: 10
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0L=
MC: 0
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0S=
M lid: 4
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0C=
apability mask: 0x02510a68
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0P=
ort GUID: 0x0002c90200243471
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Port 2:
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0S=
tate: Down
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0P=
hysical state: Polling
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0R=
ate: 2
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0B=
ase lid: 0
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0L=
MC: 0
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0S=
M lid: 0
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0C=
apability mask: 0x02510a68
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0P=
ort GUID: 0x0002c90200243472
>>>>>>>
>>>>>>> [root@stagnate ~]# cat /sys/class/net/ib0/pkey
>>>>>>> 0xffff
>>>>>>
>>>>>> What does:
>>>>>>
>>>>>> smpquery pkeys 10 1
>>>>>>
>>>>>> say ? Do you see the other pkey(s) on that port ?
>>>>>
>>>>> [root@stagnate ~]# smpquery pkeys 10 1
>>>>> =C2=A0 0: 0x7fff 0x8004 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>>>> =C2=A0 8: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>>>> =C2=A016: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>>>> =C2=A024: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>>>> =C2=A032: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>>>> =C2=A040: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>>>> =C2=A048: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>>>> =C2=A056: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>>>> 64 pkeys capacity for this port
>>>>>
>>>>> So I see that both 7fff and 8004 are being assigned to this port.=
 Is
>>>>> that
>>>>> okay?
>>>>
>>>> Yes.
>>>>
>>>>> =C2=A0Is there any problem with the machine also being in the def=
ault
>>>>> partition?
>>>>
>>>> No.
>>>>
>>>>> As I look around at all of the machines with smpquery, it appears=
 that
>>>>> they
>>>>> are all being assigned 7fff and the pkey that I assigned in
>>>>> partitions.conf.
>>>>
>>>> Good.
>>>>
>>>>> But the machine that I want to run 2 child interfaces on is havin=
g
>>>>> issues.
>>>>> It's at LID 7 and here's what smpquery says:
>>>>>
>>>>> [root@stagnate ~]# smpquery pkeys 7 1
>>>>> =C2=A0 0: 0x7fff 0x8004 0x8005 0x0000 0x0000 0x0000 0x0000 0x0000
>>>>> =C2=A0 8: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>>>> =C2=A016: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>>>> =C2=A024: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>>>> =C2=A032: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>>>> =C2=A040: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>>>> =C2=A048: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>>>> =C2=A056: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
>>>>> 64 pkeys capacity for this port
>>>>>
>>>>> So that's fine, but when I try to create a child interface I get =
this:
>>>>>
>>>>> [root@labdisk01 ~]# echo 0x8004> =C2=A0 =C2=A0/sys/class/net/ib0/=
create_child
>>>>> -bash: echo: write error: Name not unique on network
>>>>
>>>> I don't know what cause that error. Maybe someone else can help he=
re.
>>>>
>>>> Are you sure the ib0 interface is OK ? What does ifconfig ib0 say =
?
>>>
>>> Here's ifconfig ib0:
>>>
>>> ib0 =C2=A0 =C2=A0 =C2=A0 Link encap:InfiniBand =C2=A0HWaddr
>>> 80:00:04:04:FE:80:00:00:00:00:00:00:00:00:00:00:00:00:00:00
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0inet6 addr: fe80::202:c902:25:284=
1/64 Scope:Link
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0UP BROADCAST RUNNING MULTICAST =C2=
=A0MTU:65520 =C2=A0Metric:1
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0RX packets:1 errors:0 dropped:0 o=
verruns:0 frame:0
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0TX packets:17 errors:0 dropped:7 =
overruns:0 carrier:0
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0collisions:0 txqueuelen:256
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0RX bytes:56 (56.0 b) =C2=A0TX byt=
es:3529 (3.4 KiB)
>>>
>>>
>>> Then I brought up the "sub"interfaces with "ifup ib0.8004" "ifup
>>> ib0.8005" .
>>> Still get the "Name not unique on network" message if I switch the =
order
>>> and
>>> do ifup followed by echo 0x8004....etc.
>>>
>>> ib0.8004 =C2=A0Link encap:InfiniBand =C2=A0HWaddr
>>> 80:00:04:06:FE:80:00:00:00:00:00:00:00:00:00:00:00:00:00:00
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0inet addr:10.0.0.2 =C2=A0Bcast:10=
=2E0.0.255 =C2=A0Mask:255.255.255.0
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0inet6 addr: fe80::202:c902:25:284=
1/64 Scope:Link
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0UP BROADCAST RUNNING MULTICAST =C2=
=A0MTU:65520 =C2=A0Metric:1
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0RX packets:0 errors:0 dropped:0 o=
verruns:0 frame:0
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0TX packets:78 errors:0 dropped:17=
 overruns:0 carrier:0
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0collisions:0 txqueuelen:256
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0RX bytes:0 (0.0 b) =C2=A0TX bytes=
:14620 (14.2 KiB)
>>>
>>> ib0.8005 =C2=A0Link encap:InfiniBand =C2=A0HWaddr
>>> 80:00:04:07:FE:80:00:00:00:00:00:00:00:00:00:00:00:00:00:00
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0inet addr:192.168.10.2 =C2=A0Bcas=
t:192.168.10.255 =C2=A0Mask:255.255.255.0
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0inet6 addr: fe80::202:c902:25:284=
1/64 Scope:Link
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0UP BROADCAST RUNNING MULTICAST =C2=
=A0MTU:65520 =C2=A0Metric:1
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0RX packets:0 errors:0 dropped:0 o=
verruns:0 frame:0
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0TX packets:72 errors:0 dropped:18=
 overruns:0 carrier:0
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0collisions:0 txqueuelen:256
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0RX bytes:0 (0.0 b) =C2=A0TX bytes=
:14269 (13.9 KiB)
>>
>> Looks like none of the subinterfaces are receiving and the primary
>> interface only received 1 packet.
>>
>> What does saquery -g show and then saquery -m<mlid> =C2=A0for each m=
lid
>> shown in the MC groups dump.
>>
>
> Here's the saquery output:
>
> [root@labdisk01 network-scripts]# saquery -g
> MCMemberRecord group dump:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MGID..........=
=2E.........ff12:401b:8004::1
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mlid..........=
=2E.........0xC003
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mtu...........=
=2E.........0x84
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pkey..........=
=2E.........0x8004
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Rate..........=
=2E.........0x83
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SL............=
=2E.........0x0
> MCMemberRecord group dump:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MGID..........=
=2E.........ff12:401b:8004::fb
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mlid..........=
=2E.........0xC00C
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mtu...........=
=2E.........0x84
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pkey..........=
=2E.........0x8004
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Rate..........=
=2E.........0x83
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SL............=
=2E.........0x0
> MCMemberRecord group dump:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MGID..........=
=2E.........ff12:401b:8004::ffff:ffff
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mlid..........=
=2E.........0xC002
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mtu...........=
=2E.........0x84
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pkey..........=
=2E.........0x8004
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Rate..........=
=2E.........0x83
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SL............=
=2E.........0x0
> MCMemberRecord group dump:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MGID..........=
=2E.........ff12:401b:8005::1
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mlid..........=
=2E.........0xC005
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mtu...........=
=2E.........0x84
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pkey..........=
=2E.........0x8005
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Rate..........=
=2E.........0x83
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SL............=
=2E.........0x0
> MCMemberRecord group dump:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MGID..........=
=2E.........ff12:401b:8005::fb
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mlid..........=
=2E.........0xC00D
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mtu...........=
=2E.........0x84
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pkey..........=
=2E.........0x8005
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Rate..........=
=2E.........0x83
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SL............=
=2E.........0x0
> MCMemberRecord group dump:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MGID..........=
=2E.........ff12:401b:8005::ffff:ffff
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mlid..........=
=2E.........0xC004
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mtu...........=
=2E.........0x84
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pkey..........=
=2E.........0x8005
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Rate..........=
=2E.........0x83
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SL............=
=2E.........0x0
> MCMemberRecord group dump:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MGID..........=
=2E.........ff12:401b:ffff::1
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mlid..........=
=2E.........0xC001
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mtu...........=
=2E.........0x84
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pkey..........=
=2E.........0xFFFF
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Rate..........=
=2E.........0x83
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SL............=
=2E.........0x0
> MCMemberRecord group dump:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MGID..........=
=2E.........ff12:401b:ffff::fb
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mlid..........=
=2E.........0xC009
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mtu...........=
=2E.........0x84
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pkey..........=
=2E.........0xFFFF
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Rate..........=
=2E.........0x83
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SL............=
=2E.........0x0
> MCMemberRecord group dump:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MGID..........=
=2E.........ff12:401b:ffff::ffff:ffff
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mlid..........=
=2E.........0xC000
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mtu...........=
=2E.........0x84
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pkey..........=
=2E.........0xFFFF
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Rate..........=
=2E.........0x83
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SL............=
=2E.........0x0
> MCMemberRecord group dump:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MGID..........=
=2E.........ff12:601b:8004::1
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mlid..........=
=2E.........0xC013
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mtu...........=
=2E.........0x84
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pkey..........=
=2E.........0x8004
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Rate..........=
=2E.........0x83
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SL............=
=2E.........0x0
> MCMemberRecord group dump:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MGID..........=
=2E.........ff12:601b:8004::fb
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mlid..........=
=2E.........0xC00F
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mtu...........=
=2E.........0x84
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pkey..........=
=2E.........0x8004
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Rate..........=
=2E.........0x83
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SL............=
=2E.........0x0
> MCMemberRecord group dump:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MGID..........=
=2E.........ff12:601b:8004::1:ff25:2841
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mlid..........=
=2E.........0xC011
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mtu...........=
=2E.........0x84
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pkey..........=
=2E.........0x8004
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Rate..........=
=2E.........0x83
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SL............=
=2E.........0x0
> MCMemberRecord group dump:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MGID..........=
=2E.........ff12:601b:8005::1
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mlid..........=
=2E.........0xC014
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mtu...........=
=2E.........0x84
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pkey..........=
=2E.........0x8005
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Rate..........=
=2E.........0x83
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SL............=
=2E.........0x0
> MCMemberRecord group dump:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MGID..........=
=2E.........ff12:601b:8005::fb
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mlid..........=
=2E.........0xC010
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mtu...........=
=2E.........0x84
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pkey..........=
=2E.........0x8005
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Rate..........=
=2E.........0x83
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SL............=
=2E.........0x0
> MCMemberRecord group dump:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MGID..........=
=2E.........ff12:601b:8005::1:ff25:2841
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mlid..........=
=2E.........0xC012
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mtu...........=
=2E.........0x84
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pkey..........=
=2E.........0x8005
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Rate..........=
=2E.........0x83
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SL............=
=2E.........0x0
> MCMemberRecord group dump:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MGID..........=
=2E.........ff12:601b:ffff::1
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mlid..........=
=2E.........0xC008
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mtu...........=
=2E.........0x84
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pkey..........=
=2E.........0xFFFF
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Rate..........=
=2E.........0x83
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SL............=
=2E.........0x0
> MCMemberRecord group dump:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MGID..........=
=2E.........ff12:601b:ffff::fb
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mlid..........=
=2E.........0xC006
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mtu...........=
=2E.........0x84
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pkey..........=
=2E.........0xFFFF
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Rate..........=
=2E.........0x83
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SL............=
=2E.........0x0
> MCMemberRecord group dump:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MGID..........=
=2E.........ff12:601b:ffff::1:ff09:cb2b
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mlid..........=
=2E.........0xC007
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mtu...........=
=2E.........0x84
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pkey..........=
=2E.........0xFFFF
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Rate..........=
=2E.........0x83
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SL............=
=2E.........0x0
> MCMemberRecord group dump:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MGID..........=
=2E.........ff12:601b:ffff::1:ff24:3471
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mlid..........=
=2E.........0xC00B
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mtu...........=
=2E.........0x84
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pkey..........=
=2E.........0xFFFF
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Rate..........=
=2E.........0x83
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SL............=
=2E.........0x0
> MCMemberRecord group dump:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MGID..........=
=2E.........ff12:601b:ffff::1:ff24:3591
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mlid..........=
=2E.........0xC00A
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mtu...........=
=2E.........0x84
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pkey..........=
=2E.........0xFFFF
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Rate..........=
=2E.........0x83
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SL............=
=2E.........0x0
> MCMemberRecord group dump:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MGID..........=
=2E.........ff12:601b:ffff::1:ff25:2841
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mlid..........=
=2E.........0xC00E
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mtu...........=
=2E.........0x84
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pkey..........=
=2E.........0xFFFF
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Rate..........=
=2E.........0x83
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SL............=
=2E.........0x0
>
>
> And here's the mlid saquery information for each mlid:
>
> [root@labdisk01 ~]# saquery -m 0xC003
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PortGid.......=
=2E.........fe80::2:c902:25:2841 (labdisk01
> HCA-1)
> [root@labdisk01 ~]# saquery -m 0xC00C
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PortGid.......=
=2E.........fe80::2:c902:25:2841 (labdisk01
> HCA-1)
> [root@labdisk01 ~]# saquery -m 0xC002
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PortGid.......=
=2E.........fe80::2:c902:25:2841 (labdisk01
> HCA-1)
> [root@labdisk01 ~]# saquery -m 0xC005
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PortGid.......=
=2E.........fe80::2:c902:25:2841 (labdisk01
> HCA-1)
> [root@labdisk01 ~]# saquery -m 0xC00D
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PortGid.......=
=2E.........fe80::2:c902:25:2841 (labdisk01
> HCA-1)
> [root@labdisk01 ~]# saquery -m 0xC004
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PortGid.......=
=2E.........fe80::2:c902:25:2841 (labdisk01
> HCA-1)
> [root@labdisk01 ~]# saquery -m 0xC001
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PortGid.......=
=2E.........fe80::2:c903:9:cb2b (occupied HCA-1)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PortGid.......=
=2E.........fe80::2:c902:24:3471 (stagnate HCA-1)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PortGid.......=
=2E.........fe80::2:c902:24:3591 (innovate HCA-1)
> [root@labdisk01 ~]# saquery -m 0xC009
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PortGid.......=
=2E.........fe80::2:c903:9:cb2b (occupied HCA-1)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PortGid.......=
=2E.........fe80::2:c902:24:3471 (stagnate HCA-1)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PortGid.......=
=2E.........fe80::2:c902:24:3591 (innovate HCA-1)
> [root@labdisk01 ~]# saquery -m 0xC000
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PortGid.......=
=2E.........fe80::2:c903:9:cb2b (occupied HCA-1)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PortGid.......=
=2E.........fe80::2:c902:25:2841 (labdisk01
> HCA-1)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PortGid.......=
=2E.........fe80::2:c902:24:3471 (stagnate HCA-1)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PortGid.......=
=2E.........fe80::2:c902:24:3591 (innovate HCA-1)
> [root@labdisk01 ~]# saquery -m 0xC013
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PortGid.......=
=2E.........fe80::2:c902:25:2841 (labdisk01
> HCA-1)
> [root@labdisk01 ~]# saquery -m 0xC00F
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PortGid.......=
=2E.........fe80::2:c902:25:2841 (labdisk01
> HCA-1)
> [root@labdisk01 ~]# saquery -m 0xC011
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PortGid.......=
=2E.........fe80::2:c902:25:2841 (labdisk01
> HCA-1)
> [root@labdisk01 ~]# saquery -m 0xC014
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PortGid.......=
=2E.........fe80::2:c902:25:2841 (labdisk01
> HCA-1)
> [root@labdisk01 ~]# saquery -m 0xC010
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PortGid.......=
=2E.........fe80::2:c902:25:2841 (labdisk01
> HCA-1)
> [root@labdisk01 ~]# saquery -m 0xC012
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PortGid.......=
=2E.........fe80::2:c902:25:2841 (labdisk01
> HCA-1)
> [root@labdisk01 ~]# saquery -m 0xC008
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PortGid.......=
=2E.........fe80::2:c903:9:cb2b (occupied HCA-1)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PortGid.......=
=2E.........fe80::2:c902:25:2841 (labdisk01
> HCA-1)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PortGid.......=
=2E.........fe80::2:c902:24:3471 (stagnate HCA-1)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PortGid.......=
=2E.........fe80::2:c902:24:3591 (innovate HCA-1)
> [root@labdisk01 ~]# saquery -m 0xC006
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PortGid.......=
=2E.........fe80::2:c903:9:cb2b (occupied HCA-1)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PortGid.......=
=2E.........fe80::2:c902:25:2841 (labdisk01
> HCA-1)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PortGid.......=
=2E.........fe80::2:c902:24:3471 (stagnate HCA-1)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PortGid.......=
=2E.........fe80::2:c902:24:3591 (innovate HCA-1)
> [root@labdisk01 ~]# saquery -m 0xC007
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PortGid.......=
=2E.........fe80::2:c903:9:cb2b (occupied HCA-1)
> [root@labdisk01 ~]# saquery -m 0xC00B
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PortGid.......=
=2E.........fe80::2:c902:24:3471 (stagnate HCA-1)
> [root@labdisk01 ~]# saquery -m 0xC00A
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PortGid.......=
=2E.........fe80::2:c902:24:3591 (innovate HCA-1)
> [root@labdisk01 ~]# saquery -m 0xC00E
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PortGid.......=
=2E.........fe80::2:c902:25:2841 (labdisk01
> HCA-1)
>
>
> What is it that we're we looking for in this output?

The main thing was seeing whether the IPv4 broadcast group was formed
properly, what the members were, what the rate and MTU were, and
whether the other groups were properly inheriting those parameters and
this all looks fine to me.

So unless there's some other interesting messages in the OpenSM log, I
suggest thyat you retitle an email to ask about the ipoib create child
"Name not unique on network" error and lack of receive on the
subinterface. Looks to me like it may be that ipoib_vlan_add is
returning -ENOTUNIQ because it found a duplicate pkey on a
subinterface but then I don't understand where the subinterface came
from originally. I also don't understand why the subinterface isn't
receiving. Maybe try delete_child followed by create_child to see what
happens.

-- Hal

> Tom
>
>
>
>> -- Hal
>>
>>> Also, here's some junk from /var/log/messages, seemed like it might=
 be
>>> relevant, but maybe this is just IP stuff:
>>>
>>> Jul 22 14:38:37 labdisk01 kernel: ADDRCONF(NETDEV_UP): ib0.8004: li=
nk is
>>> not
>>> ready
>>> Jul 22 14:38:37 labdisk01 kernel: ADDRCONF(NETDEV_CHANGE): ib0.8004=
: link
>>> becomes ready
>>> Jul 22 14:38:39 labdisk01 avahi-daemon[4056]: New relevant interfac=
e
>>> ib0.8004.IPv6 for mDNS.
>>> Jul 22 14:38:39 labdisk01 avahi-daemon[4056]: Joining mDNS multicas=
t
>>> group
>>> on interface ib0.8004.IPv6 with address fe80::202:c902:25:2841.
>>> Jul 22 14:38:39 labdisk01 avahi-daemon[4056]: Registering new addre=
ss
>>> record
>>> for fe80::202:c902:25:2841 on ib0.8004.
>>> Jul 22 14:38:41 labdisk01 avahi-daemon[4056]: New relevant interfac=
e
>>> ib0.8004.IPv4 for mDNS.
>>> Jul 22 14:38:41 labdisk01 avahi-daemon[4056]: Joining mDNS multicas=
t
>>> group
>>> on interface ib0.8004.IPv4 with address 10.0.0.2.
>>> Jul 22 14:38:41 labdisk01 avahi-daemon[4056]: Registering new addre=
ss
>>> record
>>> for 10.0.0.2 on ib0.8004.
>>> Jul 22 14:39:22 labdisk01 kernel: ADDRCONF(NETDEV_UP): ib0.8005: li=
nk is
>>> not
>>> ready
>>> Jul 22 14:39:22 labdisk01 kernel: ADDRCONF(NETDEV_CHANGE): ib0.8005=
: link
>>> becomes ready
>>> Jul 22 14:39:24 labdisk01 avahi-daemon[4056]: New relevant interfac=
e
>>> ib0.8005.IPv6 for mDNS.
>>> Jul 22 14:39:24 labdisk01 avahi-daemon[4056]: Joining mDNS multicas=
t
>>> group
>>> on interface ib0.8005.IPv6 with address fe80::202:c902:25:2841.
>>> Jul 22 14:39:24 labdisk01 avahi-daemon[4056]: Registering new addre=
ss
>>> record
>>> for fe80::202:c902:25:2841 on ib0.8005.
>>> Jul 22 14:39:26 labdisk01 avahi-daemon[4056]: New relevant interfac=
e
>>> ib0.8005.IPv4 for mDNS.
>>> Jul 22 14:39:26 labdisk01 avahi-daemon[4056]: Joining mDNS multicas=
t
>>> group
>>> on interface ib0.8005.IPv4 with address 192.168.10.2.
>>> Jul 22 14:39:26 labdisk01 avahi-daemon[4056]: Registering new addre=
ss
>>> record
>>> for 192.168.10.2 on ib0.8005.
>>>
>>>
>>>
>>>>
>>>>> My plan was to create two child interfaces (0x8004 and 0x8005) an=
d then
>>>>> ifconfig ib0.8004 and ifconfig ib0.8005 to assign them to separat=
e
>>>>> subnets.
>>>>
>>>> That should be fine.
>>>>
>>>> -- Hal
>>>>
>>>>> Tom
>>>>>
>>>>>
>>>>>>
>>>>>> The pkey you are seeing is the only one for ib0 interface.
>>>>>>
>>>>>
>>>>>
>>>>>
>>>>>
>>>>>
>>>>>
>>>>>
>>>>>
>>>>>
>>>>>
>>>>>
>>>>>
>>>>>> If you want to have IPoIB interfaces on the other partitions too=
, you
>>>>>> need to set this up by creating a child interface on those nodes=
; you
>>>>>> had asked about that in a previous email
>>>>>>
>>>>>> (http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg04728=
=2Ehtml).
>>>>>>
>>>>>> -- Hal
>>>>>>
>>>>>>>
>>>>>>> I'm trying to run one ipoib subnet in each partition, and then
>>>>>>> eventually the goal is to have a different server that has 2 ch=
ild
>>>>>>> interfaces, one on each subnet. But it doesn't appear that my
>>>>>>> partition
>>>>>>> configuration is even correct. Is there a syntax error, or some=
thing
>>>>>>> else I am missing?
>>>>>>>
>>>>>>> Thanks,
>>>>>>>
>>>>>>> Tom
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> --
>>>>>>> Tom Ammon
>>>>>>> Network Engineer
>>>>>>> Office: 801.587.0976
>>>>>>> Mobile: 801.674.9273
>>>>>>>
>>>>>>> Center for High Performance Computing
>>>>>>> University of Utah
>>>>>>> http://www.chpc.utah.edu
>>>>>>> --
>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux=
-rdma"
>>>>>>> in
>>>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-i=
nfo.html
>>>>>>>
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
