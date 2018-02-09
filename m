From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] mlx4: Fix 1<<31 expressions
Date: Fri, 9 Feb 2018 18:42:00 +0200
Message-ID: <20180209164200.GO2197@mtr-leonro.local>
References: <20180208233829.GA16128@ziepe.ca>
 <1518192109.2871.5.camel@wdc.com>
 <20180209161030.GA7584@mellanox.com>
 <HE1PR0502MB3004BB45FC9ADB9B49CAF283D1F20@HE1PR0502MB3004.eurprd05.prod.outlook.com>
 <20180209161325.GD7570@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="o0ZfoUVt4BxPQnbU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180209161325.GD7570-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--o0ZfoUVt4BxPQnbU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 09, 2018 at 09:13:25AM -0700, Jason Gunthorpe wrote:
> On Fri, Feb 09, 2018 at 04:12:24PM +0000, Parav Pandit wrote:
>
> > > I did a patch that will make our public headers mostly strictly confo=
rming to C11
> > > with -Wpedantic set, which I've been wondering if it is worth sending=
=2E.
>
> > Any reason to use open code instead of using BIT() macro from
> > include/linux/bitops.h which does the same thing?
>
> BIT only works in the kernel. This is a publich header from rdma-core
> userspace.

=E2=9E=9C  rdma-core git:(master) git grep "define BIT" providers/mlx5/cq.c
providers/mlx5/cq.c:#define BIT(i) (1UL << (i))

Thanks

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--o0ZfoUVt4BxPQnbU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlp9z1gACgkQ5GN7iDZy
WKd25g/9GhbpSOmWaPpnHxGG77ldbKU0cyNrxzZdkoPjRonMG4dHRH1Vh8jTTODp
gYy/3WXkPiWIWX6nmX6CQI4rEbp8gkckk7O3L06CVGFZWM8o5DF0GSiLbxDFlF25
aNYOJAMopLTvoGLe2jLjzNzTE/oI5lStqlu4ZBsXucuWthkO2obPaOeCA/dfn+zN
JJr9JGHfL+qz4/kzaXEOLHF3xp9SEwfQkkiFd59adqf1SuVG8toDxHNYDCR/Ifk9
VQA0VUoxih2LltNahIXXw4Kbo2/n42lVhQId8tmTUfs0r4+VElMigmaYouSVWceq
Kgwy6zRoxjUREnDcRax8MkSODW98Pn5NcB5YnLBBxFgpO23hIKjN0/CJ1LRejgzX
8xd0wXEmGsKmiMF5AZ1MI+Qzv+WE9SQUlxTkK7k5P2aiQfvQpx1CxFJ4O/Zbm8cf
T0ofFILA6FjIAt48bCLb/gbE4R9bUnWdoTYrH6EC2A/fvkMVMFAAJXsgcCrJfpyj
RStRDKPcCr0IZAZuM/yLNyqz9me/T9xeEDEPNpc8lWjuGcQrfiFNWw6qruxWV9dS
YQ9HAo8eJtMxqNyGH0q2rv6DK7ELHQHVrXRCBZ3SjTl7M2SnWtXZLZl1aSyD7RMc
OB/rW4OAA5bjYQ0kx3bY2zRRwCfWLW6q0l9b1nhEmvlh6+Mc0zw=
=OlQ+
-----END PGP SIGNATURE-----

--o0ZfoUVt4BxPQnbU--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
