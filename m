From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 1/2] IB/srp: Always initialize use_fast_reg and use_fmr
Date: Fri, 3 Jun 2016 11:39:35 -0700
Message-ID: <4b1522b5-31a2-9c7e-6b20-4e859c009345@sandisk.com>
References: <4b4cc34a-eebb-8534-3d76-1cfb3fe961f5@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4b4cc34a-eebb-8534-3d76-1cfb3fe961f5-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that mapping fails due to use_fast_reg != 0 or use_fmr != 0
if both member variables should be zero (if never_register == 1 or
if neither FMR nor FR is supported). Remove an initialization that
became superfluous due to changing a kmalloc() into a kzalloc()
call.

Fixes: 509c5f33f4f6 ("IB/srp: Prevent mapping failures")
Cc: Sagi Grimberg <sai@grimberg.m>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 646de17..bc24b8d 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3526,7 +3526,7 @@ static void srp_add_one(struct ib_device *device)
 	int mr_page_shift, p;
 	u64 max_pages_per_mr;
 
-	srp_dev = kmalloc(sizeof *srp_dev, GFP_KERNEL);
+	srp_dev = kzalloc(sizeof(*srp_dev), GFP_KERNEL);
 	if (!srp_dev)
 		return;
 
@@ -3586,8 +3586,6 @@ static void srp_add_one(struct ib_device *device)
 						   IB_ACCESS_REMOTE_WRITE);
 		if (IS_ERR(srp_dev->global_mr))
 			goto err_pd;
-	} else {
-		srp_dev->global_mr = NULL;
 	}
 
 	for (p = rdma_start_port(device); p <= rdma_end_port(device); ++p) {
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
