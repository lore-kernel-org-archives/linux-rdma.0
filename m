From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: rdma_create_qp() and max_send_wr
Date: Thu, 19 May 2011 18:59:23 +0200
Message-ID: <1305824364.2359.37.camel@deela.quest-ce.net>
References: <20110421115323.48b52fb35c6f209c51bccbb9807b6df0.f623dc4952.wbe@email17.secureserver.net>
	 <1303467645.2243.47.camel@deela.quest-ce.net>
	 <20110519060704.GA2659@mtldesk30>
	 <1305796637.2359.6.camel@deela.quest-ce.net>
	 <20110519093402.GB2659@mtldesk30>
	 <1305802216.2359.11.camel@deela.quest-ce.net>
	 <1828884A29C6694DAF28B7E6B8A82373FE8B@ORSMSX101.amr.corp.intel.com>
	 <1305816321.2359.15.camel@deela.quest-ce.net>
	 <1305817426.2359.23.camel@deela.quest-ce.net>
	 <20110519154650.GD2659@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110519154650.GD2659@mtldesk30>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "cait-DpaxOq6QOWMAvxtiuMwx3w@public.gmane.org" <cait-DpaxOq6QOWMAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Le jeudi 19 mai 2011 =C3=A0 18:46 +0300, Eli Cohen a =C3=A9crit :
> On Thu, May 19, 2011 at 05:03:45PM +0200, Yann Droneaud wrote:
> >=20
> > To sum up:
> >=20
> > - ibv_qp_init_attr.max_recv_wr can be set to ibv_device_attr.max_qp=
_wr,
> > 16384 in my case,
> > =20
> > - ibv_qp_init_attr.max_send_wr *cannot* be set to
> > ibv_device_attr.max_qp_wr, but it can be set to 16351.
> >=20
> Thanks for investigating this. We'll check and send a fix. Meanwhile
> you can workaround this in your code.

I understand the problem (which is probably not really a problem):

In libmlx4/src/verbs.c:mlx4_create_qp()

        mlx4_calc_sq_wqe_size(&attr->cap, attr->qp_type, qp);

        /*
         * We need to leave 2 KB + 1 WQE of headroom in the SQ to
         * allow HW to prefetch.
         */
        qp->sq_spare_wqes =3D (2048 >> qp->sq.wqe_shift) + 1;
        qp->sq.wqe_cnt =3D align_queue_size(attr->cap.max_send_wr +
qp->sq_spare_wqes);
        qp->rq.wqe_cnt =3D align_queue_size(attr->cap.max_recv_wr);

=46or a requested SQ length of 1:

 qp->sq.wge_shift : 6
 qp->sq_spare_wges : 33
 attr->cap.max_send_wr : 1
 qp->sq_wge_cnt : 64

=46or a requested SQ length of 16351:

 qp->sq.wge_shift : 6
 qp->sq_spare_wges : 33
 attr->cap.max_send_wr : 16351
 qp->sq_wge_cnt : 16384

=46or a requested SQ length of 16384:

 qp->sq.wge_shift : 6
 qp->sq_spare_wges : 33
 attr->cap.max_send_wr : 16384
 qp->sq_wge_cnt : 32768

32768 is clearly above the ibv_device_attr.max_qp_wr limit, so the
creation of the QP failed later:

        ret =3D ibv_cmd_create_qp(pd, &qp->ibv_qp, attr, &cmd.ibv_cmd,
sizeof cmd,
                                &resp, sizeof resp);

ibv_cmd_create_qp() fails and returns 22.


If spare WQEs are taken in account here, it should be taken in account
in the data reported by ibv_query_device().

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
