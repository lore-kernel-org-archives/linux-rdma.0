From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH v2 2/3] nvme-rdma: remove redundant empty device add callout
Date: Sun,  2 Jul 2017 11:20:51 +0300
Message-ID: <1498983652-18250-3-git-send-email-sagi@grimberg.me>
References: <1498983652-18250-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498983652-18250-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Now that its not needed, we can simply not assign it.

Reviewed-by: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/nvme/host/rdma.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 6d4119dfbdaa..934183f80fff 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1956,10 +1956,6 @@ static struct nvmf_transport_ops nvme_rdma_transport = {
 	.create_ctrl	= nvme_rdma_create_ctrl,
 };
 
-static void nvme_rdma_add_one(struct ib_device *ib_device)
-{
-}
-
 static void nvme_rdma_remove_one(struct ib_device *ib_device, void *client_data)
 {
 	struct nvme_rdma_ctrl *ctrl;
@@ -1981,7 +1977,6 @@ static void nvme_rdma_remove_one(struct ib_device *ib_device, void *client_data)
 
 static struct ib_client nvme_rdma_ib_client = {
 	.name   = "nvme_rdma",
-	.add = nvme_rdma_add_one,
 	.remove = nvme_rdma_remove_one
 };
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
