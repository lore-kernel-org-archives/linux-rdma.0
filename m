From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1] IB/core: Do not allocate more memory than required for cma_configfs
Date: Thu, 31 Dec 2015 10:49:03 +0200
Message-ID: <1451551743-26042-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We were allocating larger memory space than required for
cma_dev_group->default_ports_group.

Fixes: 045959db65c6 ('IB/cma: Add configfs for rdma_cm')
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Hi Doug,

This patch fixes a small issue, where we allocated more space than we
actually needed. This was introduces in the RoCE v2 series.

Regards,
Matan

Changes from V0:
 - Change subject and fix spelling mistake in commit message

 drivers/infiniband/core/cma_configfs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/cma_configfs.c b/drivers/infiniband/core/cma_configfs.c
index bd1d640..ab554df 100644
--- a/drivers/infiniband/core/cma_configfs.c
+++ b/drivers/infiniband/core/cma_configfs.c
@@ -169,9 +169,10 @@ static int make_cma_ports(struct cma_dev_group *cma_dev_group,
 	ports = kcalloc(ports_num, sizeof(*cma_dev_group->ports),
 			GFP_KERNEL);
 
-	cma_dev_group->default_ports_group = kcalloc(ports_num + 1,
-						     sizeof(*cma_dev_group->ports),
-						     GFP_KERNEL);
+	cma_dev_group->default_ports_group =
+		kcalloc(ports_num + 1,
+			sizeof(*cma_dev_group->default_ports_group),
+			GFP_KERNEL);
 
 	if (!ports || !cma_dev_group->default_ports_group) {
 		err = -ENOMEM;
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
