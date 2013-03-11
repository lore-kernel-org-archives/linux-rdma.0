From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] libibumad: Rename attributes UMAD_SM_ATTR_XYZ rather than
 UMAD_SMP_ATTR_XYZ
Date: Mon, 11 Mar 2013 13:15:34 -0400
Message-ID: <513E1136.2010604@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/infiniband/umad_sm.h b/include/infiniband/umad_sm.h
index bd6833b..0ef3863 100644
--- a/include/infiniband/umad_sm.h
+++ b/include/infiniband/umad_sm.h
@@ -55,25 +55,25 @@ enum {
 
 /* Subnet management attributes */
 enum {
-	UMAD_SMP_ATTR_NODE_DESC			= 0x0010,
-	UMAD_SMP_ATTR_NODE_INFO			= 0x0011,
-	UMAD_SMP_ATTR_SWITCH_INFO		= 0x0012,
-	UMAD_SMP_ATTR_GUID_INFO			= 0x0014,
-	UMAD_SMP_ATTR_PORT_INFO			= 0x0015,
-	UMAD_SMP_ATTR_PKEY_TABLE		= 0x0016,
-	UMAD_SMP_ATTR_SLVL_TABLE		= 0x0017,
-	UMAD_SMP_ATTR_VL_ARB_TABLE		= 0x0018,
-	UMAD_SMP_ATTR_LINEAR_FT			= 0x0019,
-	UMAD_SMP_ATTR_RANDOM_FT			= 0x001A,
-	UMAD_SMP_ATTR_MCAST_FT			= 0x001B,
-	UMAD_SMP_ATTR_LINK_SPD_WIDTH_TABLE	= 0x001C,
-	UMAD_SMP_ATTR_VENDOR_MADS_TABLE		= 0x001D,
-	UMAD_SMP_ATTR_HIERARCHY_INFO		= 0x001E,
-	UMAD_SMP_ATTR_SM_INFO			= 0x0020,
-	UMAD_SMP_ATTR_VENDOR_DIAG		= 0x0030,
-	UMAD_SMP_ATTR_LED_INFO			= 0x0031,
-	UMAD_SMP_ATTR_CABLE_INFO		= 0x0032,
-	UMAD_SMP_ATTR_VENDOR_MASK		= 0xFF00
+	UMAD_SM_ATTR_NODE_DESC			= 0x0010,
+	UMAD_SM_ATTR_NODE_INFO			= 0x0011,
+	UMAD_SM_ATTR_SWITCH_INFO		= 0x0012,
+	UMAD_SM_ATTR_GUID_INFO			= 0x0014,
+	UMAD_SM_ATTR_PORT_INFO			= 0x0015,
+	UMAD_SM_ATTR_PKEY_TABLE			= 0x0016,
+	UMAD_SM_ATTR_SLVL_TABLE			= 0x0017,
+	UMAD_SM_ATTR_VL_ARB_TABLE		= 0x0018,
+	UMAD_SM_ATTR_LINEAR_FT			= 0x0019,
+	UMAD_SM_ATTR_RANDOM_FT			= 0x001A,
+	UMAD_SM_ATTR_MCAST_FT			= 0x001B,
+	UMAD_SM_ATTR_LINK_SPD_WIDTH_TABLE	= 0x001C,
+	UMAD_SM_ATTR_VENDOR_MADS_TABLE		= 0x001D,
+	UMAD_SM_ATTR_HIERARCHY_INFO		= 0x001E,
+	UMAD_SM_ATTR_SM_INFO			= 0x0020,
+	UMAD_SM_ATTR_VENDOR_DIAG		= 0x0030,
+	UMAD_SM_ATTR_LED_INFO			= 0x0031,
+	UMAD_SM_ATTR_CABLE_INFO			= 0x0032,
+	UMAD_SM_ATTR_VENDOR_MASK		= 0xFF00
 };
 
 enum {
diff --git a/src/umad_str.c b/src/umad_str.c
index a04b35b..0a000f3 100644
--- a/src/umad_str.c
+++ b/src/umad_str.c
@@ -203,41 +203,41 @@ static const char *umad_common_attr_str(be16_t attr_id)
 static const char * umad_sm_attr_str(be16_t attr_id)
 {
 	switch(ntohs(attr_id)) {
-		case UMAD_SMP_ATTR_NODE_DESC:
+		case UMAD_SM_ATTR_NODE_DESC:
 			return ("NodeDescription");
-		case UMAD_SMP_ATTR_NODE_INFO:
+		case UMAD_SM_ATTR_NODE_INFO:
 			return ("NodeInfo");
-		case UMAD_SMP_ATTR_SWITCH_INFO:
+		case UMAD_SM_ATTR_SWITCH_INFO:
 			return ("SwitchInfo");
-		case UMAD_SMP_ATTR_GUID_INFO:
+		case UMAD_SM_ATTR_GUID_INFO:
 			return ("GUIDInfo");
-		case UMAD_SMP_ATTR_PORT_INFO:
+		case UMAD_SM_ATTR_PORT_INFO:
 			return ("PortInfo");
-		case UMAD_SMP_ATTR_PKEY_TABLE:
+		case UMAD_SM_ATTR_PKEY_TABLE:
 			return ("P_KeyTable");
-		case UMAD_SMP_ATTR_SLVL_TABLE:
+		case UMAD_SM_ATTR_SLVL_TABLE:
 			return ("SLtoVLMappingTable");
-		case UMAD_SMP_ATTR_VL_ARB_TABLE:
+		case UMAD_SM_ATTR_VL_ARB_TABLE:
 			return ("VLArbitrationTable");
-		case UMAD_SMP_ATTR_LINEAR_FT:
+		case UMAD_SM_ATTR_LINEAR_FT:
 			return ("LinearForwardingTable");
-		case UMAD_SMP_ATTR_RANDOM_FT:
+		case UMAD_SM_ATTR_RANDOM_FT:
 			return ("RandomForwardingTable");
-		case UMAD_SMP_ATTR_MCAST_FT:
+		case UMAD_SM_ATTR_MCAST_FT:
 			return ("MulticastForwardingTable");
-		case UMAD_SMP_ATTR_SM_INFO:
+		case UMAD_SM_ATTR_SM_INFO:
 			return ("SMInfo");
-		case UMAD_SMP_ATTR_VENDOR_DIAG:
+		case UMAD_SM_ATTR_VENDOR_DIAG:
 			return ("VendorDiag");
-		case UMAD_SMP_ATTR_LED_INFO:
+		case UMAD_SM_ATTR_LED_INFO:
 			return ("LedInfo");
-		case UMAD_SMP_ATTR_LINK_SPD_WIDTH_TABLE:
+		case UMAD_SM_ATTR_LINK_SPD_WIDTH_TABLE:
 			return ("LinkSpeedWidthPairsTable");
-		case UMAD_SMP_ATTR_VENDOR_MADS_TABLE:
+		case UMAD_SM_ATTR_VENDOR_MADS_TABLE:
 			return ("VendorSpecificMadsTable");
-		case UMAD_SMP_ATTR_HIERARCHY_INFO:
+		case UMAD_SM_ATTR_HIERARCHY_INFO:
 			return ("HierarchyInfo");
-		case UMAD_SMP_ATTR_CABLE_INFO:
+		case UMAD_SM_ATTR_CABLE_INFO:
 			return ("CableInfo");
 		default:
 			return (umad_common_attr_str(attr_id));
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
