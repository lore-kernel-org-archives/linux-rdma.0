From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 10/10] IB/hfi1: Send a pkey change event on driver pkey
 update
Date: Thu, 09 Jun 2016 07:52:03 -0700
Message-ID: <20160609145202.12702.68363.stgit@scvm10.sc.intel.com>
References: <20160609144644.12702.4832.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160609144644.12702.4832.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Swapping a cable from a "Mgmt Allowed=No" switch port to a
"Mgmt Allowed=Yes" switch port doesn't send a pkey change
notification. Therefore, the link doesn't become active as
the oib_utils layer uses an old pkey table cache.

Fix by ensuring the pkey change notification is sent when
the table is changed both explicitly by the FM and implicitly
by the driver via a cable swap.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |    2 ++
 drivers/infiniband/hw/hfi1/mad.c  |   19 ++++++++++++-------
 drivers/infiniband/hw/hfi1/mad.h  |    2 ++
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 3487fdf..f5de851 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -7068,6 +7068,7 @@ static void add_full_mgmt_pkey(struct hfi1_pportdata *ppd)
 			    __func__, ppd->pkeys[2], FULL_MGMT_P_KEY);
 	ppd->pkeys[2] = FULL_MGMT_P_KEY;
 	(void)hfi1_set_ib_cfg(ppd, HFI1_IB_CFG_PKEYS, 0);
+	hfi1_event_pkey_change(ppd->dd, ppd->port);
 }
 
 static void clear_full_mgmt_pkey(struct hfi1_pportdata *ppd)
@@ -7075,6 +7076,7 @@ static void clear_full_mgmt_pkey(struct hfi1_pportdata *ppd)
 	if (ppd->pkeys[2] != 0) {
 		ppd->pkeys[2] = 0;
 		(void)hfi1_set_ib_cfg(ppd, HFI1_IB_CFG_PKEYS, 0);
+		hfi1_event_pkey_change(ppd->dd, ppd->port);
 	}
 }
 
diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index 2190295..fca07a1 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -78,6 +78,16 @@ static inline void clear_opa_smp_data(struct opa_smp *smp)
 	memset(data, 0, size);
 }
 
+void hfi1_event_pkey_change(struct hfi1_devdata *dd, u8 port)
+{
+	struct ib_event event;
+
+	event.event = IB_EVENT_PKEY_CHANGE;
+	event.device = &dd->verbs_dev.rdi.ibdev;
+	event.element.port_num = port;
+	ib_dispatch_event(&event);
+}
+
 static void send_trap(struct hfi1_ibport *ibp, void *data, unsigned len)
 {
 	struct ib_mad_send_buf *send_buf;
@@ -1418,15 +1428,10 @@ static int set_pkeys(struct hfi1_devdata *dd, u8 port, u16 *pkeys)
 	}
 
 	if (changed) {
-		struct ib_event event;
-
 		(void)hfi1_set_ib_cfg(ppd, HFI1_IB_CFG_PKEYS, 0);
-
-		event.event = IB_EVENT_PKEY_CHANGE;
-		event.device = &dd->verbs_dev.rdi.ibdev;
-		event.element.port_num = port;
-		ib_dispatch_event(&event);
+		hfi1_event_pkey_change(dd, port);
 	}
+
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/hfi1/mad.h b/drivers/infiniband/hw/hfi1/mad.h
index 55ee086..8b734aa 100644
--- a/drivers/infiniband/hw/hfi1/mad.h
+++ b/drivers/infiniband/hw/hfi1/mad.h
@@ -434,4 +434,6 @@ struct sc2vlnt {
 		    COUNTER_MASK(1, 3) | \
 		    COUNTER_MASK(1, 4))
 
+void hfi1_event_pkey_change(struct hfi1_devdata *dd, u8 port);
+
 #endif				/* _HFI1_MAD_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
