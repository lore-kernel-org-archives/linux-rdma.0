From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: use size_t for passing array length
Date: Sun, 19 Feb 2017 08:56:35 -0500
Message-ID: <1487512595.86943.112.camel@redhat.com>
References: <20170214212358.2730288-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Ili61vkFRu0rR59le65h"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170214212358.2730288-1-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-Ili61vkFRu0rR59le65h
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-02-14 at 22:23 +0100, Arnd Bergmann wrote:
> gcc-7 produces a mysterious warning about the size argument being
> potentially out
> of range:
>=20
> drivers/infiniband/hw/hfi1/verbs.c: In function 'init_cntr_names':
> drivers/infiniband/hw/hfi1/verbs.c:1644:2: error: 'memcpy': specified
> size between 18446744071562067968 and 18446744073709551615 exceeds
> maximum object size 9223372036854775807 [-Werror=3Dstringop-overflow=3D]
>=20
> This seems to refer to a the case where an 64-bit size_t gets
> truncated
> into a negative 'int' and subsequently turned into a high 64-bit
> number
> again.
>=20
> The fix is clearly to use size_t here, which matches the type that
> gets
> used for this value elsewhere.
>=20
> Fixes: b7481944b06e ("IB/hfi1: Show statistics counters under IB
> stats interface")
> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-Ili61vkFRu0rR59le65h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYqaQTAAoJELgmozMOVy/dOOoQAKdXdFImWNqEhMI6jReF7b2R
w6NbAO+VMjj7Mp0NMxbpkij38RduJ5wINlcBYEFRjY4Oytyly9MsyBalTfSQ0nsM
GCosAlDBfo5x8vD19XvnetoAiNcoKstk0GrrMVydkEpTLy6oyEq5zRMYvY0GnPMa
4M5fCaNU9jppJc6VNwoDwiCOozOOy9VEXPsw691KVYKGxcWbvg56AgL/v0FODBwB
vHWsQlWLBVtMid1TmW9MpPiEdO55iJQ1g2jzzhmXScXC8L6jL7hhFG02u78ZuzZI
xU1X7nl5ouevkXWwUR5Xjinca/IfNZu3QOVp0orrIfiY8zTUyMiwxZ4S1hno9HrO
6iODNFifKOPOKThgDeM30Ui/sX2i2pXjPFqFJYovANoI1C2s4VZOqwxiZJmH956A
qg1CEt/MvIp9odf/0tbaLi0YFFwfl+S45ZXU1+W3EaV4/Z3bVeVYligFQo0T1hkx
RzYJsx10rKDeGbHBbpahA8eGc/QStkmHBW0gWlez6juGQwVD/6ti8aduTDGzzvgm
JTsTAPVD7GqSiDzvkrtzUwzCZp+x6XNpme40u8pTjDQdMjGSxdbAUz1tIFhL7m2c
X+Uy+b+pzfAAnZMtKinzCHosxlp4CsUwTth+8ygN+MRKNRHRTdwI/dNVxidocynn
k6/ZCsj96nMMyUri4oZc
=TlDk
-----END PGP SIGNATURE-----

--=-Ili61vkFRu0rR59le65h--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
