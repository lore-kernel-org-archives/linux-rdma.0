From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC rdma-next 0/3] Move mlx5 vendor specific to UAPI directory
Date: Thu, 15 Sep 2016 08:02:49 +0300
Message-ID: <20160915050249.GG26069@leon.nu>
References: <1473841649-8923-1-git-send-email-leon@kernel.org>
 <20160914172145.GI16014@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qoTlaiD+Y2fIM3Ll"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160914172145.GI16014-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--qoTlaiD+Y2fIM3Ll
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 14, 2016 at 11:21:45AM -0600, Jason Gunthorpe wrote:
> On Wed, Sep 14, 2016 at 11:27:26AM +0300, Leon Romanovsky wrote:
> > The consolidate library revealed the fact that vendor specific
> > structures and defines are copy/pasted between kernel and user-space,
> > instead of sharing.
> >
> > This RFC was tested by compilation only and not-ready for merge yet.
>
> Yah, this is exactly what I had in mind. We need to give this
> treatment to all the drivers :|

Are we fine with the names (include/uapi/rdma/providers/*-abi.h)?

>
> > Leon Romanovsky (3):
> >   IB/mlx5: Move and decouple user vendor structures
> >   IB/core: Export mlx5 vendor specific strucutres
> >   MAINTAINERS: Add mlx5 uapi file
>
> One patch is probably enough, 3 patches per driver is going to be
> alot.

At the end, I will do one patch per-driver and one global patch for
MAINTAINERS file.

>
> Jason

--qoTlaiD+Y2fIM3Ll
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX2it5AAoJEORje4g2clinpfUP/0lHPhi6YryR3OJzkV72ZLl9
lAloXe9K9vveGT9V8wG0ECq9X4GZ9LGgCAqk2zN2mMQxJhgwc3pbn0+TlKqMuTGG
xqiRj0rrC2Lvfe/fqKZVjPVMuTdP+vzFzqNJn8V5n9TcGkuI4XFpHWOWjrMHjSg4
VyaTTq3Vq8VM8DghqbHNVjYipzgEKGbKE26DueewfTWZMKv8aupnSLivqESCfcAZ
T75nHf105FVP9c0Jr+kwLwrolWzTuzy32cwkyvAc99aC4H5IxPekUXRZ45mLDtML
jasQwvUckDpoYEJXCpuqj9aBh2sO9kGlTliTcnkGNwvWUTYHUOsbGBe2C7QW5HAg
ZYlAZkJbQVEZ4b5XbS5o/sSnjB9iWZJQ+lK7l4C2CB7ZgmwACK1qsNRHC0omc85D
JMuVfhFKypogvr1QucytqsscKALZSM5u25Pl15tRaemcmPmzw9bUmmgN3j7nuzBN
zJdBXNFyA62HmTtwM5krN5Lz3T78KZTv7z8nh4joWkAyh2WoBvMz+Fq51iT7ORYo
00vxxuM8JFO1B9/blknxLyyNEGzprI5OcmaeDW/4u8qH8B8hB0isNFdufGAFKhw5
OeQWrxKPpy3979/DJGEhMELzEea7OZcerMA1RtKO4IrJg+uky5EipXdV0igfJR7X
F0cClBMV1qASRCPF2Pow
=XxPa
-----END PGP SIGNATURE-----

--qoTlaiD+Y2fIM3Ll--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
