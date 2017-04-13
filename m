From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 3/4] nvme: enable SG gaps support
Date: Thu, 13 Apr 2017 18:56:16 +0300
Message-ID: <1492098977-5231-4-git-send-email-maxg@mellanox.com>
References: <1492098977-5231-1-git-send-email-maxg@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492098977-5231-1-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

For controllers that can handle arbitrarily sized bios (e.g advanced
RDMA ctrls) we can allow the block layer to pass us gaps by skip
setting the queue virt_boundary.

Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/nvme/host/core.c |    5 ++++-
 drivers/nvme/host/nvme.h |    1 +
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 9583a5f..72bc70e 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1252,7 +1252,10 @@ static void nvme_set_queue_limits(struct nvme_ctrl *ctrl,
 	}
 	if (ctrl->quirks & NVME_QUIRK_STRIPE_SIZE)
 		blk_queue_chunk_sectors(q, ctrl->max_hw_sectors);
-	blk_queue_virt_boundary(q, ctrl->page_size - 1);
+
+	if (!ctrl->sg_gaps_support)
+		blk_queue_virt_boundary(q, ctrl->page_size - 1);
+
 	if (ctrl->vwc & NVME_CTRL_VWC_PRESENT)
 		vwc = true;
 	blk_queue_write_cache(q, vwc, vwc);
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 2aa20e3..ccb895a 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -162,6 +162,7 @@ struct nvme_ctrl {
 	struct work_struct scan_work;
 	struct work_struct async_event_work;
 	struct delayed_work ka_work;
+	bool sg_gaps_support;
 
 	/* Power saving configuration */
 	u64 ps_max_latency_us;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
