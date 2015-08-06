From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 00/22] iser patches for 4.3
Date: Thu,  6 Aug 2015 18:32:44 +0300
Message-ID: <1438875186-4310-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This set is a resend that includes some extra patches that
piled up in the meantime.

I still have some patches in the pipe (including initiator/target
support for remote invalidate) but I'm targeting those to 4.4

I postponed the comment from Steve on using system PAGE_SIZE
in patch 20 until I have access to a relevant arch to test on.

This patch set includes:
- Small fixes for bugs encountered in testing
- Small fixes detected by static checkers
- Memory registration code path rework (consolidate to
  a single code path that branches only at the actual registration
  FRWR vs. FMR). This reduces code duplication that exists in current code.
- Larger IO transfer size support (up to 8MB at the moment) depending on
  the device capabilities.
- Optimize Io path by chaining send work requests and posting them
  only once.

Changes from v0:
- Added Fixes: tags to patches 4,6
- Modified change logs for patche 20,22 to add some more details
  (comments from Or)

Adir Lev (1):
  IB/iser: Maintain connection fmr_pool under a single registration
    descriptor

Jenny Falkovich (1):
  IB/iser: Change some module parameters to be RO

Sagi Grimberg (20):
  IB/iser: Change minor assignments and logging prints
  IB/iser: Remove '.' from log message
  IB/iser: Fix missing return status check in iser_send_data_out
  IB/iser: Get rid of un-maintained counters
  IB/iser: Fix possible bogus DMA unmapping
  IB/iser: Remove a redundant always-false condition
  IB/iser: Remove an unneeded print for unaligned memory
  IB/iser: Introduce struct iser_reg_resources
  IB/iser: Rename struct fast_reg_descriptor -> iser_fr_desc
  IB/iser: Remove dead code in fmr_pool alloc/free
  IB/iser: Introduce iser_reg_ops
  IB/iser: Move fastreg descriptor allocation to
    iser_create_fastreg_desc
  IB/iser: Introduce iser registration pool struct
  IB/iser: Rename iser_reg_page_vec to iser_fast_reg_fmr
  IB/iser: Make reg_desc_get a per device routine
  IB/iser: Unify fast memory registration flows
  IB/iser: Pass registration pool a size parameter
  IB/iser: Support up to 8MB data transfer in a single command
  IB/iser: Add debug prints to the various memory registration methods
  IB/iser: Chain all iser transaction send work requests

 drivers/infiniband/ulp/iser/iscsi_iser.c     |  89 +++--
 drivers/infiniband/ulp/iser/iscsi_iser.h     | 206 ++++++++----
 drivers/infiniband/ulp/iser/iser_initiator.c |  34 +-
 drivers/infiniband/ulp/iser/iser_memory.c    | 480 +++++++++++++++------------
 drivers/infiniband/ulp/iser/iser_verbs.c     | 328 ++++++++++--------
 5 files changed, 645 insertions(+), 492 deletions(-)

-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
