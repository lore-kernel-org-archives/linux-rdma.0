From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/3] staging/rdma/hfi1: Fix module parameter spelling
Date: Thu, 17 Dec 2015 19:24:14 -0500
Message-ID: <1450398255-10346-2-git-send-email-jubin.john@intel.com>
References: <1450398255-10346-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450398255-10346-1-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fix the spelling of user_credit_return_threshold, it was incorrectly
spelled as user_credit_return_theshold causing two module parameters,
one with typo, to be shown in modinfo

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index 1c8286f..8f13d53 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -113,7 +113,7 @@ MODULE_PARM_DESC(hdrq_entsize, "Size of header queue entries: 2 - 8B, 16 - 64B (
 
 unsigned int user_credit_return_threshold = 33;	/* default is 33% */
 module_param(user_credit_return_threshold, uint, S_IRUGO);
-MODULE_PARM_DESC(user_credit_return_theshold, "Credit return threshold for user send contexts, return when unreturned credits passes this many blocks (in percent of allocated blocks, 0 is off)");
+MODULE_PARM_DESC(user_credit_return_threshold, "Credit return threshold for user send contexts, return when unreturned credits passes this many blocks (in percent of allocated blocks, 0 is off)");
 
 static inline u64 encode_rcv_header_entry_size(u16);
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
