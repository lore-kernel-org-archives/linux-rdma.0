From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 2/5] IB/user_mad: Remove local start/end port variable and use the new common functions
Date: Wed, 13 May 2015 20:02:56 -0400
Message-ID: <1431561779-13714-3-git-send-email-ira.weiny@intel.com>
References: <1431561779-13714-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431561779-13714-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The start_port and end_port was duplicated data.

Use the new common rdma_[start|end]_port functions instead and remove the
unnecessary duplicated data.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/user_mad.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 2ff66bc131e9..08f264711136 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -99,7 +99,6 @@ struct ib_umad_port {
 };
 
 struct ib_umad_device {
-	int                  start_port, end_port;
 	struct kobject       kobj;
 	struct ib_umad_port  port[0];
 };
@@ -1275,12 +1274,8 @@ static void ib_umad_add_one(struct ib_device *device)
 	int s, e, i;
 	int count = 0;
 
-	if (device->node_type == RDMA_NODE_IB_SWITCH)
-		s = e = 0;
-	else {
-		s = 1;
-		e = device->phys_port_cnt;
-	}
+	s = rdma_start_port(device);
+	e = rdma_end_port(device);
 
 	umad_dev = kzalloc(sizeof *umad_dev +
 			   (e - s + 1) * sizeof (struct ib_umad_port),
@@ -1290,9 +1285,6 @@ static void ib_umad_add_one(struct ib_device *device)
 
 	kobject_init(&umad_dev->kobj, &ib_umad_dev_ktype);
 
-	umad_dev->start_port = s;
-	umad_dev->end_port   = e;
-
 	for (i = s; i <= e; ++i) {
 		if (!rdma_cap_ib_mad(device, i))
 			continue;
@@ -1332,7 +1324,7 @@ static void ib_umad_remove_one(struct ib_device *device)
 	if (!umad_dev)
 		return;
 
-	for (i = 0; i <= umad_dev->end_port - umad_dev->start_port; ++i) {
+	for (i = 0; i <= rdma_end_port(device) - rdma_start_port(device); ++i) {
 		if (rdma_cap_ib_mad(device, i))
 			ib_umad_kill_port(&umad_dev->port[i]);
 	}
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
