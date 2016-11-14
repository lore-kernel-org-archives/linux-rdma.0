From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Configuration of cq->cqe is lower than entries by 1
Date: Mon, 14 Nov 2016 14:01:53 +0200
Message-ID: <20161114120153.GC4240@leon.nu>
References: <SN1PR07MB22076C5DE03F1939603C554CF8BC0@SN1PR07MB2207.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ctP54qlpMx3WjD+/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <SN1PR07MB22076C5DE03F1939603C554CF8BC0-mikhvbZlbf8TSoR2DauN2+FPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--ctP54qlpMx3WjD+/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 14, 2016 at 11:07:53AM +0000, Amrani, Ram wrote:
> Hi Leon, All,
> While inspecting MLX code as well as other vendors' I see that the actual number of cq->cqe is configured to be less by 1 than 'entries'. Why is that?

There is addition of 1 in mlx4_ib_create_cq():
192         entries      = roundup_pow_of_two(entries + 1);
193         cq->ibcq.cqe = entries - 1;

The same goes for mlx4_alloc_resize_buf, just earlier in the stack.

>
> e.g.
> struct ib_cq *mlx4_ib_create_cq(struct ib_device *ibdev,
>                                 const struct ib_cq_init_attr *attr,
>                                 struct ib_ucontext *context,
>                                 struct ib_udata *udata)
> {
>         ...
>         cq->ibcq.cqe = entries - 1;
>         ...
> }
>
>
> static int mlx4_alloc_resize_buf(struct mlx4_ib_dev *dev, struct mlx4_ib_cq *cq,
>                                   int entries)
> {
>         ...
>         cq->resize_buf->cqe = entries - 1;	// this is later copied to cq->ibcq.cqe
>         ...
> }
>
> Thanks,
> Ram
>

--ctP54qlpMx3WjD+/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYKaexAAoJEORje4g2clinqYYP/1hW9b8z22VDpt9HAwFgge7P
Jo5qnmXt8Xz8THHJMmYeA4DoEhYsQfO99YoHqno60zwYNfqN9a2MxxaNm3wwYBHN
eRkWB6LOaHShv3Wd/qG8eDHgF2aqXNVMECw5u9E30ZmZ24MgFNoFpOuViKDD4rlT
pBkBllhMA53kw2AGxDWrdOM3ndFlQuytPu2KT3UUK/qW7RJhqP2LT/bynBLoyjFC
oSQrQMgaA1or0XDWricPQlT/S52sixuoR/OD864UcWyT7vm+/fT8bPiVy6ex9kmg
L2jZOJDVG0PxAVjseO6yWl0KF+xN7GJXnO+hS8wAvQ72ETYP21mAesl27dv4nCqG
pxjUIxNliJD2hch78rajUPVd6I6bR7SzM+qIRrONigoQOKyMRTICAms/Q3o/X7bT
kkcZ/9WourGCOvvYFO0Ao498IlaUD1qinJ7e+HSaoa2czk4JS3qmHnxbi6IxzeYv
8TH3cMgjrEtQV2qXMmSKnY4uFv4Wiqym0mk/FJBc4NVw4VHQmfGV8yLBqKmpmHKF
pOuDmk4tq9y9wN937fElPcKVRXqMKCuYmZluZqUxvSRNajQbykNgEi8QvqDC+dx6
zP1iSV8r0l/NC31RJqmyO70D671MDSzDleu3ATTJnuXjSiM/GwJhe57E+c4LMbUa
8oIJZ2YR1ij7/B3pu+pO
=hqj+
-----END PGP SIGNATURE-----

--ctP54qlpMx3WjD+/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
