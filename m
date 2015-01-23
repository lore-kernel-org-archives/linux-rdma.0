From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 FIX for-3.19] IB/ipoib: Fix broken multicast flow
Date: Fri, 23 Jan 2015 02:48:37 -0500
Message-ID: <1421999317.3352.267.camel@redhat.com>
References: <1421933479-18214-1-git-send-email-ogerlitz@mellanox.com>
	 <1421959236.3352.233.camel@redhat.com>
	 <CAJ3xEMhX9VWobHhUmW_=kumTNL6TWG6L+RrCtT2Zd=mjg-BOew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-SZ9u35NisnVrvov3e8m7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMhX9VWobHhUmW_=kumTNL6TWG6L+RrCtT2Zd=mjg-BOew-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-SZ9u35NisnVrvov3e8m7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2015-01-23 at 09:07 +0200, Or Gerlitz wrote:
> >> 2. Sync between ipoib_mcast_sendonly_join() to ipoib_mcast_sendonly_jo=
in_complete
> >> using a IS_ERR_OR_NULL() test
>=20
> > This part is no good.  You just added a kernel data corrupter or kernel
> > oopser depending on the situation.
>=20
> Yep, you probably have a point here, but didn't that exist prior to
> your 3.19-rc1 series too? in other words, if bug X was there before
> and you added bug Y and we fix Y that's fine and by the rules.

No.  My patch set was written in response to bug A.  That bug actually
had multiple sub-bugs that contributed to it.  This was one of them.
Saying that it is OK because it existed before is to deny the entire
purpose of the changes.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-SZ9u35NisnVrvov3e8m7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUwfzVAAoJELgmozMOVy/d37UQAISH2ojzzJuVfGF4pSAyi4kb
nMR/Bf2igPWt4MBJjxeLZOGaNCk/JUTXEjI2cyogg/1HaZjOdEiSNnIkpePxo0jb
CqDRb4XGKLAq4neqaIppSfL98sa3UQ136hl4z2mR+49/rTfYQBHgN2IVK1TXqqrr
V6qxRcu8IUsOlHUBp8lUUh0bxa1yrQiO0SJ6SU3KK0chEWEJwbZppBJl61tqgh7G
t9pxsTjpaI9/T0s7+IiAYi6g/nhNXSLLXGWVS5yNFUy8c6M6JWlBpbcOZsFwOPsE
CuDXwIwTEs3+APQrOo4p0A3mHswvz5nZuTUsUD32fdFJgwG2q0g0niJhawjHZ9tx
MdcoG5C/Rn4f5gtf7BoqEIQNzz0FYMsiVcy+gC6UXbexgEjzWpHJJByUURz84FyB
8+5oeZBg6jUkw/5vrrBmRnLuplWtGz9C4UCEzxRZ0Uik2kFNlumOD0139HvSyPTI
8pKJYtkJvEZe4emsLD5D+F5oykkMi4EkhydA5N6Ty4izYED2pY3A/wuNC3x6Jn9y
YvrHSj0IFcgr8kVQG2urXj2MDrLxc22AJiZwctPNsRNdnzqpHO1ijaFXA1h260vk
R2jA+p1q7bPCMYThGe3+wM9grIp11Zj0v8FCfuUDp23RlKqX2WwX6e1VnzWgJHQ5
mWgF0+LtqisxqEYHizpR
=PFe6
-----END PGP SIGNATURE-----

--=-SZ9u35NisnVrvov3e8m7--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
