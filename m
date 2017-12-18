From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 5/5] RDMA/core: Add runchecks.cfg for
 drivers/infiniband/core
Date: Mon, 18 Dec 2017 21:18:00 +0200
Message-ID: <20171218191800.GE18894@mtr-leonro.local>
References: <cover.630ac8faeeda67bf7a778c158174422042942d08.1513430008.git-series.knut.omang@oracle.com>
 <0ce3c307255b22d23f49d13213b76044647e6f60.1513430008.git-series.knut.omang@oracle.com>
 <20171218080223.GB18894@mtr-leonro.local>
 <1513600586.22938.29.camel@oracle.com>
 <1513623831.31581.121.camel@perches.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jCrbxBqMcLqd4mOl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1513623831.31581.121.camel-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?iso-8859-1?Q?H=E5kon?= Bugge <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, =?iso-8859-1?Q?=C5smund_=D8stvold?= <asmund.ostvold-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--jCrbxBqMcLqd4mOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 18, 2017 at 11:03:51AM -0800, Joe Perches wrote:
> On Mon, 2017-12-18 at 13:36 +0100, Knut Omang wrote:
> > On Mon, 2017-12-18 at 10:02 +0200, Leon Romanovsky wrote:
> []
> > > Also, I agree with other reviewers, there is no excuse for adding
> > > checkpatch specifics per-subsystem/folder, the differences are better
> > > to be treated in checkpatch.pl itself.
>
> What other reviewers are those?

I saw responses from Stephen and Jason.

>
> As a checkpatch maintainer, I don't believe it's appropriate
> to add many per-subsystem specific rules to checkpatch.

There are not so much differences, I'm aware of only one specific subsystem - netdev.
The rest of the kernel more or less follows general CodingStyle and
don't need anything specific in checkpatch.pl

Thanks

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--jCrbxBqMcLqd4mOl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlo4FGgACgkQ5GN7iDZy
WKcBghAAtnSNtIdtvbepyI737KATgaqRyqY7E4q1qiaJHtGQgrVEYmyUI9eTFvEJ
8Pf9886jYvDPj2nRwhByS7jLPbuzubM2OIrjBaQ57NgXXdlP/lt04ZFAsxaewkEz
LYlbHJ6FHszQFtgmdsjH0jXJe/t+tlNqvAfUWEv3kGyy6O01ToIa/D3lGE9FKPWC
5G6QPhYjNb8KEF1iOIj1GhpVhhvTLKR6Y+zdRsBi0tFhFbLOdZ/UPGWEXPpQotIl
MZMlaTXdBgYh4NRixJMjYjgRYrH6QmWUi8RIyU0Y/bFT3ZUUy0KYbV5OjHFpOFS5
tFZ30VGsUGKuTxilv0VK/ukHsqH2jfFqbGGlVCaG0kRYF1XzlliVPKhHe/sLSUa0
f14qiJTe6eFbIGAXs3YakgpseTzgL0k7/6fvMHkNwxTdM/Hzl1Y2+32JvWoPVgmW
08XYe15y/utXKA6NSNe7ogl5LCWXqy2uFdVwO/ODo9Id7N6DaYFfihsDmjGI3q2L
QiHNpkGFW5m7NR31FVExTyZKbh8yFJTLOsoR0el61L48fKU23kK8Jvgjd6Tl8jcA
1Ab7aEol8nJet2IPqgc1rajpkQwiW39njv2RfMMtclViKOigqfD/dGCraH2seP4j
mLtujkiw0ZUzx1drEcuNzRbqOllpvvgzrPueAvkazDBLbwaOLLQ=
=uDKz
-----END PGP SIGNATURE-----

--jCrbxBqMcLqd4mOl--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
