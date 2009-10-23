From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] infiniband-diags/ibqueryerrors.c: Cosmetic changes
Date: Fri, 23 Oct 2009 13:57:46 -0400
Message-ID: <20091023175746.GA15906@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Eliminated redundant "\n" in IBWARNs
Fixed commentary typo

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/infiniband-diags/src/ibqueryerrors.c b/infiniband-diags/src/ibqueryerrors.c
index 0842eb3..625bd8e 100644
--- a/infiniband-diags/src/ibqueryerrors.c
+++ b/infiniband-diags/src/ibqueryerrors.c
@@ -282,12 +282,12 @@ static void print_port(ib_portid_t * portid, uint16_t cap_mask, char *node_name,
 
 	if (!pma_query_via(pc, portid, portnum, ibd_timeout,
 			   IB_GSI_PORT_COUNTERS, ibmad_port)) {
-		IBWARN("IB_GSI_PORT_COUNTERS query failed on %s, %s port %d\n",
+		IBWARN("IB_GSI_PORT_COUNTERS query failed on %s, %s port %d",
 		       node_name, portid2str(portid), portnum);
 		return;
 	}
 	if (!(cap_mask & 0x1000)) {
-		/* if PortCounters:PortXmitWait not suppported clear this counter */
+		/* if PortCounters:PortXmitWait not supported clear this counter */
 		uint32_t foo = 0;
 		mad_encode_field(pc, IB_PC_XMT_WAIT_F, &foo);
 	}
@@ -515,14 +515,14 @@ int main(int argc, char **argv)
 		if ((resolved =
 		     ib_resolve_portid_str_via(&portid, dr_path, IB_DEST_DRPATH,
 					       NULL, ibmad_port)) < 0)
-			IBWARN("Failed to resolve %s; attempting full scan\n",
+			IBWARN("Failed to resolve %s; attempting full scan",
 			       dr_path);
 	} else if (node_guid_str) {
 		if ((resolved =
 		     ib_resolve_portid_str_via(&portid, node_guid_str,
 					       IB_DEST_GUID, ibd_sm_id,
 					       ibmad_port)) < 0)
-			IBWARN("Failed to resolve %s; attempting full scan\n",
+			IBWARN("Failed to resolve %s; attempting full scan",
 			       node_guid_str);
 	}
 
@@ -530,7 +530,7 @@ int main(int argc, char **argv)
 		if ((fabric = ibnd_discover_fabric(ibmad_port, &portid,
 						   0)) == NULL)
 			IBWARN
-			    ("Single node discover failed; attempting full scan\n");
+			    ("Single node discover failed; attempting full scan");
 
 	if (!fabric)		/* do a full scan */
 		if ((fabric =
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
