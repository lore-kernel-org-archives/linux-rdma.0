From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] libibumad: Add recent/missing SM/SA attributes
Date: Sat, 09 Mar 2013 08:53:38 -0500
Message-ID: <513B3EE2.1000706@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/infiniband/umad_sa.h b/include/infiniband/umad_sa.h
index aaf2ac1..eb7812d 100644
--- a/include/infiniband/umad_sa.h
+++ b/include/infiniband/umad_sa.h
@@ -82,6 +82,7 @@ enum {
 	UMAD_SA_ATTR_RANDOM_FT_REC	= 0x0016,
 	UMAD_SA_ATTR_MCAST_FT_REC	= 0x0017,
 	UMAD_SA_ATTR_SM_INFO_REC	= 0x0018,
+	UMAD_SA_ATTR_LINK_SPD_WIDTH_TABLE_REC = 0x0019,
 	UMAD_SA_ATTR_INFORM_INFO_REC	= 0x00F3,
 	UMAD_SA_ATTR_LINK_REC		= 0x0020,
 	UMAD_SA_ATTR_GUID_INFO_REC	= 0x0030,
@@ -92,7 +93,9 @@ enum {
 	UMAD_SA_ATTR_MCMEMBER_REC	= 0x0038,
 	UMAD_SA_ATTR_TRACE_REC		= 0x0039,
 	UMAD_SA_ATTR_MULTI_PATH_REC	= 0x003A,
-	UMAD_SA_ATTR_SERVICE_ASSOC_REC	= 0x003B
+	UMAD_SA_ATTR_SERVICE_ASSOC_REC	= 0x003B,
+	UMAD_SA_ATTR_HIERARCHY_INFO_REC = 0x003C,
+	UMAD_SA_ATTR_CABLE_INFO_REC	= 0x003D
 };
 
 enum {
diff --git a/include/infiniband/umad_sm.h b/include/infiniband/umad_sm.h
index f6ee171..bd6833b 100644
--- a/include/infiniband/umad_sm.h
+++ b/include/infiniband/umad_sm.h
@@ -67,9 +67,12 @@ enum {
 	UMAD_SMP_ATTR_RANDOM_FT			= 0x001A,
 	UMAD_SMP_ATTR_MCAST_FT			= 0x001B,
 	UMAD_SMP_ATTR_LINK_SPD_WIDTH_TABLE	= 0x001C,
+	UMAD_SMP_ATTR_VENDOR_MADS_TABLE		= 0x001D,
+	UMAD_SMP_ATTR_HIERARCHY_INFO		= 0x001E,
 	UMAD_SMP_ATTR_SM_INFO			= 0x0020,
 	UMAD_SMP_ATTR_VENDOR_DIAG		= 0x0030,
 	UMAD_SMP_ATTR_LED_INFO			= 0x0031,
+	UMAD_SMP_ATTR_CABLE_INFO		= 0x0032,
 	UMAD_SMP_ATTR_VENDOR_MASK		= 0xFF00
 };
 
diff --git a/src/umad_str.c b/src/umad_str.c
index 957552f..a04b35b 100644
--- a/src/umad_str.c
+++ b/src/umad_str.c
@@ -233,6 +233,12 @@ static const char * umad_sm_attr_str(be16_t attr_id)
 			return ("LedInfo");
 		case UMAD_SMP_ATTR_LINK_SPD_WIDTH_TABLE:
 			return ("LinkSpeedWidthPairsTable");
+		case UMAD_SMP_ATTR_VENDOR_MADS_TABLE:
+			return ("VendorSpecificMadsTable");
+		case UMAD_SMP_ATTR_HIERARCHY_INFO:
+			return ("HierarchyInfo");
+		case UMAD_SMP_ATTR_CABLE_INFO:
+			return ("CableInfo");
 		default:
 			return (umad_common_attr_str(attr_id));
 	}
@@ -280,6 +286,12 @@ static const char * umad_sa_attr_str(be16_t attr_id)
 			return ("MultiPathRecord");
 		case UMAD_SA_ATTR_SERVICE_ASSOC_REC:
 			return ("ServiceAssociationRecord");
+		case UMAD_SA_ATTR_LINK_SPD_WIDTH_TABLE_REC:
+			return ("LinkSpeedWidthPairsTableRecord");
+		case UMAD_SA_ATTR_HIERARCHY_INFO_REC:
+			return ("HierarchyInfoRecord");
+		case UMAD_SA_ATTR_CABLE_INFO_REC:
+			return ("CableInfoRecord");
 		default:
 			return (umad_common_attr_str(attr_id));
 	}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
