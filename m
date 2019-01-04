From: Jason Gunthorpe <jgg@mellanox.com>
Subject: [GIT PULL] Please pull RDMA subsystem changes
Date: Fri, 4 Jan 2019 05:00:10 +0000
Message-ID: <20190104050001.GA26256@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Doug Ledford <dledford@redhat.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Second merge window pull request

This could also be applied after rc1. It is a small collection of fixes posted
over the holiday break. The merge error with advise_mr is worth fixing right
away so the other, more minor, things are coming along for the ride.

The following changes since commit 5d24ae67a961c51beb255a28c9c417d9710247c2:

  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma (2018-12-28 14:57:10 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

for you to fetch changes up to 9c6260de505b63638dd86fcc33849b17f6146d94:

  infiniband/qedr: Potential null ptr dereference of qp (2019-01-02 16:08:38 -0700)

----------------------------------------------------------------
4.21 merge window 2nd pull request

Over the break a few defects were found, so this is a -rc style pull
request of various small things that have been posted.

- An attempt to shorten RCU grace period driven delays showed crashes
  during heavier testing, and has been entirely reverted

- A missed merge/rebase error between the advise_mr and ib_device_ops
  series

- Some small static analysis driven fixes from Julia and Aditya

- Missed ability to create a XRC_INI in the devx verbs interop series

----------------------------------------------------------------
Aditya Pakki (2):
      infiniband: bnxt_re: qplib: Check the return value of send_message
      infiniband/qedr: Potential null ptr dereference of qp

Julia Lawall (1):
      IB/ipoib: drop useless LIST_HEAD

Leon Romanovsky (1):
      Revert "IB/mlx5: Fix long EEH recover time with NVMe offloads"

Moni Shoua (1):
      IB/core: Add advise_mr to the list of known ops

Yishai Hadas (1):
      IB/mlx5: Allow XRC INI usage via verbs in DEVX context

 drivers/infiniband/core/device.c         |  1 +
 drivers/infiniband/hw/bnxt_re/qplib_sp.c |  5 ++---
 drivers/infiniband/hw/mlx5/mr.c          | 19 +++----------------
 drivers/infiniband/hw/mlx5/qp.c          |  3 ++-
 drivers/infiniband/hw/qedr/qedr_iw_cm.c  |  2 ++
 drivers/infiniband/ulp/ipoib/ipoib_ib.c  |  1 -
 6 files changed, 10 insertions(+), 21 deletions(-)

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfB7FMLh+8QxL+6i3OG33FX4gmxoFAlwu6E8ACgkQOG33FX4g
mxpEQg/+M3QO0bU1gpZ70aKTJyL2oyOlqI/gJm/8FFkwVzJEIyk0v1fXv/1jgdDm
fYuhW4HH9dRrDAhckrJYtAvZpmBd62aVbGWwB0e7TZzPRYNpo4b2z2oWVsiMBKb6
SZTFk2VkRCgbCTo0zPAv4+kKOBGjQ7k1CMCcBWyrPL0sMGdlqOhb89bBqHSTmEAw
bjHP/5GDjoOH81+S3udQ6XlMkrCBa8szoPPWdzqIsXP5qkXkUejSB4wcp2HA/0TL
5O0uRE1Mkmx4FfS6+iHUdxEiuVsAzsMHXjuX4WHmnH1MOPxJadCG89zwUwraCj1q
O3WnZNBiKc1787iYBZtMgh0KrqGy9OAcJmMicsSqQXSTZBDpceRGxC5vJptrwBDC
j1Bc9qfJIob3hARtxslc/LWHR/GjIBlxg6rMUd2GUHG//bljYp+pbPsVKdT7M0VA
PkWvHh7n/yrrsiqWQoCpsB9gYKZaBbnR3JOxP3ELw2WCv2eu2curoM4n9Z+3FXYn
FVOFIhtx/j8rgJsUbR+da3//PoiPaUJcAXAXl3R8qJ5wwwJfK2lZk0aQjbiq+X7M
3RO6voSKEJdh75Imyc21lbHfOfj8B+vQ+qpWbAv47gNDNAu1HzrOAo/5HastXLmx
pek8HFzLshDXEa60YC+R4KZ4vTFfwNNfuZEQk4yXENV7vNVE3b0=
=TqX7
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
