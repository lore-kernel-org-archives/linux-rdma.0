From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/5] IB/hfi1: Add sysfs interface for affinity setup
Date: Sun, 25 Sep 2016 07:44:23 -0700
Message-ID: <20160925144420.12088.25511.stgit@scvm10.sc.intel.com>
References: <20160925144248.12088.71489.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160925144248.12088.71489.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Some users want more control over which cpu cores are being used by the
driver. For example, users might want to restrict the driver to some
specified subset of the cores so that they can appropriately partition
processes, irq handlers, and work threads.
To allow the user to fine tune system affinity settings new sysfs
attributes are introduced per sdma engine.  This patch adds a new
attribute type for sdma engine and a new cpu_list attribute.
When the user writes a cpu range to the cpu_list attribute the driver
will create an internal cpu->sdma map, which will be used later as a
look-up table to choose an optimal engine for a user requests.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/hfi.h       |    2 
 drivers/infiniband/hw/hfi1/sdma.c      |  310 ++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/hfi1/sdma.h      |    8 +
 drivers/infiniband/hw/hfi1/sysfs.c     |   90 +++++++++
 drivers/infiniband/hw/hfi1/user_sdma.c |    9 -
 5 files changed, 412 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 5711620..59f69fa 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -65,6 +65,7 @@
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
 #include <rdma/ib_hdrs.h>
+#include <linux/rhashtable.h>
 #include <rdma/rdma_vt.h>
 
 #include "chip_registers.h"
@@ -1174,6 +1175,7 @@ struct hfi1_devdata {
 	atomic_t aspm_disabled_cnt;
 
 	struct hfi1_affinity *affinity;
+	struct rhashtable sdma_rht;
 	struct kobject kobj;
 };
 
diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index 0990fba..8cfa960 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -726,6 +726,34 @@ u16 sdma_get_descq_cnt(void)
 }
 
 /**
+ * sdma_engine_get_vl() - return vl for a given sdma engine
+ * @sde: sdma engine
+ *
+ * This function returns the vl mapped to a given engine, or an error if
+ * the mapping can't be found. The mapping fields are protected by RCU.
+ */
+int sdma_engine_get_vl(struct sdma_engine *sde)
+{
+	struct hfi1_devdata *dd = sde->dd;
+	struct sdma_vl_map *m;
+	u8 vl;
+
+	if (sde->this_idx >= TXE_NUM_SDMA_ENGINES)
+		return -EINVAL;
+
+	rcu_read_lock();
+	m = rcu_dereference(dd->sdma_map);
+	if (unlikely(!m)) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+	vl = m->engine_to_vl[sde->this_idx];
+	rcu_read_unlock();
+
+	return vl;
+}
+
+/**
  * sdma_select_engine_vl() - select sdma engine
  * @dd: devdata
  * @selector: a spreading factor
@@ -788,6 +816,283 @@ struct sdma_engine *sdma_select_engine_sc(
 	return sdma_select_engine_vl(dd, selector, vl);
 }
 
+struct sdma_rht_map_elem {
+	u32 mask;
+	u8 ctr;
+	struct sdma_engine *sde[0];
+};
+
+struct sdma_rht_node {
+	unsigned long cpu_id;
+	struct sdma_rht_map_elem *map[HFI1_MAX_VLS_SUPPORTED];
+	struct rhash_head node;
+};
+
+#define NR_CPUS_HINT 192
+
+static const struct rhashtable_params sdma_rht_params = {
+	.nelem_hint = NR_CPUS_HINT,
+	.head_offset = offsetof(struct sdma_rht_node, node),
+	.key_offset = offsetof(struct sdma_rht_node, cpu_id),
+	.key_len = FIELD_SIZEOF(struct sdma_rht_node, cpu_id),
+	.max_size = NR_CPUS,
+	.min_size = 8,
+	.automatic_shrinking = true,
+};
+
+/*
+ * sdma_select_user_engine() - select sdma engine based on user setup
+ * @dd: devdata
+ * @selector: a spreading factor
+ * @vl: this vl
+ *
+ * This function returns an sdma engine for a user sdma request.
+ * User defined sdma engine affinity setting is honored when applicable,
+ * otherwise system default sdma engine mapping is used. To ensure correct
+ * ordering, the mapping from <selector, vl> to sde must remain unchanged.
+ */
+struct sdma_engine *sdma_select_user_engine(struct hfi1_devdata *dd,
+					    u32 selector, u8 vl)
+{
+	struct sdma_rht_node *rht_node;
+	struct sdma_engine *sde = NULL;
+	const struct cpumask *current_mask = tsk_cpus_allowed(current);
+	unsigned long cpu_id;
+
+	/*
+	 * To ensure that always the same sdma engine(s) will be
+	 * selected make sure the process is pinned to this CPU only.
+	 */
+	if (cpumask_weight(current_mask) != 1)
+		goto out;
+
+	cpu_id = smp_processor_id();
+	rcu_read_lock();
+	rht_node = rhashtable_lookup_fast(&dd->sdma_rht, &cpu_id,
+					  sdma_rht_params);
+
+	if (rht_node && rht_node->map[vl]) {
+		struct sdma_rht_map_elem *map = rht_node->map[vl];
+
+		sde = map->sde[selector & map->mask];
+	}
+	rcu_read_unlock();
+
+	if (sde)
+		return sde;
+
+out:
+	return sdma_select_engine_vl(dd, selector, vl);
+}
+
+static void sdma_populate_sde_map(struct sdma_rht_map_elem *map)
+{
+	int i;
+
+	for (i = 0; i < roundup_pow_of_two(map->ctr ? : 1) - map->ctr; i++)
+		map->sde[map->ctr + i] = map->sde[i];
+}
+
+static void sdma_cleanup_sde_map(struct sdma_rht_map_elem *map,
+				 struct sdma_engine *sde)
+{
+	unsigned int i, pow;
+
+	/* only need to check the first ctr entries for a match */
+	for (i = 0; i < map->ctr; i++) {
+		if (map->sde[i] == sde) {
+			memmove(&map->sde[i], &map->sde[i + 1],
+				(map->ctr - i - 1) * sizeof(map->sde[0]));
+			map->ctr--;
+			pow = roundup_pow_of_two(map->ctr ? : 1);
+			map->mask = pow - 1;
+			sdma_populate_sde_map(map);
+			break;
+		}
+	}
+}
+
+/*
+ * Prevents concurrent reads and writes of the sdma engine cpu_mask
+ */
+static DEFINE_MUTEX(process_to_sde_mutex);
+
+ssize_t sdma_set_cpu_to_sde_map(struct sdma_engine *sde, const char *buf,
+				size_t count)
+{
+	struct hfi1_devdata *dd = sde->dd;
+	cpumask_var_t mask, new_mask;
+	unsigned long cpu;
+	int ret, vl, sz;
+
+	vl = sdma_engine_get_vl(sde);
+	if (unlikely(vl < 0))
+		return -EINVAL;
+
+	ret = zalloc_cpumask_var(&mask, GFP_KERNEL);
+	if (!ret)
+		return -ENOMEM;
+
+	ret = zalloc_cpumask_var(&new_mask, GFP_KERNEL);
+	if (!ret) {
+		free_cpumask_var(mask);
+		return -ENOMEM;
+	}
+	ret = cpulist_parse(buf, mask);
+	if (ret)
+		goto out_free;
+
+	if (!cpumask_subset(mask, cpu_online_mask)) {
+		dd_dev_warn(sde->dd, "Invalid CPU mask\n");
+		ret = -EINVAL;
+		goto out_free;
+	}
+
+	sz = sizeof(struct sdma_rht_map_elem) +
+			(TXE_NUM_SDMA_ENGINES * sizeof(struct sdma_engine *));
+
+	mutex_lock(&process_to_sde_mutex);
+
+	for_each_cpu(cpu, mask) {
+		struct sdma_rht_node *rht_node;
+
+		/* Check if we have this already mapped */
+		if (cpumask_test_cpu(cpu, &sde->cpu_mask)) {
+			cpumask_set_cpu(cpu, new_mask);
+			continue;
+		}
+
+		rht_node = rhashtable_lookup_fast(&dd->sdma_rht, &cpu,
+						  sdma_rht_params);
+		if (!rht_node) {
+			rht_node = kzalloc(sizeof(*rht_node), GFP_KERNEL);
+			if (!rht_node) {
+				ret = -ENOMEM;
+				goto out;
+			}
+
+			rht_node->map[vl] = kzalloc(sz, GFP_KERNEL);
+			if (!rht_node->map[vl]) {
+				kfree(rht_node);
+				ret = -ENOMEM;
+				goto out;
+			}
+			rht_node->cpu_id = cpu;
+			rht_node->map[vl]->mask = 0;
+			rht_node->map[vl]->ctr = 1;
+			rht_node->map[vl]->sde[0] = sde;
+
+			ret = rhashtable_insert_fast(&dd->sdma_rht,
+						     &rht_node->node,
+						     sdma_rht_params);
+			if (ret) {
+				kfree(rht_node->map[vl]);
+				kfree(rht_node);
+				dd_dev_err(sde->dd, "Failed to set process to sde affinity for cpu %lu\n",
+					   cpu);
+				goto out;
+			}
+
+		} else {
+			int ctr, pow;
+
+			/* Add new user mappings */
+			if (!rht_node->map[vl])
+				rht_node->map[vl] = kzalloc(sz, GFP_KERNEL);
+
+			if (!rht_node->map[vl]) {
+				ret = -ENOMEM;
+				goto out;
+			}
+
+			rht_node->map[vl]->ctr++;
+			ctr = rht_node->map[vl]->ctr;
+			rht_node->map[vl]->sde[ctr - 1] = sde;
+			pow = roundup_pow_of_two(ctr);
+			rht_node->map[vl]->mask = pow - 1;
+
+			/* Populate the sde map table */
+			sdma_populate_sde_map(rht_node->map[vl]);
+		}
+		cpumask_set_cpu(cpu, new_mask);
+	}
+
+	/* Clean up old mappings */
+	for_each_cpu(cpu, cpu_online_mask) {
+		struct sdma_rht_node *rht_node;
+
+		/* Don't cleanup sdes that are set in the new mask */
+		if (cpumask_test_cpu(cpu, mask))
+			continue;
+
+		rht_node = rhashtable_lookup_fast(&dd->sdma_rht, &cpu,
+						  sdma_rht_params);
+		if (rht_node) {
+			bool empty = true;
+			int i;
+
+			/* Remove mappings for old sde */
+			for (i = 0; i < HFI1_MAX_VLS_SUPPORTED; i++)
+				if (rht_node->map[i])
+					sdma_cleanup_sde_map(rht_node->map[i],
+							     sde);
+
+			/* Free empty hash table entries */
+			for (i = 0; i < HFI1_MAX_VLS_SUPPORTED; i++) {
+				if (!rht_node->map[i])
+					continue;
+
+				if (rht_node->map[i]->ctr) {
+					empty = false;
+					break;
+				}
+			}
+
+			if (empty) {
+				ret = rhashtable_remove_fast(&dd->sdma_rht,
+							     &rht_node->node,
+							     sdma_rht_params);
+				WARN_ON(ret);
+
+				for (i = 0; i < HFI1_MAX_VLS_SUPPORTED; i++)
+					kfree(rht_node->map[i]);
+
+				kfree(rht_node);
+			}
+		}
+	}
+
+	cpumask_copy(&sde->cpu_mask, new_mask);
+out:
+	mutex_unlock(&process_to_sde_mutex);
+out_free:
+	free_cpumask_var(mask);
+	free_cpumask_var(new_mask);
+	return ret ? : strnlen(buf, PAGE_SIZE);
+}
+
+ssize_t sdma_get_cpu_to_sde_map(struct sdma_engine *sde, char *buf)
+{
+	mutex_lock(&process_to_sde_mutex);
+	if (cpumask_empty(&sde->cpu_mask))
+		snprintf(buf, PAGE_SIZE, "%s\n", "empty");
+	else
+		cpumap_print_to_pagebuf(true, buf, &sde->cpu_mask);
+	mutex_unlock(&process_to_sde_mutex);
+	return strnlen(buf, PAGE_SIZE);
+}
+
+static void sdma_rht_free(void *ptr, void *arg)
+{
+	struct sdma_rht_node *rht_node = ptr;
+	int i;
+
+	for (i = 0; i < HFI1_MAX_VLS_SUPPORTED; i++)
+		kfree(rht_node->map[i]);
+
+	kfree(rht_node);
+}
+
 /*
  * Free the indicated map struct
  */
