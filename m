From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 08/23] ocrdma: Fix incorrect enum constant
Date: Wed, 21 Sep 2016 16:08:34 -0600
Message-ID: <1474495729-17604-9-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474495729-17604-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474495729-17604-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

clang 3.6 remarks:

../providers/ocrdma/ocrdma_verbs.c:597:14: warning: implicit conversion from enumeration type 'enum ibv_qp_state' to different enumeration type 'enum ocrdma_qp_state' [-Wenum-conversion]
        qp->state = IBV_QPS_RESET;

And it is not wrong.  IBV_QPS_RESET=0 and OCRDMA_QPS_RST=0 so this
patch is a NOP.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libocrdma/src/ocrdma_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libocrdma/src/ocrdma_verbs.c b/libocrdma/src/ocrdma_verbs.c
index b3c77c47d660..60626260656d 100644
--- a/libocrdma/src/ocrdma_verbs.c
+++ b/libocrdma/src/ocrdma_verbs.c
@@ -620,7 +620,7 @@ struct ibv_qp *ocrdma_create_qp(struct ibv_pd *pd,
 			qp->dpp_cq = 0;
 		}
 	}
-	qp->state = IBV_QPS_RESET;
+	qp->state = OCRDMA_QPS_RST;
 	INIT_DBLY_LIST_NODE(&qp->sq_entry);
 	INIT_DBLY_LIST_NODE(&qp->rq_entry);
 	return &qp->ibv_qp;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
