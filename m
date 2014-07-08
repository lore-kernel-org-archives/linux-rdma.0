From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.17 1/3] IB/ipath: Add PKEY change event support
Date: Tue,  8 Jul 2014 12:45:10 +0300
Message-ID: <1404812712-26187-2-git-send-email-ogerlitz@mellanox.com>
References: <1404812712-26187-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404812712-26187-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Deliver PKEY_CHANGE event through the relevant IB device when
the local pkey table changes.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/ipath/ipath_mad.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_mad.c b/drivers/infiniband/hw/ipath/ipath_mad.c
index 43f2d04..e890e5b 100644
--- a/drivers/infiniband/hw/ipath/ipath_mad.c
+++ b/drivers/infiniband/hw/ipath/ipath_mad.c
@@ -726,7 +726,7 @@ bail:
  * @dd: the infinipath device
  * @pkeys: the PKEY table
  */
-static int set_pkeys(struct ipath_devdata *dd, u16 *pkeys)
+static int set_pkeys(struct ipath_devdata *dd, u16 *pkeys, u8 port)
 {
 	struct ipath_portdata *pd;
 	int i;
@@ -759,6 +759,7 @@ static int set_pkeys(struct ipath_devdata *dd, u16 *pkeys)
 	}
 	if (changed) {
 		u64 pkey;
+		struct ib_event event;
 
 		pkey = (u64) dd->ipath_pkeys[0] |
 			((u64) dd->ipath_pkeys[1] << 16) |
@@ -768,12 +769,17 @@ static int set_pkeys(struct ipath_devdata *dd, u16 *pkeys)
 			   (unsigned long long) pkey);
 		ipath_write_kreg(dd, dd->ipath_kregs->kr_partitionkey,
 				 pkey);
+
+		event.event = IB_EVENT_PKEY_CHANGE;
+		event.device = &dd->verbs_dev->ibdev;
+		event.element.port_num = port;
+		ib_dispatch_event(&event);
 	}
 	return 0;
 }
 
 static int recv_subn_set_pkeytable(struct ib_smp *smp,
-				   struct ib_device *ibdev)
+				   struct ib_device *ibdev, u8 port)
 {
 	u32 startpx = 32 * (be32_to_cpu(smp->attr_mod) & 0xffff);
 	__be16 *p = (__be16 *) smp->data;
@@ -784,7 +790,7 @@ static int recv_subn_set_pkeytable(struct ib_smp *smp,
 	for (i = 0; i < n; i++)
 		q[i] = be16_to_cpu(p[i]);
 
-	if (startpx != 0 || set_pkeys(dev->dd, q) != 0)
+	if (startpx != 0 || set_pkeys(dev->dd, q, port) != 0)
 		smp->status |= IB_SMP_INVALID_FIELD;
 
 	return recv_subn_get_pkeytable(smp, ibdev);
@@ -1342,7 +1348,7 @@ static int process_subn(struct ib_device *ibdev, int mad_flags,
 			ret = recv_subn_set_portinfo(smp, ibdev, port_num);
 			goto bail;
 		case IB_SMP_ATTR_PKEY_TABLE:
-			ret = recv_subn_set_pkeytable(smp, ibdev);
+			ret = recv_subn_set_pkeytable(smp, ibdev, port_num);
 			goto bail;
 		case IB_SMP_ATTR_SM_INFO:
 			if (dev->port_cap_flags & IB_PORT_SM_DISABLED) {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
