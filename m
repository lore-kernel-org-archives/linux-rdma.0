From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags 2/6] libibmad/dump.c: Add HDR support for
 PortInfo LinkSpeedExt* fields
Date: Tue, 28 Nov 2017 17:11:47 -0500
Message-ID: <41adffa2-8e7e-20da-19d6-523e89bca9a8@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Per MgtWG comments #9364-9366

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibmad/src/dump.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/libibmad/src/dump.c b/libibmad/src/dump.c
index 1f41e62..98d5a34 100644
--- a/libibmad/src/dump.c
+++ b/libibmad/src/dump.c
@@ -336,6 +336,9 @@ void mad_dump_linkspeedext(char *buf, int bufsz, void *val, int valsz)
 	case 2:
 		snprintf(buf, bufsz, "25.78125 Gbps");
 		break;
+	case 4:
+		snprintf(buf, bufsz, "53.125 Gbps");
+		break;
 	default:
 		snprintf(buf, bufsz, "undefined (%d)", speed);
 		break;
@@ -355,13 +358,16 @@ static void dump_linkspeedext(char *buf, int bufsz, int speed)
 		n += snprintf(buf + n, bufsz - n, "14.0625 Gbps or ");
 	if (n < bufsz && speed & 0x2)
 		n += snprintf(buf + n, bufsz - n, "25.78125 Gbps or ");
+	if (n < bufsz && speed & 0x4)
+		n += snprintf(buf + n, bufsz - n, "53.125 Gbps or ");
+
 	if (n >= bufsz) {
 		if (bufsz > 3)
 			buf[n - 4] = '\0';
 		return;
 	}
 
-	if (speed >> 2) {
+	if (speed >> 3) {
 		n += snprintf(buf + n, bufsz - n, "undefined (%d)", speed);
 		return;
 	} else if (bufsz > 3)
-- 
2.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
