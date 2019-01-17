From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next] rdma: Add unbound workqueue to list of poll context types
Date: Thu, 17 Jan 2019 17:14:43 +0200
Message-ID: <20190117151443.25368-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Kernel commit f794809a7259 ("IB/core: Add an unbound WQ type to the new CQ API")
added new CQ poll context type, reflect this change in rdmatool.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/res.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rdma/res.c b/rdma/res.c
index cbb2efe6..6b0f5fe3 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -703,7 +703,7 @@ static void print_users(struct rd *rd, uint64_t val)
 static const char *poll_ctx_to_str(uint8_t idx)
 {
 	static const char * const cm_id_states_str[] = {
-		"DIRECT", "SOFTIRQ", "WORKQUEUE"};
+		"DIRECT", "SOFTIRQ", "WORKQUEUE", "UNBOUND_WORKQUEUE"};
 
 	if (idx < ARRAY_SIZE(cm_id_states_str))
 		return cm_id_states_str[idx];
-- 
2.19.1
