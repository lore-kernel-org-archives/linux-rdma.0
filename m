From: Yann Droneaud <yann-WYdEh2jsUj5Wj0EZb7rXcA@public.gmane.org>
Subject: RE: rdma_create_qp() and max_send_wr
Date: Thu, 19 May 2011 17:03:45 +0200
Message-ID: <1305817426.2359.23.camel@deela.quest-ce.net>
References: <20110421115323.48b52fb35c6f209c51bccbb9807b6df0.f623dc4952.wbe@email17.secureserver.net>
	 <1303467645.2243.47.camel@deela.quest-ce.net>
	 <20110519060704.GA2659@mtldesk30>
	 <1305796637.2359.6.camel@deela.quest-ce.net>
	 <20110519093402.GB2659@mtldesk30>
	 <1305802216.2359.11.camel@deela.quest-ce.net>
	 <1828884A29C6694DAF28B7E6B8A82373FE8B@ORSMSX101.amr.corp.intel.com>
	 <1305816321.2359.15.camel@deela.quest-ce.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1305816321.2359.15.camel-H/AUWmsJYVeqvyCYKW+Xr6xOck334EZe@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "cait-DpaxOq6QOWMAvxtiuMwx3w@public.gmane.org" <cait-DpaxOq6QOWMAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le jeudi 19 mai 2011 =C3=A0 16:45 +0200, Yann Droneaud a =C3=A9crit :

> So I'm a bit puzzled : why does it work in ibv_rc_pingpong but not in
> rdma_bw ?
>=20

Because ibv_rc_pingpong -r modify the max_recv_wr attributes=20
and rdma_bw -t modify the max_send_rw instead.

After modifiying ibv_rc_pingpong to set max_recv_wr attributes, it fail=
s
to create the QP when trying to use more than 16351 WR in the SQ.

To sum up:

- ibv_qp_init_attr.max_recv_wr can be set to ibv_device_attr.max_qp_wr,
16384 in my case,
=20
- ibv_qp_init_attr.max_send_wr *cannot* be set to
ibv_device_attr.max_qp_wr, but it can be set to 16351.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
