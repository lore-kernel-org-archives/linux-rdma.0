From: Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
Subject: [PATCH v4, under testing] nvme-rdma: support devices with queue
 size < 32
Date: Wed, 3 May 2017 12:05:15 +0200 (CEST)
Message-ID: <79901165.5342369.1493805915415.JavaMail.zimbra@kalray.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, axboe-b10kYP2dOMg@public.gmane.org, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, samuel jones <samuel.jones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In the case of small NVMe-oF queue size (<32) we may enter
a deadlock caused by the fact that the IB completions aren't sent
waiting for 32 and the send queue will fill up.

The error is seen as (using mlx5):
[ 2048.693355] mlx5_0:mlx5_ib_post_send:3765:(pid 7273):
[ 2048.693360] nvme nvme1: nvme_rdma_post_send failed with error code -12

This patch changes the way the signalling is done so
that it depends on the queue depth now. The magic define has
been removed completely. It also reworks the signalling
code to use atomic operations.

Signed-off-by: Marta Rybczynska <marta.rybczynska-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
Signed-off-by: Samuel Jones <sjones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
[v1]

---

Changes in v4:
* use atomic operations as suggested by Sagi

Changes in v3:
* avoid division in the fast path
* reverse sig_count logic to simplify the code: it now counts down
  from the queue depth/2 to 0
* change sig_count to int to avoid overflows for big queues

Changes in v2:
* signal by queue size/2, remove hardcoded 32
* support queue depth of 1
---
 drivers/nvme/host/rdma.c | 40 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 35 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 16f84eb..234b010 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -88,7 +88,7 @@ enum nvme_rdma_queue_flags {
 
 struct nvme_rdma_queue {
        struct nvme_rdma_qe     *rsp_ring;
-       u8                      sig_count;
+       atomic_t                sig_count;
        int                     queue_size;
        size_t                  cmnd_capsule_len;
        struct nvme_rdma_ctrl   *ctrl;
@@ -257,6 +257,15 @@ static int nvme_rdma_wait_for_cm(struct nvme_rdma_queue *queue)
        return queue->cm_error;
 }
 
+static inline int nvme_rdma_init_sig_count(int queue_size)
+{
+       /* We signal completion every queue depth/2 and also
+        * handle the case of possible device with queue_depth=1,
+        * where we would need to signal every message.
+        */
+       return max(queue_size / 2, 1);
+}
+
 static int nvme_rdma_create_qp(struct nvme_rdma_queue *queue, const int factor)
 {
        struct nvme_rdma_device *dev = queue->device;
@@ -561,6 +570,8 @@ static int nvme_rdma_init_queue(struct nvme_rdma_ctrl *ctrl,
 
        queue->queue_size = queue_size;
 
+       atomic_set(&queue->sig_count, nvme_rdma_init_sig_count(queue_size));
+
        queue->cm_id = rdma_create_id(&init_net, nvme_rdma_cm_handler, queue,
                        RDMA_PS_TCP, IB_QPT_RC);
        if (IS_ERR(queue->cm_id)) {
@@ -1029,6 +1040,28 @@ static void nvme_rdma_send_done(struct ib_cq *cq, struct ib_wc *wc)
                nvme_rdma_wr_error(cq, wc, "SEND");
 }
 
+static inline bool nvme_rdma_queue_sig_limit(struct nvme_rdma_queue *queue)
+{
+       int v, old;
+
+       v = atomic_read(&queue->sig_count);
+       while (1) {
+               if (v > 1) {
+                       old = atomic_cmpxchg(&queue->sig_count, v, v - 1);
+                       if (old == v)
+                               return false;
+               } else {
+                       int new_count;
+
+                       new_count = nvme_rdma_init_sig_count(queue->queue_size);
+                       old = atomic_cmpxchg(&queue->sig_count, v, new_count);
+                       if (old == v)
+                               return true;
+               }
+               v = old;
+       }
+}
+
 static int nvme_rdma_post_send(struct nvme_rdma_queue *queue,
                struct nvme_rdma_qe *qe, struct ib_sge *sge, u32 num_sge,
                struct ib_send_wr *first, bool flush)
@@ -1056,9 +1089,6 @@ static int nvme_rdma_post_send(struct nvme_rdma_queue *queue,
         * Would have been way to obvious to handle this in hardware or
         * at least the RDMA stack..
         *
-        * This messy and racy code sniplet is copy and pasted from the iSER
-        * initiator, and the magic '32' comes from there as well.
-        *
         * Always signal the flushes. The magic request used for the flush
         * sequencer is not allocated in our driver's tagset and it's
         * triggered to be freed by blk_cleanup_queue(). So we need to
@@ -1066,7 +1096,7 @@ static int nvme_rdma_post_send(struct nvme_rdma_queue *queue,
         * embedded in request's payload, is not freed when __ib_process_cq()
         * calls wr_cqe->done().
         */
-       if ((++queue->sig_count % 32) == 0 || flush)
+       if (nvme_rdma_queue_sig_limit(queue) || flush)
                wr.send_flags |= IB_SEND_SIGNALED;
 
        if (first)
-- 
1.8.3.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
