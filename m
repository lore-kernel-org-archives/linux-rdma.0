From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next 10/10] rdma: Check return value of strdup call
Date: Wed, 31 Jan 2018 10:11:56 +0200
Message-ID: <20180131081156.19607-11-leon@kernel.org>
References: <20180131081156.19607-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180131081156.19607-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: RDMA mailing list <linux-rdma@vger.kernel.org>, Steve Wise <swise@opengridcomputing.com>, Leon Romanovsky <leon@kernel.org>, netdev <netdev@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, Leon Romanovsky <leonro@mellanox.com>
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
2.16.1
