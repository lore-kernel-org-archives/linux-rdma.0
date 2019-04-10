From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next 5/8] rdma: Make get_port_from_argv() returns valid port in strict port mode
Date: Wed, 10 Apr 2019 14:21:18 +0300
Message-ID: <20190410112121.6790-6-leon@kernel.org>
References: <20190410112121.6790-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190410112121.6790-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, Mark Zhang <markz@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

When strict_port is set, make get_port_from_argv() returns failure if
no valid port is specified.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/utils.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/rdma/utils.c b/rdma/utils.c
index 1fda2879..8dc06fc6 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -56,7 +56,7 @@ bool rd_no_arg(struct rd *rd)
  * mlx5_1/1    | 1          | false
  * mlx5_1/-    | 0          | false
  *
- * In strict mode, /- will return error.
+ * In strict port mode, a non-0 port must be provided
  */
 static int get_port_from_argv(struct rd *rd, uint32_t *port,
 			      bool *is_dump_all, bool strict_port)
@@ -64,7 +64,7 @@ static int get_port_from_argv(struct rd *rd, uint32_t *port,
 	char *slash;
 
 	*port = 0;
-	*is_dump_all = true;
+	*is_dump_all = strict_port ? false : true;
 
 	slash = strchr(rd_argv(rd), '/');
 	/* if no port found, return 0 */
@@ -83,6 +83,9 @@ static int get_port_from_argv(struct rd *rd, uint32_t *port,
 		if (!*port && strlen(slash))
 			return -EINVAL;
 	}
+	if (strict_port && (*port == 0))
+		return -EINVAL;
+
 	return 0;
 }
 
-- 
2.20.1
