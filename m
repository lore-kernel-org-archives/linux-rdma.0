From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Patches for rdma-core stable-v15
Date: Mon, 13 Nov 2017 17:14:37 +0200
Message-ID: <20171113151437.GL18825@mtr-leonro.local>
References: <6ccc2110-2e27-bacd-b821-f862785a10ca@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="nf2vo/mUTtJdHW8B"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6ccc2110-2e27-bacd-b821-f862785a10ca-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-uk2M96/98Pc@public.gmane.org, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--nf2vo/mUTtJdHW8B
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 13, 2017 at 04:02:26PM +0100, Nicolas Morey-Chaisemartin wrote:
> Hi all,
>
> After looking into the ML, here are the candidates for the stable-v15 bra=
nch.
> Can the authors please confirm that they should be applied there ?
>
> Please let me know if I missed any.

In addition to the your list, I would like to see the following patches too:
commit dbf7bd2151815a12428caef6874149523c0bda8e
Author: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Wed Oct 25 12:04:53 2017 +0300

    verbs: Fix declaration of C++ include file in C-block

commit 6a74285158a146f23cbf8a804fd9de32df0d5ed2
Author: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Mon Oct 9 10:56:21 2017 +0300

    verbs: Fix C++ compilation break

commit 983f80191923c082324295ea68ac91d34daaa4c8
Author: Nelio Laranjeiro <nelio.laranjeiro-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
Date:   Tue Sep 26 16:05:11 2017 +0200

    verbs: fix compilation error with ICC

commit bf03566e0aa976afc5dfbf917296280e9fa55bb8
Author: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Date:   Mon Oct 2 04:17:09 2017 +0800

    hns: Fix create QP structure layout


Thanks

>
> Nicolas
>
> ---
>
> Devesh Sharma (1):
> =A0=A0=A0=A0=A0 bnxt_re/lib: increment psn in case of 0 length packets
>
> Hal Rosenstock (1):
> =A0=A0=A0=A0=A0 libibumad/umad.c: In get_port, ignore sysfs rate file err=
ors
>
> Jason Gunthorpe (1):
> =A0=A0=A0=A0=A0 verbs: Do not block QP attr_masks used by older kernels
>
> Michael J. Ruhl (2):
> =A0=A0=A0=A0=A0 ibacm: Incorrect usage of BE byte order of MLID attach/de=
tach_mcast()
> =A0=A0=A0=A0=A0 ibacm: Incorrect list used for subnet list causes a segfa=
ult
>
> Ram Amrani (1):
> =A0=A0=A0=A0=A0 libqedr: fix inline data copy
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--nf2vo/mUTtJdHW8B
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloJtt0ACgkQ5GN7iDZy
WKdz9g/+Lq3DPJnVGSCkuLDBjSm011FGvc06+gRzIp3ukvQXP/DC9Lkc+Is4mHFl
D1VLuJD+ELatgXZJarl9cX2Ils2znXerIMYmgaQ7tR+veJH4uman6UUvpbeggTZO
/SIM5K5bIFrQX5JosxpI+da3dL1+edeInu58mXbt4YLKxN7LLD4JUFFIzxDvjz3A
bQ8Ws1JxDd0rLh9gQVWMxqZV7AdZcpkIzgPIPlwvn9WUmECLLY3jQpKM1fSOv14A
37oEGp7EgBShO+xVPgLSrGahyNSEjGdiclkfAjVGbZ2OHBliw7vTfm3ZolS3Lz7o
3uQq6FFGdAiL8XvL99yCKh8rCqP5x1TgHM1F25JllixH6yQ6Q2lF2j2xoJCajcm3
bd8r0rCStsvT8g7M6VZLnfvTZ9AQtbRI57TAM/rfoiFofK2dEOn8pCcusBiHkSTK
2/Jl69vZLOAieZtQ3WH74guFMkXzR7KNCzGXdH3aKKtoDCky/j7OJ6Rapp5oRcMR
7HAZfm0Y1/OFGLWnBwjqL3LIQMlZ1l0bpbP2zduRUaaztDRABWB9oU2B1jGv3xnl
N8VikPRqZnEj3rD12VVKBKxt31ew3wDczKLjoWUlCm/L9k60dtghq3RP2Z4t3Rv6
cJbyiUWEmigqA71hk5cgbeATmb+Iu6kw14dE2aS/IDhEju2+0f8=
=Lc0J
-----END PGP SIGNATURE-----

--nf2vo/mUTtJdHW8B--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
