From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: [RFC 1/8] IB/srp: always avoid non-zero offsets into an FMR
Date: Tue, 18 Jan 2011 23:27:15 -0500
Message-ID: <1295411242-26148-2-git-send-email-dillowda@ornl.gov>
References: <1295411242-26148-1-git-send-email-dillowda@ornl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1295411242-26148-1-git-send-email-dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

It is unclear what bug this fixed, and so it's not clear how safe it is
to remove it, or if things were actually an HCA issue with FMR. Always
enable the workaround for now.

TODO: Better description
---
 drivers/infiniband/ulp/srp/ib_srp.c |   17 +----------------
 1 files changed, 1 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 83664ed..197e26c 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -72,12 +72,6 @@ module_param(topspin_workarounds, int, 0444);
 MODULE_PARM_DESC(topspin_workarounds,
 		 "Enable workarounds for Topspin/Cisco SRP target bugs if != 0");
 
-static int mellanox_workarounds = 1;
-
-module_param(mellanox_workarounds, int, 0444);
-MODULE_PARM_DESC(mellanox_workarounds,
-		 "Enable workarounds for Mellanox SRP target bugs if != 0");
-
 static void srp_add_one(struct ib_device *device);
 static void srp_remove_one(struct ib_device *device);
 static void srp_recv_completion(struct ib_cq *cq, void *target_ptr);
@@ -114,14 +108,6 @@ static int srp_target_is_topspin(struct srp_target_port *target)
 		 !memcmp(&target->ioc_guid, cisco_oui, sizeof cisco_oui));
 }
 
-static int srp_target_is_mellanox(struct srp_target_port *target)
-{
-	static const u8 mellanox_oui[3] = { 0x00, 0x02, 0xc9 };
-
-	return mellanox_workarounds &&
-		!memcmp(&target->ioc_guid, mellanox_oui, sizeof mellanox_oui);
-}
-
 static struct srp_iu *srp_alloc_iu(struct srp_host *host, size_t size,
 				   gfp_t gfp_mask,
 				   enum dma_data_direction direction)
@@ -662,8 +648,7 @@ static int srp_map_fmr(struct srp_target_port *target, struct scatterlist *scat,
 	if (!dev->fmr_pool)
 		return -ENODEV;
 
-	if (srp_target_is_mellanox(target) &&
-	    (ib_sg_dma_address(ibdev, &scat[0]) & ~dev->fmr_page_mask))
+	if (ib_sg_dma_address(ibdev, &scat[0]) & ~dev->fmr_page_mask)
 		return -EINVAL;
 
 	len = page_cnt = 0;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
