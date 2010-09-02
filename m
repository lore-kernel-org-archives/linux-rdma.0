From: Chuck Hartley <hartlch14-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Errors from ibchecknet
Date: Thu, 2 Sep 2010 14:11:13 -0400
Message-ID: <AANLkTin=p2Mt223QS1oXfy6vi1RBNiF4HaQQcScfg5FP@mail.gmail.com>
References: <AANLkTi=EuVGxLyjMFMw=YZm38CPvCTbcxt104R-B_o_i@mail.gmail.com>
	<AANLkTikoYH+1tBzHX29uUnFGepFhfXdOkRHSX3OLW9g6@mail.gmail.com>
	<AANLkTikQ3jeNwtbR6zqpSvt7=YWatRhWfr60Q5of_FJR@mail.gmail.com>
	<20100902090330.093d8ba6.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100902090330.093d8ba6.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sure, here is the output:
Note this is with the switch we swapped in, so the port numbers don't
match the ibchecknet output in the original message.

# ibstat
CA 'mlx4_0'
	CA type: MT26428
	Number of ports: 2
	Firmware version: 2.6.0
	Hardware version: a0
	Node GUID: 0x0002c90300032de0
	System image GUID: 0x0002c90300032de3
	Port 1:
		State: Active
		Physical state: LinkUp
		Rate: 40
		Base lid: 6
		LMC: 0
		SM lid: 6
		Capability mask: 0x0251086a
		Port GUID: 0x0002c90300032de1
	Port 2:
		State: Down
		Physical state: Polling
		Rate: 10
		Base lid: 0
		LMC: 0
		SM lid: 0
		Capability mask: 0x02510868
		Port GUID: 0x0002c90300032de2
CA 'mthca0'
	CA type: MT25204
	Number of ports: 1
	Firmware version: 1.2.0
	Hardware version: a0
	Node GUID: 0x003048c64c0c0000
	System image GUID: 0x003048c64c0c0003
	Port 1:
		State: Down
		Physical state: Polling
		Rate: 10
		Base lid: 0
		LMC: 0
		SM lid: 0
		Capability mask: 0x02510a68
		Port GUID: 0x003048c64c0c0001

# iblinkinfo
Switch 0x0002c9020041a7a0 Infiniscale-IV Mellanox Technologies:
           1    1[  ] =3D=3D( 4X 10.0 Gbps Active/  LinkUp)=3D=3D>     =
  5
1[  ] " HCA-1" ( )
           1    2[  ] =3D=3D( 4X 10.0 Gbps Active/  LinkUp)=3D=3D>     =
  6
1[  ] "linux70 HCA-1" ( )
           1    3[  ] =3D=3D( 4X 10.0 Gbps Active/  LinkUp)=3D=3D>     =
  7
1[  ] "linux71 HCA-1" ( )
           1    4[  ] =3D=3D( 4X 2.5 Gbps   Down/ Polling)=3D=3D>
[  ] "" ( )
           1    5[  ] =3D=3D( 4X 2.5 Gbps   Down/ Polling)=3D=3D>
[  ] "" ( )
           1    6[  ] =3D=3D( 4X 2.5 Gbps   Down/ Polling)=3D=3D>
[  ] "" ( )
           1    7[  ] =3D=3D( 4X 2.5 Gbps   Down/ Polling)=3D=3D>
[  ] "" ( )
           1    8[  ] =3D=3D( 4X 2.5 Gbps   Down/ Polling)=3D=3D>
[  ] "" ( )
           1    9[  ] =3D=3D( 4X 2.5 Gbps   Down/ Polling)=3D=3D>
[  ] "" ( )
           1   10[  ] =3D=3D( 4X 2.5 Gbps   Down/ Polling)=3D=3D>
[  ] "" ( )
           1   11[  ] =3D=3D( 4X 2.5 Gbps   Down/ Polling)=3D=3D>
[  ] "" ( )
           1   12[  ] =3D=3D( 4X 2.5 Gbps   Down/ Polling)=3D=3D>
[  ] "" ( )
           1   13[  ] =3D=3D( 4X 2.5 Gbps   Down/ Polling)=3D=3D>
[  ] "" ( )
           1   14[  ] =3D=3D( 4X 2.5 Gbps   Down/ Polling)=3D=3D>
[  ] "" ( )
           1   15[  ] =3D=3D( 4X 2.5 Gbps   Down/ Polling)=3D=3D>
[  ] "" ( )
           1   16[  ] =3D=3D( 4X 2.5 Gbps   Down/ Polling)=3D=3D>
[  ] "" ( )
           1   17[  ] =3D=3D( 4X 2.5 Gbps   Down/ Polling)=3D=3D>
[  ] "" ( )
           1   18[  ] =3D=3D( 4X 2.5 Gbps   Down/ Polling)=3D=3D>
[  ] "" ( )
           1   19[  ] =3D=3D( 4X 2.5 Gbps   Down/ Polling)=3D=3D>
[  ] "" ( )
           1   20[  ] =3D=3D( 4X 2.5 Gbps   Down/ Polling)=3D=3D>
[  ] "" ( )
           1   21[  ] =3D=3D( 4X 2.5 Gbps   Down/ Polling)=3D=3D>
[  ] "" ( )
           1   22[  ] =3D=3D( 4X 2.5 Gbps   Down/ Polling)=3D=3D>
