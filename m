From: Michael Heinz <mheinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Minor improvement to an error message so error code is
 included
Date: Fri, 11 Feb 2011 16:44:30 -0500
Message-ID: <20110211214430.27626.65574.stgit@kop-sds-dev-02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/agent.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/agent.c b/drivers/infiniband/core/agent.c
index 91916a8..2bc7f5a 100644
--- a/drivers/infiniband/core/agent.c
+++ b/drivers/infiniband/core/agent.c
@@ -101,7 +101,8 @@ void agent_send_response(struct ib_mad *mad, struct ib_grh *grh,
 	agent = port_priv->agent[qpn];
 	ah = ib_create_ah_from_wc(agent->qp->pd, wc, grh, port_num);
 	if (IS_ERR(ah)) {
-		printk(KERN_ERR SPFX "ib_create_ah_from_wc error\n");
+		printk(KERN_ERR SPFX "ib_create_ah_from_wc error %ld\n",
+			PTR_ERR(ah));
 		return;
 	}
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
