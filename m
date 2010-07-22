From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: more partition questions
Date: Thu, 22 Jul 2010 14:08:11 -0400
Message-ID: <AANLkTinqUs3CHKW42SWUVdqLr3vX-ixMc4M8u2ZRnQfr@mail.gmail.com>
References: <4C448DCD.80809@utah.edu>
	<AANLkTikDh5Em28cj9WSy2nNC-vrcZe4MwFHOYt9OmeuU@mail.gmail.com>
	<4C487D8F.80203@utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C487D8F.80203-wbocuHtxKic@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Ammon <tom.ammon-wbocuHtxKic@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Tom,

On Thu, Jul 22, 2010 at 1:19 PM, Tom Ammon <tom.ammon-wbocuHtxKic@public.gmane.org> wrote:
> Hal,
>
> On 7/21/2010 2:45 PM, Hal Rosenstock wrote:
>>
>> Hi Tom,
>>
>> On 7/19/10, Tom Ammon<tom.ammon-wbocuHtxKic@public.gmane.org> =C2=A0wrote:
>>>
>>> I'm trying to set up partitions in a little test environment, and I=
'm
>>> having trouble.
>>>
>>> I have opensm running on a machine attached to the fabric, and smin=
fo on
>>> the other machines confirm that this is indeed the master SM. Here'=
s my
>>> /etc/opensm/partitions.conf:
>>>
>>> Default=3D0xffff , ipoib : ALL, SELF=3Dfull ;
>>> PartitionBlue=3D0x8004, ipoib : 0x0002c9030009cb3f=3Dfull,
>>> 0x0002c90200252841=3Dfull, 0x0002c90200243471=3Dfull ;
>>> PartitionRed=3D0x8005, ipoib : 0x0002c90200252841=3Dfull,
>>> 0x0002c90200243591=3Dfull, 0x0002c9030009cb2b=3Dfull ;
>>
>> You don't really need the 0x8000 bit on in the pkeys but I don't thi=
nk
>> it does any harm.
>>
>>> But when I go to the machine with port GUID 0x0002c90200243471, it
>>> doesn't appear that it's getting the pkey I wanted:
>>>
>>> [root@stagnate ~]# ibstat
>>> CA 'mthca0'
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CA type: MT23108
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Number of ports: 2
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Firmware version: 3.3.5
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Hardware version: a1
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Node GUID: 0x0002c90200243470
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0System image GUID: 0x0002c9020024=
3473
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Port 1:
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State=
: Active
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Physi=
cal state: LinkUp
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Rate:=
 10
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Base =
lid: 10
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LMC: =
0
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SM li=
d: 4
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Capab=
ility mask: 0x02510a68
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Port =
GUID: 0x0002c90200243471
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Port 2:
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State=
: Down
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Physi=
cal state: Polling
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Rate:=
 2
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Base =
lid: 0
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LMC: =
0
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SM li=
d: 0
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Capab=
ility mask: 0x02510a68
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Port =
GUID: 0x0002c90200243472
>>>
>>> [root@stagnate ~]# cat /sys/class/net/ib0/pkey
>>> 0xffff
>>
>> What does:
>>
>> smpquery pkeys 10 1
>>
>> say ? Do you see the other pkey(s) on that port ?
>
> [root@stagnate ~]# smpquery pkeys 10 1
> =C2=A0 0: 0x7fff 0x8004 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
> =C2=A0 8: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
> =C2=A016: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
> =C2=A024: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
> =C2=A032: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
> =C2=A040: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
> =C2=A048: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
> =C2=A056: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
> 64 pkeys capacity for this port
>
> So I see that both 7fff and 8004 are being assigned to this port. Is =
that
> okay?

Yes.

>  Is there any problem with the machine also being in the default
> partition?

No.

> As I look around at all of the machines with smpquery, it appears tha=
t they
> are all being assigned 7fff and the pkey that I assigned in partition=
s.conf.

Good.

> But the machine that I want to run 2 child interfaces on is having is=
sues.
> It's at LID 7 and here's what smpquery says:
>
> [root@stagnate ~]# smpquery pkeys 7 1
> =C2=A0 0: 0x7fff 0x8004 0x8005 0x0000 0x0000 0x0000 0x0000 0x0000
> =C2=A0 8: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
> =C2=A016: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
> =C2=A024: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
> =C2=A032: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
> =C2=A040: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
> =C2=A048: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
> =C2=A056: 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000 0x0000
> 64 pkeys capacity for this port
>
> So that's fine, but when I try to create a child interface I get this=
:
>
> [root@labdisk01 ~]# echo 0x8004 > /sys/class/net/ib0/create_child
> -bash: echo: write error: Name not unique on network

I don't know what cause that error. Maybe someone else can help here.

Are you sure the ib0 interface is OK ? What does ifconfig ib0 say ?

> My plan was to create two child interfaces (0x8004 and 0x8005) and th=
en
> ifconfig ib0.8004 and ifconfig ib0.8005 to assign them to separate su=
bnets.

That should be fine.

-- Hal

> Tom
>
>
>>
>> The pkey you are seeing is the only one for ib0 interface.
>>
>
>
>
>
>
>
>
>
>
>
>
>
>> If you want to have IPoIB interfaces on the other partitions too, yo=
u
>> need to set this up by creating a child interface on those nodes; yo=
u
>> had asked about that in a previous email
>> (http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg04728.htm=
l).
>>
>> -- Hal
>>
>>>
>>> I'm trying to run one ipoib subnet in each partition, and then
>>> eventually the goal is to have a different server that has 2 child
>>> interfaces, one on each subnet. But it doesn't appear that my parti=
tion
>>> configuration is even correct. Is there a syntax error, or somethin=
g
>>> else I am missing?
>>>
>>> Thanks,
>>>
>>> Tom
>>>
>>>
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
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rdm=
a" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
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
