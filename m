From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] ibacm/acm.c: LID format should be unsigned decimal
Date: Fri, 06 Apr 2012 09:31:10 -0400
Message-ID: <4F7EF01E.8020300@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


so that unicast LIDs >= 0x8000 and < 0xc000 display as
positive rather than negative numbers.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/acm.c b/src/acm.c
index d47f9d6..e17b8a6 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -267,7 +267,7 @@ acm_format_name(int level, char *name, size_t name_size,
 	case ACM_EP_INFO_PATH:
 		path = (struct ibv_path_record *) addr;
 		if (path->dlid) {
-			sprintf(name, "SLID(%d) DLID(%d)",
+			sprintf(name, "SLID(%u) DLID(%u)",
 				ntohs(path->slid), ntohs(path->dlid));
 		} else {
 			acm_format_name(level, name, name_size, ACM_ADDRESS_GID,
@@ -275,7 +275,7 @@ acm_format_name(int level, char *name, size_t name_size,
 		}
 		break;
 	case ACM_ADDRESS_LID:
-		sprintf(name, "LID(%d)", ntohs(*((uint16_t *) addr)));
+		sprintf(name, "LID(%u)", ntohs(*((uint16_t *) addr)));
 		break;
 	default:
 		strcpy(name, "Unknown");
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
