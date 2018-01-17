From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next v2 10/10] rdma: Check return value of strdup call
Date: Wed, 17 Jan 2018 12:02:32 +0200
Message-ID: <20180117100232.3155-11-leon@kernel.org>
References: <20180117100232.3155-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180117100232.3155-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: netdev <netdev@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Steve Wise <swise@opengridcomputing.com>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Fixes: 74bd75c2b68d ("rdma: Add basic infrastructure for RDMA tool")
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/utils.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/rdma/utils.c b/rdma/utils.c
index 059aa788..f9460162 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -98,6 +98,10 @@ static struct dev_map *dev_map_alloc(const char *dev_name)
 	if (!dev_map)
 		return NULL;
 	dev_map->dev_name = strdup(dev_name);
+	if (!dev_map->dev_name) {
+		free(dev_map);
+		return NULL;
+	}
 
 	return dev_map;
 }
-- 
2.15.1
