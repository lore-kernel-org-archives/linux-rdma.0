From: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v3 3/4] Add RAW_PACKET to verbs attach/detach multicast
Date: Mon, 6 Dec 2010 09:37:19 +0200
Message-ID: <4CFC92AF.8070009@voltaire.com>
References: <4CFC918D.1090708@voltaire.com> <4CFC921D.3000907@voltaire.com> <4CFC926B.8060305@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CFC926B.8060305-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>, Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sanity check - validate that the subnet_prefix bits set to zero'es.

Signed-off-by: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 611c13c..9e4998c 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -904,7 +904,10 @@ int ib_attach_mcast(struct ib_qp *qp, union ib_gid *gid, u16 lid)
 {
 	if (!qp->device->attach_mcast)
 		return -ENOSYS;
-	if (gid->raw[0] != 0xff || qp->qp_type != IB_QPT_UD)
+	if (qp->qp_type == IB_QPT_RAW_PACKET) {
+		if (gid->global.subnet_prefix & cpu_to_be64(~1ULL))
+			return -EINVAL;
+	} else if (gid->raw[0] != 0xff || qp->qp_type != IB_QPT_UD)
 		return -EINVAL;
 
 	return qp->device->attach_mcast(qp, gid, lid);
@@ -915,7 +918,10 @@ int ib_detach_mcast(struct ib_qp *qp, union ib_gid *gid, u16 lid)
 {
 	if (!qp->device->detach_mcast)
 		return -ENOSYS;
-	if (gid->raw[0] != 0xff || qp->qp_type != IB_QPT_UD)
+	if (qp->qp_type == IB_QPT_RAW_PACKET) {
+		if (gid->global.subnet_prefix & cpu_to_be64(~1ULL))
+			return -EINVAL;
+	} else if (gid->raw[0] != 0xff || qp->qp_type != IB_QPT_UD)
 		return -EINVAL;
 
 	return qp->device->detach_mcast(qp, gid, lid);
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
