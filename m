From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCHv2 1/1] IB/core: create struct ib_port_cache
Date: Thu, 5 Jan 2017 17:41:44 +0100
Message-ID: <CAMGffEn-fOOe7s2rniqwcaocoV+jxkeJDHZ6WYJkkXi+CBQbEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a113d2dcedb4ce105455b9436
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--001a113d2dcedb4ce105455b9436
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Folks,

This is a follow up for http://www.spinics.net/lists/linux-rdma/msg44536.ht=
ml.
As Jason suggested, I'm moving 4 elments for per port arrays into a seperat=
e
ib_port_cache structure. also change the alloc/free part.

Please apply after the first 4 patches.

Comments and review are welcome!

Thanks,



>From cd8828de6cae70e4ad8b019f19112ce69db83c86 Mon Sep 17 00:00:00 2001
From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Date: Wed, 4 Jan 2017 14:09:05 +0100
Subject: [PATCH] IB/core: create struct ib_port_cache

As Jason suggested, we have 4 elements for per port arrays,
it's better to have a separate structure to represent them.

It simplifies code a bit, 30+ lines of code less :)

Signed-off-by: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Reviewed-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/core/cache.c | 134 +++++++++++++++---------------------=
----
 include/rdma/ib_verbs.h         |  12 ++--
 2 files changed, 59 insertions(+), 87 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cach=
