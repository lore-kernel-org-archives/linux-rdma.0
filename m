From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V2 13/13] RDMA/bnxt_re: Fix the value reported for local ack delay
Date: Thu, 29 Jun 2017 12:28:19 -0700
Message-ID: <1498764499-24157-14-git-send-email-selvin.xavier@broadcom.com>
References: <1498764499-24157-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498764499-24157-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Local ack delay exposed by the driver is 0 which means infinite QP
timeout. Reporting the default value to 16 (approx 260ms)

Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/bnxt_re.h  | 7 +++++++
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/bnxt_re.h b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
index 30bff05..c1c9e62 100644
--- a/drivers/infiniband/hw/bnxt_re/bnxt_re.h
+++ b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
@@ -62,6 +62,13 @@
 
 #define BNXT_RE_RQ_WQE_THRESHOLD	32
 
+/*
+ * Setting the default ack delay value to 16, which means
+ * the default timeout is approx. 260ms(4 usec * 2 ^(timeout))
+ */
+
+#define BNXT_RE_DEFAULT_ACK_DELAY	16
+
 struct bnxt_re_work {
 	struct work_struct	work;
 	unsigned long		event;
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 2cfcd38..1eff59d 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -201,7 +201,7 @@ int bnxt_re_query_device(struct ib_device *ibdev,
 	ib_attr->max_fast_reg_page_list_len = MAX_PBL_LVL_1_PGS;
 
 	ib_attr->max_pkeys = 1;
-	ib_attr->local_ca_ack_delay = 0;
+	ib_attr->local_ca_ack_delay = BNXT_RE_DEFAULT_ACK_DELAY;
 	return 0;
 }
 
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
