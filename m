From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 0/8] i40iw fixes
Date: Tue, 02 Aug 2016 14:21:04 -0400
Message-ID: <1470162064.18081.26.camel@redhat.com>
References: <1468342126-29168-1-git-send-email-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-A6u4mINnj+DN1wWlWOm1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468342126-29168-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-A6u4mINnj+DN1wWlWOm1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2016-07-12 at 11:48 -0500, Shiraz Saleem wrote:
> This patch series includes minor fixes for the Intel X722=C2=A0
> iWARP driver i40iw.
>=20
> It is based on Doug Ledford's https://github.com/dledford/linux.git
> branch: k.o/for-4.8.
>=20
> Mustafa Ismail (7):
> =C2=A0 i40iw: Correct and use size parameter to i40iw_reg_phys_mr
> =C2=A0 i40iw: Do not access pointer after free
> =C2=A0 i40iw: Remove unnecessary parameter to i40iw_cq_poll_completion
> =C2=A0 i40iw: Simplify code to set fragments in SQ WQE
> =C2=A0 i40iw: Remove unnecessary check for moving CQ head
> =C2=A0 i40iw: Change dup_ack_thresh to u8
> =C2=A0 i40iw: Add NULL check for puda buffer
>=20
> Shiraz Saleem (1):
> =C2=A0 i40iw: Fix return codes
>=20
> =C2=A0drivers/infiniband/hw/i40iw/i40iw_cm.c=C2=A0=C2=A0=C2=A0=C2=A0|=C2=
=A0=C2=A04 +--
> =C2=A0drivers/infiniband/hw/i40iw/i40iw_d.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
|=C2=A0=C2=A03 ++
> =C2=A0drivers/infiniband/hw/i40iw/i40iw_puda.c=C2=A0=C2=A0|=C2=A0=C2=A04 =
+++
> =C2=A0drivers/infiniband/hw/i40iw/i40iw_type.h=C2=A0=C2=A0|=C2=A0=C2=A02 =
+-
> =C2=A0drivers/infiniband/hw/i40iw/i40iw_uk.c=C2=A0=C2=A0=C2=A0=C2=A0| 29 =
+++++++----------
> =C2=A0drivers/infiniband/hw/i40iw/i40iw_user.h=C2=A0=C2=A0|=C2=A0=C2=A02 =
+-
> =C2=A0drivers/infiniband/hw/i40iw/i40iw_verbs.c | 52 ++++++++++++++++++++=
-
> ----------
> =C2=A07 files changed, 56 insertions(+), 40 deletions(-)
>=20

These all looked good, series accepted.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-A6u4mINnj+DN1wWlWOm1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXoOSQAAoJELgmozMOVy/diksQAKhaPeyFj6Q+zpnFWad8mvfB
126ot19H3UxkljIp/1W1HfJCsW9ZZlzM/YkwPkm6Tg9KmeVd9vTVAxj7W8Nqg4dV
bo3dq6YkPRq67HwyOjViuYj3nuu46ANEWqKzm/OF4LqlC5hzSEE1x+ICvgiUBPl2
wb5cuShDyG0cDn8s8L3KdzFWZMUNwBP4jBroldQm4BmSASlDA9Ydc7yQ6kBxYpdM
iJt+FngKPC2Yq20c+86pN0LTze/6mxLyuVYVeNx6IKE6l3gI1UzclgDu4dedxRaC
VolSdYNBv/3eO0/lVOzVm+a+dgwQhDjaHGBwECbJFacOliKMWkRIzVm/AhN2504W
ZPOPMgEMyAPbN1lQICFeuxV8JYsRwqROot8hPLhvQ9bLDXUVUktAzMMI/Ft8HJNo
IcyNvF3OcXagqVZ9uFet4as/iIZQ8ZVJrw+pQZHtc4CHIvy+TXTehbUD7KPwFT1s
gopvit0fBz/BVWr0rqXsdLpSlK7mMCFyd+UY/f/Ey2AZ1O5nDEYWCh0AYtB+5BSw
uaF+U77UbkEiLdD1MmX8MJIP3CzCGQEWsvPog4/lOS3mlWudGQnGHYCjH2vIdSWi
3NF5MqfeCnuvhnjzaCOzU16J3N+TSfAc8d9UkHAaQnLhcv2gysZmpdfWJdx2Hw3N
XDjujXKJZduvciN9YWXy
=O7TY
-----END PGP SIGNATURE-----

--=-A6u4mINnj+DN1wWlWOm1--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
