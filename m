From: Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH 2/3] IB/nes: use setup_timer
Date: Sat, 22 Apr 2017 09:32:55 +0800
Message-ID: <0423fafd41100d763a51d6b30bc10a135f245f76.1491892717.git.geliangtang@gmail.com>
References: <628d01a8e7c4f93acaa1a6e91f739131704c2ff4.1491892717.git.geliangtang@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <628d01a8e7c4f93acaa1a6e91f739131704c2ff4.1491892717.git.geliangtang@gmail.com>
In-Reply-To: <628d01a8e7c4f93acaa1a6e91f739131704c2ff4.1491892717.git.geliangtang@gmail.com>
References: <628d01a8e7c4f93acaa1a6e91f739131704c2ff4.1491892717.git.geliangtang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Faisal Latif <faisal.latif@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Use setup_timer() instead of init_timer() to simplify the code.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/infiniband/hw/nes/nes_hw.c    | 5 ++---
 drivers/infiniband/hw/nes/nes_mgt.c   | 5 ++---
 drivers/infiniband/hw/nes/nes_verbs.c | 5 ++---
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index 19acd13..5f77f0b 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -1849,9 +1849,8 @@ int nes_init_nic_qp(struct nes_device *nesdev, struct net_device *netdev)
 		wqe_count -= counter;
 		nes_write32(nesdev->regs+NES_WQE_ALLOC, (counter << 24) | nesvnic->nic.qp_id);
 	} while (wqe_count);
-	init_timer(&nesvnic->rq_wqes_timer);
-	nesvnic->rq_wqes_timer.function = nes_rq_wqes_timeout;
-	nesvnic->rq_wqes_timer.data = (unsigned long)nesvnic;
+	setup_timer(&nesvnic->rq_wqes_timer, nes_rq_wqes_timeout,
+		    (unsigned long)nesvnic);
 	nes_debug(NES_DBG_INIT, "NAPI support Enabled\n");
 	if (nesdev->nesadapter->et_use_adaptive_rx_coalesce)
 	{
diff --git a/drivers/infiniband/hw/nes/nes_mgt.c b/drivers/infiniband/hw/nes/nes_mgt.c
index 33624f1..77226cf 100644
--- a/drivers/infiniband/hw/nes/nes_mgt.c
+++ b/drivers/infiniband/hw/nes/nes_mgt.c
@@ -1040,9 +1040,8 @@ int nes_init_mgt_qp(struct nes_device *nesdev, struct net_device *netdev, struct
 			mgtvnic->mgt.rx_skb[counter] = skb;
 		}
 
-		init_timer(&mgtvnic->rq_wqes_timer);
-		mgtvnic->rq_wqes_timer.function = nes_mgt_rq_wqes_timeout;
-		mgtvnic->rq_wqes_timer.data = (unsigned long)mgtvnic;
+		setup_timer(&mgtvnic->rq_wqes_timer, nes_mgt_rq_wqes_timeout,
+			    (unsigned long)mgtvnic);
 
 		wqe_count = NES_MGT_WQ_COUNT - 1;
 		mgtvnic->mgt.rq_head = wqe_count;
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index ccf0a4c..6913237 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -1308,9 +1308,8 @@ static struct ib_qp *nes_create_qp(struct ib_pd *ibpd,
 	init_completion(&nesqp->rq_drained);
 
 	nesqp->sig_all = (init_attr->sq_sig_type == IB_SIGNAL_ALL_WR);
-	init_timer(&nesqp->terminate_timer);
-	nesqp->terminate_timer.function = nes_terminate_timeout;
-	nesqp->terminate_timer.data = (unsigned long)nesqp;
+	setup_timer(&nesqp->terminate_timer, nes_terminate_timeout,
+		    (unsigned long)nesqp);
 
 	/* update the QP table */
 	nesdev->nesadapter->qp_table[nesqp->hwqp.qp_id-NES_FIRST_QPN] = nesqp;
-- 
2.9.3
