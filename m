From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] i40iw: Optimize inline data copy
Date: Wed,  9 Nov 2016 21:28:02 -0600
Message-ID: <20161110032802.20640-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use memcpy for inline data copy in sends
and writes instead of byte by byte copy.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_uk.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_uk.c b/drivers/infiniband/hw/i40iw/i40iw_uk.c
index 4d28c3c..47cb2e0 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_uk.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_uk.c
@@ -430,7 +430,7 @@ static enum i40iw_status_code i40iw_inline_rdma_write(struct i40iw_qp_uk *qp,
 	struct i40iw_inline_rdma_write *op_info;
 	u64 *push;
 	u64 header = 0;
-	u32 i, wqe_idx;
+	u32 wqe_idx;
 	enum i40iw_status_code ret_code;
 	bool read_fence = false;
 	u8 wqe_size;
@@ -465,14 +465,12 @@ static enum i40iw_status_code i40iw_inline_rdma_write(struct i40iw_qp_uk *qp,
 	src = (u8 *)(op_info->data);
 
 	if (op_info->len <= 16) {
-		for (i = 0; i < op_info->len; i++, src++, dest++)
-			*dest = *src;
+		memcpy(dest, src, op_info->len);
 	} else {
-		for (i = 0; i < 16; i++, src++, dest++)
-			*dest = *src;
+		memcpy(dest, src, 16);
+		src += 16;
 		dest = (u8 *)wqe + 32;
-		for (; i < op_info->len; i++, src++, dest++)
-			*dest = *src;
+		memcpy(dest, src, op_info->len - 16);
 	}
 
 	wmb(); /* make sure WQE is populated before valid bit is set */
@@ -507,7 +505,7 @@ static enum i40iw_status_code i40iw_inline_send(struct i40iw_qp_uk *qp,
 	u8 *dest, *src;
 	struct i40iw_post_inline_send *op_info;
 	u64 header;
-	u32 wqe_idx, i;
+	u32 wqe_idx;
 	enum i40iw_status_code ret_code;
 	bool read_fence = false;
 	u8 wqe_size;
@@ -540,14 +538,12 @@ static enum i40iw_status_code i40iw_inline_send(struct i40iw_qp_uk *qp,
 	src = (u8 *)(op_info->data);
 
 	if (op_info->len <= 16) {
-		for (i = 0; i < op_info->len; i++, src++, dest++)
-			*dest = *src;
+		memcpy(dest, src, op_info->len);
 	} else {
-		for (i = 0; i < 16; i++, src++, dest++)
-			*dest = *src;
+		memcpy(dest, src, 16);
+		src += 16;
 		dest = (u8 *)wqe + 32;
-		for (; i < op_info->len; i++, src++, dest++)
-			*dest = *src;
+		memcpy(dest, src, op_info->len - 16);
 	}
 
 	wmb(); /* make sure WQE is populated before valid bit is set */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
