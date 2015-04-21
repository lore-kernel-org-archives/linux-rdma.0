From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags] vendstat: mad_rpc_close_port not called
 in corner cases
Date: Tue, 21 Apr 2015 10:01:48 -0400
Message-ID: <5536584C.8070505@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Thu, 16 Apr 2015 18:27:39 +0300

Call mad_rpc_close_port in all corner cases.
This is needed so fds are not leaked with ibsim.

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/vendstat.c |   82 ++++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 53 insertions(+), 29 deletions(-)

diff --git a/src/vendstat.c b/src/vendstat.c
index 11ee73e..baade3e 100644
--- a/src/vendstat.c
+++ b/src/vendstat.c
@@ -172,13 +172,14 @@ static int do_vendor(ib_portid_t *portid, struct ibmad_port *srcport,
 	call.attrid = attr_id;
 	call.mod = attr_mod;
 
-	if (!ib_vendor_call_via(data, portid, &call, srcport))
-		IBEXIT("vendstat: method %u, attribute %u", method, attr_id);
-
+	if (!ib_vendor_call_via(data, portid, &call, srcport)) {
+		fprintf(stderr,"vendstat: method %u, attribute %u failure\n", method, attr_id);
+		return -1;
+	}
 	return 0;
 }
 
-static void do_config_space_records(ib_portid_t *portid, unsigned set,
+static int do_config_space_records(ib_portid_t *portid, unsigned set,
 				    is3_config_space_t *cs, unsigned records)
 {
 	unsigned i;
@@ -194,17 +195,19 @@ static void do_config_space_records(ib_portid_t *portid, unsigned set,
 	if (do_vendor(portid, srcport, IB_MLX_VENDOR_CLASS,
 		      set ? IB_MAD_METHOD_SET : IB_MAD_METHOD_GET,
 		      IB_MLX_IS3_CONFIG_SPACE_ACCESS, 2 << 22 | records << 16,
-		      cs))
-		IBEXIT("cannot %s config space records", set ? "set" : "get");
-
+		      cs)) {
+		fprintf(stderr,"cannot %s config space records\n", set ? "set" : "get");
+		return -1;
+	}
 	for (i = 0; i < records; i++) {
 		printf("Config space record at 0x%x: 0x%x\n",
 		       ntohl(cs->record[i].address),
 		       ntohl(cs->record[i].data & cs->record[i].mask));
 	}
+	return 0;
 }
 
-static void counter_groups_info(ib_portid_t * portid, int port)
+static int counter_groups_info(ib_portid_t * portid, int port)
 {
 	char buf[1024];
 	is4_counter_group_info_t *cg_info;
@@ -213,15 +216,17 @@ static void counter_groups_info(ib_portid_t * portid, int port)
 	/* Counter Group Info */
 	memset(&buf, 0, sizeof(buf));
 	if (do_vendor(portid, srcport, IB_MLX_VENDOR_CLASS, IB_MAD_METHOD_GET,
-		      IB_MLX_IS4_COUNTER_GROUP_INFO, port, buf))
-		IBEXIT("counter group info query");
-
+		      IB_MLX_IS4_COUNTER_GROUP_INFO, port, buf)) {
+		fprintf(stderr,"counter group info query failure\n");
+		return -1;
+	}
 	cg_info = (is4_counter_group_info_t *) & buf;
 	num_cg = cg_info->num_of_counter_groups;
 	printf("counter_group_info:\n");
 	printf("%d counter groups\n", num_cg);
 	for (i = 0; i < num_cg; i++)
 		printf("group%d mask %#x\n", i, ntohl(cg_info->group_masks[i]));
+	return 0;
 }
 
 /* Group0 counter config values */
@@ -236,7 +241,7 @@ static void counter_groups_info(ib_portid_t * portid, int port)
 
 static int cg0, cg1;
 
-static void config_counter_groups(ib_portid_t * portid, int port)
+static int config_counter_groups(ib_portid_t * portid, int port)
 {
 	char buf[1024];
 	is4_config_counter_groups_t *cg_config;
@@ -251,15 +256,19 @@ static void config_counter_groups(ib_portid_t * portid, int port)
 	cg_config->group_selects[1].group_select = (uint8_t) cg1;
 
 	if (do_vendor(portid, srcport, IB_MLX_VENDOR_CLASS, IB_MAD_METHOD_SET,
-		      IB_MLX_IS4_CONFIG_COUNTER_GROUP, port, buf))
-		IBEXIT("config counter group set");
-
+		      IB_MLX_IS4_CONFIG_COUNTER_GROUP, port, buf)) {
+		fprintf(stderr, "config counter group set failure\n");
+		return -1;
+	}
 	/* get config counter groups */
 	memset(&buf, 0, sizeof(buf));
 
 	if (do_vendor(portid, srcport, IB_MLX_VENDOR_CLASS, IB_MAD_METHOD_GET,
-		      IB_MLX_IS4_CONFIG_COUNTER_GROUP, port, buf))
-		IBEXIT("config counter group query");
+		      IB_MLX_IS4_CONFIG_COUNTER_GROUP, port, buf)) {
+		fprintf(stderr, "config counter group query failure\n");
+		return -1;
+	}
+	return 0;
 }
 
 static int general_info, xmit_wait, counter_group_info, config_counter_group;
