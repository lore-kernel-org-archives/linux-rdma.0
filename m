From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/6] i40iw: Fixes for i40iw
Date: Mon, 12 Dec 2016 17:14:45 -0500
Message-ID: <7c31435b-a11d-fb66-700a-3243c2a97f1e@redhat.com>
References: <20161206214935.41584-1-henry.orosco@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="dDf0erCtOPiddNNTdaa1XHAbTPImxBSIm"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161206214935.41584-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--dDf0erCtOPiddNNTdaa1XHAbTPImxBSIm
Content-Type: multipart/mixed; boundary="wmE8J2OadQFebJVsqVj5NHfqXV0CABobD";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Message-ID: <7c31435b-a11d-fb66-700a-3243c2a97f1e-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/6] i40iw: Fixes for i40iw
References: <20161206214935.41584-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
In-Reply-To: <20161206214935.41584-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--wmE8J2OadQFebJVsqVj5NHfqXV0CABobD
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/6/2016 4:49 PM, Henry Orosco wrote:
> The following patch series has fixes for the i40iw driver.
>=20
> Mustafa Ismail (4):
>   i40iw: Fix double free of QP
>   i40iw: Fix memory leak in CQP destroy when in reset
>   i40iw: Assign MSS only when it is a new MTU
>   i40iw: Fix incorrect check for error
>=20
> Shiraz Saleem (2):
>   i40iw: Fix QP flush to not hang on empty queues or failure
>   i40iw: Fix race condition in terminate timer's handler
>=20
>  drivers/infiniband/hw/i40iw/i40iw.h       | 11 +++++++----
>  drivers/infiniband/hw/i40iw/i40iw_cm.c    | 22 +++++++++++++++++-----
>  drivers/infiniband/hw/i40iw/i40iw_hw.c    | 30 +++++++++++++++++++++++=
++++---
>  drivers/infiniband/hw/i40iw/i40iw_main.c  | 11 +++++------
>  drivers/infiniband/hw/i40iw/i40iw_puda.c  |  2 +-
>  drivers/infiniband/hw/i40iw/i40iw_utils.c |  5 ++++-
>  drivers/infiniband/hw/i40iw/i40iw_verbs.c |  2 +-
>  7 files changed, 62 insertions(+), 21 deletions(-)
>=20

Series applied, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--wmE8J2OadQFebJVsqVj5NHfqXV0CABobD--

--dDf0erCtOPiddNNTdaa1XHAbTPImxBSIm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYTyFVAAoJELgmozMOVy/d6A4P/2sOt/VEKxjfaBzDdaBBG+8f
WXLYNT0FM2qSP7MpSq/dcLjnUHfTuEQXkegyst/wcVLCBpRF/fnohAa9IR9xgro7
mNeG17TZUpyDS3dNOycz96E+d4nmfNTCtXSgqzB5moeU5CIk4QdEkYcwkdCKBZTx
yYyxQN3of8aBt2zPFotgDtlkYrv83D1IlS/+8LAnS2DJmDZHbfOMwtEaZqcvJVC9
DPvN2tG7s14OTdqbs0cXA2wKsT4sJAkmE+FZxuXJ6L8F6NSjlgV4/BuDa9mIioNv
wHyWnbXLKIiIyS+stilYGgXgNOJQZmqmy5Bi2WuniGGSg122LTjem0Q9mpw/nQ3L
S8Yr0ROeSdTm9sWdIl+FZBtQ9OCAISHdVFYBx7ZoW3SDdPvsTX+c/gZIW56Bc8CX
PmfHo1fK0Iv34mSLtTqgMH+/xYZkh63jeI35GqwAlIeDqt69HTL3aI3j2tFcB6hn
QzTFI0kXaIDeRsV3f6unCYR3ovm/TCZxO2daNoYiQGDmrtQTyyGWo4LyfAEI4Vsx
v7vHOygT9CKeckarI88532UHgUez+ac+AMnvx6+3vPojz+ZlDjUHxVfk90pu6HlT
UavdVottp6Zb1GtZ+hMLlK1+rjZ4ch8UMa/i2S4cM7gBUQwXzuWTOeCcsLMbDwxB
nLX/SaOeY6p3eT7P/PmV
=FWtD
-----END PGP SIGNATURE-----

--dDf0erCtOPiddNNTdaa1XHAbTPImxBSIm--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
