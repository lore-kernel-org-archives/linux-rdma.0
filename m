From: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/core: Fix error return code in add_port()
Date: Fri, 21 Jun 2013 10:26:10 +0800
Message-ID: <CAPgLHd_iWVTbbJN2XrJMU31wPiKCdZMZwVC0Su=afxKSPo4QvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>

Fix to return -ENOMEM in the alloc_group_attrs() error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
---
 drivers/infiniband/core/sysfs.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 246fdc1..d9b78c4 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -545,8 +545,10 @@ static int add_port(struct ib_device *device, int port_num,
 
 	p->gid_group.name  = "gids";
 	p->gid_group.attrs = alloc_group_attrs(show_port_gid, attr.gid_tbl_len);
-	if (!p->gid_group.attrs)
+	if (!p->gid_group.attrs) {
+		ret = -ENOMEM;
 		goto err_remove_pma;
+	}
 
 	ret = sysfs_create_group(&p->kobj, &p->gid_group);
 	if (ret)
@@ -555,8 +557,10 @@ static int add_port(struct ib_device *device, int port_num,
 	p->pkey_group.name  = "pkeys";
 	p->pkey_group.attrs = alloc_group_attrs(show_port_pkey,
 						attr.pkey_tbl_len);
-	if (!p->pkey_group.attrs)
+	if (!p->pkey_group.attrs) {
+		ret = -ENOMEM;
 		goto err_remove_gid;
+	}
 
 	ret = sysfs_create_group(&p->kobj, &p->pkey_group);
 	if (ret)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
