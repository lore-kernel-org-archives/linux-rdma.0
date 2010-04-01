From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 8/26] rdma/ucm: change event handling based on port space
Date: Thu, 1 Apr 2010 10:08:41 -0700
Message-ID: <87838B949B064ED1AABA87DF04EF345F@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
References: 
In-Reply-To: 
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The rdma_ucm handles events differently based on the port space
of the associated rdma_cm_id.  In order to support RDMA_PS_IB,
fix the handling based on the qp type.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/core/ucma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 7a59039..723fe83 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -258,7 +258,7 @@ static int ucma_event_handler(struct rdma_cm_id *cm_id,
 	ucma_set_event_context(ctx, event, uevent);
 	uevent->resp.event = event->event;
 	uevent->resp.status = event->status;
-	if (cm_id->ps == RDMA_PS_UDP || cm_id->ps == RDMA_PS_IPOIB)
+	if (cm_id->qp_type == IB_QPT_UD)
 		ucma_copy_ud_event(&uevent->resp.param.ud, &event->param.ud);
 	else
 		ucma_copy_conn_event(&uevent->resp.param.conn,



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
