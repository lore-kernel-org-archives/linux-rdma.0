From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [ofw] ib-diags: compatability issue with ibstat
Date: Fri, 23 Sep 2011 09:13:46 -0400
Message-ID: <CAKzyTsyUnwJHu=pp=zvhbQ9qC97EVp1oqtkt_wRK3o8RWB9D-g@mail.gmail.com>
References: <1828884A29C6694DAF28B7E6B8A8237316E66F5B@ORSMSX101.amr.corp.intel.com>
	<20110921151349.140d95f6.weiny2@llnl.gov>
	<1828884A29C6694DAF28B7E6B8A8237316E6723E@ORSMSX101.amr.corp.intel.com>
	<20110921153254.06c77ebc.weiny2@llnl.gov>
	<20110921171408.4e4087c8.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110921171408.4e4087c8.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 21, 2011 at 8:14 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
> On Wed, 21 Sep 2011 15:32:54 -0700
> Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
>
>> On Wed, 21 Sep 2011 15:23:45 -0700
>> "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>
>> > > Does this mean "ibstatus" does not work on Windows?
>> >
>> > We do not support any of the scripts on windows. =C2=A0As far as I=
 could tell, the scripts look like they just do post-processing of avai=
lable output.
>> >
>>
>> Good to know, thanks.
>>
>> > > How are you proposing the addition to ibverbs? =C2=A0It seems th=
is would break ABI
>> > > there.
>> >
>> > On windows, libibumad uses libibverbs to obtain whatever data it n=
eeds. =C2=A0I'm assuming that a non-MAD application will eventually be =
able to use ibverbs to determine the rate, without needing to parse dat=
a from some file.
>> >
>> > > Does windows have sysfs like capabilities which would make the s=
eparate layer
>> > > clean?
>> >
>> > There's nothing like sysfs on windows. =C2=A0If the data is availa=
ble from ibverbs, windows could pull the data from there, even if the d=
iags do not want to rely on ibverbs on the linux side.
>> >
>>
>> To be clear I am not against using ibverbs on the linux side. =C2=A0=
It sounds like that would be the best move going forward.
>>
>
> Honestly, ibverbs supplies similar functionality in ibv_devinfo. =C2=A0=
:-/
>
> It seems both ibstat and ibstatus should be dropped and ibv_devinfo e=
nhanced to supply, Rate, Physical state, Capability Mask, and the trans=
port (on a per port basis)[*]. =C2=A0There might be some other function=
ality as well. =C2=A0Roland, ibv_devinfo, is in the examples directory.=
 =C2=A0Is there any reason this should not be used as the "official" to=
ol? =C2=A0If not I think we should use the code from ibv_devinfo as a b=
asis for ibstat. =C2=A0But I hate to see 2 implementations so close.

Even if ibv_devinfo is updated to include the additional information,
do we want to require libibverbs, etc. on any IB management machine
just for this ? That's not the case today on IB management nodes.

-- Hal

>
> Ira
>
> [*] There are cards which support this. =C2=A0However, ibverbs does n=
ot have a transport field for each port. =C2=A0Example:
>
> 15:54:10 > ibv_devinfo -d mlx4_1 | grep trans
> =C2=A0 =C2=A0 =C2=A0 =C2=A0transport: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0InfiniBand (0)
>
> 15:55:22 > ibstat mlx4_1 | grep Link
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Physical state=
: LinkUp
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Link layer: In=
finiBand
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Link layer: Et=
hernet
>
>
> Full output from ibstat:
>
> 15:55:32 > ibstat mlx4_1
> CA 'mlx4_1'
> =C2=A0 =C2=A0 =C2=A0 =C2=A0CA type: MT26428
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Number of ports: 2
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Firmware version: 2.9.1000
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Hardware version: b0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Node GUID: 0x0002c9030008e7f0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0System image GUID: 0x0002c9030008e7f3
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Port 1:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State: Initial=
izing
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Physical state=
: LinkUp
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Rate: 10
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Base lid: 0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LMC: 0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SM lid: 0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Capability mas=
k: 0x02510868
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Port GUID: 0x0=
002c9030008e7f1
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Link layer: In=
finiBand
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Port 2:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State: Down
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Physical state=
: Disabled
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Rate: 10
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Base lid: 0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LMC: 0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SM lid: 0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Capability mas=
k: 0x00010000
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Port GUID: 0x0=
202c9fffe08e7f1
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Link layer: Et=
hernet
>
>
>> Ira
>>
>> > - Sean
>>
>>
>> --
>> Ira Weiny
>> Math Programmer/Computer Scientist
>> Lawrence Livermore National Lab
>> 925-423-8008
>> weiny2-i2BcT+NCU+M@public.gmane.org
>
>
> --
> Ira Weiny
> Member of Technical Staff
> Lawrence Livermore National Lab
> 925-423-8008
> weiny2-i2BcT+NCU+M@public.gmane.org
> _______________________________________________
> ofw mailing list
> ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
> http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
