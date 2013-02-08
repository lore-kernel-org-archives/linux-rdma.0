From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/6] idr: remove MAX_IDR_MASK and move left MAX_IDR_* into
 idr.c
Date: Fri, 8 Feb 2013 13:01:49 -0800
Message-ID: <20130208210149.GB26660@mtj.dyndns.org>
References: <20130208210050.GA26660@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130208210050.GA26660-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Jean Delvare <khali-PUYAD+kWke1g9hUCZPvPmw@public.gmane.org>, linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

MAX_IDR_MASK is another weirdness in the idr interface.  As idr covers
whole positive integer range, it's defined as 0x7fffffff or INT_MAX.

Its usage in idr_find(), idr_replace() and idr_remove() is bizarre.
They basically mask off the sign bit and operate on the rest, so if
the caller, by accident, passes in a negative number, the sign bit
will be masked off and the remaining part will be used as if that was
the input, which is worse than crashing.

The constant is visible in idr.h and there are several users in the
kernel.

* drivers/i2c/i2c-core.c:i2c_add_numbered_adapter()

  Basically used to test if adap->nr is a negative number which isn't
  -1 and returns -EINVAL if so.  idr_alloc() already has negative
  @start checking (w/ WARN_ON_ONCE), so this can go away.

* drivers/infiniband/core/cm.c:cm_alloc_id()
  drivers/infiniband/hw/mlx4/cm.c:id_map_alloc()

  Used to wrap cyclic @start.  Can be replaced with max(next, 0).
  Note that this type of cyclic allocation using idr is buggy.  These
  are prone to spurious -ENOSPC failure after the first wraparound.

* fs/super.c:get_anon_bdev()

  The ID allocated from ida is masked off before being tested whether
  it's inside valid range.  ida allocated ID can never be a negative
  number and the masking is unnecessary.

Update idr_*() functions to fail with -EINVAL when negative @id is
specified and update other MAX_IDR_MASK users as described above.

This leaves MAX_IDR_MASK without any user, remove it and relocate
other MAX_IDR_* constants to lib/idr.c.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jean Delvare <khali-PUYAD+kWke1g9hUCZPvPmw@public.gmane.org>
Cc: linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
---
 drivers/i2c/i2c-core.c          |    2 --
 drivers/infiniband/core/cm.c    |    2 +-
 drivers/infiniband/hw/mlx4/cm.c |    2 +-
 fs/super.c                      |    2 +-
 include/linux/idr.h             |   10 ----------
 lib/idr.c                       |   24 +++++++++++++++++-------
 6 files changed, 20 insertions(+), 22 deletions(-)

