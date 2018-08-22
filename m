From: Jason Gunthorpe <jgg@mellanox.com>
Subject: [GIT PULL] Please pull RDMA subsystem changes
Date: Wed, 22 Aug 2018 15:44:58 -0600
Message-ID: <20180822214458.GA26822@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Torvalds <torvalds@linux-foundation.org>, Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Second merge window pull request

This is the SMC cleanup promised, a randconfig regression fix, and kernel oops
fix.

I've learned we have at least one regression this merge window in IPoIB,
which people are working on.

The following changes since commit 0a3173a5f09bc58a3638ecfd0a80bdbae55e123c:

  Merge branch 'linus/master' into rdma.git for-next (2018-08-16 14:21:29 -0600)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

for you to fetch changes up to 845b397a7771f2d3504beff5521f452be0d22eec:

  IB/ucm: fix UCM link error (2018-08-21 16:56:32 -0600)

----------------------------------------------------------------
Second merge window update

- Switch SMC over to rdma_get_gid_attr and remove the compat

- Fix a crash in HFI1 with some BIOS's

- Fix a randconfig failure

----------------------------------------------------------------
Arnd Bergmann (1):
      IB/ucm: fix UCM link error

Jason Gunthorpe (1):
      RDMA/smc: Replace ib_query_gid with rdma_get_gid_attr

Michael J. Ruhl (1):
      IB/hfi1: Invalid NUMA node information can cause a divide by zero

 drivers/infiniband/Kconfig            |  2 +-
 drivers/infiniband/hw/hfi1/affinity.c | 24 +++++++++++++++---
 include/rdma/ib_cache.h               | 24 ------------------
 net/smc/smc_ib.c                      | 48 ++++++++++++++++++-----------------
 4 files changed, 47 insertions(+), 51 deletions(-)

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfB7FMLh+8QxL+6i3OG33FX4gmxoFAlt92VcACgkQOG33FX4g
mxrw9w//Xvs2ltPmikbtL92R6o2kFIWNJemfvUnJmVkwjAAdrAOM89h81apygOMH
yW91pwFSQomwc3YEU5p7lFVztiRZdAS0yaRPQeHyTrl/q2JeeBJa7h8BRtDVFRPC
jBGVCket6EkqmDW6oNlbc6b5AKIuU2LP/I6gFp/qmWKgQ/65Y5yHfT2T3LUBh0nK
0ANvz/bbPpvl7pPGd8DWx145L6KpA+VZTNOA37FXDBa8ZNs3Px8dmrq6QFtWoAz2
ibsHXUFHC8G22n9mqWvyl/IPdFqvh/MTRF9qUAlufC//VVvqCaxIwMfXjPRiwUZY
1Q+uoC37L3JYIsSd9gmcGeZQM7o/Vg2UKqlQ3iY+Dl5m349klvNk8SH1G2iby9Tk
t77uGjiuNsho6tYYSgyFe6YWbjvypk/NWVBPLG6JhLMeoSQy1XTprvwiCOfgsCFo
fQSgr0VGh9xZJ8DxT2Ea5BjXpE69bG/2xWzSPuRwja/sDZQbUa/U/2Ca4/m/j5tM
57Mz02zJq4s/gOawRaqy7cn5dW2yQON3aoy6OX2rQipQ7/9EAdKEedXQm6V8GcHm
ApiULqjaMmUbKZ+sKgB29V88VKXH5fj7kCpxnkQJkAU1R3l95vZOfI92VFYGEnxF
speTMfkfN4rM1ClCIfs5wQZws4XbTsSbTD2dkJdoQJRsU0z06Bo=
=9LN5
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
