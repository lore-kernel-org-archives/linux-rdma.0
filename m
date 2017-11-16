From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Thu, 16 Nov 2017 16:39:22 -0500
Message-ID: <1510868362.8751.14.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-4CcLsXpkMt76B1rRzSTo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-4CcLsXpkMt76B1rRzSTo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

This is a super small pull request.  One patch only, and only a few
lines.  But, it's a change that we've been waiting to get all finalized
and it *just* now became a legal "done deal", so to speak.  And it's
timing couldn't be better.

The change is simply to add Jason Gunthorpe to the MAINTAINERS file for
the RDMA stack (and update him in the .mailmap).  Jason and I have
talked offline, and Jason will be filing a ticket with the k.o helpdesk
to get an account on k.o, and then we will likely move the rdma tree to
an area where we can both access it and use a shared repo + individual
topic branches + merged up for-next branch as the staging basis for each
release.

Timing here is nice because in the US we are headed into a holiday
period whereas Jason will be around to keep the patch flow progressing
(I guess Canadians do their equivalent to Thanksgiving in October, so he
doesn't have an excuse to ignore email for the next week ;-)).

Here's the boilerplate:

The following changes since commit
4190b4e96954e2c3597021d29435c3f8db8d3129:

  RDMA/core: Rename kernel modify_cq to better describe its usage (2017-
11-13 16:59:22 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to e6e58e7774148b0d20bcdf7bab097e51ddb758d1:

  RDMA: Add Jason Gunthorpe as a co-maintainer (2017-11-16 15:56:29
-0500)

----------------------------------------------------------------
Add Jason Gunthorpe as co-maintainer of the RDMA stack

----------------------------------------------------------------
Jason Gunthorpe (1):
      RDMA: Add Jason Gunthorpe as a co-maintainer

 .mailmap    | 2 ++
 MAINTAINERS | 1 +
 2 files changed, 3 insertions(+)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-4CcLsXpkMt76B1rRzSTo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloOBYoACgkQuCajMw5X
L93JaA//Yn6DqprzOpDXbyeM+69Sqr1a3jQsZhG+5XphGLB1rvDqeDXQBpClzSac
VZWmRLX0CzMsYXl/KmejhhsGt1IYtcwljW7qOQo5ze0CmY3oSDLnZK8UI9GKx8cN
GZyG9CC5QLquVb2cf0a6Rh17nvyRBF5cj5D9MbdPhQJN0UglaRDCw7sZgiV6tzmg
eOMFps8Mrnkr3Vnm4XTq990jkM3X/F4AJNscfqLb+90hoLW1x3B+FqUK/4KarUqb
bOaHD7qWzIdjmmZELtL2PqgpRaHEba+ceNO4Lj7/fT/sWDOu1IZ4sD3/3sftV8TQ
V2tDuXFuaCzcwzmIvBje4hVjgP5AccQNrP346ZJlDaTYE01rurmLDOmHVGA1Aey8
KHET2rErjmIsZau54i8M2Xp2/vmkxZC8b6dZIHmrFlLO/PYYdkxldKi44S+lLUaW
RETniTXjsHsVA1MpcuJV/ewGlBwSAzR+M7cW2vsuW2JOVPceeJjerDblXqLBYnBY
g0ZrhPNCMzk25j7zylkMCsC5MLkq/1j8LIOLtUuMJBxjsoMO7cdKIXZa8xwxbG6n
P6QZY/mi0BG5YAhWkh9AT8jCcDtLIkVIa0AywZX+F9NtGKall2KpokZPSycpb8gS
tVc/yPWwI4PR4izf8UO0SN7hTLzRSZwgz55IhNNflomItRqk0vs=
=BsG+
-----END PGP SIGNATURE-----

--=-4CcLsXpkMt76B1rRzSTo--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
