From: Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH] net/rds/Kconfig: RDS should depend on IPV6
Date: Thu, 26 Jul 2018 00:20:08 +0200
Message-ID: <20180725222008.32186-1-anders.roxell@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net, santosh.shilimkar@oracle.com, ka-cheong.poon@oracle.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org, Anders Roxell <anders.roxell@linaro.org>
List-Id: linux-rdma@vger.kernel.org

Build error, implicit declaration of function __inet6_ehashfn shows up
When RDS is enabled but not IPV6.
net/rds/connection.c: In function ‘rds_conn_bucket’:
net/rds/connection.c:67:9: error: implicit declaration of function ‘__inet6_ehashfn’; did you mean ‘__inet_ehashfn’? [-Werror=implicit-function-declaration]
  hash = __inet6_ehashfn(lhash, 0, fhash, 0, rds_hash_secret);
         ^~~~~~~~~~~~~~~
         __inet_ehashfn

Current code adds IPV6 as a depends on in config RDS.

Fixes: eee2fa6ab322 ("rds: Changing IP address internal representation to struct in6_addr")
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 net/rds/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/Kconfig b/net/rds/Kconfig
index 41f75563b54b..607128f10bcd 100644
--- a/net/rds/Kconfig
+++ b/net/rds/Kconfig
@@ -1,7 +1,7 @@
 
 config RDS
 	tristate "The RDS Protocol"
-	depends on INET
+	depends on INET && CONFIG_IPV6
 	---help---
 	  The RDS (Reliable Datagram Sockets) protocol provides reliable,
 	  sequenced delivery of datagrams over Infiniband or TCP.
-- 
2.18.0
