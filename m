From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 0/3] staging/rdma/hfi1: complete fixes for ECN detection
Date: Wed,  4 Nov 2015 21:10:08 -0500
Message-ID: <1446689411-22263-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The following 3 patches fix the ECN detection and add a module parameter to
turn the prescan of the receive queue on and off.

Arthur Kepner (2):
  staging/rdma/hfi1: don't cache "prescan head"
  staging/rdma/hfi1: optionally prescan rx queue for {B,F}ECNs - UC, RC

Vennila Megavannan (1):
  staging/rdma/hfi1: Method to toggle "fast ECN" detection

 drivers/staging/rdma/hfi1/Kconfig  |  14 ++---
 drivers/staging/rdma/hfi1/driver.c | 101 +++++++++++++++++++------------------
 drivers/staging/rdma/hfi1/hfi.h    |  13 -----
 drivers/staging/rdma/hfi1/rc.c     |  10 ++--
 drivers/staging/rdma/hfi1/uc.c     |  15 +++---
 drivers/staging/rdma/hfi1/verbs.c  |  41 ++++++++++++---
 6 files changed, 108 insertions(+), 86 deletions(-)

-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
