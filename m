From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH libibmad] dump.c: In mad_dump_linkwidth, output undefined
 widths
Date: Tue, 15 Apr 2014 13:35:29 -0400
Message-ID: <534D6DE1.4010306@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ammar Haj Hamad <ahamad-DMD6N21cJuFWk0Htik3J/w@public.gmane.org>, "rafiw-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <rafiw-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Based on patch for this for width 0 from Ammar Haj Hamad <ahamad-DMD6N21cJuFWk0Htik3J/w@public.gmane.org>

Some implementations when port is down appear to return a link width of 0

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/dump.c b/src/dump.c
index 7f3ef7d..efe4bc4 100644
--- a/src/dump.c
+++ b/src/dump.c
@@ -185,7 +185,8 @@ void mad_dump_linkwidth(char *buf, int bufsz, void *val, int valsz)
 		break;
 	default:
 		IBWARN("bad width %d", width);
-		buf[0] = 0;
+		snprintf(buf, bufsz, "undefined (%d)", width);
+		break;
 	}
 }
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
