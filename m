From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/amso1100: Do not build amso1100 without infiniband
 subsystem
Date: Fri, 14 Aug 2015 16:57:07 -0400
Message-ID: <55CE5623.7000609@redhat.com>
References: <20150804180632.30555.59059.stgit@build2.ogc.int>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hWRsFAv9jt3aFp9omGkcS8XhphdiaJB0U"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150804180632.30555.59059.stgit-PBeJgSbIpn97NCTnQtmixQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hWRsFAv9jt3aFp9omGkcS8XhphdiaJB0U
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 08/04/2015 02:06 PM, Steve Wise wrote:
> Moving the amso1100 driver to staging now requires a guard on the
> INFINIBAND subsytem in order to prevent the driver from being built
> without infiniband enabled. This will lead to a broken build.
>=20
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Picked up, thanks.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--hWRsFAv9jt3aFp9omGkcS8XhphdiaJB0U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVzlYjAAoJELgmozMOVy/d9DQP/2vCXMD/tAKAP9x9z0o9sxA3
MuKDdSGj1vrlDJyA2BIf7Ed0/SB/2FkXyMpMN122yKTlUstuFDjJd2lQH5snojJr
lAF3wClHkvRFLluaiJW1+79r5f0QToH8qJRmQs24hmlvetoMqik8/D2XX4L51lBY
tbh0UZZ+2zhHx9/Hpot0D86tQpGItAnHPxJ1zM2J0Xf1wHpXok3A09XZ8wMQpdJo
0yiX/g0gpUKGhEF4rw3uoksjZT4d14eIARyUBJs7zgEMV9KZfper1PbsTkTkWxbX
blQZj7w1gT+xzneiNfFPtEnLRjG82G0nGM5R99yHLOjkdi7RM5mER8FcXbljoCUn
UdacMHU/CN8jynFG0GB4KyMOMSXgpl92JCFIOss8bSWonUjThcN8whjZy5x08+lH
yi/HltIs3syuRGdaCdTDmMuCQzWzit/nMp5DlMlFa6j2rgGPqfpvMIUkFrfLoiVs
R6r8kvXYYnXmuI4JsNL8heoAKfvWcIPnNfJiyP0N+lNz2fWzBLzOTxiBE4OBm3YK
vVXDKtd+A+LnhrzF/he9W8Z+gxdq8wvI4aNBGfGUlOtj8CK+XCpXkXEb5kDpiJmU
TCqGhEHIYNBSK7zhrzKK956TNiAzE5d59SPEBR0wMSPgl5m7Mw1OtL/kQ3uu36Cp
sFHI3txIbdFJ7w4jkgs6
=M6oK
-----END PGP SIGNATURE-----

--hWRsFAv9jt3aFp9omGkcS8XhphdiaJB0U--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
