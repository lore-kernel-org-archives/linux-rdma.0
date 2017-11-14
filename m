From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH for-next 6/6] IB/qib: Fix comparison error with qperf
 compare/swap test
Date: Tue, 14 Nov 2017 04:34:52 -0800
Message-ID: <20171114123450.10579.77204.stgit@scvm10.sc.intel.com>
References: <20171114122859.10579.79788.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171114122859.10579.79788.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

This failure exists with qib:

ver_rc_compare_swap:
mismatch, sequence 2, expected 123456789abcdef, got 0

The request builder was using the incorrect inlines to
build the request header resulting in incorrect data
in the atomic header.

Fix by using the appropriate inlines to create the request.

Cc: <stable@vger.kernel.org> # 4.9.x+
Fixes: 261a4351844b ("IB/qib,IB/hfi: Use core common header file")
Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/hw/qib/qib_rc.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index 8f5754f..e4a9ba1 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -434,13 +434,13 @@ int qib_make_rc_req(struct rvt_qp *qp, unsigned long *flags)
 				qp->s_state = OP(COMPARE_SWAP);
 				put_ib_ateth_swap(wqe->atomic_wr.swap,
 						  &ohdr->u.atomic_eth);
-				put_ib_ateth_swap(wqe->atomic_wr.compare_add,
-						  &ohdr->u.atomic_eth);
+				put_ib_ateth_compare(wqe->atomic_wr.compare_add,
+						     &ohdr->u.atomic_eth);
 			} else {
 				qp->s_state = OP(FETCH_ADD);
 				put_ib_ateth_swap(wqe->atomic_wr.compare_add,
 						  &ohdr->u.atomic_eth);
-				put_ib_ateth_swap(0, &ohdr->u.atomic_eth);
+				put_ib_ateth_compare(0, &ohdr->u.atomic_eth);
 			}
 			put_ib_ateth_vaddr(wqe->atomic_wr.remote_addr,
 					   &ohdr->u.atomic_eth);
