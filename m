From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Patchworks problems
Date: Tue, 19 Sep 2017 10:31:22 -0400
Message-ID: <c2b96c6b-cc54-7e07-d28d-84bc608805dc@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xaDhNduSotGGRl9Kgriv8oebwm724HEkX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xaDhNduSotGGRl9Kgriv8oebwm724HEkX
Content-Type: multipart/mixed; boundary="Qmbt6UJpB7tTveNsbeHsMTjVP6Dtg29Ku";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <c2b96c6b-cc54-7e07-d28d-84bc608805dc-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Patchworks problems

--Qmbt6UJpB7tTveNsbeHsMTjVP6Dtg29Ku
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Upon coming back to work, one of the emails in my Inbox was about an
outage period on patchworks.  From 20:30 UTC Sept 14 and 20:30 UTC Sept
15, the patchworks hosted at kernel.org (which includes the linux-rdma
patchworks) silently dropped all patches.  If you had sent a patch in
this window, and it hasn't already been superseded by a later sending,
then you will need to resend the patch(es) in order for me to see them
in patchworks.  This mainly applies to kernel patches which are still
done exclusively in patchworks by myself.  It does not necessarily apply
to patches to rdma-core because I seem to see a lot of pull requests for
rdma-core and so patchworks is not the exclusive (and really not even
the primary) means of patch management for rdma-core patches.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--Qmbt6UJpB7tTveNsbeHsMTjVP6Dtg29Ku--

--xaDhNduSotGGRl9Kgriv8oebwm724HEkX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZwSo6AAoJELgmozMOVy/dBbUP/31mLuYtSa/Ru1o7ncBeaRFe
dMAsLGSw8XWHWsAwlKX94nIRhsD+h8fdGqni1y85EES3Dd5gx+mtMXwkDiBdoovi
JAQGU1dF/cuL2Z4JgCH9dVMHwiATqcPYVfe0hHk6d1wvXf1U3E05Hk7unv7XjDmH
8bMxhe9ag9cJVK0OWITnm8Z28kmu7y39A6JJ6TlHTu5w6FUkpvWFxk3vtgLT8Wt4
XiduO55ps/yVpjqLRJ4St6nOaeMdv1u2MAEMMKFhfgyw6JLipMdDFOEUb/XI99R8
1bkfUmaohg7N0pSREbffjM5QYKP50szxhL5DOUOLf0OHSh0eOCFpONk7z3ykFmHI
9OnvEs9c5tWVYqYQBE5FdE1Anirv3QQ3w0iNnjPdzVfW66zRrNk9jDB9pwg+hPws
J2+vj/Z+F+Mtph4CIkKqAMzmb2REufhyjq9iKtP+BJ3/OMpZJqXtwnDB332wGlYJ
3BcG3j5NVfoo5+hGA1rZhn+z9LLKJVJyD7zBUax2Wz8j5KP/wJsemlPtMnLheg9Z
EDdPeRn0Mb83CUVLYF8DpFHYCVjzToeVt2IdirkYdUp2TBXY54zT/4ghcaHr58fA
HmAGzVSOC269rfHaJzbilkLKdzP0yj58dlekOWlSZ4pS27tmEJyN1ylcRzDGNpIm
ot2As7tj5iWmfsNJPYK+
=miDJ
-----END PGP SIGNATURE-----

--xaDhNduSotGGRl9Kgriv8oebwm724HEkX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
