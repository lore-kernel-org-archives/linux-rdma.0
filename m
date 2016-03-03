From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 00/10] IB/mlx5: Use wr.ud.pkey_index in GSI QP
Date: Thu, 3 Mar 2016 10:47:38 -0500
Message-ID: <56D85C9A.7020401@redhat.com>
References: <1456753512-17688-1-git-send-email-haggaie@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="BHaD7lNJQaD3BcbDwCX7nshm13OSb9mm2"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456753512-17688-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BHaD7lNJQaD3BcbDwCX7nshm13OSb9mm2
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 02/29/2016 08:45 AM, Haggai Eran wrote:
> The check of BTH P_Key for RDMA_CM requests was introduced in patch
> 4c21b5bcef73 ("IB/cma: Add net_dev and private data checks to RDMA CM")=
=2E
> A side effect of that change was the unexpected behavior of the mlx5 dr=
iver
> in handling the pkey_index in ib_send_wr.ud in GSI packets.  The pkey_i=
ndex
> in ib_wc was not set correctly [1], and in addition, we found out that =
the
> mlx5 driver did not respect the pkey_index in ib_send_wr.ud for GSI
> packets. Since the pkey_index in a Work Request is not explicitly requi=
red
> by the IBA specifications, the Connect-IB and ConnectX-4 adapter cards =
do
> not support it.
>=20
> This patch fixes the issue inside the mlx5_ib module. It emulates a sin=
gle
> GSI QP by creating multiple QPs underneath the surface. An ordinary GSI=
 QP
> is created for receiving MADs destined at QP 1, and multiple transmissi=
on
> QPs are created for sending MADs. These QPs behave like UD QPs, althoug=
h
> they use QP 1 as their source QP number. The QPs are created on-demand,=
 one
> for each non-zero P_Key in the P_Key table.
>=20
> The driver handles reordering of the completions to make sure they are
> reported in the same order their matching Work Requests were posted.
>=20
> A spinlock in the emulated GSI QP struct protects concurrent access to =
the
> transmission QPs from post send operations and from their creation
> following a P_Key table change. In addition, it protects the Work Reque=
st
> list that maintains the completion order.
>=20
> The patchset is divided as follows. The first patch adds the infrastruc=
ture
> required for creating additional QPs that send as QP 1. The following p=
atch
> adds some helpful debugging prints to the QP modification code. Patch 3=

> adds a skeleton code for an emulated GSI QP. The next two patches creat=
e
> the multiple transmission QPs. Patches 6-7 handle the reordering of the=

> completions. Patches 8-9 enable the use of the created QPs and remove t=
he
> send queue buffer from the receive GSI QP. Finally patch 10 reverts the=

> change in "IB/cma: Use inner P_Key to determine netdev".
>=20
> These patches apply against kernel v4.5-rc6.
>=20
> [1] mlx5: Fix incorrect wc pkey_index assignment for GSI messages
> http://www.spinics.net/lists/linux-rdma/msg28374.html
>=20
> Haggai Eran (10):
>   IB/mlx5: Add support for setting source QP number
>   IB/mlx5: Modify QP debugging prints
>   IB/mlx5: Add GSI QP wrapper
>   IB/mlx5: Create multiple transmission GSI QPs
>   IB/mlx5: Create GSI transmission QPs when P_Key table is changed
>   IB/mlx5: Generate completions in software
>   IB/mlx5: Reorder GSI completions
>   IB/mlx5: Pick the right GSI transmission QP for sending
>   IB/mlx5: Eliminate GSI RX QP's send buffers
>   IB/cma: Print warning on different inner and header P_Keys
>=20
>  drivers/infiniband/core/cma.c        |   8 +
>  drivers/infiniband/hw/mlx5/Makefile  |   2 +-
>  drivers/infiniband/hw/mlx5/cq.c      |  83 +++++-
>  drivers/infiniband/hw/mlx5/gsi.c     | 548 +++++++++++++++++++++++++++=
++++++++
>  drivers/infiniband/hw/mlx5/main.c    |  30 ++
>  drivers/infiniband/hw/mlx5/mlx5_ib.h |  57 +++-
>  drivers/infiniband/hw/mlx5/qp.c      |  95 ++++--
>  include/linux/mlx5/mlx5_ifc.h        |   3 +-
>  include/linux/mlx5/qp.h              |   3 +-
>  9 files changed, 802 insertions(+), 27 deletions(-)
>  create mode 100644 drivers/infiniband/hw/mlx5/gsi.c
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--BHaD7lNJQaD3BcbDwCX7nshm13OSb9mm2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW2FyaAAoJELgmozMOVy/d014QAJF7XCeH99fyQDgue61QLf5R
FdxeHfMoIK1B52fDW44mbAiQafG0dUnGCYHdGP20A6sUGM7iYquCKSaXuXiHxUhI
84/MGeUskhnDfCGekpB5vGrmTY1CmOY9foNSsLhZ+2ZW5Dh9THgww8U0NDu9jOpS
74f+826GoNkZSgZOYKRPKMY/2j6CWZFzTlNfrd96ROtmDZDJs48a6tVmVg/N8zoY
2rSyy16CpzUHHj7zdoNsfxv2OQcytYDJFzEV8B4Cq7d4u3lIuiug+asKEqQNh9lQ
7sY8vb5rb9u+RwIZxvfO2rj1N2vSxIuzHE3J7ShiP2a4egfpu0eB6Th806IrtRy+
WPTFuytnnpJBxMbwO/PemPWiIN+imiC1SPXSVSa3+ZuNoG+OkPqCGdVbYU4mQne7
fC4l9JcMPFbNMr+NJCXopKH94yFyBbdpoYLXrpxMnlu5tiEZhiArbG5If7aI0UT+
a2frP5kWFQCuOYzLMCW4M5afzti6qCUKLBrBjZyzA1E7511310cYZgGqcX0ewlPO
gmY9V/XHNZRJt1RI3lI3MqFaxgML5LPoTIZKAAJnUvdAps7oS9CJHjGHj6/hwirZ
4NfYEeqmV88qQ2jDB2TfPd7o9qzTW33Cp8Mz3a9yehMCTO6qRjUCz9EIIxGikkNk
cK01DvO4SUdRJlVs5h1B
=pOH7
-----END PGP SIGNATURE-----

--BHaD7lNJQaD3BcbDwCX7nshm13OSb9mm2--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
