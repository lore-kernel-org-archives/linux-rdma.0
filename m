From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/2] IB/rxe: Replace in kernel memory
 registration support
Date: Tue, 12 Jul 2016 10:55:29 -0400
Message-ID: <edd9f4b6-9634-c5df-3f4d-ed8b4411cd44@redhat.com>
References: <1467734750-20298-1-git-send-email-monis@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bX18WrQkPm8GFpADonllH2FbD18aIom6T"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467734750-20298-1-git-send-email-monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bX18WrQkPm8GFpADonllH2FbD18aIom6T
Content-Type: multipart/mixed; boundary="8EGJhW5AgLDWrhaUXiGXwpirCSgElbAcj"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
 leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Message-ID: <edd9f4b6-9634-c5df-3f4d-ed8b4411cd44-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/2] IB/rxe: Replace in kernel memory
 registration support
References: <1467734750-20298-1-git-send-email-monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
In-Reply-To: <1467734750-20298-1-git-send-email-monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--8EGJhW5AgLDWrhaUXiGXwpirCSgElbAcj
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 7/5/2016 12:05 PM, Moni Shoua wrote:
> Registering memory regions in ULPs is implemented with 2 sets of API, F=
MR
> and FastReg. FMR is considered obsolete and FastReg is what modern driv=
ers
> should implement.
> The patches in this series add FastReg and remove FMR support form the
> SoftRoCE driver.
>=20
> Moni Shoua (1):
>   IB/rxe: Remove FMR support
>=20
> Sagi Grimberg (1):
>   IB/rxe: Add fast memory registraion and remote invalidation) support
>=20
>  drivers/infiniband/hw/rxe/rxe.c        | 18 ++-----
>  drivers/infiniband/hw/rxe/rxe_loc.h    |  3 --
>  drivers/infiniband/hw/rxe/rxe_mr.c     | 44 ++-------------
>  drivers/infiniband/hw/rxe/rxe_opcode.c |  4 +-
>  drivers/infiniband/hw/rxe/rxe_opcode.h |  1 +
>  drivers/infiniband/hw/rxe/rxe_param.h  | 11 ++--
>  drivers/infiniband/hw/rxe/rxe_pool.c   | 10 +---
>  drivers/infiniband/hw/rxe/rxe_pool.h   |  1 -
>  drivers/infiniband/hw/rxe/rxe_req.c    | 36 +++++++++++++
>  drivers/infiniband/hw/rxe/rxe_resp.c   | 16 ++++++
>  drivers/infiniband/hw/rxe/rxe_verbs.c  | 98 +++++++++++++-------------=
--------
>  drivers/infiniband/hw/rxe/rxe_verbs.h  |  8 +--
>  include/uapi/rdma/ib_user_rxe.h        |  5 ++
>  13 files changed, 114 insertions(+), 141 deletions(-)
>=20

Series applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--8EGJhW5AgLDWrhaUXiGXwpirCSgElbAcj--

--bX18WrQkPm8GFpADonllH2FbD18aIom6T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXhQThAAoJELgmozMOVy/d05sP+wd0Tk9owQNVkouVjoKs71jJ
idBDdumTx9lax5pDpWN6Ku3cnfHYJTmUqUU30xHsI0k9h+0eCPedvhZA4lSzB0M/
4m/G9wn+oHV4yfvn/UZMzFYNCY1Z5qgEsPuGYvPweDBZW5c8zxyP52mgfpumJKyE
JXi2Wo2fXyJ1C24/GFEnQGxcudOvSePYDKaqkysTjFL3zLbC9xCpOQegNT4Erksa
/8Mu3iUd2dMEbOWQcYkCy57a3PHfBD5Rh7Ae8EJEfya1HVtx9t6fauw7H1eRnNKy
d5g4tG86NLL1LAr5xG83dLCfAqauvQhky6apwda86k7jYCnnKNTiHXVDQ1CI5CgR
EyAVFWS5aj5+upNH6iB34U1nOIi2Dn2k4yePvdOwL5Hmij8deEXUbzisz1zUqXx7
TbLoX+577bX2SWjqYxdZ34rBIzuP1aLCTxBCVqEwo0DUHTsrnvdkgAPLzEvG1OKj
rrfzzDhCyk4tqgXRP///Mv7pAGyoqAFXQPb6ifcQPXNsvbwmjYdBq38xOyu/nriz
uasFHVdA/TsBRFgrkloSCcB1xc+cBVwX17mrvot05EdoMapP/fv5jZG4f1uXimTO
DKafuZEUr3wUs0+lIyddYLv64aCumlt0VmMKibO8WQ0KuN17hlVO7MXrC58tFidD
c8SMxnuFmF1lKOf8FxSa
=EOEx
-----END PGP SIGNATURE-----

--bX18WrQkPm8GFpADonllH2FbD18aIom6T--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
