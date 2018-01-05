From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v2 06/14] {net,IB}/mlx5: Manage port
 association for multiport RoCE
Date: Fri, 5 Jan 2018 08:36:41 +0200
Message-ID: <20180105063641.GC10145@mtr-leonro.local>
References: <20180104152544.28919-1-leon@kernel.org>
 <20180104152544.28919-7-leon@kernel.org>
 <20180104233334.GA18993@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YwTTlJgQ7QoYB9ta"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180104233334.GA18993-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--YwTTlJgQ7QoYB9ta
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 04, 2018 at 04:33:34PM -0700, Jason Gunthorpe wrote:
> > +struct mlx5_ib_odp {
> > +	struct ib_odp_caps	caps;
> > +	u64			max_size;
> > +	/*
> > +	 * Sleepable RCU that prevents destruction of MRs while they are still
> > +	 * being used by a page fault handler.
> > +	 */
> > +	struct srcu_struct      mr_srcu;
> > +	u32			null_mkey;
> > +	void			(*sync)(struct mlx5_ib_dev *dev);
> > +};
>
> Well this doesn't belong in here. rebase error or something?

Very strange, this chunk indeed doesn't belong to this series and Daniel
didn't add it too, but I see this mlx5_ib_odp struct above of newly added
mlx5_ib_multiport_info struct in our review system.

In this series, it comes from my rr-cache, but I don't know why it is in
the review system.

We can safely remove it. Do you want me to respin it?

Thanks

--YwTTlJgQ7QoYB9ta
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpPHPkACgkQ5GN7iDZy
WKdUQQ/+IVzKbEeS/3OvzESv5wRNTrk8KJW9GKlKaN8JPqwG5Dv3lyMYcPdtvTm/
tXsP1BhSQe+cvi8zbNtwXY5bWwMJuIABsMU72MhGT2K4vvX2/to3ZQC52D2NQHow
WpVHQ4PymvSdTZ+RiJ+e1pHKcdUAhSvB2WN9k+Bugt268Kvq0OvKUkJQIyCfJvGA
eDqQdp4+UJ6XnEU38fYVhKW1eRRGfOhCHLeLE7b97SGM1wY0CdHGxoGNJIDX0Fln
xfSmJJ7REn9p6Y+n0K7zKNYcMka/rP4PfLi88NY1JS3B++6p33CUxoUCEdzt9/TW
EkJYIgHl4trc2VFXFrH4EKJpiM/WCbhHydYvK5WN5T4NPWNnH3ThK2wLz/5yeg94
+1vT0GZe+yg5DArY+oC0SncuwbS/JMxCYD1s2Q7wToTC6QCyWwmgxAhdWIFQzsYI
reqK2L2suH5YqWXU6cpg4b61j07N3ToFv2pVvzHh+kfnu1ymgK+pHyqyCdZm+sgl
YGoOUbsz3stBWP4Rm+IRXG3ocOEpzzplJFRhmFs+RVZI7T6rnuDjiU3rsu3N9uYY
oEDlHzf1ump4e5U9OwjCvI/OmLEfPvL63azLRnLtKpdsjsHtoUbK5NwCx275axkw
PfFOg6CIMSX8HJXr1Fs29H57l3l1bXva8HYamNrmY0Gp9yVCGmc=
=bDKl
-----END PGP SIGNATURE-----

--YwTTlJgQ7QoYB9ta--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
