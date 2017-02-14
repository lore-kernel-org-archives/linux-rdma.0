From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V1 rdma-core 7/7] mlx5: Export mlx5 direct verbs interface
Date: Tue, 14 Feb 2017 07:52:19 +0200
Message-ID: <20170214055219.GE6989@mtr-leonro.local>
References: <1486909012-15064-1-git-send-email-yishaih@mellanox.com>
 <1486909012-15064-8-git-send-email-yishaih@mellanox.com>
 <20170213164944.GB25430@obsidianresearch.com>
 <20170213182121.GD6989@mtr-leonro.local>
 <20170213184250.GA12224@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jL2BoiuKMElzg3CS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170213184250.GA12224-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--jL2BoiuKMElzg3CS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 13, 2017 at 11:42:50AM -0700, Jason Gunthorpe wrote:
> On Mon, Feb 13, 2017 at 08:21:21PM +0200, Leon Romanovsky wrote:
> > On Mon, Feb 13, 2017 at 09:49:44AM -0700, Jason Gunthorpe wrote:
> > > On Sun, Feb 12, 2017 at 04:16:52PM +0200, Yishai Hadas wrote:
> > > > diff --git a/debian/ibverbs-providers.install b/debian/ibverbs-providers.install
> > > > index 70244ee..7bacc2e 100644
> > > > +++ b/debian/ibverbs-providers.install
> > > > @@ -1,8 +1,12 @@
> > > > +usr/include/infiniband/mlx5dv.h
> > > >  etc/libibverbs.d/
> > > >  etc/modprobe.d/truescale.conf
> > > >  usr/bin/rxe_cfg
> > > >  usr/lib/*/libibverbs/lib*-rdmav2.so
> > > > +usr/lib/*/libmlx5.*
> > > >  usr/lib/truescale-serdes.cmds
> > > >  usr/share/doc/rdma-core/rxe.md usr/share/doc/ibverbs-providers/
> > > > +usr/share/man/man3/mlx5dv_*.3
> > > > +usr/share/man/man7/mlx5dv.7
> > >
> > > These need to go in libibverbs-dev, as does the libmlx5*.so.
> >
> > I'm not sure, at the end libmlx5 is a provider.
>
> Devel items need to go in dev pacakges. That means headers, devel man
> pages and the main .so symlink.

Sorry, but I'm still missing how mlx5 installation will be handled.

The ibverbs-provider installs different *-rdmav2.so files and it should
install libmlx5-rdmav2.so among them.

If we move libmlx5.so to libibverbs-dev, how will symlink be created?
What will user see after installing libibverbs + ibverbs-provider?
And what will be in case of libibverbs-dev + ibverbs-provider?

Thanks

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--jL2BoiuKMElzg3CS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliimxMACgkQ5GN7iDZy
WKfuXw//UZjYKStv8ChhsMhMHixKmY/xTzuOcciRT1EFon6tKmt5gg8xaL615RRp
MmNdni2qkLFTk+IzUdDyp5e/5eUdeK2JOgIdObDX6chMaWN1qKxd7Aqu+QVdFiiw
jENEknfVN8Z4+ri3HjlS5EZSQHXNhTenxYqGt3Gp5ARyLOcGInlpqDX9BCh2gK9B
ff9guW1es5wVfDBIp5boS1YaFOg7ifadxOpNcNEGqI05wT3k8PlmJZZY92GLNwY3
Heqw4s+OEKn20zKtt2EY6lez0UPFwmpTDatYRf/KZAw9t0plkJ5ak6UQO0eCvavc
VYcgTFaDku7mgqrDCwpK4o/ohDFYTU2OBj72SCgWYj6dS6OGWxqdaVf4t5NdOWJD
BmB5bro4q6vVkH8GvIVQVEtkCVQnwAaIZVfSXDy/AbH03OYX5xU7wUYzlAiuJ4wR
57HPZ6V7GBz+DqVIbybaoX3FsH//+uBQrvW/3NSjWEt+hAO2GBwN370486OQCleo
+JuqxHwqp55XuZkwG+km4VfVQctueaOi0EHiYSj9FWcdViuSvJZC37FSbUkcztef
GJ/rzuom7aMv5tx/arbUbKqwQ3TsAkTS8GiULU99gGiiABB+ZXtZdROdppBxq2T4
nKum8KxjOB6n/jkII/BKQMfDuVi95CtdC/YC52LNXRl+7n38TPQ=
=8C4W
-----END PGP SIGNATURE-----

--jL2BoiuKMElzg3CS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
