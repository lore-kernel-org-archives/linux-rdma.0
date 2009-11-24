From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/core: clarify the documentation of ib_post_send()
Date: Tue, 24 Nov 2009 20:51:32 +0100
Message-ID: <200911242051.33106.bart.vanassche@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Clarify the documentation of ib_post_send().

Signed-off-by: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
CC: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
CC: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index c179318..b5c894f 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1425,6 +1425,11 @@ int ib_destroy_qp(struct ib_qp *qp);
  * @send_wr: A list of work requests to post on the send queue.
  * @bad_send_wr: On an immediate failure, this parameter will reference
  *   the work request that failed to be posted on the QP.
+ *
+ * Note: while IBTA Vol1 section 11.4.1.1 specifies that if an immediate
+ * error is returned that the QP state shall not be affected, implementations
+ * of ib_post_send() may return an immediate error after already having
+ * processed one or more work requests.
  */
 static inline int ib_post_send(struct ib_qp *qp,
 			       struct ib_send_wr *send_wr,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
