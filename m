From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 0/5] Convert management helpers to Core Capability bits
Date: Mon, 11 May 2015 21:46:53 -0400
Message-ID: <1431395218-27693-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The following 5 patches complete the conversion of Michaels management helpers
to use new Core Capability bits to signal core capabilities rather than
inferring these capabilities from the device protocols.

The first fixes a bug which was uncovered after I changed the implementation of
rdma_cap_ib_mad

The second formalizes the creation of immutable per port data which is stored
in the ib_device structure for use by the core code.  This is accomplished by a
call back specified to ib_device_register.

The third converts the management helpers to use a new bit mask which is stored
in the immutable per port device data.  Comments to the RFC version of these
patches included using only 32 bits for this data although I am worried that
will quickly fill up with some of the proposed further cleanups.

The final 2 patches implement the OPA management helper additions which spurred
these architectural changes.  They are reworked versions of previous patches
submitted under the OPA MAD change series.

These all apply on top of Dougs for-4.1 with Michaels v8 management helper
patches.


Ira Weiny (5):
  IB/user_mad: Fix bug in ib_umad_remove_one when rdma_cap_ib_mad
    implementation changed
  IB/core: Formalize the creation of immutable per port data within the
    ib_device object
  IB/core: Convert management helpers to core capability bits
  IB/core: Add rdma_dev_max_mad_size helper call
  IB/core: Add rdma_cap_opa_mad helper using RDMA_CORE_CAP_OPA_MAD flag

 drivers/infiniband/core/device.c             |  57 ++++++-------
 drivers/infiniband/core/mad.c                |   4 +
 drivers/infiniband/core/user_mad.c           |  13 ++-
 drivers/infiniband/hw/amso1100/c2_provider.c |  29 +++++--
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |  29 +++++--
 drivers/infiniband/hw/cxgb4/provider.c       |  29 +++++--
 drivers/infiniband/hw/ehca/ehca_hca.c        |   9 +-
 drivers/infiniband/hw/ehca/ehca_main.c       |  22 ++++-
 drivers/infiniband/hw/ipath/ipath_verbs.c    |  29 +++++--
 drivers/infiniband/hw/mlx4/main.c            |  37 +++++---
 drivers/infiniband/hw/mlx5/main.c            |  29 +++++--
 drivers/infiniband/hw/mthca/mthca_provider.c |  29 +++++--
 drivers/infiniband/hw/nes/nes_verbs.c        |  30 +++++--
 drivers/infiniband/hw/ocrdma/ocrdma_main.c   |  24 +++++-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |   6 --
 drivers/infiniband/hw/qib/qib_verbs.c        |  30 +++++--
 drivers/infiniband/hw/usnic/usnic_ib_main.c  |  23 ++++-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c |   7 +-
 include/rdma/ib_mad.h                        |   1 +
 include/rdma/ib_verbs.h                      | 122 +++++++++++++++++++++++----
 20 files changed, 410 insertions(+), 149 deletions(-)

-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
