From: Zhu Yanjun <yanjun.zhu@oracle.com>
Subject: [PATCH 1/1] net: rds: remove unnecessary NULL check
Date: Sun, 30 Dec 2018 23:24:11 +0800
Message-ID: <20181230152411.15096-1-yanjun.zhu@oracle.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: santosh.shilimkar@oracle.com, davem@davemloft.net, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc: Zhu Yanjun <yanjun.zhu@oracle.com>
List-Id: linux-rdma@vger.kernel.org

In kfree, the NULL check is done.

Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
---
 net/rds/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index b9bbcf3d6c63..c16f0a362c32 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -623,7 +623,7 @@ static void __net_exit rds_tcp_exit_net(struct net *net)
 	if (rtn->rds_tcp_sysctl)
 		unregister_net_sysctl_table(rtn->rds_tcp_sysctl);
 
-	if (net != &init_net && rtn->ctl_table)
+	if (net != &init_net)
 		kfree(rtn->ctl_table);
 }
 
-- 
2.17.1
