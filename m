From: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags/src/perfquery.c: Fix all_ports corner case
Date: Thu, 13 Sep 2012 23:16:14 -0700
Message-ID: <1347603374.19910.3.camel@crazyclimber.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

if AllPortSelect is not supported and --all_ports is specified, it should
only emulate AllPortSelect if no port is specified or the all ports
port number (255) is specified.

Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 src/perfquery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/perfquery.c b/src/perfquery.c
index 27ec4f7..605ece9 100644
--- a/src/perfquery.c
+++ b/src/perfquery.c
@@ -783,7 +783,7 @@ int main(int argc, char **argv)
 	if (!(cap_mask & IB_PM_ALL_PORT_SELECT)) {	/* bit 8 is AllPortSelect */
 		if (!all_ports && port == ALL_PORTS)
 			IBERROR("AllPortSelect not supported");
-		if (all_ports)
+		if (all_ports && port == ALL_PORTS)
 			all_ports_loop = 1;
 	}
 
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
