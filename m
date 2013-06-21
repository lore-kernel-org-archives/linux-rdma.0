From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 05/15 ibacm] ibacm*.cfg: Fix commentary typos
Date: Fri, 21 Jun 2013 07:01:37 -0400
Message-ID: <51C43291.7050504@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 ibacm_addr.cfg |    4 ++--
 ibacm_opts.cfg |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/ibacm_addr.cfg b/ibacm_addr.cfg
index dd2bd6e..c8f7f68 100644
--- a/ibacm_addr.cfg
+++ b/ibacm_addr.cfg
@@ -1,7 +1,7 @@
 # InfiniBand Communication Management Assistant for clusters address file
 #
 # Use ib_acme utility with -G option to automatically generate a sample
-# acm_addr.cfg file for the current system.
+# ibacm_addr.cfg file for the current system.
 #
 # Entry format is:
 # address device port pkey
@@ -21,4 +21,4 @@
 # node31-1    ibv_device0 1 0x00FF
 # node31-2    ibv_device0 2 0x00FF
 # 192.168.0.1 ibv_device0 1 0xFFFF
-# 192.168.0.2 ibv_device0 2 default
\ No newline at end of file
+# 192.168.0.2 ibv_device0 2 default
diff --git a/ibacm_opts.cfg b/ibacm_opts.cfg
index dc9823e..58069b8 100644
--- a/ibacm_opts.cfg
+++ b/ibacm_opts.cfg
@@ -1,7 +1,7 @@
 # InfiniBand Multicast Communication Manager for clusters configuration file
 #
 # Use ib_acme utility with -O option to automatically generate a sample
-# acm_opts.cfg file for the current system.
+# ibacm_opts.cfg file for the current system.
 #
 # Entry format is:
 # name value
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
