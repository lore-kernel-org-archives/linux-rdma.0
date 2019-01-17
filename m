From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 1/2] RDMA/srp: Avoid calling mutex_lock() from inside scsi_queue_rq()
Date: Wed, 16 Jan 2019 16:27:16 -0800
Message-ID: <20190117002717.84686-2-bvanassche@acm.org>
References: <20190117002717.84686-1-bvanassche@acm.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190117002717.84686-1-bvanassche@acm.org>
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, Sergey Gorenko <sergeygo@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Laurence Oberman <loberman@redhat.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

srp_queuecommand() can be called from the following contexts:
* From inside scsi_queue_rq(). This function can be called by several
  kernel threads, including the SCSI error handler thread.
* From inside scsi_send_eh_cmnd(). This function is only called from the
  SCSI error handler thread.

In scsi-mq mode it is not allowed to sleep inside srp_queuecommand()
since the flag BLK_MQ_F_BLOCKING has not been set. Since setting the
request queue flag BLK_MQ_F_BLOCKING would slow down the hot path, make
srp_queuecommand() skip the mutex_lock() and mutex_unlock() calls when
called from inside scsi_queue_rq() from the SCSI EH thread.

This patch avoids that the following appears in the kernel log:

BUG: sleeping function called from invalid context at kernel/locking/mutex.c:908
in_atomic(): 1, irqs_disabled(): 0, pid: 30974, name: scsi_eh_4
INFO: lockdep is turned off.
Preemption disabled at:
[<ffffffff816b1d65>] __blk_mq_delay_run_hw_queue+0x185/0x290
CPU: 3 PID: 30974 Comm: scsi_eh_4 Not tainted 4.20.0-rc6-dbg+ #6
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
Call Trace:
 dump_stack+0x86/0xca
 ___might_sleep.cold.80+0x128/0x139
 __might_sleep+0x71/0xe0
 __mutex_lock+0xc8/0xbe0
 mutex_lock_nested+0x1b/0x20
 srp_queuecommand+0x7f2/0x19a0 [ib_srp]
 scsi_dispatch_cmd+0x15d/0x510
 scsi_queue_rq+0x123/0xa90
 blk_mq_dispatch_rq_list+0x678/0xc20
 blk_mq_sched_dispatch_requests+0x25c/0x310
 __blk_mq_run_hw_queue+0xd6/0x180
 __blk_mq_delay_run_hw_queue+0x262/0x290
 blk_mq_run_hw_queue+0x11f/0x1b0
 blk_mq_run_hw_queues+0x87/0xb0
 scsi_run_queue+0x402/0x6f0
 scsi_run_host_queues+0x30/0x50
 scsi_error_handler+0x2d3/0xa80
 kthread+0x1cf/0x1f0
 ret_from_fork+0x24/0x30

Cc: Sergey Gorenko <sergeygo@mellanox.com>
Cc: Max Gurtovoy <maxg@mellanox.com>
Cc: Laurence Oberman <loberman@redhat.com>
Cc: <stable@vger.kernel.org>
Fixes: a95cadb9dafe ("IB/srp: Add periodic reconnect functionality") # v3.13
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 31d91538bbf4..23e5c9afb8fb 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2352,13 +2352,19 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	u32 tag;
 	u16 idx;
 	int len, ret;
-	const bool in_scsi_eh = !in_interrupt() && current == shost->ehandler;
+	const bool in_scsi_eh = !in_interrupt() && current == shost->ehandler
+		&& rcu_preempt_depth() == 0;
 
 	/*
-	 * The SCSI EH thread is the only context from which srp_queuecommand()
-	 * can get invoked for blocked devices (SDEV_BLOCK /
+	 * The scsi_send_eh_cmnd() function is the only function that can call
+	 * .queuecommand() for blocked devices (SDEV_BLOCK /
 	 * SDEV_CREATED_BLOCK). Avoid racing with srp_reconnect_rport() by
-	 * locking the rport mutex if invoked from inside the SCSI EH.
+	 * locking the rport mutex if invoked from inside that function.
+	 * Recognize this context by checking whether called from the SCSI EH
+	 * thread and whether no RCU read lock is held. If
+	 * blk_mq_run_hw_queues() is called from the context of the SCSI EH
+	 * thread then an RCU read lock is held around scsi_queue_rq() calls
+	 * becase the SRP driver does not set BLK_MQ_F_BLOCKING.
 	 */
 	if (in_scsi_eh)
 		mutex_lock(&rport->mutex);
-- 
2.20.1.97.g81188d93c3-goog
