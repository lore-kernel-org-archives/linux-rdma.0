From: Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: infiniband: remove self-assignment from nes_query_qp()
Date: Tue, 17 Sep 2013 17:45:54 -0400
Message-ID: <20130917214554.GA357@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Assigning a value to itself is pointless.

Spotted with coverity, no hardware to test.

Signed-off-by: Dave Jones <davej-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 5b53ca5..8308e36 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -2834,7 +2834,7 @@ static int nes_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	init_attr->qp_context = nesqp->ibqp.qp_context;
 	init_attr->send_cq = nesqp->ibqp.send_cq;
 	init_attr->recv_cq = nesqp->ibqp.recv_cq;
-	init_attr->srq = nesqp->ibqp.srq = nesqp->ibqp.srq;
+	init_attr->srq = nesqp->ibqp.srq;
 	init_attr->cap = attr->cap;
 
 	return 0;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
