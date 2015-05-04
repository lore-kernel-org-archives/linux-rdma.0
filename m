From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [RFC PATCH 0/5] Add Core Capability Bits to use in Management helpers
Date: Mon,  4 May 2015 02:14:54 -0400
Message-ID: <1430720099-32512-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The following 5 patches use new Core Capability bits to signal core
capabilities rather than inferring these capabilities based on the protocols.

The first 3 are the beginning of converting Michaels patches over to a bit
mask.  Before converting all the functions I wanted to get consensus with a
smaller patch series.

In addition I have included the additional OPA flags which will be needed for
the OPA series to show how new support can be communicated.  If we are in
agreement then I can complete the series with an official submission.


Ira Weiny (5):
  IB/core: Add Core Capability flags to ib_device
  IB/core: Replace query_protocol callback with Core Capability flags
    check
  IB/core: Convert cap_ib_mad to core_cap_flags bit mask
  IB/core: Add rdma_dev_max_mad_size call
  IB/core: Add cap_opa_mad helper using RDMA_CORE_CAP_OPA_MAD flag

 drivers/infiniband/core/device.c             |   42 +++++++++++++++-
 drivers/infiniband/core/mad.c                |    4 ++
 drivers/infiniband/hw/amso1100/c2_provider.c |    8 +---
 drivers/infiniband/hw/amso1100/c2_rnic.c     |    1 +
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |    9 +---
 drivers/infiniband/hw/cxgb4/provider.c       |    9 +---
 drivers/infiniband/hw/ehca/ehca_hca.c        |   11 ++--
 drivers/infiniband/hw/ehca/ehca_main.c       |    1 -
 drivers/infiniband/hw/ipath/ipath_verbs.c    |    9 +---
 drivers/infiniband/hw/mlx4/main.c            |   14 ++----
 drivers/infiniband/hw/mlx5/main.c            |   10 +---
 drivers/infiniband/hw/mthca/mthca_provider.c |   10 +---
 drivers/infiniband/hw/nes/nes_verbs.c        |    9 +---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c   |    1 -
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |    8 +--
 drivers/infiniband/hw/qib/qib_verbs.c        |    9 +---
 drivers/infiniband/hw/usnic/usnic_ib_main.c  |    1 -
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c |    9 +--
 include/rdma/ib_mad.h                        |    1 +
 include/rdma/ib_verbs.h                      |   72 +++++++++++++++++++++++---
 20 files changed, 142 insertions(+), 96 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
