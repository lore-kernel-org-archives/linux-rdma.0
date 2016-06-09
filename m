From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH net-next 4/7] RDMA/iw_cxgb4: Add missing error codes for act open cmd
Date: Fri, 10 Jun 2016 01:05:14 +0530
Message-ID: <1465500917-18491-5-git-send-email-hariprasad@chelsio.com>
References: <1465500917-18491-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465500917-18491-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c            | 11 ++++++++---
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h |  2 ++
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 25236fc7dc92..4819314ef510 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2016,12 +2016,17 @@ static int send_fw_act_open_req(struct c4iw_ep *ep, unsigned int atid)
 }
 
 /*
- * Return whether a failed active open has allocated a TID
+ * Some of the error codes above implicitly indicate that there is no TID
+ * allocated with the result of an ACT_OPEN.  We use this predicate to make
+ * that explicit.
  */
 static inline int act_open_has_tid(int status)
 {
-	return status != CPL_ERR_TCAM_FULL && status != CPL_ERR_CONN_EXIST &&
-	       status != CPL_ERR_ARP_MISS;
+	return (status != CPL_ERR_TCAM_PARITY &&
+		status != CPL_ERR_TCAM_MISS &&
+		status != CPL_ERR_TCAM_FULL &&
+		status != CPL_ERR_CONN_EXIST_SYNRECV &&
+		status != CPL_ERR_CONN_EXIST);
 }
 
 /* Returns whether a CPL status conveys negative advice.
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h b/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
index 4705e2dea423..e0ebe1378cb2 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
@@ -104,6 +104,8 @@ enum {
 
 enum CPL_error {
 	CPL_ERR_NONE               = 0,
+	CPL_ERR_TCAM_PARITY        = 1,
+	CPL_ERR_TCAM_MISS          = 2,
 	CPL_ERR_TCAM_FULL          = 3,
 	CPL_ERR_BAD_LENGTH         = 15,
 	CPL_ERR_BAD_ROUTE          = 18,
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
