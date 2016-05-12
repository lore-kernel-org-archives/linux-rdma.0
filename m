From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 7/7] IB/srp: Do not register memory if never_register has been
 set
Date: Thu, 12 May 2016 10:51:01 -0700
Message-ID: <5734C285.20001@sandisk.com>
References: <5734C181.2020003@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5734C181.2020003-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This makes it easier to test the code path that does not use
memory registration (srp_map_sg_dma()).

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 5ecdeb4..a208274 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -70,6 +70,7 @@ static unsigned int indirect_sg_entries;
 static bool allow_ext_sg;
 static bool prefer_fr = true;
 static bool register_always = true;
+static bool never_register;
 static int topspin_workarounds = 1;
 
 module_param(srp_sg_tablesize, uint, 0444);
@@ -99,6 +100,9 @@ module_param(register_always, bool, 0444);
 MODULE_PARM_DESC(register_always,
 		 "Use memory registration even for contiguous memory regions");
 
+module_param(never_register, bool, 0444);
+MODULE_PARM_DESC(never_register, "Never register memory");
+
 static const struct kernel_param_ops srp_tmo_ops;
 
 static int srp_reconnect_delay = 10;
@@ -3541,9 +3545,10 @@ static void srp_add_one(struct ib_device *device)
 			    device->map_phys_fmr && device->unmap_fmr);
 	srp_dev->has_fr = (device->attrs.device_cap_flags &
 			   IB_DEVICE_MEM_MGT_EXTENSIONS);
-	if (!srp_dev->has_fmr && !srp_dev->has_fr) {
+	if (!never_register && !srp_dev->has_fmr && !srp_dev->has_fr) {
 		dev_warn(&device->dev, "neither FMR nor FR is supported\n");
-	} else if (device->attrs.max_mr_size >= 2 * srp_dev->mr_page_size) {
+	} else if (!never_register &&
+		   device->attrs.max_mr_size >= 2 * srp_dev->mr_page_size) {
 		srp_dev->use_fast_reg = (srp_dev->has_fr &&
 					 (!srp_dev->has_fmr || prefer_fr));
 		srp_dev->use_fmr = !srp_dev->use_fast_reg && srp_dev->has_fmr;
@@ -3568,7 +3573,8 @@ static void srp_add_one(struct ib_device *device)
 	if (IS_ERR(srp_dev->pd))
 		goto free_dev;
 
-	if (!register_always || (!srp_dev->has_fmr && !srp_dev->has_fr)) {
+	if (never_register || !register_always ||
+	    (!srp_dev->has_fmr && !srp_dev->has_fr)) {
 		srp_dev->global_mr = ib_get_dma_mr(srp_dev->pd,
 						   IB_ACCESS_LOCAL_WRITE |
 						   IB_ACCESS_REMOTE_READ |
-- 
2.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
