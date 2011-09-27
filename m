From: Marcus R Epperson <marcus.r.epperson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] infiniband-diags/src/ibqueryerrors.c: fix segv due to CA port 0 reference
Date: Tue, 27 Sep 2011 15:52:30 -0700
Message-ID: <1317163951-25948-1-git-send-email-marcus.r.epperson@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Marcus R Epperson <marcus.r.epperson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Marcus R Epperson <marcus.r.epperson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 src/ibqueryerrors.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index fa116a9..230f6b2 100644
--- a/src/ibqueryerrors.c
+++ b/src/ibqueryerrors.c
@@ -427,8 +427,9 @@ static int print_results(ib_portid_t * portid, char *node_name,
 		}
 
 		if (portnum == 0xFF)
-			printf("   GUID 0x%" PRIx64 " port ALL:%s\n",
-			       node->ports[0]->guid, str);
+			if (node->type == IB_NODE_SWITCH)
+				printf("   GUID 0x%" PRIx64 " port ALL:%s\n",
+				       node->ports[0]->guid, str);
 		else
 			printf("   GUID 0x%" PRIx64 " port %d:%s\n",
 			       node->ports[portnum]->guid, portnum, str);
-- 
1.7.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
