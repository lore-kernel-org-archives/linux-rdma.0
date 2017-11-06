From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/4] bnxt_re: Bug fixes
Date: Mon,  6 Nov 2017 08:07:28 -0800
Message-ID: <1509984452-18336-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Includes few bug fixes for bnxt_re. Adds memory barriers before
processing the HW completions and fixes race conditoins
in QP destroy path.

Doug,
 Please apply.

Thanks,
Selvin Xavier

Selvin Xavier (3):
  RDMA/bnxt_re: Set QP state in case of response completion errors
  RDMA/bnxt_re: Flush CQ notification Work Queue before destroying QP
  RDMA/bnxt_re: synchronize poll_cq and req_notify_cq verbs

Somnath Kotur (1):
  RDMA/bnxt_re: Add memory barriers when processing CQ/EQ entries

 drivers/infiniband/hw/bnxt_re/ib_verbs.c   | 16 ++++++++++-----
 drivers/infiniband/hw/bnxt_re/qplib_fp.c   | 31 ++++++++++++++++++++++++++++++
 drivers/infiniband/hw/bnxt_re/qplib_fp.h   |  1 +
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c |  4 ++++
 4 files changed, 47 insertions(+), 5 deletions(-)

-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