--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -978,8 +978,6 @@ int i2c_add_numbered_adapter(struct i2c_
 
 	if (adap->nr == -1) /* -1 means dynamically assign bus id */
 		return i2c_add_adapter(adap);
-	if (adap->nr & ~MAX_IDR_MASK)
-		return -EINVAL;
 
 	mutex_lock(&core_lock);
 	id = idr_alloc(&i2c_adapter_idr, adap, adap->nr, adap->nr + 1,
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -390,7 +390,7 @@ static int cm_alloc_id(struct cm_id_priv
 
 	id = idr_alloc(&cm.local_id_table, cm_id_priv, next_id, 0, GFP_NOWAIT);
 	if (id >= 0)
-		next_id = ((unsigned) id + 1) & MAX_IDR_MASK;
+		next_id = max(id + 1, 0);
 
 	spin_unlock_irqrestore(&cm.lock, flags);
 	idr_preload_end();
--- a/drivers/infiniband/hw/mlx4/cm.c
+++ b/drivers/infiniband/hw/mlx4/cm.c
@@ -225,7 +225,7 @@ id_map_alloc(struct ib_device *ibdev, in
 
 	ret = idr_alloc(&sriov->pv_id_table, ent, next_id, 0, GFP_NOWAIT);
 	if (ret >= 0) {
-		next_id = ((unsigned)ret + 1) & MAX_IDR_MASK;
+		next_id = max(ret + 1, 0);
 		ent->pv_cm_id = (u32)ret;
 		sl_id_map_add(ibdev, ent);
 		list_add_tail(&ent->list, &sriov->cm_list);
--- a/fs/super.c
+++ b/fs/super.c
@@ -842,7 +842,7 @@ int get_anon_bdev(dev_t *p)
 	else if (error)
 		return -EAGAIN;
 
-	if ((dev & MAX_IDR_MASK) == (1 << MINORBITS)) {
+	if (dev == (1 << MINORBITS)) {
 		spin_lock(&unnamed_dev_lock);
 		ida_remove(&unnamed_dev_ida, dev);
 		if (unnamed_dev_start > dev)
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -38,16 +38,6 @@
 #define IDR_SIZE (1 << IDR_BITS)
 #define IDR_MASK ((1 << IDR_BITS)-1)
 
-#define MAX_IDR_SHIFT (sizeof(int)*8 - 1)
-#define MAX_IDR_BIT (1U << MAX_IDR_SHIFT)
-#define MAX_IDR_MASK (MAX_IDR_BIT - 1)
-
-/* Leave the possibility of an incomplete final layer */
-#define MAX_IDR_LEVEL ((MAX_IDR_SHIFT + IDR_BITS - 1) / IDR_BITS)
-
-/* Number of id_layer structs to leave in free list */
-#define MAX_IDR_FREE (MAX_IDR_LEVEL * 2)
-
 struct idr_layer {
 	unsigned long		bitmap;	/* A zero bit means "space here" */
 	struct idr_layer __rcu	*ary[1<<IDR_BITS];
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -38,6 +38,15 @@
 #include <linux/percpu.h>
 #include <linux/hardirq.h>
 
+#define MAX_IDR_SHIFT		(sizeof(int) * 8 - 1)
+#define MAX_IDR_BIT		(1U << MAX_IDR_SHIFT)
+
+/* Leave the possibility of an incomplete final layer */
+#define MAX_IDR_LEVEL ((MAX_IDR_SHIFT + IDR_BITS - 1) / IDR_BITS)
+
+/* Number of id_layer structs to leave in free list */
+#define MAX_IDR_FREE (MAX_IDR_LEVEL * 2)
+
 static struct kmem_cache *idr_layer_cache;
 static DEFINE_PER_CPU(struct idr_layer *, idr_preload_head);
 static DEFINE_PER_CPU(int, idr_preload_cnt);
@@ -539,8 +548,8 @@ void idr_remove(struct idr *idp, int id)
 	struct idr_layer *p;
 	struct idr_layer *to_free;
 
-	/* Mask off upper bits we don't use for the search. */
-	id &= MAX_IDR_MASK;
+	if (WARN_ON_ONCE(id < 0))
+		return;
 
 	sub_remove(idp, (idp->layers - 1) * IDR_BITS, id);
 	if (idp->top && idp->top->count == 1 && (idp->layers > 1) &&
@@ -647,14 +656,14 @@ void *idr_find(struct idr *idp, int id)
 	int n;
 	struct idr_layer *p;
 
+	if (WARN_ON_ONCE(id < 0))
+		return NULL;
+
 	p = rcu_dereference_raw(idp->top);
 	if (!p)
 		return NULL;
 	n = (p->layer+1) * IDR_BITS;
 
-	/* Mask off upper bits we don't use for the search. */
-	id &= MAX_IDR_MASK;
-
 	if (id > idr_max(p->layer + 1))
 		return NULL;
 	BUG_ON(n == 0);
@@ -796,14 +805,15 @@ void *idr_replace(struct idr *idp, void
 	int n;
 	struct idr_layer *p, *old_p;
 
+	if (WARN_ON_ONCE(id < 0))
+		return ERR_PTR(-EINVAL);
+
 	p = idp->top;
 	if (!p)
 		return ERR_PTR(-EINVAL);
 
 	n = (p->layer+1) * IDR_BITS;
 
-	id &= MAX_IDR_MASK;
-
 	if (id >= (1 << n))
 		return ERR_PTR(-EINVAL);
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
