From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v5 iproute2 1/8] utils: Move BIT macro to common header
Date: Thu, 17 Aug 2017 09:37:31 +0300
Message-ID: <20170817063738.31554-2-leonro@mellanox.com>
References: <20170817063738.31554-1-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170817063738.31554-1-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

BIT() macro was implemented and used by devlink for now, but following
patches of rdmatool will reuse the same macro, so put it in common
header file.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 devlink/devlink.c | 2 +-
 include/utils.h   | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index f9bc16c3..7602970b 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -25,6 +25,7 @@
 #include "list.h"
 #include "mnlg.h"
 #include "json_writer.h"
+#include "utils.h"
 
 #define ESWITCH_MODE_LEGACY "legacy"
 #define ESWITCH_MODE_SWITCHDEV "switchdev"
@@ -160,7 +161,6 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 	free(ifname_map);
 }
 
-#define BIT(nr)                 (1UL << (nr))
 #define DL_OPT_HANDLE		BIT(0)
 #define DL_OPT_HANDLEP		BIT(1)
 #define DL_OPT_PORT_TYPE	BIT(2)
diff --git a/include/utils.h b/include/utils.h
index 6080b962..7a3b3fd2 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -195,6 +195,8 @@ static inline void __jiffies_to_tv(struct timeval *tv, unsigned long jiffies)
 int print_timestamp(FILE *fp);
 void print_nlmsg_timestamp(FILE *fp, const struct nlmsghdr *n);
 
+#define BIT(nr)                 (1UL << (nr))
+
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 
 #define BUILD_BUG_ON(cond) ((void)sizeof(char[1 - 2 * !!(cond)]))
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
