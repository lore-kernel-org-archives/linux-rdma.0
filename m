From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 02/22] IB/srpt: Remove struct srpt_node_acl
Date: Fri, 29 Jan 2016 15:11:43 -0800
Message-ID: <56ABF1AF.3070301@sandisk.com>
References: <56ABF16E.7070006@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56ABF16E.7070006-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Since struct srpt_node_acl is identical to struct se_node_acl,
remove the definition of the former structure. This patch does
not change any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.h | 8 --------
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index f65ae60..fde32ed 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3565,7 +3565,7 @@ static struct configfs_attribute *srpt_wwn_attrs[] = {
 static const struct target_core_fabric_ops srpt_template = {
 	.module				= THIS_MODULE,
 	.name				= "srpt",
-	.node_acl_size			= sizeof(struct srpt_node_acl),
+	.node_acl_size			= sizeof(struct se_node_acl),
 	.get_fabric_name		= srpt_get_fabric_name,
 	.tpg_get_wwn			= srpt_get_fabric_wwn,
 	.tpg_get_tag			= srpt_get_tag,
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 09037f2..b0ede97 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -363,12 +363,4 @@ struct srpt_device {
 	struct list_head	list;
 };
 
-/**
- * struct srpt_node_acl - Per-initiator ACL data (managed via configfs).
- * @nacl:      Target core node ACL information.
- */
-struct srpt_node_acl {
-	struct se_node_acl	nacl;
-};
-
 #endif				/* IB_SRPT_H */
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
