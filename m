From: Ursula Braun <ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [RFC net-next 06/10] net/smc: remove Kconfig warning
Date: Thu, 20 Jul 2017 14:09:42 +0200
Message-ID: <20170720120946.67234-7-ubraun@linux.vnet.ibm.com>
References: <20170720120946.67234-1-ubraun@linux.vnet.ibm.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170720120946.67234-1-ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hch-jcswGhMUV9g@public.gmane.org, schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, hwippel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, raspl-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Now separate memory regions are created and registered for separate
RMBs. The unsafe_global_rkey of the protection domain is no longer
used. Thus the exposing memory warning can be removed.

Signed-off-by: Ursula Braun <ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 net/smc/Kconfig | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/smc/Kconfig b/net/smc/Kconfig
index 33954852f3f8..c717ef0896aa 100644
--- a/net/smc/Kconfig
+++ b/net/smc/Kconfig
@@ -8,10 +8,6 @@ config SMC
 	  The Linux implementation of the SMC-R solution is designed as
 	  a separate socket family SMC.
 
-	  Warning: SMC will expose all memory for remote reads and writes
-	  once a connection is established.  Don't enable this option except
-	  for tightly controlled lab environment.
-
 	  Select this option if you want to run SMC socket applications
 
 config SMC_DIAG
-- 
2.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
