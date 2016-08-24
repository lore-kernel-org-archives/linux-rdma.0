From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] i40iw: Avoid writing to freed memory
Date: Wed, 24 Aug 2016 11:34:38 -0400
Message-ID: <d95be065-ad24-9ab1-6762-00c3a442eda8@redhat.com>
References: <1471991096-85476-1-git-send-email-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cxSNu6BgpG2aKgcr7XnesULQaLSN7vCcd"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471991096-85476-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cxSNu6BgpG2aKgcr7XnesULQaLSN7vCcd
Content-Type: multipart/mixed; boundary="VdgcxT5KhKw1RI7RqoIsbOV4MbCrdculm"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
 Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Message-ID: <d95be065-ad24-9ab1-6762-00c3a442eda8-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] i40iw: Avoid writing to freed memory
References: <1471991096-85476-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
In-Reply-To: <1471991096-85476-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--VdgcxT5KhKw1RI7RqoIsbOV4MbCrdculm
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/23/2016 6:24 PM, Shiraz Saleem wrote:
> From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> iwpbl->iwmr points to the structure that contains iwpbl,=20
> which is iwmr. Setting this to NULL would result in=20
> writing to freed memory. So just free iwmr, and return.=20
>=20
> Fixes: d37498417947 ("i40iw: add files for iwarp interface")
>=20
> Reported-by: Stefan Assmann <sassmann-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--VdgcxT5KhKw1RI7RqoIsbOV4MbCrdculm--

--cxSNu6BgpG2aKgcr7XnesULQaLSN7vCcd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXvb6OAAoJELgmozMOVy/dR74P/RohA+D4dd8bo+V3x8ny0eaF
nusq9Vj0x9RO/0mTyf9bDGyXI2x+Rlp/g8uosqWp8XDFyB2NWuxUmClq5ntjV9cv
+pfIbRTzRpRiuiuT5veaYyh02j1Uj/TvbcaSw2W9PgRb9fn30qcNDHmAeKIZcK6T
8lCHGBPiq1zmFPYSuai6UxKrGHnBhieu5ecdYTpSat7UZnFWDF82h94tMjBFQtdX
88it22piDrdwQiCTnWhzgVul/jZ79qWJ5HyPm8In5fGKSM3EUhMOVN6k8MnTtJTp
QjAvrwU8gKYWJfs64QY+x4q+ths0c6xHzK+Qhzt0PEymATF1BS3geVIjw+FhjH5Y
vTpGIavZproxjFIVIHV6ocDiMC+g65yrQ0Lht70HuyRASSN/B6Gl4sY1By1H3hNB
HQ6LLqqNWr3bZe3z8O4mmP5p3N3tJ/fE1moBya6rIx1b0PdXmqwkMeDR4bgsYcFn
pEDIoo2+xGs8WFFatu21QtI5tu2jAOPS2PhwJ4UzLiNhxfkhN2gsb7+SSKV8H/kv
v9WULO5IVJiODVIQ17OuHkMzUcspe0aHCl9MxITVtEnWn7BOYl4UNDE8DjytimDk
fFzdKUB+9FZ4rAimz5kKEK7VNCCl45BRgMpJtF40PfpeoEPme3n75VHk0iv8LyvE
nuIPIu/5aMT02J6ggehq
=x9w5
-----END PGP SIGNATURE-----

--cxSNu6BgpG2aKgcr7XnesULQaLSN7vCcd--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
