From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] ibsim: Set issm flag on connect when SIM_SET_ISSM set
Date: Fri, 21 Jun 2013 11:28:05 -0700
Message-ID: <1371839285.19017.136.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When the SIM_SET_ISSM environment variable is set, ibsim did not
set the issm bit until after an ibsim connection was complete.  This
allowed multiple SMs to actively run as the SM on the same port.

Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 umad2sim/sim_client.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/umad2sim/sim_client.c b/umad2sim/sim_client.c
index eb42a7c..5a04be5 100644
--- a/umad2sim/sim_client.c
+++ b/umad2sim/sim_client.c
@@ -178,7 +178,10 @@ static int sim_connect(struct sim_client *sc, int id, int qp, char *nodeid)
 	struct sim_client_info info = { 0 };
 
 	info.id = id;
-	info.issm = 0;
+	if (getenv("SIM_SET_ISSM"))
+		info.issm = 1;
+	else
+		info.issm = 0;
 	info.qp = qp;
 
 	if (nodeid)
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