@@ -1161,6 +1466,10 @@ int sdma_init(struct hfi1_devdata *dd, u8 port)
 	dd->num_sdma = num_engines;
 	if (sdma_map_init(dd, port, ppd->vls_operational, NULL))
 		goto bail;
+
+	if (rhashtable_init(&dd->sdma_rht, &sdma_rht_params))
+		goto bail;
+
 	dd_dev_info(dd, "SDMA num_sdma: %u\n", dd->num_sdma);
 	return 0;
 
@@ -1252,6 +1561,7 @@ void sdma_exit(struct hfi1_devdata *dd)
 		sdma_finalput(&sde->state);
 	}
 	sdma_clean(dd, dd->num_sdma);
+	rhashtable_free_and_destroy(&dd->sdma_rht, sdma_rht_free, NULL);
 }
 
 /*
diff --git a/drivers/infiniband/hw/hfi1/sdma.h b/drivers/infiniband/hw/hfi1/sdma.h
index b333afa..93025f6 100644
--- a/drivers/infiniband/hw/hfi1/sdma.h
+++ b/drivers/infiniband/hw/hfi1/sdma.h
@@ -413,6 +413,8 @@ struct sdma_engine {
 	spinlock_t flushlist_lock;
 	/* private: */
 	struct list_head flushlist;
