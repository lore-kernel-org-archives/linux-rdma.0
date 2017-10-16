From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v1 0/6] RDMA core and mlx5 fixes and refactoring for 4.15
Date: Mon, 16 Oct 2017 08:45:11 +0300
Message-ID: <20171016054517.30643-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

1) Introduce and use rdma_create_user_ah

Currently there is inconsistency in resolving destination mac address in
ib core and provider driver as below.
1. Provider drivers are using different API to resolve dmac.
2. Provider drivers are resolving destination mac address for user space
consumers, but don't have to resolve for kernel consumers.

This leads ah_attr->roce.dmac being input field for kernel consumers and
treated as output field for user space consumers.

Without proper API, umad module miss resolving destination mac
address while creating address handle.

Additionally mlx4 driver resolves incorrect mac address for v4 mapped
v6 destination multicast gid.

This patchset allows uverbs modules to invoke ib_core API that
resolves destination mac address for user consumers.

This patchset avoids above issues by ib_core resolving destination mac
address for roce for user as well as kernel consumers.
It uses ib_resolve_eth_dmac() API which resolves destination mac address
for unicast, multicast, v4 mapped v6 addresses, and also link local gid.
This eliminates code duplication in provider drivers and also brings
uniformity by always resolving dmac in ib_core for all type of GIDs.

This allows to eliminate exporting low level API ib_resolve_eth_dmac().
So its removed as export symbol until a good use case arise.

2) Three simple fixes for IB/core.
3) Patch for mlx5 posted to the mailing list.

Changelog:
 v0->v1: Added forgotten patch "IB/core: Introduce and use rdma_create_user_ah"

The patches are available in the git repository at:
  git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-next-2017-10-16

	Thanks
---------------------------------------

Jérémy Lefaure (1):
  IB/mlx5: Use ARRAY_SIZE

Parav Pandit (5):
  IB/core: Introduce and use rdma_create_user_ah
  IB: Let ib_core resolve destination mac address
  IB/core: Fix unable to change lifespan entry for hw_counters
  IB/core: Fix use workqueue without WQ_MEM_RECLAIM
  IB/core: Take into account optional UDR, XRC headers and mandatory
    ICRC for RoCE MTU

 drivers/infiniband/core/addr.c           |  2 +-
 drivers/infiniband/core/sysfs.c          | 16 ++++++++++-
 drivers/infiniband/core/user_mad.c       |  2 +-
 drivers/infiniband/core/uverbs_cmd.c     | 10 +------
 drivers/infiniband/core/verbs.c          | 48 ++++++++++++++++++++++++++++----
 drivers/infiniband/hw/bnxt_re/ib_verbs.c |  8 ------
 drivers/infiniband/hw/hns/hns_roce_ah.c  | 14 +---------
 drivers/infiniband/hw/mlx4/ah.c          |  8 ++----
 drivers/infiniband/hw/mlx5/ah.c          |  4 ---
 drivers/infiniband/hw/mlx5/odp.c         |  6 ++--
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c | 15 ----------
 include/rdma/ib_addr.h                   |  7 +++--
 include/rdma/ib_pack.h                   | 19 +++++++------
 include/rdma/ib_verbs.h                  | 17 +++++++++--
 14 files changed, 98 insertions(+), 78 deletions(-)

--
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
