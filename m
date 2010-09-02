From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Errors from ibchecknet
Date: Thu, 2 Sep 2010 16:34:38 -0400
Message-ID: <AANLkTimzaxf1792qK6WC1ek18x1UJZh0vwANc4UPK78T@mail.gmail.com>
References: <AANLkTi=EuVGxLyjMFMw=YZm38CPvCTbcxt104R-B_o_i@mail.gmail.com>
	<AANLkTikoYH+1tBzHX29uUnFGepFhfXdOkRHSX3OLW9g6@mail.gmail.com>
	<AANLkTikQ3jeNwtbR6zqpSvt7=YWatRhWfr60Q5of_FJR@mail.gmail.com>
	<20100902090330.093d8ba6.weiny2@llnl.gov>
	<AANLkTin=p2Mt223QS1oXfy6vi1RBNiF4HaQQcScfg5FP@mail.gmail.com>
	<20100902131614.440c3111.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100902131614.440c3111.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Chuck Hartley <hartlch14-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 2, 2010 at 4:16 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
> On Thu, 2 Sep 2010 11:11:13 -0700
> Chuck Hartley <hartlch14-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Sure, here is the output:
>> Note this is with the switch we swapped in, so the port numbers don'=
t
>> match the ibchecknet output in the original message.
>>
>> # ibstat
>> CA 'mlx4_0'
>> =C2=A0 =C2=A0 =C2=A0 CA type: MT26428
>> =C2=A0 =C2=A0 =C2=A0 Number of ports: 2
>> =C2=A0 =C2=A0 =C2=A0 Firmware version: 2.6.0
>> =C2=A0 =C2=A0 =C2=A0 Hardware version: a0
>> =C2=A0 =C2=A0 =C2=A0 Node GUID: 0x0002c90300032de0
>> =C2=A0 =C2=A0 =C2=A0 System image GUID: 0x0002c90300032de3
>> =C2=A0 =C2=A0 =C2=A0 Port 1:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State: Active
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Physical state: Lin=
kUp
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Rate: 40
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Base lid: 6
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 LMC: 0
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 SM lid: 6
>
> Well the SM lid is set here. =C2=A0Is it set on the other nodes?
>
> I don't run ibchecknet usually but I am getting the same errors here =
on a
> working fabric...
>
> ibwarn: [13629] dump_perfcounters: PortXmitWait not indicated so igno=
re this counter
> #warn: Lid is not configured lid 37 port 2
> #warn: SM Lid is not configured
> Port check lid 37 port 2: =C2=A0FAILED
>
> Looking at this output I don't think this is an error.
>
> 13:17:14 > smpquery nodeinfo 37
> # Node info: Lid 37
> BaseVers:........................1
> ClassVers:.......................1
> NodeType:........................Switch
> NumPorts:........................24
> ...
>
> On switch external Ports the Lid and SMLid are not used.
>
> Hal, would you concur?

Yes, on switch external ports, both LID and SMLID are not valid.

-- Hal