+	struct cpumask cpu_mask;
+	struct kobject kobj;
 };
 
 int sdma_init(struct hfi1_devdata *dd, u8 port);
@@ -1059,6 +1061,12 @@ struct sdma_engine *sdma_select_engine_vl(
 	u32 selector,
 	u8 vl);
 
+struct sdma_engine *sdma_select_user_engine(struct hfi1_devdata *dd,
+					    u32 selector, u8 vl);
+ssize_t sdma_get_cpu_to_sde_map(struct sdma_engine *sde, char *buf);
+ssize_t sdma_set_cpu_to_sde_map(struct sdma_engine *sde, const char *buf,
+				size_t count);
+int sdma_engine_get_vl(struct sdma_engine *sde);
 void sdma_seqfile_dump_sde(struct seq_file *s, struct sdma_engine *);
 
 #ifdef CONFIG_SDMA_VERBOSITY
diff --git a/drivers/infiniband/hw/hfi1/sysfs.c b/drivers/infiniband/hw/hfi1/sysfs.c
index 74c84c6..836eea5 100644
--- a/drivers/infiniband/hw/hfi1/sysfs.c
+++ b/drivers/infiniband/hw/hfi1/sysfs.c
@@ -766,13 +766,82 @@ bail:
 	return ret;
 }
 
