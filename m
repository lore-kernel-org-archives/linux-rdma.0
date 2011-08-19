From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/6] infiniband-diags/ibportstate: Add support for FDR10
Date: Fri, 19 Aug 2011 12:53:55 -0400
Message-ID: <4E4E9523.40404@dev.mellanox.co.il>
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
 man/ibportstate.8 |    5 ++-
 src/ibportstate.c |   95 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 96 insertions(+), 4 deletions(-)

diff --git a/man/ibportstate.8 b/man/ibportstate.8
index 2a60db9..0537d7e 100644
--- a/man/ibportstate.8
+++ b/man/ibportstate.8
@@ -23,7 +23,7 @@ also allows the link speed/width enabled on any IB port to be adjusted.
 .TP
 op
 Port operations allowed
- supported ops: enable, disable, reset, speed, espeed, width, query,
+ supported ops: enable, disable, reset, speed, espeed, fdr10, width, query,
 		down, arm, active, vls, mtu, lid, smlid, lmc
  Default is query
 .PP
@@ -34,6 +34,7 @@ Port operations allowed
  (An error is indicated if PortInfo:LinkSpeedSupported does not support
   this setting)
  espeed ops are allowed on any port supporting extended link speeds
+ fdr10 ops are allowed on any port supporting fdr10
 (An error is indicated if port's capability mask indicates extended
  link speeds are not supported or if PortInfo:LinkSpeedExtSupported
  does not support this setting)
@@ -42,7 +43,7 @@ Port operations allowed
   this setting)
  (NOTE: Speed and width changes are not effected until the port goes through
   link renegotiation)
- query also validates port characteristics (link width, speed, and espeed)
+ query also validates port characteristics (link width, speed, espeed, and fdr10)
   based on the peer port. This checking is done when the port
   queried is a switch port as it relies on combined routing
   (an initial LID route with directed routing to the peer) which
