From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv3] infiniband-diags/vendstat.c: Support IS4/SX firmware
 version info
Date: Wed, 18 Apr 2012 16:27:09 +0300
Message-ID: <20120418132709.GD5326@calypso>
References: <20120418081407.GA5326@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120418081407.GA5326@calypso>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, Adam Habari <adamh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Adam Habari <adamh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Changes since v2:
Added copyright
Some minor cosmetic formatting changes detected by checkpatch

diff --git a/src/vendstat.c b/src/vendstat.c
index 1d3d78c..413d202 100644
--- a/src/vendstat.c
+++ b/src/vendstat.c
@@ -1,4 +1,5 @@
 /*
+ * Copyright (c) 2012 Mellanox Technologies LTD.  All rights reserved.
  * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -57,6 +58,9 @@
 /* Config space addresses */
 #define IB_MLX_IS3_PORT_XMIT_WAIT	0x10013C
 
+#define IS4_DEV_ID 0x01b3
+#define SX_DEV_ID 0x0245
+
 struct ibmad_port *srcport;
 
 typedef struct {
@@ -82,6 +86,12 @@ typedef struct {
 } is3_fw_info_t;
 
 typedef struct {
+	uint32_t ext_major;
+	uint32_t ext_minor;
+	uint32_t ext_sub_minor;
+} is4_fw_ext_info_t;
+
+typedef struct {
 	uint8_t resv1;
 	uint8_t major;
 	uint8_t minor;
@@ -98,6 +108,14 @@ typedef struct {
 
 typedef struct {
 	uint8_t reserved[8];
+	is3_hw_info_t hw_info;
+	is3_fw_info_t fw_info;
+	is4_fw_ext_info_t ext_fw_info;
+	is3_sw_info_t sw_info;
+} is4_general_info_t;
+
+typedef struct {
+	uint8_t reserved[8];
 	struct is3_record {
 		uint32_t address;
 		uint32_t data;
@@ -291,8 +309,11 @@ int main(int argc, char **argv)
 	ib_portid_t portid = { 0 };
 	int port = 0;
 	char buf[1024];
-	is3_general_info_t *gi;
-
+	uint32_t fw_ver_major = 0;
+	uint32_t fw_ver_minor = 0;
+	uint32_t fw_ver_sub_minor = 0;
+	is3_general_info_t *gi_is3;
+	is4_general_info_t *gi_is4;
 	const struct ibdiag_opt opts[] = {
 		{"N", 'N', 0, NULL, "show IS3 or IS4 general information"},
 		{"w", 'w', 0, NULL, "show IS3 port xmit wait counters"},
@@ -372,37 +393,48 @@ int main(int argc, char **argv)
 		IBERROR("classportinfo query");
 
 	memset(&buf, 0, sizeof(buf));
-	gi = (is3_general_info_t *) & buf;
+	gi_is3 = (is3_general_info_t *) &buf;
 	if (do_vendor(&portid, srcport, IB_MLX_VENDOR_CLASS, IB_MAD_METHOD_GET,
-		      IB_MLX_IS3_GENERAL_INFO, 0, gi))
+		      IB_MLX_IS3_GENERAL_INFO, 0, gi_is3))
 		IBERROR("generalinfo query");
 
+	if (IS4_DEV_ID == ntohs(gi_is3->hw_info.device_id) ||
+	    SX_DEV_ID == ntohs(gi_is3->hw_info.device_id)) {
+		gi_is4 = (is4_general_info_t *) &buf;
+		fw_ver_major = ntohl(gi_is4->ext_fw_info.ext_major);
+		fw_ver_minor = ntohl(gi_is4->ext_fw_info.ext_minor);
+		fw_ver_sub_minor = ntohl(gi_is4->ext_fw_info.ext_sub_minor);
+	} else {
+		fw_ver_major = gi_is3->fw_info.major;
+		fw_ver_minor = gi_is3->fw_info.minor;
+		fw_ver_sub_minor = gi_is3->fw_info.sub_minor;
+	}
+
 	if (general_info) {
 		/* dump IS3 or IS4 general info here */
-		printf("hw_dev_rev:  0x%04x\n", ntohs(gi->hw_info.hw_revision));
-		printf("hw_dev_id:   0x%04x\n", ntohs(gi->hw_info.device_id));
-		printf("hw_uptime:   0x%08x\n", ntohl(gi->hw_info.uptime));
+		printf("hw_dev_rev:  0x%04x\n", ntohs(gi_is3->hw_info.hw_revision));
+		printf("hw_dev_id:   0x%04x\n", ntohs(gi_is3->hw_info.device_id));
+		printf("hw_uptime:   0x%08x\n", ntohl(gi_is3->hw_info.uptime));
 		printf("fw_version:  %02d.%02d.%02d\n",
-		       gi->fw_info.major, gi->fw_info.minor,
-		       gi->fw_info.sub_minor);
-		printf("fw_build_id: 0x%04x\n", ntohl(gi->fw_info.build_id));
-		printf("fw_date:     %02d/%02d/%04x\n",
-		       gi->fw_info.month, gi->fw_info.day,
-		       ntohs(gi->fw_info.year));
-		printf("fw_psid:     '%s'\n", gi->fw_info.psid);
+		       fw_ver_major, fw_ver_minor, fw_ver_sub_minor);
+		printf("fw_build_id: 0x%04x\n", ntohl(gi_is3->fw_info.build_id));
+		printf("fw_date:     %02x/%02x/%04x\n",
+		       gi_is3->fw_info.month, gi_is3->fw_info.day,
+		       ntohs(gi_is3->fw_info.year));
+		printf("fw_psid:     '%s'\n", gi_is3->fw_info.psid);
 		printf("fw_ini_ver:  %d\n",
-		       ntohl(gi->fw_info.ini_file_version));
-		printf("sw_version:  %02d.%02d.%02d\n", gi->sw_info.major,
-		       gi->sw_info.minor, gi->sw_info.sub_minor);
+		       ntohl(gi_is3->fw_info.ini_file_version));
+		printf("sw_version:  %02d.%02d.%02d\n", gi_is3->sw_info.major,
+		       gi_is3->sw_info.minor, gi_is3->sw_info.sub_minor);
 	}
 
 	if (xmit_wait) {
 		is3_config_space_t *cs;
 		unsigned i;
 
-		if (ntohs(gi->hw_info.device_id) != IS3_DEVICE_ID)
+		if (ntohs(gi_is3->hw_info.device_id) != IS3_DEVICE_ID)
 			IBERROR("Unsupported device ID 0x%x",
-				ntohs(gi->hw_info.device_id));
+				ntohs(gi_is3->hw_info.device_id));
 
 		memset(&buf, 0, sizeof(buf));
 		/* Set record addresses for each port */
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
