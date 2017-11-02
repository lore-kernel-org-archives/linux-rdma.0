From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 5/5] travis: Test Debian packaging under Artful
 container
Date: Thu, 2 Nov 2017 19:18:42 +0200
Message-ID: <20171102171842.GB16127@mtr-leonro.local>
References: <20171102165556.22105-1-leon@kernel.org>
 <20171102165556.22105-6-leon@kernel.org>
 <20171102170554.GO18874@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="d3DVaulSu5qtnQB/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171102170554.GO18874-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Nicolas Morey-Chaisemartin <nmoreychaisemartin-l3A5Bk7waGM@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--d3DVaulSu5qtnQB/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 02, 2017 at 11:05:54AM -0600, Jason Gunthorpe wrote:
> On Thu, Nov 02, 2017 at 06:55:56PM +0200, Leon Romanovsky wrote:
> > From: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > This will be compiled with GCC 7 coming with Ubuntu Artful
>
> Hurm. This point of this is to test the latest gcc, not just the GCC
> in a distro.
>
> We should be testing gcc-8 here, but it isn't available for
> trusty right now. :(
>
> Then the lines:
>
>       - ubuntu-toolchain-r-test
>
> and
>
>       - gcc-7
>
> Should be removed from the .travis.yml as well in this patch.

It looks like we can remove debhelper too.

>
> Jason

--d3DVaulSu5qtnQB/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln7U3IACgkQ5GN7iDZy
WKcVwxAAyr2ST4Gln4TZPXPVIHMKcnybWWGI3xNr99Ma6Hs0/FCrLd2pR1qWIwfY
xmro0Z46DHJFtzl/xwx58NVf5drtlRHpDuWd+Lz+QGul9OctDorCNe6fHDdVCME+
uOcw9PHJ4JUh+kH0iMvgBxittwiebyRDf2bd4GwULB3YerNp286RQ5GZTQqAs2PP
iYnMunz11KkTV7Tu9wEruNjbFw9pe0BoC0Vo223A2mIr0J0t1qtvi9UoCOLRSxGM
bDe7m3XePDF6BT9X/kM3pmLzJMOJ3aYYtWLtCpT4AORr0HpFGlFdlCFuqRp+bChc
QyDbdcXoyqk2Tw0kDAiSuc+dz7jpP78qgILOtJdAgkycvBndE2QTfo7CRfA90C8l
VkdA/fvDBIySYEEfBXvvCAcTQbCsmc/oLHdKVlJZ3VRM/bhkL3ssnRFv/lgvBs/P
87zHtP886q2VEbm4bXjFSzy+/YvLXE/cJSdlxX08MDjxynTsCCHLTEYleUSAGUUI
yChG2mv8w56QNp5yzHNb/ZsVAk2ITqOATRakk4Mb/5XTkvX1srIwpsm8IwtM8G/L
rqS2mYjyeWv8ppO6OM/tBcdncdGHOKGq2K11PJL9/dgEuFl29qOn+N3aCCjQQ+Mm
Jdzm6jPmUTCyIRUfa9w9h8Z9X5Vz1pJc4yhNag/A1IWCAUuiqG8=
=7aNr
-----END PGP SIGNATURE-----

--d3DVaulSu5qtnQB/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
