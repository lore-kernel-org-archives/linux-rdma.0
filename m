From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next v2 02/10] rdma: Make visible the number of arguments
Date: Wed, 17 Jan 2018 12:02:24 +0200
Message-ID: <20180117100232.3155-3-leon@kernel.org>
References: <20180117100232.3155-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180117100232.3155-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: netdev <netdev@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Steve Wise <swise@opengridcomputing.com>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/rdma.h  | 1 +
 rdma/utils.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/rdma/rdma.h b/rdma/rdma.h
index cbd9aa89..1b66ae04 100644
--- a/rdma/rdma.h
+++ b/rdma/rdma.h
@@ -74,6 +74,7 @@ int rd_exec_cmd(struct rd *rd, const struct rd_cmd *c, const char *str);
 int rd_exec_dev(struct rd *rd, int (*cb)(struct rd *rd));
 int rd_exec_link(struct rd *rd, int (*cb)(struct rd *rd), bool strict_port);
 void rd_free(struct rd *rd);
+int rd_argc(struct rd *rd);
 
 /*
  * Device manipulation
diff --git a/rdma/utils.c b/rdma/utils.c
index b9c668a3..af2b374d 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -12,7 +12,7 @@
 #include "rdma.h"
 #include <ctype.h>
 
-static int rd_argc(struct rd *rd)
+int rd_argc(struct rd *rd)
 {
 	return rd->argc;
 }
-- 
2.15.1
