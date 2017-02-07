From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch 1/2] IB/rxe: Fix resid update
Date: Tue, 7 Feb 2017 16:43:05 +0300
Message-ID: <20170207134305.GJ11103@mwanda>
References: <8892e1d1-84ba-489b-d118-3599b9b50b0f@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8892e1d1-84ba-489b-d118-3599b9b50b0f-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Itkin <eyal.itkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Eyal Itkin <eyal.itkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Update the response's resid field when larger than MTU, instead of only
updating the local resid variable.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Eyal Itkin <eyal.itkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 7bf20ced2078..d404a8aba7af 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -479,7 +479,7 @@ static enum resp_states check_rkey(struct rxe_qp *qp,
 				goto err;
 			}
 
-			resid = mtu;
+			qp->resp.resid = mtu;
 		} else {
 			if (pktlen != resid) {
 				state = RESPST_ERR_LENGTH;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
