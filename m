From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/3] libibumad: Add support for SA
 MCMemberRecord
Date: Wed, 22 Nov 2017 11:43:24 +0200
Message-ID: <20171122094324.GD18825@mtr-leonro.local>
References: <f4b44991-78b7-fc36-520c-f6959e75fed4@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="khrwSSTxyUQyy1lH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f4b44991-78b7-fc36-520c-f6959e75fed4-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--khrwSSTxyUQyy1lH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 20, 2017 at 08:40:57PM -0500, Hal Rosenstock wrote:
> Add umad_sa_mcm.h to support SA MCMemberRecord and add umad_sa_mcm_rereg_test.c (rewrite of infiniband-diags umad_rereg_test) using this new header.
>
> Update umad_sa.h with some common enums, defines, and helpers shared with SA PathRecord and MultiPathRecord.
>
>

Thanks, applied.

--khrwSSTxyUQyy1lH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloVRrwACgkQ5GN7iDZy
WKfKchAAvPOwjm0PDTrU7zBLqK3qBJMmYywINutHmo2OqP4FM+dSLyLj+5Bl/teN
U3ryfxnfWA1lfFhREA2FLLEg6TcgPwPSwP/bQPfPn22oSHXMev72SOeacZTUWiEY
l8A32H5g20U6ZfGkaQZoJUeKC/ugswT2GR6t00/kvXIYvCOXYquimrTs7CBVqKZt
i1xfVpFd/MT+Sq5ZKqGSqaYFUNPxjqJrapf693FFfO0O8ruiKoCIHml/RZKTivwP
XGfbToxUmZw75BMVANxOCFMSGyQG+w3R/su1EyJP9obbVOkb6f8fIBTLaEwu4MtD
/UwMU6uOZIzcfIK8OY/BoHGHv/3grWb7GR+MMRIJ9gG4+9DrRuS36O/Dxz40Kw5i
64ZbppWGhPoU5hjoWzS9c5XPl3D0KhuWV8UUElwKq+LarNelqS1jHZ7//C/OnPTw
bnN6ylQliAQEFci1et8tPpmLlaIbwgP6K4GMMR5ywLDCflbO7dBM/BxjMLyNJELs
PKPDT83bdnvYubNqXaHSkwDY+h4kWplunuso2oTzgxCZcUgyriXbppZQMCS0Du7D
NGSn1lI4MNLggQ+TvXQ25LtON5vo5PMsMnaX1Ox6NPrwjVDN/8fqAsUp5mVLSrZs
DALg6ZtoM/4u/NyiF0UFGAxqCw4trHmXw8tWMjQ2fZDupEdIlwc=
=r5oI
-----END PGP SIGNATURE-----

--khrwSSTxyUQyy1lH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
