From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/8] i40iw: Fixes for i40iw
Date: Sat, 22 Jul 2017 13:25:18 -0400
Message-ID: <2609abfb-0930-4fe5-1b23-f2fb7bc78af2@redhat.com>
References: <20170623210402.19988-1-henry.orosco@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rovLhuTttjSSVsx6gOpUPuCeGJ6KP9s87"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170623210402.19988-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rovLhuTttjSSVsx6gOpUPuCeGJ6KP9s87
Content-Type: multipart/mixed; boundary="R1aWD3KXQ9OGbc88DLsqL2ESJaOkRtt4V";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Message-ID: <2609abfb-0930-4fe5-1b23-f2fb7bc78af2-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/8] i40iw: Fixes for i40iw
References: <20170623210402.19988-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
In-Reply-To: <20170623210402.19988-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--R1aWD3KXQ9OGbc88DLsqL2ESJaOkRtt4V
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/23/2017 5:03 PM, Henry Orosco wrote:
> The following patch series has fixes for the i40iw driver.
>=20
> Henry Orosco (2):
>   i40iw: Add missing memory barrier
>   i40iw: Update list correctly
>=20
> Mustafa Ismail (2):
>   i40iw: Fix order of cleanup in close
>   i40iw: Do not poll CCQ after it is destroyed
>=20
> Shiraz Saleem (4):
>   i40iw: Utilize iwdev->reset during PCI function reset
>   i40iw: Release cm_id ref on PCI function reset
>   i40iw: Free QP resources on CQP destroy QP failure
>   i40iw: Avoid memory leak of CQP request objects
>=20
>  drivers/infiniband/hw/i40iw/i40iw.h       |  1 +
>  drivers/infiniband/hw/i40iw/i40iw_cm.c    |  5 ++-
>  drivers/infiniband/hw/i40iw/i40iw_ctrl.c  |  2 ++
>  drivers/infiniband/hw/i40iw/i40iw_main.c  | 60 +++++++++++++++--------=
--------
>  drivers/infiniband/hw/i40iw/i40iw_puda.c  |  5 ++-
>  drivers/infiniband/hw/i40iw/i40iw_utils.c | 60 +++++++++++++++++++++++=
++++++--
>  6 files changed, 99 insertions(+), 34 deletions(-)
>=20

This series was accepted into 4.13-rc, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--R1aWD3KXQ9OGbc88DLsqL2ESJaOkRtt4V--

--rovLhuTttjSSVsx6gOpUPuCeGJ6KP9s87
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZc4p+AAoJELgmozMOVy/dqGsP+gPiBb/94Z8gBb3zUUu0alZu
qDbItpbZNheaSlGX8AADrV+7NEXnkn5uTYb2SOQCm7uUt+OtMrOsB/oXFqsuW+CV
q0fCGvQY2w507aAO21upKGtQqcN/JGyQV22dLcJdkrirxR75pvVpc+wzb15mUfpw
F5OU/TaDPIYBoEHzBjYxrIQr2XlhluuqRyyf19ZVMsYpX+5eByCjtuFjWxRuKZZW
SewPPU4afPXA60Bj9VHllMSOBY2vjkF03seHfNL+G5+fmcXeDNTc7nPGuF92COf0
o6+kUSpuaWR8yeLnnag4NbV8dEYJGpWkSdWBxdlEdNAbgY+o0S2QROqpKBMBAI3u
XoIlp1m8NFqjD85D2uGArFOq7dPzOkkEYSmvuRd2hBUHNHCT8MujQtAvInZs+Eem
Ir8acOUkfiQHhUco9e+Okkh9c9Q+/9vJujkZ9kfvUvlYxZo3K351sKviACE5E5RJ
6HTblniZ5Ez3cF78Ifo3hNeFMn9LoKajXnwNcFuvWVaX9qAbOewDK+0O9XHFG8qi
OH0ie3SWueevSRNO2LuXX4NISvnzppS64FfK2fNQFgPbUllZ9jhueiMp0sJsIH5A
4rkYKHVCmmiV+Xuqqa210w0FGvB+ddsn37x2UBZur2kjljfLpTzZFV5sjdufVrxj
SoFqonOW5VTiGG71pm/W
=VPhb
-----END PGP SIGNATURE-----

--rovLhuTttjSSVsx6gOpUPuCeGJ6KP9s87--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
