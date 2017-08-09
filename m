From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 2/6] i40iw: Correct variable names
Date: Tue,  8 Aug 2017 20:38:44 -0500
Message-ID: <20170809013848.29080-3-henry.orosco@intel.com>
References: <20170809013848.29080-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170809013848.29080-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Fix incorrect naming of status code and struct. Use inline
instead of immediate.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_status.h | 2 +-
 drivers/infiniband/hw/i40iw/i40iw_uk.c     | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_status.h b/drivers/infiniband/hw/i40iw/i40iw_status.h
index 91c4217..f7013f1 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_status.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_status.h
@@ -62,7 +62,7 @@ enum i40iw_status_code {
 	I40IW_ERR_INVALID_ALIGNMENT = -23,
 	I40IW_ERR_FLUSHED_QUEUE = -24,
 	I40IW_ERR_INVALID_PUSH_PAGE_INDEX = -25,
-	I40IW_ERR_INVALID_IMM_DATA_SIZE = -26,
+	I40IW_ERR_INVALID_INLINE_DATA_SIZE = -26,
 	I40IW_ERR_TIMEOUT = -27,
 	I40IW_ERR_OPCODE_MISMATCH = -28,
 	I40IW_ERR_CQP_COMPL_ERROR = -29,
diff --git a/drivers/infiniband/hw/i40iw/i40iw_uk.c b/drivers/infiniband/hw/i40iw/i40iw_uk.c
index b0d3a0e..70a6b41 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_uk.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_uk.c
@@ -435,7 +435,7 @@ static enum i40iw_status_code i40iw_inline_rdma_write(struct i40iw_qp_uk *qp,
 
 	op_info = &info->op.inline_rdma_write;
 	if (op_info->len > I40IW_MAX_INLINE_DATA_SIZE)
-		return I40IW_ERR_INVALID_IMM_DATA_SIZE;
+		return I40IW_ERR_INVALID_INLINE_DATA_SIZE;
 
 	ret_code = i40iw_inline_data_size_to_wqesize(op_info->len, &wqe_size);
 	if (ret_code)
@@ -511,7 +511,7 @@ static enum i40iw_status_code i40iw_inline_send(struct i40iw_qp_uk *qp,
 
 	op_info = &info->op.inline_send;
 	if (op_info->len > I40IW_MAX_INLINE_DATA_SIZE)
-		return I40IW_ERR_INVALID_IMM_DATA_SIZE;
+		return I40IW_ERR_INVALID_INLINE_DATA_SIZE;
 
 	ret_code = i40iw_inline_data_size_to_wqesize(op_info->len, &wqe_size);
 	if (ret_code)
@@ -1187,7 +1187,7 @@ enum i40iw_status_code i40iw_inline_data_size_to_wqesize(u32 data_size,
 							 u8 *wqe_size)
 {
 	if (data_size > I40IW_MAX_INLINE_DATA_SIZE)
-		return I40IW_ERR_INVALID_IMM_DATA_SIZE;
+		return I40IW_ERR_INVALID_INLINE_DATA_SIZE;
 
 	if (data_size <= 16)
 		*wqe_size = I40IW_QP_WQE_MIN_SIZE;
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
