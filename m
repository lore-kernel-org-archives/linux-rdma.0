From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/core: memset attr variable to prevent garbage data
Date: Fri, 26 Sep 2014 15:49:40 +0530
Message-ID: <45be0302-ea5d-4f35-892a-47617edd27ec@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

During create-ah from user land, uverbs is sending
garbage data in attr.dmac and attr.vlan_id. This
patch prevents the same.

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 0600c50..0b1ce71 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2508,6 +2508,7 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 		goto err;
 	}
 
+	memset(&attr, 0, sizeof(attr));
 	attr.dlid 	       = cmd.attr.dlid;
 	attr.sl 	       = cmd.attr.sl;
 	attr.src_path_bits     = cmd.attr.src_path_bits;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
