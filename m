From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 0/2] staging/rdma/hfi1: Miscellaneous Fixes
Date: Mon,  9 Nov 2015 19:18:19 -0500
Message-ID: <1447114701-11003-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Updated these 2 patches based on feedback received.

Changes in v2:
	- Removed volatile for receive context tail dummy address
	- Removed unlikely() in sdma_select_engine_vl()

Ira Weiny (1):
  staging/rdma/hfi1: Eliminate WARN_ON when VL is invalid

Mark F. Brown (1):
  staging/rdma/hfi1: Workaround to prevent corruption during packet
    delivery

 drivers/staging/rdma/hfi1/chip.c |   18 +++++++++++++++---
 drivers/staging/rdma/hfi1/hfi.h  |    4 ++++
 drivers/staging/rdma/hfi1/init.c |   28 ++++++++++++++++++++++++++++
 drivers/staging/rdma/hfi1/sdma.c |   12 ++++++++++--
 4 files changed, 57 insertions(+), 5 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
