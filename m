From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH FIX For-3.19 v4 0/7] IB/ipoib: follow fixes for
 multicast handling
Date: Thu, 22 Jan 2015 09:21:05 -0500
Message-ID: <1421936465.3352.140.camel@redhat.com>
References: <cover.1421725318.git.dledford@redhat.com>
	 <54BE7F66.4070404@dev.mellanox.co.il>
	 <CAL1RGDVPCH3h7nZMd9=4rFPqbKEGZiXQC+Atvfwj5kWcf2S3Qg@mail.gmail.com>
	 <CAJ3xEMi5vGc-Urv_7RSWCn9-ZAiq0WzVn3y0__jrTc48jM9gpQ@mail.gmail.com>
	 <CAG4TOxO3wTguFbffxPFANrVTQo7=gVDzEAWwoDhh_acNTixXpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-W9Ma7C82VAVEC1+5Cg3p"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxO3wTguFbffxPFANrVTQo7=gVDzEAWwoDhh_acNTixXpQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-W9Ma7C82VAVEC1+5Cg3p
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-01-21 at 12:37 -0800, Roland Dreier wrote:
> On Wed, Jan 21, 2015 at 12:34 PM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote=
:
> >> Because Doug's changes fixed some bad, easy-to-reproduce issues.  On
> >> the other hand we don't want to introduce new regressions to fix the
> >> old issues.
> >
> > See above, we did introduced regressions.
>=20
> Yes, I know, that's my whole point.
>=20
> We need to fix the current 3.19-rc code, and the two choices are to
> keep the fixes we added during 3.19 or revert back to 3.18.
>=20
> Doug's opinion is that your proposed fix is broken, and we don't have
> an alternate fix.

I will second that opinion.  Over night we ran a series of tests on some
new patches I made, and they resolved the rmmod/insmod failure case in
our testing.  There were two significant fixes.  One of them was related
to the switch to using a separate work queue per device.  The other was
an oversight in ipoib_mcast_restart_task().  Neither of these issues
were addressed by the alternate fix.  So, at best, the alternate fix is
paper machete that covers over two holes but leaves the holes in place.

> So I suggest we revert the whole series from 3.19 and get this right for =
3.20.

Before you decide, please take a look at the final fix as I see it.
This was a 7 patch series, now it's 10 patches.  But the final three
patches are small, well understood, and obviously correct.

Regardless of whether you take these 10, I do *not* suggest leaving the
first 8 and using the alternate patch.  I suggest either an all or
nothing approach.  But, like I said, the rmmod issue is now fixed in my
testing.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-W9Ma7C82VAVEC1+5Cg3p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUwQdRAAoJELgmozMOVy/dP1kP/1dNUphpShvaFQVD3TGO4quB
vWqGm87vu6sk0qUY4dKvR5INJfhgEEztemu0WFPkneimad46cm56Z1DMXKwvyJJl
xLXeXBp10uja/O+TtqTrDaaSlwtuOVG53HNKXqZDl6qxDemyLghHB+eZUg0zJbvN
IjtvFlxVX7gD+vFkKDZJJB6zoqcDjmahb/tgFPCYgrzshBJ9P81RAGYyksdtVjTc
t8myNGGu4zF90vUbm3d6QGg6JCfqWw31eCTq6/aKOdJQ9LJtA5lbOCtUOCehenEL
w2yLfwsMWCx7bbhpf85W9lwXWCTSjF4XogWOXQ/lhP4mDGFfOoHI5YpUjtcC+ggy
+Y5iyfkgOPthVHG5uSgT1ib40T0qZ2g24iBd8aRLO/s4dDwx3eIvTXQcv2cd9ajH
E45boJujLYIsOgfVzsK8vcTEK5eBJTwhmK3yVkOvQdrE2ABvgVeNAylHcSJX3yCM
5o1qrCu4//i93MILH8QtsJ+yiATIkfeuhTJ1Rl6+sVqq+fVoKxMdrqhSxckpgr8V
ffifimNwuRDZDHiDcqj47f5nraFNR+uPHrx5hZpT1q7iUB6jXK7UVYGLLHCbTxMm
jNya1vB/FyztblTunO4NF/zaXHRG0nM4RhV3BVJKE1pkZAZZvMILxg+jaQYHbT9i
nR7C4r3wNeRkIG68j7JE
=XTrA
-----END PGP SIGNATURE-----

--=-W9Ma7C82VAVEC1+5Cg3p--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
