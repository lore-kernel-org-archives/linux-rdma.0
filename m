From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V1 0/9] Add RoCE v2 support
Date: Thu, 15 Oct 2015 19:07:03 +0300
Message-ID: <1444925232-13598-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This series adds the support for RoCE v2. In order to support RoCE v2,
we add gid_type attribute to every GID. When the RoCE GID management
populates the GID table, it duplicates each GID with all supported types.
This gives the user the ability to communicate over each supported
type.

Patch 0001, 0002 and 0003 add support for multiple GID types to the
cache and related APIs. The third patch exposes the GID attributes
information is sysfs.

Patch 0004 adds the RoCE v2 GID type and the capabilities required
from the vendor in order to implement RoCE v2. These capabilities
are grouped together as RDMA_CORE_PORT_IBA_ROCE_UDP_ENCAP.

RoCE v2 could work at IPv4 and IPv6 networks. When receiving ib_wc, this
information should come from the vendor's driver. In case the vendor
doesn't supply this information, we parse the packet headers and resolve
its network type. Patch 0005 adds this information and required utilities.

Patches 0006 and 0007 add configfs support (and the required
infrastructure) for CMA. The administrator should be able to set the
default RoCE type. This is done through a new per-port
default_roce_mode configfs file.

Patch 0008 formats a QP1 packet in order to support RoCE v2 CM
packets. This is required for vendors which implement their
QP1 as a Raw QP.

Patch 0009 adds support for IPv4 multicast as an IPv4 network
requires IGMP to be sent in order to join multicast groups.

Vendors code aren't part of this patch-set. Soft-Roce will be
sent soon and depends on these patches. Other vendors, like
mlx4, ocrdma and mlx5 will follow.

This patch is applied on "Add RoCE GID cache usage in verbs/cma"
which was sent to the mailing list.

Thanks,
Matan

Changes from V0:
 - Rebased patches against Doug's latest k.o/for-4.4 tree.
 - Fixed a bug in configfs (rmdir caused an incorrect free).

Matan Barak (6):
  IB/core: Add gid_type to gid attribute
  IB/cm: Use the source GID index type
  IB/core: Add gid attributes to sysfs
  IB/core: Add ROCE_UDP_ENCAP (RoCE V2) type
  IB/rdma_cm: Add wrapper for cma reference count
  IB/cma: Add configfs for rdma_cm

Moni Shoua (2):
  IB/core: Initialize UD header structure with IP and UDP headers
  IB/cma: Join and leave multicast groups with IGMP

Somnath Kotur (1):
  IB/core: Add rdma_network_type to wc

 drivers/infiniband/Kconfig                |   9 +
 drivers/infiniband/core/Makefile          |   2 +
 drivers/infiniband/core/addr.c            |  14 ++
 drivers/infiniband/core/cache.c           | 156 +++++++++----
 drivers/infiniband/core/cm.c              |  25 ++-
 drivers/infiniband/core/cma.c             | 216 ++++++++++++++++--
 drivers/infiniband/core/cma_configfs.c    | 353 ++++++++++++++++++++++++++++++
 drivers/infiniband/core/core_priv.h       |  32 +++
 drivers/infiniband/core/device.c          |  10 +-
 drivers/infiniband/core/multicast.c       |  20 +-
 drivers/infiniband/core/roce_gid_mgmt.c   |  61 +++++-
 drivers/infiniband/core/sa_query.c        |   5 +-
 drivers/infiniband/core/sysfs.c           | 184 +++++++++++++++-
 drivers/infiniband/core/ud_header.c       | 155 ++++++++++++-
 drivers/infiniband/core/uverbs_marshall.c |   1 +
 drivers/infiniband/core/verbs.c           | 124 ++++++++++-
 drivers/infiniband/hw/mlx4/qp.c           |   7 +-
 drivers/infiniband/hw/mthca/mthca_qp.c    |   2 +-
 include/rdma/ib_addr.h                    |   1 +
 include/rdma/ib_cache.h                   |   4 +
 include/rdma/ib_pack.h                    |  45 +++-
 include/rdma/ib_sa.h                      |   4 +
 include/rdma/ib_verbs.h                   |  78 ++++++-
 23 files changed, 1402 insertions(+), 106 deletions(-)
 create mode 100644 drivers/infiniband/core/cma_configfs.c

-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
