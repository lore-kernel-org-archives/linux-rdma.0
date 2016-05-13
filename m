From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] i40iw: constify i40iw_vf_cqp_ops structure
Date: Fri, 13 May 2016 12:49:10 -0400
Message-ID: <20702354-cb48-8711-240f-3ac4006c6cbb@redhat.com>
References: <1462105341-6299-1-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cAc0sqKHIVB8EgLlpPBEiUJca6KSL2akh"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462105341-6299-1-git-send-email-Julia.Lawall-L2FTfq7BK8M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cAc0sqKHIVB8EgLlpPBEiUJca6KSL2akh
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/01/2016 08:22 AM, Julia Lawall wrote:
> The i40iw_vf_cqp_ops structure is never modified, so declare it as cons=
t.
>=20
> Done with the help of Coccinelle.
>=20
> Signed-off-by: Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org>

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--cAc0sqKHIVB8EgLlpPBEiUJca6KSL2akh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXNgWGAAoJELgmozMOVy/d2E4P/RpEphJ+tOoLI0vZ9fMtKjkh
KgFHdaChF5+nG7sUx1+K12efI2Eo/bVTWgA5vpb0CTVhp0aoZdWKDEoNxWQLBZvS
Kjz9l/slNwusuU5SyxVEHS3ar8BAbC5uBK4MJRUjUcqu/Rj23fbF+MEdLqObIAi8
fZ7XVL/VqWS8RdP1h1+A6NDvN0vka/R/pMYiy06TsInJuQv43Cl7zACJ9zTqP6sy
ZTdEWbKYvm1t+3JqozEZ7NToMXuIaRcavGBhcCuTEc2uXwfcslP44Ogpsf1rnpBm
Nw2lr+HOynthYHLYGPuZ2NzZdXbV3znu4ieoTc+07OxJu8Y++76wPYyH4zY8BBrg
oz3uGF/7sWBhz1+NeLH+u2rl6QYb1Ffx7aR9m+k8MubCaDtRO7e6tH7Q71U4l1Mx
G98/kyYbp8oTrSHTzrZm59FDiCwQKa7IXh7rktlhb0QPfhKh+jeJ92FZ+QfBANox
Ga8IjpvI4PkY1ZYiL1RoxcyBDAmRGIwfVDljiP+dPNFBJsDSbtAzvDQ7ilo7AcBM
WxB7wT3g3sLUHmZlNugjxykpSzwzH1uUqJ67PEn3LOii2SSVD5hm0MmUwPYqs3zs
gbtsfyeGfYwiFHQH3aNQEqBPzQZpLztpqkZfoNDAqen7ksTV6tNTcniwi9ArVoQH
H/9ZMuU7Tdyix7QW6jZ4
=+Bl3
-----END PGP SIGNATURE-----

--cAc0sqKHIVB8EgLlpPBEiUJca6KSL2akh--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
