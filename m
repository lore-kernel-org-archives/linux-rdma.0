From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next v1 0/5] Cleanup of
 CONFIG_INFINIBAND_ON_DEMAND_PAGING usage
Date: Tue, 8 Jan 2019 08:18:05 +0200
Message-ID: <20190108061805.GI3632@mtr-leonro.mtl.com>
References: <20181223091418.26218-1-leon@kernel.org>
 <20190107183128.GA4613@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="QWpDgw58+k1mSFBj"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190107183128.GA4613@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Haggai Eran <haggaie@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--QWpDgw58+k1mSFBj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 07, 2019 at 11:31:28AM -0700, Jason Gunthorpe wrote:
> On Sun, Dec 23, 2018 at 11:14:13AM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Changelog v0->v1:
> >  * Don't set ODP caps always (patch #2)
> >  * Set invalidate_range callback based on device_cap only
> >
> > -------------------------------------------------------------------------------
> >
> > Hi,
> >
> > As a followup to Jason's request to rethink CONFIG_INFINIBAND_ON_DEMAND_PAGING
> > usage, this series cleans mlx5_ib and RDMA/core code and it is based on accepted
> > patch https://patchwork.kernel.org/patch/10735547/
> >
> > I think that we will see more patches in that area, I would like to
> > remove CONFIG_INFINIBAND_ON_DEMAND_PAGING completely.
> >
> > Thanks
> >
> > Leon Romanovsky (5):
> >   RDMA: Clean structures from CONFIG_INFINIBAND_ON_DEMAND_PAGING
> >   RDMA/core: Don't depend device ODP capabilities on kconfig option
> >   RDMA/mlx5: Introduce and reuse helper to identify ODP MR
> >   RDMA/mlx5: Embed into the code flow the ODP config option
> >   RDMA/mlx5: Delete declaration of already removed function
>
> This doesn't apply anymore, can you resend it please?

Done, thanks

>
> Jason

--QWpDgw58+k1mSFBj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcNECdAAoJEORje4g2clinKoYP/2XMxJYu01Pkq4WHuV8sbHcT
3kyGikjRHNtZv1aiFa9lcEv6mJJONg2Vh953ixW0LWnrfB1MhAQmyV3wlj49Axq1
oBiK5nkWX0/OxIUwSutetvBXrwyU7giO4Bx3MtDYVHe1ewSaoIelHF1yxLcNI8n5
iI2k6bLcV0HvGtDQrY+uypOrD7TBPiBMwljyoC74oFhLlZ5NcPi2WVb0YUz8Mprn
Vgw+kdHYS7DO6A/hI0OWgUUg2wa5+tDmf4m3fJhMNS0SxnjsArHmu5ZH/zYtP0Ew
PvUMqdLxdU9W9aT4w+J4bAEGeK38qbvCh/jKzxUFJZmaMeG45LFdt6mO2qkKsMMt
Yzmc556olBDeQfy8Wk1UHyWK6hn9Asy0q41YhqW6jiQUJ1KPt1tixIwQauw2Smiw
17V301TWQWuM8XoLTowSwM+MJax/2q70sQtIVgEnHSIpi8D0ypokJa/io1aT5eck
aCCgGmC0kDL18p3CcD0Vb9987J3IKcKLmbDUO4ItvKE+AOXZ6iGk3dvRHFsqoTSi
3jbThdRIjF6/cWkHZXcykDj1/b3Ri+aBQX7ARrR+Nd0TzKYxS5Q8o2OF8wR+Gkr1
csxHc71/qulYqcPErLn2eakgP/oH4uN65vcQdH6XDIEYTZv6HR3L9v/aPUZcj5rz
GofEreHZcUpnX+bYHRVC
=t9A5
-----END PGP SIGNATURE-----

--QWpDgw58+k1mSFBj--
