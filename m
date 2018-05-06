From: Alexandru Moise <00moses.alexander00@gmail.com>
Subject: [PATCH] nvmet,rxe: defer ip datagram sending to tasklet
Date: Mon, 7 May 2018 00:20:56 +0200
Message-ID: <20180506222056.GA10100@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: monis@mellanox.com, dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

When using NVME over Fabrics we may end up sending IP
packets in interrupt context, we should defer this work
to a tasklet.

[   50.939957] WARNING: CPU: 3 PID: 0 at kernel/softirq.c:161 __local_bh_enable_ip+0x1f/0xa0
[   50.942602] CPU: 3 PID: 0 Comm: swapper/3 Kdump: loaded Tainted: G        W         4.17.0-rc3-ARCH+ #104
[   50.945466] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-20171110_100015-anatol 04/01/2014
[   50.948163] RIP: 0010:__local_bh_enable_ip+0x1f/0xa0
[   50.949631] RSP: 0018:ffff88009c183900 EFLAGS: 00010006
[   50.951029] RAX: 0000000080010403 RBX: 0000000000000200 RCX: 0000000000000001
[   50.952636] RDX: 0000000000000000 RSI: 0000000000000200 RDI: ffffffff817e04ec
[   50.954278] RBP: ffff88009c183910 R08: 0000000000000001 R09: 0000000000000614
[   50.956000] R10: ffffea00021d5500 R11: 0000000000000001 R12: ffffffff817e04ec
[   50.957779] R13: 0000000000000000 R14: ffff88009566f400 R15: ffff8800956c7000
[   50.959402] FS:  0000000000000000(0000) GS:ffff88009c180000(0000) knlGS:0000000000000000
[   50.961552] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   50.963798] CR2: 000055c4ec0ccac0 CR3: 0000000002209001 CR4: 00000000000606e0
[   50.966121] Call Trace:
[   50.966845]  <IRQ>
[   50.967497]  __dev_queue_xmit+0x62d/0x690
[   50.968722]  dev_queue_xmit+0x10/0x20
[   50.969894]  neigh_resolve_output+0x173/0x190
[   50.971244]  ip_finish_output2+0x2b8/0x370
[   50.972527]  ip_finish_output+0x1d2/0x220
[   50.973785]  ? ip_finish_output+0x1d2/0x220
[   50.975010]  ip_output+0xd4/0x100
[   50.975903]  ip_local_out+0x3b/0x50
[   50.976823]  rxe_send+0x74/0x120
[   50.977702]  rxe_requester+0xe3b/0x10b0
[   50.978881]  ? ip_local_deliver_finish+0xd1/0xe0
[   50.980260]  rxe_do_task+0x85/0x100
[   50.981386]  rxe_run_task+0x2f/0x40
[   50.982470]  rxe_post_send+0x51a/0x550
[   50.983591]  nvmet_rdma_queue_response+0x10a/0x170
[   50.985024]  __nvmet_req_complete+0x95/0xa0
[   50.986287]  nvmet_req_complete+0x15/0x60
[   50.987469]  nvmet_bio_done+0x2d/0x40
[   50.988564]  bio_endio+0x12c/0x140
[   50.989654]  blk_update_request+0x185/0x2a0
[   50.990947]  blk_mq_end_request+0x1e/0x80
[   50.991997]  nvme_complete_rq+0x1cc/0x1e0
[   50.993171]  nvme_pci_complete_rq+0x117/0x120
[   50.994355]  __blk_mq_complete_request+0x15e/0x180
[   50.995988]  blk_mq_complete_request+0x6f/0xa0
[   50.997304]  nvme_process_cq+0xe0/0x1b0
[   50.998494]  nvme_irq+0x28/0x50
[   50.999572]  __handle_irq_event_percpu+0xa2/0x1c0
[   51.000986]  handle_irq_event_percpu+0x32/0x80
[   51.002356]  handle_irq_event+0x3c/0x60
[   51.003463]  handle_edge_irq+0x1c9/0x200
[   51.004473]  handle_irq+0x23/0x30
[   51.005363]  do_IRQ+0x46/0xd0
[   51.006182]  common_interrupt+0xf/0xf
[   51.007129]  </IRQ>

Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>
---
 drivers/infiniband/sw/rxe/rxe_verbs.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 2cb52fd48cf1..b84881077f8b 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -798,6 +798,9 @@ static int rxe_post_send_kernel(struct rxe_qp *qp, struct ib_send_wr *wr,
 	must_sched = (qp_type(qp) == IB_QPT_GSI) ||
 			(queue_count(qp->sq.queue) > 1);
 
+	if (in_irq())
+		must_sched = 1;
+
 	rxe_run_task(&qp->req.task, must_sched);
 	if (unlikely(qp->req.state == QP_STATE_ERROR))
 		rxe_run_task(&qp->comp.task, 1);
@@ -809,6 +812,7 @@ static int rxe_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			 struct ib_send_wr **bad_wr)
 {
 	struct rxe_qp *qp = to_rqp(ibqp);
+	int must_sched = 0;
 
 	if (unlikely(!qp->valid)) {
 		*bad_wr = wr;
@@ -821,8 +825,16 @@ static int rxe_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	}
 
 	if (qp->is_user) {
+		/*
+		 * NVME over fabrics can enter this path in
+		 * interrupt context, offload datagram
+		 * sending to rxe tasklet.
+		 */
+		if (in_irq())
+			must_sched = 1;
+
 		/* Utilize process context to do protocol processing */
-		rxe_run_task(&qp->req.task, 0);
+		rxe_run_task(&qp->req.task, must_sched);
 		return 0;
 	} else
 		return rxe_post_send_kernel(qp, wr, bad_wr);
-- 
2.17.0
