From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v2] IB/core: Use memdup_user() rather than duplicating its
 implementation
Date: Tue, 23 Aug 2016 12:43:52 -0400
Message-ID: <ce171524-747e-5a14-105f-62c7955a7448@redhat.com>
References: <566ABCD9.1060404@users.sourceforge.net>
 <f7bb3caf-81cd-fba9-afc8-5fac72b8a4b3@users.sourceforge.net>
 <1471802623.3746.1.camel@perches.com>
 <683187e0-2e6a-88c0-f87a-9c5f0489370a@users.sourceforge.net>
 <1471809188.3746.18.camel@perches.com>
 <5e87f691-edb9-0a12-ff7a-59854c2ca2f8@users.sourceforge.net>
 <1471859215.2764.24.camel@opteya.com>
 <3a5989cb-5a01-f502-c7fc-c489079ee73e@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GEOBdXTaBM6BexNbE9b3CMC5GaAs0hBNi"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3a5989cb-5a01-f502-c7fc-c489079ee73e@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>, linux-rdma@vger.kernel.org, Hal Rosenstock <hal.rosenstock@gmail.com>, Joe Perches <joe@perches.com>, Sean Hefty <sean.hefty@intel.com>, Yann Droneaud <ydroneaud@opteya.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GEOBdXTaBM6BexNbE9b3CMC5GaAs0hBNi
Content-Type: multipart/mixed; boundary="s96fhQJPJso0wPfmjRubWuEEtwgQfGuNc"
From: Doug Ledford <dledford@redhat.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>,
 linux-rdma@vger.kernel.org, Hal Rosenstock <hal.rosenstock@gmail.com>,
 Joe Perches <joe@perches.com>, Sean Hefty <sean.hefty@intel.com>,
 Yann Droneaud <ydroneaud@opteya.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
 Julia Lawall <julia.lawall@lip6.fr>
Message-ID: <ce171524-747e-5a14-105f-62c7955a7448@redhat.com>
Subject: Re: [PATCH v2] IB/core: Use memdup_user() rather than duplicating its
 implementation
References: <566ABCD9.1060404@users.sourceforge.net>
 <f7bb3caf-81cd-fba9-afc8-5fac72b8a4b3@users.sourceforge.net>
 <1471802623.3746.1.camel@perches.com>
 <683187e0-2e6a-88c0-f87a-9c5f0489370a@users.sourceforge.net>
 <1471809188.3746.18.camel@perches.com>
 <5e87f691-edb9-0a12-ff7a-59854c2ca2f8@users.sourceforge.net>
 <1471859215.2764.24.camel@opteya.com>
 <3a5989cb-5a01-f502-c7fc-c489079ee73e@users.sourceforge.net>
In-Reply-To: <3a5989cb-5a01-f502-c7fc-c489079ee73e@users.sourceforge.net>

--s96fhQJPJso0wPfmjRubWuEEtwgQfGuNc
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 8/22/2016 12:30 PM, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 22 Aug 2016 18:23:24 +0200
>=20
> * Reuse existing functionality from memdup_user() instead of keeping
>   duplicate source code.
>=20
>   This issue was detected by using the Coccinelle software.
>=20
> * The local variable "ret" will be set to an appropriate value a bit la=
ter.
>   Thus omit the explicit initialisation at the beginning.
>=20
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Applied, thanks.


--=20
Doug Ledford <dledford@redhat.com>
    GPG Key ID: 0E572FDD


--s96fhQJPJso0wPfmjRubWuEEtwgQfGuNc--

--GEOBdXTaBM6BexNbE9b3CMC5GaAs0hBNi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXvH1IAAoJELgmozMOVy/dy3AP/2l/Jzt8M+QrvlMCigQ7jMPG
NMnZYzgjsIksk9PHDd38opAj2oKa4wWLkzDk311weWqegLUUr79HAJFr3hhtB532
Xa7iXq7/94AI6N8rX06tP7r3vLc0C9T6CpX498j6NuIgv+nY8si/j31NXkaEK6Ia
UwlrR5699FIPHtNyG/ujddkZEuiWyiAh3kRH4ABkCC9ig1n+uYYJKoKpXfXJH15w
uH8CL10SXbAsxSGY5N2usLBPhqbmStVJiJ6UN85ofDTdWQ1/2jMW5ILzsInm5PPU
YCEmNZ2Q/Lid+V+hNHg0YDFwd0jBN81mzXuUkONJ3dnHMCxea9RCh88qwWxn8+Mi
bIM8vrxgj2Ttlu6XkfYtmD8KsAvTA+5go8yy4cuJve2ucqr6YkNVRgPW2u1BwQRt
72fwOSlsdtmKjRFeKEbymiOO72O4icsnh6GIL3rWiCuEbEGQiLj0swPZcDfBNB6Z
fmT4LdlrkjV38TFAt7Cg3D1NKtt8XaIer1CmZe5uIEuoFNoNa0lPz+29tJoQS8Au
hRv22mhgQh3An4jN3GSK3MZRcFOFeQFgoT28yyhGDSkXhRJjNFiMdnSjor7b5I0N
QbF2KL/fuBiFhUCNnbfKK9jKLCsYGqdodU+MMqw4xu+qNlNYHFLprE/epOi2QiRB
CCHwbZ0xekC1anoPaDBo
=7eKk
-----END PGP SIGNATURE-----

--GEOBdXTaBM6BexNbE9b3CMC5GaAs0hBNi--
