From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.3 0/6] IB: set of fixes and additions
Date: Wed, 11 Jan 2012 18:52:00 +0200
Message-ID: <alpine.LRH.2.00.1201111850330.10264@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The series is made of four elements

This subset (patches 1-3) fixes two bugs port info related bugs, where
the first patch is just making following code related to speed possible...

[PATCH 1/6] IB: use central enum for speed instead of hard-coded values
[PATCH 2/6] IB/core: fix wrong display of rate in sysfs
[PATCH 3/6] IB/mlx4: fix wrong info returned when querying IBoE ports

This patch comes to address the long pending patch for 4k mtu
along the lines of what was requested over the last review

[PATCH 4/6] net/mlx4: allow for dynamic mtu configuration for IB ports

This patch is simple and comes to unify the approach for checksum
indication with possible / hopefully soon changes in libibverbs

[PATCH 5/6] IB: change CQ TCP/IP checksum offload mark to use bit flag indication instead of integer

This patch extends the IPoIB child scheme, and will serve as
a building block when using IPoIB in the Virtualization space.

[PATCH 6/6] IB/ipoib: add support for clones / multiple childs on the same partition

Roland, Yep, this submission comes a bit into the 3.3 merge cycle, but
with its fairly limited scope, I hope it can make it there... as of the recent
changes in mlx4_core, patches 3 & 4 need you to pull Linus tree, but this should
be done now anyway for any future patches to the IB stack through out the 3.3 cycle
and elsewhere


Or Gerlitz (6):
  IB: use central enum for speed instead of hard-coded values
  IB/core: fix wrong display of rate in sysfs
  IB/mlx4: fix wrong info returned when querying IBoE ports
  net/mlx4: allow for dynamic mtu configuration for IB ports
  IB: change CQ TCP/IP checksum offload mark to use bit flag indication instead of integer
  IB/ipoib: add support for clones / multiple childs on the same partition

 Documentation/infiniband/ipoib.txt           |   24 +++++
 drivers/infiniband/core/sysfs.c              |   25 ++++--
 drivers/infiniband/hw/amso1100/c2_provider.c |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |    2 +-
 drivers/infiniband/hw/cxgb4/provider.c       |    2 +-
 drivers/infiniband/hw/ehca/ehca_hca.c        |    2 +-
 drivers/infiniband/hw/mlx4/cq.c              |    3 +-
 drivers/infiniband/hw/mlx4/main.c            |  107 +++++++++++++-----------
 drivers/infiniband/hw/mthca/mthca_cq.c       |    3 +-
 drivers/infiniband/hw/nes/nes_verbs.c        |    2 +-
 drivers/infiniband/hw/qib/qib_rc.c           |    1 -
 drivers/infiniband/hw/qib/qib_uc.c           |    1 -
 drivers/infiniband/ulp/ipoib/ipoib.h         |    9 ++-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c      |    3 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c    |   48 ++++++++---
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c    |   40 ++++++---
 drivers/net/ethernet/mellanox/mlx4/main.c    |  118 +++++++++++++++++++++++++-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h    |    2 +
 drivers/net/ethernet/mellanox/mlx4/port.c    |   25 +++++-
 include/linux/mlx4/device.h                  |    1 +
 include/rdma/ib_verbs.h                      |   11 ++-
 21 files changed, 330 insertions(+), 101 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
