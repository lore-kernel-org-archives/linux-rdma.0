From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: Errors from ibchecknet
Date: Thu, 2 Sep 2010 09:03:30 -0700
Message-ID: <20100902090330.093d8ba6.weiny2@llnl.gov>
References: <AANLkTi=EuVGxLyjMFMw=YZm38CPvCTbcxt104R-B_o_i@mail.gmail.com>
	<AANLkTikoYH+1tBzHX29uUnFGepFhfXdOkRHSX3OLW9g6@mail.gmail.com>
	<AANLkTikQ3jeNwtbR6zqpSvt7=YWatRhWfr60Q5of_FJR@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikQ3jeNwtbR6zqpSvt7=YWatRhWfr60Q5of_FJR-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Hartley <hartlch14-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2 Sep 2010 06:56:50 -0700
Chuck Hartley <hartlch14-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> We swapped in a different switch and see the same errors. The opensm
> logfile does not show any errors:

Could you run "ibstat" on the node with OpenSM running?

And "iblinkinfo" on the same node?

Send that output.

Ira

>=20
> -------------------------------------------------
> OpenSM 3.3.5
> Command Line Arguments:
>  Daemon mode
>  Log File: /var/log/opensm.log
> -------------------------------------------------
> OpenSM 3.3.5
>=20
> Sep 02 05:56:29 933684 [B53B8700] 0x80 -> OpenSM 3.3.5
> Entering DISCOVERING state
>=20
> Sep 02 05:56:29 934931 [B53B8700] 0x02 -> osm_vendor_init: 1000
> pending umads specified
> Sep 02 05:56:29 935079 [B53B8700] 0x80 -> Entering DISCOVERING state
> Using default GUID 0x2c90300032de1
> Entering MASTER state
>=20
> Sep 02 05:56:29 953763 [B53B8700] 0x02 -> osm_vendor_bind: Binding to
> port 0x2c90300032de1
> Sep 02 05:56:29 990146 [B53B8700] 0x02 -> osm_vendor_bind: Binding to
> port 0x2c90300032de1
> Sep 02 05:56:29 990240 [B53B8700] 0x02 -> osm_opensm_bind: Setting
> IS_SM on port 0x0002c90300032de1
> Sep 02 05:56:30 009040 [AF1DB710] 0x80 -> Entering MASTER state
> SUBNET UP
>=20
> Sep 02 05:56:30 009885 [AF1DB710] 0x02 -> osm_ucast_mgr_process:
> minhop tables configured on all switches
> Sep 02 05:56:30 014593 [AF1DB710] 0x80 -> SUBNET UP
>=20
>=20
> On Thu, Sep 2, 2010 at 8:56 AM, Hal Rosenstock <hal.rosenstock@gmail.=
com> wrote:
> > On Thu, Sep 2, 2010 at 8:34 AM, Chuck Hartley <hartlch14-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>=
 wrote:
> >> Hello,
> >>
> >> We installed 1.5.1 and are having problems getting the IB fabric
> >> working. ibv_devinfo shows the HCAs ports are ok and ibdiagnet rep=
orts
> >> no errors. However, ibchecknet shows that the switch ports are not
> >> being configured. =A0We have never seen this before and are at a l=
oss as
> >> to where the problem might be - would someone please point us in t=
he
> >> right direction to look? =A0Could it be a problem with the switch
> >> itself? Output from ibchecknet below.
> >>
> >>
> >> # ibchecknet
> >> Error check on lid 3 (Infiniscale-IV Mellanox Technologies) port a=
ll: =A0FAILED
> >> ibwarn: [26732] dump_perfcounters: PortXmitWait not indicated so
> >> ignore this counter
> >> #warn: Lid is not configured lid 3 port 7
> >> #warn: SM Lid is not configured
> >
> > Is there an SM running on your subnet ? If so, I think that the lac=
k
> > of an SM could account for all of the issues mentioned here.
> >
> > -- Hal
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://*vger.kernel.org/majordomo-info.html
>=20


--=20
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
