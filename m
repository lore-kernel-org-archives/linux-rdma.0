From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/usnic: delete unneeded IS_ERR test
Date: Wed, 23 Dec 2015 11:11:06 -0500
Message-ID: <567AC79A.8000306@redhat.com>
References: <1450558139-466-1-git-send-email-Julia.Lawall@lip6.fr>
 <20151222152903.GA23118@DGOODELL-M-F02A.cisco.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="PQUBMw1PDrg3Iucc6e3kIDXUfvKltCFGr"
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20151222152903.GA23118@DGOODELL-M-F02A.cisco.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dave Goodell <dgoodell@cisco.com>, Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Christian Benvenuti <benve@cisco.com>, kernel-janitors@vger.kernel.org, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Nelson Escobar <neescoba@cisco.com>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PQUBMw1PDrg3Iucc6e3kIDXUfvKltCFGr
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/22/2015 10:29 AM, Dave Goodell wrote:
> [copying Nelson too]
>=20
> On Sat, Dec 19, 2015 at 09:48:59PM +0100, Julia Lawall wrote:
>> kzalloc doesn't return ERR_PTR, so there is no need to test for it.
>>
>> The semantic match that finds this problem is as follows:
>> (http://coccinelle.lip6.fr/)
>>
>> // <smpl>
>> @@
>> expression x,e;
>> @@
>>
>> * x =3D kzalloc(...)
>> ... when !=3D x =3D e
>> * IS_ERR_OR_NULL(x)
>> // </smpl>
>>
>> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Reviewed-by: Dave Goodell <dgoodell@cisco.com>
>=20
> -Dave
>=20

Thanks, applied.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--PQUBMw1PDrg3Iucc6e3kIDXUfvKltCFGr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWeseaAAoJELgmozMOVy/dVMoP/3mWqaXvMNRrJ9vRXtknXXvu
kNM1/gZUJL5vbdIF0Lf5QsUFYCU9jKnUjBfvM2LuHMvdO+uTFCmOvVxqhXfFNDGn
dLOqeF1kC1grguS2Ta2dElyKFt45as8R5s4kRCXxucHmevOP4WvFe/s24EVJKFV1
rYx+Py5hvPeqQNqcLCIBSEvBglzQpsz8I7JyrqHju4t5wLJmB+KxQgHwOlcDMZkZ
Ef9VBhQJFLOq6MYx1diuuUODxd9CCMb5UOpRI2otkRgaWnUQ+b+NBvlVu6pM6NnL
pskKx/siAtFTWSPE4GTtOyND5tFyqbvKmUkgfHJ6X+A2RmZTKH42/UEaHD/6t8QO
cO2XUCdOy1jAyI3M8PZZriDBiOvOJiDIazuA3UyfU4cJIsRGgAfbvB/yZtdEiufP
mkoLKzlnTJraPZvJSlHZSPGzWUaTdSM+4tF1Hj87F6ti3h4BuQu87dv1gXj/KsXw
SjBvRpm2Zqw35L0fMno6UKePa96fSLPI1ksSMw1+EMocOMA36uUk7zfemUbWTY3m
vXgOU9JQbvGM7kPRus9ewD+U6SNNPnt32hNAEkTp2/LGAiI8tdoOjWCjwFmN021b
MA+zFFUjNDH3U2LG/mjk1WiBPdXoOZvplHlBOe6wqnO0qOKfGxvENhY+zxp7dyBk
JFZWXY3nOY0/0Xir5cJQ
=4EPa
-----END PGP SIGNATURE-----

--PQUBMw1PDrg3Iucc6e3kIDXUfvKltCFGr--
