From: Colin King <colin.king@canonical.com>
Subject: [PATCH] net: rds: fix spelling mistake "syctl" -> "sysctl"
Date: Fri,  3 May 2019 13:10:17 +0100
Message-ID: <20190503121017.5227-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Santosh Shilimkar <santosh.shilimkar@oracle.com>, "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a pr_warn warning. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/rds/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index faf726e00e27..66121bc6f34e 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -551,7 +551,7 @@ static __net_init int rds_tcp_init_net(struct net *net)
 		tbl = kmemdup(rds_tcp_sysctl_table,
 			      sizeof(rds_tcp_sysctl_table), GFP_KERNEL);
 		if (!tbl) {
-			pr_warn("could not set allocate syctl table\n");
+			pr_warn("could not set allocate sysctl table\n");
 			return -ENOMEM;
 		}
 		rtn->ctl_table = tbl;
-- 
2.20.1
