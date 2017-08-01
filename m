From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [pull request][rdma-next 00/33] RDMA netlink refactoring and RDMAtool code
Date: Tue,  1 Aug 2017 15:05:03 +0300
Message-ID: <20170801120536.540-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Latest code drop with fixed LMC name (LID mask control).

----------------------------------------------------------------
The following changes since commit 913cc67159bc85a96d94df301ca39c1b2c540dca:

  IB/hfi1: Always perform offline transition (2017-07-31 15:18:38 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-next-2017-08-01

for you to fetch changes up to 76bed394b018e89cc0a7d69a2c724655a1506c2c:

  RDMA/netlink: Export node_type (2017-08-01 14:22:50 +0300)

----------------------------------------------------------------
RDMA netlink refactoring and RDMAtool code

----------------------------------------------------------------
Leon Romanovsky (33):
      Revert "IB/core: Add flow control to the portmapper netlink calls"
      RDMA/netlink: Remove netlink clients infrastructure
      RDMA/netlink: Remove redundant owner option for netlink callbacks
      RDMA/netlink: Avoid double pass for RDMA netlink messages
      RDMA/iwcm: Remove useless check of nelink client validity
      RDMA/iwcm: Remove extra EXPORT_SYMBOLS
      RDMA/netlink: Add flag to consolidate common handing
      RDMA/netlink: Simplify the put_msg and put_attr
      RDMA/netlink: Rename and remove redundant parameter from ibnl_unicast
      RDMA/netlink: Rename and remove redundant parameter from ibnl_multicast
      RDMA/netlink: Simplify and rename ibnl_chk_listeners
      RDMA/netlink: Rename netlink callback struct
      RDMA/core: Add iterator over ib_devices
      RDMA/core: Add and expose static device index
      RDMA/netlink: Add and implement doit netlink callback
      RDMA/netlink: Reduce indirection access to cb_table
      RDMA/netlink: Convert LS to doit callback
      RDMA/netlink: Update copyright
      RDMA/netlink: Add netlink device definitions to UAPI
      RDMA/netlink: Add nldev initialization flows
      RDMA/netlink: Implement nldev device dumpit calback
      RDMA/netlink: Add nldev device doit implementation
      RDMA/netlink: Add nldev port dumpit implementation
      RDMA/netlink: Implement nldev port doit callback
      RDMA/netlink: Expose device and port capability masks
      RDMA: Simplify get firmware interface
      RDMA/netlink: Export FW version
      RDMA/netlink: Export node_guid and sys_image_guid
      RDMA/netlink: Advertise IB subnet prefix
      RDMA/netink: Export lids and sm_lids
      RDMA/netlink: Export LID mask control (LMC)
      RDMA/netlink: Provide port state and physical link state
      RDMA/netlink: Export node_type

 drivers/infiniband/core/Makefile               |   3 +-
 drivers/infiniband/core/addr.c                 |  12 +-
 drivers/infiniband/core/cma.c                  |  11 +-
 drivers/infiniband/core/core_priv.h            |  26 ++-
 drivers/infiniband/core/device.c               | 119 +++++++---
 drivers/infiniband/core/iwcm.c                 |  12 +-
 drivers/infiniband/core/iwpm_msg.c             |  20 +-
 drivers/infiniband/core/iwpm_util.c            |  15 +-
 drivers/infiniband/core/netlink.c              | 310 ++++++++++++------------
 drivers/infiniband/core/nldev.c                | 312 +++++++++++++++++++++++++
 drivers/infiniband/core/sa_query.c             |  18 +-
 drivers/infiniband/core/sysfs.c                |   4 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c    |   5 +-
 drivers/infiniband/hw/cxgb4/provider.c         |   5 +-
 drivers/infiniband/hw/hfi1/verbs.c             |   5 +-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c      |   7 +-
 drivers/infiniband/hw/mlx4/main.c              |   5 +-
 drivers/infiniband/hw/mlx5/main.c              |   8 +-
 drivers/infiniband/hw/mthca/mthca_provider.c   |   5 +-
 drivers/infiniband/hw/nes/nes_verbs.c          |   5 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c     |   5 +-
 drivers/infiniband/hw/qedr/main.c              |   5 +-
 drivers/infiniband/hw/usnic/usnic_ib_main.c    |   6 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c |   5 +-
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c   |   3 +-
 include/rdma/ib_verbs.h                        |   8 +-
 include/rdma/rdma_netlink.h                    |  38 +--
 include/uapi/rdma/rdma_netlink.h               |  84 ++++++-
 28 files changed, 743 insertions(+), 318 deletions(-)
 create mode 100644 drivers/infiniband/core/nldev.c
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
