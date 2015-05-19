From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v8 0/6] Generic logging helpers
Date: Tue, 19 May 2015 11:34:11 -0400
Message-ID: <1432049651.3114.39.camel@redhat.com>
References: <1432028899-15211-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-p6C2aQsCWWolmxOCKbW4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432028899-15211-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-p6C2aQsCWWolmxOCKbW4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-05-19 at 12:48 +0300, Sagi Grimberg wrote:
> This small set adds some meaningful verbosity to some
> of the core/rdma_cm enumerated events. Its useful to
> see the meaning of the opcodes instead of revisiting the
> code for every new status/event that left the cache in
> our brain.
>=20
> Many thanks to all the reviewers!

Hi Sagi,

I grabbed v7 already, but I manually added Sean's typo catch to it when
I picked it up.  So it's the same as your v8.

> Changes from v7:
> - Fixed typo for IB_WC_REM_INV_RD_REQ_ERR wc status
>=20
> Changes from v6:
> - Lowered case for unrecognised event/status print
> - Fixed typo in IB_WC_REM_INV_REQ_ERR string
>=20
> Changes from v5:
> - Changed message strings to match the xprtrdma style
> - checkpatch nit
>=20
> Changes from v4:
> - Split up ULP changes to separate patches
>=20
> Changes from v3:
> - Protect against "holes" in string arrays
> - Restored __attribute_const__ to functions prototype
> - Made string arrays rodata
>=20
> Changes from v2:
> - Cast to size_t instead of unsigned
> - Style fix in string arrays declaration
> - Removed redundant __attribute_const__
>=20
> Changes from v1:
> - Changed helper names ib_wc_status_msg and rdma_event_msg
> - Cast input arguments to protect string buffer access
> - Add svcrdma to the party
>=20
> Changes from v0 (RFC):
> - Moved string arrays to .c files
> - Changed string helpers from macros to exported functions
> - Aligned rds to generic helpers as well
>=20
> Sagi Grimberg (6):
>   IB/core, cma: Nice log-friendly string helpers
>   IB/srp: Align to generic logging helpers
>   IB/iser: Align to generic logging helpers
>   iser-target: Align to generic logging helpers
>   xprtrdma, svcrdma: Switch to generic logging helpers
>   RDS: Switch to generic logging helpers
>=20
>  drivers/infiniband/core/cma.c            |   28 +++++++++
>  drivers/infiniband/core/verbs.c          |   65 +++++++++++++++++++++
>  drivers/infiniband/ulp/iser/iser_verbs.c |   28 ++++++---
>  drivers/infiniband/ulp/isert/ib_isert.c  |   19 ++++--
>  drivers/infiniband/ulp/srp/ib_srp.c      |   16 +++--
>  include/rdma/ib_verbs.h                  |    4 +
>  include/rdma/rdma_cm.h                   |    2 +
>  net/rds/af_rds.c                         |    9 ---
>  net/rds/ib.h                             |    1 -
>  net/rds/ib_cm.c                          |   36 +-----------
>  net/rds/ib_recv.c                        |    4 +-
>  net/rds/ib_send.c                        |   38 +------------
>  net/rds/rdma_transport.c                 |   34 +----------
>  net/rds/rds.h                            |    1 -
>  net/sunrpc/xprtrdma/frwr_ops.c           |    4 +-
>  net/sunrpc/xprtrdma/svc_rdma_transport.c |   29 ++++++----
>  net/sunrpc/xprtrdma/verbs.c              |   90 ++----------------------=
------
>  17 files changed, 174 insertions(+), 234 deletions(-)
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-p6C2aQsCWWolmxOCKbW4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVW1fzAAoJELgmozMOVy/dINcP/R5DjiNF0k8Ty6DWrOppnFiL
fs+o+gWWklUsCsy9kssxQ18xDvC/c88ebD+qhUbVq7m4N5mjM9FuADG4QA1ct+hY
QMH1Hq7wh2vF3JpYNWE0gAov7VnXifP8hFT7xd6f0Qim5Ji57qErhiUbmYxLuGFV
aUmSGa6CEH/MNtFfAE9s5ieXgonQHheoTFtvovK8ynyEa9sVxNus3xOLstejka1e
VBUTByhOHmYGNdDaB3Wy+O3ye6Xo2aVUHd/LW3l2lkuI1Rxg0tU1qXNU5JCkpz7N
oACSldufVYcqV0f+cRWMFteZTcUg5tK1232yszLSkFNUuuNxpOEZ3lmbYN5/+HTS
vHLZ+LFX/bsPrDF+cf8vdhyXTclZVLhkivaExwduX8pX1u6/3FwzjNvnv3JVYd6h
mfKb/jIF94m3FPfiO85vqYjGTkRXBI5MQKZrlnB+l05VHSKgDRCc78Xp8Ki9UPKz
D+SQbh/+rDQHGpTMlSKtDzwxdW+Gczev7p9e0cGJT+JEoBIFniUlE1QXPbXOCHFu
OJ7ydD69ywZqHa16tVyhC1TkNYLtue6rv1j/Y7JarKe2VAH7dYIydfeQrtwy+qv7
Uy3LTiE/shFnSsT91mD0X361EZM1ZJkcWqkGMc7DNsYHJK6+wb5PH/Ap6Wm5OJSW
srwEnHbQqc3VnTzgDj/R
=mtv6
-----END PGP SIGNATURE-----

--=-p6C2aQsCWWolmxOCKbW4--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
