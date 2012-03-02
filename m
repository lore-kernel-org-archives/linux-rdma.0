From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm/man/opensm.8.in: Add description for OSM_LOG_SYS
 logging flag
Date: Fri, 02 Mar 2012 08:10:27 -0500
Message-ID: <4F50C6C3.4010605@dev.mellanox.co.il>
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
 man/opensm.8.in |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/man/opensm.8.in b/man/opensm.8.in
index 12b9976..720254e 100644
--- a/man/opensm.8.in
+++ b/man/opensm.8.in
@@ -439,7 +439,7 @@ specific log level as follows:
  0x10 - FUNCS (function entry/exit, very high volume)
  0x20 - FRAMES (dumps all SMP and GMP frames)
  0x40 - ROUTING (dump FDB routing information)
- 0x80 - currently unused.
+ 0x80 - SYS (syslog at LOG_INFO level in addition to OpenSM logging)
 
 Without -D, OpenSM defaults to ERROR + INFO (0x3).
 Specifying -D 0 disables all messages.
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
