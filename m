From: Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org>
Subject: [PATCH 09/26] i40iw: constify local structures
Date: Sun, 11 Sep 2016 15:05:51 +0200
Message-ID: <1473599168-30561-10-git-send-email-Julia.Lawall@lip6.fr>
References: <1473599168-30561-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473599168-30561-1-git-send-email-Julia.Lawall-L2FTfq7BK8M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

For structure types defined in the same file or local header files, find
top-level static structure declarations that have the following
properties:
1. Never reassigned.
2. Address never taken
3. Not passed to a top-level macro call
4. No pointer or array-typed field passed to a function or stored in a
variable.
Declare structures having all of these properties as const.

Done using Coccinelle.
Based on a suggestion by Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>.

Signed-off-by: Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org>

---
The semantic patch seems too long for a commit log, but is in the cover
letter.

 drivers/infiniband/hw/i40iw/i40iw_uk.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_uk.c b/drivers/infiniband/hw/i40iw/i40iw_uk.c
index 4d28c3c..eb94c03 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_uk.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_uk.c
@@ -918,7 +918,7 @@ enum i40iw_status_code i40iw_get_wqe_shift(u32 wqdepth, u32 sge, u32 inline_data
 	return 0;
 }
 
-static struct i40iw_qp_uk_ops iw_qp_uk_ops = {
+static const struct i40iw_qp_uk_ops iw_qp_uk_ops = {
 	i40iw_qp_post_wr,
 	i40iw_qp_ring_push_db,
 	i40iw_rdma_write,
@@ -932,14 +932,14 @@ static struct i40iw_qp_uk_ops iw_qp_uk_ops = {
 	i40iw_nop
 };
 
-static struct i40iw_cq_ops iw_cq_ops = {
+static const struct i40iw_cq_ops iw_cq_ops = {
 	i40iw_cq_request_notification,
 	i40iw_cq_poll_completion,
 	i40iw_cq_post_entries,
 	i40iw_clean_cq
 };
 
-static struct i40iw_device_uk_ops iw_device_uk_ops = {
+static const struct i40iw_device_uk_ops iw_device_uk_ops = {
 	i40iw_cq_uk_init,
 	i40iw_qp_uk_init,
 };

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
