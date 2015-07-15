From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCHv3 infiniband-diags] iblinkinfo.c: Close additional file descriptor
 in advance
Date: Wed, 15 Jul 2015 14:08:49 -0400
Message-ID: <55A6A1B1.90407@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Additional file descriptor for SMP MADs should be closed before running
ibnd_discover_fabric() to avoid parallel usage of two SMP file descriptors

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Change since v2:
Only SMP query for NodeInfo if (!all && dr_path) - same as current code

Change since v1:
Per Ira's comment, moved location of SMP query for NodeInfo
so partial fabric DR query will work.

diff --git a/src/iblinkinfo.c b/src/iblinkinfo.c
index 92ff3c6..5f2b677 100644
--- a/src/iblinkinfo.c
+++ b/src/iblinkinfo.c
@@ -594,6 +594,7 @@ int main(int argc, char **argv)
 	ibnd_fabric_t *diff_fabric = NULL;
 	struct ibmad_port *ibmad_port;
 	ib_portid_t port_id = { 0 };
+	uint8_t ni[IB_SMP_DATA_SIZE] = { 0 };
 	int mgmt_classes[3] =
 	    { IB_SMI_CLASS, IB_SMI_DIRECT_CLASS, IB_SA_CLASS };
 
@@ -659,6 +660,7 @@ int main(int argc, char **argv)
 	node_name_map = open_node_name_map(node_name_map_file);
 
 	if (dr_path && load_cache_file) {
+		mad_rpc_close_port(ibmad_port);
 		fprintf(stderr, "Cannot specify cache and direct route path\n");
 		exit(1);
 	}
@@ -679,6 +681,16 @@ int main(int argc, char **argv)
 			       guid_str);
 	}
 
+	if (!all && dr_path) {
+		if (!smp_query_via(ni, &port_id, IB_ATTR_NODE_INFO, 0,
+				   ibd_timeout, ibmad_port)){
+			mad_rpc_close_port(ibmad_port);
+			fprintf(stderr, "Failed to get local Node Info\n");
+			exit(1);
+		}
+	}
+	mad_rpc_close_port(ibmad_port);
+
 	if (diff_cache_file &&
 	    !(diff_fabric = ibnd_load_fabric(diff_cache_file, 0)))
 		IBEXIT("loading cached fabric for diff failed\n");
@@ -723,11 +735,6 @@ int main(int argc, char **argv)
 			fprintf(stderr, "Failed to find port: %s\n", guid_str);
 	} else if (!all && dr_path) {
 		ibnd_port_t *p = NULL;
-		uint8_t ni[IB_SMP_DATA_SIZE] = { 0 };
-
-		if (!smp_query_via(ni, &port_id, IB_ATTR_NODE_INFO, 0,
-				   ibd_timeout, ibmad_port))
-			return -1;
 		mad_decode_field(ni, IB_NODE_PORT_GUID_F, &(guid));
 
 		p = ibnd_find_port_guid(fabric, guid);
@@ -758,6 +765,5 @@ int main(int argc, char **argv)
 
 close_port:
 	close_node_name_map(node_name_map);
-	mad_rpc_close_port(ibmad_port);
 	exit(rc);
 }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
