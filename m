From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] qedr: Fix missing unlock on error in qedr_post_send()
Date: Tue, 1 Nov 2016 14:09:42 +0000
Message-ID: <SN1PR07MB22074858C222B214F03D8ED7F8A10@SN1PR07MB2207.namprd07.prod.outlook.com>
References: <1477672406-31487-1-git-send-email-weiyj.lk@gmail.com>
 <20161031053835.GV3617@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161031053835.GV3617-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Borundia, Rajesh" <Rajesh.Borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > index a615142..e7c7417 100644
> > --- a/drivers/infiniband/hw/qedr/verbs.c
> > +++ b/drivers/infiniband/hw/qedr/verbs.c
> > @@ -2983,7 +2983,8 @@ int qedr_post_send(struct ib_qp *ibqp, struct
> > ib_send_wr *wr,
> >
> >  	if (!wr) {
> >  		DP_ERR(dev, "Got an empty post send.\n");
> > -		return -EINVAL;
> > +		rc =3D -EINVAL;
> > +		goto out_unlock;
> >  	}
>=20
> IMHO, this if needs to be moved to be before acquiring spinlock and avoid
> introducing new labels for this one case only.
>=20

Thanks Wei and Leon.

Actually, perhaps we can totally remove the check itself -
Since this is kernel space, is it safe to presume that all ULPs are trusted=
 to be well coded?
(if not, and as a side note, I see that in MLX4 there's a for(..;wr;..) loo=
p, but that wr is=20
dereferenced earlier so perhaps this is a potential bug)

Ram


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
