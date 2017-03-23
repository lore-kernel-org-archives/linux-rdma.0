From: Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
Subject: [PATCH RFC] nvme-rdma: support devices with queue size < 32
Date: Thu, 23 Mar 2017 10:04:09 +0100 (CET)
Message-ID: <1315914765.312051621.1490259849534.JavaMail.zimbra@kalray.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
Cc: Samuel Jones <samuel.jones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In the case of small NVMe-oF queue size (<32) we may enter
a deadlock caused by the fact that the IB completions aren't sent
waiting for 32 and the send queue will fill up.

The error is seen as (using mlx5):
[ 2048.693355] mlx5_0:mlx5_ib_post_send:3765:(pid 7273):
[ 2048.693360] nvme nvme1: nvme_rdma_post_send failed with error code -12

The patch doesn't change the behaviour for remote devices with
larger queues.

Signed-off-by: Marta Rybczynska <marta.rybczynska-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
Signed-off-by: Samuel Jones <sjones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
---
 drivers/nvme/host/rdma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 779f516..8ea4cba 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1023,6 +1023,7 @@ static int nvme_rdma_post_send(struct nvme_rdma_queue *queue,
 {
        struct ib_send_wr wr, *bad_wr;
        int ret;
+       int sig_limit;
 
        sge->addr   = qe->dma;
        sge->length = sizeof(struct nvme_command),
@@ -1054,7 +1055,8 @@ static int nvme_rdma_post_send(struct nvme_rdma_queue *queue,
         * embedded in request's payload, is not freed when __ib_process_cq()
         * calls wr_cqe->done().
         */
-       if ((++queue->sig_count % 32) == 0 || flush)
+       sig_limit = min(queue->queue_size, 32);
+       if ((++queue->sig_count % sig_limit) == 0 || flush)
                wr.send_flags |= IB_SEND_SIGNALED;
 
        if (first)
-- 
1.8.3.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
