From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 11/24] IB/qib: clear WAIT_SEND flags when setting QP to error
	state
Date: Tue, 28 Dec 2010 10:27:47 -0500
Message-ID: <20101228152747.19960.66724.stgit@kop-dev-sles11-04.qlogic.org>
References: <20101228152648.19960.84006.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101228152648.19960.84006.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If these flags are set when the QP is transitioned to the error
state, it will wait until the flags are cleared, which may never
happen if the error transition is due to a link going down.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_qp.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index 6c39851..32dacd4 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -468,6 +468,10 @@ int qib_error_qp(struct qib_qp *qp, enum ib_wc_status err)
 		qp->s_flags &= ~(QIB_S_TIMER | QIB_S_WAIT_RNR);
 		del_timer(&qp->s_timer);
 	}
+
+	if (qp->s_flags & QIB_S_ANY_WAIT_SEND)
+		qp->s_flags &= ~QIB_S_ANY_WAIT_SEND;
+
 	spin_lock(&dev->pending_lock);
 	if (!list_empty(&qp->iowait) && !(qp->s_flags & QIB_S_BUSY)) {
 		qp->s_flags &= ~QIB_S_ANY_WAIT_IO;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
