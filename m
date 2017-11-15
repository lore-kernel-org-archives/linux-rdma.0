From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/5] buildlib: add script to dump ABI
Date: Wed, 15 Nov 2017 19:37:19 +0200
Message-ID: <20171115173719.GC18825@mtr-leonro.local>
References: <8306e0d4-3f4f-1d06-74e1-c971fc63f7b8@suse.de>
 <8bcdf747-5613-8990-5742-8a9b6e552ac9@morey-chaisemartin.com>
 <20171115055632.GR18825@mtr-leonro.local>
 <b36cd702-5d8e-c116-3306-39e1a1b8aaf5@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="nthI8DG+iQKFvgNS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b36cd702-5d8e-c116-3306-39e1a1b8aaf5-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--nthI8DG+iQKFvgNS
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 15, 2017 at 06:22:33PM +0100, Nicolas Morey-Chaisemartin wrote:
>
>
> Le 15/11/2017 =E0 06:56, Leon Romanovsky a =E9crit=A0:
> > On Tue, Nov 14, 2017 at 07:57:55PM +0100, Nicolas Morey-Chaisemartin wr=
ote:
> >> Builds rdma-core in -Og/Debug mode and use abi-dumper to generate 1 xml
> >>  per .so.*.* file.
> >> Do not use .so file directly. Providers have no symbol exported
> >>  and cause abi-dumer to exit with an error.
> > mlx4/mlx5 do export.
> >
> > Thanks
>
>
> Yes but they also export versiones .so files
> $ ll build-abi/lib/libmlx*
> lrwxrwxrwx 1 nmorey users=A0=A0=A0=A0 17 Nov 14 19:51 build-abi/lib/libml=
x4-rdmav16.so -> libmlx4.so.1.0.16
> lrwxrwxrwx 1 nmorey users=A0=A0=A0=A0 12 Nov 14 19:51 build-abi/lib/libml=
x4.so -> libmlx4.so.1
> lrwxrwxrwx 1 nmorey users=A0=A0=A0=A0 17 Nov 14 19:51 build-abi/lib/libml=
x4.so.1 -> libmlx4.so.1.0.16
> -rwxr-xr-x 1 nmorey users 276600 Nov 14 19:51 build-abi/lib/libmlx4.so.1.=
0.16
> lrwxrwxrwx 1 nmorey users=A0=A0=A0=A0 17 Nov 14 19:51 build-abi/lib/libml=
x5-rdmav16.so -> libmlx5.so.1.2.16
> lrwxrwxrwx 1 nmorey users=A0=A0=A0=A0 12 Nov 14 19:51 build-abi/lib/libml=
x5.so -> libmlx5.so.1
> lrwxrwxrwx 1 nmorey users=A0=A0=A0=A0 17 Nov 14 19:51 build-abi/lib/libml=
x5.so.1 -> libmlx5.so.1.2.16
> -rwxr-xr-x 1 nmorey users 690712 Nov 14 19:51 build-abi/lib/libmlx5.so.1.=
2.16
>
> So the .so are ignored (specially the -rdmav16) but the standalone ones a=
ren't

We are supporting static builds too (*.a and not *.so), can the script
be extended to check them too?

Thanks

>
> Nicolas

--nthI8DG+iQKFvgNS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloMe08ACgkQ5GN7iDZy
WKdW2w//dy3vQ6U7+t4a04jbTfJME95BkHC2wVGOZ+4Es8Rco1i+EhUcUFEFyC3k
4t5ML3bX815skYeldovTiJnSnOk1PyAmXbf96AY/8H8Tjosh5jgSoG7jTdNg5h04
dizRuIf8oplHN7s+NNEnlt56hoIutbMLDKJ2rhdteI+xerRINlGaXUuS8FabATTh
mV/Ep2cidGMY6GvKPFqxuWRLFNuHQ3VG1TDbhxI14D7O4mhD1jHswaasyPB61jc/
kM1bwCuJM/EgGtSy0v4y5dml8dzft2jR4bVnM+Mro4yg1HbZfTLGvEczXE2MWOoB
V6k5sKn1ODJq0GW4xlEOJ6HyT9GruFPsbJubvSyythlBUQ/3CO8CJ6WW/LWSa7EC
A9j9WWT0ZAJvNvJyD2ZR/auodygMjdkgsxHZwTg6SSdY3F05pSIg3CPhD1HhVW7G
z9jI1Sn/tUCciXExV1H3oaptoKGZ22FUsTYPCr14ppED5sIVr4oeICgRDy+fo6Jr
Jil/V+LvF41y6ubB5G43ZCDRSpLha1UIHxAj4a/1BQG9C7kPnvnycbIauiVqQaa2
FUTSJh6b2KkgOuRvXeo9C/yJbI9bs0EeDSke2RCAVz69fRj9oCgl0OspKT2NkP1l
pj22APJDJtL/prGioVOOyzzjis2INkCyP/I8RMJYvUL6rSJ/f8E=
=xS9n
-----END PGP SIGNATURE-----

--nthI8DG+iQKFvgNS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