@@ -364,20 +373,26 @@ int main(int argc, char **argv)
 
 	if (argc) {
 		if (resolve_portid_str(ibd_ca, ibd_ca_port, &portid, argv[0],
-				       ibd_dest_type, ibd_sm_id, srcport) < 0)
+				       ibd_dest_type, ibd_sm_id, srcport) < 0) {
+			mad_rpc_close_port(srcport);
 			IBEXIT("can't resolve destination port %s", argv[0]);
+		}
 	} else {
-		if (resolve_self(ibd_ca, ibd_ca_port, &portid, &port, 0) < 0)
+		if (resolve_self(ibd_ca, ibd_ca_port, &portid, &port, 0) < 0) {
+			mad_rpc_close_port(srcport);
 			IBEXIT("can't resolve self port %s", argv[0]);
+		}
 	}
 
 	if (counter_group_info) {
 		counter_groups_info(&portid, port);
+		mad_rpc_close_port(srcport);
 		exit(0);
 	}
 
 	if (config_counter_group) {
 		config_counter_groups(&portid, port);
+		mad_rpc_close_port(srcport);
 		exit(0);
 	}
 
@@ -388,6 +403,7 @@ int main(int argc, char **argv)
 		if (write_cs_records)
 			do_config_space_records(&portid, 1, &write_cs,
 						write_cs_records);
+		mad_rpc_close_port(srcport);
 		exit(0);
 	}
 
@@ -395,23 +411,27 @@ int main(int argc, char **argv)
 	/* but vendors change the VendorId so how know for sure ? */
 	/* Only General Info and Port Xmit Wait Counters */
 	/* queries are currently supported */
-	if (!general_info && !xmit_wait)
+	if (!general_info && !xmit_wait) {
+		mad_rpc_close_port(srcport);
 		IBEXIT("at least one of -N and -w must be specified");
-
+	}
 	/* Would need a list of these and it might not be complete */
 	/* so for right now, punt on this */
 
 	/* vendor ClassPortInfo is required attribute if class supported */
 	memset(&buf, 0, sizeof(buf));
 	if (do_vendor(&portid, srcport, IB_MLX_VENDOR_CLASS, IB_MAD_METHOD_GET,
-		      CLASS_PORT_INFO, 0, buf))
+		      CLASS_PORT_INFO, 0, buf)) {
+		mad_rpc_close_port(srcport);
 		IBEXIT("classportinfo query");
-
+	}
 	memset(&buf, 0, sizeof(buf));
 	gi_is3 = (is3_general_info_t *) &buf;
 	if (do_vendor(&portid, srcport, IB_MLX_VENDOR_CLASS, IB_MAD_METHOD_GET,
-		      IB_MLX_IS3_GENERAL_INFO, 0, gi_is3))
+		      IB_MLX_IS3_GENERAL_INFO, 0, gi_is3)) {
+		mad_rpc_close_port(srcport);
 		IBEXIT("generalinfo query");
+	}
 
 	if (is_ext_fw_info_supported(ntohs(gi_is3->hw_info.device_id))) {
 		gi_is4 = (is4_general_info_t *) &buf;
@@ -452,10 +472,11 @@ int main(int argc, char **argv)
 		is3_config_space_t *cs;
 		unsigned i;
 
-		if (ntohs(gi_is3->hw_info.device_id) != IS3_DEVICE_ID)
+		if (ntohs(gi_is3->hw_info.device_id) != IS3_DEVICE_ID) {
+			mad_rpc_close_port(srcport);
 			IBEXIT("Unsupported device ID 0x%x",
 				ntohs(gi_is3->hw_info.device_id));
-
+		}
 		memset(&buf, 0, sizeof(buf));
 		/* Set record addresses for each port */
 		cs = (is3_config_space_t *) & buf;
@@ -464,9 +485,10 @@ int main(int argc, char **argv)
 			    htonl(IB_MLX_IS3_PORT_XMIT_WAIT + ((i + 1) << 12));
 		if (do_vendor(&portid, srcport, IB_MLX_VENDOR_CLASS,
 			      IB_MAD_METHOD_GET, IB_MLX_IS3_CONFIG_SPACE_ACCESS,
-			      2 << 22 | 16 << 16, cs))
+			      2 << 22 | 16 << 16, cs)) {
+			mad_rpc_close_port(srcport);
 			IBEXIT("vendstat");
-
+		}
 		for (i = 0; i < 16; i++)
 			if (cs->record[i].data)	/* PortXmitWait is 32 bit counter */
 				printf("Port %d: PortXmitWait 0x%x\n", i + 4, ntohl(cs->record[i].data));	/* port 4 is first port */
@@ -480,8 +502,10 @@ int main(int argc, char **argv)
 			    htonl(IB_MLX_IS3_PORT_XMIT_WAIT + ((i + 17) << 12));
 		if (do_vendor(&portid, srcport, IB_MLX_VENDOR_CLASS,
 			      IB_MAD_METHOD_GET, IB_MLX_IS3_CONFIG_SPACE_ACCESS,
-			      2 << 22 | 8 << 16, cs))
+			      2 << 22 | 8 << 16, cs)) {
+			mad_rpc_close_port(srcport);
 			IBEXIT("vendstat");
+		}
 
 		for (i = 0; i < 8; i++)
 			if (cs->record[i].data)	/* PortXmitWait is 32 bit counter */
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
