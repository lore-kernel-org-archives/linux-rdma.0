From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/opensm.8.in: Fix cut 'n paste error
Date: Thu, 23 Feb 2012 07:41:44 -0500
Message-ID: <4F463408.5010700@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/man/opensm.8.in b/man/opensm.8.in
index 12b9976..83f8bf5 100644
--- a/man/opensm.8.in
+++ b/man/opensm.8.in
@@ -221,7 +221,7 @@ attempt to alleviate this problem.
 \fB\-\-scatter\-ports\fR
 This option will randomize port selecting in routing.
 .TP
-\fB\-H\fR, \fB\-\-max_reverse_hops\fR <file name>
+\fB\-H\fR, \fB\-\-max_reverse_hops\fR <max reverse hops allowed>
 Set the maximum number of reverse hops an I/O node is allowed
 to make. A reverse hop is the use of a switch the wrong way around.
 .TP
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
