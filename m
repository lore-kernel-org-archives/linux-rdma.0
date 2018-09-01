From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] infiniband: core: mad: Fix a sleep-in-atomic-context bug in ib_mad_recv_done()
Date: Sat,  1 Sep 2018 20:06:59 +0800
Message-ID: <20180901120659.32509-1-baijiaju1990@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com, jgg@ziepe.ca, leon@kernel.org, ira.weiny@intel.com, pravin.shedge4linux@gmail.com, hal@mellanox.com, parav@mellanox.com, haakon.bugge@oracle.com, bart.vanassche@sandisk.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
List-Id: linux-rdma@vger.kernel.org

The driver may sleep with holding a spinlock.

The function call paths (from bottom to top) in Linux-4.16 are:

[FUNC] alloc_mad_private(GFP_KERNEL)
drivers/infiniband/core/mad.c, 2264: 
	alloc_mad_private in ib_mad_recv_done
drivers/infiniband/core/cq.c, 45: 
	[FUNC_PTR]ib_mad_recv_done in __ib_process_cq
drivers/infiniband/core/cq.c, 77: 
	__ib_process_cq in ib_process_cq_direct
drivers/infiniband/ulp/srp/ib_srp.c, 2010: 
	ib_process_cq_direct in __srp_get_tx_iu
drivers/infiniband/ulp/srp/ib_srp.c, 2353: 
	__srp_get_tx_iu in srp_queuecommand
drivers/infiniband/ulp/srp/ib_srp.c, 2352: 
	_raw_spin_lock_irqsave in srp_queuecommand

[FUNC] alloc_mad_private(GFP_KERNEL)
drivers/infiniband/core/mad.c, 2264: 
	alloc_mad_private in ib_mad_recv_done
drivers/infiniband/core/cq.c, 45: 
	[FUNC_PTR]ib_mad_recv_done in __ib_process_cq
drivers/infiniband/core/cq.c, 77: 
	__ib_process_cq in ib_process_cq_direct
drivers/infiniband/ulp/srp/ib_srp.c, 2010: 
	ib_process_cq_direct in __srp_get_tx_iu
drivers/infiniband/ulp/srp/ib_srp.c, 2903: 
	__srp_get_tx_iu in srp_send_tsk_mgmt
drivers/infiniband/ulp/srp/ib_srp.c, 2902: 
	spin_lock_irq in srp_send_tsk_mgmt

To fix this bug, GFP_KERNEL is replaced with GFP_ATOMIC.

This bug is found by my static analysis tool DSAC.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/infiniband/core/mad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index f742ae7a768b..0db954f6958a 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -2263,7 +2263,7 @@ static void ib_mad_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		goto out;
 
 	mad_size = recv->mad_size;
-	response = alloc_mad_private(mad_size, GFP_KERNEL);
+	response = alloc_mad_private(mad_size, GFP_ATOMIC);
 	if (!response)
 		goto out;
 
-- 
2.17.0
