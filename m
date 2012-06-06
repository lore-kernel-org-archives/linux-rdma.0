From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 2/3] IB/mlx4: Fix max_wqe capacity report for query device
Date: Wed, 6 Jun 2012 20:26:29 +0300
Message-ID: <201206062026.29878.jackm@dev.mellanox.co.il>
References: <1337864889-20886-1-git-send-email-ogerlitz@mellanox.com> <1337864889-20886-3-git-send-email-ogerlitz@mellanox.com> <CAL1RGDVG5o8j1sFQY6HFsfS6YNnbujRD9vQx06gJ_iCyMtjC7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDVG5o8j1sFQY6HFsfS6YNnbujRD9vQx06gJ_iCyMtjC7Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wednesday 06 June 2012 20:05, Roland Dreier wrote:
> > =A0 =A0 =A0 =A0/* Sanity check RQ size before proceeding */
> > - =A0 =A0 =A0 if (cap->max_recv_wr =A0> dev->dev->caps.max_wqes =A0=
||
> > - =A0 =A0 =A0 =A0 =A0 cap->max_recv_sge > dev->dev->caps.max_rq_sg)
> > + =A0 =A0 =A0 if (cap->max_recv_wr > dev->dev->caps.max_wqes - MLX4=
_IB_SQ_MAX_SPARE ||
> > + =A0 =A0 =A0 =A0 =A0 cap->max_recv_sge >
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 min(dev->dev->caps.max_sq_sg, dev->de=
v->caps.max_rq_sg))
>=20
> Why do we need to check max_recv_sge against caps.max_sq_sg as well a=
s
> caps.max_rq_sg?
>=20
Because the HCA provides separate sizes for max_recv_sge and max_send_s=
ge, but
the IB spec only allows for a single max_sg_entries value.

We therefore enforce the lower limit of the 2.

-Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
