From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: OFED-4.8, rdma-core, and library paths
Date: Tue, 7 Feb 2017 20:35:38 +0200
Message-ID: <20170207183538.GT6005@mtr-leonro.local>
References: <011b01d28153$e5f0adf0$b1d209d0$@opengridcomputing.com>
 <20170207171145.GB1077@obsidianresearch.com>
 <02c801d28166$693e17d0$3bba4770$@opengridcomputing.com>
 <20170207172752.GA12315@obsidianresearch.com>
 <20170207180642.GQ6005@mtr-leonro.local>
 <20170207181814.GA13368@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lCt7MkQCJDO5fc2F"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170207181814.GA13368-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, 'Vladimir Sokolovsky' <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--lCt7MkQCJDO5fc2F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 07, 2017 at 11:18:14AM -0700, Jason Gunthorpe wrote:
> On Tue, Feb 07, 2017 at 08:06:42PM +0200, Leon Romanovsky wrote:
> > On Tue, Feb 07, 2017 at 10:27:52AM -0700, Jason Gunthorpe wrote:
> > > On Tue, Feb 07, 2017 at 11:19:59AM -0600, Steve Wise wrote:
> > > > >
> > > > > Hm, possibly yes. ibverbs first checks the new location, if the
> > > > > provider is not there then it will fall back to a naked dlopen which
> > > > > could find providers in the system library path if there was a .driver
> > > > > file for it.
> > > >
> > > > Hmm, so it will load the provider libraries directly specifying the
> > > > full path?  IE 'ldconfig -p' doesn't matter?
> > >
> > > As the first try, yes. That is the usual way to locate
> > > plugins. Typically you don't want the system linker searching plugin
> > > directories.
> >
> > Jason,
> > I have a slightly different question, but it is still in context of
> > plugins and linkers.
> >
> > In v0 of DV, you asked from us to create normal shared library for mlx5,
> > e.g. libmlx5.so. In order to be visible to "gcc -lmlx5"i command, it should be
> > placed in the same directory as libibverbs.so, while plugins should be placed
> > in libibverbs folder.
> >
> > I did it by using symlinks
> > $l /usr/lib64/libibverbs
> > lrwxrwxrwx    1 root root   10 Feb  7 18:09 libmlx5-rdmav2.so -> ../libmlx5.so
> > $l /usr/lib64 | grep mlx5
> > lrwxrwxrwx    1 root root   12 Feb  7 18:09 libmlx5.so -> libmlx5.so.1
> > lrwxrwxrwx    1 root root   17 Feb  7 18:09 libmlx5.so.1 -> libmlx5.so.1.0.13
> >
> > It works, but I don't know if it is right approach from distro/packaging
> > perspective. Is it ok?
>
> I think this is basically OK. The symlink should point to the real
> file (libmlx5.so.1.0.13) though.

Right, to be sure that provider and libibverbs are coming from same version.

>
> Also, make sure that cmake computes the .. properly, something like
>
> execute_process("realpath --relative-to ${VERBS_PROVIDER_DIR} ${CMAKE_INSTALL_LIBDIR}/libmlx5.so.1.0.13" OUTPUT_VARIBALE LINK_PATH)
>
> You'll want to create a new rdma_dv_provider function to handle all of
> this.

I made it (rdma_shared_provider function), but have a very hard time
to properly create ".." symlink, because during the build (in place too)
the output is placed in build/lib in flat structure and symlinks need to
be without "..". But during installation phase, these symlinks should
be changed to ".." and it doesn't work for me in automatic way :(

>
> Jason

--lCt7MkQCJDO5fc2F
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliaE3kACgkQ5GN7iDZy
WKc8Qg//TmN+ZS9xxGYt2XaoHs0Mvy23sYIxALFy6XKy66Gsbx8MOITlsjpUV9ao
h+pkTu46CBv64MKFEP9mKzPzV/gz6XHN3D7PDkg96FmdwARL7tSlUhCzpg4+YkkG
YVaeZRF2jYphrS5s0rxE9JmAbuux70X4kotTx5XzkcJfqtFADcNET+lv0kF8WGs9
R7YY/6POVgtrKVQD9Xv8gal7Agq6JBX/mTGPtivRRc7i1MF9rNb717hzV4b3h6g1
KySUus/tQiohYnCYwSSjRV+MLtxeG1wk2aDkWR/xK8dBLFMSSDkFjP8UmRW8jd9r
CuXKUCuWlI9vFsd9sfFeY/Vz9hhmlEsEMrmn3T5RTkzil992q/rsXmV0CV+eTFpS
jOpmQc33664O6xAG9YleLnZcU+olSVDuFf8CTpF6E+tD85zgOPRBSHy+D0+5MBAf
TUiwSn/aJOMAb/sCvvgFDrTYFZpFk9/FDKctNfgAtW1pBYDnGlrAnwKWv6ua2SI2
Zrq6EPA2q9WC7HEfj8kKaEaWKtdgyEn+6a02dUltDIEFbDOtRE61wMybmMKazGc+
pPh7kEy+hbzBFqpIwDQcfaWrc5BGc0eg/JBrCQRdVQFCQDCXxSWD0kfqcF/LxtEw
Gnp5+XWqWkYUDO5A2qcqG91ERbZnAAocbQjBY/dPPmTTdXw8Au4=
=J1Or
-----END PGP SIGNATURE-----

--lCt7MkQCJDO5fc2F--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
