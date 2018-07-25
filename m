From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] rds: send: Fix dead code in rds_sendmsg
Date: Wed, 25 Jul 2018 10:22:27 -0500
Message-ID: <20180725152227.GA26303@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Ka-Cheong Poon <ka-cheong.poon@oracle.com>, Santosh Shilimkar <santosh.shilimkar@oracle.com>, "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-rdma@vger.kernel.org

Currently, code at label *out* is unreachable. Fix this by updating
variable *ret* with -EINVAL, so the jump to *out* can be properly
executed instead of directly returning from function.

Addresses-Coverity-ID: 1472059 ("Structurally dead code")
Fixes: 1e2b44e78eea ("rds: Enable RDS IPv6 support")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 net/rds/send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/send.c b/net/rds/send.c
index 9604e1f..18e2b4d 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -1126,7 +1126,7 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 				if (addr4 == htonl(INADDR_ANY) ||
 				    addr4 == htonl(INADDR_BROADCAST) ||
 				    IN_MULTICAST(ntohl(addr4))) {
-					return -EINVAL;
+					ret = -EINVAL;
 					goto out;
 				}
 			}
-- 
2.7.4
