From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/31] RDMA fixes and refactoring for 4.15
Date: Wed, 27 Dec 2017 06:58:41 +0200
Message-ID: <20171227045841.GH10734@mtr-leonro.local>
References: <20171114125218.20477-1-leon@kernel.org>
 <20171218231120.GH19056@ziepe.ca>
 <20171226184914.GF10734@mtr-leonro.local>
 <20171226194926.GH30884@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Cp3Cp8fzgozWLBWL"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171226194926.GH30884-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Cp3Cp8fzgozWLBWL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 26, 2017 at 12:49:26PM -0700, Jason Gunthorpe wrote:
> On Tue, Dec 26, 2017 at 08:49:14PM +0200, Leon Romanovsky wrote:
> > > Everything is in the wip/jgg-zero-day branch, it will move to for-next
> > > my tomorrow. Let me know if there are any serious problems with my
> > > edits.
> >
> > I have a hard time to find the commit 09/31
> > https://patchwork.kernel.org/patch/10057549/
> >
> > It is marked as superseded, but I wasn't supposed to send any new
> > version of it.
>
> I must have confused it with the other PSN patch you re-sent to go to
> -rc (RDMA/cma: Make sure that PSN is not over max allowed)
>
> Can you just mark it as New in patchworks?

Done, thanks

>
> Thanks,
> Jason

--Cp3Cp8fzgozWLBWL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpDKH8ACgkQ5GN7iDZy
WKdcQA/+Jg9W5mpv2wizXXJQ587mg7ePjQVanLJphkr8wdDG+7wcUQR85/ma5qkZ
SJ8gtU4C6q9Ri+pAYeIQRfhi0xKj3GFjPPDBePKgbdLkjXo/KoBsODRQBlHQvO1a
FOsKVNucIW3+0vObqkzA5BQ72u7zTuh9L/QbmpKobgJ1PUbYS63anEvxo6wMMDQo
AHUCuqtshd4Ev/w80tucKCRdT+OLmdw8SsERoZFdy2AE8lNxGc1spvvvc2p7M5Kr
IW9BD4Iuywfl75y8sZa8yQij5MPS5zmnaSNNUCyYmkzgLaUUtTxHVXScgJ5Q5Axv
54snNyoxP0Vg1t+qGcjzHvT+cDpH0V8V6ySRIVNA0sUlPRfaOcUh1kNA8dvaZOFk
Ujm8eGwRX8W2OTvLHlY0Wv17zlnDOrayAXMoRlyC1EH3O3QF/mPA5ABZExYYqLZ2
M3qe2bfYRXFc5JdtiqlEHODJ2DjF7oeBXNhHsORPE4kQhP05LltwwaIcsV34DZzm
i6wYTYdLB3sjABB9KIaUfukC1xs8veCwaIH3FKGAXN0YAzzx1HYkkVg4e8s0WdQD
8YV5USTDSdUGK1Y7+m/UH7jLs5vNI85imCrxZOlm91q1lfkk/vMUSn1RRWIdSwqX
7xK5fnm67xcgURIh5N4GiO/DXgYOO5RB9sDsFvqiVtsSZiVQfdA=
=an0o
-----END PGP SIGNATURE-----

--Cp3Cp8fzgozWLBWL--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
