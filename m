From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build warning in Linus' tree
Date: Fri, 18 Mar 2011 10:04:18 +1100
Message-ID: <20110318100418.6556c92c.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__18_Mar_2011_10_04_18_+1100_Q7uStZrPoxj+6nhz"
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Hal Rosenstock <hal.rosenstock@gmail.com>, Eric Dumazet <eric.dumazet@gmail.com>, Tejun Heo <tj@kernel.org>, Changli Gao <xiaosuo@gmail.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

--Signature=_Fri__18_Mar_2011_10_04_18_+1100_Q7uStZrPoxj+6nhz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the Linus' tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

drivers/infiniband/core/addr.c: In function 'addr4_resolve':
drivers/infiniband/core/addr.c:188: warning: 'ret' may be used uninitialize=
d in this function

I didn't notice this one before, sorry.

I don't know what introduced it, but the third if statement in the
function will make us use "ret" uninitialised.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__18_Mar_2011_10_04_18_+1100_Q7uStZrPoxj+6nhz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNgpNyAAoJEDMEi1NhKgbsvJ8H/RG5X3ZUgtexwYrofgyqw4YU
kRROlLz9Dy/CH0v9rV+S/xLvnxSGume1XjOEVVT/LI4bA5NbeSDwpZ55ZlJ/DyCi
cYnGC+4GrLvUDqJ9zA5ekP93MBbevzq9icaZDa9ndZiA5o+QAh53rwShieZd25Rw
6vc1gbYJ2boYLuSEzWF5VPpWaevvblpYMd7EuFbqBTvoGARu1yogUraKQsmLGGp8
+EQ0lHOZutWe8sDTVwuoZkGQ/MHQYq1JpGl95pNgEo6X0ekulXtuH0LHmqPff38D
aTI6SpkpSxJqxKUFicHGO8gdBkF6AShekxJP15cE77wUEutNFSixDfi4upFOTEs=
=X7KB
-----END PGP SIGNATURE-----

--Signature=_Fri__18_Mar_2011_10_04_18_+1100_Q7uStZrPoxj+6nhz--
