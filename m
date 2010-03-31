From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/3] IB/core: use IB_CQ_REPORT_MISSED_EVENTS to avoid missed
	CQ callbacks
Date: Wed, 31 Mar 2010 10:57:47 -0700
Message-ID: <20100331175747.24522.88472.stgit@chromite.mv.qlogic.com>
References: <20100331175742.24522.17850.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100331175742.24522.17850.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

ib_req_notify_cq(IB_CQ_NEXT_COMP) is not guaranteed to generate
a callback for the next completion entered since there is a race
between arming the callback and another CQE being added to the queue.
The IB_CQ_REPORT_MISSED_EVENTS flag was added to detect this
race and allow the verbs consumer to call ib_poll_cq() and
ib_req_notify_cq() again to avoid delays in processing the CQE.

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

 drivers/infiniband/core/mad.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index e351b15..54c413e 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -2226,10 +2226,11 @@ static void ib_mad_completion_handler(struct work_struct *work)
 {
 	struct ib_mad_port_private *port_priv;
 	struct ib_wc wc;
+	int ret;
 
 	port_priv = container_of(work, struct ib_mad_port_private, work);
-	ib_req_notify_cq(port_priv->cq, IB_CQ_NEXT_COMP);
 
+again:
 	while (ib_poll_cq(port_priv->cq, 1, &wc) == 1) {
 		if (wc.status == IB_WC_SUCCESS) {
 			switch (wc.opcode) {
@@ -2246,6 +2247,10 @@ static void ib_mad_completion_handler(struct work_struct *work)
 		} else
 			mad_error_handler(port_priv, &wc);
 	}
+	ret = ib_req_notify_cq(port_priv->cq, IB_CQ_NEXT_COMP |
+					      IB_CQ_REPORT_MISSED_EVENTS);
+	if (ret > 0)
+		goto again;
 }
 
 static void cancel_mads(struct ib_mad_agent_private *mad_agent_priv)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
