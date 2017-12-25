From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 01/15] net/mlx5: Fix race for multiple RoCE
 enable
Date: Mon, 25 Dec 2017 07:59:16 +0200
Message-ID: <20171225055916.GU2942@mtr-leonro.local>
References: <20171224125741.25464-1-leon@kernel.org>
 <20171224125741.25464-2-leon@kernel.org>
 <CAJ3xEMg8U_4DpYEWa8t1QpccNzjU6f0shEtQ7fRWg-EtGupy+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="i6ZTfQE1Row3TVml"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMg8U_4DpYEWa8t1QpccNzjU6f0shEtQ7fRWg-EtGupy+w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--i6ZTfQE1Row3TVml
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 24, 2017 at 11:53:16PM +0200, Or Gerlitz wrote:
> On Sun, Dec 24, 2017 at 2:57 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > There are two potential problems with the existing implementation.
> >
> > 1. Enable and disable can race after the atomic operations,
>
> s/,/./
>
> > 2. If a command fails the refcount is left in an inconsistent state.
> >
> > Introduce a lock and perform error checking.
> >
> > Fixes: a6f7d2aff623 ("net/mlx5: Add support for multiple RoCE enable")
>
> Dan, please send this to net as a fix
>

Thanks Or for the suggestion, but we will proceed with our initial plan
and continue to submit this as part of our original dual-port-roce
series.

Thanks

> > Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--i6ZTfQE1Row3TVml
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpAk7QACgkQ5GN7iDZy
WKf7Hg/9E+jr9xnKpl0Xzn3CHUsJWlN73vrjdARhZjYLccqjbMuIN9O635SiVAY6
c4d9ROSq0KR/V+k50h5Wx+gPbcdBV9YqqWRKD4VjhAmWdGKnsCCJMJwTJ9o37eqt
CSVobOzyTWxf96A5XjYycm2aaugRScH1+279iABCtCv8o7kp3CQNg+6D17e6w24b
0O8j9G0SMQg6nuz3oKoeIsF01qP/9HI1m3PaNf93c+EW4yF64JtZJ4WOAnTLpA5j
jnHXMAx//dfjNhUmbF2yMjRYowUbtnMYqnSgIbR5BkkFhSUU+ylpalijFhyTU8v8
ETh0LoR3K/qDc6R6hnRZ/ZnALbKkVhOM0HgfgEdrt7LBvwjvTQeyMEGD6XdKbgUk
uAhlQvjf9mLHpMLMRq15GAdgDuqxRZbvpZGJjNGJH1Y08WPn4a830ImW6wBI0TwG
9yMYjpVE2yGt5cTthdfbDOMrAzubnUHvf1nmHP6nEzmqLAfjFv+QjPXoGW5OcDTA
7J1p8z40gxBKASJpv9f+2NqtZ9aloPYN4aqzGI7cLjX16SDtMHTi5dTbFNI90qkp
05U7OyDA4rzTEIRF5AuJymNhgDwXMAySiFjhS6KCxSOt6CGzCxNXRe39uhGs3mMs
SzVZLMxFegK5XhnbSdeeskaIn6CYBGfrnfLoQU0gFOUNDEsZUW4=
=X09h
-----END PGP SIGNATURE-----

--i6ZTfQE1Row3TVml--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
