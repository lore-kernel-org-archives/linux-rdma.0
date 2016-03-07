From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 07/10] IB/hfi1: Fix panic in adaptive pio
Date: Mon, 07 Mar 2016 11:35:35 -0800
Message-ID: <20160307193535.4913.99009.stgit@scvm10.sc.intel.com>
References: <20160307193146.4913.42900.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160307193146.4913.42900.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The following panic occurs while running ib_send_bw -a with
adaptive pio turned on:

[ 8551.143596] BUG: unable to handle kernel NULL pointer dereference at (null)
[ 8551.152986] IP: [<ffffffffa0902a94>] pio_wait.isra.21+0x34/0x190 [hfi1]
[ 8551.160926] PGD 80db21067 PUD 80bb45067 PMD 0
[ 8551.166431] Oops: 0000 [#1] SMP
[ 8551.276725] task: ffff880816bf15c0 ti: ffff880812ac0000 task.ti: ffff880812ac0000
[ 8551.285705] RIP: 0010:[<ffffffffa0902a94>] pio_wait.isra.21+0x34/0x190 [hfi1]
[ 8551.296462] RSP: 0018:ffff880812ac3b58  EFLAGS: 00010282
[ 8551.303029] RAX: 000000000000002d RBX: 0000000000000000 RCX: 0000000000000800
[ 8551.311633] RDX: ffff880812ac3c08 RSI: 0000000000000000 RDI: ffff8800b6665e40
[ 8551.320228] RBP: ffff880812ac3ba0 R08: 0000000000001000 R09: ffffffffa09039a0
[ 8551.328820] R10: ffff880817a0c000 R11: 0000000000000000 R12: ffff8800b6665e40
[ 8551.337406] R13: ffff880817a0c000 R14: ffff8800b6665800 R15: ffff8800b6665e40
[ 8551.355640] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 8551.362674] CR2: 0000000000000000 CR3: 000000080abe8000 CR4: 00000000001406e0
[ 8551.371262] Stack:
[ 8551.374119]  ffff880812ac3bf0 ffff88080cf54010 ffff880800000800 ffff880812ac3c08
[ 8551.383036]  ffff8800b6665800 ffff8800b6665e40 0000000000000202 ffffffffa08e7b80
[ 8551.391941]  00000001007de431 ffff880812ac3bc8 ffffffffa0904645 ffff8800b6665800
[ 8551.400859] Call Trace:
[ 8551.404214]  [<ffffffffa08e7b80>] ? hfi1_del_timers_sync+0x30/0x30 [hfi1]
[ 8551.412417]  [<ffffffffa0904645>] hfi1_verbs_send+0x215/0x330 [hfi1]
[ 8551.420154]  [<ffffffffa08ec126>] hfi1_do_send+0x166/0x350 [hfi1]
[ 8551.427618]  [<ffffffffa055a533>] rvt_post_send+0x533/0x6a0 [rdmavt]
[ 8551.435367]  [<ffffffffa050760f>] ib_uverbs_post_send+0x30f/0x530 [ib_uverbs]
[ 8551.443999]  [<ffffffffa0501367>] ib_uverbs_write+0x117/0x380 [ib_uverbs]
[ 8551.452269]  [<ffffffff815810ab>] ? sock_recvmsg+0x3b/0x50
[ 8551.459071]  [<ffffffff81581152>] ? sock_read_iter+0x92/0xe0
[ 8551.466068]  [<ffffffff81212857>] __vfs_write+0x37/0x100
[ 8551.472692]  [<ffffffff81213532>] ? rw_verify_area+0x52/0xd0
[ 8551.479682]  [<ffffffff81213782>] vfs_write+0xa2/0x1a0
[ 8551.486089]  [<ffffffff81003176>] ? do_audit_syscall_entry+0x66/0x70
[ 8551.493891]  [<ffffffff812146c5>] SyS_write+0x55/0xc0
[ 8551.500220]  [<ffffffff816ae0ee>] entry_SYSCALL_64_fastpath+0x12/0x71
[ 8551.531284] RIP  [<ffffffffa0902a94>] pio_wait.isra.21+0x34/0x190 [hfi1]
[ 8551.539508]  RSP <ffff880812ac3b58>
[ 8551.544110] CR2: 0000000000000000

The priv s_sendcontext pointer was not setup properly.  Fix with this
patch by using the s_sendcontext and eliminating its send engine use.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/qp.c    |    2 ++
 drivers/infiniband/hw/hfi1/verbs.c |    6 +-----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
index ce5d2c2..dfbb7b1 100644
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
@@ -220,6 +220,7 @@ void hfi1_modify_qp(struct rvt_qp *qp, struct ib_qp_attr *attr,
 	if (attr_mask & IB_QP_AV) {
 		priv->s_sc = ah_to_sc(ibqp->device, &qp->remote_ah_attr);
 		priv->s_sde = qp_to_sdma_engine(qp, priv->s_sc);
+		priv->s_sendcontext = qp_to_send_context(qp, priv->s_sc);
 	}
 
 	if (attr_mask & IB_QP_PATH_MIG_STATE &&
@@ -228,6 +229,7 @@ void hfi1_modify_qp(struct rvt_qp *qp, struct ib_qp_attr *attr,
 		qp->s_flags |= RVT_S_AHG_CLEAR;
 		priv->s_sc = ah_to_sc(ibqp->device, &qp->remote_ah_attr);
 		priv->s_sde = qp_to_sdma_engine(qp, priv->s_sc);
+		priv->s_sendcontext = qp_to_send_context(qp, priv->s_sc);
 	}
 }
 
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 467e6c3..7acaa25 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1005,12 +1005,8 @@ int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 
 	/* vl15 special case taken care of in ud.c */
 	sc5 = priv->s_sc;
-	sc = qp_to_send_context(qp, sc5);
+	sc = ps->s_txreq->psc;
 
-	if (!sc) {
-		ret = -EINVAL;
-		goto bail;
-	}
 	if (likely(pbc == 0)) {
 		u8 vl = sc_to_vlt(dd_from_ibdev(qp->ibqp.device), sc5);
 		/* set PBC_DC_INFO bit (aka SC[4]) in pbc_flags */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
