From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V1] IB/core: memset attr variable to prevent garbage data
Date: Fri, 26 Sep 2014 19:30:40 +0530
Message-ID: <1303ef19-9e66-4ad0-9788-995faadb05ab@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

During create-ah from user land, uverbs is sending
garbage data in attr.dmac and attr.vlan_id. This
patch prevents the same.

Fixes: dd5f03beb4f7 ('IB/core: Ethernet L2 attributes in verbs/cm
structures')

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 0600c50..5ba2a86 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2518,6 +2518,8 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	attr.grh.sgid_index    = cmd.attr.grh.sgid_index;
 	attr.grh.hop_limit     = cmd.attr.grh.hop_limit;
 	attr.grh.traffic_class = cmd.attr.grh.traffic_class;
+	attr.vlan_id           = 0;
+	memset(&attr.dmac, 0, sizeof(attr.dmac));
 	memcpy(attr.grh.dgid.raw, cmd.attr.grh.dgid, 16);
 
 	ah = ib_create_ah(pd, &attr);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
