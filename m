From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma-core: =?utf-8?B?4oCLbGliaWJ1bWE=?= =?utf-8?Q?d?= symbols
 version downgrade
Date: Wed, 19 Apr 2017 13:04:30 +0300
Message-ID: <20170419100430.GI14088@mtr-leonro.local>
References: <1492538111.18372.1.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="TBNym+cBXeFsS4Vs"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1492538111.18372.1.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: List Linux RDMA Mailing <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--TBNym+cBXeFsS4Vs
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 18, 2017 at 07:55:11PM +0200, Benjamin Drung wrote:
> Hi,
>
> while reviewing the Debian packaging changes from libibumad
> 1.3.10.2-2 to rdma-core, I stumbled over the symbols version.
> libibumad 1.3.10.2 ships libibumad.so.3.1.0, but rdma-core
> ships libibumad.so.3.0.14 which is lower. Is that intentional?

I don't think so. It should be 3.1.${PACKAGE_VERSION}.

Thanks

>
> --
> Benjamin Drung
> System Developer
> Debian & Ubuntu Developer
>
> ProfitBricks GmbH
> Greifswalder Str. 207
> D - 10405 Berlin
>
> Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
> URL:  http://www.profitbricks.com
>
> Sitz der Gesellschaft: Berlin.
> Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
> Gesch=E4ftsf=FChrer: Andreas Gauger, Achim Weiss.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--TBNym+cBXeFsS4Vs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlj3Ni4ACgkQ5GN7iDZy
WKdpQw//e1sMLUI4lh2lrZUglqLdRfh7cL5/c8b3UFNGq8F/EuPRLrn56YZ3mafR
n0Q2l9mYh983bCjQHPnBCRxiXEFnz51towFcpHDETg2pvhb81XlwxhEg4cUS9Pns
HMiovTIIHOzHchCr1ewe9sP57nCOkmVec9++elrgMyWKpbdVZO3Yhs2OKlERR9SJ
Duzv6XHS1tL4vBm3Gi8K3jfN2+dvDhIPZ5zV7+KyvAu/bIE28JOdaTU/mv+EBlwj
D9pVA0NalrkJPp75XPvNm4z6OOCBq0CHvdphgyeYhvQDx1114WZalgXs4YGfPmpS
ZUdSB2q95F01N66mSSFLjYN7Dz2fiUJRrLxv3LWBdworFFEG2o3aVspLOLTqYGNu
N8CMUPSauCp4M5TJFZqK4wUHIKnc0psK/IUR1XR1alt7Ss1yWuDhE+j9tXqmKQ9s
MiT0QEq/nM9Nr2Bljjd1DI+ep9lvhPXVnpP+S7BBdAzdwSPrvGqU80sh+4ZLGCGK
vy6vsj7vg7JWXiUdFekg/Rstk77JIyxieRvwNjUVE456QWLm04vpYzvk8ZO5/YDf
moaKAz43uSoQBhIhbPhy6SnC97oVmHMikl7s+OSUHLz6WxloYBJ51a7Cd+WLMdco
bFwOnYFhsOmuCzsJpe8Wpiu01U29nnuCgZcHdFIfc7ZPvUulwkQ=
=fIW3
-----END PGP SIGNATURE-----

--TBNym+cBXeFsS4Vs--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
