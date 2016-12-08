From: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-core 04/10] i40iw: Optimize inline data copy
Date: Thu,  8 Dec 2016 12:16:35 -0600
Message-ID: <1481221001-1044-5-git-send-email-tatyana.e.nikolova@intel.com>
References: <1481221001-1044-1-git-send-email-tatyana.e.nikolova@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481221001-1044-1-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Use memcpy for inline data copy in sends
and writes instead of byte by byte copy.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 providers/i40iw/i40iw_uk.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/providers/i40iw/i40iw_uk.c b/providers/i40iw/i40iw_uk.c
index 9b1a618..bf194f3 100644
--- a/providers/i40iw/i40iw_uk.c
+++ b/providers/i40iw/i40iw_uk.c
@@ -432,7 +432,7 @@ static enum i40iw_status_code i40iw_inline_rdma_write(struct i40iw_qp_uk *qp,
 	struct i40iw_inline_rdma_write *op_info;
 	u64 *push;
 	u64 header = 0;
-	u32 i, wqe_idx;
+	u32 wqe_idx;
 	enum i40iw_status_code ret_code;
 	bool read_fence = false;
 	u8 wqe_size;
@@ -468,14 +468,12 @@ static enum i40iw_status_code i40iw_inline_rdma_write(struct i40iw_qp_uk *qp,
 	src = (u8 *)(op_info->data);
 
 	if (op_info->len <= I40IW_BYTE_16) {
-		for (i = 0; i < op_info->len; i++, src++, dest++)
-			*dest = *src;
+		memcpy(dest, src, op_info->len);
 	} else {
-		for (i = 0; i < I40IW_BYTE_16; i++, src++, dest++)
-			*dest = *src;
+		memcpy(dest, src, I40IW_BYTE_16);
+		src += I40IW_BYTE_16;
 		dest = (u8 *)wqe + I40IW_BYTE_32;
-		for (; i < op_info->len; i++, src++, dest++)
-			*dest = *src;
+		memcpy(dest, src, op_info->len - I40IW_BYTE_16);
 	}
 
 	i40iw_wmb(); /* make sure WQE is populated before valid bit is set */
@@ -510,7 +508,7 @@ static enum i40iw_status_code i40iw_inline_send(struct i40iw_qp_uk *qp,
 	u8 *dest, *src;
 	struct i40iw_post_inline_send *op_info;
 	u64 header;
-	u32 wqe_idx, i;
+	u32 wqe_idx;
 	enum i40iw_status_code ret_code;
 	bool read_fence = false;
 	u8 wqe_size;
@@ -544,14 +542,12 @@ static enum i40iw_status_code i40iw_inline_send(struct i40iw_qp_uk *qp,
 	src = (u8 *)(op_info->data);
 
 	if (op_info->len <= I40IW_BYTE_16) {
-		for (i = 0; i < op_info->len; i++, src++, dest++)
-			*dest = *src;
+		memcpy(dest, src, op_info->len);
 	} else {
-		for (i = 0; i < I40IW_BYTE_16; i++, src++, dest++)
-			*dest = *src;
+		memcpy(dest, src, I40IW_BYTE_16);
+		src += I40IW_BYTE_16;
 		dest = (u8 *)wqe + I40IW_BYTE_32;
-		for (; i < op_info->len; i++, src++, dest++)
-			*dest = *src;
+		memcpy(dest, src, op_info->len - I40IW_BYTE_16);
 	}
 
 	i40iw_wmb(); /* make sure WQE is populated before valid bit is set */
-- 
1.8.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
