From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags] ibportstate.c: Cosmetic changes to MLNX
 Extended PortInfo
Date: Tue, 10 Jun 2014 14:23:13 -0400
Message-ID: <53974D11.1030901@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


for consistency with smpquery mepi output:

smpquery mepi 24 1
# MLNX ext Port info: Lid 24 port 1
StateChangeEnable:...............0x00
LinkSpeedSupported:..............0x01
LinkSpeedEnabled:................0x01
LinkSpeedActive:.................0x00

and to prepare for IBTA extended PortInfo attribute

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/ibportstate.c b/src/ibportstate.c
index bf3c00c..47e9133 100644
--- a/src/ibportstate.c
+++ b/src/ibportstate.c
@@ -252,31 +252,31 @@ static void set_port_info(ib_portid_t * dest, uint8_t * data, int portnum,
 	show_port_info(dest, data, portnum, espeed_cap, is_switch);
 }
 
-static void get_ext_port_info(ib_portid_t * dest, uint8_t * data, int portnum)
+static void get_mlnx_ext_port_info(ib_portid_t * dest, uint8_t * data, int portnum)
 {
 	if (!smp_query_via(data, dest, IB_ATTR_MLNX_EXT_PORT_INFO,
 			   portnum, 0, srcport))
 		IBEXIT("smp query ext portinfo failed");
 }
 
-static void show_ext_port_info(ib_portid_t * dest, uint8_t * data, int portnum)
+static void show_mlnx_ext_port_info(ib_portid_t * dest, uint8_t * data, int portnum)
 {
 	char buf[256];
 
 	mad_dump_mlnx_ext_port_info(buf, sizeof buf, data, IB_SMP_DATA_SIZE);
 
-	printf("# Extended Port info: %s port %d\n%s", portid2str(dest),
+	printf("# MLNX ext Port info: %s port %d\n%s", portid2str(dest),
 	       portnum, buf);
 }
 
-static void set_ext_port_info(ib_portid_t * dest, uint8_t * data, int portnum)
+static void set_mlnx_ext_port_info(ib_portid_t * dest, uint8_t * data, int portnum)
 {
 	if (!smp_set_via(data, dest, IB_ATTR_MLNX_EXT_PORT_INFO,
 			 portnum, 0, srcport))
-		IBEXIT("smp set ext portinfo failed");
+		IBEXIT("smp set MLNX ext portinfo failed");
 
-	printf("\nAfter ExtendedPortInfo set:\n");
-	show_ext_port_info(dest, data, portnum);
+	printf("\nAfter MLNXExtendedPortInfo set:\n");
+	show_mlnx_ext_port_info(dest, data, portnum);
 }
 
 static int get_link_width(int lwe, int lws)
@@ -528,8 +528,8 @@ int main(int argc, char **argv)
 	espeed_cap = get_port_info(&portid, data, portnum, is_switch);
 	show_port_info(&portid, data, portnum, espeed_cap, is_switch);
 	if (is_mlnx_ext_port_info_supported(devid)) {
-		get_ext_port_info(&portid, data2, portnum);
-		show_ext_port_info(&portid, data2, portnum);
+		get_mlnx_ext_port_info(&portid, data2, portnum);
+		show_mlnx_ext_port_info(&portid, data2, portnum);
 	}
 
 	if (port_op != QUERY || changed) {
@@ -600,7 +600,7 @@ int main(int argc, char **argv)
 			mad_set_field(data2, 0,
 				      IB_MLNX_EXT_PORT_LINK_SPEED_ENABLED_F,
 				      fdr10);
-			set_ext_port_info(&portid, data2, portnum);
+			set_mlnx_ext_port_info(&portid, data2, portnum);
 		}
 
 		if (port_args[MKEY].set)
@@ -678,13 +678,13 @@ int main(int argc, char **argv)
 							peerlocalportnum,
 							is_peer_switch);
 			if (is_mlnx_ext_port_info_supported(rem_devid))
-				get_ext_port_info(&peerportid, data2,
-						  peerlocalportnum);
+				get_mlnx_ext_port_info(&peerportid, data2,
+						       peerlocalportnum);
 			show_port_info(&peerportid, data, peerlocalportnum,
 				       peer_espeed_cap, is_peer_switch);
 			if (is_mlnx_ext_port_info_supported(rem_devid))
-				show_ext_port_info(&peerportid, data2,
-						   peerlocalportnum);
+				show_mlnx_ext_port_info(&peerportid, data2,
+							peerlocalportnum);
 
 			mad_decode_field(data, IB_PORT_LINK_WIDTH_ENABLED_F,
 					 &peerlwe);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
