From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/srp: reduce number of interrupts
Date: Wed, 24 Feb 2010 15:10:55 -0800
Message-ID: <adamxyyxm9s.fsf@roland-alpha.cisco.com>
References: <201002022023.54554.bart.vanassche@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201002022023.54554.bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> (Bart Van Assche's
	message of "Tue, 2 Feb 2010 20:23:54 +0100")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

thanks, applied, and I added the following cleanup on top too.
The old mess wasn't your fault of course but I think this makes things a
bit safer, assuming I didn't mess it up:

IB/srp: Clean up error path in srp_create_target_ib()

Instead of repeating the error unwinding steps in each place an error
can be detected, use the common idiom of gotos into an error flow.

Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   31 ++++++++++++++++++-------------
 1 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 441ea7c..ed3f9eb 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -232,15 +232,14 @@ static int srp_create_target_ib(struct srp_target_port *target)
 				       srp_recv_completion, NULL, target, SRP_RQ_SIZE, 0);
 	if (IS_ERR(target->recv_cq)) {
 		ret = PTR_ERR(target->recv_cq);
-		goto out;
+		goto err;
 	}
 
 	target->send_cq = ib_create_cq(target->srp_host->srp_dev->dev,
 				       srp_send_completion, NULL, target, SRP_SQ_SIZE, 0);
 	if (IS_ERR(target->send_cq)) {
 		ret = PTR_ERR(target->send_cq);
-		ib_destroy_cq(target->recv_cq);
-		goto out;
+		goto err_recv_cq;
 	}
 
 	ib_req_notify_cq(target->recv_cq, IB_CQ_NEXT_COMP);
@@ -258,20 +257,26 @@ static int srp_create_target_ib(struct srp_target_port *target)
 	target->qp = ib_create_qp(target->srp_host->srp_dev->pd, init_attr);
 	if (IS_ERR(target->qp)) {
 		ret = PTR_ERR(target->qp);
-		ib_destroy_cq(target->send_cq);
-		ib_destroy_cq(target->recv_cq);
-		goto out;
+		goto err_send_cq;
 	}
 
 	ret = srp_init_qp(target, target->qp);
-	if (ret) {
-		ib_destroy_qp(target->qp);
-		ib_destroy_cq(target->send_cq);
-		ib_destroy_cq(target->recv_cq);
-		goto out;
-	}
+	if (ret)
+		goto err_qp;
 
-out:
+	kfree(init_attr);
+	return 0;
+
+err_qp:
+	ib_destroy_qp(target->qp);
+
+err_send_cq:
+	ib_destroy_cq(target->send_cq);
+
+err_recv_cq:
+	ib_destroy_cq(target->recv_cq);
+
+err:
 	kfree(init_attr);
 	return ret;
 }
-- 
1.7.0


-- 
Roland Dreier  <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
