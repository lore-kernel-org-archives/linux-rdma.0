From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 3/5] IB/rxe: Use DEVICE_ATTR_RO macro to show parent field
Date: Thu, 15 Jun 2017 11:29:05 +0300
Message-ID: <20170615082907.5658-4-leon@kernel.org>
References: <20170615082907.5658-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170615082907.5658-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kamal Heib <kamalheib1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kamal Heib <kamalheib1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Use DEVICE_ATTR RO() macro and rename the show function accordingly.

Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_verbs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 83d709e74dfb..92156025db73 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -1212,8 +1212,8 @@ static int rxe_detach_mcast(struct ib_qp *ibqp, union ib_gid *mgid, u16 mlid)
 	return rxe_mcast_drop_grp_elem(rxe, qp, mgid);
 }
 
-static ssize_t rxe_show_parent(struct device *device,
-			       struct device_attribute *attr, char *buf)
+static ssize_t parent_show(struct device *device,
+			   struct device_attribute *attr, char *buf)
 {
 	struct rxe_dev *rxe = container_of(device, struct rxe_dev,
 					   ib_dev.dev);
@@ -1221,7 +1221,7 @@ static ssize_t rxe_show_parent(struct device *device,
 	return snprintf(buf, 16, "%s\n", rxe_parent_name(rxe, 1));
 }
 
-static DEVICE_ATTR(parent, S_IRUGO, rxe_show_parent, NULL);
+static DEVICE_ATTR_RO(parent);
 
 static struct device_attribute *rxe_dev_attributes[] = {
 	&dev_attr_parent,
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
