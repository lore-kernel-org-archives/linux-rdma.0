From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] rdma/ucma: Discard all events for new connections until
 accepted
Date: Tue, 10 Jan 2012 23:53:41 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237325675541@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

After reporting a new connection request to user space, the
rdma_ucm will discard subsequent events until the user has
associated a user space idenfier with the kernel cm_id.  This
is needed to avoid reporting a reject/disconnect event to
the user for a request that they may not have processed.

The user space identifier is set once the user tries to accept
the connection request.  However, the following race exists in
ucma_accept():

	ctx->uid = cmd.uid;
	<events may be reported now>
	ret = rdma_accept(ctx->cm_id, ...);

Once ctx->uid has been set, new events may be reported to the
user.  While the above mentioned race is avoided, there
is an issue that the user _may_ receive a reject/disconnect
event if rdma_accept() fails, depending on when the event is
processed.  To simplify the use of rdma_accept(), discard all
events unless rdma_accept() succeeds.

This problem was discovered based on questions from Roland
Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
I don't know if I'd call this a real bug, but it is cleaner if the user knows
whether to expect a callback.

 drivers/infiniband/core/ucma.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index b37b0c0..5034a87 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -808,9 +808,12 @@ static ssize_t ucma_accept(struct ucma_file *file, const char __user *inbuf,
 		return PTR_ERR(ctx);
 
 	if (cmd.conn_param.valid) {
-		ctx->uid = cmd.uid;
 		ucma_copy_conn_param(&conn_param, &cmd.conn_param);
+		mutex_lock(&file->mut);
 		ret = rdma_accept(ctx->cm_id, &conn_param);
+		if (!ret)
+			ctx->uid = cmd.uid;
+		mutex_unlock(&file->mut);
 	} else
 		ret = rdma_accept(ctx->cm_id, NULL);
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
