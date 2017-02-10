From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 4/5] IB/hfi1: Use memdup_user() rather than duplicating its
 implementation in hfi1_user_sdma_process_request()
Date: Fri, 10 Feb 2017 22:04:38 +0100
Message-ID: <b19e44b3-601f-c642-b8d3-12c000511ce2@users.sourceforge.net>
References: <8a997282-09c7-0f9f-645e-d7c6e8c79e67@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8a997282-09c7-0f9f-645e-d7c6e8c79e67@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Sean Hefty <sean.hefty@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 10 Feb 2017 21:01:55 +0100

Reuse existing functionality from memdup_user() instead of keeping
duplicate source code.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/hfi1/user_sdma.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 991e7f3d8e18..5a73d738f2ba 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -731,23 +731,18 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 			ret = -EINVAL;
 			goto free_req;
 		}
-		req->tids = kcalloc(ntids, sizeof(*req->tids), GFP_KERNEL);
-		if (!req->tids) {
-			ret = -ENOMEM;
-			goto free_req;
-		}
 		/*
 		 * We have to copy all of the tids because they may vary
 		 * in size and, therefore, the TID count might not be
 		 * equal to the pkt count. However, there is no way to
 		 * tell at this point.
 		 */
-		ret = copy_from_user(req->tids, iovec[idx].iov_base,
-				     ntids * sizeof(*req->tids));
-		if (ret) {
+		req->tids = memdup_user(iovec[idx].iov_base,
+					sizeof(*req->tids) * ntids);
+		if (IS_ERR(req->tids)) {
+			ret = PTR_ERR(req->tids);
 			SDMA_DBG(req, "Failed to copy %d TIDs (%d)",
 				 ntids, ret);
-			ret = -EFAULT;
 			goto free_req;
 		}
 		req->n_tids = ntids;
@@ -1606,7 +1601,8 @@ static void user_sdma_free_request(struct user_sdma_request *req, bool unpin)
 				atomic_dec(&node->refcount);
 		}
 	}
-	kfree(req->tids);
+	if (!IS_ERR(req->tids))
+		kfree(req->tids);
 	clear_bit(req->info.comp_idx, req->pq->req_in_use);
 }
 
-- 
2.11.1
