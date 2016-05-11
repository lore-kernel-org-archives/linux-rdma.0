From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 5/6] IB/srp: Swap two code blocks in srp_add_one()
Date: Tue, 10 May 2016 17:15:21 -0700
Message-ID: <57327999.20106@sandisk.com>
References: <573278D9.4050908@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <573278D9.4050908-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch does not change any functionality but makes the next
patch in this series easier to read.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 6440469..e530a77 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3430,17 +3430,6 @@ static void srp_add_one(struct ib_device *device)
 	if (!srp_dev)
 		return;
 
-	srp_dev->has_fmr = (device->alloc_fmr && device->dealloc_fmr &&
-			    device->map_phys_fmr && device->unmap_fmr);
-	srp_dev->has_fr = (device->attrs.device_cap_flags &
-			   IB_DEVICE_MEM_MGT_EXTENSIONS);
-	if (!srp_dev->has_fmr && !srp_dev->has_fr)
-		dev_warn(&device->dev, "neither FMR nor FR is supported\n");
-
-	srp_dev->use_fast_reg = (srp_dev->has_fr &&
-				 (!srp_dev->has_fmr || prefer_fr));
-	srp_dev->use_fmr = !srp_dev->use_fast_reg && srp_dev->has_fmr;
-
 	/*
 	 * Use the smallest page size supported by the HCA, down to a
 	 * minimum of 4096 bytes. We're unlikely to build large sglists
@@ -3453,6 +3442,18 @@ static void srp_add_one(struct ib_device *device)
 	do_div(max_pages_per_mr, srp_dev->mr_page_size);
 	srp_dev->max_pages_per_mr = min_t(u64, SRP_MAX_PAGES_PER_MR,
 					  max_pages_per_mr);
+
+	srp_dev->has_fmr = (device->alloc_fmr && device->dealloc_fmr &&
+			    device->map_phys_fmr && device->unmap_fmr);
+	srp_dev->has_fr = (device->attrs.device_cap_flags &
+			   IB_DEVICE_MEM_MGT_EXTENSIONS);
+	if (!srp_dev->has_fmr && !srp_dev->has_fr)
+		dev_warn(&device->dev, "neither FMR nor FR is supported\n");
+
+	srp_dev->use_fast_reg = (srp_dev->has_fr &&
+				 (!srp_dev->has_fmr || prefer_fr));
+	srp_dev->use_fmr = !srp_dev->use_fast_reg && srp_dev->has_fmr;
+
 	if (srp_dev->use_fast_reg) {
 		srp_dev->max_pages_per_mr =
 			min_t(u32, srp_dev->max_pages_per_mr,
-- 
2.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
