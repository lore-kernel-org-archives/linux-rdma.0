From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH v3 9/9] nvmet-rdma: assign cq completion vector based on the port allowed cpus
Date: Wed,  8 Nov 2017 11:57:42 +0200
Message-ID: <20171108095742.25365-10-sagi@grimberg.me>
References: <20171108095742.25365-1-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171108095742.25365-1-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We take a cpu assignment from the port configured cpulist
(spread uniformly accross them) and pass it to the queue pair
as an affinity hint.

Note that if the rdma device does not expose a vector affinity mask,
or the core couldn't find a match, it will fallback to the old behavior
as we don't have sufficient information to do the "correct" vector
assignment.

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/nvme/target/rdma.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index d9cdfd2bd623..98d7f2ded511 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -892,7 +892,8 @@ static int nvmet_rdma_create_queue_ib(struct nvmet_rdma_queue *queue)
 {
 	struct ib_qp_init_attr qp_attr;
 	struct nvmet_rdma_device *ndev = queue->dev;
-	int ret, i;
+	struct nvmet_port *port = queue->port;
+	int ret, cpu, i;
 
 	memset(&qp_attr, 0, sizeof(qp_attr));
 	qp_attr.create_flags = IB_QP_CREATE_ASSIGN_CQS;
@@ -916,6 +917,14 @@ static int nvmet_rdma_create_queue_ib(struct nvmet_rdma_queue *queue)
 	else
 		qp_attr.cap.max_recv_sge = 2;
 
+	/*
+	 * Spread the io queues across port cpus,
+	 * but still keep all admin queues on cpu 0.
+	 */
+	cpu = !queue->host_qid ? 0 : port->cpus[queue->idx % port->nr_cpus];
+	qp_attr.affinity_hint = cpu;
+	qp_attr.create_flags |= IB_QP_CREATE_AFFINITY_HINT;
+
 	ret = rdma_create_qp(queue->cm_id, ndev->pd, &qp_attr);
 	if (ret) {
 		pr_err("failed to create_qp ret= %d\n", ret);
@@ -1052,6 +1061,7 @@ nvmet_rdma_alloc_queue(struct nvmet_rdma_device *ndev,
 	INIT_WORK(&queue->release_work, nvmet_rdma_release_queue_work);
 	queue->dev = ndev;
 	queue->cm_id = cm_id;
+	queue->port = cm_id->context;
 
 	spin_lock_init(&queue->state_lock);
 	queue->state = NVMET_RDMA_Q_CONNECTING;
@@ -1170,7 +1180,6 @@ static int nvmet_rdma_queue_connect(struct rdma_cm_id *cm_id,
 		ret = -ENOMEM;
 		goto put_device;
 	}
-	queue->port = cm_id->context;
 
 	if (queue->host_qid == 0) {
 		/* Let inflight controller teardown complete */
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
