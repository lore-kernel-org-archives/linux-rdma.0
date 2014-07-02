From: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/1] ibacm: define prov_lib_path as a char array
Date: Wed,  2 Jul 2014 14:30:50 -0400
Message-ID: <1404325850-918-1-git-send-email-kaike.wan@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch fixes a segfault error when the option file defines the provider
lib path. The variable prov_lib_path should be a buffer (char array) instead
of a char pointer. This allows a string to be copied into it during option
parsing.

Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 8f147ef..fae9d0b 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -193,7 +193,7 @@ static int log_level = 0;
 static char lock_file[128] = "/var/run/ibacm.pid";
 static short server_port = 6125;
 static int support_ips_in_addr_cfg = 0;
-static char *prov_lib_path = IBACM_LIB_PATH;
+static char prov_lib_path[256] = IBACM_LIB_PATH;
 
 void acm_write(int level, const char *format, ...)
 {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
