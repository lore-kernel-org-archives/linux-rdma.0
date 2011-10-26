From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: iblinkinfo flag ports which were not
 scanned
Date: Wed, 26 Oct 2011 14:27:53 -0700
Message-ID: <20111026142753.e9ffe06b.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



When using the -n option iblinkinfo may not scan the entire fabric.  As such
some ports will not be available to print.  Output that information rather than
blank data as before.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 src/iblinkinfo.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/src/iblinkinfo.c b/src/iblinkinfo.c
index 4b69a5c..00c7bc0 100644
--- a/src/iblinkinfo.c
+++ b/src/iblinkinfo.c
@@ -214,8 +214,12 @@ void print_port(ibnd_node_t * node, ibnd_port_t * port, char *out_prefix)
 			 port->remoteport->portnum, ext_port_str, remap,
 			 width_msg, speed_msg);
 		free(remap);
-	} else
-		snprintf(remote_str, 256, "           [  ] \"\" ( )\n");
+	} else {
+		if (istate == IB_LINK_DOWN)
+			snprintf(remote_str, 256, "           [  ] \"\" ( )\n");
+		else
+			snprintf(remote_str, 256, "    \"Port not available\"\n");
+	}
 
 	if (port->ext_portnum)
 		snprintf(ext_port_str, 256, "%d", port->ext_portnum);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
