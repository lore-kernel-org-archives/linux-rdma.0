From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/4] libocrdma update series
Date: Fri, 26 Feb 2016 10:04:50 -0500
Message-ID: <56D06992.5030104@redhat.com>
References: <1456386647-22315-1-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="B6MpWklNrACekXw11o2Eu86pXEWJEsijH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456386647-22315-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--B6MpWklNrACekXw11o2Eu86pXEWJEsijH
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 02/25/2016 02:50 AM, Devesh Sharma wrote:
> This series includes couple of bug fixes and support for RoCE-v2
> for user space applicaitons.
>=20
> Patch 0001 adds support for RoCE-v2 to userland applications
>=20
> Patch 0002 and 0003 are bug fixes to avoid build warnings
>=20
> Patch 0004 updates the version string
>=20
> Devesh Sharma (4):
>   RDMA/libocrdma: Add user space support for RoCE-v2
>   RDMA/libocrdma: Fix compile time warnings
>   RDMA/libocrdma: Remove async-event hook from context ops
>   RDMA/libocrdma: Update libocrdma version string
>=20
>  configure.in       |  4 +--
>  src/ocrdma_abi.h   |  2 +-
>  src/ocrdma_main.c  |  1 -
>  src/ocrdma_main.h  |  5 +++-
>  src/ocrdma_verbs.c | 76 +++++++++++-----------------------------------=
--------
>  5 files changed, 22 insertions(+), 66 deletions(-)
>=20

Series looks reasonable to me.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--B6MpWklNrACekXw11o2Eu86pXEWJEsijH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW0GmSAAoJELgmozMOVy/dq28P/1BX6VEZC3q3Fm3OJX1usL67
PXcNg1+JVJNUuWCeWhDQ7eN8UCdi/8GhZVoeNHVQsy5Y8Kx7fdBMJvdfJ2GuSNah
MCKIx4BwDemLQBJ6oWU0YSIEl7ub8Sej1g3PO46Hv3Ieugv/HpoI1RM19GdA88VR
VkhZSUj8hJ1t4+VLh2i6MI6HaXFaoXXWI5ozooTwdiRGCeMdWGo8iTEGKS5QCqjK
oxQER6pYYDC/C7sJYNJklu/ZWoFC1gfN5X2ZdK1gY+9DoKqeT/KhEeQRbvoGelhC
IaiP4/UcVB5/1QYC9SAdtyysgn841xIjP87FCPrW/oaqpHKb9jSQvW92PwFoYitn
bVyxJhCUGWVoEKmH9xdKvYm12efHBQQwAZrzPN+FgAJEfkOaHS2BB/16PHNWnsla
BgxCQdjcyhQf58OPOSn0uajaWKL5qgv2MzsWoZOMZLOv4E+iq7Bu3mlQd3m29Ztc
OsXlzTKbh2Yu88i91IQ8PvN0l0m0ywnadMy6wSg6w/f8AUt7QJ3er29lEKJ/axRi
xCVhHlRRbAjoZj93ub/G9RW7PDtlvzkuXQBzqmtp/bnRh3NDXDtIGIDxbDq9oWT1
8oeWIjnmn+oRG95LrDls12Ci0P1Qwc/jAQYClCooETheFZzs3h2Mw7XNl/OqT9vh
tBfJrei+POMY0RcWfWEe
=0bBc
-----END PGP SIGNATURE-----

--B6MpWklNrACekXw11o2Eu86pXEWJEsijH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
