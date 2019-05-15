From: Jason Gunthorpe <jgg@mellanox.com>
Subject: [GIT PULL] Please pull RDMA subsystem changes
Date: Wed, 15 May 2019 00:46:58 +0000
Message-ID: <20190515004652.GA17171@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Doug Ledford <dledford@redhat.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

These are the 2nd proposed RDMA patches for 5.2.

As requested the main reason to send this is to fix the gcc 9.1
warnings that many people may hit now that FC30 is out.

Thanks,
Jason

The following changes since commit b79656ed44c6865e17bcd93472ec39488bcc4984:

  RDMA/ipoib: Allow user space differentiate between valid dev_port (2019-05-07 16:13:23 -0300)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

for you to fetch changes up to c191f93454bcc92810b9c8cdb895a452a57948c2:

  net/mlx5: Set completion EQs as shared resources (2019-05-14 10:22:09 -0300)

----------------------------------------------------------------
5.2 Merge Window second pull request

This is being sent to get a fix for the gcc 9.1 build warnings, and I've
also pulled in some bug fix patches that were posted in the last two
weeks.

- Avoid the gcc 9.1 warning about overflowing a union member

- Fix the wrong callback type for a single response netlink to doit

- Bug fixes from more usage of the mlx5 devx interface

----------------------------------------------------------------
Jason Gunthorpe (1):
      RDMA: Directly cast the sockaddr union to sockaddr

Parav Pandit (1):
      RDMA/core: Change system parameters callback from dumpit to doit

Yishai Hadas (2):
      IB/mlx5: Verify DEVX general object type correctly
      net/mlx5: Set completion EQs as shared resources

 drivers/infiniband/core/addr.c               | 16 ++++++++--------
 drivers/infiniband/core/nldev.c              | 27 +++++++++++++++------------
 drivers/infiniband/hw/mlx5/devx.c            | 13 ++++++++++---
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c     |  5 ++---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c     |  5 ++---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c |  3 +++
 include/linux/mlx5/mlx5_ifc.h                |  2 +-
 include/uapi/rdma/rdma_netlink.h             |  2 +-
 8 files changed, 42 insertions(+), 31 deletions(-)

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfB7FMLh+8QxL+6i3OG33FX4gmxoFAlzbYXkACgkQOG33FX4g
mxqzBhAAmocSn2V083QOUUOPoRRjoJWVZZmVulrCp7jpNqI5i+3Cn+JriYC+82SA
87nAzbKOGqvSBg0lldSQRrrl1HjOGrAmGA2r10Iae24xqwAJ9NLErmJghpTW+QhY
owTBX/2TJuadLtwADvhCqQMmTLSm1KeRpgPeDz73XDPveRQuzjGdSSWVXQ7z1nGH
tLwCPZrOIAXK4ErUg/TfrVSmmsFDE0kkFpHlIzvP5t7rYyDhKt/Mgx1WghjdK8nE
3qQ40F2iEYoCW5sx15r3SwXEUfo7yO5B+c2LnkBjhEE0OY25syoDOnM8Q1MV6jcR
pblf0XAstS41DjYPB/7CObiSY6K37l6YybGflJwIaEU5zWc78DaIh1UD3WZddAvJ
OHszh/OO+nxWUya1KdJrwsstSlcKaZR/wwPnmE8OEO1cpj2k/vYRDgW8DuFcKQdV
qE7xfHcmP466KIZygLv8YGBCn1BLij3lz4EsDLa4dksA81/L7K5KQqpToVKjW9Lo
G7m8zny0ZQITN8JPckf1J0JF6MiHAD42youRcJB2il/PyrKOmQYJQ6BZvhzmndYb
8zvVC+Y4kwk615VmGuXq16Qwx72QEHuSfQb5dPbv2GfR26ntJJQT+VhceGMhtw53
chjalaGI+M4CtqBoLYNb/w08V7mERMlh3CklugHJXm/8QEE9AM8=
=F5G/
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
