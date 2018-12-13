From: Doug Ledford <dledford@redhat.com>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Thu, 13 Dec 2018 11:56:10 -0500
Message-ID: <267101dbb3beb8883efe614e099e7ac4c7a84f37.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-D9i8SVO0+y+hI6fdaMxC"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Torvalds, Linus" <torvalds@linux-foundation.org>
Cc: "Gunthorpe, Jason" <jgg@ziepe.ca>, linux-rdma <linux-rdma@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--=-D9i8SVO0+y+hI6fdaMxC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

We have 5 small fixes for this pull request.  One is a performance
regression, so not necessarily strictly a fix, but it was small and
reasonable and claimed to avoid thrashing in the scheduler, so I took
it.  The remaining are all legitimate fixes that match the "we take
fixes any time" criteria.

Here's the boilerplate:

The following changes since commit 7bca603a69c0c239654a8f0bcb99e1a60b30040c=
:

  RDMA/mlx5: Initialize return variable in case pagefault was skipped (2018=
-11-29 15:16:45 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linu=
s

for you to fetch changes up to 37fbd834b4e492dc41743830cbe435f35120abd8:

  IB/core: Fix oops in netdev_next_upper_dev_rcu() (2018-12-12 12:14:49 -05=
00)

----------------------------------------------------------------
Pull request for 4.20-rc

- One performance regression for hfi1
- One kasan fix for hfi1
- A couple mlx5 fixes
- A core oops fix

----------------------------------------------------------------
Artemy Kovalyov (1):
      IB/mlx5: Fix implicit ODP interrupted page fault

Mark Zhang (1):
      IB/core: Fix oops in netdev_next_upper_dev_rcu()

Michael J. Ruhl (1):
      IB/hfi1: Fix a latency issue for small messages

Piotr Stankiewicz (1):
      IB/hfi1: Fix an out-of-bounds access in get_hw_stats

Yishai Hadas (1):
      IB/mlx5: Block DEVX umem from the non applicable cases

 drivers/infiniband/core/roce_gid_mgmt.c | 3 +++
 drivers/infiniband/hw/hfi1/chip.c       | 3 ++-
 drivers/infiniband/hw/hfi1/hfi.h        | 2 ++
 drivers/infiniband/hw/hfi1/qp.c         | 7 +++++++
 drivers/infiniband/hw/hfi1/verbs.c      | 2 +-
 drivers/infiniband/hw/mlx5/devx.c       | 4 +++-
 drivers/infiniband/hw/mlx5/odp.c        | 9 ++++-----
 7 files changed, 22 insertions(+), 8 deletions(-)



--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-D9i8SVO0+y+hI6fdaMxC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlwSjyoACgkQuCajMw5X
L93AAhAArQcB28UZwypl9TI2eVIXg+zNQqnHIppGrx2TmV20yDRHyDSiWJASVgI5
SWicp0a8wurPZoWzK9Z8zjnwI8F1PvvnyWMD5r2wZ6LJQhiFN4pVC4zQvG/lb+7G
gPVSiSaUOgOTMqNZqgCj9uyhk20gdB9+tfn+R6yHo2EgIq2Z4Ppo6qkv2kBRS4FD
/AUaabt7Dt1Lc4HaQbZDSq9j5hK8OwBCEdZCR4Rv5Z+rAUr69jqQ3XYgwmPQakC/
fAnI/sLgmma11vnNKhAuSzXyoI0C0EebCUnl5extMaQqS4fXyyh3cK844XmiunR1
1G0Edm115GQOSOhAh8kF5J/1SYBN32cLpkMtBIISrcCrZx5Ryk5qVRePmw5g8Xbs
QWqbE0rSnSXP7x6bynbSYWUotl9y3HdmCDH689MJREmcBbP5qvR1q09sI8WO1XPb
LDlYcF7VWrxRLX5mr2Max8DZmarkwwGU8Aq3bnDrCHeonUy7rR0YRM5wlGKQQ25b
/ydczd+dBie34lo+Rri1b/Osdb1wPfAt8/HCVbK9GKsF7kHpzWzL5u8KHIOP0W7C
hZmnq3OPddohsHmxM0Fkl12+xZzyJkDoEhoE0JXti/h9b00+buG8gwE3sn5b89AA
+YCTpZ8eEWvVvzs64bL0V/1LsGzz9S+iWcK46kTyj3h8mxPQF8E=
=Rd0N
-----END PGP SIGNATURE-----

--=-D9i8SVO0+y+hI6fdaMxC--