diff --git a/src/ibportstate.c b/src/ibportstate.c
index f7ad37f..9077413 100644
--- a/src/ibportstate.c
+++ b/src/ibportstate.c
@@ -54,6 +54,7 @@ enum port_ops {
 	DISABLE,
 	SPEED,
 	ESPEED,
+	FDR10SPEED,
 	WIDTH,
 	DOWN,
 	ARM,
@@ -68,6 +69,7 @@ enum port_ops {
 struct ibmad_port *srcport;
 int speed = 0; /* no state change */
 int espeed = 0; /* no state change */
+int fdr10 = 0; /* no state change */
 int width = 0; /* no state change */
 int lid;
 int smlid;
@@ -86,6 +88,7 @@ struct {
 	{"disable", NULL, 0},	/* DISABLE */
 	{"speed", &speed, 0},	/* SPEED */
 	{"espeed", &espeed, 0},	/* EXTENDED SPEED */
+	{"fdr10", &fdr10, 0},	/* FDR10 SPEED */
 	{"width", &width, 0},	/* WIDTH */
 	{"down", NULL, 0},	/* DOWN */
 	{"arm", NULL, 0},	/* ARM */
@@ -118,6 +121,15 @@ static int get_node_info(ib_portid_t * dest, uint8_t * data)
 		return 0;
 }
 
+static int is_mlnx_ext_port_info_supported(uint32_t devid)
+{
+	if (devid == 0xc738)
+		return 1;
+	if (devid >= 0x1003 && devid <= 0x1010)
+		return 1;
+	return 0;
+}
+
 static int get_port_info(ib_portid_t * dest, uint8_t * data, int portnum,
 			 int is_switch)
 {
@@ -212,6 +224,33 @@ static void set_port_info(ib_portid_t * dest, uint8_t * data, int portnum,
 	show_port_info(dest, data, portnum, espeed_cap);
 }
 
+static void get_ext_port_info(ib_portid_t * dest, uint8_t * data, int portnum)
+{
+	if (!smp_query_via(data, dest, IB_ATTR_MLNX_EXT_PORT_INFO,
+			   portnum, 0, srcport))
+		IBERROR("smp query ext portinfo failed");
+}
+
+static void show_ext_port_info(ib_portid_t * dest, uint8_t * data, int portnum)
+{
+	char buf[256];
+
+	mad_dump_mlnx_ext_port_info(buf, sizeof buf, data, IB_SMP_DATA_SIZE);
+
+	printf("# Extended Port info: %s port %d\n%s", portid2str(dest),
+	       portnum, buf);
+}
+
+static void set_ext_port_info(ib_portid_t * dest, uint8_t * data, int portnum)
+{
+	if (!smp_set_via(data, dest, IB_ATTR_MLNX_EXT_PORT_INFO,
+			 portnum, 0, srcport))
+		IBERROR("smp set ext portinfo failed");
+
+	printf("\nAfter ExtendedPortInfo set:\n");
+	show_ext_port_info(dest, data, portnum);
+}
+
 static int get_link_width(int lwe, int lws)
 {
 	if (lwe == 255)
@@ -303,17 +342,21 @@ int main(int argc, char **argv)
 	ib_portid_t portid = { 0 };
 	int port_op = -1;
 	int is_switch, is_peer_switch, espeed_cap, peer_espeed_cap;
-	int state, physstate, lwe, lws, lwa, lse, lss, lsa, lsee, lses, lsea;
+	int state, physstate, lwe, lws, lwa, lse, lss, lsa, lsee, lses, lsea,
+	    fdr10s, fdr10e, fdr10a;
 	int peerlocalportnum, peerlwe, peerlws, peerlwa, peerlse, peerlss,
-	    peerlsa, peerlsee, peerlses, peerlsea;
+	    peerlsa, peerlsee, peerlses, peerlsea, peerfdr10s, peerfdr10e,
+	    peerfdr10a;
 	int peerwidth, peerspeed, peerespeed;
 	uint8_t data[IB_SMP_DATA_SIZE] = { 0 };
+	uint8_t data2[IB_SMP_DATA_SIZE] = { 0 };
 	ib_portid_t peerportid = { 0 };
 	int portnum = 0;
 	ib_portid_t selfportid = { 0 };
 	int selfport = 0;
 	int changed = 0;
 	int i;
+	uint16_t devid, rem_devid;
 	long val;
 	char usage_args[] = "<dest dr_path|lid|guid> <portnum> [<op>]\n"
 	    "\nSupported ops: enable, disable, reset, speed, width, query,\n"
@@ -379,6 +422,10 @@ int main(int argc, char **argv)
 				if (val < 0 || val > 31)
 					IBERROR("invalid extended speed value %ld", val);
 				break;
+			case FDR10SPEED:
+				if (val < 0 || val > 1)
+					IBERROR("invalid fdr10 speed value %ld", val);
+				break;
 			case WIDTH:
 				if (val < 0 || (val > 15 && val != 255))
 					IBERROR("invalid width value %ld", val);
@@ -415,6 +462,7 @@ int main(int argc, char **argv)
 		port_op = QUERY;
 
 	is_switch = get_node_info(&portid, data);
+	devid = mad_get_field(data, 0, IB_NODE_DEVID_F);
 
 	if (port_op != QUERY || changed)
 		printf("Initial %s PortInfo:\n", is_switch ? "Switch" : "CA");
@@ -422,6 +470,10 @@ int main(int argc, char **argv)
 		printf("%s PortInfo:\n", is_switch ? "Switch" : "CA");
 	espeed_cap = get_port_info(&portid, data, portnum, is_switch);
 	show_port_info(&portid, data, portnum, espeed_cap);
+	if (is_mlnx_ext_port_info_supported(devid)) {
+		get_ext_port_info(&portid, data2, portnum);
+		show_ext_port_info(&portid, data2, portnum);
+	}
 
 	if (port_op != QUERY || changed) {
 		/*
@@ -475,6 +527,15 @@ int main(int argc, char **argv)
 		if (port_args[LMC].set)
 			mad_set_field(data, 0, IB_PORT_LMC_F, lmc);
 
+		if (port_args[FDR10SPEED].set) {
+			mad_set_field(data2, 0,
+				      IB_MLNX_EXT_PORT_STATE_CHG_ENABLE_F,
+				      FDR10);
+			mad_set_field(data2, 0,
+				      IB_MLNX_EXT_PORT_LINK_SPEED_ENABLED_F,
+				      fdr10);
+			set_ext_port_info(&portid, data2, portnum);
+		}
 		set_port_info(&portid, data, portnum, is_switch);
 
 	} else if (is_switch && portnum) {
@@ -495,6 +556,15 @@ int main(int argc, char **argv)
 					 &lsa);
 			mad_decode_field(data, IB_PORT_LINK_SPEED_ENABLED_F,
 					 &lse);
+			mad_decode_field(data2,
+					 IB_MLNX_EXT_PORT_LINK_SPEED_SUPPORTED_F,
+					 &fdr10s);
+			mad_decode_field(data2,
+					 IB_MLNX_EXT_PORT_LINK_SPEED_ENABLED_F,
+					 &fdr10e);
+			mad_decode_field(data2,
+					 IB_MLNX_EXT_PORT_LINK_SPEED_ACTIVE_F,
+					 &fdr10a);
 			if (espeed_cap) {
 				mad_decode_field(data,
 						 IB_PORT_LINK_SPEED_EXT_SUPPORTED_F,
@@ -521,6 +591,7 @@ int main(int argc, char **argv)
 
 			/* Get peer port NodeInfo to obtain peer port number */
 			is_peer_switch = get_node_info(&peerportid, data);
+			rem_devid = mad_get_field(data, 0, IB_NODE_DEVID_F);
 
 			mad_decode_field(data, IB_NODE_LOCAL_PORT_F,
 					 &peerlocalportnum);
@@ -530,8 +601,14 @@ int main(int argc, char **argv)
 			peer_espeed_cap = get_port_info(&peerportid, data,
 							peerlocalportnum,
 							is_peer_switch);
+			if (is_mlnx_ext_port_info_supported(rem_devid))
+				get_ext_port_info(&peerportid, data2,
+						  peerlocalportnum);
 			show_port_info(&peerportid, data, peerlocalportnum,
 				       peer_espeed_cap);
+			if (is_mlnx_ext_port_info_supported(rem_devid))
+				show_ext_port_info(&peerportid, data2,
+						   peerlocalportnum);
 
 			mad_decode_field(data, IB_PORT_LINK_WIDTH_ENABLED_F,
 					 &peerlwe);
@@ -545,6 +622,15 @@ int main(int argc, char **argv)
 					 &peerlsa);
 			mad_decode_field(data, IB_PORT_LINK_SPEED_ENABLED_F,
 					 &peerlse);
+			mad_decode_field(data2,
+					 IB_MLNX_EXT_PORT_LINK_SPEED_SUPPORTED_F,
+					 &peerfdr10s);
+			mad_decode_field(data2,
+					 IB_MLNX_EXT_PORT_LINK_SPEED_ENABLED_F,
+					 &peerfdr10e);
+			mad_decode_field(data2,
+					 IB_MLNX_EXT_PORT_LINK_SPEED_ACTIVE_F,
+					 &peerfdr10a);
 			if (peer_espeed_cap) {
 				mad_decode_field(data,
 						 IB_PORT_LINK_SPEED_EXT_SUPPORTED_F,
@@ -574,6 +660,11 @@ int main(int argc, char **argv)
 								peerlses);
 				validate_extended_speed(espeed, peerespeed,
 							lsea);
+			} else {
+				if (fdr10e & FDR10 && peerfdr10e & FDR10) {
+					if (!(fdr10a & FDR10))
+						IBWARN("Peer ports operating at  active speed %d rather than FDR10", lsa);
+				}
 			}
 		}
 	}
-- 
1.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
