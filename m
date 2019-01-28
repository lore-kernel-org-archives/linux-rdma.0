From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 072/170] IB/hfi1: Unreserve a reserved request when it is completed
Date: Mon, 28 Jan 2019 11:10:22 -0500
Message-ID: <20190128161200.55107-72-sashal@kernel.org>
References: <20190128161200.55107-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190128161200.55107-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Kaike Wan <kaike.wan@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Jason Gunthorpe <jgg@mellanox.com>, Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

[ Upstream commit ca95f802ef5139722acc8d30aeaab6fe5bbe939e ]

Currently, When a reserved operation is completed, its entry in the send
queue will not be unreserved, which leads to the miscalculation of
qp->s_avail and thus the triggering of a WARN_ON call trace. This patch
fixes the problem by unreserving the reserved operation when it is
completed.

Fixes: 856cc4c237ad ("IB/hfi1: Add the capability for reserved operations")
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/rc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 818bac1a4056..d3b8cb92fd6d 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -1162,6 +1162,7 @@ void hfi1_rc_send_complete(struct rvt_qp *qp, struct hfi1_opa_header *opah)
 		if (cmp_psn(wqe->lpsn, qp->s_sending_psn) >= 0 &&
 		    cmp_psn(qp->s_sending_psn, qp->s_sending_hpsn) <= 0)
 			break;
+		rvt_qp_wqe_unreserve(qp, wqe);
 		s_last = qp->s_last;
 		trace_hfi1_qp_send_completion(qp, wqe, s_last);
 		if (++s_last >= qp->s_size)
@@ -1214,6 +1215,7 @@ static struct rvt_swqe *do_rc_completion(struct rvt_qp *qp,
 		u32 s_last;
 
 		rvt_put_swqe(wqe);
+		rvt_qp_wqe_unreserve(qp, wqe);
 		s_last = qp->s_last;
 		trace_hfi1_qp_send_completion(qp, wqe, s_last);
 		if (++s_last >= qp->s_size)
-- 
2.19.1
