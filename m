From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] librdmacm: Return ECONNREFUSED from rdma_connect on reject
Date: Fri, 9 Dec 2011 00:05:54 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237325654F84@ORSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Make the errno return code from rdma_connect consistent with
connect.  The underlying status value is available by reading
the event data.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/cma.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/src/cma.c b/src/cma.c
index e09ab99..4a0bde9 100755
--- a/src/cma.c
+++ b/src/cma.c
@@ -761,8 +761,12 @@ static int ucma_complete(struct cma_id_private *id_priv)
 	if (ret)
 		return ret;
 
-	if (id_priv->id.event->status)
-		ret = ERR(id_priv->id.event->status);
+	if (id_priv->id.event->status) {
+		if (id_priv->id.event->event == RDMA_CM_EVENT_REJECTED)
+			ret = ERR(ECONNREFUSED);
+		else
+			ret = ERR(id_priv->id.event->status);
+	}
 	return ret;
 }
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
