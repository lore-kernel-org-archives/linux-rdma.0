From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-4.1 1/2] cxgb4: Support for user mode bar2 mappings with T4
Date: Tue,  9 Jun 2015 18:23:11 +0530
Message-ID: <1433854392-6531-2-git-send-email-hariprasad@chelsio.com>
References: <1433854392-6531-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433854392-6531-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Enhance cxgb4_t4_bar2_sge_qregs() and cxgb4_bar2_sge_qregs() to support T4
user mode mappings.  Update all the current users as well.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h      | 1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 4 +++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h  | 1 +
 drivers/net/ethernet/chelsio/cxgb4/sge.c        | 4 ++--
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c      | 7 ++++---
 5 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 524d110..e052f05 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -1185,6 +1185,7 @@ enum t4_bar2_qtype { T4_BAR2_QTYPE_EGRESS, T4_BAR2_QTYPE_INGRESS };
 int cxgb4_t4_bar2_sge_qregs(struct adapter *adapter,
 		      unsigned int qid,
 		      enum t4_bar2_qtype qtype,
+		      int user,
 		      u64 *pbar2_qoffset,
 		      unsigned int *pbar2_qid);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 803d91b..a935559 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -2145,6 +2145,7 @@ EXPORT_SYMBOL(cxgb4_read_sge_timestamp);
 int cxgb4_bar2_sge_qregs(struct net_device *dev,
 			 unsigned int qid,
 			 enum cxgb4_bar2_qtype qtype,
+			 int user,
 			 u64 *pbar2_qoffset,
 			 unsigned int *pbar2_qid)
 {
@@ -2153,6 +2154,7 @@ int cxgb4_bar2_sge_qregs(struct net_device *dev,
 				 (qtype == CXGB4_BAR2_QTYPE_EGRESS
 				  ? T4_BAR2_QTYPE_EGRESS
 				  : T4_BAR2_QTYPE_INGRESS),
+				 user,
 				 pbar2_qoffset,
 				 pbar2_qid);
 }
@@ -2351,7 +2353,7 @@ static void process_db_drop(struct work_struct *work)
 		int ret;
 
 		ret = cxgb4_t4_bar2_sge_qregs(adap, qid, T4_BAR2_QTYPE_EGRESS,
-					&bar2_qoffset, &bar2_qid);
+					      0, &bar2_qoffset, &bar2_qid);
 		if (ret)
 			dev_err(adap->pdev_dev, "doorbell drop recovery: "
 				"qid=%d, pidx_inc=%d\n", qid, pidx_inc);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
index 78ab4d4..e33934a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
@@ -306,6 +306,7 @@ enum cxgb4_bar2_qtype { CXGB4_BAR2_QTYPE_EGRESS, CXGB4_BAR2_QTYPE_INGRESS };
 int cxgb4_bar2_sge_qregs(struct net_device *dev,
 			 unsigned int qid,
 			 enum cxgb4_bar2_qtype qtype,
+			 int user,
 			 u64 *pbar2_qoffset,
 			 unsigned int *pbar2_qid);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index 0d2edda..1b99aec 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -2429,8 +2429,8 @@ static void __iomem *bar2_address(struct adapter *adapter,
 	u64 bar2_qoffset;
 	int ret;
 
-	ret = cxgb4_t4_bar2_sge_qregs(adapter, qid, qtype,
-				&bar2_qoffset, pbar2_qid);
+	ret = cxgb4_t4_bar2_sge_qregs(adapter, qid, qtype, 0,
+				      &bar2_qoffset, pbar2_qid);
 	if (ret)
 		return NULL;
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 5959e3a..2d76a07 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -5102,6 +5102,7 @@ int t4_prep_adapter(struct adapter *adapter)
  *	@adapter: the adapter
  *	@qid: the Queue ID
  *	@qtype: the Ingress or Egress type for @qid
+ *	@user: true if this request is for a user mode queue
  *	@pbar2_qoffset: BAR2 Queue Offset
  *	@pbar2_qid: BAR2 Queue ID or 0 for Queue ID inferred SGE Queues
  *
@@ -5125,6 +5126,7 @@ int t4_prep_adapter(struct adapter *adapter)
 int cxgb4_t4_bar2_sge_qregs(struct adapter *adapter,
 		      unsigned int qid,
 		      enum t4_bar2_qtype qtype,
+		      int user,
 		      u64 *pbar2_qoffset,
 		      unsigned int *pbar2_qid)
 {
@@ -5132,9 +5134,8 @@ int cxgb4_t4_bar2_sge_qregs(struct adapter *adapter,
 	u64 bar2_page_offset, bar2_qoffset;
 	unsigned int bar2_qid, bar2_qid_offset, bar2_qinferred;
 
-	/* T4 doesn't support BAR2 SGE Queue registers.
-	 */
-	if (is_t4(adapter->params.chip))
+	/* T4 doesn't support BAR2 SGE Queue registers for kernel mode queues */
+	if (!user && is_t4(adapter->params.chip))
 		return -EINVAL;
 
 	/* Get our SGE Page Size parameters.
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
