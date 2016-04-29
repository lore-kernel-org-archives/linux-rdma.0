From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 00/16] RDMA/Intel X722 iWARP driver update
Date: Thu, 28 Apr 2016 22:39:33 -0400
Message-ID: <5722C965.7080700@redhat.com>
References: <1460993589-9428-1-git-send-email-mustafa.ismail@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kmm8hShOd11Tfx2FRIn5gwSaFblegqrme"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460993589-9428-1-git-send-email-mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kmm8hShOd11Tfx2FRIn5gwSaFblegqrme
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/18/2016 11:32 AM, Mustafa Ismail wrote:
> This (V3) series corrects the subject line of the email.
>=20
> This patch series covers changes to i40iw since the initial driver subm=
ission
> including base memory management extensions, virtual channel messages q=
ueue,
> corrections for endian warnings and bug fixes.
>=20
> This patch series is based on Doug Ledford's
> https://github.com/dledford/linux.git branch: k.o/for-4.6-rc
>=20

I've taken the series, but in my for-next area.  The existing i40iw
driver is broken, and the patches to fix it are more than I wanted to
include in an -rc pull request.  Because it's brand new, it's not a
regression, so for-next is good enough IMO.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--kmm8hShOd11Tfx2FRIn5gwSaFblegqrme
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXIsllAAoJELgmozMOVy/d9RoQAMPDXR1opAGaGukS/mtz/qy+
OGGgvZ5lYdUX29DdUGvr+2DCOlcVBul1HmglWi6C2EAfIPwAPAQGyriybe0T/lOH
DR6sExPRxxbwdegjsDiW2YgRu0XdYrvXEcitGgqvnB/5KgDPFGOXnYmbKTyhqAlA
2lJQHIqzg3hk5gqJZGzna6EoOiy9UY/m3L5wM5YOL+ER49NacuURVzWi/FQx36xV
6/r0bSD4iu967Xv0tpOFeqIAkDQ1C5HtP4yLEKUMBWOJ6J/2OjssOZYsaiI2UzZu
iV1DGNGfmuM8svetVQisdmBAxCBvgN8H4RfSd3vHS0tRVeoikU9MCju7Ws7XnSDF
Hj2yUt7z3x/VnWVbEPvWhyhUqkiDn083ZddvwJ3yhpMu4EbFj/ZzGnNDzJ3nreys
cJqfNmYfDTi3mdOEWo1cdZyLYhMzBxaeTcVY6//szSkB1d9iylM+uerz5G0GLH4z
doLn5MR5sF0WngRlJYRI8iS4m3q7ORsJm916Bx7GRTdF2bwV/pqP9kI+vSLLSL0k
vvAoFDqUPOlLTVg7f1SuOvOckVXXDbkTO1W9jyaY9zUjP8o1lynnLlWaHyysIcl/
z/qDNTBJxD+BulnunUQXGW0dWlfj3AFFqf4WKFIMAElVX7njqUXuETrZmyvRDo86
AVrSNDxyQwHsAthbsID/
=hLQc
-----END PGP SIGNATURE-----

--kmm8hShOd11Tfx2FRIn5gwSaFblegqrme--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
