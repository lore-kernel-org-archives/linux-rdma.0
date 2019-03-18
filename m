From: Jason Gunthorpe <jgg@mellanox.com>
Subject: [GIT PULL] Please pull RDMA subsystem changes
Date: Mon, 18 Mar 2019 01:04:12 +0000
Message-ID: <20190318010407.GA26545@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Doug Ledford <dledford@redhat.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

First rc pull request - nothing too special, just some driver bug
fixes that have been sitting during the merge window.

Thanks,
Jason

The following changes since commit 9e98c678c2d6ae3a17cb2de55d17f69dddaa231b:

  Linux 5.1-rc1 (2019-03-17 14:22:26 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

for you to fetch changes up to ec4fe4bcc584b55e24e8d1768f5510a62c0fd619:

  i40iw: Avoid panic when handling the inetdev event (2019-03-17 21:40:40 -0300)

----------------------------------------------------------------
5.1 First RC pull request

Several driver bug fixes post in the last three weeks

- First part of a race condition fix in mlx4 with CATAS errors

- Bad interaction with FW causing resource leaks in the mlx5 DCT flow

- Bad reporting of link speed/width in new mlx5 devices

- Userspace triggable OOPs in i40iw

----------------------------------------------------------------
Aya Levin (1):
      IB/mlx5: Fix mapping of link-mode to IB width and speed

Feng Tang (1):
      i40iw: Avoid panic when handling the inetdev event

Jack Morgenstein (1):
      IB/mlx4: Fix race condition between catas error reset and aliasguid flows

Yishai Hadas (2):
      net/mlx5: Fix DCT creation bad flow
      IB/mlx5: Use mlx5 core to create/destroy a DEVX DCT

 drivers/infiniband/hw/i40iw/i40iw_utils.c    | 12 ++++-
 drivers/infiniband/hw/mlx4/alias_GUID.c      |  2 +-
 drivers/infiniband/hw/mlx5/devx.c            | 34 +++++++++----
 drivers/infiniband/hw/mlx5/main.c            |  7 +++
 drivers/infiniband/hw/mlx5/qp.c              |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/qp.c | 72 +++++++++++++++-------------
 include/linux/mlx5/qp.h                      |  3 +-
 7 files changed, 89 insertions(+), 45 deletions(-)

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfB7FMLh+8QxL+6i3OG33FX4gmxoFAlyO7oQACgkQOG33FX4g
mxoq0A/8CVz+6BHYBGjJ2+oyoBCJXtApJzqEJdtGQhkqPdr0V5giW3hKOJNkveJk
v0ul6T5f+eRkJjko4Wk1JTz1NrDtemlPDSLTwg7Q4ZJYENJC+y35X7AS2RTCWFI6
Gs9doTx4EiyZbx3fizome3ZNgaGFmtSHvW+1ImIssP3neoK9ZFeMw/M58QpRpCIc
tM+RoRA3jo7VwnNqzIiud5EJCz4tmy9+cqrHff0Z15j6bvfEyzbtmKq3oe2bFw9z
Id3q4xBQ99pt51r3zVlMzFV6HCbDIJ2fUcl/Kp4m0Oj9dslBlBZrWUJ/pjaP/OkO
1U8seQTnCj+fOkLzvQ6hjG/TaPm1dU/TtTk84Jv5g3WgzKj49Ak4ZmE/5IyOh2z+
KMV8ooBDQnK35xF3dhwmWNpcAfNClLk3KEyK6lUPOrAfm4sXPevCD4SLovcZqmIa
daYlfO7YEJ5+L/XgYbgRJb6qfaLWQtGYCUC9JPPmtf8oyKnHayf7lvzQ2X5Kv9pk
krnRomQJNpV5FCgSF+JZ3Q5/SnGT6zZyMNWGPue/61L6/gLY/wwsdoVQuVF68DRB
DtFrr4jVrItIRk85SdGczXZuYMQa/Kj2BndSuTl5HWBlnb0QfGN7bGpURGsCMT1K
OufRuMC/2AgOB4qc7zTmEUAnuotsLZNZNIXqre5fXYtzpVtf7Gc=
=+ta4
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
