From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH] libibumad/sa: Add SA specific status values
Date: Thu, 21 Feb 2013 10:41:34 -0800
Message-ID: <1361472094-12503-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/infiniband/umad_sa.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/infiniband/umad_sa.h b/include/infiniband/umad_sa.h
index f3e161e..a83b9f9 100644
--- a/include/infiniband/umad_sa.h
+++ b/include/infiniband/umad_sa.h
@@ -60,6 +60,17 @@ enum {
 	UMAD_SA_METHOD_GET_TRACE_TABLE	= 0x13
 };
 
+enum {
+	UMAD_SA_STATUS_SUCCESS		= 0,
+	UMAD_SA_STATUS_NO_RESOURCES	= 1,
+	UMAD_SA_STATUS_REQ_INVALID	= 2,
+	UMAD_SA_STATUS_NO_RECORDS	= 3,
+	UMAD_SA_STATUS_TOO_MANY_RECORDS	= 4,
+	UMAD_SA_STATUS_INVALID_GID	= 5,
+	UMAD_SA_STATUS_INSUF_COMPS	= 6,
+	UMAD_SA_STATUS_REQ_DENIED	= 7
+};
+
 /* SA attributes */
 enum {
 	UMAD_SA_ATTR_NODE_REC		= 0x0011,
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
