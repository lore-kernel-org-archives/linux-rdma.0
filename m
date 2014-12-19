From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] libibmad/src/rpc.c: Remove superfluous packet dump
Date: Fri, 19 Dec 2014 11:08:20 -0800
Message-ID: <1419016100.20566.155.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When idebug == 1, mad_rpc outputs only the mad data
response in debug output.  It does not output the request
mad data.  This is confusing since it's not clear if it's
request or response output.

When idebug > 1, full mad send and receive buffers are
output, which makes the mad data output with idebug == 1
superfluous.  Remove it to remove confusion.

Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 src/rpc.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/src/rpc.c b/src/rpc.c
index 8d961f2..202fac5 100644
--- a/src/rpc.c
+++ b/src/rpc.c
@@ -272,11 +272,6 @@ void *mad_rpc(const struct ibmad_port *port, ib_rpc_t * rpc,
 		return NULL;
 	}
 
-	if (ibdebug) {
-		IBWARN("data offs %d sz %d", rpc->dataoffs, rpc->datasz);
-		xdump(stderr, "mad data\n", mad + rpc->dataoffs, rpc->datasz);
-	}
-
 	if (rcvdata)
 		memcpy(rcvdata, mad + rpc->dataoffs, rpc->datasz);
 
-- 
1.7.1




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
