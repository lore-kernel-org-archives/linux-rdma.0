From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V2 00/10] i40iw: Fixes and optimizations
Date: Sat, 10 Dec 2016 16:47:25 +0200
Message-ID: <20161210144725.GD2521@mtr-leonro.local>
References: <1481306104-19352-1-git-send-email-tatyana.e.nikolova@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="LTeJQqWS0MN7I/qa"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1481306104-19352-1-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--LTeJQqWS0MN7I/qa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 09, 2016 at 11:54:54AM -0600, Tatyana Nikolova wrote:
> The patch series includes fixes, optimizations and
> clean up to the user space i40iw.
>=20
> V2 Changes:
>=20
> Use do/while(0) in i40iw_debug macro.
>=20
> Mustafa Ismail (4):
>   i40iw: Optimize setting fragments
>   i40iw: Remove unnecessary parameter
>   i40iw: Optimize inline data copy
>   i40iw: Remove unnecessary check for moving CQ head
>=20
> Shiraz Saleem (6):
>   i40iw: Fix incorrect assignment of SQ head
>   i40iw: Return correct error codes for destroy QP and CQ
>   i40iw: Do not destroy QP/CQ if lock is held
>   i40iw: Control debug error prints using env variable
>   i40iw: Use 2M huge pages for CQ/QP memory if available
>   i40iw: Remove SQ size constraint

Hi Tatyana,

I merged all patches except "i40iw: Control debug error prints using
env variable" and "i40iw: Use 2M huge pages for CQ/QP memory if available".

For the first patch, I gave rationale by responding to that patch. The
seond patch adds new environmental variable, which is better to be in
common place.

Thanks

>=20
>  providers/i40iw/i40iw_d.h      |   6 +-
>  providers/i40iw/i40iw_uk.c     |  62 ++++++++------------
>  providers/i40iw/i40iw_umain.c  |  21 ++++++-
>  providers/i40iw/i40iw_umain.h  |  11 ++++
>  providers/i40iw/i40iw_user.h   |   2 +-
>  providers/i40iw/i40iw_uverbs.c | 128 ++++++++++++++++++++++++++++++-----=
------
>  6 files changed, 153 insertions(+), 77 deletions(-)
>=20
> --=20
> 1.8.5.2
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--LTeJQqWS0MN7I/qa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhMFWMACgkQ5GN7iDZy
WKe2gA//QR+eeSouxIiraiotkxAjEAdpyqhTeWQtaPkLqoOkjIgY9fMJo+FOz2/t
PgvmTNiLgNpYZNUhL2MLoZD7IfkGHNuDekmroylZm+76dUKgxca33vHh11+aADM5
1x+IDHfnwayLBrJEY9tB1mL5+8qHxDq1faJ+1DFRCM5B3FxUp3sUi/hZ3e8oQpFp
OUf89m9uqji763qvWb+qGDpUoOM+SRqCGBqsX7s1aWUz5WpJ1rdyBu710IW4f1Zh
2Zo1gk62eOKUB/BgIu7CIDdCRYthHuyWEWIOwSCdKe00tSbCkMHgZPq2aShG6O70
VOdK1LiS9N77TtSVDdoiDzGRf2Xp16Hw8vH/n3EMtcwR6lg6x7Ju25y8CO6cFbL2
nyh2yzuQPKruHB9dZz9KXalWVK3MgzWsaBL3dTNizC3ffEvvPnSbUnGKjnjSbNJj
Y62WWgY29A6rF+Sw2HSd4LX6Po7KEo5VcGs5m2l6cBf2VKrlQ+96KQ5CBsvsR6Rz
oGnPsvLrl30bP70qJqF5rjJ+qCYRQ+FlubYPB6bxBPE2mkRkVtjE+ZBhSJ53KQcw
2jpiJn4sPYdmf0m+1GY7Y2pDPAySCQ5//qNvEZcB9hDxd1yHqrobwIEHtVJ6Tuby
pisxFnq0Jsg79DUjujb2tVrhG0AB5nsP318fKQtDKV3g/Qno0iI=
=Sv+p
-----END PGP SIGNATURE-----

--LTeJQqWS0MN7I/qa--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
