From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-4.1 0/2] Adds support for user mode bar2 mapping and bar2 qid density
Date: Tue,  9 Jun 2015 18:23:10 +0530
Message-ID: <1433854392-6531-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

This patch series adds support for user mode bar2 mappings for T4 adapter
and also adds  support for bar2 qid densities exceeding page size.

This patch series has been created against Doug's github tree 'for-4.1'
branch and includes patches on cxgb4 and iw_cxgb4 driver.

We have included all the maintainers of respective drivers. Kindly review
the change and let us know in case of any review comments.

Thanks

Hariprasad Shenai (2):
  cxgb4: Support for user mode bar2 mappings with T4
  iw_cxgb4: support for bar2 qid densities exceeding the page size

 drivers/infiniband/hw/cxgb4/cq.c                | 22 ++++-----
 drivers/infiniband/hw/cxgb4/device.c            | 16 ++-----
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h          |  5 +-
 drivers/infiniband/hw/cxgb4/qp.c                | 64 ++++++++++++++++---------
 drivers/infiniband/hw/cxgb4/t4.h                | 60 +++++++++++++++--------
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h      |  1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c |  4 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h  |  1 +
 drivers/net/ethernet/chelsio/cxgb4/sge.c        |  4 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c      |  7 +--
 10 files changed, 109 insertions(+), 75 deletions(-)

-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
