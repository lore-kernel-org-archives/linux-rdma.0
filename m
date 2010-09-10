From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2.6.37 01/11] RDMA/cxgb4: Don't use null ep ptr.
Date: Fri, 10 Sep 2010 11:14:48 -0500
Message-ID: <20100910161447.6829.94002.stgit@build.ogc.int>
References: <20100910161442.6829.91594.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100910161442.6829.91594.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In c4iw_modify_qp() error path, only use qhp->ep if ep is not set.  Otherwise
qhp->ep can be NULL and we crash.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/qp.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 93f6e5b..05aa20b 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -1305,7 +1305,8 @@ err:
 
 	/* disassociate the LLP connection */
 	qhp->attr.llp_stream_handle = NULL;
-	ep = qhp->ep;
+	if (!ep)
+		ep = qhp->ep;
 	qhp->ep = NULL;
 	qhp->attr.state = C4IW_QP_STATE_ERROR;
 	free = 1;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
