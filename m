From: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH RFC 2/4] ib/core: handle FDR-10 link encoding
Date: Mon, 19 Sep 2011 19:06:17 +0300
Message-ID: <201109191906.18102.marcela@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Added support for new link encodings beyond the regular 8 to 10 bit encoding.
For now only FDR-10 (64 to 66 bit encoding) is implemented.

Signed-off-by: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/sysfs.c |    2 +-
 include/rdma/ib_verbs.h         |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

Index: b/drivers/infiniband/core/sysfs.c
===================================================================
--- a/drivers/infiniband/core/sysfs.c	2011-09-14 13:49:58.000000000 +0300
+++ b/drivers/infiniband/core/sysfs.c	2011-09-14 13:50:43.731775900 +0300
@@ -209,7 +209,7 @@ static ssize_t rate_show(struct ib_port
 			speed = " DDR";
 			break;
 		case 4:
-			speed = " QDR";
+			speed = attr.link_encoding == 0 ? " QDR" : " FDR10";
 			break;
 		}
 
Index: b/include/rdma/ib_verbs.h
===================================================================
--- a/include/rdma/ib_verbs.h	2011-09-14 13:49:58.000000000 +0300
+++ b/include/rdma/ib_verbs.h	2011-09-14 13:50:43.740777700 +0300
@@ -319,6 +319,7 @@ struct ib_port_attr {
 	u8			active_speed;
 	u8                      phys_state;
 	u8                      ext_active_speed;
+	u8                      link_encoding;
 };
 
 enum ib_device_modify_flags {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
