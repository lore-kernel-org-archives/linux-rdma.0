From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Fri, 10 Feb 2017 14:42:02 -0500
Message-ID: <1486755722.86943.29.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-3VoDKneLczU9DdIHrTQO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-3VoDKneLczU9DdIHrTQO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

This is a very small pull request. =C2=A0Two security related patches that
you know about, and a compile error problem.

The following changes since commit
b4cfe3971f6eab542dd7ecc398bfa1aeec889934:

=C2=A0 RDMA/cma: Fix unknown symbol when CONFIG_IPV6 is not enabled (2017-
01-27 14:29:04 -0500)

are available in the git repository at:

=C2=A0 git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to
646ebd4166ca00bdf682a36bd2e1c9a74d848ac6:

=C2=A0 RDMA: Don't reference kernel private header from UAPI header (2017-
02-08 12:28:49 -0500)

----------------------------------------------------------------
Third round of -rc fixes for 4.10 kernel

- Two security related issues in the rxe driver
- One compile issue in the RDMA uapi header

----------------------------------------------------------------
Eyal Itkin (2):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0IB/rxe: Fix resid update
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0IB/rxe: Fix mem_check_range integer ove=
rflow

Leon Romanovsky (1):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0RDMA: Don't reference kernel private he=
ader from UAPI header

=C2=A0drivers/infiniband/sw/rxe/rxe_mr.c=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A08 ++=
+++---
=C2=A0drivers/infiniband/sw/rxe/rxe_resp.c |=C2=A0=C2=A02 +-
=C2=A0include/uapi/rdma/ib_user_verbs.h=C2=A0=C2=A0=C2=A0=C2=A0| 11 +++++++=
+---
=C2=A03 files changed, 14 insertions(+), 7 deletions(-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-3VoDKneLczU9DdIHrTQO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYnheKAAoJELgmozMOVy/d9EIQALZLgXrQvWIFmaCtQjnieLs3
CAp/+r3t05pAGEmST/3vby3euXty4X9bcJITI3Ih5zQYm3NBVqDirh/sHTmIe2qC
Ks/WGjen5Uc8NZgBAhkDNhBINV51m+inuHu8bol7UQnBH+K/Dptaalxw7b74dkOe
YUvmZ+DUYLn6WouB2PsUB3kZalkDFicHSVYjOhtGVg+psOvvn47EoWb4ZYjKHQPL
NnusYmV+RFMP6X1uPF8M840piyKZcdlJ0IGzJuIZ1s7uA7PU1ypBN3v3uFLEBHv+
/b7WpWiBvXnVfN57I3h7txnO31IWfwjPPJGUnAVAd7qFIQoVH3DbTmvCCyDCPYnd
JGcgtE1E/X130uE/XU4CZFVM30qmFbXLpLxm+98aLWth/fOOeboFU3p9mt0A+GCa
uwizn2zH/wbLTreLdT99t2FCZ+EJa3M6TP1KBBVbE6P/lxpbfNshBprEozgNg03i
QoIxon29E+79G6IsUW8l7lh9FkOpv9iI299JmRu7P7tUJm/T0UsSsUCmR1Ora+3W
SN9TdKYMjB/tindiwkArbGbuXn2hDl/APzqH7djOF9qY+84uX8fqOrTF55zYrvz9
E2TYVdxz2I0HF3NpwBIBBgkxM0Lb22Ya9vs5s0c/lhMkFT+2VpnosFttgsqce/0R
lcsSwwzpIsvrECAGvT99
=8CE/
-----END PGP SIGNATURE-----

--=-3VoDKneLczU9DdIHrTQO--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
