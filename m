From: Bhumika Goyal <bhumirks-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] i40iw: make some structures const
Date: Mon, 28 Aug 2017 21:51:23 +0530
Message-ID: <1503937283-15549-1-git-send-email-bhumirks@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: julia.lawall-L2FTfq7BK8M@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bhumika Goyal <bhumirks-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Make some structures const as they are only used during a copy
operation.

Signed-off-by: Bhumika Goyal <bhumirks-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_uk.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_uk.c b/drivers/infiniband/hw/i40iw/i40iw_uk.c
index 1060725..0aadb7a 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_uk.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_uk.c
@@ -912,7 +912,7 @@ enum i40iw_status_code i40iw_get_wqe_shift(u32 wqdepth, u32 sge, u32 inline_data
 	return 0;
 }
 
-static struct i40iw_qp_uk_ops iw_qp_uk_ops = {
+static const struct i40iw_qp_uk_ops iw_qp_uk_ops = {
 	.iw_qp_post_wr = i40iw_qp_post_wr,
 	.iw_qp_ring_push_db = i40iw_qp_ring_push_db,
 	.iw_rdma_write = i40iw_rdma_write,
@@ -926,14 +926,14 @@ enum i40iw_status_code i40iw_get_wqe_shift(u32 wqdepth, u32 sge, u32 inline_data
 	.iw_post_nop = i40iw_nop
 };
 
-static struct i40iw_cq_ops iw_cq_ops = {
+static const struct i40iw_cq_ops iw_cq_ops = {
 	.iw_cq_request_notification = i40iw_cq_request_notification,
 	.iw_cq_poll_completion = i40iw_cq_poll_completion,
 	.iw_cq_post_entries = i40iw_cq_post_entries,
 	.iw_cq_clean = i40iw_clean_cq
 };
 
-static struct i40iw_device_uk_ops iw_device_uk_ops = {
+static const struct i40iw_device_uk_ops iw_device_uk_ops = {
 	.iwarp_cq_uk_init = i40iw_cq_uk_init,
 	.iwarp_qp_uk_init = i40iw_qp_uk_init,
 };
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
