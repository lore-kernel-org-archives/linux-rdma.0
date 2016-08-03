From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/13] Code clean ups for 4.8
Date: Tue, 02 Aug 2016 22:52:52 -0400
Message-ID: <1470192772.18081.54.camel@redhat.com>
References: <1469723257-27317-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-rsavjqoWFMTECWmhHneB"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469723257-27317-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-rsavjqoWFMTECWmhHneB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2016-07-28 at 12:27 -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> The following patches perform some code clean up in preparation for
> up coming
> fixes.
>=20
> Functionality is not changed.
>=20
> Dean Luick (6):
> =C2=A0 IB/hfi1: Remove unused uctxt->subpid and uctxt->pid
> =C2=A0 IB/hfi1: Remove unused function hfi1_mmu_rb_search
> =C2=A0 IB/hfi1: Always expect ops functions
> =C2=A0 IB/hfi1: Make iovec loop index easy to understand
> =C2=A0 IB/hfi1: Remove unneeded empty check in hfi1_mmu_rb_unregister()
> =C2=A0 IB/hfi1: Rename TID mmu_rb_* functions
>=20
> Ira Weiny (7):
> =C2=A0 IB/hfi1: Fix minor format error
> =C2=A0 IB/hfi1: Add parameter names to function declarations
> =C2=A0 IB/hfi1: Add parameter names to callback declarations
> =C2=A0 IB/hfi1: Consolidate __mmu_rb_remove and hfi1_mmu_rb_remove
> =C2=A0 IB/hfi1: Remove unused sub-context parameter
> =C2=A0 IB/hfi1: Use "false" not 0
> =C2=A0 IB/hfi1: Restructure hfi1_file_open
>=20
> =C2=A0drivers/infiniband/hw/hfi1/file_ops.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
| 18 ++++----
> =C2=A0drivers/infiniband/hw/hfi1/hfi.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0| 11 +++--
> =C2=A0drivers/infiniband/hw/hfi1/mmu_rb.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0| 74 ++++++++-------------
> ----------
> =C2=A0drivers/infiniband/hw/hfi1/mmu_rb.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0| 13 +++---
> =C2=A0drivers/infiniband/hw/hfi1/user_exp_rcv.c | 33 +++++++-------
> =C2=A0drivers/infiniband/hw/hfi1/user_sdma.c=C2=A0=C2=A0=C2=A0=C2=A0| 11 =
++---
> =C2=A06 files changed, 62 insertions(+), 98 deletions(-)
>=20

Thanks Ira, series applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-rsavjqoWFMTECWmhHneB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXoVyEAAoJELgmozMOVy/dnhgQALscjiDMx9BNcs+C/a8is0EO
eiLydzXXgVJ24SFanLOwlN4+J3t572T0prjOq1+lNO8PrtVezOROLriVK9KIHIS/
c16/EbXW8CiiyVNkajLBpcyKDEcs1e1DWnZwKEONyPYC5Un22FF36CNH0w0DuzwH
Qh/4r6Nmv/ArgPyKd7UcXzW+a6zkY/54ExC+JMWY64cu81CYcqLJW1eTcpkUvs7A
gUEXgwgS1nhm+EM99MK2RSuDMZxJiTPBzAWrs3jf0ZFgaZakEVWUC/WJ3cjQlONp
r/AE2jIpt6qajgMZu9bBVBeNFUT+e2cDlG5xnceC7bDjORg+ovAjWO0OL+YOGFHx
6qpJblXmBoQmqhNtWWE60pkAifoBzm/HHrL0xX+YyO/ugp+DVnX4pwi235ZZrWV3
ns7cFm3Qv3pBp6sK/dseSQlHGva1DSXmasa5VWzBkzl3o2o0LcF6qJ4M6JsxPQq8
cNkFjrELQ4fIRzrmMScxdQtSoeFuCWeipjjiRZ5MSHPPt3y2fKwFgDIrK6N/lVmt
JI/vq+7lAo1U1jZq3CB49DseozSyYZoHZiNo0wrPh7OmhlpfUjZ9/xAYLZg7+NN0
2b2WthIEkZG+XI/hlHQ024zthILqwa+la050cjAR3Y80n3RUpBCswxN1460da5lF
XJPmfCMyC5QJ2aelWD6N
=g2XV
-----END PGP SIGNATURE-----

--=-rsavjqoWFMTECWmhHneB--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
