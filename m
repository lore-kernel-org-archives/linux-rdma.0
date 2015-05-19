From: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v2 1/4] IB/netlink: Add defines for MAD requests through netlink
Date: Tue, 19 May 2015 14:12:03 -0400
Message-ID: <1432059126-4137-2-git-send-email-kaike.wan@intel.com>
References: <1432059126-4137-1-git-send-email-kaike.wan@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432059126-4137-1-git-send-email-kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch adds netlink defines for MAD client, MAD group, and MAD
operation.

Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/uapi/rdma/rdma_netlink.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index 6e4bb42..c747453 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -7,12 +7,14 @@ enum {
 	RDMA_NL_RDMA_CM = 1,
 	RDMA_NL_NES,
 	RDMA_NL_C4IW,
+	RDMA_NL_MAD,
 	RDMA_NL_NUM_CLIENTS
 };
 
 enum {
 	RDMA_NL_GROUP_CM = 1,
 	RDMA_NL_GROUP_IWPM,
+	RDMA_NL_GROUP_MAD,
 	RDMA_NL_NUM_GROUPS
 };
 
@@ -44,6 +46,11 @@ enum {
 	RDMA_NL_IWPM_NUM_OPS
 };
 
+enum {
+	RDMA_NL_MAD_REQUEST = 0,
+	RDMA_NL_MAD_NUM_OPS
+};
+
 struct rdma_cm_id_stats {
 	__u32	qp_num;
 	__u32	bound_dev_if;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
