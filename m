From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build failure after merge of the infiniband tree
Date: Fri, 6 Jul 2012 12:35:55 +1000
Message-ID: <20120706123555.949d8efb4de5c4df18fb1ec0@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__6_Jul_2012_12_35_55_+1000_CO4._s2p=E/sOMIf"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, linux-rdma@vger.kernel.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Sean Hefty <sean.hefty@intel.com>
List-Id: linux-rdma@vger.kernel.org

--Signature=_Fri__6_Jul_2012_12_35_55_+1000_CO4._s2p=E/sOMIf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the infiniband tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/infiniband/core/cma.c: In function 'rdma_bind_addr':
drivers/infiniband/core/cma.c:2411:30: error: 'struct net' has no member na=
med 'ipv6'

Caused by commit e7925058b0ed ("RDMA/cma: Bind to a specific address
family"). CONFIG_IPV6 is not enabled for this build.

I have used the version of the infiniband tree from next-20120705 for
today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__6_Jul_2012_12_35_55_+1000_CO4._s2p=E/sOMIf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP9k8LAAoJEECxmPOUX5FEGvsP/3cYLhdGMBiN+aGnUZNvbEjW
qaV25Uf61x631HlCXP0uhFvPFta8q7h6LH++kSSgPeEzMUOUymXfxtZtWGFg+C+z
SXmuXcdiWb+ax7lE402RZ8lOxba61n356OYfNyHuSK6uc5vdlng0D/0L9oNudpPy
8CL226BBWgY/qrEfesEdIxyI9mpywZPSJHw9FGlqP87YWLEBb+5fHLRT6RZTgG6A
ImuDzuMxHE98no3ACUQ2A1VIpKMtIjVALi3YT9Pciskc5TDx++BXQ0k+nTRWtr5S
bn39sheyLp5AqX5+m7kKxMFjws3E3F+46Q72vDHU+GjuBHp7sZ2DAToaX7r/2+zd
JodfrZ3zSjvZERKYDfXcCO4l8LmaJDr4qSkQ54vkD+KTdl+Pk/DMi/LwcNi6G8YY
0W4oyrFoUrO7cB2F7N7tpZJvVt87W977Lk6Jb9bOh5AapE2xbxFKy5pvHyGe4c9j
25CNhjgpuymtw/iEt071jsb/7eJkDUJmobvm5QnvaK4+Qm6d+LBxUx+gjCahSKJs
yQk0hr8fRhrPXXeUMP0ynna9uDSweflwHBtSLXS/7xDqd/66GYm8A9AjGyFBZNYX
hDs3Z/KsesKB/Cj7YBJrDZXSpya3Rb//on5VZGlixO2BpceiEQzXoCu3PqVJ56Yg
RrbWVxVhcsX74+4fQGnN
=6tCn
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Jul_2012_12_35_55_+1000_CO4._s2p=E/sOMIf--
