From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: RE: rdma_create_qp() and max_send_wr
Date: Thu, 19 May 2011 16:45:20 +0200
Message-ID: <1305816321.2359.15.camel@deela.quest-ce.net>
References: <20110421115323.48b52fb35c6f209c51bccbb9807b6df0.f623dc4952.wbe@email17.secureserver.net>
	 <1303467645.2243.47.camel@deela.quest-ce.net>
	 <20110519060704.GA2659@mtldesk30>
	 <1305796637.2359.6.camel@deela.quest-ce.net>
	 <20110519093402.GB2659@mtldesk30>
	 <1305802216.2359.11.camel@deela.quest-ce.net>
	 <1828884A29C6694DAF28B7E6B8A82373FE8B@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373FE8B-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "cait-DpaxOq6QOWMAvxtiuMwx3w@public.gmane.org" <cait-DpaxOq6QOWMAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le jeudi 19 mai 2011 =C3=A0 14:25 +0000, Hefty, Sean a =C3=A9crit :
> > Creating QP through ibv_create_qp() seems to allow use
> > of the maximum QP WR, but rmda_create_qp() limits to 16351.
>=20
> rdma_create_qp() passes the QP creation call straight through to ibv_=
create_qp(). =20

That's what I see when tracing the code in GDB.

> It will also allocate CQs if those don't already exist using the same=
=20
> limits as specified for the QP, which could be the reason for the=20
> failure.
>=20

The CQs are already allocated, I've also checked that with the debugger=
=2E

So I'm a bit puzzled : why does it work in ibv_rc_pingpong but not in
rdma_bw ?

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
