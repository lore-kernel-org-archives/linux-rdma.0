From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] infiniband-diags/smpquery: Add support for extended link
 speeds
Date: Mon, 15 Aug 2011 19:54:33 -0400
Message-ID: <4E49B1B9.5020900@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/man/smpquery.8 b/man/smpquery.8
index afd02db..c4cb8f2 100644
--- a/man/smpquery.8
+++ b/man/smpquery.8
@@ -6,8 +6,8 @@ smpquery \- query InfiniBand subnet management attributes
 .SH SYNOPSIS
 .B smpquery
 [\-d(ebug)] [\-e(rr_show)] [\-v(erbose)] [\-D(irect)] [\-G(uid)]
-[\-C ca_name] [\-P ca_port] [\-t(imeout) timeout_ms]
-[--node-name-map node-name-map] [\-V(ersion)] [\-h(elp)]
+[\-x|\-\-extended] [\-C ca_name] [\-P ca_port] [\-t(imeout) timeout_ms]
+[\-\-node-name-map node-name-map] [\-V(ersion)] [\-h(elp)]
 <op> <dest dr_path|lid|guid> [op params]
 
 .SH DESCRIPTION
@@ -32,6 +32,11 @@ Current supported operations and their parameters:
         mlnxextportinfo <addr> [<portnum>]  # default port is zero
 
 .TP
+\fB\-x\fR, \fB\-\-extended\fR
+Set SMSupportsExtendedSpeeds bit 31 in AttributeModifier
+(only impacts PortInfo queries).
+
+.TP
 \fB\-\-node\-name\-map\fR <node-name-map>
 Specify a node name map.  The node name map file maps GUIDs to more
 user friendly names.  See
diff --git a/src/smpquery.c b/src/smpquery.c
index 6753ba9..cecfa68 100644
--- a/src/smpquery.c
+++ b/src/smpquery.c
@@ -80,6 +80,7 @@ static const match_rec_t match_tbl[] = {
 
 static char *node_name_map_file = NULL;
 static nn_map_t *node_name_map = NULL;
+static int extended_speeds = 0;
 
 /*******************************************/
 static char *node_desc(ib_portid_t * dest, char **argv, int argc)
@@ -134,17 +135,20 @@ static char *port_info(ib_portid_t * dest, char **argv, int argc)
 {
 	char buf[2300];
 	char data[IB_SMP_DATA_SIZE] = { 0 };
-	int portnum = 0;
+	int portnum = 0, orig_portnum;
 
 	if (argc > 0)
 		portnum = strtol(argv[0], 0, 0);
+	orig_portnum = portnum;
+	if (extended_speeds)
+		portnum |= 1 << 31;
 
 	if (!smp_query_via(data, dest, IB_ATTR_PORT_INFO, portnum, 0, srcport))
 		return "port info query failed";
 
 	mad_dump_portinfo(buf, sizeof buf, data, sizeof data);
 
-	printf("# Port info: %s port %d\n%s", portid2str(dest), portnum, buf);
+	printf("# Port info: %s port %d\n%s", portid2str(dest), orig_portnum, buf);
 	return 0;
 }
 
@@ -414,6 +418,9 @@ static int process_opt(void *context, int ch, char *optarg)
 	case 'c':
 		ibd_dest_type = IB_DEST_DRSLID;
 		break;
+	case 'x':
+		extended_speeds = 1;
+		break;
 	default:
 		return -1;
 	}
@@ -435,6 +442,7 @@ int main(int argc, char **argv)
 		{"combined", 'c', 0, NULL,
 		 "use Combined route address argument"},
 		{"node-name-map", 1, 1, "<file>", "node name map file"},
+		{"extended", 'x', 0, NULL, "use extended speeds"},
 		{0}
 	};
 	const char *usage_examples[] = {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
