From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/8] IB/hfi1, qib, rdmavt: Additional fixes and updates
 for 4.7
Date: Tue, 24 May 2016 11:46:28 -0400
Message-ID: <4f704889-f271-6a13-f1be-94f4ede62765@redhat.com>
References: <20160519000433.30706.21093.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8QIRfabDqLmHuaVu6Jp2T976DFtgRhF6t"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160519000433.30706.21093.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8QIRfabDqLmHuaVu6Jp2T976DFtgRhF6t
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 05/19/2016 08:21 AM, Dennis Dalessandro wrote:
> Here are a few more patches that would be good to get into 4.7 merge wi=
ndow. Two
> of the fixes are for build warnings on new versions of gcc. There are a=
 couple
> bug fixes and some minor clean ups.
>=20
> This patch series should apply on Doug's k.o/for-4.7 branch.
>=20
> Patches can also be viewed in my repo at:
> https://github.com/ddalessa/kernel/tree/for-4.7
>=20
> ---
>=20
> Dennis Dalessandro (1):
>       IB/hfi1: Remove anti-pattern in cdev init
>=20
> Ira Weiny (1):
>       IB/hfi1: Remove unnecessary comment
>=20
> Jianxin Xiong (1):
>       IB/hfi1: Fix bug that blocks process on exit after port bounce
>=20
> Jubin John (3):
>       IB/rdmavt: Use kzalloc_node
>       IB/hfi1: Fix sdma_event_names[] build warning
>       IB/qib: Remove unused qib_7322_intr_msgs[]
>=20
> Mike Marciniszyn (1):
>       IB/rdmavt: Insure QP vmalloc variants zero memory
>=20
> Mitko Haralanov (1):
>       IB/hfi1: Fix an interval RB node reference count leak
>=20
>=20
>  drivers/infiniband/hw/qib/qib_iba7322.c |   15 ---------------
>  drivers/infiniband/sw/rdmavt/mr.c       |    4 +++-
>  drivers/infiniband/sw/rdmavt/qp.c       |    8 ++++----
>  drivers/staging/rdma/hfi1/device.c      |   14 +++++++-------
>  drivers/staging/rdma/hfi1/qp.c          |    3 ---
>  drivers/staging/rdma/hfi1/sdma.c        |    2 ++
>  drivers/staging/rdma/hfi1/user_sdma.c   |   18 ++++++++++--------
>  7 files changed, 26 insertions(+), 38 deletions(-)
>=20

Thanks, series applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--8QIRfabDqLmHuaVu6Jp2T976DFtgRhF6t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXRHdUAAoJELgmozMOVy/d/88P/i4rtrNcpRuVH82LprMo2pkG
CS+O91QR1DLx7X6+uFed6o/wmQykttGccuRbE5m0BkQbdEQnh2QCyNF1vY7q5h7u
85gm9/MjkWBBKundVSI3EaU+7TUQLJXlr4UHXy0hf/ewSgShGGSvqqJJ2hE5Z37m
JPtonYrM6+zu1ehhqLr49m+y63pBjfpNjAIML5kZZ4NgCALMzc3qSYOYSlmoTTtH
7QuZV0qckJ/puSeteAB7hVYbZRemf42M3QkOMaNtdQVrkr8Z2bnG+Utk25kzgByy
IwgCsfCzchZqLQ9BRr6mezRFEHbgVmMADw0fRjGJRZg2mX9uBWPQ40y+LCIPKdCY
4y/hJDUN/zNP9VgQGZOHXWqjWkTkSD7nYToTM9cIxX/CNFhd0JcqJGNOJScV6EDt
sZ5rHXqk/KlPslYSo7EQRUIta0NQcPK73a8MPn/yu5uyny8kvB2BVGIpd55Cuz7q
10jwOkhRWm13jb/hP9T/eF+E38yEJpEPOeU3KvkxNzdh7jXZG9utTouiF8Gw3KLe
CJnpAYOkIzpDDHmtRN1dMEkZjaa3AgrLmCIvMKTnlHZrJ0eD4jkuXVAzYJE8ggne
xeX1GDLYCGpyaeaZpJNtQQvI5FrOLCFMgc1ol0ISen30zFyldHTSq8F7aLL09p2J
bCjo/djDvHd1lNruHN6E
=zkFx
-----END PGP SIGNATURE-----

--8QIRfabDqLmHuaVu6Jp2T976DFtgRhF6t--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