>
> Chuck,
> Is it just that IPoIB is not working for you?
>
> Ira
>
>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Capability mask: 0x=
0251086a
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Port GUID: 0x0002c9=
0300032de1
>> =C2=A0 =C2=A0 =C2=A0 Port 2:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State: Down
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Physical state: Pol=
ling
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Rate: 10
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Base lid: 0
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 LMC: 0
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 SM lid: 0
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Capability mask: 0x=
02510868
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Port GUID: 0x0002c9=
0300032de2
>> CA 'mthca0'
>> =C2=A0 =C2=A0 =C2=A0 CA type: MT25204
>> =C2=A0 =C2=A0 =C2=A0 Number of ports: 1
>> =C2=A0 =C2=A0 =C2=A0 Firmware version: 1.2.0
>> =C2=A0 =C2=A0 =C2=A0 Hardware version: a0
>> =C2=A0 =C2=A0 =C2=A0 Node GUID: 0x003048c64c0c0000
>> =C2=A0 =C2=A0 =C2=A0 System image GUID: 0x003048c64c0c0003
>> =C2=A0 =C2=A0 =C2=A0 Port 1:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State: Down
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Physical state: Pol=
ling
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Rate: 10
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Base lid: 0
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 LMC: 0
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 SM lid: 0
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Capability mask: 0x=
02510a68
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Port GUID: 0x003048=
c64c0c0001
>>
>> # iblinkinfo
>> Switch 0x0002c9020041a7a0 Infiniscale-IV Mellanox Technologies:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A01[ =C2=A0] =3D=
=3D( 4X 10.0 Gbps Active/ =C2=A0LinkUp)=3D=3D> =C2=A0 =C2=A0 =C2=A0 5
>> 1[ =C2=A0] " HCA-1" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A02[ =C2=A0] =3D=
=3D( 4X 10.0 Gbps Active/ =C2=A0LinkUp)=3D=3D> =C2=A0 =C2=A0 =C2=A0 6
>> 1[ =C2=A0] "linux70 HCA-1" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A03[ =C2=A0] =3D=
=3D( 4X 10.0 Gbps Active/ =C2=A0LinkUp)=3D=3D> =C2=A0 =C2=A0 =C2=A0 7
>> 1[ =C2=A0] "linux71 HCA-1" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A04[ =C2=A0] =3D=
=3D( 4X 2.5 Gbps =C2=A0 Down/ Polling)=3D=3D>
>> [ =C2=A0] "" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A05[ =C2=A0] =3D=
=3D( 4X 2.5 Gbps =C2=A0 Down/ Polling)=3D=3D>
>> [ =C2=A0] "" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A06[ =C2=A0] =3D=
=3D( 4X 2.5 Gbps =C2=A0 Down/ Polling)=3D=3D>
>> [ =C2=A0] "" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A07[ =C2=A0] =3D=
=3D( 4X 2.5 Gbps =C2=A0 Down/ Polling)=3D=3D>
>> [ =C2=A0] "" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A08[ =C2=A0] =3D=
=3D( 4X 2.5 Gbps =C2=A0 Down/ Polling)=3D=3D>
>> [ =C2=A0] "" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A09[ =C2=A0] =3D=
=3D( 4X 2.5 Gbps =C2=A0 Down/ Polling)=3D=3D>
>> [ =C2=A0] "" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 10[ =C2=A0] =3D=3D=
( 4X 2.5 Gbps =C2=A0 Down/ Polling)=3D=3D>
>> [ =C2=A0] "" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 11[ =C2=A0] =3D=3D=
( 4X 2.5 Gbps =C2=A0 Down/ Polling)=3D=3D>
>> [ =C2=A0] "" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 12[ =C2=A0] =3D=3D=
( 4X 2.5 Gbps =C2=A0 Down/ Polling)=3D=3D>
>> [ =C2=A0] "" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 13[ =C2=A0] =3D=3D=
( 4X 2.5 Gbps =C2=A0 Down/ Polling)=3D=3D>
>> [ =C2=A0] "" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 14[ =C2=A0] =3D=3D=
( 4X 2.5 Gbps =C2=A0 Down/ Polling)=3D=3D>
>> [ =C2=A0] "" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 15[ =C2=A0] =3D=3D=
( 4X 2.5 Gbps =C2=A0 Down/ Polling)=3D=3D>
>> [ =C2=A0] "" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 16[ =C2=A0] =3D=3D=
( 4X 2.5 Gbps =C2=A0 Down/ Polling)=3D=3D>
>> [ =C2=A0] "" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 17[ =C2=A0] =3D=3D=
( 4X 2.5 Gbps =C2=A0 Down/ Polling)=3D=3D>
>> [ =C2=A0] "" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 18[ =C2=A0] =3D=3D=
( 4X 2.5 Gbps =C2=A0 Down/ Polling)=3D=3D>
>> [ =C2=A0] "" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 19[ =C2=A0] =3D=3D=
( 4X 2.5 Gbps =C2=A0 Down/ Polling)=3D=3D>
>> [ =C2=A0] "" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 20[ =C2=A0] =3D=3D=
( 4X 2.5 Gbps =C2=A0 Down/ Polling)=3D=3D>
>> [ =C2=A0] "" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 21[ =C2=A0] =3D=3D=
( 4X 2.5 Gbps =C2=A0 Down/ Polling)=3D=3D>
>> [ =C2=A0] "" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 22[ =C2=A0] =3D=3D=
( 4X 2.5 Gbps =C2=A0 Down/ Polling)=3D=3D>
>> [ =C2=A0] "" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 23[ =C2=A0] =3D=3D=
( 4X 2.5 Gbps =C2=A0 Down/ Polling)=3D=3D>
>> [ =C2=A0] "" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 24[ =C2=A0] =3D=3D=
( 4X 5.0 Gbps Active/ =C2=A0LinkUp)=3D=3D> =C2=A0 =C2=A0 =C2=A0 9
>> 1[ =C2=A0] " HCA-1" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 25[ =C2=A0] =3D=3D=
( 4X 5.0 Gbps Active/ =C2=A0LinkUp)=3D=3D> =C2=A0 =C2=A0 =C2=A0 8
>> 1[ =C2=A0] " HCA-1" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 26[ =C2=A0] =3D=3D=
( 4X 2.5 Gbps =C2=A0 Down/ Polling)=3D=3D>
>> [ =C2=A0] "" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 27[ =C2=A0] =3D=3D=
( 4X 2.5 Gbps =C2=A0 Down/ Polling)=3D=3D>
>> [ =C2=A0] "" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 28[ =C2=A0] =3D=3D=
( 4X 2.5 Gbps =C2=A0 Down/ Polling)=3D=3D>
>> [ =C2=A0] "" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 29[ =C2=A0] =3D=3D=
( 4X 2.5 Gbps =C2=A0 Down/ Polling)=3D=3D>
>> [ =C2=A0] "" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 30[ =C2=A0] =3D=3D=
( 4X 2.5 Gbps =C2=A0 Down/ Polling)=3D=3D>
>> [ =C2=A0] "" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 31[ =C2=A0] =3D=3D=
( 4X 2.5 Gbps =C2=A0 Down/ Polling)=3D=3D>
>> [ =C2=A0] "" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 32[ =C2=A0] =3D=3D=
( 4X 2.5 Gbps =C2=A0 Down/ Polling)=3D=3D>
>> [ =C2=A0] "" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 33[ =C2=A0] =3D=3D=
( 4X 2.5 Gbps =C2=A0 Down/ Polling)=3D=3D>
>> [ =C2=A0] "" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 34[ =C2=A0] =3D=3D=
( 4X 2.5 Gbps =C2=A0 Down/ Polling)=3D=3D>
>> [ =C2=A0] "" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 35[ =C2=A0] =3D=3D=
( 4X 2.5 Gbps =C2=A0 Down/ Polling)=3D=3D>
>> [ =C2=A0] "" ( )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 36[ =C2=A0] =3D=3D=
( 4X 2.5 Gbps =C2=A0 Down/ Polling)=3D=3D>
>> [ =C2=A0] "" ( )
>>
>> On Thu, Sep 2, 2010 at 12:03 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
>> > On Thu, 2 Sep 2010 06:56:50 -0700
>> > Chuck Hartley <hartlch14-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >
>> >> We swapped in a different switch and see the same errors. The ope=
nsm
>> >> logfile does not show any errors:
>> >
>> > Could you run "ibstat" on the node with OpenSM running?
>> >
>> > And "iblinkinfo" on the same node?
>> >
>> > Send that output.
>> >
>> > Ira
>> >
>> >>
>> >> -------------------------------------------------
>> >> OpenSM 3.3.5
>> >> Command Line Arguments:
>> >> =C2=A0Daemon mode
>> >> =C2=A0Log File: /var/log/opensm.log
>> >> -------------------------------------------------
>> >> OpenSM 3.3.5
>> >>
>> >> Sep 02 05:56:29 933684 [B53B8700] 0x80 -> OpenSM 3.3.5
>> >> Entering DISCOVERING state
>> >>
>> >> Sep 02 05:56:29 934931 [B53B8700] 0x02 -> osm_vendor_init: 1000
>> >> pending umads specified
>> >> Sep 02 05:56:29 935079 [B53B8700] 0x80 -> Entering DISCOVERING st=
ate
>> >> Using default GUID 0x2c90300032de1
>> >> Entering MASTER state
>> >>
>> >> Sep 02 05:56:29 953763 [B53B8700] 0x02 -> osm_vendor_bind: Bindin=
g to
>> >> port 0x2c90300032de1
>> >> Sep 02 05:56:29 990146 [B53B8700] 0x02 -> osm_vendor_bind: Bindin=
g to
>> >> port 0x2c90300032de1
>> >> Sep 02 05:56:29 990240 [B53B8700] 0x02 -> osm_opensm_bind: Settin=
g
>> >> IS_SM on port 0x0002c90300032de1
>> >> Sep 02 05:56:30 009040 [AF1DB710] 0x80 -> Entering MASTER state
>> >> SUBNET UP
>> >>
>> >> Sep 02 05:56:30 009885 [AF1DB710] 0x02 -> osm_ucast_mgr_process:
>> >> minhop tables configured on all switches
>> >> Sep 02 05:56:30 014593 [AF1DB710] 0x80 -> SUBNET UP
>> >>
>> >>
>> >> On Thu, Sep 2, 2010 at 8:56 AM, Hal Rosenstock <hal.rosenstock@gm=
ail.com> wrote:
>> >> > On Thu, Sep 2, 2010 at 8:34 AM, Chuck Hartley <hartlch14@gmail.=
com> wrote:
>> >> >> Hello,
>> >> >>
>> >> >> We installed 1.5.1 and are having problems getting the IB fabr=
ic
>> >> >> working. ibv_devinfo shows the HCAs ports are ok and ibdiagnet=
 reports
