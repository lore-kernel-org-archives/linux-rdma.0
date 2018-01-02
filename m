From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH iproute2-next 2/9] rdma: Make visible the number of arguments
Date: Tue,  2 Jan 2018 11:37:18 +0200
Message-ID: <20180102093725.6172-3-leon@kernel.org>
References: <20180102093725.6172-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180102093725.6172-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
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
index 7c920a5c..9184f455 100644
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

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
