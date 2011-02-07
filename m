From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] umad_send.3 (man page)
Date: Mon, 7 Feb 2011 10:10:11 -0600
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB4A20B28010@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <openfabrics-ewg-0P3JtQMG0aQdnm+yROfE0A@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The man page for umad_send() does not match the source code.

Signed-off-by: Michael Heinz Michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
---
diff --git a/libibumad/man/umad_send.3 b/libibumad/man/umad_send.3
index 2d84f57..c4a617a 100644
--- a/libibumad/man/umad_send.3
+++ b/libibumad/man/umad_send.3
@@ -7,11 +7,13 @@ umad_send \- send umad
 .nf
 .B #include <infiniband/umad.h>
 .sp
-.BI "int umad_send(int " "portid" ", int " "agentid" ", void " "*umad" ", int " "timeout_ms" ", int " "retries");
+.BI "int umad_send(int " "portid" ", int " "agentid" ", void " "*umad" ", int " "length" ", int " "timeout_ms" ", int " "retries");
 .fi
 .SH "DESCRIPTION"
 .B umad_send()
-sends the specified
+sends
+.I length\fR
+bytes from the specified
 .I umad\fR
 buffer from the port specified by
 .I portid\fR,

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
