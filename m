From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH 3/3] nvmet-rdma: remove redundant empty device add callout
Date: Wed, 28 Jun 2017 13:05:38 +0300
Message-ID: <1498644338-19719-4-git-send-email-sagi@grimberg.me>
References: <1498644338-19719-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498644338-19719-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Now that its not needed, we can simply not assign it.

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/nvme/target/rdma.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 56a4cba690b5..76d2bb793afe 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1510,10 +1510,6 @@ static struct nvmet_fabrics_ops nvmet_rdma_ops = {
 	.delete_ctrl		= nvmet_rdma_delete_ctrl,
 };
 
-static void nvmet_rdma_add_one(struct ib_device *ib_device)
-{
-}
-
 static void nvmet_rdma_remove_one(struct ib_device *ib_device, void *client_data)
 {
 	struct nvmet_rdma_queue *queue;
@@ -1534,7 +1530,6 @@ static void nvmet_rdma_remove_one(struct ib_device *ib_device, void *client_data
 
 static struct ib_client nvmet_rdma_ib_client = {
 	.name   = "nvmet_rdma",
-	.add = nvmet_rdma_add_one,
 	.remove = nvmet_rdma_remove_one
 };
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
