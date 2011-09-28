From: Marcus R Epperson <marcus.r.epperson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 0/1] infiniband-diags/src/ibqueryerrors.c: fix segv due to CA port 0 reference
Date: Tue, 27 Sep 2011 18:15:11 -0700
Message-ID: <1317172512-29615-1-git-send-email-marcus.r.epperson@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Marcus R Epperson <marcus.r.epperson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 src/ibqueryerrors.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index fa116a9..7222746 100644
--- a/src/ibqueryerrors.c
+++ b/src/ibqueryerrors.c
@@ -426,10 +426,11 @@ static int print_results(ib_portid_t * portid, char *node_name,
 			summary.bad_nodes++;
 		}
 
-		if (portnum == 0xFF)
-			printf("   GUID 0x%" PRIx64 " port ALL:%s\n",
-			       node->ports[0]->guid, str);
-		else
+		if (portnum == 0xFF) {
+			if (node->type == IB_NODE_SWITCH)
+				printf("   GUID 0x%" PRIx64 " port ALL:%s\n",
+				       node->ports[0]->guid, str);
+		} else
 			printf("   GUID 0x%" PRIx64 " port %d:%s\n",
 			       node->ports[portnum]->guid, portnum, str);
 		if (portnum != 0xFF && port_config)
-- 
1.7.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
