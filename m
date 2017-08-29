From: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] RDMA/qedr: Missing error code in qedr_init_user_queue()
Date: Tue, 29 Aug 2017 07:02:36 +0000
Message-ID: <DM2PR0701MB1392E1F3804F92DA2677812F889F0@DM2PR0701MB1392.namprd07.prod.outlook.com>
References: <20170825081839.5ahvp6pehrhyyf2z@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170825081839.5ahvp6pehrhyyf2z@mwanda>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon@mwanda" <Kalderon@mwanda>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dan Carpenter [mailto:dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
Sent: Friday, August 25, 2017 11:19 AM
> To: Amrani, Ram <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>; Kalderon@mwanda;
> Kalderon, Michal <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> Cc: Elior, Ariel <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>; Doug Ledford
> <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Hal
> Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [PATCH] RDMA/qedr: Missing error code in qedr_init_user_queue()
>=20
> We should return -ENOMEM if the kzalloc() fails.  We currently return
> success.
>=20
> Fixes: 69ad0e7fe845 ("RDMA/qedr: Add support for iWARP in user space")
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>=20
> diff --git a/drivers/infiniband/hw/qedr/verbs.c
> b/drivers/infiniband/hw/qedr/verbs.c
> index 4e14a558734b..bce4f79370e6 100644
> --- a/drivers/infiniband/hw/qedr/verbs.c
> +++ b/drivers/infiniband/hw/qedr/verbs.c
> @@ -821,8 +821,10 @@ static inline int qedr_init_user_queue(struct
> ib_ucontext *ib_ctx,
>  				   FW_PAGE_SHIFT);
>  	} else {
>  		q->pbl_tbl =3D kzalloc(sizeof(*q->pbl_tbl), GFP_KERNEL);
> -		if (!q->pbl_tbl)
> +		if (!q->pbl_tbl) {
> +			rc =3D -ENOMEM;
>  			goto err0;
> +		}
>  	}
>=20
>  	return 0;

Thanks, Dan

Acked-by: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
