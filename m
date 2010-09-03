From: Chuck Hartley <hartlch14-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Errors from ibchecknet
Date: Fri, 3 Sep 2010 17:04:37 -0400
Message-ID: <AANLkTi=zJWVk3KCiiQpuQd+Etuxc3JVTg48EeMQ_xV9C@mail.gmail.com>
References: <AANLkTi=EuVGxLyjMFMw=YZm38CPvCTbcxt104R-B_o_i@mail.gmail.com>
	<AANLkTikoYH+1tBzHX29uUnFGepFhfXdOkRHSX3OLW9g6@mail.gmail.com>
	<AANLkTikQ3jeNwtbR6zqpSvt7=YWatRhWfr60Q5of_FJR@mail.gmail.com>
	<20100902090330.093d8ba6.weiny2@llnl.gov>
	<AANLkTin=p2Mt223QS1oXfy6vi1RBNiF4HaQQcScfg5FP@mail.gmail.com>
	<20100902131614.440c3111.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100902131614.440c3111.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I checked another working  fabric here and also see the same warnings,
so it looks like the warnings are not really a problem.

Well, I assume that it is just IPoIB that isn't working. Since ibping
works, I believe that says the IB part is ok. Of course, I can't run
any of the perftools since they all need IPoIB to resolve the host IP.

Do you have any suggestions of what to check to diagnose the IPoIB
problem?  Specifically, can you think of any interaction with the
"normal" networking stuff in the kernel that might be misconfigured?
The reason I mention that is because I rebuilt/installed OFED (no
errors/warnings) and it is in its default configuration, which is
running well on other similar fabrics here.  Therefore I assume the
problem must be with the non-OFED stuff. Previously, whenever this
kind of problem cropped up it has always been because opensm was not
running. I did check that iptables was off, so it isn't a firewall
issue.

- Chuck


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
>> =A0 =A0 =A0 CA type: MT26428
>> =A0 =A0 =A0 Number of ports: 2
>> =A0 =A0 =A0 Firmware version: 2.6.0
>> =A0 =A0 =A0 Hardware version: a0
>> =A0 =A0 =A0 Node GUID: 0x0002c90300032de0
>> =A0 =A0 =A0 System image GUID: 0x0002c90300032de3
>> =A0 =A0 =A0 Port 1:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 State: Active
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 Physical state: LinkUp
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 Rate: 40
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 Base lid: 6
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 LMC: 0
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 SM lid: 6
>
> Well the SM lid is set here. =A0Is it set on the other nodes?
>
> I don't run ibchecknet usually but I am getting the same errors here =
on a
> working fabric...
>
> ibwarn: [13629] dump_perfcounters: PortXmitWait not indicated so igno=
re this counter
> #warn: Lid is not configured lid 37 port 2
> #warn: SM Lid is not configured
> Port check lid 37 port 2: =A0FAILED
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
>
> Chuck,
> Is it just that IPoIB is not working for you?
>
> Ira
>
>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 Capability mask: 0x0251086a
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 Port GUID: 0x0002c90300032de1
>> =A0 =A0 =A0 Port 2:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 State: Down
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 Physical state: Polling
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 Rate: 10
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 Base lid: 0
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 LMC: 0
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 SM lid: 0
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 Capability mask: 0x02510868
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 Port GUID: 0x0002c90300032de2
>> CA 'mthca0'
>> =A0 =A0 =A0 CA type: MT25204
>> =A0 =A0 =A0 Number of ports: 1
>> =A0 =A0 =A0 Firmware version: 1.2.0
>> =A0 =A0 =A0 Hardware version: a0
>> =A0 =A0 =A0 Node GUID: 0x003048c64c0c0000
>> =A0 =A0 =A0 System image GUID: 0x003048c64c0c0003
>> =A0 =A0 =A0 Port 1:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 State: Down
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 Physical state: Polling
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 Rate: 10
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 Base lid: 0
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 LMC: 0
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 SM lid: 0
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 Capability mask: 0x02510a68
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 Port GUID: 0x003048c64c0c0001
>>
>> # iblinkinfo
>> Switch 0x0002c9020041a7a0 Infiniscale-IV Mellanox Technologies:
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 =A01[ =A0] =3D=3D( 4X 10.0 Gbps Active/=
 =A0LinkUp)=3D=3D> =A0 =A0 =A0 5
>> 1[ =A0] " HCA-1" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 =A02[ =A0] =3D=3D( 4X 10.0 Gbps Active/=
 =A0LinkUp)=3D=3D> =A0 =A0 =A0 6
>> 1[ =A0] "linux70 HCA-1" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 =A03[ =A0] =3D=3D( 4X 10.0 Gbps Active/=
 =A0LinkUp)=3D=3D> =A0 =A0 =A0 7
