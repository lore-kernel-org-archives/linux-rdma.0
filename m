From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: Configuration of cq->cqe is lower than entries by 1
Date: Mon, 14 Nov 2016 11:07:53 +0000
Message-ID: <SN1PR07MB22076C5DE03F1939603C554CF8BC0@SN1PR07MB2207.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Leon, All,
While inspecting MLX code as well as other vendors' I see that the actual n=
umber of cq->cqe is configured to be less by 1 than 'entries'. Why is that?

e.g.
struct ib_cq *mlx4_ib_create_cq(struct ib_device *ibdev,
                                const struct ib_cq_init_attr *attr,
                                struct ib_ucontext *context,
                                struct ib_udata *udata)
{
        ...
        cq->ibcq.cqe =3D entries - 1;
        ...
}


static int mlx4_alloc_resize_buf(struct mlx4_ib_dev *dev, struct mlx4_ib_cq=
 *cq,
                                  int entries)
{
        ...
        cq->resize_buf->cqe =3D entries - 1;	// this is later copied to cq-=
>ibcq.cqe
        ...
}

Thanks,
Ram

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
