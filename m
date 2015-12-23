From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: MR cleanups / dead code removal V2
Date: Wed, 23 Dec 2015 13:27:50 -0500
Message-ID: <567AE7A6.1050701@redhat.com>
References: <1450894374-8241-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TVGSxgx7raNu6exdiNPgTJr3D9l6I4hw0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450894374-8241-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TVGSxgx7raNu6exdiNPgTJr3D9l6I4hw0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/23/2015 01:12 PM, Christoph Hellwig wrote:
> Hi Doug,
>=20
> this series (on top of your k.o/for-4.5 branch) has various MR-related
> cleanups:  starting to document the device capabilities, removing lots
> of dead MR/MW code and removing a useless field in struct ib_mr.  This
> should be fairly uncontroversial I hope, so I'd like to get it in befor=
e
> any real MR changes.
>=20
> Changes since V1:
>  - rebase
>  - updated description for the last patch
>  - additional ACKs
>=20

Thanks for rebasing it.  Applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--TVGSxgx7raNu6exdiNPgTJr3D9l6I4hw0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWeuemAAoJELgmozMOVy/dtmwP/017jmBCp4w6MVbsVwdANWCl
9eDtktOlBnrJ8YyRM9JMrNzYJyVYuX1Yd1PFU7ZX3wywbBHI2wl/AU/FZZnM0hFs
czQelxdMnWRETUyf/wF9PxU/KRXm9r5diYhOUmJtV8ipSIYx8S/WcIEJpy5fVzE/
2am6UqDB2jUe+cN++uVL2/JIz6yOAkNp2SgaX5mTcpVHqlvBjfaUtngwYsRcUAlY
qfu/o92kXpaMfcWco2CRp/IjVRJJSio+/zfaEzPbOZLN2k+U/JLdTmBEczdoWSvl
Tz/LauUUyTP6yRIFmt53jplARjlYbm3ugAG2n1B0jot8wCh8WA4FtpBFDH3B1UJo
8l6kEjsoGlc29iKquGB6NM14wwSCZBDCfTRxESIzZy/kpd0vYDqNjkYv8jVg9UyO
5Jd9TBId5sm24f61r40AOLftKT4H1j/l6cHq9474g1gu9ri6di/lmjwYZBGQRMKu
JXmdalutlJdrrL1uYiy+kH0DceIuQBKeu3vau54tU5mBNj1MnIqPAsGdZ9xvZitn
UZ5whLIHs9/9879NXZ+hD1hUtw0YnTJEFBHj2oSDEXsJ8U9yDpNqnF1yhyLs5Tz6
Ad7CXXoFInxfThKeaft+/+gsksE+4ENuxbwSkfHLOPAxeEvx+gAPfZKiaVkWjV9s
BIk1Wu2ky511CxMAhp6i
=Sgld
-----END PGP SIGNATURE-----

--TVGSxgx7raNu6exdiNPgTJr3D9l6I4hw0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
