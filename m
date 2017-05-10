From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: qedr: backport fixes for 4.11
Date: Wed, 10 May 2017 08:04:55 -0400
Message-ID: <78366ab9-df60-1d5e-5e1d-f9f824eecff9@redhat.com>
References: <BN3PR07MB257890E2A0984E1B902D974DF8EC0@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gQxjjElP8CeXC3jcj4MltV1QjPUq8fHLl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BN3PR07MB257890E2A0984E1B902D974DF8EC0-EldUQEzkDQfpW3VS/XPqkOFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gQxjjElP8CeXC3jcj4MltV1QjPUq8fHLl
Content-Type: multipart/mixed; boundary="53buhLJGwgvFco6bauHmdN7ODVjWFmp3K";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>,
 "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Message-ID: <78366ab9-df60-1d5e-5e1d-f9f824eecff9-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: qedr: backport fixes for 4.11
References: <BN3PR07MB257890E2A0984E1B902D974DF8EC0-EldUQEzkDQfpW3VS/XPqkOFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
In-Reply-To: <BN3PR07MB257890E2A0984E1B902D974DF8EC0-EldUQEzkDQfpW3VS/XPqkOFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>

--53buhLJGwgvFco6bauHmdN7ODVjWFmp3K
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 5/10/2017 7:58 AM, Amrani, Ram wrote:
> Hi Doug,
> We consider the following patches important and would like to see them =
in 4.11:
> 08c4cf51 RDMA/qedr: reset access control when registering a MR
> 4dd7263 RDMA/qedr: destroy CQ only after HW releases it
>=20
> Thanks,
> Ram
>=20

If you didn't originally include a stable tag, then you need to resend
those two patches to stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org with a proper Cc: line for
stable and with the upstream commit ID in the message.  That will get
them added to backward kernel versions.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--53buhLJGwgvFco6bauHmdN7ODVjWFmp3K--

--gQxjjElP8CeXC3jcj4MltV1QjPUq8fHLl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZEwHtAAoJELgmozMOVy/dmCgP/A8UBUSw8V1QyiuCyIaFda8N
oVdjEIAiULzbJlV4AS8jUrcnZYlbNnF1jYry8LH2wsi0qOYRiW4vIKYDYnjghcev
odriOb2gNRDsDeD6YanhrivHyb5QzHmAJZAnHv2nx7LYzER1Ej8f8LsW4M+nBmha
FcNocS7k2TUvhc5j0M8TpeZP0rhYSZQAWHcV6x0Lt4V9uUVNMbYRR30HVb7ACMNe
erLwa8Df+pHqKpAZTpqSoLCqcjoX43/M+balQ3/Yp4m92IjBkCizT6Cb4G+gyTtX
RXwFkzjOFIi9VwCJOS5S7iKzzNfDgfILqxk/zV5mPnRy7nPgzcl0GmjBktfqQJRn
7FjQPyDuoSVdY7an/Hhq4JfpjcE2PAzrsAwesNng2ba2Xi5p4rrSXRRxu+OhvEtK
2m0Eow7Jn7tAGHgj8pb5vrmTiQ14ZiyS4L1teB01Hv9cTHPVZOzHC4Q/B7FruXsL
d8BdMPyv8Ju38086cdF+3OiXONIqDShtEOhoETiK6I0m2a19VUKDD24/JbK30DNZ
wqJPAr01jEi+60H40dc8u6uLoMVA3Z6w6AHO9tRlMHLbFgWhceERL9+TXHXGJ2X+
569J1i9+2m4CJ4k1b/nELqJlsFA2XH8IodvK5ogOxWFSkl9+FYJDvNoxlq3InWzT
9SbbIT9WTR0gIxAa99FD
=Xyq9
-----END PGP SIGNATURE-----

--gQxjjElP8CeXC3jcj4MltV1QjPUq8fHLl--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
