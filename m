From: Ursula Braun <ubraun@linux.vnet.ibm.com>
Subject: [PATCH net-next 06/10] net/smc: remove Kconfig warning
Date: Fri, 28 Jul 2017 13:56:18 +0200
Message-ID: <20170728115622.17247-7-ubraun@linux.vnet.ibm.com>
References: <20170728115622.17247-1-ubraun@linux.vnet.ibm.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20170728115622.17247-1-ubraun@linux.vnet.ibm.com>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: hch@lst.de, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, jwi@linux.vnet.ibm.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, raspl@linux.vnet.ibm.com, ubraun@linux.vnet.ibm.com
List-Id: linux-rdma@vger.kernel.org

Now separate memory regions are created and registered for separate
RMBs. The unsafe_global_rkey of the protection domain is no longer
used. Thus the exposing memory warning can be removed.

Signed-off-by: Ursula Braun <ubraun@linux.vnet.ibm.com>
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
