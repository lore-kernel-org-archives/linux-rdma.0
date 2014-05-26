From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] RDMA/cxgb3: information leak in send_abort()
Date: Tue, 27 May 2014 00:04:44 +0300
Message-ID: <20140526210444.GA18660@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Steve Wise <swise@chelsio.com>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The cpl_abort_req struct has several reserved members which need to be
cleared to avoid disclosing kernel information.  I have added a memset()
so now it matches the cxgb4 version of this function.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index 095bb04..cb78b1e 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -418,6 +418,7 @@ static int send_abort(struct iwch_ep *ep, struct sk_buff *skb, gfp_t gfp)
 	skb->priority = CPL_PRIORITY_DATA;
 	set_arp_failure_handler(skb, abort_arp_failure);
 	req = (struct cpl_abort_req *) skb_put(skb, sizeof(*req));
+	memset(req, 0, sizeof(*req));
 	req->wr.wr_hi = htonl(V_WR_OP(FW_WROPCODE_OFLD_HOST_ABORT_CON_REQ));
 	req->wr.wr_lo = htonl(V_WR_TID(ep->hwtid));
 	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_ABORT_REQ, ep->hwtid));