>> >> >> no errors. However, ibchecknet shows that the switch ports are=
 not
>> >> >> being configured. =C2=A0We have never seen this before and are=
 at a loss as
>> >> >> to where the problem might be - would someone please point us =
in the
>> >> >> right direction to look? =C2=A0Could it be a problem with the =
switch
>> >> >> itself? Output from ibchecknet below.
>> >> >>
>> >> >>
>> >> >> # ibchecknet
>> >> >> Error check on lid 3 (Infiniscale-IV Mellanox Technologies) po=
rt all: =C2=A0FAILED
>> >> >> ibwarn: [26732] dump_perfcounters: PortXmitWait not indicated =
so
>> >> >> ignore this counter
>> >> >> #warn: Lid is not configured lid 3 port 7
>> >> >> #warn: SM Lid is not configured
>> >> >
>> >> > Is there an SM running on your subnet ? If so, I think that the=
 lack
>> >> > of an SM could account for all of the issues mentioned here.
>> >> >
>> >> > -- Hal
>> >> >
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-r=
dma" in
>> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> >> More majordomo info at =C2=A0http://**vger.kernel.org/majordomo-i=
nfo.html
>> >>
>> >
>> >
>> > --
>> > Ira Weiny
>> > Math Programmer/Computer Scientist
>> > Lawrence Livermore National Lab
>> > 925-423-8008
>> > weiny2-i2BcT+NCU+M@public.gmane.org
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =C2=A0http://*vger.kernel.org/majordomo-info.=
html
>>
>
>
> --
> Ira Weiny
> Math Programmer/Computer Scientist
> Lawrence Livermore National Lab
> 925-423-8008
> weiny2-i2BcT+NCU+M@public.gmane.org
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
