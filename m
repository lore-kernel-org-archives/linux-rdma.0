From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 2/3] IB/core: fix port kobject deletion during error flow
Date: Sun, 18 May 2014 11:12:25 +0300
Message-ID: <1400400746-9030-3-git-send-email-haggaie@mellanox.com>
References: <1400400746-9030-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1400400746-9030-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When encountering an error during the add_port function, adding a port to
sysfs, the port kobject is freed without being deleted from sysfs.

Instead of freeing it directly, the patch uses kobject_put to release the
kobject and delete it.

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/sysfs.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 1f77072..68fa798 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -429,15 +429,19 @@ static void ib_port_release(struct kobject *kobj)
 	struct attribute *a;
 	int i;
 
-	for (i = 0; (a = p->gid_group.attrs[i]); ++i)
-		kfree(a);
+	if (p->gid_group.attrs) {
+		for (i = 0; (a = p->gid_group.attrs[i]); ++i)
+			kfree(a);
 
-	kfree(p->gid_group.attrs);
+		kfree(p->gid_group.attrs);
+	}
 
-	for (i = 0; (a = p->pkey_group.attrs[i]); ++i)
-		kfree(a);
+	if (p->pkey_group.attrs) {
+		for (i = 0; (a = p->pkey_group.attrs[i]); ++i)
+			kfree(a);
 
-	kfree(p->pkey_group.attrs);
+		kfree(p->pkey_group.attrs);
+	}
 
 	kfree(p);
 }
@@ -536,8 +540,10 @@ static int add_port(struct ib_device *device, int port_num,
 	ret = kobject_init_and_add(&p->kobj, &port_type,
 				   device->ports_parent,
 				   "%d", port_num);
-	if (ret)
-		goto err_put;
+	if (ret) {
+		kfree(p);
+		return ret;
+	}
 
 	ret = sysfs_create_group(&p->kobj, &pma_group);
 	if (ret)
@@ -585,6 +591,7 @@ err_free_pkey:
 		kfree(p->pkey_group.attrs[i]);
 
 	kfree(p->pkey_group.attrs);
+	p->pkey_group.attrs = NULL;
 
 err_remove_gid:
 	sysfs_remove_group(&p->kobj, &p->gid_group);
@@ -594,12 +601,13 @@ err_free_gid:
 		kfree(p->gid_group.attrs[i]);
 
 	kfree(p->gid_group.attrs);
+	p->gid_group.attrs = NULL;
 
 err_remove_pma:
 	sysfs_remove_group(&p->kobj, &pma_group);
 
 err_put:
-	kfree(p);
+	kobject_put(&p->kobj);
 	return ret;
 }
 
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
