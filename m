From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/10] IB/hfi1,rdmavt: Another set of fixes for 4.7
Date: Thu, 26 May 2016 12:25:32 -0400
Message-ID: <b1b19ac3-e5a7-ecae-3b46-7a2d26005160@redhat.com>
References: <20160524194746.19706.42976.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="32hueb9tCbw2tpWXqvuPxbOoc9o1NEWrn"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160524194746.19706.42976.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--32hueb9tCbw2tpWXqvuPxbOoc9o1NEWrn
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 05/24/2016 03:50 PM, Dennis Dalessandro wrote:
> Doug, here are a few more fixes that we would like to get into 4.7 if p=
ossible.
> These apply on top of the series to get the driver out of staging. I ca=
n always
> respin if needed.
>=20
> Included here is one patch which has a stable tag for 4.6 since it fixe=
s a hard
> lockup. The others are minor bug fixes.
>=20
> Patches can also be viewed in my repo at:
> https://github.com/ddalessa/kernel/tree/for-4.7
>=20
> ---
>=20
> Dean Luick (2):
>       IB/hfi1: Add a retry for the first-time QSFP access
>       IB/hfi1: Correct 8051 link parameter settings
>=20
> Jianxin Xiong (2):
>       IB/hfi1,qib: Add ieth to the packet header definitions
>       IB/hfi1: Add tracing support for send with invalidate opcode
>=20
> Jubin John (2):
>       IB/hfi1: Fix pio map initialization
>       IB/hfi1: Fix credit return threshold adjustment
>=20
> Mike Marciniszyn (3):
>       IB/hfi1: Fix hard lockup due to not using save/restore spin lock
>       IB/rdmavt: Max atomic value should be a u8
>       IB/rdamvt: Fix rdmavt s_ack_queue sizing
>=20
> Sebastian Sanchez (1):
>       IB/hfi1: Update pkey table properly after link down or FM start
>=20
>=20
>  drivers/infiniband/hw/hfi1/chip.c     |   16 ++++++++++++++--
>  drivers/infiniband/hw/hfi1/chip.h     |    6 ++++++
>  drivers/infiniband/hw/hfi1/mad.c      |    6 ++++++
>  drivers/infiniband/hw/hfi1/pio.c      |   24 ++++++++++++++++++++----
>  drivers/infiniband/hw/hfi1/platform.c |    6 ++++--
>  drivers/infiniband/hw/hfi1/qp.c       |    5 +++--
>  drivers/infiniband/hw/hfi1/qsfp.c     |   16 ++++++++++++++++
>  drivers/infiniband/hw/hfi1/trace.c    |    7 +++++++
>  drivers/infiniband/hw/hfi1/trace.h    |    2 ++
>  drivers/infiniband/hw/hfi1/verbs.c    |    2 ++
>  drivers/infiniband/hw/hfi1/verbs.h    |    1 +
>  drivers/infiniband/hw/qib/qib_verbs.h |    1 +
>  drivers/infiniband/sw/rdmavt/qp.c     |   22 ++++++++++++++++++++--
>  include/rdma/rdma_vt.h                |   13 +++++++++++--
>  include/rdma/rdmavt_qp.h              |    5 +----
>  15 files changed, 114 insertions(+), 18 deletions(-)
>=20

I took everything but 7 and 10.  Please address the comments on those two=
=2E

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--32hueb9tCbw2tpWXqvuPxbOoc9o1NEWrn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXRyN8AAoJELgmozMOVy/dryEP/2MSo4pdcLihUz7aFkpn7fgF
ta+sJIUYdtCmd0FoGf2iXSc4v8yFDgLkZ11GbI/vG9+x+7Pz86VbPsR3UATkg2sy
HbxuI/MIZpjP7EogXZU/9sVIwZG9d4Acx3vUVF4CitcEmqxu6UMPTkWg9gxv5LF+
wausvXulj5Y/SZeloxdm3iudD1D+YR2sq5lFcYQMfTiVQjYpjj852SD1r4JtwHYp
gvt749WbySuoFQbICDuh2IhNcRbQrCL1Irk3mjanVtGYOtL0VfdOP7p8dAtgDkGz
YNNhoF4owYFr+ihpBAQobQjnrHo3D8h3ZXZBekFhIByPHhnYjL+eWgY/aMroLq7D
J53wfq9Zp/e91VfxzXgx3/U28E1PNproaKvApBKH1RyS6xgi2Qw/RNpfMCT7eEDR
dznIIbMIwDqtdZ9fGMKWqP8Dq+0IoYBwsDNMCNInelg2T09enaRIHGu2ZI4I+mnf
lcfb4dFEOWHJTYsZ3VxUp8CZhNte5iZ+4xLGniJmq3drB7OyYEevHBE3QPUOy3Od
4sicYhlnUfowDoVjpslb7G3c81TpoDD0xImBUbbi6APKUXltIIPIRcZa1OA3apXT
z9Kp1SX7HkbSX4UIUh0qE4EGs0ueB7QH+GyTcwun4ttgUMJPjv99t+rX82BEepXc
pJ4T6wVd39Dni8RMp99D
=8jXm
-----END PGP SIGNATURE-----

--32hueb9tCbw2tpWXqvuPxbOoc9o1NEWrn--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
