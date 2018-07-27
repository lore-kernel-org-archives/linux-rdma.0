From: Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH] net/rds/Kconfig: Correct the RDS depends
Date: Fri, 27 Jul 2018 15:18:49 +0200
Message-ID: <20180727131849.18488-1-anders.roxell@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: santosh.shilimkar@oracle.com, davem@davemloft.net, eric.dumazet@gmail.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org, Anders Roxell <anders.roxell@linaro.org>
List-Id: linux-rdma@vger.kernel.org

Remove prefix 'CONFIG_' from CONFIG_IPV6

Fixes: ba7d7e2677c0 ("net/rds/Kconfig: RDS should depend on IPV6")
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 net/rds/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/Kconfig b/net/rds/Kconfig
index 607128f10bcd..4c7f2595d919 100644
--- a/net/rds/Kconfig
+++ b/net/rds/Kconfig
@@ -1,7 +1,7 @@
 
 config RDS
 	tristate "The RDS Protocol"
-	depends on INET && CONFIG_IPV6
+	depends on INET && IPV6
 	---help---
 	  The RDS (Reliable Datagram Sockets) protocol provides reliable,
 	  sequenced delivery of datagrams over Infiniband or TCP.
-- 
2.18.0
