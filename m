From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH 2/4] IB/core: export ib_get_cached_port_state
Date: Mon, 12 Dec 2016 12:45:26 +0100
Message-ID: <CAMGffEnCU-8sodNH_i-KKPAhe3ekkt+Yd34wiUVqvXJ+ujSRwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From 1cf770be635e987e31feed2f7c82b9f4f3bd316a Mon Sep 17 00:00:00 2001
From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Date: Mon, 12 Dec 2016 10:12:39 +0100
Subject: [PATCH 2/4] IB/core: export ib_get_cached_port_state

Export function for rdma_cm, patch will follow.

Signed-off-by: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Reviewed-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/core/cache.c | 18 ++++++++++++++++++
 include/rdma/ib_cache.h         | 13 +++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cach=
e.c
index 025db27..1b064cf 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -1025,6 +1025,24 @@ int ib_get_cached_lmc(struct ib_device *device,
 }
 EXPORT_SYMBOL(ib_get_cached_lmc);

+int ib_get_cached_port_state(struct ib_device   *device,
+                 u8                  port_num,
+                 enum ib_port_state *port_state)
+{
+    unsigned long flags;
+    int ret =3D 0;
+
+    if (port_num < rdma_start_port(device) || port_num > rdma_end_port(dev=
ice))
+        return -EINVAL;
+
+    read_lock_irqsave(&device->cache.lock, flags);
+    *port_state =3D device->cache.port_state_cache[port_num -
rdma_start_port(device)];
+    read_unlock_irqrestore(&device->cache.lock, flags);
+
+    return ret;
+}
+EXPORT_SYMBOL(ib_get_cached_port_state);
+
 static void ib_cache_update(struct ib_device *device,
                 u8                port)
 {
diff --git a/include/rdma/ib_cache.h b/include/rdma/ib_cache.h
index e30f19b..385ec88 100644
--- a/include/rdma/ib_cache.h
+++ b/include/rdma/ib_cache.h
@@ -165,4 +165,17 @@ int ib_get_cached_lmc(struct ib_device *device,
               u8                port_num,
               u8                *lmc);

+/**
+ * ib_get_cached_port_state - Returns a cached port state table entry
+ * @device: The device to query.
+ * @port_num: The port number of the device to query.
+ * @port_state: port_state for the specified port for that device.
+ *
+ * ib_get_cached_port_state() fetches the specified port_state table
entry stored in
+ * the local software cache.
+ */
+int ib_get_cached_port_state(struct ib_device *device,
+                  u8                port_num,
+                  enum ib_port_state *port_active);
+
 #endif /* _IB_CACHE_H */
--=20
2.7.4


--=20
Jinpu Wang
Linux Kernel Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Tel:       +49 30 577 008  042
Fax:      +49 30 577 008 299
Email:    jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL:      https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
