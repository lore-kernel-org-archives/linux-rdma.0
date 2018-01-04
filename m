From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next v1 2/9] rdma: Make visible the number of arguments
Date: Thu,  4 Jan 2018 09:01:43 +0200
Message-ID: <20180104070150.15625-3-leon@kernel.org>
References: <20180104070150.15625-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180104070150.15625-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, David Ahern <dsahern@gmail.com>
Cc: RDMA mailing list <linux-rdma@vger.kernel.org>, Leon Romanovsky <leon@kernel.org>, netdev <netdev@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, Leon Romanovsky <leonro@mellanox.com>
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
