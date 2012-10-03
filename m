From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Problem running rping over Intel adapters
Date: Wed, 3 Oct 2012 22:38:34 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A98ECB@FMSMSX151.amr.corp.intel.com>
References: <506CB0E9.90201@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <506CB0E9.90201-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 1) rping, on the client side, clears the conn_params for the newly to be
> attempted connection, then sets:
> 
> 	conn_param.responder_resources = 1;
> 	conn_param.initiator_depth = 1;
> 	conn_param.retry_count = 10;
> 
> On the accept side, rping clears the conn_params and then sets just the
> responder_resources and initiator_depth, without even checking the
> incoming requested conn_param values from the incoming cm_id.  So, OK,
> you can get away with that since this is a simple test program, but
> still not "best programming practices".  However, the important part
> here is the retry_count of 10.  That won't work on Intel/QLogic hardware.

I pushed in the following fix to rping.  Thanks

---

rping: Reduce retry_count to fit in 3-bits

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

retry_count is a 3 bit value on IB, reduce it from
10 to 7.

A value of 10 prevents rping from working over the Intel
IB HCA.  Problem reported by Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

The retry_count is also not set when calling rdma_accept.
Rather than passing different values into rdma_accept than
what was specified by the remote side, use the values given
in the connection request.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 examples/rping.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/examples/rping.c b/examples/rping.c
index 785338e..32bd70a 100644
--- a/examples/rping.c
+++ b/examples/rping.c
@@ -342,16 +342,11 @@ error:
 
 static int rping_accept(struct rping_cb *cb)
 {
-	struct rdma_conn_param conn_param;
 	int ret;
 
 	DEBUG_LOG("accepting client connection request\n");
 
-	memset(&conn_param, 0, sizeof conn_param);
-	conn_param.responder_resources = 1;
-	conn_param.initiator_depth = 1;
-
-	ret = rdma_accept(cb->child_cm_id, &conn_param);
+	ret = rdma_accept(cb->child_cm_id, NULL);
 	if (ret) {
 		perror("rdma_accept");
 		return ret;
@@ -975,7 +970,7 @@ static int rping_connect_client(struct rping_cb *cb)
 	memset(&conn_param, 0, sizeof conn_param);
 	conn_param.responder_resources = 1;
 	conn_param.initiator_depth = 1;
-	conn_param.retry_count = 10;
+	conn_param.retry_count = 7;
 
 	ret = rdma_connect(cb->cm_id, &conn_param);
 	if (ret) {


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
