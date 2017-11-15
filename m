From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/5] buildlib: add script to dump ABI
Date: Wed, 15 Nov 2017 21:38:53 +0200
Message-ID: <20171115193853.GD18825@mtr-leonro.local>
References: <8306e0d4-3f4f-1d06-74e1-c971fc63f7b8@suse.de>
 <8bcdf747-5613-8990-5742-8a9b6e552ac9@morey-chaisemartin.com>
 <20171115055632.GR18825@mtr-leonro.local>
 <b36cd702-5d8e-c116-3306-39e1a1b8aaf5@suse.de>
 <20171115173719.GC18825@mtr-leonro.local>
 <9f40619b-bd97-ad6f-494b-c493dd3c3c21@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="DGJeRcv3Pogw2aF5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9f40619b-bd97-ad6f-494b-c493dd3c3c21-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--DGJeRcv3Pogw2aF5
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 15, 2017 at 06:52:49PM +0100, Nicolas Morey-Chaisemartin wrote:
>
>
> Le 15/11/2017 =E0 18:37, Leon Romanovsky a =E9crit=A0:
> > On Wed, Nov 15, 2017 at 06:22:33PM +0100, Nicolas Morey-Chaisemartin wr=
ote:
> >>
> >> Le 15/11/2017 =E0 06:56, Leon Romanovsky a =E9crit=A0:
> >>> On Tue, Nov 14, 2017 at 07:57:55PM +0100, Nicolas Morey-Chaisemartin =
wrote:
> >>>> Builds rdma-core in -Og/Debug mode and use abi-dumper to generate 1 =
xml
> >>>>  per .so.*.* file.
> >>>> Do not use .so file directly. Providers have no symbol exported
> >>>>  and cause abi-dumer to exit with an error.
> >>> mlx4/mlx5 do export.
> >>>
> >>> Thanks
> >>
> >> Yes but they also export versiones .so files
> >> $ ll build-abi/lib/libmlx*
> >> lrwxrwxrwx 1 nmorey users=A0=A0=A0=A0 17 Nov 14 19:51 build-abi/lib/li=
bmlx4-rdmav16.so -> libmlx4.so.1.0.16
> >> lrwxrwxrwx 1 nmorey users=A0=A0=A0=A0 12 Nov 14 19:51 build-abi/lib/li=
bmlx4.so -> libmlx4.so.1
> >> lrwxrwxrwx 1 nmorey users=A0=A0=A0=A0 17 Nov 14 19:51 build-abi/lib/li=
bmlx4.so.1 -> libmlx4.so.1.0.16
> >> -rwxr-xr-x 1 nmorey users 276600 Nov 14 19:51 build-abi/lib/libmlx4.so=
=2E1.0.16
> >> lrwxrwxrwx 1 nmorey users=A0=A0=A0=A0 17 Nov 14 19:51 build-abi/lib/li=
bmlx5-rdmav16.so -> libmlx5.so.1.2.16
> >> lrwxrwxrwx 1 nmorey users=A0=A0=A0=A0 12 Nov 14 19:51 build-abi/lib/li=
bmlx5.so -> libmlx5.so.1
> >> lrwxrwxrwx 1 nmorey users=A0=A0=A0=A0 17 Nov 14 19:51 build-abi/lib/li=
bmlx5.so.1 -> libmlx5.so.1.2.16
> >> -rwxr-xr-x 1 nmorey users 690712 Nov 14 19:51 build-abi/lib/libmlx5.so=
=2E1.2.16
> >>
> >> So the .so are ignored (specially the -rdmav16) but the standalone one=
s aren't
> > We are supporting static builds too (*.a and not *.so), can the script
> > be extended to check them too?
> >
> > Thanks
>
> Does that changes something ? As long as the specific build-abi build gen=
erates the .so, it should be sufficient to check the ABI.
> Wether someone build with static options or not.
> Unless there are other static libs I'm missing.

In static libraries, the functions have different signatures without stanza=
s.

>
> Nicolas

--DGJeRcv3Pogw2aF5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloMl8wACgkQ5GN7iDZy
WKeHExAAlAmPyx2zYaDtmHARy6lyZ+SVkLhvfAq5K8r4P3kqnG5cr5LR2TwIwcxJ
b5RAogjnskgKCZOV/wGURT/iY6wV2QXv1J+P6Ti0TCY3Z/JuKiLejttRL0nzuB4G
GQ8fkqeRohu4NEFvbRGkoeal/aQd6wexEuTNtLrWaUbJSRU4ZmGWdfijM2xm/jXM
c4l9a8uvyHywltByflib4W3WZIx1P2FhM+g2bmA5PJO3aaQltYyK8psTBFoAodfb
XFDFrynMA8JSul4lBaU8W/bD2NxvOgFEqhqpyvlyYw1iXle6lN++aqW/AX+dgh1l
3srIWzHkGUB+97uTMoeSifFNqy16FR3fuS7kO29a1gQlNMT/z62iKU3dryy3/gCG
LdExOmlCKOSuqx5V3h548O0+VBP7rO4zLvzCGkj8vk4UwK8DGc0AGht5DzKDYPEC
LG+YuYWn1WrKUn9Ly8ENJn0mzYQHe0Uq1ghrVLb5WCEm7pK1eGXM0plMoKSNEtx9
nfoLQCokIepnEOvGBvCf0V/AWgIa0S7NruhQAj+yKNQgoaTiY33XuyhndB0OBdqn
rnfUf7udWwF43CqAxX+Egui7wocv5uwkx7iJqtXF+uPBLmBMmgXjUeULJ5PuH9fn
pYgFi8Ef70+FiiH99ioqiVglkpd3CGYkw1VMRUBhvgy6UhA+sjE=
=AUf2
-----END PGP SIGNATURE-----

--DGJeRcv3Pogw2aF5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
