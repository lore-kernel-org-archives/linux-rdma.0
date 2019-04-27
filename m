From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.0 24/79] IB/hfi1: Clear the IOWAIT pending bits when QP is put into error state
Date: Fri, 26 Apr 2019 21:37:43 -0400
Message-ID: <20190427013838.6596-24-sashal@kernel.org>
References: <20190427013838.6596-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190427013838.6596-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Kaike Wan <kaike.wan@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Jason Gunthorpe <jgg@mellanox.com>, Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

[ Upstream commit 93b289b9aff66eca7575b09f36f5abbeca8e6167 ]

When a QP is put into error state, it may be waiting for send engine
resources. In this case, the QP will be removed from the send engine's
waiting list, but its IOWAIT pending bits are not cleared. This will
normally not have any major impact as the QP is being destroyed.  However,
the QP still needs to wind down its operations, such as draining the send
queue by scheduling the send engine. Clearing the pending bits will avoid
any potential complications. In addition, if the QP will eventually hang,
clearing the pending bits can help debugging by presenting a consistent
picture if the user dumps the qp_stats.

This patch clears a QP's IOWAIT_PENDING_IB and IO_PENDING_TID bits in
priv->s_iowait.flags in this case.

Fixes: 5da0fc9dbf89 ("IB/hfi1: Prepare resource waits for dual leg")
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Reviewed-by: Alex Estrin <alex.estrin@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/qp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
index 5866f358ea04..df8e812804b3 100644
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
@@ -834,6 +834,8 @@ void notify_error_qp(struct rvt_qp *qp)
 		if (!list_empty(&priv->s_iowait.list) &&
 		    !(qp->s_flags & RVT_S_BUSY)) {
 			qp->s_flags &= ~HFI1_S_ANY_WAIT_IO;
+			iowait_clear_flag(&priv->s_iowait, IOWAIT_PENDING_IB);
+			iowait_clear_flag(&priv->s_iowait, IOWAIT_PENDING_TID);
 			list_del_init(&priv->s_iowait.list);
 			priv->s_iowait.lock = NULL;
 			rvt_put_qp(qp);
-- 
2.19.1
