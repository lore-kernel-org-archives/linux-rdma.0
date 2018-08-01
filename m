From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the net-next tree with the rdma
 tree
Date: Wed, 1 Aug 2018 15:33:45 +1000
Message-ID: <20180801153345.22692adb@canb.auug.org.au>
References: <20180727123301.3ac97ddc@canb.auug.org.au>
        <20180727024832.GA30023@mellanox.com>
        <20180727132847.2be8563b@canb.auug.org.au>
        <VI1PR0502MB3008702AFA64F44DE57DC9F5D12A0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
        <20180727150903.0f2816ba@canb.auug.org.au>
        <VI1PR0502MB3008076016496152D4898D8ED12E0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/dDQdiXnugJklB1/GrWVKH5K"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <VI1PR0502MB3008076016496152D4898D8ED12E0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Parav Pandit <parav@mellanox.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, David Miller <davem@davemloft.net>, Networking <netdev@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ursula Braun <ubraun@linux.ibm.com>, Leon Romanovsky <leonro@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--Sig_/dDQdiXnugJklB1/GrWVKH5K
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Parav,

On Tue, 31 Jul 2018 21:12:00 +0000 Parav Pandit <parav@mellanox.com> wrote:
>
> You might want to consider this compatibility patch in Linux-rdma
> tree to avoid a merge conflict of smc.
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/commit/?h=
=3Dfor-next&id=3D7aaa1807e698f73094b78f0ef25b1a37a4409a55

Ok, since commit that is now in the rdma tree, my resolution of the
original conflicts comes down to dropping all the changes to
net/smc/smc_core.c net/smc/smc_ib.c that come from the rdma tree and
adding

#include <rdma/ib_cache.h>

to net/smc/smc_ib.c.

--=20
Cheers,
Stephen Rothwell

--Sig_/dDQdiXnugJklB1/GrWVKH5K
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlthRjkACgkQAVBC80lX
0GyjwggAk3Mmdj+p/qwxlJS9NnJ8IwCPYvSGfbGVRKNun/AwSGSJO60X57M8Ne00
KN+8uJrqwwtxSfrfdPlVeTZhODK55vePIIaUbmAxUvcKvOQvNGSwPajCFXzXA1IC
mJUAV5w2vq5RReJWfKX0dusZZJKf2VvGzDxbu9JEeE05hMNy94A8r4lRJX7zN8cQ
QPvS22C42D02UbnhjTeBDkQstbZdHvbu4NMkckdajU1p9eXIL73zQVCWtfBPe5op
zNmHq0jPu9R5GyysqU+By88pbtPqJRnfoA8LriKuEk64Hznc3t82V7Ygbg3VlCRL
YRysMdLWiLTfc2rXqeCyCGd75Iq0yg==
=dBjF
-----END PGP SIGNATURE-----

--Sig_/dDQdiXnugJklB1/GrWVKH5K--
