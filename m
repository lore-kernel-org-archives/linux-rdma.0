From: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH 1/3] ib_core : Default value for automatic completion vector
	selection
Date: Thu, 13 May 2010 12:25:10 +0300
Message-ID: <4BEBC576.7050001@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

By using IB_CQ_VECTOR_LEAST_ATTACHED, we are letting the hw driver to choose
the completion vector that has the least number of CQ's already attached to it.

Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 include/rdma/ib_verbs.h |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index a585e0f..79b4d8f 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1453,6 +1453,13 @@ static inline int ib_post_recv(struct ib_qp *qp,
 	return qp->device->post_recv(qp, recv_wr, bad_recv_wr);
 }
 
+/*
+ * IB_CQ_VECTOR_LEAST_ATTACHED: The constant specifies that
+ *	the CQ will be attached to the completion vector that has
+ *	the least number of CQs already attached to it.
+ */
+#define IB_CQ_VECTOR_LEAST_ATTACHED	0xffffffff
+
 /**
  * ib_create_cq - Creates a CQ on the specified device.
  * @device: The device on which to create the CQ.
@@ -1464,7 +1471,8 @@ static inline int ib_post_recv(struct ib_qp *qp,
  *   the associated completion and event handlers.
  * @cqe: The minimum size of the CQ.
  * @comp_vector - Completion vector used to signal completion events.
- *     Must be >= 0 and < context->num_comp_vectors.
+ *     Must be >= 0 and < context->num_comp_vectors
+ *     or IB_CQ_VECTOR_LEAST_ATTACHED.
  *
  * Users can examine the cq structure to determine the actual CQ size.
  */
-- 
1.6.1.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
