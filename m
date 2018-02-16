From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-rc 0/6] RDMA/bnxt_re: Misc bug fixes
Date: Thu, 15 Feb 2018 21:20:07 -0800
Message-ID: <1518758413-20850-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This series includes some of the bug fixes for bnxt_re driver.
Please consider this for rc.

Thanks,
Selvin Xavier

Devesh Sharma (2):
  RDMA/bnxt_re: Disable atomic capability on bnxt_re adapters
  RDMA/bnxt_re: Unpin SQ and RQ memory if QP create fails

Selvin Xavier (4):
  RDMA/bnxt_re: Maintain GID index mapping between stack and hardware
  RDMA/bnxt_re: Synchronize destroy_qp with poll_cq
  RDMA/bnxt_re: Fix system crash during load/unload
  RDMA/bnxt_re: Avoid system hang during device un-reg

 drivers/infiniband/hw/bnxt_re/bnxt_re.h  |  5 ++-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 75 ++++++++++++++++++++++++--------
 drivers/infiniband/hw/bnxt_re/ib_verbs.h |  2 +
 drivers/infiniband/hw/bnxt_re/main.c     | 25 +++++++++--
 drivers/infiniband/hw/bnxt_re/qplib_fp.c | 21 +++------
 drivers/infiniband/hw/bnxt_re/qplib_fp.h |  4 +-
 drivers/infiniband/hw/bnxt_re/qplib_sp.c | 14 +-----
 7 files changed, 93 insertions(+), 53 deletions(-)

-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
