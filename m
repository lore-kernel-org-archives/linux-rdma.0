From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: Re: [PATCH 3.2] IB/qib: Change lkey table allocation to support
 more MRs
Date: Thu, 08 Oct 2015 13:49:54 +0100
Message-ID: <1444308594.2956.255.camel@decadent.org.uk>
References: <20150929145143.27497.86046.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-DmGjfAANi9DhoWbDg3BQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150929145143.27497.86046.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-DmGjfAANi9DhoWbDg3BQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-09-29 at 10:51 -0400, Mike Marciniszyn wrote:
> The lkey table is allocated with with a get_user_pages() with an
> order based on a number of index bits from a module parameter.
>=20
> The underlying kernel code cannot allocate that many contiguous
> pages.
>=20
> There is no reason the underlying memory needs to be physically
> contiguous.
>=20
> This patch:
> - switches the allocation/deallocation to vmalloc/vfree
> - caps the number of bits to 23 to insure at least 1 generation bit
>   o this matches the module parameter description
>=20
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 3.2
> Reviewed-by: Vinit Agnihotri <vinit.abhay.agnihotri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
[...]

qib_dev_warn() is not defined.  But, I worked out how to backport this
anyway.

Ben.


--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-DmGjfAANi9DhoWbDg3BQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAVhZmcue/yOyVhhEJAQpNyA/+Jn+xT6ZxoYtlQ25JGMmhOqR4cUKmCfZr
WAup1zoJvADrGJEtZV1VDntQ6knZN3tkQcBPj/CPcZeM07qmk86ghIKceDMmK0el
ybrg+/cfUNkB+HuNq47rVE8HajqYAq8hGKiGvGOogUoQEEHg/YMuztzSK3EU5Ckh
ZIhohhG410XvTopJ87iQc1TELE/9BjQHkyhbx4GUhQlJSpXezWMMOdeoC+IxNwIn
qa7KH4vA4Iv0LFKDsXo7+78I9Mnquedp0oJJQ1xIAZlEIV4SYQLLlj02K660EMal
GblUVBH6JvKex4JxzXE+67jLD0iKwdfnkZpg4OkGe4UR//T1duWLGOyCUzyqLjgn
uFCi9vyLcEk7J8TPClmPPpBPvj4nT2WFfxDReNAqWASfX649JHj9ZWM2jCOSQvOj
tXaEEfgWwoZvF0yT9KAQg3uBYIlpcBiJ3RE7YIesXj6PzRFHk0q0jRFaWOqp3BW0
L1owbb9A55yCGIgNApACX3MqpowyzhS3U5mdAAWPPZlRQQb6hrXiW0QDw42DjkEk
BYL/mWdjDnxqR80FOOVm7oXaC7t/ba6B+/K4lGI52yio1CxfZyfP03cwySG16r+E
JmupQIkyWdxfk2KQ91AVmQIpsBSNF1aARqxf2KhGaEkEtQNMNsURXVHJgq5rl5bo
HihDRa573M8=
=JaKY
-----END PGP SIGNATURE-----

--=-DmGjfAANi9DhoWbDg3BQ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
