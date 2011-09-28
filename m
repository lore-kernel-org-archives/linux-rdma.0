From: Marcus R Epperson <marcus.r.epperson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 1/1] infiniband-diags/src/ibqueryerrors.c: don't increment bad_ports for port ALL
Date: Tue, 27 Sep 2011 18:15:12 -0700
Message-ID: <1317172512-29615-2-git-send-email-marcus.r.epperson@gmail.com>
References: <1317172512-29615-1-git-send-email-marcus.r.epperson@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1317172512-29615-1-git-send-email-marcus.r.epperson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Marcus R Epperson <marcus.r.epperson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 src/ibqueryerrors.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index 7222746..d37d268 100644
--- a/src/ibqueryerrors.c
+++ b/src/ibqueryerrors.c
@@ -430,13 +430,13 @@ static int print_results(ib_portid_t * portid, char *node_name,
 			if (node->type == IB_NODE_SWITCH)
 				printf("   GUID 0x%" PRIx64 " port ALL:%s\n",
 				       node->ports[0]->guid, str);
-		} else
+		} else {
 			printf("   GUID 0x%" PRIx64 " port %d:%s\n",
 			       node->ports[portnum]->guid, portnum, str);
-		if (portnum != 0xFF && port_config)
-			print_port_config(node_name, node, portnum);
-
-		summary.bad_ports++;
+			if (port_config)
+				print_port_config(node_name, node, portnum);
+			summary.bad_ports++;
+		}
 	}
 	return (n);
 }
-- 
1.7.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
