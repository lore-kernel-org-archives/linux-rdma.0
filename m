From: Ilya Nelkenbaum <ilyan-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] ibsim/Makefile: Add install rpath to linker
Date: Thu, 27 Oct 2016 16:55:31 +0300
Message-ID: <1477576531-29723-1-git-send-email-ilyan@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 ibsim/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/ibsim/Makefile b/ibsim/Makefile
index 5d1ac62..ad94651 100644
--- a/ibsim/Makefile
+++ b/ibsim/Makefile
@@ -1,5 +1,7 @@
 progs:=ibsim
 
+ibsim_LDFLAGS = "-Wl,-rpath,\$$ORIGIN/../lib"
+
 -include ../defs.mk
 
 all: $(progs)
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
