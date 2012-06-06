From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] IB/mlx4: Fix max_wqe capacity report for query device
Date: Wed, 6 Jun 2012 10:05:32 -0700
Message-ID: <CAL1RGDVG5o8j1sFQY6HFsfS6YNnbujRD9vQx06gJ_iCyMtjC7Q@mail.gmail.com>
References: <1337864889-20886-1-git-send-email-ogerlitz@mellanox.com> <1337864889-20886-3-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337864889-20886-3-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Looks OK, applied.  One question:

> =A0 =A0 =A0 =A0/* Sanity check RQ size before proceeding */
> - =A0 =A0 =A0 if (cap->max_recv_wr =A0> dev->dev->caps.max_wqes =A0||
> - =A0 =A0 =A0 =A0 =A0 cap->max_recv_sge > dev->dev->caps.max_rq_sg)
> + =A0 =A0 =A0 if (cap->max_recv_wr > dev->dev->caps.max_wqes - MLX4_I=
B_SQ_MAX_SPARE ||
> + =A0 =A0 =A0 =A0 =A0 cap->max_recv_sge >
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 min(dev->dev->caps.max_sq_sg, dev->dev-=
>caps.max_rq_sg))

Why do we need to check max_recv_sge against caps.max_sq_sg as well as
caps.max_rq_sg?

> @@ -329,8 +330,19 @@ static int set_rq_size(struct mlx4_ib_dev *dev, =
struct ib_qp_cap *cap,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0qp->rq.wqe_shift =3D ilog2(qp->rq.max_=
gs * sizeof (struct mlx4_wqe_data_seg));
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 cap->max_recv_wr =A0=3D qp->rq.max_post =3D qp->rq.wqe_=
cnt;
> - =A0 =A0 =A0 cap->max_recv_sge =3D qp->rq.max_gs;
> + =A0 =A0 =A0 /* leave userspace return values as they were, so as no=
t to break ABI */
> + =A0 =A0 =A0 if (is_user) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cap->max_recv_wr =A0=3D qp->rq.max_post=
 =3D qp->rq.wqe_cnt;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cap->max_recv_sge =3D qp->rq.max_gs;
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cap->max_recv_wr =A0=3D qp->rq.max_post=
 =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 min(dev->dev->caps.max_=
wqes - MLX4_IB_SQ_MAX_SPARE, qp->rq.wqe_cnt);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cap->max_recv_sge =3D min(qp->rq.max_gs=
,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 min(dev->dev->caps.max_sq_sg,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 dev->dev->caps.max_rq_sg));
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 /* We don't support inline sends for kernel QPs (yet) *=
/
> +

That comment looks like cut and paste detritus, I deleted it...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
