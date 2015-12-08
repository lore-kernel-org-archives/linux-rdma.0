From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v2 0/5] Clean up SDMA engine code
Date: Tue,  8 Dec 2015 17:10:08 -0500
Message-ID: <1449612613-6616-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Various improvements to the SDMA engine code.

---
Changes from V1:
	Fix off by one error in the last patch

Mitko Haralanov (5):
  staging/rdma/hfi1: Convert to use get_user_pages_fast
  staging/rdma/hfi1: Unconditionally clean-up SDMA queues
  staging/rdma/hfi1: Clean-up unnecessary goto statements
  staging/rdma/hfi1: Detect SDMA transmission error early
  staging/rdma/hfi1: Add page lock limit check for SDMA requests

 drivers/staging/rdma/hfi1/file_ops.c   |  11 +-
 drivers/staging/rdma/hfi1/hfi.h        |   4 +-
 drivers/staging/rdma/hfi1/user_pages.c |  97 +++-------
 drivers/staging/rdma/hfi1/user_sdma.c  | 319 +++++++++++++++++++--------------
 drivers/staging/rdma/hfi1/user_sdma.h  |   2 +
 5 files changed, 222 insertions(+), 211 deletions(-)

-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
