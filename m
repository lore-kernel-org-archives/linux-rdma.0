From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 10/19] IB/mad: Add helper function for smi_check_forward_dr_smp
Date: Mon, 26 Jan 2015 14:07:43 -0500
Message-ID: <1422299272-15898-11-git-send-email-ira.weiny@intel.com>
References: <1422299272-15898-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1422299272-15898-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This helper function will be used for processing both IB and OPA SMPs.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/smi.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/core/smi.c b/drivers/infiniband/core/smi.c
index 24670de..8a5fb1d 100644
--- a/drivers/infiniband/core/smi.c
+++ b/drivers/infiniband/core/smi.c
@@ -236,21 +236,20 @@ enum smi_action smi_handle_dr_smp_recv(struct ib_smp *smp, u8 node_type,
 					smp->dr_slid == IB_LID_PERMISSIVE);
 }
 
-enum smi_forward_action smi_check_forward_dr_smp(struct ib_smp *smp)
+static inline
+enum smi_forward_action __smi_check_forward_dr_smp(u8 hop_ptr, u8 hop_cnt,
+						   u8 direction,
+						   int dr_dlid_is_permissive,
+						   int dr_slid_is_permissive)
 {
-	u8 hop_ptr, hop_cnt;
-
-	hop_ptr = smp->hop_ptr;
-	hop_cnt = smp->hop_cnt;
-
-	if (!ib_get_smp_direction(smp)) {
+	if (!direction) {
 		/* C14-9:2 -- intermediate hop */
 		if (hop_ptr && hop_ptr < hop_cnt)
 			return IB_SMI_FORWARD;
 
 		/* C14-9:3 -- at the end of the DR segment of path */
 		if (hop_ptr == hop_cnt)
-			return (smp->dr_dlid == IB_LID_PERMISSIVE ?
+			return (dr_dlid_is_permissive ?
 				IB_SMI_SEND : IB_SMI_LOCAL);
 
 		/* C14-9:4 -- hop_ptr = hop_cnt + 1 -> give to SMA/SM */
@@ -263,10 +262,19 @@ enum smi_forward_action smi_check_forward_dr_smp(struct ib_smp *smp)
 
 		/* C14-13:3 -- at the end of the DR segment of path */
 		if (hop_ptr == 1)
-			return (smp->dr_slid != IB_LID_PERMISSIVE ?
+			return (dr_slid_is_permissive ?
 				IB_SMI_SEND : IB_SMI_LOCAL);
 	}
 	return IB_SMI_LOCAL;
+
+}
+
+enum smi_forward_action smi_check_forward_dr_smp(struct ib_smp *smp)
+{
+	return __smi_check_forward_dr_smp(smp->hop_ptr, smp->hop_cnt,
+					  ib_get_smp_direction(smp),
+					  smp->dr_dlid == IB_LID_PERMISSIVE,
+					  smp->dr_slid != IB_LID_PERMISSIVE);
 }
 
 /*
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
