From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 rdma-next 03/18] IB/core: Add braces when using sizeof
Date: Sat, 29 Apr 2017 14:41:15 -0400
Message-ID: <1493491290-31621-4-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1493491290-31621-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493491290-31621-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch adds braces around parameters to sizeof
as called out by checkpatch

Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_marshall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_marshall.c b/drivers/infiniband/core/uverbs_marshall.c
index af020f8..ed3e68f 100644
--- a/drivers/infiniband/core/uverbs_marshall.c
+++ b/drivers/infiniband/core/uverbs_marshall.c
@@ -36,7 +36,7 @@
 void ib_copy_ah_attr_to_user(struct ib_uverbs_ah_attr *dst,
 			     struct ib_ah_attr *src)
 {
-	memcpy(dst->grh.dgid, src->grh.dgid.raw, sizeof src->grh.dgid);
+	memcpy(dst->grh.dgid, src->grh.dgid.raw, sizeof(src->grh.dgid));
 	dst->grh.flow_label        = src->grh.flow_label;
 	dst->grh.sgid_index        = src->grh.sgid_index;
 	dst->grh.hop_limit         = src->grh.hop_limit;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
