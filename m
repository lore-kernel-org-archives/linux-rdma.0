From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 2/2] RDMA/srp: Rework SCSI device reset handling
Date: Wed, 16 Jan 2019 16:27:17 -0800
Message-ID: <20190117002717.84686-3-bvanassche@acm.org>
References: <20190117002717.84686-1-bvanassche@acm.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190117002717.84686-1-bvanassche@acm.org>
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, Sergey Gorenko <sergeygo@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Laurence Oberman <loberman@redhat.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Since .scsi_done() must only be called after scsi_queue_rq() has
finished, make sure that the SRP initiator driver does not call
.scsi_done() while scsi_queue_rq() is in progress. Although
invoking sg_reset -d while I/O is in progress works fine with kernel
v4.20 and before, that is not the case with kernel v5.0-rc1. This
patch avoids that the following crash is triggered with kernel
v5.0-rc1:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000138
CPU: 0 PID: 360 Comm: kworker/0:1H Tainted: G    B             5.0.0-rc1-dbg+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
Workqueue: kblockd blk_mq_run_work_fn
RIP: 0010:blk_mq_dispatch_rq_list+0x116/0xb10
Call Trace:
 blk_mq_sched_dispatch_requests+0x2f7/0x300
 __blk_mq_run_hw_queue+0xd6/0x180
 blk_mq_run_work_fn+0x27/0x30
 process_one_work+0x4f1/0xa20
 worker_thread+0x67/0x5b0
 kthread+0x1cf/0x1f0
 ret_from_fork+0x24/0x30

Cc: Sergey Gorenko <sergeygo@mellanox.com>
Cc: Max Gurtovoy <maxg@mellanox.com>
Cc: Laurence Oberman <loberman@redhat.com>
Cc: <stable@vger.kernel.org>
Fixes: 94a9174c630c ("IB/srp: reduce lock coverage of command completion") # v2.6.38
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 23e5c9afb8fb..f7ccbb07321b 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3036,9 +3036,11 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 
 static int srp_reset_device(struct scsi_cmnd *scmnd)
 {
-	struct srp_target_port *target = host_to_target(scmnd->device->host);
+	struct scsi_device *sdev = scmnd->device;
+	struct srp_target_port *target = host_to_target(sdev->host);
 	struct srp_rdma_ch *ch;
-	int i, j;
+	struct request_queue *q = sdev->request_queue;
+	int time_left;
 	u8 status;
 
 	shost_printk(KERN_ERR, target->scsi_host, "SRP reset_device called\n");
@@ -3050,16 +3052,12 @@ static int srp_reset_device(struct scsi_cmnd *scmnd)
 	if (status)
 		return FAILED;
 
-	for (i = 0; i < target->ch_count; i++) {
-		ch = &target->ch[i];
-		for (j = 0; j < target->req_ring_size; ++j) {
-			struct srp_request *req = &ch->req_ring[j];
-
-			srp_finish_req(ch, req, scmnd->device, DID_RESET << 16);
-		}
-	}
+	/* Check whether all requests have finished. */
+	blk_freeze_queue_start(q);
+	time_left = blk_mq_freeze_queue_wait_timeout(q, 1 * HZ);
+	blk_mq_unfreeze_queue(q);
 
-	return SUCCESS;
+	return time_left > 0 ? SUCCESS : FAILED;
 }
 
 static int srp_reset_host(struct scsi_cmnd *scmnd)
-- 
2.20.1.97.g81188d93c3-goog
