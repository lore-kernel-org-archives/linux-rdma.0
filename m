From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] RDMA/bnxt_re: add DCB dependency
Date: Sun, 19 Feb 2017 08:58:49 -0500
Message-ID: <1487512729.86943.116.camel@redhat.com>
References: <20170217144110.2237820-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-C+7dzjRFTGPvhzhIwxgL"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170217144110.2237820-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Selvin Xavier <selvin.xavier@broadcom.com>, Sean Hefty <sean.hefty@intel.com>
Cc: Devesh Sharma <devesh.sharma@broadcom.com>, Somnath Kotur <somnath.kotur@broadcom.com>, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-C+7dzjRFTGPvhzhIwxgL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2017-02-17 at 15:40 +0100, Arnd Bergmann wrote:
> When CONFIG_DCB is disabled, we get a link error:
>=20
> drivers/infiniband/built-in.o: In function `bnxt_re_setup_qos':
> trace.c:(.text+0x155774): undefined reference to
> `dcb_ieee_getapp_mask'
> trace.c:(.text+0x155774): relocation truncated to fit:
> R_AARCH64_CALL26 against undefined symbol `dcb_ieee_getapp_mask'
> trace.c:(.text+0x155794): undefined reference to
> `dcb_ieee_getapp_mask'
> trace.c:(.text+0x155794): relocation truncated to fit:
> R_AARCH64_CALL26 against undefined symbol `dcb_ieee_getapp_mask'
>=20
> Like the other drivers that use this function, a Kconfig dependency
> is
> the correct fix.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks, applied.

--=20
Doug Ledford <dledford@redhat.com>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-C+7dzjRFTGPvhzhIwxgL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYqaSZAAoJELgmozMOVy/d5YoP/1BCuxDD4b1wG+4WcEwbahqK
7He0nrQOmgUpV6+iR6XEEIDyOpBrevUmn2Qvci6HRJHmwhk8XBmtO1wTWNUVe4Uk
qQH+8r6ObVcP1Fi8FiLOkmtnt/x/2m7SlLYq/lHMUg9xu2RblKWmUYJ+Zxkra7sB
CACA69OUOP4jh7dala+TRQJDPG7Jk00Kz7kNxAVEghrdbOJM1XH1ioBpEeJpNbJ6
J7wbE/TUo4CvonZcePokTHtwZS5MdOJxEskbCPf25L6UA3hCsa3eq1IAgRpYZpBN
H+Wg+UtHUbQzqM4enmg5yqUD9RwsSMCsGvCImV6/+LFabLUpFIoyi/vk4ozGjF+K
x5yHqEtcQmUSwuXFk7hgrwC/nDLAYmjjUOKT+6fMXQPfWFvjtKE8rntErA/7TSiP
s0CjGN4jywd4WtIsPFUKMVABVozobqowG+9E0mHkNHwPC9uIUiFfL8UEQYPNGDQo
16RmpOm/YVU3fS+gTGhLdRnLH4/GxzzmR8882tijUiOq1OAaTkGIOrbszBNxOrCD
iiR/mHOK24bx28O16N86Z8gYOyl+P84LJyuQHVuebducAPDurUryL6ZtMLaBwsBv
2ifNtz3pMYIiPvQ0o4M2ZHGoNbTZRCQMRfYuAeHnBaA3kOtA8Um4A/sK5U5iM+Lj
KFEFj009Jdrs5ZnfNZDR
=eR3K
-----END PGP SIGNATURE-----

--=-C+7dzjRFTGPvhzhIwxgL--
