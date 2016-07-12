From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 5/8] i40iw: Simplify code to set fragments in SQ WQE
Date: Tue, 12 Jul 2016 11:48:43 -0500
Message-ID: <1468342126-29168-6-git-send-email-shiraz.saleem@intel.com>
References: <1468342126-29168-1-git-send-email-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468342126-29168-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Replace a subtract and multiply with an add; while populating fragments
in SQ wqe.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_uk.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_uk.c b/drivers/infiniband/hw/i40iw/i40iw_uk.c
index cea0b8a..6b217e6 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_uk.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_uk.c
@@ -291,9 +291,9 @@ static enum i40iw_status_code i40iw_rdma_write(struct i40iw_qp_uk *qp,
 
 	i40iw_set_fragment(wqe, 0, op_info->lo_sg_list);
 
-	for (i = 1; i < op_info->num_lo_sges; i++) {
-		byte_off = 32 + (i - 1) * 16;
+	for (i = 1, byte_off = 32; i < op_info->num_lo_sges; i++) {
 		i40iw_set_fragment(wqe, byte_off, &op_info->lo_sg_list[i]);
+		byte_off += 16;
 	}
 
 	wmb(); /* make sure WQE is populated before valid bit is set */
@@ -401,9 +401,9 @@ static enum i40iw_status_code i40iw_send(struct i40iw_qp_uk *qp,
 
 	i40iw_set_fragment(wqe, 0, op_info->sg_list);
 
-	for (i = 1; i < op_info->num_sges; i++) {
-		byte_off = 32 + (i - 1) * 16;
+	for (i = 1, byte_off = 32; i < op_info->num_sges; i++) {
 		i40iw_set_fragment(wqe, byte_off, &op_info->sg_list[i]);
+		byte_off += 16;
 	}
 
 	wmb(); /* make sure WQE is populated before valid bit is set */
@@ -685,9 +685,9 @@ static enum i40iw_status_code i40iw_post_receive(struct i40iw_qp_uk *qp,
 
 	i40iw_set_fragment(wqe, 0, info->sg_list);
 
-	for (i = 1; i < info->num_sges; i++) {
-		byte_off = 32 + (i - 1) * 16;
+	for (i = 1, byte_off = 32; i < info->num_sges; i++) {
 		i40iw_set_fragment(wqe, byte_off, &info->sg_list[i]);
+		byte_off += 16;
 	}
 
 	wmb(); /* make sure WQE is populated before valid bit is set */
-- 
2.8.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