+struct sde_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct sdma_engine *sde, char *buf);
+	ssize_t (*store)(struct sdma_engine *sde, const char *buf, size_t cnt);
+};
+
+static ssize_t sde_show(struct kobject *kobj, struct attribute *attr, char *buf)
+{
+	struct sde_attribute *sde_attr =
+		container_of(attr, struct sde_attribute, attr);
+	struct sdma_engine *sde =
+		container_of(kobj, struct sdma_engine, kobj);
+
+	if (!sde_attr->show)
+		return -EINVAL;
+
+	return sde_attr->show(sde, buf);
+}
+
+static ssize_t sde_store(struct kobject *kobj, struct attribute *attr,
+			 const char *buf, size_t count)
+{
+	struct sde_attribute *sde_attr =
+		container_of(attr, struct sde_attribute, attr);
+	struct sdma_engine *sde =
+		container_of(kobj, struct sdma_engine, kobj);
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (!sde_attr->store)
+		return -EINVAL;
+
+	return sde_attr->store(sde, buf, count);
+}
+
+static const struct sysfs_ops sde_sysfs_ops = {
+	.show = sde_show,
+	.store = sde_store,
+};
+
+static struct kobj_type sde_ktype = {
+	.sysfs_ops = &sde_sysfs_ops,
+};
+
+#define SDE_ATTR(_name, _mode, _show, _store) \
+	struct sde_attribute sde_attr_##_name = \
+		__ATTR(_name, _mode, _show, _store)
+
+static ssize_t sde_show_cpu_to_sde_map(struct sdma_engine *sde, char *buf)
+{
+	return sdma_get_cpu_to_sde_map(sde, buf);
+}
+
+static ssize_t sde_store_cpu_to_sde_map(struct sdma_engine *sde,
+					const char *buf, size_t count)
+{
+	return sdma_set_cpu_to_sde_map(sde, buf, count);
+}
+
+static SDE_ATTR(cpu_list, S_IWUSR | S_IRUGO,
+		sde_show_cpu_to_sde_map,
+		sde_store_cpu_to_sde_map);
+
+static struct sde_attribute *sde_attribs[] = {
+	&sde_attr_cpu_list
+};
+
 /*
  * Register and create our files in /sys/class/infiniband.
  */
 int hfi1_verbs_register_sysfs(struct hfi1_devdata *dd)
 {
 	struct ib_device *dev = &dd->verbs_dev.rdi.ibdev;
-	int i, ret;
+	struct device *class_dev = &dev->dev;
+	int i, j, ret;
 
 	for (i = 0; i < ARRAY_SIZE(hfi1_attributes); ++i) {
 		ret = device_create_file(&dev->dev, hfi1_attributes[i]);
@@ -780,10 +849,29 @@ int hfi1_verbs_register_sysfs(struct hfi1_devdata *dd)
 			goto bail;
 	}
 
+	for (i = 0; i < dd->num_sdma; i++) {
+		ret = kobject_init_and_add(&dd->per_sdma[i].kobj,
+					   &sde_ktype, &class_dev->kobj,
+					   "sdma%d", i);
+		if (ret)
+			goto bail;
+
+		for (j = 0; j < ARRAY_SIZE(sde_attribs); j++) {
+			ret = sysfs_create_file(&dd->per_sdma[i].kobj,
+						&sde_attribs[j]->attr);
+			if (ret)
+				goto bail;
+		}
+	}
+
 	return 0;
 bail:
 	for (i = 0; i < ARRAY_SIZE(hfi1_attributes); ++i)
 		device_remove_file(&dev->dev, hfi1_attributes[i]);
+
+	for (i = 0; i < dd->num_sdma; i++)
+		kobject_del(&dd->per_sdma[i].kobj);
+
 	return ret;
 }
 
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index bc7e5c1..a761f80 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -548,7 +548,7 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 	u8 opcode, sc, vl;
 	int req_queued = 0;
 	u16 dlid;
-	u8 selector;
+	u32 selector;
 
 	if (iovec[idx].iov_len < sizeof(info) + sizeof(req->hdr)) {
 		hfi1_cdbg(
@@ -753,12 +753,9 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 
 	dlid = be16_to_cpu(req->hdr.lrh[1]);
 	selector = dlid_to_selector(dlid);
+	selector += uctxt->ctxt + fd->subctxt;
+	req->sde = sdma_select_user_engine(dd, selector, vl);
 
-	/* Have to select the engine */
-	req->sde = sdma_select_engine_vl(dd,
-					 (u32)(uctxt->ctxt + fd->subctxt +
-					       selector),
-					 vl);
 	if (!req->sde || !sdma_running(req->sde)) {
 		ret = -ECOMM;
 		goto free_req;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
