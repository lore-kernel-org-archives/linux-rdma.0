From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: Fetch monitor values on-demand for CableInfo
 query
Date: Tue, 9 Aug 2016 20:58:01 +0300
Message-ID: <20160809175801.GD23921@leon.nu>
References: <1470755838-14117-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="llIrKcgUOe3dCx0c"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1470755838-14117-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--llIrKcgUOe3dCx0c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 09, 2016 at 11:17:18AM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> The monitor values from bytes 22 through 81 of the QSFP memory space
> (SFF 8636) are dynamic and serving them out of the QSFP memory cache
> maintained by the driver provides stale data to the CableInfo SMA query.
> This patch refreshes the dynamic values from the QSFP memory on request
> and overwrites the stale data from the cache for the overlap between the
> requested range and the monitor range.
>=20
>=20

Ira,
On all your patches, you have double line between commit message and
tags.

> Reviewed-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--llIrKcgUOe3dCx0c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXqhmpAAoJEORje4g2clinyPQQAL2FxVI6hosFZc7vg9KxY+2i
IaLf09VoBrp11rednpHdc8o1z7z0DC7et4xwV2Nkkl/QmEd9FGbNJ5yzlgzYyQ+J
xRReiCqqMwiFgk/lhcqYE3cS78CroHDp2i8VHhKiDR4VWv8BumQ4H18+SC1ij5uC
UlP7Vo3L+VZwdtuLb2nUxX0aa7RgWJTZOapVHFDWHQS5TlDlLVr+GrDrVhj38My+
hBG9PuWehcTPmtgrZBbdLZ4mwXXSs8y6xDTn7hzjqGd/8722YOEOAs90KLE8wWsD
VtKbmh/+RkSA6jblZ1s/jJQIAugjzs/9AXnqxJxEVWZkhNHlJolYQeAWgtsFLctq
DUeQvVBoVDE9YeSO+cEChvcZfCHKkKdBxLW5/JV0gHw8CNqLvLBSXUKyYVbPJpIa
5sRMQA86V7YYHj+biRdEsshzwAaeku+eebvnqUWXDmMbbjp6FQw4ttIM9dOdVzRA
kjCbJJvkJ+qhIM88RCiaTorC0MItlr2drGwV3v34EvPgUBnEjOAJHHeWwrULbDrU
7yhdexbJJs0G7FS90bWwEpAjEhlwqTHGkP+5L7r9U7Kk9bKNQr9ejGDtjIdsoifE
UDcLGONmjML15TNniVY4B3em2SgTaUvEVICSSXVTWWICMCxfjG0jkNkgHEtANt/v
1Aax+88PyTAp+gg44hn0
=FdMk
-----END PGP SIGNATURE-----

--llIrKcgUOe3dCx0c--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
