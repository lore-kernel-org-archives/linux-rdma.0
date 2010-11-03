From: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 3/3] Add RAW_PACKET to ib_attach/detach mcast calls
Date: Wed, 03 Nov 2010 16:37:59 +0200
Message-ID: <4CD173C7.4050707@voltaire.com>
References: <4CD171F0.8020506@voltaire.com> <4CD172C8.4010700@voltaire.com> <4CD17345.7040400@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CD17345.7040400-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>, Alex Rosenbaum <Alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Added RAW_PACKET to ib_attach/detach calls

Add iWARP transport to attach/detach mcast.
Differentiate between transport types when dealing with multicast.


Signed-off-by: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index b04b419..a053c0e 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -903,9 +903,17 @@ int ib_attach_mcast(struct ib_qp *qp, union ib_gid *gid, u16 lid)
 {
 	if (!qp->device->attach_mcast)
 		return -ENOSYS;
-	if (gid->raw[0] != 0xff || qp->qp_type != IB_QPT_UD)
-		return -EINVAL;
 
+	switch (rdma_node_get_transport(qp->device->node_type)) {
+	case RDMA_TRANSPORT_IB:
+		if (gid->raw[0] != 0xff || qp->qp_type != IB_QPT_UD)
+			return -EINVAL;
+		break;
+	case RDMA_TRANSPORT_IWARP:
+		if (qp->qp_type != IB_QPT_RAW_PACKET)
+			return -EINVAL;
+		break;
+	}
 	return qp->device->attach_mcast(qp, gid, lid);
 }
 EXPORT_SYMBOL(ib_attach_mcast);
@@ -914,9 +922,17 @@ int ib_detach_mcast(struct ib_qp *qp, union ib_gid *gid, u16 lid)
 {
 	if (!qp->device->detach_mcast)
 		return -ENOSYS;
-	if (gid->raw[0] != 0xff || qp->qp_type != IB_QPT_UD)
-		return -EINVAL;
 
+	switch (rdma_node_get_transport(qp->device->node_type)) {
+	case RDMA_TRANSPORT_IB:
+		if (gid->raw[0] != 0xff || qp->qp_type != IB_QPT_UD)
+			return -EINVAL;
+		break;
+	case RDMA_TRANSPORT_IWARP:
+		if (qp->qp_type != IB_QPT_RAW_PACKET)
+			return -EINVAL;
+		break;
+	}
 	return qp->device->detach_mcast(qp, gid, lid);
 }
 EXPORT_SYMBOL(ib_detach_mcast);
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
