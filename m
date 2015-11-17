From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 08/13] staging/rdma/hfi1: change krcvqs module parameter type from byte to uint
Date: Mon, 16 Nov 2015 21:59:30 -0500
Message-ID: <1447729175-28745-9-git-send-email-jubin.john@intel.com>
References: <1447729175-28745-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447729175-28745-1-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Mark F. Brown <mark.f.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The krcvqs parameter is displayed incorrectly in sysfs.
The workaround is to set the param type as uint.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mark F. Brown <mark.f.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/hfi.h  |    2 +-
 drivers/staging/rdma/hfi1/init.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index fe751bb..a8a11da 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -1625,7 +1625,7 @@ extern unsigned int hfi1_cu;
 extern unsigned int user_credit_return_threshold;
 extern uint num_rcv_contexts;
 extern unsigned n_krcvqs;
-extern u8 krcvqs[];
+extern uint krcvqs[];
 extern int krcvqsset;
 extern uint kdeth_qp;
 extern uint loopback;
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index 3f5a409..7fa775a 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -87,9 +87,9 @@ module_param_named(num_rcv_contexts, num_rcv_contexts, uint, S_IRUGO);
 MODULE_PARM_DESC(
 	num_rcv_contexts, "Set max number of user receive contexts to use");
 
-u8 krcvqs[RXE_NUM_DATA_VL];
+uint krcvqs[RXE_NUM_DATA_VL];
 int krcvqsset;
-module_param_array(krcvqs, byte, &krcvqsset, S_IRUGO);
+module_param_array(krcvqs, uint, &krcvqsset, S_IRUGO);
 MODULE_PARM_DESC(krcvqs, "Array of the number of kernel receive queues by VL");
 
 /* computed based on above array */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
