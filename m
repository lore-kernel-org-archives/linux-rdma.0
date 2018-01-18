From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 00/13] Request for Comments on SoftiWarp
Date: Thu, 18 Jan 2018 09:29:58 +0200
Message-ID: <20180118072958.GW13639@mtr-leonro.local>
References: <20180114223603.19961-1-bmt@zurich.ibm.com>
 <031f01d38fad$422520c0$c66f6240$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sDhuxz86kt5qlkuV"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <031f01d38fad$422520c0$c66f6240$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Bernard Metzler' <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--sDhuxz86kt5qlkuV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 17, 2018 at 10:07:22AM -0600, Steve Wise wrote:
> Hey Bernard,
>
> >
> > This patch set contributes a new version of the SoftiWarp
> > driver, as originally introduced Oct 6th, 2017.
> >
>
>
> Two things I think will help with review:
>
> 1) provide a github linux kernel repo with this series added.  That allows
> reviewers to easily use both patches and a full kernel tree for reviewing.
>
> 2) provide the userlib patches (and a github repo) that works with the
> latest upstream rdma-core.  That will allow folks to test use-side rdma as
> part of their review.

And please don't call it "PATCH" in subject, but "RFC".
The "PATCH" is misleading.

>
> I'll review the individual patches in detail asap.

I would like to review too to learn iWARP a little bit closer, but most
probably won't have time to do it till -rc1.

>
> Thanks!
>
> Steve.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--sDhuxz86kt5qlkuV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpgTPYACgkQ5GN7iDZy
WKcWXQ/6ApB1ZVT+6RAHrTWS2kjH4AIqBO7pjaYGJm78heygd8pcZ13HoyLQaZoL
qvN1pM3GOPPrSMNnezr6DOXm4j38oZWNn/gkSWnVPmrYEF0+ekwL159W/J5AEizC
ClzU9vkKiRMBIKyGT9ZPdBBMxKuhMi4Up5m4VLiZVg+uReEJKt/+pLKzqCI4cavh
ycxi6mtju4RcicDIyWwbTv4X2JSshWwpk63EfLxZiRBURsA2LWLUhnqr72s5qPmD
blucq62ZIDZezVt+Us3lvJ1q8cM6VE++3sHsMbSWnJyBybNKmyj4qy9Avr7RkBl5
gtF6q0uFL552hSHoI+9LPCe3p2D2+ulZA8wzVLhy1obTjIe7os42z7NMyh8zV4ME
mz+xa0+3s0Y6WUXQQAESTziTj2MNWuwsfKwQSgUy2zW2eRkLeFcrsYSboXx2Pxxp
VszCNe+wRbyJ7VhRHe8dd0zHGBqb+GmTvQFeOd8GJ3FgyirjmiTrdbU8UYlsGKrx
XIEk6HhFylAqlMWJYC1VLg2x3GlxZU1yoxYYoWlOUUA2Rcuwz43DpmjuT6bcoldx
arzbJJ5xCwWYPW4rnJbTxU54r168vHnCpMg89eow8ieaPLtUCF+L7zdkYO4DMJ1G
YlCVQfFwIEsByag4HSz97Utr/oV+D/xlMv0DihiMC2J0hg4/IO0=
=OTYo
-----END PGP SIGNATURE-----

--sDhuxz86kt5qlkuV--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
