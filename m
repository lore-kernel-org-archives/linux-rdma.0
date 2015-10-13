From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags] ibqueryerrors.c: Removed unused passed
 parameters to print_port_config and query_and_dump
Date: Tue, 13 Oct 2015 08:38:20 -0400
Message-ID: <561CFB3C.9090703@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


src/ibqueryerrors.c: In function ?print_port_config?:
src/ibqueryerrors.c:176: warning: unused parameter ?node_name?
src/ibqueryerrors.c: In function ?query_and_dump?:
src/ibqueryerrors.c:367: warning: unused parameter ?node?

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index 40a8ad1..304dc15 100644
--- a/src/ibqueryerrors.c
+++ b/src/ibqueryerrors.c
@@ -173,7 +173,7 @@ static int exceeds_threshold(int field, unsigned val)
 	return (val > thres);
 }
 
-static void print_port_config(char *node_name, ibnd_node_t * node, int portnum)
+static void print_port_config(ibnd_node_t * node, int portnum)
 {
 	char width[64], speed[64], state[64], physstate[64];
 	char remote_str[256];
@@ -364,7 +364,7 @@ Exit:
 }
 
 static int query_and_dump(char *buf, size_t size, ib_portid_t * portid,
-			  ibnd_node_t * node, char *node_name, int portnum,
+			  char *node_name, int portnum,
 			  const char *attr_name, uint16_t attr_id,
 			  int start_field, int end_field)
 {
@@ -418,7 +418,7 @@ static int print_results(ib_portid_t * portid, char *node_name,
 			/* If there are PortXmitDiscards, get details (if supported) */
 			if (i == IB_PC_XMT_DISCARDS_F && details) {
 				n += query_and_dump(str + n, sizeof(buf) - n, portid,
-						    node, node_name, portnum,
+						    node_name, portnum,
 						    "PortXmitDiscardDetails",
 						    IB_GSI_PORT_XMIT_DISCARD_DETAILS,
 						    IB_PC_RCV_LOCAL_PHY_ERR_F,
@@ -426,7 +426,7 @@ static int print_results(ib_portid_t * portid, char *node_name,
 				/* If there are PortRcvErrors, get details (if supported) */
 			} else if (i == IB_PC_ERR_RCV_F && details) {
 				n += query_and_dump(str + n, sizeof(buf) - n, portid,
-						    node, node_name, portnum,
+						    node_name, portnum,
 						    "PortRcvErrorDetails",
 						    IB_GSI_PORT_RCV_ERROR_DETAILS,
 						    IB_PC_XMT_INACT_DISC_F,
@@ -499,7 +499,7 @@ static int print_results(ib_portid_t * portid, char *node_name,
 			printf("   GUID 0x%" PRIx64 " port %d:%s\n",
 			       node->ports[portnum]->guid, portnum, str);
 			if (port_config)
-				print_port_config(node_name, node, portnum);
+				print_port_config(node, portnum);
 			summary.bad_ports++;
 		}
 	}
@@ -596,7 +596,7 @@ static int print_data_cnts(ib_portid_t * portid, uint16_t cap_mask,
 	printf("\n");
 
 	if (portnum != 0xFF && port_config)
-		print_port_config(node_name, node, portnum);
+		print_port_config(node, portnum);
 
 	return (0);
 }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
