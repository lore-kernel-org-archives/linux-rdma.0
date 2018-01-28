From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 3/5] IB/core: Avoid SGID attributes query while converting GID from OPA to IB
Date: Sun, 28 Jan 2018 11:25:31 +0200
Message-ID: <20180128092533.4156-4-leon@kernel.org>
References: <20180128092533.4156-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180128092533.4156-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

SGID attributes are not used during OPA to IB GID conversion.
Therefore don't query it.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index b8f8d3128a53..68df93558d80 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1577,15 +1577,13 @@ static void cm_opa_to_ib_sgid(struct cm_work *work,
 			      struct sa_path_rec *path)
 {
 	struct ib_device *dev = work->port->cm_dev->ib_device;
-	struct ib_gid_attr gid_attr;
 	u8 port_num = work->port->port_num;
 
 	if (rdma_cap_opa_ah(dev, port_num) &&
 	    (ib_is_opa_gid(&path->sgid))) {
 		union ib_gid sgid;
 
-		if (ib_get_cached_gid(dev, port_num, 0,
-				      &sgid, &gid_attr)) {
+		if (ib_get_cached_gid(dev, port_num, 0, &sgid, NULL)) {
 			dev_warn(&dev->dev,
 				 "Error updating sgid in CM request\n");
 			return;
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
