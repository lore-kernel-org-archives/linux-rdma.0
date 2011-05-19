From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: rdma_create_qp() and max_send_wr
Date: Thu, 19 May 2011 12:50:13 +0200
Message-ID: <1305802216.2359.11.camel@deela.quest-ce.net>
References: <20110421115323.48b52fb35c6f209c51bccbb9807b6df0.f623dc4952.wbe@email17.secureserver.net>
	 <1303467645.2243.47.camel@deela.quest-ce.net>
	 <20110519060704.GA2659@mtldesk30>
	 <1305796637.2359.6.camel@deela.quest-ce.net>
	 <20110519093402.GB2659@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110519093402.GB2659@mtldesk30>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: cait-DpaxOq6QOWMAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Le jeudi 19 mai 2011 =C3=A0 12:34 +0300, Eli Cohen a =C3=A9crit :
> On Thu, May 19, 2011 at 11:17:16AM +0200, Yann Droneaud wrote:
> >=20
> > Have you some test code for me to test ?
> >=20
>=20
> I used ibv_rc_pingpong which is part of libiberbs. the '-r' option
> allows you to define the queue depth. Please try it and let me know.

ibv_rc_pingpong works well with the max value eg 16384.
but ib_rdma_bw doesn't:

ib_rdma_bw -t 16384 doesn't work, but ib_rdma_bw -t 16351 does.

Creating QP through ibv_create_qp() seems to allow use=20
of the maximum QP WR, but rmda_create_qp() limits to 16351.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
