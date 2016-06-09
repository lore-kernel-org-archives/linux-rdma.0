From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 0/7] RDMA/iw_cxgb4: Misc. fixes cleanup and low resource fixes
Date: Fri, 10 Jun 2016 01:05:10 +0530
Message-ID: <1465500917-18491-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi

This patch series add low resource fixes for connection management,
memory registration and for completion queue teardown. Cleans up
c4iw_reject_cr function, allocates enough space for debugfs qps dump so
IPv6 address doesn't get truncated, also adds missing error codes for
active open CPL command. Atlast read module parameter markers_enabled,
should be read only only once, so that the value remains the same
throughout MPA negotiaion.

This patch series has been created against Doug Ledford's linux tree,
"for-4.7-topics/cxgb4-2" branch and includes patches on iw_cxgb4 driver.

We have included all the maintainers of respective drivers. Kindly review
the change and let us know in case of any review comments.

Thanks

Hariprasad Shenai (7):
  RDMA/iw_cxgb4: markers_enabled module parameter should be read only
    once
  RDMA/iw_cxgb4: allocate enough space for debugfs "qps" dump
  RDMA/iw_cxgb4: clean up c4iw_reject_cr()
  RDMA/iw_cxgb4: Add missing error codes for act open cmd
  RDMA/iw_cxgb4: Low resource fixes for connection manager
  RDMA/iw_cxgb4: Low resource fixes for Memory registration
  RDMA/iw_cxgb4: Low resource fixes for Completion queue

 drivers/infiniband/hw/cxgb4/cm.c            | 187 ++++++++++++++++++----------
 drivers/infiniband/hw/cxgb4/cq.c            |  42 ++++---
 drivers/infiniband/hw/cxgb4/device.c        |   2 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h      |  22 ++++
 drivers/infiniband/hw/cxgb4/mem.c           | 107 ++++++++++------
 drivers/infiniband/hw/cxgb4/qp.c            |  12 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h |   2 +
 7 files changed, 250 insertions(+), 124 deletions(-)

-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
