From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 05/14] IB/mad: Add helper function for smi_handle_dr_smp_recv
Date: Wed, 20 May 2015 04:13:26 -0400
Message-ID: <1432109615-19564-6-git-send-email-ira.weiny@intel.com>
References: <1432109615-19564-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432109615-19564-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This helper function will be used later for processing both IB and OPA SMP
recvs.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/smi.c | 80 +++++++++++++++++++++++++------------------
 1 file changed, 47 insertions(+), 33 deletions(-)

diff --git a/drivers/infiniband/core/smi.c b/drivers/infiniband/core/smi.c
index 4115b0979377..b09fa1dec865 100644
--- a/drivers/infiniband/core/smi.c
+++ b/drivers/infiniband/core/smi.c
@@ -137,91 +137,105 @@ enum smi_action smi_handle_dr_smp_send(struct ib_smp *smp,
 					smp->dr_slid == IB_LID_PERMISSIVE);
 }
 
-/*
- * Adjust information for a received SMP
- * Return IB_SMI_DISCARD if the SMP should be dropped
- */
-enum smi_action smi_handle_dr_smp_recv(struct ib_smp *smp, u8 node_type,
-				       int port_num, int phys_port_cnt)
+static inline
+enum smi_action __smi_handle_dr_smp_recv(u8 node_type, int port_num,
+					 int phys_port_cnt,
+					 u8 *hop_ptr, u8 hop_cnt,
+					 u8 *initial_path,
+					 u8 *return_path,
+					 u8 direction,
+					 int dr_dlid_is_permissive,
+					 int dr_slid_is_permissive)
 {
-	u8 hop_ptr, hop_cnt;
-
-	hop_ptr = smp->hop_ptr;
-	hop_cnt = smp->hop_cnt;
-
 	/* See section 14.2.2.2, Vol 1 IB spec */
 	/* C14-6 -- valid hop_cnt values are from 0 to 63 */
 	if (hop_cnt >= IB_SMP_MAX_PATH_HOPS)
 		return IB_SMI_DISCARD;
 
-	if (!ib_get_smp_direction(smp)) {
+	if (!direction) {
 		/* C14-9:1 -- sender should have incremented hop_ptr */
-		if (hop_cnt && hop_ptr == 0)
+		if (hop_cnt && *hop_ptr == 0)
 			return IB_SMI_DISCARD;
 
 		/* C14-9:2 -- intermediate hop */
-		if (hop_ptr && hop_ptr < hop_cnt) {
+		if (*hop_ptr && *hop_ptr < hop_cnt) {
 			if (node_type != RDMA_NODE_IB_SWITCH)
 				return IB_SMI_DISCARD;
 
-			smp->return_path[hop_ptr] = port_num;
-			/* smp->hop_ptr updated when sending */
-			return (smp->initial_path[hop_ptr+1] <= phys_port_cnt ?
+			return_path[*hop_ptr] = port_num;
+			/* hop_ptr updated when sending */
+			return (initial_path[*hop_ptr+1] <= phys_port_cnt ?
 				IB_SMI_HANDLE : IB_SMI_DISCARD);
 		}
 
 		/* C14-9:3 -- We're at the end of the DR segment of path */
-		if (hop_ptr == hop_cnt) {
+		if (*hop_ptr == hop_cnt) {
 			if (hop_cnt)
-				smp->return_path[hop_ptr] = port_num;
-			/* smp->hop_ptr updated when sending */
+				return_path[*hop_ptr] = port_num;
+			/* hop_ptr updated when sending */
 
 			return (node_type == RDMA_NODE_IB_SWITCH ||
-				smp->dr_dlid == IB_LID_PERMISSIVE ?
+				dr_dlid_is_permissive ?
 				IB_SMI_HANDLE : IB_SMI_DISCARD);
 		}
 
 		/* C14-9:4 -- hop_ptr = hop_cnt + 1 -> give to SMA/SM */
 		/* C14-9:5 -- fail unreasonable hop pointer */
-		return (hop_ptr == hop_cnt + 1 ? IB_SMI_HANDLE : IB_SMI_DISCARD);
+		return (*hop_ptr == hop_cnt + 1 ? IB_SMI_HANDLE : IB_SMI_DISCARD);
 
 	} else {
 
 		/* C14-13:1 */
-		if (hop_cnt && hop_ptr == hop_cnt + 1) {
-			smp->hop_ptr--;
-			return (smp->return_path[smp->hop_ptr] ==
+		if (hop_cnt && *hop_ptr == hop_cnt + 1) {
+			(*hop_ptr)--;
+			return (return_path[*hop_ptr] ==
 				port_num ? IB_SMI_HANDLE : IB_SMI_DISCARD);
 		}
 
 		/* C14-13:2 */
-		if (2 <= hop_ptr && hop_ptr <= hop_cnt) {
+		if (2 <= *hop_ptr && *hop_ptr <= hop_cnt) {
 			if (node_type != RDMA_NODE_IB_SWITCH)
 				return IB_SMI_DISCARD;
 
-			/* smp->hop_ptr updated when sending */
-			return (smp->return_path[hop_ptr-1] <= phys_port_cnt ?
+			/* hop_ptr updated when sending */
+			return (return_path[*hop_ptr-1] <= phys_port_cnt ?
 				IB_SMI_HANDLE : IB_SMI_DISCARD);
 		}
 
 		/* C14-13:3 -- We're at the end of the DR segment of path */
-		if (hop_ptr == 1) {
-			if (smp->dr_slid == IB_LID_PERMISSIVE) {
+		if (*hop_ptr == 1) {
+			if (dr_slid_is_permissive) {
 				/* giving SMP to SM - update hop_ptr */
-				smp->hop_ptr--;
+				(*hop_ptr)--;
 				return IB_SMI_HANDLE;
 			}
-			/* smp->hop_ptr updated when sending */
+			/* hop_ptr updated when sending */
 			return (node_type == RDMA_NODE_IB_SWITCH ?
 				IB_SMI_HANDLE : IB_SMI_DISCARD);
 		}
 
 		/* C14-13:4 -- hop_ptr = 0 -> give to SM */
 		/* C14-13:5 -- Check for unreasonable hop pointer */
-		return (hop_ptr == 0 ? IB_SMI_HANDLE : IB_SMI_DISCARD);
+		return (*hop_ptr == 0 ? IB_SMI_HANDLE : IB_SMI_DISCARD);
 	}
 }
 
+/*
+ * Adjust information for a received SMP
+ * Return IB_SMI_DISCARD if the SMP should be dropped
+ */
+enum smi_action smi_handle_dr_smp_recv(struct ib_smp *smp, u8 node_type,
+				       int port_num, int phys_port_cnt)
+{
+	return __smi_handle_dr_smp_recv(node_type, port_num, phys_port_cnt,
+					&smp->hop_ptr, smp->hop_cnt,
+					smp->initial_path,
+					smp->return_path,
+					ib_get_smp_direction(smp),
+					smp->dr_dlid == IB_LID_PERMISSIVE,
+					smp->dr_slid == IB_LID_PERMISSIVE);
+}
+
 enum smi_forward_action smi_check_forward_dr_smp(struct ib_smp *smp)
 {
 	u8 hop_ptr, hop_cnt;
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
