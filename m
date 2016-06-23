From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 0/7] RDMA/iw_cxgb4: Misc. fixes cleanup and low
 resource fixes
Date: Thu, 23 Jun 2016 10:41:36 -0400
Message-ID: <e18e4f0e-e70c-d974-92f2-aba516772f3d@redhat.com>
References: <1465500917-18491-1-git-send-email-hariprasad@chelsio.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TkrcrhK2Oqhei6B8nJPLRlLNl3wiFCCQn"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465500917-18491-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TkrcrhK2Oqhei6B8nJPLRlLNl3wiFCCQn
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 06/09/2016 03:35 PM, Hariprasad Shenai wrote:
> Hi
>=20
> This patch series add low resource fixes for connection management,
> memory registration and for completion queue teardown. Cleans up
> c4iw_reject_cr function, allocates enough space for debugfs qps dump so=

> IPv6 address doesn't get truncated, also adds missing error codes for
> active open CPL command. Atlast read module parameter markers_enabled,
> should be read only only once, so that the value remains the same
> throughout MPA negotiaion.
>=20
> This patch series has been created against Doug Ledford's linux tree,
> "for-4.7-topics/cxgb4-2" branch and includes patches on iw_cxgb4 driver=
=2E
>=20
> We have included all the maintainers of respective drivers. Kindly revi=
ew
> the change and let us know in case of any review comments.
>=20
> Thanks
>=20
> Hariprasad Shenai (7):
>   RDMA/iw_cxgb4: markers_enabled module parameter should be read only
>     once
>   RDMA/iw_cxgb4: allocate enough space for debugfs "qps" dump
>   RDMA/iw_cxgb4: clean up c4iw_reject_cr()
>   RDMA/iw_cxgb4: Add missing error codes for act open cmd
>   RDMA/iw_cxgb4: Low resource fixes for connection manager
>   RDMA/iw_cxgb4: Low resource fixes for Memory registration
>   RDMA/iw_cxgb4: Low resource fixes for Completion queue
>=20
>  drivers/infiniband/hw/cxgb4/cm.c            | 187 ++++++++++++++++++--=
--------
>  drivers/infiniband/hw/cxgb4/cq.c            |  42 ++++---
>  drivers/infiniband/hw/cxgb4/device.c        |   2 +-
>  drivers/infiniband/hw/cxgb4/iw_cxgb4.h      |  22 ++++
>  drivers/infiniband/hw/cxgb4/mem.c           | 107 ++++++++++------
>  drivers/infiniband/hw/cxgb4/qp.c            |  12 +-
>  drivers/net/ethernet/chelsio/cxgb4/t4_msg.h |   2 +
>  7 files changed, 250 insertions(+), 124 deletions(-)
>=20

Series applied.  Although, was a bit confusing that the patches all said
net-next in their header.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--TkrcrhK2Oqhei6B8nJPLRlLNl3wiFCCQn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXa/UgAAoJELgmozMOVy/dSXAQALsywlext1OmyyYLdOkAC+S7
UzYGAoLy8H76lD9QgS0XEInf+ScLPfV5BGZKghRr2YhsLZffD7O2WgYgSuL2CA6P
K7IUE8JYI78vPaej5OerR/OzhklQlLKusZ+UbdJgmJ56zlmqbSrWVktUEjStrdGn
QksVFmrzbqcGxumFts/obBLPVPVAngA2s5cZgCsjdrxBcnXa+cw3eikgZfhVHrsS
8U7kGD4rju03sH0Onnhy6dyaN7iiJQGIYDK0448fwqR8uVDEpQlNeSbPJBxZajMi
PL9URLZ+Dyb3Jqlr/7a+D1ZEJW+fhbW9rE6QDOhizoi6b9axdBag3AEvDs/H38un
SdI2umHaEbVFn6cMPwsAqvktmTwwIeTOqibwllbP4WDKwIt+pj5Pv14QDLoOjA/3
MsXUzmvbXeb+PuyQJx5zt2MnFejS/C/jRk+6KmKS8EmIPr/BqOcu8IhSpY8U7aKN
wFjxL/W1+An7gtOaxX2hKgH0TaVAZ1qHEDxhPfifRq4sajguXCMBAX8oC8/+ZZUR
TAQxpACPDwduaeULRBPrbor6uouvM0k2or0fJYWKwJ9DNI6KDi1r4um+BOgbcgy4
930+xPah7goOds8OY0ZiUn+f8UUT42K6FhEuo2yHOOjgdC81aAcvoQ4KBU3nrYcb
B4oN3CrmeGHObMNbzomZ
=6M9J
-----END PGP SIGNATURE-----

--TkrcrhK2Oqhei6B8nJPLRlLNl3wiFCCQn--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
