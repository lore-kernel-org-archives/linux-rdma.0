From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 0/5] Convert management helpers to Core Capability bits
Date: Wed, 13 May 2015 20:02:54 -0400
Message-ID: <1431561779-13714-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The following 5 patches complete the conversion of Michaels management helpers
to use new Core Capability bits to signal core capabilities rather than
inferring these capabilities from the device protocols.

The first makes the start_port and end_port functions common rather than being
declared in 2 places.

The second uses the start and end port common functions (rather than declaring
yet another copy of them) in the user_mad code.

The third fixes a bug which was uncovered after I changed the implementation of
rdma_cap_ib_mad and utilizes the first 2 patches.

The forth formalizes the creation of immutable per port data which is stored
in the ib_device structure for use by the core code.  This is now accomplished by a
new mandatory device function.

The fifth converts the management helpers to use a new bit mask which is stored
in the immutable per port device data.

The 2 OPA patches have been removed at Hals request and will be submitted as
part of a new OPA MAD series.


Ira Weiny (5):
  IB/core: Create common start/end port functions
  IB/user_mad: Remove local start/end port variable and use the new
    common functions
  IB/user_mad: Fix bug in ib_umad_remove_one when rdma_cap_ib_mad
    implementation changed
  IB/core: Formalize the creation of immutable per port data within the
    ib_device object
  IB/core: Convert management helpers to core capability bits

 drivers/infiniband/core/cache.c              |  61 ++++++---------
 drivers/infiniband/core/device.c             |  82 ++++++++------------
 drivers/infiniband/core/sysfs.c              |   1 +
 drivers/infiniband/core/user_mad.c           |  16 +---
 drivers/infiniband/hw/amso1100/c2_provider.c |  25 ++++--
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |  25 ++++--
 drivers/infiniband/hw/cxgb4/provider.c       |  25 ++++--
 drivers/infiniband/hw/ehca/ehca_hca.c        |   6 --
 drivers/infiniband/hw/ehca/ehca_main.c       |  19 ++++-
 drivers/infiniband/hw/ipath/ipath_verbs.c    |  25 ++++--
 drivers/infiniband/hw/mlx4/main.c            |  32 +++++---
 drivers/infiniband/hw/mlx5/main.c            |  25 ++++--
 drivers/infiniband/hw/mthca/mthca_provider.c |  25 ++++--
 drivers/infiniband/hw/nes/nes_verbs.c        |  24 ++++--
 drivers/infiniband/hw/ocrdma/ocrdma_main.c   |  19 ++++-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |   6 --
 drivers/infiniband/hw/qib/qib_verbs.c        |  25 ++++--
 drivers/infiniband/hw/usnic/usnic_ib_main.c  |  18 ++++-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c |   6 --
 include/rdma/ib_verbs.h                      | 110 ++++++++++++++++++++++-----
 20 files changed, 371 insertions(+), 204 deletions(-)

-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
