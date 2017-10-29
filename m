From: idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Subject: [PATCH 2/2] nvme-rdma: Add remote_invalidation module parameter
Date: Sun, 29 Oct 2017 18:38:21 +0200
Message-ID: <1509295101-14081-3-git-send-email-idanb@mellanox.com>
References: <1509295101-14081-1-git-send-email-idanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1509295101-14081-1-git-send-email-idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

NVMe over Fabrics in its secure "register_always" mode
registers and invalidates the user buffer upon each IO.
The protocol enables the host to request the susbsystem
to use SEND WITH INVALIDATE operation while returning the
response capsule and invalidate the local key
(remote_invalidation).
In some HW implementations, the local network adapter may
perform better while using local invalidation operations.

The results below show that running with local invalidation
rather then remote invalidation improve the iops one could
achieve by using the ConnectX-5Ex network adapter by x1.36 factor.
Nevertheless, using local invalidation induce more CPU overhead
than enabling the target to invalidate remotly, therefore,
because there is a CPU% vs IOPs limit tradeoff we propose to
have module parameter to define whether to request remote
invalidation or not.

The following results were taken against a single nvme over fabrics
subsystem with a single namespace backed by null_blk:

Block Size       s/g reg_wr      inline reg_wr    inline reg_wr + local inv
++++++++++++   ++++++++++++++   ++++++++++++++++ +++++++++++++++++++++++++++
512B            1446.6K/8.57%    5224.2K/76.21%   7143.3K/79.72%
1KB             1390.6K/8.5%     4656.7K/71.69%   5860.6K/55.45%
2KB             1343.8K/8.6%     3410.3K/38.96%   4106.7K/55.82%
4KB             1254.8K/8.39%    2033.6K/15.86%   2165.3K/17.48%
8KB             1079.5K/7.7%     1143.1K/7.27%    1158.2K/7.33%
16KB            603.4K/3.64%     593.8K/3.4%      588.9K/3.77%
32KB            294.8K/2.04%     293.7K/1.98%     294.4K/2.93%
64KB            138.2K/1.32%     141.6K/1.26%     135.6K/1.34%

Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/nvme/host/rdma.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 92a03ff..7f8225d 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -146,6 +146,11 @@ static inline struct nvme_rdma_ctrl *to_rdma_ctrl(struct nvme_ctrl *ctrl)
 MODULE_PARM_DESC(register_always,
 	 "Use memory registration even for contiguous memory regions");
 
+static bool remote_invalidation = true;
+module_param(remote_invalidation, bool, 0444);
+MODULE_PARM_DESC(remote_invalidation,
+	 "request remote invalidation from subsystem (default: true)");
+
 static int nvme_rdma_cm_handler(struct rdma_cm_id *cm_id,
 		struct rdma_cm_event *event);
 static void nvme_rdma_recv_done(struct ib_cq *cq, struct ib_wc *wc);
@@ -1152,8 +1157,9 @@ static int nvme_rdma_map_sg_fr(struct nvme_rdma_queue *queue,
 	sg->addr = cpu_to_le64(req->mr->iova);
 	put_unaligned_le24(req->mr->length, sg->length);
 	put_unaligned_le32(req->mr->rkey, sg->key);
-	sg->type = (NVME_KEY_SGL_FMT_DATA_DESC << 4) |
-			NVME_SGL_FMT_INVALIDATE;
+	sg->type = NVME_KEY_SGL_FMT_DATA_DESC << 4;
+	if (remote_invalidation)
+		sg->type |= NVME_SGL_FMT_INVALIDATE;
 
 	return 0;
 }
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
