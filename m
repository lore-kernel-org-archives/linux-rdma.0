From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: libibverbs-1.2.0-rc1 release
Date: Wed, 23 Sep 2015 13:02:57 -0400
Message-ID: <5602DB41.5070700@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="sgW6j4lTaGfbmiIeeVBqPD982uADbdftr"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sgW6j4lTaGfbmiIeeVBqPD982uADbdftr
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

I have done a pre-release of the upcoming libibverbs-1.2.0 release.  The
code has been pushed to the official git repo and also an -rc1 tarball
uploaded to the https://ww.openfabrics.org/downloads/verbs download
area.  From the tag message:

tag libibverbs-1.2.0-rc1
Tagger: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date:   Wed Sep 23 12:47:04 2015 -0400

Ininitial roundup of 1.2.0 release items

- Add support for RoCE
- Add support for On Demand Paging
- No longer assume that no driver for a verbs device should be considered=

  an error condition (usnic devices in particular are moving to libfabric=

  drivers only, so we will emit a useless warning/error in the presence
  of usnic enabled machines)
- Harden some of the argument processing in example programs
- Add support for s390x
- Fix the broken create/destroy flow API
- First release under new management (hence the decision to update to
  version 1.2.0 instead of 1.1.9)

In particular, as this release fixes the create/destroy flow API, there
is a need for an updated libmlx4 sources in order to compile against the
fixed API (binary compatibility was maintained, but source compatibility
was not, so you will need the new libmlx4 to compile against the new
libibverbs).  Yishai, please post an updated libmlx4 head of repo and
preferably also a source tarball for libmlx4 when it's ready.
Preferably it would include an embedded check for the proper flow API in
your configure scripts.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--sgW6j4lTaGfbmiIeeVBqPD982uADbdftr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWAttBAAoJELgmozMOVy/dJesP/AuJNPfAyIjwYT1cK2od5Hws
pltuHCYHbTra7oM6H8qOTJh+/MjaPNidZjTek9WeGRHs0nXMEFAVtI/QhhZyXk5P
0I8Yw1id2NTr2QrkbIsNskGEWsMOZ3O6yLaJgQa9G0ugiMh21UZ0qFTcE2sNZlK2
VOLmUnAUSC6n7U00zL10izBE6wFj+2WTCyTFb4kwu2f8gLYU+0yi9/tQ2oLQSOtO
MLtbgZna8aFv2QlX/vmlJYsicr2CxAuSrldITq1o3FHz7NfhDd7Axaphx+/HHZjy
mCXsEIqud2PvN/+kCrbwvIx+7xDItzb0T6IVY9mv6kqQHSNauu0AvvbA2gozmKoq
yE6cznB6UaG/m5A7zdWxS0oSl5OrsW2S2piJaXziwGlJkk5eLTCtCYPDFrxvGAZ7
LvbJfuhTcO526kzzGOgb1cdH/S7SJPg+FOo3iuMGz1UeowfihGNXSdYsLiQ3pdnB
XWcQ7oiU1ZSN8NP1zwgk63g/Qznntd8LZlYxXgoY0lhwkEhL82Azqhpkb27ubCMo
Y0wKpUV5di2IH4x6d16gAjc3PfBVdy63t2nDWe16WVCis1n1PK7J2sIPhNkf4QvD
EaonvKQeahutYoUfqR112oWgb0IEMmsazijbW+ANgjcL8dnzCLS6A8L1WxZvm5Yg
fgN7pbVyAnj07pQgPEXU
=kPoz
-----END PGP SIGNATURE-----

--sgW6j4lTaGfbmiIeeVBqPD982uADbdftr--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
