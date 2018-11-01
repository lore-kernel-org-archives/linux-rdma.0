From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next] rdma: Refresh help section of resource information
Date: Thu,  1 Nov 2018 10:35:05 +0200
Message-ID: <20181101083505.25152-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

After commit 4060e4c0d257 ("rdma: Add PD resource tracking
information"), the resource information shows PDs and MRs,
but help pages didn't fully reflect it.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/res.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/rdma/res.c b/rdma/res.c
index 0d8c1c38..cbb2efe6 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -16,13 +16,17 @@ static int res_help(struct rd *rd)
 {
 	pr_out("Usage: %s resource\n", rd->filename);
 	pr_out("          resource show [DEV]\n");
-	pr_out("          resource show [qp|cm_id]\n");
+	pr_out("          resource show [qp|cm_id|pd|mr|cq]\n");
 	pr_out("          resource show qp link [DEV/PORT]\n");
 	pr_out("          resource show qp link [DEV/PORT] [FILTER-NAME FILTER-VALUE]\n");
 	pr_out("          resource show cm_id link [DEV/PORT]\n");
 	pr_out("          resource show cm_id link [DEV/PORT] [FILTER-NAME FILTER-VALUE]\n");
 	pr_out("          resource show cq link [DEV/PORT]\n");
 	pr_out("          resource show cq link [DEV/PORT] [FILTER-NAME FILTER-VALUE]\n");
+	pr_out("          resource show pd dev [DEV]\n");
+	pr_out("          resource show pd dev [DEV] [FILTER-NAME FILTER-VALUE]\n");
+	pr_out("          resource show mr dev [DEV]\n");
+	pr_out("          resource show mr dev [DEV] [FILTER-NAME FILTER-VALUE]\n");
 	return 0;
 }
