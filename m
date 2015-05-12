From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/5] IB/user_mad: Fix bug in ib_umad_remove_one when rdma_cap_ib_mad implementation changed
Date: Mon, 11 May 2015 21:46:54 -0400
Message-ID: <1431395218-27693-2-git-send-email-ira.weiny@intel.com>
References: <1431395218-27693-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431395218-27693-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The addition of the rdma_cap_ib_mad is technically broken in ib_umad_remove_one
because the loop "i" value is not a port value.

This bug resulted in the ib_umad failing to properly remove its resources when
the core capability functions were converted to bit fields.

NOTE: This original patch did not result in broken behavior on its own.  It was
only an issue when the implementation of rdma_cap_ib_mad was changed.

Change "i" to correspond to the port and alter the index to the private port
array.

Fixes: e17371d73908 ("IB/Verbs: Use management helper rdma_cap_ib_mad()")

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/user_mad.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 2ff66bc..36ce192 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -1327,14 +1327,21 @@ free:
 static void ib_umad_remove_one(struct ib_device *device)
 {
 	struct ib_umad_device *umad_dev = ib_get_client_data(device, &umad_client);
-	int i;
+	int s, e, i;
 
 	if (!umad_dev)
 		return;
 
-	for (i = 0; i <= umad_dev->end_port - umad_dev->start_port; ++i) {
+	if (device->node_type == RDMA_NODE_IB_SWITCH)
+		s = e = 0;
+	else {
+		s = 1;
+		e = device->phys_port_cnt;
+	}
+
+	for (i = s; i <= e; ++i) {
 		if (rdma_cap_ib_mad(device, i))
-			ib_umad_kill_port(&umad_dev->port[i]);
+			ib_umad_kill_port(&umad_dev->port[i - s]);
 	}
 
 	kobject_put(&umad_dev->kobj);
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