[  ] "" ( )
           1   23[  ] =3D=3D( 4X 2.5 Gbps   Down/ Polling)=3D=3D>
[  ] "" ( )
           1   24[  ] =3D=3D( 4X 5.0 Gbps Active/  LinkUp)=3D=3D>      =
 9
1[  ] " HCA-1" ( )
           1   25[  ] =3D=3D( 4X 5.0 Gbps Active/  LinkUp)=3D=3D>      =
 8
1[  ] " HCA-1" ( )
           1   26[  ] =3D=3D( 4X 2.5 Gbps   Down/ Polling)=3D=3D>
[  ] "" ( )
           1   27[  ] =3D=3D( 4X 2.5 Gbps   Down/ Polling)=3D=3D>
[  ] "" ( )
           1   28[  ] =3D=3D( 4X 2.5 Gbps   Down/ Polling)=3D=3D>
[  ] "" ( )
           1   29[  ] =3D=3D( 4X 2.5 Gbps   Down/ Polling)=3D=3D>
[  ] "" ( )
           1   30[  ] =3D=3D( 4X 2.5 Gbps   Down/ Polling)=3D=3D>
[  ] "" ( )
           1   31[  ] =3D=3D( 4X 2.5 Gbps   Down/ Polling)=3D=3D>
[  ] "" ( )
           1   32[  ] =3D=3D( 4X 2.5 Gbps   Down/ Polling)=3D=3D>
[  ] "" ( )
           1   33[  ] =3D=3D( 4X 2.5 Gbps   Down/ Polling)=3D=3D>
[  ] "" ( )
           1   34[  ] =3D=3D( 4X 2.5 Gbps   Down/ Polling)=3D=3D>
[  ] "" ( )
           1   35[  ] =3D=3D( 4X 2.5 Gbps   Down/ Polling)=3D=3D>
[  ] "" ( )
           1   36[  ] =3D=3D( 4X 2.5 Gbps   Down/ Polling)=3D=3D>
[  ] "" ( )

On Thu, Sep 2, 2010 at 12:03 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
> On Thu, 2 Sep 2010 06:56:50 -0700
> Chuck Hartley <hartlch14-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> We swapped in a different switch and see the same errors. The opensm
>> logfile does not show any errors:
>
> Could you run "ibstat" on the node with OpenSM running?
>
> And "iblinkinfo" on the same node?
>
> Send that output.
>
> Ira
>
>>
>> -------------------------------------------------
>> OpenSM 3.3.5
>> Command Line Arguments:
>> =A0Daemon mode
>> =A0Log File: /var/log/opensm.log
>> -------------------------------------------------
>> OpenSM 3.3.5
>>
>> Sep 02 05:56:29 933684 [B53B8700] 0x80 -> OpenSM 3.3.5
>> Entering DISCOVERING state
>>
>> Sep 02 05:56:29 934931 [B53B8700] 0x02 -> osm_vendor_init: 1000
>> pending umads specified
>> Sep 02 05:56:29 935079 [B53B8700] 0x80 -> Entering DISCOVERING state
>> Using default GUID 0x2c90300032de1
>> Entering MASTER state
>>
>> Sep 02 05:56:29 953763 [B53B8700] 0x02 -> osm_vendor_bind: Binding t=
o
>> port 0x2c90300032de1
>> Sep 02 05:56:29 990146 [B53B8700] 0x02 -> osm_vendor_bind: Binding t=
o
>> port 0x2c90300032de1
>> Sep 02 05:56:29 990240 [B53B8700] 0x02 -> osm_opensm_bind: Setting
>> IS_SM on port 0x0002c90300032de1
>> Sep 02 05:56:30 009040 [AF1DB710] 0x80 -> Entering MASTER state
>> SUBNET UP
>>
>> Sep 02 05:56:30 009885 [AF1DB710] 0x02 -> osm_ucast_mgr_process:
>> minhop tables configured on all switches
>> Sep 02 05:56:30 014593 [AF1DB710] 0x80 -> SUBNET UP
>>
>>
>> On Thu, Sep 2, 2010 at 8:56 AM, Hal Rosenstock <hal.rosenstock@gmail=
=2Ecom> wrote:
>> > On Thu, Sep 2, 2010 at 8:34 AM, Chuck Hartley <hartlch14-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org=
> wrote:
>> >> Hello,
>> >>
>> >> We installed 1.5.1 and are having problems getting the IB fabric
>> >> working. ibv_devinfo shows the HCAs ports are ok and ibdiagnet re=
ports
>> >> no errors. However, ibchecknet shows that the switch ports are no=
t
>> >> being configured. =A0We have never seen this before and are at a =
loss as
>> >> to where the problem might be - would someone please point us in =
the
>> >> right direction to look? =A0Could it be a problem with the switch
>> >> itself? Output from ibchecknet below.
>> >>
>> >>
>> >> # ibchecknet
>> >> Error check on lid 3 (Infiniscale-IV Mellanox Technologies) port =
all: =A0FAILED
>> >> ibwarn: [26732] dump_perfcounters: PortXmitWait not indicated so
>> >> ignore this counter
>> >> #warn: Lid is not configured lid 3 port 7
>> >> #warn: SM Lid is not configured
>> >
>> > Is there an SM running on your subnet ? If so, I think that the la=
ck
>> > of an SM could account for all of the issues mentioned here.
>> >
>> > -- Hal
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
