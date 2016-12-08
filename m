From: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-core 01/10] i40iw: Optimize setting fragments
Date: Thu,  8 Dec 2016 12:16:32 -0600
Message-ID: <1481221001-1044-2-git-send-email-tatyana.e.nikolova@intel.com>
References: <1481221001-1044-1-git-send-email-tatyana.e.nikolova@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481221001-1044-1-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Small optimizations replace subtract and multiply with add.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 providers/i40iw/i40iw_uk.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/providers/i40iw/i40iw_uk.c b/providers/i40iw/i40iw_uk.c
index aff3de6..4d353b5 100644
--- a/providers/i40iw/i40iw_uk.c
+++ b/providers/i40iw/i40iw_uk.c
@@ -291,9 +291,9 @@ static enum i40iw_status_code i40iw_rdma_write(struct i40iw_qp_uk *qp,
 
 	i40iw_set_fragment(wqe, I40IW_BYTE_0, op_info->lo_sg_list);
 
-	for (i = 1; i < op_info->num_lo_sges; i++) {
-		byte_off = I40IW_BYTE_32 + (i - 1) * 16;
+	for (i = 1, byte_off = I40IW_BYTE_32; i < op_info->num_lo_sges; i++) {
 		i40iw_set_fragment(wqe, byte_off, &op_info->lo_sg_list[i]);
+		byte_off += 16;
 	}
 
 	i40iw_wmb(); /* make sure WQE is populated before valid bit is set */
@@ -404,9 +404,9 @@ static enum i40iw_status_code i40iw_send(struct i40iw_qp_uk *qp,
 
 	i40iw_set_fragment(wqe, I40IW_BYTE_0, op_info->sg_list);
 
-	for (i = 1; i < op_info->num_sges; i++) {
-		byte_off = I40IW_BYTE_32 + (i - 1) * 16;
+	for (i = 1, byte_off = I40IW_BYTE_32; i < op_info->num_sges; i++) {
 		i40iw_set_fragment(wqe, byte_off, &op_info->sg_list[i]);
+		byte_off += 16;
 	}
 
 	i40iw_wmb(); /* make sure WQE is populated before valid bit is set */
@@ -692,9 +692,9 @@ static enum i40iw_status_code i40iw_post_receive(struct i40iw_qp_uk *qp,
 
 	i40iw_set_fragment(wqe, I40IW_BYTE_0, info->sg_list);
 
-	for (i = 1; i < info->num_sges; i++) {
-		byte_off = I40IW_BYTE_32 + (i - 1) * 16;
+	for (i = 1, byte_off = I40IW_BYTE_32; i < info->num_sges; i++) {
 		i40iw_set_fragment(wqe, byte_off, &info->sg_list[i]);
+		byte_off += 16;
 	}
 
 	i40iw_wmb(); /* make sure WQE is populated before valid bit is set */
-- 
1.8.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
