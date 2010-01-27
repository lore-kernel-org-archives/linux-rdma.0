From: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH 2/2] ib/ehca: allow access for ib_query_qp()
Date: Wed, 27 Jan 2010 18:03:08 +0100
Message-ID: <20100127180308.5155480d@alex-laptop>
References: <20100127180035.779b24d1@alex-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100127180035.779b24d1@alex-laptop>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stefan Roscher <stefan.roscher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Joachim Fenkes <fenkes-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Hoang-Nam Nguyen <HNGUYEN-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Wilder <wilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The max_dest_rd_atomic and max_qp_rd_atomic values are
properly returned by query_qp(), so there should not be
an error returned when they are queried.

Signed-off-by: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/infiniband/hw/ehca/ehca_qp.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- linux-2.6.orig/drivers/infiniband/hw/ehca/ehca_qp.c
+++ linux-2.6/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -55,9 +55,7 @@ static struct kmem_cache *qp_cache;
 /*
  * attributes not supported by query qp
  */
-#define QP_ATTR_QUERY_NOT_SUPPORTED (IB_QP_MAX_DEST_RD_ATOMIC | \
-				     IB_QP_MAX_QP_RD_ATOMIC   | \
-				     IB_QP_ACCESS_FLAGS       | \
+#define QP_ATTR_QUERY_NOT_SUPPORTED (IB_QP_ACCESS_FLAGS       | \
 				     IB_QP_EN_SQD_ASYNC_NOTIFY)
 
 /*
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