e.c
index f91886b..2e52021 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -314,14 +314,13 @@ static void make_default_gid(struct  net_device
*dev, union ib_gid *gid)
 int ib_cache_gid_add(struct ib_device *ib_dev, u8 port,
              union ib_gid *gid, struct ib_gid_attr *attr)
 {
-    struct ib_gid_table **ports_table =3D ib_dev->cache.gid_cache;
     struct ib_gid_table *table;
     int ix;
     int ret =3D 0;
     struct net_device *idev;
     int empty;

-    table =3D ports_table[port - rdma_start_port(ib_dev)];
+    table =3D ib_dev->cache.ports[port - rdma_start_port(ib_dev)].gid;

     if (!memcmp(gid, &zgid, sizeof(*gid)))
         return -EINVAL;
@@ -369,11 +368,10 @@ int ib_cache_gid_add(struct ib_device *ib_dev, u8 por=
t,
 int ib_cache_gid_del(struct ib_device *ib_dev, u8 port,
              union ib_gid *gid, struct ib_gid_attr *attr)
 {
-    struct ib_gid_table **ports_table =3D ib_dev->cache.gid_cache;
     struct ib_gid_table *table;
     int ix;

-    table =3D ports_table[port - rdma_start_port(ib_dev)];
+    table =3D ib_dev->cache.ports[port - rdma_start_port(ib_dev)].gid;

     mutex_lock(&table->lock);
     write_lock_irq(&table->rwlock);
@@ -399,12 +397,11 @@ int ib_cache_gid_del(struct ib_device *ib_dev, u8 por=
t,
 int ib_cache_gid_del_all_netdev_gids(struct ib_device *ib_dev, u8 port,
                      struct net_device *ndev)
 {
-    struct ib_gid_table **ports_table =3D ib_dev->cache.gid_cache;
     struct ib_gid_table *table;
     int ix;
     bool deleted =3D false;

-    table  =3D ports_table[port - rdma_start_port(ib_dev)];
+    table =3D ib_dev->cache.ports[port - rdma_start_port(ib_dev)].gid;

     mutex_lock(&table->lock);
     write_lock_irq(&table->rwlock);
@@ -428,10 +425,9 @@ int ib_cache_gid_del_all_netdev_gids(struct
ib_device *ib_dev, u8 port,
 static int __ib_cache_gid_get(struct ib_device *ib_dev, u8 port, int index=
,
                   union ib_gid *gid, struct ib_gid_attr *attr)
 {
-    struct ib_gid_table **ports_table =3D ib_dev->cache.gid_cache;
     struct ib_gid_table *table;

-    table =3D ports_table[port - rdma_start_port(ib_dev)];
+    table =3D ib_dev->cache.ports[port - rdma_start_port(ib_dev)].gid;

     if (index < 0 || index >=3D table->sz)
         return -EINVAL;
@@ -455,14 +451,13 @@ static int _ib_cache_gid_table_find(struct
ib_device *ib_dev,
                     unsigned long mask,
                     u8 *port, u16 *index)
 {
-    struct ib_gid_table **ports_table =3D ib_dev->cache.gid_cache;
     struct ib_gid_table *table;
     u8 p;
     int local_index;
     unsigned long flags;

     for (p =3D 0; p < ib_dev->phys_port_cnt; p++) {
-        table =3D ports_table[p];
+        table =3D ib_dev->cache.ports[p].gid;
         read_lock_irqsave(&table->rwlock, flags);
         local_index =3D find_gid(table, gid, val, false, mask, NULL);
         if (local_index >=3D 0) {
@@ -503,7 +498,6 @@ int ib_find_cached_gid_by_port(struct ib_device *ib_dev=
,
                    u16 *index)
 {
     int local_index;
-    struct ib_gid_table **ports_table =3D ib_dev->cache.gid_cache;
     struct ib_gid_table *table;
     unsigned long mask =3D GID_ATTR_FIND_MASK_GID |
                  GID_ATTR_FIND_MASK_GID_TYPE;
@@ -514,7 +508,7 @@ int ib_find_cached_gid_by_port(struct ib_device *ib_dev=
,
         port > rdma_end_port(ib_dev))
         return -ENOENT;

-    table =3D ports_table[port - rdma_start_port(ib_dev)];
+    table =3D ib_dev->cache.ports[port - rdma_start_port(ib_dev)].gid;

     if (ndev)
         mask |=3D GID_ATTR_FIND_MASK_NETDEV;
@@ -562,21 +556,18 @@ static int ib_cache_gid_find_by_filter(struct
ib_device *ib_dev,
                        void *context,
                        u16 *index)
 {
-    struct ib_gid_table **ports_table =3D ib_dev->cache.gid_cache;
     struct ib_gid_table *table;
     unsigned int i;
     unsigned long flags;
     bool found =3D false;

-    if (!ports_table)
-        return -EOPNOTSUPP;

     if (port < rdma_start_port(ib_dev) ||
         port > rdma_end_port(ib_dev) ||
         !rdma_protocol_roce(ib_dev, port))
         return -EPROTONOSUPPORT;

-    table =3D ports_table[port - rdma_start_port(ib_dev)];
+    table =3D ib_dev->cache.ports[port - rdma_start_port(ib_dev)].gid;

     read_lock_irqsave(&table->rwlock, flags);
     for (i =3D 0; i < table->sz; i++) {
@@ -668,14 +659,13 @@ void ib_cache_gid_set_default_gid(struct
ib_device *ib_dev, u8 port,
                   unsigned long gid_type_mask,
                   enum ib_cache_gid_default_mode mode)
 {
-    struct ib_gid_table **ports_table =3D ib_dev->cache.gid_cache;
     union ib_gid gid;
     struct ib_gid_attr gid_attr;
     struct ib_gid_attr zattr_type =3D zattr;
     struct ib_gid_table *table;
     unsigned int gid_type;

-    table  =3D ports_table[port - rdma_start_port(ib_dev)];
+    table =3D ib_dev->cache.ports[port - rdma_start_port(ib_dev)].gid;

     make_default_gid(ndev, &gid);
     memset(&gid_attr, 0, sizeof(gid_attr));
@@ -766,71 +756,64 @@ static int gid_table_reserve_default(struct
ib_device *ib_dev, u8 port,
 static int _gid_table_setup_one(struct ib_device *ib_dev)
 {
     u8 port;
-    struct ib_gid_table **table;
+    struct ib_gid_table *table;
     int err =3D 0;

-    table =3D kcalloc(ib_dev->phys_port_cnt, sizeof(*table), GFP_KERNEL);
-    if (!table)
-        return -ENOMEM;
-
     for (port =3D 0; port < ib_dev->phys_port_cnt; port++) {
         u8 rdma_port =3D port + rdma_start_port(ib_dev);

-        table[port] =3D
+        table =3D
             alloc_gid_table(
                 ib_dev->port_immutable[rdma_port].gid_tbl_len);
-        if (!table[port]) {
+        if (!table) {
             err =3D -ENOMEM;
             goto rollback_table_setup;
         }

         err =3D gid_table_reserve_default(ib_dev,
                         port + rdma_start_port(ib_dev),
-                        table[port]);
+                        table);
         if (err)
             goto rollback_table_setup;
+        ib_dev->cache.ports[port].gid =3D table;
     }

-    ib_dev->cache.gid_cache =3D table;
     return 0;

 rollback_table_setup:
     for (port =3D 0; port < ib_dev->phys_port_cnt; port++) {
+        table =3D ib_dev->cache.ports[port].gid;
+
         cleanup_gid_table_port(ib_dev, port + rdma_start_port(ib_dev),
-                       table[port]);
-        release_gid_table(table[port]);
+                       table);
+        release_gid_table(table);
     }

-    kfree(table);
     return err;
 }

 static void gid_table_release_one(struct ib_device *ib_dev)
 {
-    struct ib_gid_table **table =3D ib_dev->cache.gid_cache;
+    struct ib_gid_table *table;
     u8 port;

-    if (!table)
-        return;
-
-    for (port =3D 0; port < ib_dev->phys_port_cnt; port++)
-        release_gid_table(table[port]);
-
-    kfree(table);
-    ib_dev->cache.gid_cache =3D NULL;
+    for (port =3D 0; port < ib_dev->phys_port_cnt; port++) {
+        table =3D ib_dev->cache.ports[port].gid;
+        release_gid_table(table);
+        ib_dev->cache.ports[port].gid =3D NULL;
+    }
 }

 static void gid_table_cleanup_one(struct ib_device *ib_dev)
 {
-    struct ib_gid_table **table =3D ib_dev->cache.gid_cache;
+    struct ib_gid_table *table;
     u8 port;

-    if (!table)
-        return;
-
-    for (port =3D 0; port < ib_dev->phys_port_cnt; port++)
+    for (port =3D 0; port < ib_dev->phys_port_cnt; port++) {
+        table =3D ib_dev->cache.ports[port].gid;
         cleanup_gid_table_port(ib_dev, port + rdma_start_port(ib_dev),
-                       table[port]);
+                       table);
+    }
 }

 static int gid_table_setup_one(struct ib_device *ib_dev)
@@ -860,12 +843,12 @@ int ib_get_cached_gid(struct ib_device *device,
 {
     int res;
     unsigned long flags;
-    struct ib_gid_table **ports_table =3D device->cache.gid_cache;
-    struct ib_gid_table *table =3D ports_table[port_num -
rdma_start_port(device)];
+    struct ib_gid_table *table;

     if (port_num < rdma_start_port(device) || port_num > rdma_end_port(dev=
ice))
         return -EINVAL;

+    table =3D device->cache.ports[port_num - rdma_start_port(device)].gid;
     read_lock_irqsave(&table->rwlock, flags);
     res =3D __ib_cache_gid_get(device, port_num, index, gid, gid_attr);
     read_unlock_irqrestore(&table->rwlock, flags);
@@ -917,7 +900,7 @@ int ib_get_cached_pkey(struct ib_device *device,

     read_lock_irqsave(&device->cache.lock, flags);

-    cache =3D device->cache.pkey_cache[port_num - rdma_start_port(device)]=
;
+    cache =3D device->cache.ports[port_num - rdma_start_port(device)].pkey=
;

     if (index < 0 || index >=3D cache->table_len)
         ret =3D -EINVAL;
@@ -946,7 +929,7 @@ int ib_find_cached_pkey(struct ib_device *device,

     read_lock_irqsave(&device->cache.lock, flags);

-    cache =3D device->cache.pkey_cache[port_num - rdma_start_port(device)]=
;
+    cache =3D device->cache.ports[port_num - rdma_start_port(device)].pkey=
;

     *index =3D -1;

@@ -986,7 +969,7 @@ int ib_find_exact_cached_pkey(struct ib_device *device,

     read_lock_irqsave(&device->cache.lock, flags);

-    cache =3D device->cache.pkey_cache[port_num - rdma_start_port(device)]=
;
+    cache =3D device->cache.ports[port_num - rdma_start_port(device)].pkey=
;

     *index =3D -1;

@@ -1014,7 +997,7 @@ int ib_get_cached_lmc(struct ib_device *device,
         return -EINVAL;

     read_lock_irqsave(&device->cache.lock, flags);
-    *lmc =3D device->cache.lmc_cache[port_num - rdma_start_port(device)];
+    *lmc =3D device->cache.ports[port_num - rdma_start_port(device)].lmc;
     read_unlock_irqrestore(&device->cache.lock, flags);

     return ret;
@@ -1032,7 +1015,8 @@ int ib_get_cached_port_state(struct ib_device   *devi=
ce,
         return -EINVAL;

     read_lock_irqsave(&device->cache.lock, flags);
-    *port_state =3D device->cache.port_state_cache[port_num -
rdma_start_port(device)];
+    *port_state =3D device->cache.ports[port_num
+        - rdma_start_port(device)].port_state;
     read_unlock_irqrestore(&device->cache.lock, flags);

     return ret;
@@ -1051,14 +1035,13 @@ static void ib_cache_update(struct ib_device *devic=
e,
     int                        i;
     int                        ret;
     struct ib_gid_table      *table;
-    struct ib_gid_table     **ports_table =3D device->cache.gid_cache;
     bool               use_roce_gid_table =3D
                     rdma_cap_roce_gid_table(device, port);

     if (port < rdma_start_port(device) || port > rdma_end_port(device))
         return;

-    table =3D ports_table[port - rdma_start_port(device)];
+    table =3D device->cache.ports[port - rdma_start_port(device)].gid;

     tprops =3D kmalloc(sizeof *tprops, GFP_KERNEL);
     if (!tprops)
@@ -1110,9 +1093,10 @@ static void ib_cache_update(struct ib_device *device=
,

     write_lock_irq(&device->cache.lock);

-    old_pkey_cache =3D device->cache.pkey_cache[port - rdma_start_port(dev=
ice)];
+    old_pkey_cache =3D device->cache.ports[port -
+        rdma_start_port(device)].pkey;

-    device->cache.pkey_cache[port - rdma_start_port(device)] =3D pkey_cach=
e;
+    device->cache.ports[port - rdma_start_port(device)].pkey =3D pkey_cach=
e;
     if (!use_roce_gid_table) {
         write_lock(&table->rwlock);
         for (i =3D 0; i < gid_cache->table_len; i++) {
@@ -1122,8 +1106,8 @@ static void ib_cache_update(struct ib_device *device,
         write_unlock(&table->rwlock);
     }

-    device->cache.lmc_cache[port - rdma_start_port(device)] =3D tprops->lm=
c;
-    device->cache.port_state_cache[port - rdma_start_port(device)] =3D
+    device->cache.ports[port - rdma_start_port(device)].lmc =3D tprops->lm=
c;
+    device->cache.ports[port - rdma_start_port(device)].port_state =3D
         tprops->state;

     write_unlock_irq(&device->cache.lock);
@@ -1177,26 +1161,17 @@ int ib_cache_setup_one(struct ib_device *device)

     rwlock_init(&device->cache.lock);

-    device->cache.pkey_cache =3D
-        kzalloc(sizeof *device->cache.pkey_cache *
+    device->cache.ports =3D
+        kzalloc(sizeof(*device->cache.ports) *
             (rdma_end_port(device) - rdma_start_port(device) + 1), GFP_KER=
NEL);
-    device->cache.lmc_cache =3D kmalloc(sizeof *device->cache.lmc_cache *
-                      (rdma_end_port(device) -
-                       rdma_start_port(device) + 1),
-                      GFP_KERNEL);
-    device->cache.port_state_cache =3D kmalloc(sizeof
*device->cache.port_state_cache *
-                      (rdma_end_port(device) -
-                       rdma_start_port(device) + 1),
-                      GFP_KERNEL);
-    if (!device->cache.pkey_cache || !device->cache.port_state_cache ||
-        !device->cache.lmc_cache) {
+    if (!device->cache.ports) {
         err =3D -ENOMEM;
-        goto free;
+        goto out;
     }

     err =3D gid_table_setup_one(device);
     if (err)
-        goto free;
+        goto out;

     for (p =3D 0; p <=3D rdma_end_port(device) - rdma_start_port(device); =
++p)
         ib_cache_update(device, p + rdma_start_port(device));
@@ -1211,10 +1186,7 @@ int ib_cache_setup_one(struct ib_device *device)

 err:
     gid_table_cleanup_one(device);
-free:
-    kfree(device->cache.pkey_cache);
-    kfree(device->cache.lmc_cache);
-    kfree(device->cache.port_state_cache);
+out:
     return err;
 }

@@ -1228,15 +1200,11 @@ void ib_cache_release_one(struct ib_device *device)
      * all the device's resources when the cache could no
      * longer be accessed.
      */
-    if (device->cache.pkey_cache)
-        for (p =3D 0;
-             p <=3D rdma_end_port(device) - rdma_start_port(device); ++p)
-            kfree(device->cache.pkey_cache[p]);
+    for (p =3D 0; p <=3D rdma_end_port(device) - rdma_start_port(device); =
++p)
+        kfree(device->cache.ports[p].pkey);

     gid_table_release_one(device);
-    kfree(device->cache.pkey_cache);
-    kfree(device->cache.lmc_cache);
-    kfree(device->cache.port_state_cache);
+    kfree(device->cache.ports);
 }

 void ib_cache_cleanup_one(struct ib_device *device)
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index fafa988..e55afec 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1775,13 +1775,17 @@ enum ib_mad_result {

 #define IB_DEVICE_NAME_MAX 64

+struct ib_port_cache {
+    struct ib_pkey_cache  *pkey;
+    struct ib_gid_table   *gid;
+    u8                     lmc;
+    enum ib_port_state     port_state;
+};
+
 struct ib_cache {
     rwlock_t                lock;
     struct ib_event_handler event_handler;
-    struct ib_pkey_cache  **pkey_cache;
-    struct ib_gid_table   **gid_cache;
-    u8                     *lmc_cache;
-    enum ib_port_state     *port_state_cache;
+    struct ib_port_cache   *ports;
 };

 struct ib_dma_mapping_ops {
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

--001a113d2dcedb4ce105455b9436
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-IB-core-create-struct-ib_port_cache.patch"
Content-Disposition: attachment;
	filename="0001-IB-core-create-struct-ib_port_cache.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ixklhiyw0

RnJvbSBjZDg4MjhkZTZjYWU3MGU0YWQ4YjAxOWYxOTExMmNlNjlkYjgzYzg2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKYWNrIFdhbmcgPGppbnB1LndhbmdAcHJvZml0YnJpY2tzLmNv
bT4KRGF0ZTogV2VkLCA0IEphbiAyMDE3IDE0OjA5OjA1ICswMTAwClN1YmplY3Q6IFtQQVRDSF0g
SUIvY29yZTogY3JlYXRlIHN0cnVjdCBpYl9wb3J0X2NhY2hlCgpBcyBKYXNvbiBzdWdnZXN0ZWQs
IHdlIGhhdmUgNCBlbGVtZW50cyBmb3IgcGVyIHBvcnQgYXJyYXlzLAppdCdzIGJldHRlciB0byBo
YXZlIGEgc2VwYXJhdGUgc3RydWN0dXJlIHRvIHJlcHJlc2VudCB0aGVtLgoKSXQgc2ltcGxpZmll
cyBjb2RlIGEgYml0LCAzMCsgbGluZXMgb2YgY29kZSBsZXNzIDopCgpTaWduZWQtb2ZmLWJ5OiBK
YWNrIFdhbmcgPGppbnB1LndhbmdAcHJvZml0YnJpY2tzLmNvbT4KUmV2aWV3ZWQtYnk6IE1pY2hh
ZWwgV2FuZyA8eXVuLndhbmdAcHJvZml0YnJpY2tzLmNvbT4KLS0tCiBkcml2ZXJzL2luZmluaWJh
bmQvY29yZS9jYWNoZS5jIHwgMTM0ICsrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0KIGluY2x1ZGUvcmRtYS9pYl92ZXJicy5oICAgICAgICAgfCAgMTIgKystLQogMiBmaWxl
cyBjaGFuZ2VkLCA1OSBpbnNlcnRpb25zKCspLCA4NyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS9kcml2ZXJzL2luZmluaWJhbmQvY29yZS9jYWNoZS5jIGIvZHJpdmVycy9pbmZpbmliYW5kL2Nv
cmUvY2FjaGUuYwppbmRleCBmOTE4ODZiLi4yZTUyMDIxIDEwMDY0NAotLS0gYS9kcml2ZXJzL2lu
ZmluaWJhbmQvY29yZS9jYWNoZS5jCisrKyBiL2RyaXZlcnMvaW5maW5pYmFuZC9jb3JlL2NhY2hl
LmMKQEAgLTMxNCwxNCArMzE0LDEzIEBAIHN0YXRpYyB2b2lkIG1ha2VfZGVmYXVsdF9naWQoc3Ry
dWN0ICBuZXRfZGV2aWNlICpkZXYsIHVuaW9uIGliX2dpZCAqZ2lkKQogaW50IGliX2NhY2hlX2dp
ZF9hZGQoc3RydWN0IGliX2RldmljZSAqaWJfZGV2LCB1OCBwb3J0LAogCQkgICAgIHVuaW9uIGli
X2dpZCAqZ2lkLCBzdHJ1Y3QgaWJfZ2lkX2F0dHIgKmF0dHIpCiB7Ci0Jc3RydWN0IGliX2dpZF90
YWJsZSAqKnBvcnRzX3RhYmxlID0gaWJfZGV2LT5jYWNoZS5naWRfY2FjaGU7CiAJc3RydWN0IGli
X2dpZF90YWJsZSAqdGFibGU7CiAJaW50IGl4OwogCWludCByZXQgPSAwOwogCXN0cnVjdCBuZXRf
ZGV2aWNlICppZGV2OwogCWludCBlbXB0eTsKIAotCXRhYmxlID0gcG9ydHNfdGFibGVbcG9ydCAt
IHJkbWFfc3RhcnRfcG9ydChpYl9kZXYpXTsKKwl0YWJsZSA9IGliX2Rldi0+Y2FjaGUucG9ydHNb
cG9ydCAtIHJkbWFfc3RhcnRfcG9ydChpYl9kZXYpXS5naWQ7CiAKIAlpZiAoIW1lbWNtcChnaWQs
ICZ6Z2lkLCBzaXplb2YoKmdpZCkpKQogCQlyZXR1cm4gLUVJTlZBTDsKQEAgLTM2OSwxMSArMzY4
LDEwIEBAIGludCBpYl9jYWNoZV9naWRfYWRkKHN0cnVjdCBpYl9kZXZpY2UgKmliX2RldiwgdTgg
cG9ydCwKIGludCBpYl9jYWNoZV9naWRfZGVsKHN0cnVjdCBpYl9kZXZpY2UgKmliX2RldiwgdTgg
cG9ydCwKIAkJICAgICB1bmlvbiBpYl9naWQgKmdpZCwgc3RydWN0IGliX2dpZF9hdHRyICphdHRy
KQogewotCXN0cnVjdCBpYl9naWRfdGFibGUgKipwb3J0c190YWJsZSA9IGliX2Rldi0+Y2FjaGUu
Z2lkX2NhY2hlOwogCXN0cnVjdCBpYl9naWRfdGFibGUgKnRhYmxlOwogCWludCBpeDsKIAotCXRh
YmxlID0gcG9ydHNfdGFibGVbcG9ydCAtIHJkbWFfc3RhcnRfcG9ydChpYl9kZXYpXTsKKwl0YWJs
ZSA9IGliX2Rldi0+Y2FjaGUucG9ydHNbcG9ydCAtIHJkbWFfc3RhcnRfcG9ydChpYl9kZXYpXS5n
aWQ7CiAKIAltdXRleF9sb2NrKCZ0YWJsZS0+bG9jayk7CiAJd3JpdGVfbG9ja19pcnEoJnRhYmxl
LT5yd2xvY2spOwpAQCAtMzk5LDEyICszOTcsMTEgQEAgaW50IGliX2NhY2hlX2dpZF9kZWwoc3Ry
dWN0IGliX2RldmljZSAqaWJfZGV2LCB1OCBwb3J0LAogaW50IGliX2NhY2hlX2dpZF9kZWxfYWxs
X25ldGRldl9naWRzKHN0cnVjdCBpYl9kZXZpY2UgKmliX2RldiwgdTggcG9ydCwKIAkJCQkgICAg
IHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2KQogewotCXN0cnVjdCBpYl9naWRfdGFibGUgKipwb3J0
c190YWJsZSA9IGliX2Rldi0+Y2FjaGUuZ2lkX2NhY2hlOwogCXN0cnVjdCBpYl9naWRfdGFibGUg
KnRhYmxlOwogCWludCBpeDsKIAlib29sIGRlbGV0ZWQgPSBmYWxzZTsKIAotCXRhYmxlICA9IHBv
cnRzX3RhYmxlW3BvcnQgLSByZG1hX3N0YXJ0X3BvcnQoaWJfZGV2KV07CisJdGFibGUgPSBpYl9k
ZXYtPmNhY2hlLnBvcnRzW3BvcnQgLSByZG1hX3N0YXJ0X3BvcnQoaWJfZGV2KV0uZ2lkOwogCiAJ
bXV0ZXhfbG9jaygmdGFibGUtPmxvY2spOwogCXdyaXRlX2xvY2tfaXJxKCZ0YWJsZS0+cndsb2Nr
KTsKQEAgLTQyOCwxMCArNDI1LDkgQEAgaW50IGliX2NhY2hlX2dpZF9kZWxfYWxsX25ldGRldl9n
aWRzKHN0cnVjdCBpYl9kZXZpY2UgKmliX2RldiwgdTggcG9ydCwKIHN0YXRpYyBpbnQgX19pYl9j
YWNoZV9naWRfZ2V0KHN0cnVjdCBpYl9kZXZpY2UgKmliX2RldiwgdTggcG9ydCwgaW50IGluZGV4
LAogCQkJICAgICAgdW5pb24gaWJfZ2lkICpnaWQsIHN0cnVjdCBpYl9naWRfYXR0ciAqYXR0cikK
IHsKLQlzdHJ1Y3QgaWJfZ2lkX3RhYmxlICoqcG9ydHNfdGFibGUgPSBpYl9kZXYtPmNhY2hlLmdp
ZF9jYWNoZTsKIAlzdHJ1Y3QgaWJfZ2lkX3RhYmxlICp0YWJsZTsKIAotCXRhYmxlID0gcG9ydHNf
dGFibGVbcG9ydCAtIHJkbWFfc3RhcnRfcG9ydChpYl9kZXYpXTsKKwl0YWJsZSA9IGliX2Rldi0+
Y2FjaGUucG9ydHNbcG9ydCAtIHJkbWFfc3RhcnRfcG9ydChpYl9kZXYpXS5naWQ7CiAKIAlpZiAo
aW5kZXggPCAwIHx8IGluZGV4ID49IHRhYmxlLT5zeikKIAkJcmV0dXJuIC1FSU5WQUw7CkBAIC00
NTUsMTQgKzQ1MSwxMyBAQCBzdGF0aWMgaW50IF9pYl9jYWNoZV9naWRfdGFibGVfZmluZChzdHJ1
Y3QgaWJfZGV2aWNlICppYl9kZXYsCiAJCQkJICAgIHVuc2lnbmVkIGxvbmcgbWFzaywKIAkJCQkg
ICAgdTggKnBvcnQsIHUxNiAqaW5kZXgpCiB7Ci0Jc3RydWN0IGliX2dpZF90YWJsZSAqKnBvcnRz
X3RhYmxlID0gaWJfZGV2LT5jYWNoZS5naWRfY2FjaGU7CiAJc3RydWN0IGliX2dpZF90YWJsZSAq
dGFibGU7CiAJdTggcDsKIAlpbnQgbG9jYWxfaW5kZXg7CiAJdW5zaWduZWQgbG9uZyBmbGFnczsK
IAogCWZvciAocCA9IDA7IHAgPCBpYl9kZXYtPnBoeXNfcG9ydF9jbnQ7IHArKykgewotCQl0YWJs
ZSA9IHBvcnRzX3RhYmxlW3BdOworCQl0YWJsZSA9IGliX2Rldi0+Y2FjaGUucG9ydHNbcF0uZ2lk
OwogCQlyZWFkX2xvY2tfaXJxc2F2ZSgmdGFibGUtPnJ3bG9jaywgZmxhZ3MpOwogCQlsb2NhbF9p
bmRleCA9IGZpbmRfZ2lkKHRhYmxlLCBnaWQsIHZhbCwgZmFsc2UsIG1hc2ssIE5VTEwpOwogCQlp
ZiAobG9jYWxfaW5kZXggPj0gMCkgewpAQCAtNTAzLDcgKzQ5OCw2IEBAIGludCBpYl9maW5kX2Nh
Y2hlZF9naWRfYnlfcG9ydChzdHJ1Y3QgaWJfZGV2aWNlICppYl9kZXYsCiAJCQkgICAgICAgdTE2
ICppbmRleCkKIHsKIAlpbnQgbG9jYWxfaW5kZXg7Ci0Jc3RydWN0IGliX2dpZF90YWJsZSAqKnBv
cnRzX3RhYmxlID0gaWJfZGV2LT5jYWNoZS5naWRfY2FjaGU7CiAJc3RydWN0IGliX2dpZF90YWJs
ZSAqdGFibGU7CiAJdW5zaWduZWQgbG9uZyBtYXNrID0gR0lEX0FUVFJfRklORF9NQVNLX0dJRCB8
CiAJCQkgICAgIEdJRF9BVFRSX0ZJTkRfTUFTS19HSURfVFlQRTsKQEAgLTUxNCw3ICs1MDgsNyBA
QCBpbnQgaWJfZmluZF9jYWNoZWRfZ2lkX2J5X3BvcnQoc3RydWN0IGliX2RldmljZSAqaWJfZGV2
LAogCSAgICBwb3J0ID4gcmRtYV9lbmRfcG9ydChpYl9kZXYpKQogCQlyZXR1cm4gLUVOT0VOVDsK
IAotCXRhYmxlID0gcG9ydHNfdGFibGVbcG9ydCAtIHJkbWFfc3RhcnRfcG9ydChpYl9kZXYpXTsK
Kwl0YWJsZSA9IGliX2Rldi0+Y2FjaGUucG9ydHNbcG9ydCAtIHJkbWFfc3RhcnRfcG9ydChpYl9k
ZXYpXS5naWQ7CiAKIAlpZiAobmRldikKIAkJbWFzayB8PSBHSURfQVRUUl9GSU5EX01BU0tfTkVU
REVWOwpAQCAtNTYyLDIxICs1NTYsMTggQEAgc3RhdGljIGludCBpYl9jYWNoZV9naWRfZmluZF9i
eV9maWx0ZXIoc3RydWN0IGliX2RldmljZSAqaWJfZGV2LAogCQkJCSAgICAgICB2b2lkICpjb250
ZXh0LAogCQkJCSAgICAgICB1MTYgKmluZGV4KQogewotCXN0cnVjdCBpYl9naWRfdGFibGUgKipw
b3J0c190YWJsZSA9IGliX2Rldi0+Y2FjaGUuZ2lkX2NhY2hlOwogCXN0cnVjdCBpYl9naWRfdGFi
bGUgKnRhYmxlOwogCXVuc2lnbmVkIGludCBpOwogCXVuc2lnbmVkIGxvbmcgZmxhZ3M7CiAJYm9v
bCBmb3VuZCA9IGZhbHNlOwogCi0JaWYgKCFwb3J0c190YWJsZSkKLQkJcmV0dXJuIC1FT1BOT1RT
VVBQOwogCiAJaWYgKHBvcnQgPCByZG1hX3N0YXJ0X3BvcnQoaWJfZGV2KSB8fAogCSAgICBwb3J0
ID4gcmRtYV9lbmRfcG9ydChpYl9kZXYpIHx8CiAJICAgICFyZG1hX3Byb3RvY29sX3JvY2UoaWJf
ZGV2LCBwb3J0KSkKIAkJcmV0dXJuIC1FUFJPVE9OT1NVUFBPUlQ7CiAKLQl0YWJsZSA9IHBvcnRz
X3RhYmxlW3BvcnQgLSByZG1hX3N0YXJ0X3BvcnQoaWJfZGV2KV07CisJdGFibGUgPSBpYl9kZXYt
PmNhY2hlLnBvcnRzW3BvcnQgLSByZG1hX3N0YXJ0X3BvcnQoaWJfZGV2KV0uZ2lkOwogCiAJcmVh
ZF9sb2NrX2lycXNhdmUoJnRhYmxlLT5yd2xvY2ssIGZsYWdzKTsKIAlmb3IgKGkgPSAwOyBpIDwg
dGFibGUtPnN6OyBpKyspIHsKQEAgLTY2OCwxNCArNjU5LDEzIEBAIHZvaWQgaWJfY2FjaGVfZ2lk
X3NldF9kZWZhdWx0X2dpZChzdHJ1Y3QgaWJfZGV2aWNlICppYl9kZXYsIHU4IHBvcnQsCiAJCQkJ
ICB1bnNpZ25lZCBsb25nIGdpZF90eXBlX21hc2ssCiAJCQkJICBlbnVtIGliX2NhY2hlX2dpZF9k
ZWZhdWx0X21vZGUgbW9kZSkKIHsKLQlzdHJ1Y3QgaWJfZ2lkX3RhYmxlICoqcG9ydHNfdGFibGUg
PSBpYl9kZXYtPmNhY2hlLmdpZF9jYWNoZTsKIAl1bmlvbiBpYl9naWQgZ2lkOwogCXN0cnVjdCBp
Yl9naWRfYXR0ciBnaWRfYXR0cjsKIAlzdHJ1Y3QgaWJfZ2lkX2F0dHIgemF0dHJfdHlwZSA9IHph
dHRyOwogCXN0cnVjdCBpYl9naWRfdGFibGUgKnRhYmxlOwogCXVuc2lnbmVkIGludCBnaWRfdHlw
ZTsKIAotCXRhYmxlICA9IHBvcnRzX3RhYmxlW3BvcnQgLSByZG1hX3N0YXJ0X3BvcnQoaWJfZGV2
KV07CisJdGFibGUgPSBpYl9kZXYtPmNhY2hlLnBvcnRzW3BvcnQgLSByZG1hX3N0YXJ0X3BvcnQo
aWJfZGV2KV0uZ2lkOwogCiAJbWFrZV9kZWZhdWx0X2dpZChuZGV2LCAmZ2lkKTsKIAltZW1zZXQo
JmdpZF9hdHRyLCAwLCBzaXplb2YoZ2lkX2F0dHIpKTsKQEAgLTc2Niw3MSArNzU2LDY0IEBAIHN0
YXRpYyBpbnQgZ2lkX3RhYmxlX3Jlc2VydmVfZGVmYXVsdChzdHJ1Y3QgaWJfZGV2aWNlICppYl9k
ZXYsIHU4IHBvcnQsCiBzdGF0aWMgaW50IF9naWRfdGFibGVfc2V0dXBfb25lKHN0cnVjdCBpYl9k
ZXZpY2UgKmliX2RldikKIHsKIAl1OCBwb3J0OwotCXN0cnVjdCBpYl9naWRfdGFibGUgKip0YWJs
ZTsKKwlzdHJ1Y3QgaWJfZ2lkX3RhYmxlICp0YWJsZTsKIAlpbnQgZXJyID0gMDsKIAotCXRhYmxl
ID0ga2NhbGxvYyhpYl9kZXYtPnBoeXNfcG9ydF9jbnQsIHNpemVvZigqdGFibGUpLCBHRlBfS0VS
TkVMKTsKLQlpZiAoIXRhYmxlKQotCQlyZXR1cm4gLUVOT01FTTsKLQogCWZvciAocG9ydCA9IDA7
IHBvcnQgPCBpYl9kZXYtPnBoeXNfcG9ydF9jbnQ7IHBvcnQrKykgewogCQl1OCByZG1hX3BvcnQg
PSBwb3J0ICsgcmRtYV9zdGFydF9wb3J0KGliX2Rldik7CiAKLQkJdGFibGVbcG9ydF0gPQorCQl0
YWJsZSA9CiAJCQlhbGxvY19naWRfdGFibGUoCiAJCQkJaWJfZGV2LT5wb3J0X2ltbXV0YWJsZVty
ZG1hX3BvcnRdLmdpZF90YmxfbGVuKTsKLQkJaWYgKCF0YWJsZVtwb3J0XSkgeworCQlpZiAoIXRh
YmxlKSB7CiAJCQllcnIgPSAtRU5PTUVNOwogCQkJZ290byByb2xsYmFja190YWJsZV9zZXR1cDsK
IAkJfQogCiAJCWVyciA9IGdpZF90YWJsZV9yZXNlcnZlX2RlZmF1bHQoaWJfZGV2LAogCQkJCQkJ
cG9ydCArIHJkbWFfc3RhcnRfcG9ydChpYl9kZXYpLAotCQkJCQkJdGFibGVbcG9ydF0pOworCQkJ
CQkJdGFibGUpOwogCQlpZiAoZXJyKQogCQkJZ290byByb2xsYmFja190YWJsZV9zZXR1cDsKKwkJ
aWJfZGV2LT5jYWNoZS5wb3J0c1twb3J0XS5naWQgPSB0YWJsZTsKIAl9CiAKLQlpYl9kZXYtPmNh
Y2hlLmdpZF9jYWNoZSA9IHRhYmxlOwogCXJldHVybiAwOwogCiByb2xsYmFja190YWJsZV9zZXR1
cDoKIAlmb3IgKHBvcnQgPSAwOyBwb3J0IDwgaWJfZGV2LT5waHlzX3BvcnRfY250OyBwb3J0Kysp
IHsKKwkJdGFibGUgPSBpYl9kZXYtPmNhY2hlLnBvcnRzW3BvcnRdLmdpZDsKKwogCQljbGVhbnVw
X2dpZF90YWJsZV9wb3J0KGliX2RldiwgcG9ydCArIHJkbWFfc3RhcnRfcG9ydChpYl9kZXYpLAot
CQkJCSAgICAgICB0YWJsZVtwb3J0XSk7Ci0JCXJlbGVhc2VfZ2lkX3RhYmxlKHRhYmxlW3BvcnRd
KTsKKwkJCQkgICAgICAgdGFibGUpOworCQlyZWxlYXNlX2dpZF90YWJsZSh0YWJsZSk7CiAJfQog
Ci0Ja2ZyZWUodGFibGUpOwogCXJldHVybiBlcnI7CiB9CiAKIHN0YXRpYyB2b2lkIGdpZF90YWJs
ZV9yZWxlYXNlX29uZShzdHJ1Y3QgaWJfZGV2aWNlICppYl9kZXYpCiB7Ci0Jc3RydWN0IGliX2dp
ZF90YWJsZSAqKnRhYmxlID0gaWJfZGV2LT5jYWNoZS5naWRfY2FjaGU7CisJc3RydWN0IGliX2dp
ZF90YWJsZSAqdGFibGU7CiAJdTggcG9ydDsKIAotCWlmICghdGFibGUpCi0JCXJldHVybjsKLQot
CWZvciAocG9ydCA9IDA7IHBvcnQgPCBpYl9kZXYtPnBoeXNfcG9ydF9jbnQ7IHBvcnQrKykKLQkJ
cmVsZWFzZV9naWRfdGFibGUodGFibGVbcG9ydF0pOwotCi0Ja2ZyZWUodGFibGUpOwotCWliX2Rl
di0+Y2FjaGUuZ2lkX2NhY2hlID0gTlVMTDsKKwlmb3IgKHBvcnQgPSAwOyBwb3J0IDwgaWJfZGV2
LT5waHlzX3BvcnRfY250OyBwb3J0KyspIHsKKwkJdGFibGUgPSBpYl9kZXYtPmNhY2hlLnBvcnRz
W3BvcnRdLmdpZDsKKwkJcmVsZWFzZV9naWRfdGFibGUodGFibGUpOworCQlpYl9kZXYtPmNhY2hl
LnBvcnRzW3BvcnRdLmdpZCA9IE5VTEw7CisJfQogfQogCiBzdGF0aWMgdm9pZCBnaWRfdGFibGVf
Y2xlYW51cF9vbmUoc3RydWN0IGliX2RldmljZSAqaWJfZGV2KQogewotCXN0cnVjdCBpYl9naWRf
dGFibGUgKip0YWJsZSA9IGliX2Rldi0+Y2FjaGUuZ2lkX2NhY2hlOworCXN0cnVjdCBpYl9naWRf
dGFibGUgKnRhYmxlOwogCXU4IHBvcnQ7CiAKLQlpZiAoIXRhYmxlKQotCQlyZXR1cm47Ci0KLQlm
b3IgKHBvcnQgPSAwOyBwb3J0IDwgaWJfZGV2LT5waHlzX3BvcnRfY250OyBwb3J0KyspCisJZm9y
IChwb3J0ID0gMDsgcG9ydCA8IGliX2Rldi0+cGh5c19wb3J0X2NudDsgcG9ydCsrKSB7CisJCXRh
YmxlID0gaWJfZGV2LT5jYWNoZS5wb3J0c1twb3J0XS5naWQ7CiAJCWNsZWFudXBfZ2lkX3RhYmxl
X3BvcnQoaWJfZGV2LCBwb3J0ICsgcmRtYV9zdGFydF9wb3J0KGliX2RldiksCi0JCQkJICAgICAg
IHRhYmxlW3BvcnRdKTsKKwkJCQkgICAgICAgdGFibGUpOworCX0KIH0KIAogc3RhdGljIGludCBn
aWRfdGFibGVfc2V0dXBfb25lKHN0cnVjdCBpYl9kZXZpY2UgKmliX2RldikKQEAgLTg2MCwxMiAr
ODQzLDEyIEBAIGludCBpYl9nZXRfY2FjaGVkX2dpZChzdHJ1Y3QgaWJfZGV2aWNlICpkZXZpY2Us
CiB7CiAJaW50IHJlczsKIAl1bnNpZ25lZCBsb25nIGZsYWdzOwotCXN0cnVjdCBpYl9naWRfdGFi
bGUgKipwb3J0c190YWJsZSA9IGRldmljZS0+Y2FjaGUuZ2lkX2NhY2hlOwotCXN0cnVjdCBpYl9n
aWRfdGFibGUgKnRhYmxlID0gcG9ydHNfdGFibGVbcG9ydF9udW0gLSByZG1hX3N0YXJ0X3BvcnQo
ZGV2aWNlKV07CisJc3RydWN0IGliX2dpZF90YWJsZSAqdGFibGU7CiAKIAlpZiAocG9ydF9udW0g
PCByZG1hX3N0YXJ0X3BvcnQoZGV2aWNlKSB8fCBwb3J0X251bSA+IHJkbWFfZW5kX3BvcnQoZGV2
aWNlKSkKIAkJcmV0dXJuIC1FSU5WQUw7CiAKKwl0YWJsZSA9IGRldmljZS0+Y2FjaGUucG9ydHNb
cG9ydF9udW0gLSByZG1hX3N0YXJ0X3BvcnQoZGV2aWNlKV0uZ2lkOwogCXJlYWRfbG9ja19pcnFz
YXZlKCZ0YWJsZS0+cndsb2NrLCBmbGFncyk7CiAJcmVzID0gX19pYl9jYWNoZV9naWRfZ2V0KGRl
dmljZSwgcG9ydF9udW0sIGluZGV4LCBnaWQsIGdpZF9hdHRyKTsKIAlyZWFkX3VubG9ja19pcnFy
ZXN0b3JlKCZ0YWJsZS0+cndsb2NrLCBmbGFncyk7CkBAIC05MTcsNyArOTAwLDcgQEAgaW50IGli
X2dldF9jYWNoZWRfcGtleShzdHJ1Y3QgaWJfZGV2aWNlICpkZXZpY2UsCiAKIAlyZWFkX2xvY2tf
aXJxc2F2ZSgmZGV2aWNlLT5jYWNoZS5sb2NrLCBmbGFncyk7CiAKLQljYWNoZSA9IGRldmljZS0+
Y2FjaGUucGtleV9jYWNoZVtwb3J0X251bSAtIHJkbWFfc3RhcnRfcG9ydChkZXZpY2UpXTsKKwlj
YWNoZSA9IGRldmljZS0+Y2FjaGUucG9ydHNbcG9ydF9udW0gLSByZG1hX3N0YXJ0X3BvcnQoZGV2
aWNlKV0ucGtleTsKIAogCWlmIChpbmRleCA8IDAgfHwgaW5kZXggPj0gY2FjaGUtPnRhYmxlX2xl
bikKIAkJcmV0ID0gLUVJTlZBTDsKQEAgLTk0Niw3ICs5MjksNyBAQCBpbnQgaWJfZmluZF9jYWNo
ZWRfcGtleShzdHJ1Y3QgaWJfZGV2aWNlICpkZXZpY2UsCiAKIAlyZWFkX2xvY2tfaXJxc2F2ZSgm
ZGV2aWNlLT5jYWNoZS5sb2NrLCBmbGFncyk7CiAKLQljYWNoZSA9IGRldmljZS0+Y2FjaGUucGtl
eV9jYWNoZVtwb3J0X251bSAtIHJkbWFfc3RhcnRfcG9ydChkZXZpY2UpXTsKKwljYWNoZSA9IGRl
dmljZS0+Y2FjaGUucG9ydHNbcG9ydF9udW0gLSByZG1hX3N0YXJ0X3BvcnQoZGV2aWNlKV0ucGtl
eTsKIAogCSppbmRleCA9IC0xOwogCkBAIC05ODYsNyArOTY5LDcgQEAgaW50IGliX2ZpbmRfZXhh
Y3RfY2FjaGVkX3BrZXkoc3RydWN0IGliX2RldmljZSAqZGV2aWNlLAogCiAJcmVhZF9sb2NrX2ly
cXNhdmUoJmRldmljZS0+Y2FjaGUubG9jaywgZmxhZ3MpOwogCi0JY2FjaGUgPSBkZXZpY2UtPmNh
Y2hlLnBrZXlfY2FjaGVbcG9ydF9udW0gLSByZG1hX3N0YXJ0X3BvcnQoZGV2aWNlKV07CisJY2Fj
aGUgPSBkZXZpY2UtPmNhY2hlLnBvcnRzW3BvcnRfbnVtIC0gcmRtYV9zdGFydF9wb3J0KGRldmlj
ZSldLnBrZXk7CiAKIAkqaW5kZXggPSAtMTsKIApAQCAtMTAxNCw3ICs5OTcsNyBAQCBpbnQgaWJf
Z2V0X2NhY2hlZF9sbWMoc3RydWN0IGliX2RldmljZSAqZGV2aWNlLAogCQlyZXR1cm4gLUVJTlZB
TDsKIAogCXJlYWRfbG9ja19pcnFzYXZlKCZkZXZpY2UtPmNhY2hlLmxvY2ssIGZsYWdzKTsKLQkq
bG1jID0gZGV2aWNlLT5jYWNoZS5sbWNfY2FjaGVbcG9ydF9udW0gLSByZG1hX3N0YXJ0X3BvcnQo
ZGV2aWNlKV07CisJKmxtYyA9IGRldmljZS0+Y2FjaGUucG9ydHNbcG9ydF9udW0gLSByZG1hX3N0
YXJ0X3BvcnQoZGV2aWNlKV0ubG1jOwogCXJlYWRfdW5sb2NrX2lycXJlc3RvcmUoJmRldmljZS0+
Y2FjaGUubG9jaywgZmxhZ3MpOwogCiAJcmV0dXJuIHJldDsKQEAgLTEwMzIsNyArMTAxNSw4IEBA
IGludCBpYl9nZXRfY2FjaGVkX3BvcnRfc3RhdGUoc3RydWN0IGliX2RldmljZSAgICpkZXZpY2Us
CiAJCXJldHVybiAtRUlOVkFMOwogCiAJcmVhZF9sb2NrX2lycXNhdmUoJmRldmljZS0+Y2FjaGUu
bG9jaywgZmxhZ3MpOwotCSpwb3J0X3N0YXRlID0gZGV2aWNlLT5jYWNoZS5wb3J0X3N0YXRlX2Nh
Y2hlW3BvcnRfbnVtIC0gcmRtYV9zdGFydF9wb3J0KGRldmljZSldOworCSpwb3J0X3N0YXRlID0g
ZGV2aWNlLT5jYWNoZS5wb3J0c1twb3J0X251bQorCQktIHJkbWFfc3RhcnRfcG9ydChkZXZpY2Up
XS5wb3J0X3N0YXRlOwogCXJlYWRfdW5sb2NrX2lycXJlc3RvcmUoJmRldmljZS0+Y2FjaGUubG9j
aywgZmxhZ3MpOwogCiAJcmV0dXJuIHJldDsKQEAgLTEwNTEsMTQgKzEwMzUsMTMgQEAgc3RhdGlj
IHZvaWQgaWJfY2FjaGVfdXBkYXRlKHN0cnVjdCBpYl9kZXZpY2UgKmRldmljZSwKIAlpbnQgICAg
ICAgICAgICAgICAgICAgICAgICBpOwogCWludCAgICAgICAgICAgICAgICAgICAgICAgIHJldDsK
IAlzdHJ1Y3QgaWJfZ2lkX3RhYmxlCSAgKnRhYmxlOwotCXN0cnVjdCBpYl9naWRfdGFibGUJICoq
cG9ydHNfdGFibGUgPSBkZXZpY2UtPmNhY2hlLmdpZF9jYWNoZTsKIAlib29sCQkJICAgdXNlX3Jv
Y2VfZ2lkX3RhYmxlID0KIAkJCQkJcmRtYV9jYXBfcm9jZV9naWRfdGFibGUoZGV2aWNlLCBwb3J0
KTsKIAogCWlmIChwb3J0IDwgcmRtYV9zdGFydF9wb3J0KGRldmljZSkgfHwgcG9ydCA+IHJkbWFf
ZW5kX3BvcnQoZGV2aWNlKSkKIAkJcmV0dXJuOwogCi0JdGFibGUgPSBwb3J0c190YWJsZVtwb3J0
IC0gcmRtYV9zdGFydF9wb3J0KGRldmljZSldOworCXRhYmxlID0gZGV2aWNlLT5jYWNoZS5wb3J0
c1twb3J0IC0gcmRtYV9zdGFydF9wb3J0KGRldmljZSldLmdpZDsKIAogCXRwcm9wcyA9IGttYWxs
b2Moc2l6ZW9mICp0cHJvcHMsIEdGUF9LRVJORUwpOwogCWlmICghdHByb3BzKQpAQCAtMTExMCw5
ICsxMDkzLDEwIEBAIHN0YXRpYyB2b2lkIGliX2NhY2hlX3VwZGF0ZShzdHJ1Y3QgaWJfZGV2aWNl
ICpkZXZpY2UsCiAKIAl3cml0ZV9sb2NrX2lycSgmZGV2aWNlLT5jYWNoZS5sb2NrKTsKIAotCW9s
ZF9wa2V5X2NhY2hlID0gZGV2aWNlLT5jYWNoZS5wa2V5X2NhY2hlW3BvcnQgLSByZG1hX3N0YXJ0
X3BvcnQoZGV2aWNlKV07CisJb2xkX3BrZXlfY2FjaGUgPSBkZXZpY2UtPmNhY2hlLnBvcnRzW3Bv
cnQgLQorCQlyZG1hX3N0YXJ0X3BvcnQoZGV2aWNlKV0ucGtleTsKIAotCWRldmljZS0+Y2FjaGUu
cGtleV9jYWNoZVtwb3J0IC0gcmRtYV9zdGFydF9wb3J0KGRldmljZSldID0gcGtleV9jYWNoZTsK
KwlkZXZpY2UtPmNhY2hlLnBvcnRzW3BvcnQgLSByZG1hX3N0YXJ0X3BvcnQoZGV2aWNlKV0ucGtl
eSA9IHBrZXlfY2FjaGU7CiAJaWYgKCF1c2Vfcm9jZV9naWRfdGFibGUpIHsKIAkJd3JpdGVfbG9j
aygmdGFibGUtPnJ3bG9jayk7CiAJCWZvciAoaSA9IDA7IGkgPCBnaWRfY2FjaGUtPnRhYmxlX2xl
bjsgaSsrKSB7CkBAIC0xMTIyLDggKzExMDYsOCBAQCBzdGF0aWMgdm9pZCBpYl9jYWNoZV91cGRh
dGUoc3RydWN0IGliX2RldmljZSAqZGV2aWNlLAogCQl3cml0ZV91bmxvY2soJnRhYmxlLT5yd2xv
Y2spOwogCX0KIAotCWRldmljZS0+Y2FjaGUubG1jX2NhY2hlW3BvcnQgLSByZG1hX3N0YXJ0X3Bv
cnQoZGV2aWNlKV0gPSB0cHJvcHMtPmxtYzsKLQlkZXZpY2UtPmNhY2hlLnBvcnRfc3RhdGVfY2Fj
aGVbcG9ydCAtIHJkbWFfc3RhcnRfcG9ydChkZXZpY2UpXSA9CisJZGV2aWNlLT5jYWNoZS5wb3J0
c1twb3J0IC0gcmRtYV9zdGFydF9wb3J0KGRldmljZSldLmxtYyA9IHRwcm9wcy0+bG1jOworCWRl
dmljZS0+Y2FjaGUucG9ydHNbcG9ydCAtIHJkbWFfc3RhcnRfcG9ydChkZXZpY2UpXS5wb3J0X3N0
YXRlID0KIAkJdHByb3BzLT5zdGF0ZTsKIAogCXdyaXRlX3VubG9ja19pcnEoJmRldmljZS0+Y2Fj
aGUubG9jayk7CkBAIC0xMTc3LDI2ICsxMTYxLDE3IEBAIGludCBpYl9jYWNoZV9zZXR1cF9vbmUo
c3RydWN0IGliX2RldmljZSAqZGV2aWNlKQogCiAJcndsb2NrX2luaXQoJmRldmljZS0+Y2FjaGUu
bG9jayk7CiAKLQlkZXZpY2UtPmNhY2hlLnBrZXlfY2FjaGUgPQotCQlremFsbG9jKHNpemVvZiAq
ZGV2aWNlLT5jYWNoZS5wa2V5X2NhY2hlICoKKwlkZXZpY2UtPmNhY2hlLnBvcnRzID0KKwkJa3ph
bGxvYyhzaXplb2YoKmRldmljZS0+Y2FjaGUucG9ydHMpICoKIAkJCShyZG1hX2VuZF9wb3J0KGRl
dmljZSkgLSByZG1hX3N0YXJ0X3BvcnQoZGV2aWNlKSArIDEpLCBHRlBfS0VSTkVMKTsKLQlkZXZp
Y2UtPmNhY2hlLmxtY19jYWNoZSA9IGttYWxsb2Moc2l6ZW9mICpkZXZpY2UtPmNhY2hlLmxtY19j
YWNoZSAqCi0JCQkJCSAgKHJkbWFfZW5kX3BvcnQoZGV2aWNlKSAtCi0JCQkJCSAgIHJkbWFfc3Rh
cnRfcG9ydChkZXZpY2UpICsgMSksCi0JCQkJCSAgR0ZQX0tFUk5FTCk7Ci0JZGV2aWNlLT5jYWNo
ZS5wb3J0X3N0YXRlX2NhY2hlID0ga21hbGxvYyhzaXplb2YgKmRldmljZS0+Y2FjaGUucG9ydF9z
dGF0ZV9jYWNoZSAqCi0JCQkJCSAgKHJkbWFfZW5kX3BvcnQoZGV2aWNlKSAtCi0JCQkJCSAgIHJk
bWFfc3RhcnRfcG9ydChkZXZpY2UpICsgMSksCi0JCQkJCSAgR0ZQX0tFUk5FTCk7Ci0JaWYgKCFk
ZXZpY2UtPmNhY2hlLnBrZXlfY2FjaGUgfHwgIWRldmljZS0+Y2FjaGUucG9ydF9zdGF0ZV9jYWNo
ZSB8fAotCSAgICAhZGV2aWNlLT5jYWNoZS5sbWNfY2FjaGUpIHsKKwlpZiAoIWRldmljZS0+Y2Fj
aGUucG9ydHMpIHsKIAkJZXJyID0gLUVOT01FTTsKLQkJZ290byBmcmVlOworCQlnb3RvIG91dDsK
IAl9CiAKIAllcnIgPSBnaWRfdGFibGVfc2V0dXBfb25lKGRldmljZSk7CiAJaWYgKGVycikKLQkJ
Z290byBmcmVlOworCQlnb3RvIG91dDsKIAogCWZvciAocCA9IDA7IHAgPD0gcmRtYV9lbmRfcG9y
dChkZXZpY2UpIC0gcmRtYV9zdGFydF9wb3J0KGRldmljZSk7ICsrcCkKIAkJaWJfY2FjaGVfdXBk
YXRlKGRldmljZSwgcCArIHJkbWFfc3RhcnRfcG9ydChkZXZpY2UpKTsKQEAgLTEyMTEsMTAgKzEx
ODYsNyBAQCBpbnQgaWJfY2FjaGVfc2V0dXBfb25lKHN0cnVjdCBpYl9kZXZpY2UgKmRldmljZSkK
IAogZXJyOgogCWdpZF90YWJsZV9jbGVhbnVwX29uZShkZXZpY2UpOwotZnJlZToKLQlrZnJlZShk
ZXZpY2UtPmNhY2hlLnBrZXlfY2FjaGUpOwotCWtmcmVlKGRldmljZS0+Y2FjaGUubG1jX2NhY2hl
KTsKLQlrZnJlZShkZXZpY2UtPmNhY2hlLnBvcnRfc3RhdGVfY2FjaGUpOworb3V0OgogCXJldHVy
biBlcnI7CiB9CiAKQEAgLTEyMjgsMTUgKzEyMDAsMTEgQEAgdm9pZCBpYl9jYWNoZV9yZWxlYXNl
X29uZShzdHJ1Y3QgaWJfZGV2aWNlICpkZXZpY2UpCiAJICogYWxsIHRoZSBkZXZpY2UncyByZXNv
dXJjZXMgd2hlbiB0aGUgY2FjaGUgY291bGQgbm8KIAkgKiBsb25nZXIgYmUgYWNjZXNzZWQuCiAJ
ICovCi0JaWYgKGRldmljZS0+Y2FjaGUucGtleV9jYWNoZSkKLQkJZm9yIChwID0gMDsKLQkJICAg
ICBwIDw9IHJkbWFfZW5kX3BvcnQoZGV2aWNlKSAtIHJkbWFfc3RhcnRfcG9ydChkZXZpY2UpOyAr
K3ApCi0JCQlrZnJlZShkZXZpY2UtPmNhY2hlLnBrZXlfY2FjaGVbcF0pOworCWZvciAocCA9IDA7
IHAgPD0gcmRtYV9lbmRfcG9ydChkZXZpY2UpIC0gcmRtYV9zdGFydF9wb3J0KGRldmljZSk7ICsr
cCkKKwkJa2ZyZWUoZGV2aWNlLT5jYWNoZS5wb3J0c1twXS5wa2V5KTsKIAogCWdpZF90YWJsZV9y
ZWxlYXNlX29uZShkZXZpY2UpOwotCWtmcmVlKGRldmljZS0+Y2FjaGUucGtleV9jYWNoZSk7Ci0J
a2ZyZWUoZGV2aWNlLT5jYWNoZS5sbWNfY2FjaGUpOwotCWtmcmVlKGRldmljZS0+Y2FjaGUucG9y
dF9zdGF0ZV9jYWNoZSk7CisJa2ZyZWUoZGV2aWNlLT5jYWNoZS5wb3J0cyk7CiB9CiAKIHZvaWQg
aWJfY2FjaGVfY2xlYW51cF9vbmUoc3RydWN0IGliX2RldmljZSAqZGV2aWNlKQpkaWZmIC0tZ2l0
IGEvaW5jbHVkZS9yZG1hL2liX3ZlcmJzLmggYi9pbmNsdWRlL3JkbWEvaWJfdmVyYnMuaAppbmRl
eCBmYWZhOTg4Li5lNTVhZmVjIDEwMDY0NAotLS0gYS9pbmNsdWRlL3JkbWEvaWJfdmVyYnMuaAor
KysgYi9pbmNsdWRlL3JkbWEvaWJfdmVyYnMuaApAQCAtMTc3NSwxMyArMTc3NSwxNyBAQCBlbnVt
IGliX21hZF9yZXN1bHQgewogCiAjZGVmaW5lIElCX0RFVklDRV9OQU1FX01BWCA2NAogCitzdHJ1
Y3QgaWJfcG9ydF9jYWNoZSB7CisJc3RydWN0IGliX3BrZXlfY2FjaGUgICpwa2V5OworCXN0cnVj
dCBpYl9naWRfdGFibGUgICAqZ2lkOworCXU4ICAgICAgICAgICAgICAgICAgICAgbG1jOworCWVu
dW0gaWJfcG9ydF9zdGF0ZSAgICAgcG9ydF9zdGF0ZTsKK307CisKIHN0cnVjdCBpYl9jYWNoZSB7
CiAJcndsb2NrX3QgICAgICAgICAgICAgICAgbG9jazsKIAlzdHJ1Y3QgaWJfZXZlbnRfaGFuZGxl
ciBldmVudF9oYW5kbGVyOwotCXN0cnVjdCBpYl9wa2V5X2NhY2hlICAqKnBrZXlfY2FjaGU7Ci0J
c3RydWN0IGliX2dpZF90YWJsZSAgICoqZ2lkX2NhY2hlOwotCXU4ICAgICAgICAgICAgICAgICAg
ICAgKmxtY19jYWNoZTsKLQllbnVtIGliX3BvcnRfc3RhdGUgICAgICpwb3J0X3N0YXRlX2NhY2hl
OworCXN0cnVjdCBpYl9wb3J0X2NhY2hlICAgKnBvcnRzOwogfTsKIAogc3RydWN0IGliX2RtYV9t
YXBwaW5nX29wcyB7Ci0tIAoyLjcuNAoK
--001a113d2dcedb4ce105455b9436--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
