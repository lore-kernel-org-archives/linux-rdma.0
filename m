From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 2/5] IB/srp: Introduce a local variable in srp_add_one()
Date: Mon, 21 Nov 2016 13:57:07 -0800
Message-ID: <96a9cadd-dc31-769b-6e6a-f5553aff8ed3@sandisk.com>
References: <ba32b251-135f-c57d-44cc-658ae35a49ca@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ba32b251-135f-c57d-44cc-658ae35a49ca-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch makes the srp_add_one() code more compact and does not
change any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 8bb720c..c216c6e 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3527,6 +3527,7 @@ static struct srp_host *srp_add_port(struct srp_device *device, u8 port)
 static void srp_add_one(struct ib_device *device)
 {
 	struct srp_device *srp_dev;
+	struct ib_device_attr *attr = &device->attrs;
 	struct srp_host *host;
 	int mr_page_shift, p;
 	u64 max_pages_per_mr;
@@ -3541,25 +3542,25 @@ static void srp_add_one(struct ib_device *device)
 	 * minimum of 4096 bytes. We're unlikely to build large sglists
 	 * out of smaller entries.
 	 */
-	mr_page_shift		= max(12, ffs(device->attrs.page_size_cap) - 1);
+	mr_page_shift		= max(12, ffs(attr->page_size_cap) - 1);
 	srp_dev->mr_page_size	= 1 << mr_page_shift;
 	srp_dev->mr_page_mask	= ~((u64) srp_dev->mr_page_size - 1);
-	max_pages_per_mr	= device->attrs.max_mr_size;
+	max_pages_per_mr	= attr->max_mr_size;
 	do_div(max_pages_per_mr, srp_dev->mr_page_size);
 	pr_debug("%s: %llu / %u = %llu <> %u\n", __func__,
-		 device->attrs.max_mr_size, srp_dev->mr_page_size,
+		 attr->max_mr_size, srp_dev->mr_page_size,
 		 max_pages_per_mr, SRP_MAX_PAGES_PER_MR);
 	srp_dev->max_pages_per_mr = min_t(u64, SRP_MAX_PAGES_PER_MR,
 					  max_pages_per_mr);
 
 	srp_dev->has_fmr = (device->alloc_fmr && device->dealloc_fmr &&
 			    device->map_phys_fmr && device->unmap_fmr);
-	srp_dev->has_fr = (device->attrs.device_cap_flags &
+	srp_dev->has_fr = (attr->device_cap_flags &
 			   IB_DEVICE_MEM_MGT_EXTENSIONS);
 	if (!never_register && !srp_dev->has_fmr && !srp_dev->has_fr) {
 		dev_warn(&device->dev, "neither FMR nor FR is supported\n");
 	} else if (!never_register &&
-		   device->attrs.max_mr_size >= 2 * srp_dev->mr_page_size) {
+		   attr->max_mr_size >= 2 * srp_dev->mr_page_size) {
 		srp_dev->use_fast_reg = (srp_dev->has_fr &&
 					 (!srp_dev->has_fmr || prefer_fr));
 		srp_dev->use_fmr = !srp_dev->use_fast_reg && srp_dev->has_fmr;
@@ -3572,13 +3573,13 @@ static void srp_add_one(struct ib_device *device)
 	if (srp_dev->use_fast_reg) {
 		srp_dev->max_pages_per_mr =
 			min_t(u32, srp_dev->max_pages_per_mr,
-			      device->attrs.max_fast_reg_page_list_len);
+			      attr->max_fast_reg_page_list_len);
 	}
 	srp_dev->mr_max_size	= srp_dev->mr_page_size *
 				   srp_dev->max_pages_per_mr;
 	pr_debug("%s: mr_page_shift = %d, device->max_mr_size = %#llx, device->max_fast_reg_page_list_len = %u, max_pages_per_mr = %d, mr_max_size = %#x\n",
-		 device->name, mr_page_shift, device->attrs.max_mr_size,
-		 device->attrs.max_fast_reg_page_list_len,
+		 device->name, mr_page_shift, attr->max_mr_size,
+		 attr->max_fast_reg_page_list_len,
 		 srp_dev->max_pages_per_mr, srp_dev->mr_max_size);
 
 	INIT_LIST_HEAD(&srp_dev->dev_list);
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
