From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next v2 00/10] Add RoCE GID cache usage in verbs/cma
Date: Thu, 15 Oct 2015 18:38:44 +0300
Message-ID: <1444923534-10882-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This purpose of this series is to add usage of the GID cache to
the CMA and IB stack. Instead of passing Ethernet L2 attributes
via QP attributes, we could just use the GID cache that's already
points to a ndev and thus to all required L2 attributes.

The first five patches query the GID table to find only GIDs which
are related to the bounded net-device of the specific used port. This
extra information is carried via ib_sa_path_rec (extending it to
include the namespace and ifindex). Querying the ndev and port
is achieved by adding a gid_attr argument to ib_query_gid, add a
ndev argument to ib_find_cached_gid and add a new
ib_find_cached_gid_by_port. This usage of the GID table replaces
the usage of QP attributes.

The sixth patch adds an ib_cache_gid_find_by_filter function.
This allows the user to query the cache by a specific filter.
ib_cache_gid_find_by_filter is used by the seventh patch. Instead
of storing the smac and vid on the AH, we could just resolve
them from the net-device which the sgid index is assigned to.
This change means that instead of resolving all L2 attributes,
the server, we get the dgid and vlan and searches the GID cache
in order to find a matching GID index.

The last three patches removed unused fields and attributes.

Matan

Changes from V1:
 - Rebased patches against Doug's latest k.o/for-4.4 tree.

Matan Barak (10):
  IB/core: Add netdev and gid attributes paramteres to cache
  IB/core: Expose and rename ib_find_cached_gid_by_port cache API
  IB/core: Add netdev to path record
  IB/cm: cm_init_av_by_path should find a GID by its netdevice
  IB/cma: cma_validate_port should verify the port and netdevice
  IB/cache: Add ib_find_gid_by_filter cache API
  IB/core: Use GID table in AH creation and dmac resolution
  IB/cm: Remove the usage of smac and vid of qp_attr and cm_av
  IB/core: Remove smac and vlan id from qp_attr and ah_attr
  IB/core: Remove smac and vlan id from path record

 drivers/infiniband/core/addr.c                 |   3 +-
 drivers/infiniband/core/cache.c                | 112 +++++++++++++++--
 drivers/infiniband/core/cm.c                   |  40 ++-----
 drivers/infiniband/core/cma.c                  |  42 ++++---
 drivers/infiniband/core/core_priv.h            |   9 +-
 drivers/infiniband/core/device.c               |  19 ++-
 drivers/infiniband/core/mad.c                  |   2 +-
 drivers/infiniband/core/multicast.c            |   3 +-
 drivers/infiniband/core/sa_query.c             |  19 +--
 drivers/infiniband/core/sysfs.c                |   2 +-
 drivers/infiniband/core/ucma.c                 |   1 -
 drivers/infiniband/core/uverbs_cmd.c           |   3 +-
 drivers/infiniband/core/uverbs_marshall.c      |   4 +-
 drivers/infiniband/core/verbs.c                | 159 +++++++++++++++----------
 drivers/infiniband/hw/mlx4/ah.c                |  17 ++-
 drivers/infiniband/hw/mlx4/mad.c               |  12 +-
 drivers/infiniband/hw/mlx4/main.c              |   4 +-
 drivers/infiniband/hw/mlx4/mcg.c               |   2 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h           |   2 +-
 drivers/infiniband/hw/mlx4/qp.c                |  52 ++++++--
 drivers/infiniband/hw/mthca/mthca_av.c         |   2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c       |  22 ++--
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c       |  30 +++--
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c    |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   2 +-
 drivers/infiniband/ulp/srp/ib_srp.c            |   2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c          |   3 +-
 include/rdma/ib_addr.h                         |   2 +-
 include/rdma/ib_cache.h                        |  40 ++++++-
 include/rdma/ib_sa.h                           |  12 +-
 include/rdma/ib_verbs.h                        |  18 ++-
 32 files changed, 422 insertions(+), 222 deletions(-)

-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
