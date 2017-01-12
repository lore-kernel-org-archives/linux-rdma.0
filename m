From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/qib: use rb_entry()
Date: Thu, 12 Jan 2017 12:09:56 -0500
Message-ID: <1484240996.123135.8.camel@redhat.com>
References: <ddabc96c798df194791134d8e070d728e2a7b59f.1482203698.git.geliangtang@gmail.com>
         <b3d122a5a5a74579c4854cde74974e2cbc140be0.1482203536.git.geliangtang@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-keT3KzTaUNoZo3b4DGVa"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b3d122a5a5a74579c4854cde74974e2cbc140be0.1482203536.git.geliangtang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Geliang Tang <geliangtang@gmail.com>, Mike Marciniszyn <infinipath@intel.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-keT3KzTaUNoZo3b4DGVa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2016-12-20 at 22:02 +0800, Geliang Tang wrote:
> To make the code clearer, use rb_entry() instead of container_of() to
> deal with rbtree.
>=20
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>

In spite of the fact that I don't really like this patch, and don't
think it's an improvement, because other people have taken the same
basic patches, I'll not reject this one.

--=20
Doug Ledford <dledford@redhat.com>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-keT3KzTaUNoZo3b4DGVa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYd7hkAAoJELgmozMOVy/dEkoP+gMgEcB1+HwERfjrGBnutDM8
fk4LPKwCPSVXwszpVYBW2dKFHmhRZVQkUKrKyRfU+1lpeomdbNL7FYFVNfIXHwIv
lZQ6IZTZ5DmBXdH4+fvN80XpzNztNXvbrG5BbFIwaEfPvqs8KPCpzX/IWMXmxZHA
bSo1hh0qe6lOJwLC18zPo6wnP0Zc15IduJritpiazp1bhrOtTBMgURUdKFtBuYdm
8y+0252OTPKCr/sgyakhJkDkCEnoFryDeM/imkoMm6fO8MKJwdgEssIisiUEn975
6tD6N0HRjc2KazMNVXMT209Rrq2J4mr173myEMD6F2bLhaMpbju9UTqFmtBMNrZK
1dYmu75N+9nHzzwEPKGnkeODky/5RQiQIzL0ymwEdvDlAyl5iZDXLxlOdbhncS+X
nTah4BIBUhMiivgPzS1mFMq+PXmdnA11EslNR56YmxAtZShnfqr1IGAii3AxUTXn
Cj27M469PgcqvcJE6QmeqbxjykfKnfm6JKyr7Sl01QpzUCBc7ne2PZubxHfE8L+a
FE4DyU+foIE8obgvulSEBM2azSmwzdUZNt5HZW+Y+qCtY7MkgYPIvjXdbZUmtbRS
0PBf5ZcvpGJ8xBPcKnSIasLPgYuCal49m3wBKgKeJKamv0snS9PAmHmPRPkse2vp
uHrtZx3HO0elXaavy7+4
=kRlk
-----END PGP SIGNATURE-----

--=-keT3KzTaUNoZo3b4DGVa--
