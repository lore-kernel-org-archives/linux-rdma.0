From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 1/6] IB/uverbs: Allow CQ moderation with
 modify CQ
Date: Mon, 30 Oct 2017 17:28:15 +0200
Message-ID: <20171030152815.GA16127@mtr-leonro.local>
References: <20171029135140.32649-1-leon@kernel.org>
 <20171029135140.32649-2-leon@kernel.org>
 <20171029174345.GC4488@ziepe.ca>
 <20171029182808.GN16127@mtr-leonro.local>
 <20171030144807.GA12392@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hIhQBbMWEy++B+zM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171030144807.GA12392-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--hIhQBbMWEy++B+zM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 30, 2017 at 08:48:07AM -0600, Jason Gunthorpe wrote:
> On Sun, Oct 29, 2017 at 08:28:08PM +0200, Leon Romanovsky wrote:
>
> > > > +int ib_uverbs_ex_modify_cq(struct ib_uverbs_file *file,
> > > > +			   struct ib_device *ib_dev,
> > > > +			   struct ib_udata *ucore,
> > > > +			   struct ib_udata *uhw)
> > >
> > > Is this really a good idea?
> > >
> > > Why not ib_uverbs_set_cq_moderation ?
> >
> > It follows already existed ib_modify_cq(), see commit 2dd571622787
> > ("IB/core: Add support for modify CQ")
>
> And that function should have been called set_cq_moderation:
>
> + * ib_modify_cq - Modifies moderation params of the CQ
> + * @cq: The CQ to modify.
> + * @cq_count: number of CQEs that will trigger an event
> + * @cq_period: max period of time in usec before triggering an event
> + *
> + */
> +int ib_modify_cq(struct ib_cq *cq, u16 cq_count, u16 cq_period);

I see it differently, this is extendable version of modify_cq, which is
going to benefit all other users who will decide to extend it.

Thanks

>
> Jason

--hIhQBbMWEy++B+zM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln3RQ8ACgkQ5GN7iDZy
WKfItw//ed2Bs8FE6P5AbPjn1UtHq6MPYyThI7AMUCzytgVqjAlVlUFKQv0OULoO
xNLisnXyTW3vHmere2x1gzX1TmRf6wQ5mN4XzC6P5c7Z3uDNyBuWVz40ocUBEBfa
xbxP3JHuqGRoOv5K0ryKbdbl1FnHsq4E3vq7ppH8DE1qnZCIuiMhqMdyTz4l40DL
GIih3sDcr+1LRBE3ycUu5kVZwdd4IcyQDcbArk0QC7O33T2Xvzfy9kUJ1qZQ6pPA
91ztlbdKf7iHCfU7J5U1NifS1+FNw4gViATrNPcu1xE/AaFwEKTjCblZwNEPwRAm
GytzbmBPl+ytGXj5hlTG4WHzAkKRYefucARIrSZTaj2gDLjAt5ZDS0dHk43dk2Pa
PDX1ZCLN8sAIxVFuLSFVhJ0I7PMtg42mI8goW+m3MUDzcy/taLerHl5Wuvd6z55Z
8Wr5sXOHNG8u8+xYE5QWFVglD9hscHIrtpGhHMWZZSlEJV49UQTF1P3nY7W2aQZ/
4bZ9c7FW7oxqu5ZPKcYkIERKZ7MZzXt39x1CnppYJHJ+Wx4GYH6nQNFFxyfqSuqn
qoXHSx7xCr3/EcualJIkC6WrhjqXmGTNByX+5Db+et4cGxHJy1NoYdHAKxiQDyAl
6rMpyzNfsBHGzDaAcli2DPFrpesABm0rnenS2mIL0jnAJw3FiMw=
=Hj0c
-----END PGP SIGNATURE-----

--hIhQBbMWEy++B+zM--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
