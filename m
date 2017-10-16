From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 05/12] i40iw: Remove unused structures
Date: Mon, 16 Oct 2017 15:45:58 -0500
Message-ID: <20171016204605.37512-6-shiraz.saleem@intel.com>
References: <20171016204605.37512-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171016204605.37512-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Some structures for post SQ operation are not used.
Remove the following:

i40iw_post_send_w_inv
i40iw_post_inline_send_w_inv
send_w_sol
send_w_inv
send_w_sol_inv
inline_send_w_sol
inline_send_w_inv
inline_send_w_sol_inv

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_user.h | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_user.h b/drivers/infiniband/hw/i40iw/i40iw_user.h
index 15e8f55..a898f99 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_user.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_user.h
@@ -204,18 +204,6 @@ struct i40iw_post_inline_send {
 	u32 len;
 };
 
-struct i40iw_post_send_w_inv {
-	i40iw_sgl sg_list;
-	u32 num_sges;
-	i40iw_stag remote_stag_to_inv;
-};
-
-struct i40iw_post_inline_send_w_inv {
-	void *data;
-	u32 len;
-	i40iw_stag remote_stag_to_inv;
-};
-
 struct i40iw_rdma_write {
 	i40iw_sgl lo_sg_list;
 	u32 num_lo_sges;
@@ -257,9 +245,6 @@ struct i40iw_post_sq_info {
 	bool defer_flag;
 	union {
 		struct i40iw_post_send send;
-		struct i40iw_post_send send_w_sol;
-		struct i40iw_post_send_w_inv send_w_inv;
-		struct i40iw_post_send_w_inv send_w_sol_inv;
 		struct i40iw_rdma_write rdma_write;
 		struct i40iw_rdma_read rdma_read;
 		struct i40iw_rdma_read rdma_read_inv;
@@ -267,9 +252,6 @@ struct i40iw_post_sq_info {
 		struct i40iw_inv_local_stag inv_local_stag;
 		struct i40iw_inline_rdma_write inline_rdma_write;
 		struct i40iw_post_inline_send inline_send;
-		struct i40iw_post_inline_send inline_send_w_sol;
-		struct i40iw_post_inline_send_w_inv inline_send_w_inv;
-		struct i40iw_post_inline_send_w_inv inline_send_w_sol_inv;
 	} op;
 };
 
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