>> 1[ =A0] "linux71 HCA-1" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 =A04[ =A0] =3D=3D( 4X 2.5 Gbps =A0 Down=
/ Polling)=3D=3D>
>> [ =A0] "" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 =A05[ =A0] =3D=3D( 4X 2.5 Gbps =A0 Down=
/ Polling)=3D=3D>
>> [ =A0] "" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 =A06[ =A0] =3D=3D( 4X 2.5 Gbps =A0 Down=
/ Polling)=3D=3D>
>> [ =A0] "" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 =A07[ =A0] =3D=3D( 4X 2.5 Gbps =A0 Down=
/ Polling)=3D=3D>
>> [ =A0] "" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 =A08[ =A0] =3D=3D( 4X 2.5 Gbps =A0 Down=
/ Polling)=3D=3D>
>> [ =A0] "" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 =A09[ =A0] =3D=3D( 4X 2.5 Gbps =A0 Down=
/ Polling)=3D=3D>
>> [ =A0] "" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 10[ =A0] =3D=3D( 4X 2.5 Gbps =A0 Down/ =
Polling)=3D=3D>
>> [ =A0] "" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 11[ =A0] =3D=3D( 4X 2.5 Gbps =A0 Down/ =
Polling)=3D=3D>
>> [ =A0] "" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 12[ =A0] =3D=3D( 4X 2.5 Gbps =A0 Down/ =
Polling)=3D=3D>
>> [ =A0] "" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 13[ =A0] =3D=3D( 4X 2.5 Gbps =A0 Down/ =
Polling)=3D=3D>
>> [ =A0] "" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 14[ =A0] =3D=3D( 4X 2.5 Gbps =A0 Down/ =
Polling)=3D=3D>
>> [ =A0] "" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 15[ =A0] =3D=3D( 4X 2.5 Gbps =A0 Down/ =
Polling)=3D=3D>
>> [ =A0] "" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 16[ =A0] =3D=3D( 4X 2.5 Gbps =A0 Down/ =
Polling)=3D=3D>
>> [ =A0] "" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 17[ =A0] =3D=3D( 4X 2.5 Gbps =A0 Down/ =
Polling)=3D=3D>
>> [ =A0] "" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 18[ =A0] =3D=3D( 4X 2.5 Gbps =A0 Down/ =
Polling)=3D=3D>
>> [ =A0] "" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 19[ =A0] =3D=3D( 4X 2.5 Gbps =A0 Down/ =
Polling)=3D=3D>
>> [ =A0] "" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 20[ =A0] =3D=3D( 4X 2.5 Gbps =A0 Down/ =
Polling)=3D=3D>
>> [ =A0] "" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 21[ =A0] =3D=3D( 4X 2.5 Gbps =A0 Down/ =
Polling)=3D=3D>
>> [ =A0] "" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 22[ =A0] =3D=3D( 4X 2.5 Gbps =A0 Down/ =
Polling)=3D=3D>
>> [ =A0] "" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 23[ =A0] =3D=3D( 4X 2.5 Gbps =A0 Down/ =
Polling)=3D=3D>
>> [ =A0] "" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 24[ =A0] =3D=3D( 4X 5.0 Gbps Active/ =A0=
LinkUp)=3D=3D> =A0 =A0 =A0 9
>> 1[ =A0] " HCA-1" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 25[ =A0] =3D=3D( 4X 5.0 Gbps Active/ =A0=
LinkUp)=3D=3D> =A0 =A0 =A0 8
>> 1[ =A0] " HCA-1" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 26[ =A0] =3D=3D( 4X 2.5 Gbps =A0 Down/ =
Polling)=3D=3D>
>> [ =A0] "" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 27[ =A0] =3D=3D( 4X 2.5 Gbps =A0 Down/ =
Polling)=3D=3D>
>> [ =A0] "" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 28[ =A0] =3D=3D( 4X 2.5 Gbps =A0 Down/ =
Polling)=3D=3D>
>> [ =A0] "" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 29[ =A0] =3D=3D( 4X 2.5 Gbps =A0 Down/ =
Polling)=3D=3D>
>> [ =A0] "" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 30[ =A0] =3D=3D( 4X 2.5 Gbps =A0 Down/ =
Polling)=3D=3D>
>> [ =A0] "" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 31[ =A0] =3D=3D( 4X 2.5 Gbps =A0 Down/ =
Polling)=3D=3D>
>> [ =A0] "" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 32[ =A0] =3D=3D( 4X 2.5 Gbps =A0 Down/ =
Polling)=3D=3D>
>> [ =A0] "" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 33[ =A0] =3D=3D( 4X 2.5 Gbps =A0 Down/ =
Polling)=3D=3D>
>> [ =A0] "" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 34[ =A0] =3D=3D( 4X 2.5 Gbps =A0 Down/ =
Polling)=3D=3D>
>> [ =A0] "" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 35[ =A0] =3D=3D( 4X 2.5 Gbps =A0 Down/ =
Polling)=3D=3D>
>> [ =A0] "" ( )
>> =A0 =A0 =A0 =A0 =A0 =A01 =A0 36[ =A0] =3D=3D( 4X 2.5 Gbps =A0 Down/ =
Polling)=3D=3D>
>> [ =A0] "" ( )
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
>> >> =A0Daemon mode
>> >> =A0Log File: /var/log/opensm.log
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
>> >> >> being configured. =A0We have never seen this before and are at=
 a loss as
>> >> >> to where the problem might be - would someone please point us =
in the
>> >> >> right direction to look? =A0Could it be a problem with the swi=
tch
>> >> >> itself? Output from ibchecknet below.
>> >> >>
>> >> >>
>> >> >> # ibchecknet
>> >> >> Error check on lid 3 (Infiniscale-IV Mellanox Technologies) po=
rt all: =A0FAILED
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
>> >> More majordomo info at =A0http://**vger.kernel.org/majordomo-info=
=2Ehtml
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
>> More majordomo info at =A0http://*vger.kernel.org/majordomo-info.htm=
l
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
