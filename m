From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH 1/1] IB/core: create struct ib_port_cache
Date: Wed, 4 Jan 2017 15:01:38 +0100
Message-ID: <CAMGffEn7QsNVhDcV10Qwc-U7em3L47eOgc0CS1oRxXSFAfLGkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=f403045e357875ad090545453a38
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--f403045e357875ad090545453a38
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Folks,

This is a follow up for http://www.spinics.net/lists/linux-rdma/msg44536.ht=
ml.
As Jason suggested, I'm moving 4 elments for per port arrays into a seperat=
e
ib_port_cache structure.

Please apply after the first 4 patches.


>From 66e011a67bcae22ed1f5c180b5b40c085ed10fd3 Mon Sep 17 00:00:00 2001
From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Date: Wed, 4 Jan 2017 14:09:05 +0100
Subject: [PATCH 1/1] IB/core: create struct ib_port_cache

As Jason suggested, we have 4 elements for per port arrays,
it's better to have a seperate structure to represent them.

Signed-off-by: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/core/cache.c | 74 ++++++++++++++++++++-----------------=
----
 include/rdma/ib_verbs.h         | 10 ++++--
 2 files changed, 44 insertions(+), 40 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cach=
e.c
index f91886b..740229b 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -314,7 +314,7 @@ static void make_default_gid(struct  net_device
*dev, union ib_gid *gid)
 int ib_cache_gid_add(struct ib_device *ib_dev, u8 port,
              union ib_gid *gid, struct ib_gid_attr *attr)
 {
-    struct ib_gid_table **ports_table =3D ib_dev->cache.gid_cache;
+    struct ib_gid_table **ports_table =3D ib_dev->cache.port_cache.gid_cac=
he;
     struct ib_gid_table *table;
     int ix;
     int ret =3D 0;
@@ -369,7 +369,7 @@ int ib_cache_gid_add(struct ib_device *ib_dev, u8 port,
 int ib_cache_gid_del(struct ib_device *ib_dev, u8 port,
              union ib_gid *gid, struct ib_gid_attr *attr)
 {
-    struct ib_gid_table **ports_table =3D ib_dev->cache.gid_cache;
+    struct ib_gid_table **ports_table =3D ib_dev->cache.port_cache.gid_cac=
he;
     struct ib_gid_table *table;
     int ix;

@@ -399,7 +399,7 @@ int ib_cache_gid_del(struct ib_device *ib_dev, u8 port,
 int ib_cache_gid_del_all_netdev_gids(struct ib_device *ib_dev, u8 port,
                      struct net_device *ndev)
 {
-    struct ib_gid_table **ports_table =3D ib_dev->cache.gid_cache;
+    struct ib_gid_table **ports_table =3D ib_dev->cache.port_cache.gid_cac=
he;
     struct ib_gid_table *table;
     int ix;
     bool deleted =3D false;
@@ -428,7 +428,7 @@ int ib_cache_gid_del_all_netdev_gids(struct
ib_device *ib_dev, u8 port,
 static int __ib_cache_gid_get(struct ib_device *ib_dev, u8 port, int index=
,
                   union ib_gid *gid, struct ib_gid_attr *attr)
 {
-    struct ib_gid_table **ports_table =3D ib_dev->cache.gid_cache;
+    struct ib_gid_table **ports_table =3D ib_dev->cache.port_cache.gid_cac=
he;
     struct ib_gid_table *table;

     table =3D ports_table[port - rdma_start_port(ib_dev)];
@@ -455,7 +455,7 @@ static int _ib_cache_gid_table_find(struct
ib_device *ib_dev,
                     unsigned long mask,
                     u8 *port, u16 *index)
 {
-    struct ib_gid_table **ports_table =3D ib_dev->cache.gid_cache;
+    struct ib_gid_table **ports_table =3D ib_dev->cache.port_cache.gid_cac=
he;
     struct ib_gid_table *table;
     u8 p;
     int local_index;
@@ -503,7 +503,7 @@ int ib_find_cached_gid_by_port(struct ib_device *ib_dev=
,
                    u16 *index)
 {
     int local_index;
-    struct ib_gid_table **ports_table =3D ib_dev->cache.gid_cache;
+    struct ib_gid_table **ports_table =3D ib_dev->cache.port_cache.gid_cac=
he;
     struct ib_gid_table *table;
     unsigned long mask =3D GID_ATTR_FIND_MASK_GID |
                  GID_ATTR_FIND_MASK_GID_TYPE;
@@ -562,7 +562,7 @@ static int ib_cache_gid_find_by_filter(struct
ib_device *ib_dev,
                        void *context,
                        u16 *index)
 {
-    struct ib_gid_table **ports_table =3D ib_dev->cache.gid_cache;
+    struct ib_gid_table **ports_table =3D ib_dev->cache.port_cache.gid_cac=
he;
     struct ib_gid_table *table;
     unsigned int i;
     unsigned long flags;
@@ -668,7 +668,7 @@ void ib_cache_gid_set_default_gid(struct ib_device
*ib_dev, u8 port,
                   unsigned long gid_type_mask,
                   enum ib_cache_gid_default_mode mode)
 {
-    struct ib_gid_table **ports_table =3D ib_dev->cache.gid_cache;
+    struct ib_gid_table **ports_table =3D ib_dev->cache.port_cache.gid_cac=
he;
     union ib_gid gid;
     struct ib_gid_attr gid_attr;
     struct ib_gid_attr zattr_type =3D zattr;
@@ -791,7 +791,7 @@ static int _gid_table_setup_one(struct ib_device *ib_de=
v)
             goto rollback_table_setup;
     }

-    ib_dev->cache.gid_cache =3D table;
+    ib_dev->cache.port_cache.gid_cache =3D table;
     return 0;

 rollback_table_setup:
@@ -807,7 +807,7 @@ static int _gid_table_setup_one(struct ib_device *ib_de=
v)

 static void gid_table_release_one(struct ib_device *ib_dev)
 {
-    struct ib_gid_table **table =3D ib_dev->cache.gid_cache;
+    struct ib_gid_table **table =3D ib_dev->cache.port_cache.gid_cache;
     u8 port;

     if (!table)
@@ -817,12 +817,12 @@ static void gid_table_release_one(struct
ib_device *ib_dev)
         release_gid_table(table[port]);

     kfree(table);
-    ib_dev->cache.gid_cache =3D NULL;
+    ib_dev->cache.port_cache.gid_cache =3D NULL;
 }

 static void gid_table_cleanup_one(struct ib_device *ib_dev)
 {
-    struct ib_gid_table **table =3D ib_dev->cache.gid_cache;
+    struct ib_gid_table **table =3D ib_dev->cache.port_cache.gid_cache;
     u8 port;

     if (!table)
@@ -860,7 +860,7 @@ int ib_get_cached_gid(struct ib_device *device,
 {
     int res;
     unsigned long flags;
-    struct ib_gid_table **ports_table =3D device->cache.gid_cache;
+    struct ib_gid_table **ports_table =3D device->cache.port_cache.gid_cac=
he;
     struct ib_gid_table *table =3D ports_table[port_num -
rdma_start_port(device)];

     if (port_num < rdma_start_port(device) || port_num > rdma_end_port(dev=
ice))
@@ -917,7 +917,7 @@ int ib_get_cached_pkey(struct ib_device *device,

     read_lock_irqsave(&device->cache.lock, flags);

-    cache =3D device->cache.pkey_cache[port_num - rdma_start_port(device)]=
;
+    cache =3D device->cache.port_cache.pkey_cache[port_num -
rdma_start_port(device)];

     if (index < 0 || index >=3D cache->table_len)
         ret =3D -EINVAL;
@@ -946,7 +946,7 @@ int ib_find_cached_pkey(struct ib_device *device,

     read_lock_irqsave(&device->cache.lock, flags);

-    cache =3D device->cache.pkey_cache[port_num - rdma_start_port(device)]=
;
+    cache =3D device->cache.port_cache.pkey_cache[port_num -
rdma_start_port(device)];

     *index =3D -1;

@@ -986,7 +986,7 @@ int ib_find_exact_cached_pkey(struct ib_device *device,

     read_lock_irqsave(&device->cache.lock, flags);

-    cache =3D device->cache.pkey_cache[port_num - rdma_start_port(device)]=
;
+    cache =3D device->cache.port_cache.pkey_cache[port_num -
rdma_start_port(device)];

     *index =3D -1;

@@ -1014,7 +1014,7 @@ int ib_get_cached_lmc(struct ib_device *device,
         return -EINVAL;

     read_lock_irqsave(&device->cache.lock, flags);
-    *lmc =3D device->cache.lmc_cache[port_num - rdma_start_port(device)];
+    *lmc =3D device->cache.port_cache.lmc_cache[port_num -
rdma_start_port(device)];
     read_unlock_irqrestore(&device->cache.lock, flags);

     return ret;
@@ -1032,7 +1032,7 @@ int ib_get_cached_port_state(struct ib_device   *devi=
ce,
         return -EINVAL;

     read_lock_irqsave(&device->cache.lock, flags);
-    *port_state =3D device->cache.port_state_cache[port_num -
rdma_start_port(device)];
+    *port_state =3D device->cache.port_cache.port_state_cache[port_num
- rdma_start_port(device)];
     read_unlock_irqrestore(&device->cache.lock, flags);

     return ret;
@@ -1051,7 +1051,7 @@ static void ib_cache_update(struct ib_device *device,
     int                        i;
     int                        ret;
     struct ib_gid_table      *table;
-    struct ib_gid_table     **ports_table =3D device->cache.gid_cache;
+    struct ib_gid_table     **ports_table =3D device->cache.port_cache.gid=
_cache;
     bool               use_roce_gid_table =3D
                     rdma_cap_roce_gid_table(device, port);

@@ -1110,9 +1110,9 @@ static void ib_cache_update(struct ib_device *device,

     write_lock_irq(&device->cache.lock);

-    old_pkey_cache =3D device->cache.pkey_cache[port - rdma_start_port(dev=
ice)];
+    old_pkey_cache =3D device->cache.port_cache.pkey_cache[port -
rdma_start_port(device)];

-    device->cache.pkey_cache[port - rdma_start_port(device)] =3D pkey_cach=
e;
+    device->cache.port_cache.pkey_cache[port -
rdma_start_port(device)] =3D pkey_cache;
     if (!use_roce_gid_table) {
         write_lock(&table->rwlock);
         for (i =3D 0; i < gid_cache->table_len; i++) {
@@ -1122,8 +1122,8 @@ static void ib_cache_update(struct ib_device *device,
         write_unlock(&table->rwlock);
     }

-    device->cache.lmc_cache[port - rdma_start_port(device)] =3D tprops->lm=
c;
-    device->cache.port_state_cache[port - rdma_start_port(device)] =3D
+    device->cache.port_cache.lmc_cache[port -
rdma_start_port(device)] =3D tprops->lmc;
+    device->cache.port_cache.port_state_cache[port - rdma_start_port(devic=
e)] =3D
         tprops->state;

     write_unlock_irq(&device->cache.lock);
@@ -1177,19 +1177,19 @@ int ib_cache_setup_one(struct ib_device *device)

     rwlock_init(&device->cache.lock);

-    device->cache.pkey_cache =3D
-        kzalloc(sizeof *device->cache.pkey_cache *
+    device->cache.port_cache.pkey_cache =3D
+        kzalloc(sizeof *device->cache.port_cache.pkey_cache *
             (rdma_end_port(device) - rdma_start_port(device) + 1), GFP_KER=
NEL);
-    device->cache.lmc_cache =3D kmalloc(sizeof *device->cache.lmc_cache *
+    device->cache.port_cache.lmc_cache =3D kmalloc(sizeof
*device->cache.port_cache.lmc_cache *
                       (rdma_end_port(device) -
                        rdma_start_port(device) + 1),
                       GFP_KERNEL);
-    device->cache.port_state_cache =3D kmalloc(sizeof
*device->cache.port_state_cache *
+    device->cache.port_cache.port_state_cache =3D kmalloc(sizeof
*device->cache.port_cache.port_state_cache *
                       (rdma_end_port(device) -
                        rdma_start_port(device) + 1),
                       GFP_KERNEL);
-    if (!device->cache.pkey_cache || !device->cache.port_state_cache ||
-        !device->cache.lmc_cache) {
+    if (!device->cache.port_cache.pkey_cache ||
!device->cache.port_cache.port_state_cache ||
+        !device->cache.port_cache.lmc_cache) {
         err =3D -ENOMEM;
         goto free;
     }
@@ -1212,9 +1212,9 @@ int ib_cache_setup_one(struct ib_device *device)
 err:
     gid_table_cleanup_one(device);
 free:
-    kfree(device->cache.pkey_cache);
-    kfree(device->cache.lmc_cache);
-    kfree(device->cache.port_state_cache);
+    kfree(device->cache.port_cache.pkey_cache);
+    kfree(device->cache.port_cache.lmc_cache);
+    kfree(device->cache.port_cache.port_state_cache);
     return err;
 }

@@ -1228,15 +1228,15 @@ void ib_cache_release_one(struct ib_device *device)
      * all the device's resources when the cache could no
      * longer be accessed.
      */
-    if (device->cache.pkey_cache)
+    if (device->cache.port_cache.pkey_cache)
         for (p =3D 0;
              p <=3D rdma_end_port(device) - rdma_start_port(device); ++p)
-            kfree(device->cache.pkey_cache[p]);
+            kfree(device->cache.port_cache.pkey_cache[p]);

     gid_table_release_one(device);
-    kfree(device->cache.pkey_cache);
-    kfree(device->cache.lmc_cache);
-    kfree(device->cache.port_state_cache);
+    kfree(device->cache.port_cache.pkey_cache);
+    kfree(device->cache.port_cache.lmc_cache);
+    kfree(device->cache.port_cache.port_state_cache);
 }

 void ib_cache_cleanup_one(struct ib_device *device)
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index fafa988..4443770 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1775,15 +1775,19 @@ enum ib_mad_result {

 #define IB_DEVICE_NAME_MAX 64

-struct ib_cache {
-    rwlock_t                lock;
-    struct ib_event_handler event_handler;
+struct ib_port_cache {
     struct ib_pkey_cache  **pkey_cache;
     struct ib_gid_table   **gid_cache;
     u8                     *lmc_cache;
     enum ib_port_state     *port_state_cache;
 };

+struct ib_cache {
+    rwlock_t                lock;
+    struct ib_event_handler event_handler;
+    struct ib_port_cache    port_cache;
+};
+
 struct ib_dma_mapping_ops {
     int        (*mapping_error)(struct ib_device *dev,
                      u64 dma_addr);
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

--f403045e357875ad090545453a38
Content-Type: text/x-patch; charset=US-ASCII;
	name="0005-IB-core-create-struct-ib_port_cache.patch"
Content-Disposition: attachment;
	filename="0005-IB-core-create-struct-ib_port_cache.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ixj0dhx20

RnJvbSA2NmUwMTFhNjdiY2FlMjJlZDFmNWMxODBiNWI0MGMwODVlZDEwZmQzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKYWNrIFdhbmcgPGppbnB1LndhbmdAcHJvZml0YnJpY2tzLmNv
bT4KRGF0ZTogV2VkLCA0IEphbiAyMDE3IDE0OjA5OjA1ICswMTAwClN1YmplY3Q6IFtQQVRDSCA1
LzVdIElCL2NvcmU6IGNyZWF0ZSBzdHJ1Y3QgaWJfcG9ydF9jYWNoZQoKQXMgSmFzb24gc3VnZ2Vz
dGVkLCB3ZSBoYXZlIDQgZWxlbWVudHMgZm9yIHBlciBwb3J0IGFycmF5cywKaXQncyBiZXR0ZXIg
dG8gaGF2ZSBhIHNlcGVyYXRlIHN0cnVjdHVyZSB0byByZXByZXNlbnQgdGhlbS4KClNpZ25lZC1v
ZmYtYnk6IEphY2sgV2FuZyA8amlucHUud2FuZ0Bwcm9maXRicmlja3MuY29tPgotLS0KIGRyaXZl
cnMvaW5maW5pYmFuZC9jb3JlL2NhY2hlLmMgfCA3NCArKysrKysrKysrKysrKysrKysrKy0tLS0t
LS0tLS0tLS0tLS0tLS0tLQogaW5jbHVkZS9yZG1hL2liX3ZlcmJzLmggICAgICAgICB8IDEwICsr
KystLQogMiBmaWxlcyBjaGFuZ2VkLCA0NCBpbnNlcnRpb25zKCspLCA0MCBkZWxldGlvbnMoLSkK
CmRpZmYgLS1naXQgYS9kcml2ZXJzL2luZmluaWJhbmQvY29yZS9jYWNoZS5jIGIvZHJpdmVycy9p
bmZpbmliYW5kL2NvcmUvY2FjaGUuYwppbmRleCBmOTE4ODZiLi43NDAyMjliIDEwMDY0NAotLS0g
YS9kcml2ZXJzL2luZmluaWJhbmQvY29yZS9jYWNoZS5jCisrKyBiL2RyaXZlcnMvaW5maW5pYmFu
ZC9jb3JlL2NhY2hlLmMKQEAgLTMxNCw3ICszMTQsNyBAQCBzdGF0aWMgdm9pZCBtYWtlX2RlZmF1
bHRfZ2lkKHN0cnVjdCAgbmV0X2RldmljZSAqZGV2LCB1bmlvbiBpYl9naWQgKmdpZCkKIGludCBp
Yl9jYWNoZV9naWRfYWRkKHN0cnVjdCBpYl9kZXZpY2UgKmliX2RldiwgdTggcG9ydCwKIAkJICAg
ICB1bmlvbiBpYl9naWQgKmdpZCwgc3RydWN0IGliX2dpZF9hdHRyICphdHRyKQogewotCXN0cnVj
dCBpYl9naWRfdGFibGUgKipwb3J0c190YWJsZSA9IGliX2Rldi0+Y2FjaGUuZ2lkX2NhY2hlOwor
CXN0cnVjdCBpYl9naWRfdGFibGUgKipwb3J0c190YWJsZSA9IGliX2Rldi0+Y2FjaGUucG9ydF9j
YWNoZS5naWRfY2FjaGU7CiAJc3RydWN0IGliX2dpZF90YWJsZSAqdGFibGU7CiAJaW50IGl4Owog
CWludCByZXQgPSAwOwpAQCAtMzY5LDcgKzM2OSw3IEBAIGludCBpYl9jYWNoZV9naWRfYWRkKHN0
cnVjdCBpYl9kZXZpY2UgKmliX2RldiwgdTggcG9ydCwKIGludCBpYl9jYWNoZV9naWRfZGVsKHN0
cnVjdCBpYl9kZXZpY2UgKmliX2RldiwgdTggcG9ydCwKIAkJICAgICB1bmlvbiBpYl9naWQgKmdp
ZCwgc3RydWN0IGliX2dpZF9hdHRyICphdHRyKQogewotCXN0cnVjdCBpYl9naWRfdGFibGUgKipw
b3J0c190YWJsZSA9IGliX2Rldi0+Y2FjaGUuZ2lkX2NhY2hlOworCXN0cnVjdCBpYl9naWRfdGFi
bGUgKipwb3J0c190YWJsZSA9IGliX2Rldi0+Y2FjaGUucG9ydF9jYWNoZS5naWRfY2FjaGU7CiAJ
c3RydWN0IGliX2dpZF90YWJsZSAqdGFibGU7CiAJaW50IGl4OwogCkBAIC0zOTksNyArMzk5LDcg
QEAgaW50IGliX2NhY2hlX2dpZF9kZWwoc3RydWN0IGliX2RldmljZSAqaWJfZGV2LCB1OCBwb3J0
LAogaW50IGliX2NhY2hlX2dpZF9kZWxfYWxsX25ldGRldl9naWRzKHN0cnVjdCBpYl9kZXZpY2Ug
KmliX2RldiwgdTggcG9ydCwKIAkJCQkgICAgIHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2KQogewot
CXN0cnVjdCBpYl9naWRfdGFibGUgKipwb3J0c190YWJsZSA9IGliX2Rldi0+Y2FjaGUuZ2lkX2Nh
Y2hlOworCXN0cnVjdCBpYl9naWRfdGFibGUgKipwb3J0c190YWJsZSA9IGliX2Rldi0+Y2FjaGUu
cG9ydF9jYWNoZS5naWRfY2FjaGU7CiAJc3RydWN0IGliX2dpZF90YWJsZSAqdGFibGU7CiAJaW50
IGl4OwogCWJvb2wgZGVsZXRlZCA9IGZhbHNlOwpAQCAtNDI4LDcgKzQyOCw3IEBAIGludCBpYl9j
YWNoZV9naWRfZGVsX2FsbF9uZXRkZXZfZ2lkcyhzdHJ1Y3QgaWJfZGV2aWNlICppYl9kZXYsIHU4
IHBvcnQsCiBzdGF0aWMgaW50IF9faWJfY2FjaGVfZ2lkX2dldChzdHJ1Y3QgaWJfZGV2aWNlICpp
Yl9kZXYsIHU4IHBvcnQsIGludCBpbmRleCwKIAkJCSAgICAgIHVuaW9uIGliX2dpZCAqZ2lkLCBz
dHJ1Y3QgaWJfZ2lkX2F0dHIgKmF0dHIpCiB7Ci0Jc3RydWN0IGliX2dpZF90YWJsZSAqKnBvcnRz
X3RhYmxlID0gaWJfZGV2LT5jYWNoZS5naWRfY2FjaGU7CisJc3RydWN0IGliX2dpZF90YWJsZSAq
KnBvcnRzX3RhYmxlID0gaWJfZGV2LT5jYWNoZS5wb3J0X2NhY2hlLmdpZF9jYWNoZTsKIAlzdHJ1
Y3QgaWJfZ2lkX3RhYmxlICp0YWJsZTsKIAogCXRhYmxlID0gcG9ydHNfdGFibGVbcG9ydCAtIHJk
bWFfc3RhcnRfcG9ydChpYl9kZXYpXTsKQEAgLTQ1NSw3ICs0NTUsNyBAQCBzdGF0aWMgaW50IF9p
Yl9jYWNoZV9naWRfdGFibGVfZmluZChzdHJ1Y3QgaWJfZGV2aWNlICppYl9kZXYsCiAJCQkJICAg
IHVuc2lnbmVkIGxvbmcgbWFzaywKIAkJCQkgICAgdTggKnBvcnQsIHUxNiAqaW5kZXgpCiB7Ci0J
c3RydWN0IGliX2dpZF90YWJsZSAqKnBvcnRzX3RhYmxlID0gaWJfZGV2LT5jYWNoZS5naWRfY2Fj
aGU7CisJc3RydWN0IGliX2dpZF90YWJsZSAqKnBvcnRzX3RhYmxlID0gaWJfZGV2LT5jYWNoZS5w
b3J0X2NhY2hlLmdpZF9jYWNoZTsKIAlzdHJ1Y3QgaWJfZ2lkX3RhYmxlICp0YWJsZTsKIAl1OCBw
OwogCWludCBsb2NhbF9pbmRleDsKQEAgLTUwMyw3ICs1MDMsNyBAQCBpbnQgaWJfZmluZF9jYWNo
ZWRfZ2lkX2J5X3BvcnQoc3RydWN0IGliX2RldmljZSAqaWJfZGV2LAogCQkJICAgICAgIHUxNiAq
aW5kZXgpCiB7CiAJaW50IGxvY2FsX2luZGV4OwotCXN0cnVjdCBpYl9naWRfdGFibGUgKipwb3J0
c190YWJsZSA9IGliX2Rldi0+Y2FjaGUuZ2lkX2NhY2hlOworCXN0cnVjdCBpYl9naWRfdGFibGUg
Kipwb3J0c190YWJsZSA9IGliX2Rldi0+Y2FjaGUucG9ydF9jYWNoZS5naWRfY2FjaGU7CiAJc3Ry
dWN0IGliX2dpZF90YWJsZSAqdGFibGU7CiAJdW5zaWduZWQgbG9uZyBtYXNrID0gR0lEX0FUVFJf
RklORF9NQVNLX0dJRCB8CiAJCQkgICAgIEdJRF9BVFRSX0ZJTkRfTUFTS19HSURfVFlQRTsKQEAg
LTU2Miw3ICs1NjIsNyBAQCBzdGF0aWMgaW50IGliX2NhY2hlX2dpZF9maW5kX2J5X2ZpbHRlcihz
dHJ1Y3QgaWJfZGV2aWNlICppYl9kZXYsCiAJCQkJICAgICAgIHZvaWQgKmNvbnRleHQsCiAJCQkJ
ICAgICAgIHUxNiAqaW5kZXgpCiB7Ci0Jc3RydWN0IGliX2dpZF90YWJsZSAqKnBvcnRzX3RhYmxl
ID0gaWJfZGV2LT5jYWNoZS5naWRfY2FjaGU7CisJc3RydWN0IGliX2dpZF90YWJsZSAqKnBvcnRz
X3RhYmxlID0gaWJfZGV2LT5jYWNoZS5wb3J0X2NhY2hlLmdpZF9jYWNoZTsKIAlzdHJ1Y3QgaWJf
Z2lkX3RhYmxlICp0YWJsZTsKIAl1bnNpZ25lZCBpbnQgaTsKIAl1bnNpZ25lZCBsb25nIGZsYWdz
OwpAQCAtNjY4LDcgKzY2OCw3IEBAIHZvaWQgaWJfY2FjaGVfZ2lkX3NldF9kZWZhdWx0X2dpZChz
dHJ1Y3QgaWJfZGV2aWNlICppYl9kZXYsIHU4IHBvcnQsCiAJCQkJICB1bnNpZ25lZCBsb25nIGdp
ZF90eXBlX21hc2ssCiAJCQkJICBlbnVtIGliX2NhY2hlX2dpZF9kZWZhdWx0X21vZGUgbW9kZSkK
IHsKLQlzdHJ1Y3QgaWJfZ2lkX3RhYmxlICoqcG9ydHNfdGFibGUgPSBpYl9kZXYtPmNhY2hlLmdp
ZF9jYWNoZTsKKwlzdHJ1Y3QgaWJfZ2lkX3RhYmxlICoqcG9ydHNfdGFibGUgPSBpYl9kZXYtPmNh
Y2hlLnBvcnRfY2FjaGUuZ2lkX2NhY2hlOwogCXVuaW9uIGliX2dpZCBnaWQ7CiAJc3RydWN0IGli
X2dpZF9hdHRyIGdpZF9hdHRyOwogCXN0cnVjdCBpYl9naWRfYXR0ciB6YXR0cl90eXBlID0gemF0
dHI7CkBAIC03OTEsNyArNzkxLDcgQEAgc3RhdGljIGludCBfZ2lkX3RhYmxlX3NldHVwX29uZShz
dHJ1Y3QgaWJfZGV2aWNlICppYl9kZXYpCiAJCQlnb3RvIHJvbGxiYWNrX3RhYmxlX3NldHVwOwog
CX0KIAotCWliX2Rldi0+Y2FjaGUuZ2lkX2NhY2hlID0gdGFibGU7CisJaWJfZGV2LT5jYWNoZS5w
b3J0X2NhY2hlLmdpZF9jYWNoZSA9IHRhYmxlOwogCXJldHVybiAwOwogCiByb2xsYmFja190YWJs
ZV9zZXR1cDoKQEAgLTgwNyw3ICs4MDcsNyBAQCBzdGF0aWMgaW50IF9naWRfdGFibGVfc2V0dXBf
b25lKHN0cnVjdCBpYl9kZXZpY2UgKmliX2RldikKIAogc3RhdGljIHZvaWQgZ2lkX3RhYmxlX3Jl
bGVhc2Vfb25lKHN0cnVjdCBpYl9kZXZpY2UgKmliX2RldikKIHsKLQlzdHJ1Y3QgaWJfZ2lkX3Rh
YmxlICoqdGFibGUgPSBpYl9kZXYtPmNhY2hlLmdpZF9jYWNoZTsKKwlzdHJ1Y3QgaWJfZ2lkX3Rh
YmxlICoqdGFibGUgPSBpYl9kZXYtPmNhY2hlLnBvcnRfY2FjaGUuZ2lkX2NhY2hlOwogCXU4IHBv
cnQ7CiAKIAlpZiAoIXRhYmxlKQpAQCAtODE3LDEyICs4MTcsMTIgQEAgc3RhdGljIHZvaWQgZ2lk
X3RhYmxlX3JlbGVhc2Vfb25lKHN0cnVjdCBpYl9kZXZpY2UgKmliX2RldikKIAkJcmVsZWFzZV9n
aWRfdGFibGUodGFibGVbcG9ydF0pOwogCiAJa2ZyZWUodGFibGUpOwotCWliX2Rldi0+Y2FjaGUu
Z2lkX2NhY2hlID0gTlVMTDsKKwlpYl9kZXYtPmNhY2hlLnBvcnRfY2FjaGUuZ2lkX2NhY2hlID0g
TlVMTDsKIH0KIAogc3RhdGljIHZvaWQgZ2lkX3RhYmxlX2NsZWFudXBfb25lKHN0cnVjdCBpYl9k
ZXZpY2UgKmliX2RldikKIHsKLQlzdHJ1Y3QgaWJfZ2lkX3RhYmxlICoqdGFibGUgPSBpYl9kZXYt
PmNhY2hlLmdpZF9jYWNoZTsKKwlzdHJ1Y3QgaWJfZ2lkX3RhYmxlICoqdGFibGUgPSBpYl9kZXYt
PmNhY2hlLnBvcnRfY2FjaGUuZ2lkX2NhY2hlOwogCXU4IHBvcnQ7CiAKIAlpZiAoIXRhYmxlKQpA
QCAtODYwLDcgKzg2MCw3IEBAIGludCBpYl9nZXRfY2FjaGVkX2dpZChzdHJ1Y3QgaWJfZGV2aWNl
ICpkZXZpY2UsCiB7CiAJaW50IHJlczsKIAl1bnNpZ25lZCBsb25nIGZsYWdzOwotCXN0cnVjdCBp
Yl9naWRfdGFibGUgKipwb3J0c190YWJsZSA9IGRldmljZS0+Y2FjaGUuZ2lkX2NhY2hlOworCXN0
cnVjdCBpYl9naWRfdGFibGUgKipwb3J0c190YWJsZSA9IGRldmljZS0+Y2FjaGUucG9ydF9jYWNo
ZS5naWRfY2FjaGU7CiAJc3RydWN0IGliX2dpZF90YWJsZSAqdGFibGUgPSBwb3J0c190YWJsZVtw
b3J0X251bSAtIHJkbWFfc3RhcnRfcG9ydChkZXZpY2UpXTsKIAogCWlmIChwb3J0X251bSA8IHJk
bWFfc3RhcnRfcG9ydChkZXZpY2UpIHx8IHBvcnRfbnVtID4gcmRtYV9lbmRfcG9ydChkZXZpY2Up
KQpAQCAtOTE3LDcgKzkxNyw3IEBAIGludCBpYl9nZXRfY2FjaGVkX3BrZXkoc3RydWN0IGliX2Rl
dmljZSAqZGV2aWNlLAogCiAJcmVhZF9sb2NrX2lycXNhdmUoJmRldmljZS0+Y2FjaGUubG9jaywg
ZmxhZ3MpOwogCi0JY2FjaGUgPSBkZXZpY2UtPmNhY2hlLnBrZXlfY2FjaGVbcG9ydF9udW0gLSBy
ZG1hX3N0YXJ0X3BvcnQoZGV2aWNlKV07CisJY2FjaGUgPSBkZXZpY2UtPmNhY2hlLnBvcnRfY2Fj
aGUucGtleV9jYWNoZVtwb3J0X251bSAtIHJkbWFfc3RhcnRfcG9ydChkZXZpY2UpXTsKIAogCWlm
IChpbmRleCA8IDAgfHwgaW5kZXggPj0gY2FjaGUtPnRhYmxlX2xlbikKIAkJcmV0ID0gLUVJTlZB
TDsKQEAgLTk0Niw3ICs5NDYsNyBAQCBpbnQgaWJfZmluZF9jYWNoZWRfcGtleShzdHJ1Y3QgaWJf
ZGV2aWNlICpkZXZpY2UsCiAKIAlyZWFkX2xvY2tfaXJxc2F2ZSgmZGV2aWNlLT5jYWNoZS5sb2Nr
LCBmbGFncyk7CiAKLQljYWNoZSA9IGRldmljZS0+Y2FjaGUucGtleV9jYWNoZVtwb3J0X251bSAt
IHJkbWFfc3RhcnRfcG9ydChkZXZpY2UpXTsKKwljYWNoZSA9IGRldmljZS0+Y2FjaGUucG9ydF9j
YWNoZS5wa2V5X2NhY2hlW3BvcnRfbnVtIC0gcmRtYV9zdGFydF9wb3J0KGRldmljZSldOwogCiAJ
KmluZGV4ID0gLTE7CiAKQEAgLTk4Niw3ICs5ODYsNyBAQCBpbnQgaWJfZmluZF9leGFjdF9jYWNo
ZWRfcGtleShzdHJ1Y3QgaWJfZGV2aWNlICpkZXZpY2UsCiAKIAlyZWFkX2xvY2tfaXJxc2F2ZSgm
ZGV2aWNlLT5jYWNoZS5sb2NrLCBmbGFncyk7CiAKLQljYWNoZSA9IGRldmljZS0+Y2FjaGUucGtl
eV9jYWNoZVtwb3J0X251bSAtIHJkbWFfc3RhcnRfcG9ydChkZXZpY2UpXTsKKwljYWNoZSA9IGRl
dmljZS0+Y2FjaGUucG9ydF9jYWNoZS5wa2V5X2NhY2hlW3BvcnRfbnVtIC0gcmRtYV9zdGFydF9w
b3J0KGRldmljZSldOwogCiAJKmluZGV4ID0gLTE7CiAKQEAgLTEwMTQsNyArMTAxNCw3IEBAIGlu
dCBpYl9nZXRfY2FjaGVkX2xtYyhzdHJ1Y3QgaWJfZGV2aWNlICpkZXZpY2UsCiAJCXJldHVybiAt
RUlOVkFMOwogCiAJcmVhZF9sb2NrX2lycXNhdmUoJmRldmljZS0+Y2FjaGUubG9jaywgZmxhZ3Mp
OwotCSpsbWMgPSBkZXZpY2UtPmNhY2hlLmxtY19jYWNoZVtwb3J0X251bSAtIHJkbWFfc3RhcnRf
cG9ydChkZXZpY2UpXTsKKwkqbG1jID0gZGV2aWNlLT5jYWNoZS5wb3J0X2NhY2hlLmxtY19jYWNo
ZVtwb3J0X251bSAtIHJkbWFfc3RhcnRfcG9ydChkZXZpY2UpXTsKIAlyZWFkX3VubG9ja19pcnFy
ZXN0b3JlKCZkZXZpY2UtPmNhY2hlLmxvY2ssIGZsYWdzKTsKIAogCXJldHVybiByZXQ7CkBAIC0x
MDMyLDcgKzEwMzIsNyBAQCBpbnQgaWJfZ2V0X2NhY2hlZF9wb3J0X3N0YXRlKHN0cnVjdCBpYl9k
ZXZpY2UgICAqZGV2aWNlLAogCQlyZXR1cm4gLUVJTlZBTDsKIAogCXJlYWRfbG9ja19pcnFzYXZl
KCZkZXZpY2UtPmNhY2hlLmxvY2ssIGZsYWdzKTsKLQkqcG9ydF9zdGF0ZSA9IGRldmljZS0+Y2Fj
aGUucG9ydF9zdGF0ZV9jYWNoZVtwb3J0X251bSAtIHJkbWFfc3RhcnRfcG9ydChkZXZpY2UpXTsK
KwkqcG9ydF9zdGF0ZSA9IGRldmljZS0+Y2FjaGUucG9ydF9jYWNoZS5wb3J0X3N0YXRlX2NhY2hl
W3BvcnRfbnVtIC0gcmRtYV9zdGFydF9wb3J0KGRldmljZSldOwogCXJlYWRfdW5sb2NrX2lycXJl
c3RvcmUoJmRldmljZS0+Y2FjaGUubG9jaywgZmxhZ3MpOwogCiAJcmV0dXJuIHJldDsKQEAgLTEw
NTEsNyArMTA1MSw3IEBAIHN0YXRpYyB2b2lkIGliX2NhY2hlX3VwZGF0ZShzdHJ1Y3QgaWJfZGV2
aWNlICpkZXZpY2UsCiAJaW50ICAgICAgICAgICAgICAgICAgICAgICAgaTsKIAlpbnQgICAgICAg
ICAgICAgICAgICAgICAgICByZXQ7CiAJc3RydWN0IGliX2dpZF90YWJsZQkgICp0YWJsZTsKLQlz
dHJ1Y3QgaWJfZ2lkX3RhYmxlCSAqKnBvcnRzX3RhYmxlID0gZGV2aWNlLT5jYWNoZS5naWRfY2Fj
aGU7CisJc3RydWN0IGliX2dpZF90YWJsZQkgKipwb3J0c190YWJsZSA9IGRldmljZS0+Y2FjaGUu
cG9ydF9jYWNoZS5naWRfY2FjaGU7CiAJYm9vbAkJCSAgIHVzZV9yb2NlX2dpZF90YWJsZSA9CiAJ
CQkJCXJkbWFfY2FwX3JvY2VfZ2lkX3RhYmxlKGRldmljZSwgcG9ydCk7CiAKQEAgLTExMTAsOSAr
MTExMCw5IEBAIHN0YXRpYyB2b2lkIGliX2NhY2hlX3VwZGF0ZShzdHJ1Y3QgaWJfZGV2aWNlICpk
ZXZpY2UsCiAKIAl3cml0ZV9sb2NrX2lycSgmZGV2aWNlLT5jYWNoZS5sb2NrKTsKIAotCW9sZF9w
a2V5X2NhY2hlID0gZGV2aWNlLT5jYWNoZS5wa2V5X2NhY2hlW3BvcnQgLSByZG1hX3N0YXJ0X3Bv
cnQoZGV2aWNlKV07CisJb2xkX3BrZXlfY2FjaGUgPSBkZXZpY2UtPmNhY2hlLnBvcnRfY2FjaGUu
cGtleV9jYWNoZVtwb3J0IC0gcmRtYV9zdGFydF9wb3J0KGRldmljZSldOwogCi0JZGV2aWNlLT5j
YWNoZS5wa2V5X2NhY2hlW3BvcnQgLSByZG1hX3N0YXJ0X3BvcnQoZGV2aWNlKV0gPSBwa2V5X2Nh
Y2hlOworCWRldmljZS0+Y2FjaGUucG9ydF9jYWNoZS5wa2V5X2NhY2hlW3BvcnQgLSByZG1hX3N0
YXJ0X3BvcnQoZGV2aWNlKV0gPSBwa2V5X2NhY2hlOwogCWlmICghdXNlX3JvY2VfZ2lkX3RhYmxl
KSB7CiAJCXdyaXRlX2xvY2soJnRhYmxlLT5yd2xvY2spOwogCQlmb3IgKGkgPSAwOyBpIDwgZ2lk
X2NhY2hlLT50YWJsZV9sZW47IGkrKykgewpAQCAtMTEyMiw4ICsxMTIyLDggQEAgc3RhdGljIHZv
aWQgaWJfY2FjaGVfdXBkYXRlKHN0cnVjdCBpYl9kZXZpY2UgKmRldmljZSwKIAkJd3JpdGVfdW5s
b2NrKCZ0YWJsZS0+cndsb2NrKTsKIAl9CiAKLQlkZXZpY2UtPmNhY2hlLmxtY19jYWNoZVtwb3J0
IC0gcmRtYV9zdGFydF9wb3J0KGRldmljZSldID0gdHByb3BzLT5sbWM7Ci0JZGV2aWNlLT5jYWNo
ZS5wb3J0X3N0YXRlX2NhY2hlW3BvcnQgLSByZG1hX3N0YXJ0X3BvcnQoZGV2aWNlKV0gPQorCWRl
dmljZS0+Y2FjaGUucG9ydF9jYWNoZS5sbWNfY2FjaGVbcG9ydCAtIHJkbWFfc3RhcnRfcG9ydChk
ZXZpY2UpXSA9IHRwcm9wcy0+bG1jOworCWRldmljZS0+Y2FjaGUucG9ydF9jYWNoZS5wb3J0X3N0
YXRlX2NhY2hlW3BvcnQgLSByZG1hX3N0YXJ0X3BvcnQoZGV2aWNlKV0gPQogCQl0cHJvcHMtPnN0
YXRlOwogCiAJd3JpdGVfdW5sb2NrX2lycSgmZGV2aWNlLT5jYWNoZS5sb2NrKTsKQEAgLTExNzcs
MTkgKzExNzcsMTkgQEAgaW50IGliX2NhY2hlX3NldHVwX29uZShzdHJ1Y3QgaWJfZGV2aWNlICpk
ZXZpY2UpCiAKIAlyd2xvY2tfaW5pdCgmZGV2aWNlLT5jYWNoZS5sb2NrKTsKIAotCWRldmljZS0+
Y2FjaGUucGtleV9jYWNoZSA9Ci0JCWt6YWxsb2Moc2l6ZW9mICpkZXZpY2UtPmNhY2hlLnBrZXlf
Y2FjaGUgKgorCWRldmljZS0+Y2FjaGUucG9ydF9jYWNoZS5wa2V5X2NhY2hlID0KKwkJa3phbGxv
YyhzaXplb2YgKmRldmljZS0+Y2FjaGUucG9ydF9jYWNoZS5wa2V5X2NhY2hlICoKIAkJCShyZG1h
X2VuZF9wb3J0KGRldmljZSkgLSByZG1hX3N0YXJ0X3BvcnQoZGV2aWNlKSArIDEpLCBHRlBfS0VS
TkVMKTsKLQlkZXZpY2UtPmNhY2hlLmxtY19jYWNoZSA9IGttYWxsb2Moc2l6ZW9mICpkZXZpY2Ut
PmNhY2hlLmxtY19jYWNoZSAqCisJZGV2aWNlLT5jYWNoZS5wb3J0X2NhY2hlLmxtY19jYWNoZSA9
IGttYWxsb2Moc2l6ZW9mICpkZXZpY2UtPmNhY2hlLnBvcnRfY2FjaGUubG1jX2NhY2hlICoKIAkJ
CQkJICAocmRtYV9lbmRfcG9ydChkZXZpY2UpIC0KIAkJCQkJICAgcmRtYV9zdGFydF9wb3J0KGRl
dmljZSkgKyAxKSwKIAkJCQkJICBHRlBfS0VSTkVMKTsKLQlkZXZpY2UtPmNhY2hlLnBvcnRfc3Rh
dGVfY2FjaGUgPSBrbWFsbG9jKHNpemVvZiAqZGV2aWNlLT5jYWNoZS5wb3J0X3N0YXRlX2NhY2hl
ICoKKwlkZXZpY2UtPmNhY2hlLnBvcnRfY2FjaGUucG9ydF9zdGF0ZV9jYWNoZSA9IGttYWxsb2Mo
c2l6ZW9mICpkZXZpY2UtPmNhY2hlLnBvcnRfY2FjaGUucG9ydF9zdGF0ZV9jYWNoZSAqCiAJCQkJ
CSAgKHJkbWFfZW5kX3BvcnQoZGV2aWNlKSAtCiAJCQkJCSAgIHJkbWFfc3RhcnRfcG9ydChkZXZp
Y2UpICsgMSksCiAJCQkJCSAgR0ZQX0tFUk5FTCk7Ci0JaWYgKCFkZXZpY2UtPmNhY2hlLnBrZXlf
Y2FjaGUgfHwgIWRldmljZS0+Y2FjaGUucG9ydF9zdGF0ZV9jYWNoZSB8fAotCSAgICAhZGV2aWNl
LT5jYWNoZS5sbWNfY2FjaGUpIHsKKwlpZiAoIWRldmljZS0+Y2FjaGUucG9ydF9jYWNoZS5wa2V5
X2NhY2hlIHx8ICFkZXZpY2UtPmNhY2hlLnBvcnRfY2FjaGUucG9ydF9zdGF0ZV9jYWNoZSB8fAor
CSAgICAhZGV2aWNlLT5jYWNoZS5wb3J0X2NhY2hlLmxtY19jYWNoZSkgewogCQllcnIgPSAtRU5P
TUVNOwogCQlnb3RvIGZyZWU7CiAJfQpAQCAtMTIxMiw5ICsxMjEyLDkgQEAgaW50IGliX2NhY2hl
X3NldHVwX29uZShzdHJ1Y3QgaWJfZGV2aWNlICpkZXZpY2UpCiBlcnI6CiAJZ2lkX3RhYmxlX2Ns
ZWFudXBfb25lKGRldmljZSk7CiBmcmVlOgotCWtmcmVlKGRldmljZS0+Y2FjaGUucGtleV9jYWNo
ZSk7Ci0Ja2ZyZWUoZGV2aWNlLT5jYWNoZS5sbWNfY2FjaGUpOwotCWtmcmVlKGRldmljZS0+Y2Fj
aGUucG9ydF9zdGF0ZV9jYWNoZSk7CisJa2ZyZWUoZGV2aWNlLT5jYWNoZS5wb3J0X2NhY2hlLnBr
ZXlfY2FjaGUpOworCWtmcmVlKGRldmljZS0+Y2FjaGUucG9ydF9jYWNoZS5sbWNfY2FjaGUpOwor
CWtmcmVlKGRldmljZS0+Y2FjaGUucG9ydF9jYWNoZS5wb3J0X3N0YXRlX2NhY2hlKTsKIAlyZXR1
cm4gZXJyOwogfQogCkBAIC0xMjI4LDE1ICsxMjI4LDE1IEBAIHZvaWQgaWJfY2FjaGVfcmVsZWFz
ZV9vbmUoc3RydWN0IGliX2RldmljZSAqZGV2aWNlKQogCSAqIGFsbCB0aGUgZGV2aWNlJ3MgcmVz
b3VyY2VzIHdoZW4gdGhlIGNhY2hlIGNvdWxkIG5vCiAJICogbG9uZ2VyIGJlIGFjY2Vzc2VkLgog
CSAqLwotCWlmIChkZXZpY2UtPmNhY2hlLnBrZXlfY2FjaGUpCisJaWYgKGRldmljZS0+Y2FjaGUu
cG9ydF9jYWNoZS5wa2V5X2NhY2hlKQogCQlmb3IgKHAgPSAwOwogCQkgICAgIHAgPD0gcmRtYV9l
bmRfcG9ydChkZXZpY2UpIC0gcmRtYV9zdGFydF9wb3J0KGRldmljZSk7ICsrcCkKLQkJCWtmcmVl
KGRldmljZS0+Y2FjaGUucGtleV9jYWNoZVtwXSk7CisJCQlrZnJlZShkZXZpY2UtPmNhY2hlLnBv
cnRfY2FjaGUucGtleV9jYWNoZVtwXSk7CiAKIAlnaWRfdGFibGVfcmVsZWFzZV9vbmUoZGV2aWNl
KTsKLQlrZnJlZShkZXZpY2UtPmNhY2hlLnBrZXlfY2FjaGUpOwotCWtmcmVlKGRldmljZS0+Y2Fj
aGUubG1jX2NhY2hlKTsKLQlrZnJlZShkZXZpY2UtPmNhY2hlLnBvcnRfc3RhdGVfY2FjaGUpOwor
CWtmcmVlKGRldmljZS0+Y2FjaGUucG9ydF9jYWNoZS5wa2V5X2NhY2hlKTsKKwlrZnJlZShkZXZp
Y2UtPmNhY2hlLnBvcnRfY2FjaGUubG1jX2NhY2hlKTsKKwlrZnJlZShkZXZpY2UtPmNhY2hlLnBv
cnRfY2FjaGUucG9ydF9zdGF0ZV9jYWNoZSk7CiB9CiAKIHZvaWQgaWJfY2FjaGVfY2xlYW51cF9v
bmUoc3RydWN0IGliX2RldmljZSAqZGV2aWNlKQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9yZG1hL2li
X3ZlcmJzLmggYi9pbmNsdWRlL3JkbWEvaWJfdmVyYnMuaAppbmRleCBmYWZhOTg4Li40NDQzNzcw
IDEwMDY0NAotLS0gYS9pbmNsdWRlL3JkbWEvaWJfdmVyYnMuaAorKysgYi9pbmNsdWRlL3JkbWEv
aWJfdmVyYnMuaApAQCAtMTc3NSwxNSArMTc3NSwxOSBAQCBlbnVtIGliX21hZF9yZXN1bHQgewog
CiAjZGVmaW5lIElCX0RFVklDRV9OQU1FX01BWCA2NAogCi1zdHJ1Y3QgaWJfY2FjaGUgewotCXJ3
bG9ja190ICAgICAgICAgICAgICAgIGxvY2s7Ci0Jc3RydWN0IGliX2V2ZW50X2hhbmRsZXIgZXZl
bnRfaGFuZGxlcjsKK3N0cnVjdCBpYl9wb3J0X2NhY2hlIHsKIAlzdHJ1Y3QgaWJfcGtleV9jYWNo
ZSAgKipwa2V5X2NhY2hlOwogCXN0cnVjdCBpYl9naWRfdGFibGUgICAqKmdpZF9jYWNoZTsKIAl1
OCAgICAgICAgICAgICAgICAgICAgICpsbWNfY2FjaGU7CiAJZW51bSBpYl9wb3J0X3N0YXRlICAg
ICAqcG9ydF9zdGF0ZV9jYWNoZTsKIH07CiAKK3N0cnVjdCBpYl9jYWNoZSB7CisJcndsb2NrX3Qg
ICAgICAgICAgICAgICAgbG9jazsKKwlzdHJ1Y3QgaWJfZXZlbnRfaGFuZGxlciBldmVudF9oYW5k
bGVyOworCXN0cnVjdCBpYl9wb3J0X2NhY2hlICAgIHBvcnRfY2FjaGU7Cit9OworCiBzdHJ1Y3Qg
aWJfZG1hX21hcHBpbmdfb3BzIHsKIAlpbnQJCSgqbWFwcGluZ19lcnJvcikoc3RydWN0IGliX2Rl
dmljZSAqZGV2LAogCQkJCQkgdTY0IGRtYV9hZGRyKTsKLS0gCjIuNy40Cgo=
--f403045e357875ad090545453a38--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
