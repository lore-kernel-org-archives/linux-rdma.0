From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 1/2] ibsim: Remove parse corner case with full
	ibnetdiscover output
Date: Thu, 13 Jun 2013 14:30:40 -0700
Message-ID: <1371159040.13124.181.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When feeding in ibnetdiscover full output (i.e. -f option), ibsim
would not parse the lid and lmc of ports correctly.

Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 ibsim/sim_net.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/ibsim/sim_net.c b/ibsim/sim_net.c
index 13c3b8c..10820ba 100644
--- a/ibsim/sim_net.c
+++ b/ibsim/sim_net.c
@@ -679,7 +679,6 @@ static int parse_port(char *line, Node * node, int type, int maxports)
 			IBWARN("bad port option");
 			return -1;
 		}
-		line = s + 1;
 	}
 	if (type != SWITCH_NODE && line && parse_port_lid_and_lmc(port, line) < 0) {
 		IBWARN("cannot parse lid, lmc");
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
