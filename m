From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH for-next 02/16] IB/{qib,
 hfi1}: Avoid flow control testing for RDMA write operation
Date: Mon, 21 Aug 2017 18:26:20 -0700
Message-ID: <20170822012619.32701.53092.stgit@scvm10.sc.intel.com>
References: <20170822011657.32701.22207.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170822011657.32701.22207.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

Section 9.7.7.2.5 of the 1.3 IBTA spec clearly says that receive
credits should never apply to RDMA write.

qib and hfi1 were doing that.  The following situation will result
in a QP hang:
- A prior SEND or RDMA_WRITE with immmediate consumed the last
  credit for a QP using RC receive buffer credits
- The prior op is acked so there are no more acks
- The peer ULP fails to post receive for some reason
- An RDMA write sees that the credits are exhausted and waits
- The peer ULP posts receive buffers
- The ULP posts a send or RDMA write that will be hung

The fix is to avoid the credit test for the RDMA write operation.

Cc: <stable@vger.kernel.org>
Reviewed-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/hw/hfi1/rc.c    |    3 ++-
 drivers/infiniband/hw/qib/qib_rc.c |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 99defcc..e1cf0c0 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -442,7 +442,7 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 		case IB_WR_RDMA_WRITE:
 			if (newreq && !(qp->s_flags & RVT_S_UNLIMITED_CREDIT))
 				qp->s_lsn++;
-			/* FALLTHROUGH */
+			goto no_flow_control;
 		case IB_WR_RDMA_WRITE_WITH_IMM:
 			/* If no credit, return. */
 			if (!(qp->s_flags & RVT_S_UNLIMITED_CREDIT) &&
@@ -450,6 +450,7 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 				qp->s_flags |= RVT_S_WAIT_SSN_CREDIT;
 				goto bail;
 			}
+no_flow_control:
 			put_ib_reth_vaddr(
 				wqe->rdma_wr.remote_addr,
 				&ohdr->u.rc.reth);
diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index 4ddbcac..e9a9173 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -348,7 +348,7 @@ int qib_make_rc_req(struct rvt_qp *qp, unsigned long *flags)
 		case IB_WR_RDMA_WRITE:
 			if (newreq && !(qp->s_flags & RVT_S_UNLIMITED_CREDIT))
 				qp->s_lsn++;
-			/* FALLTHROUGH */
+			goto no_flow_control;
 		case IB_WR_RDMA_WRITE_WITH_IMM:
 			/* If no credit, return. */
 			if (!(qp->s_flags & RVT_S_UNLIMITED_CREDIT) &&
@@ -356,7 +356,7 @@ int qib_make_rc_req(struct rvt_qp *qp, unsigned long *flags)
 				qp->s_flags |= RVT_S_WAIT_SSN_CREDIT;
 				goto bail;
 			}
-
+no_flow_control:
 			ohdr->u.rc.reth.vaddr =
 				cpu_to_be64(wqe->rdma_wr.remote_addr);
 			ohdr->u.rc.reth.rkey =
