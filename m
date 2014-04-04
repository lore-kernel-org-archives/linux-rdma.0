From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 12/14] ibacm: fix handling of aliased IPoIB devices
Date: Thu,  3 Apr 2014 20:51:52 -0400
Message-ID: <1396572714-16498-13-git-send-email-ira.weiny@intel.com>
References: <1396572714-16498-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1396572714-16498-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

ibX:Y devices don't have sysfs files directly.  They use the "base" interface
of ibX.  The ioctl calls however include the full aliased name.

Netlink does not have this problem as the interface name is reported as it
appears in sysfs.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm_util.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/src/acm_util.c b/src/acm_util.c
index c3c5b69..da6d058 100644
--- a/src/acm_util.c
+++ b/src/acm_util.c
@@ -134,6 +134,7 @@ int acm_if_iter_sys(acm_if_iter_cb cb, void *ctx)
 	uint8_t addr_type;
 	uint8_t addr[ACM_MAX_ADDRESS];
 	size_t addr_len;
+	char *alias_sep;
 
 	s = socket(AF_INET6, SOCK_DGRAM, 0);
 	if (!s)
@@ -177,6 +178,12 @@ int acm_if_iter_sys(acm_if_iter_cb cb, void *ctx)
 			continue;
 		}
 
+		acm_log(2, "%s\n", ifr[i].ifr_name);
+
+		alias_sep = strchr(ifr[i].ifr_name, ':');
+		if (alias_sep)
+			*alias_sep = '\0';
+
 		if (!acm_if_is_ib(ifr[i].ifr_name))
 			continue;
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
