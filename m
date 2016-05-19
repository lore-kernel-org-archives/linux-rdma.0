From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/core: Make device counter infrastructure dynamic
Date: Thu, 19 May 2016 17:35:13 -0400
Message-ID: <9ed44c11acf2de44f06ce5d88758ce8d732d1be2.1463693558.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

In practice, each RDMA device has a unique set of counters that the
hardware implements.  Having a central set of counters that they must
all adhere to is limiting and causes many useful counters to not be
available.

Therefore we create a dynamic counter registration infrastructure.

The driver must implement a stats structure allocation routine, in
which the driver must place the directory name it wants, a list of
names for all of the counters, an array of u64 counters themselves,
plus a few generic configuration options.

We then implement a core routine to create a sysfs file for each
of the named stats elements, and a core routine to retrieve the
stats when any of the sysfs attribute files are read.

To avoid excessive beating on the stats generation routine in the
drivers, the core code also caches the stats for a short period of
time so that someone attempting to read all of the stats in a
given device's directory will not result in a stats generation
call per file read.

Future work will attempt to standardize just the shared stats
elements, and possibly add a method to get the stats via netlink
in addition to sysfs.

Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
[ Add caching, make structure names more informative, add i40iw support,
  other significant rewrites from the original patch ]
---

Testing:
  This has been tested on cxgb4 only so far.  I've established that the
  directory structure is made as desired (only stats in parent device,
  not in port devices), that all stats output properly, that the lifespan
  element is create and outputs properly and also accepts input properly,
  and that the setting of the lifespan has the desired effect on the
  frequency that the elements are updated.

 drivers/infiniband/core/sysfs.c             | 373 ++++++++++++++++++----------
 drivers/infiniband/hw/cxgb3/iwch_provider.c | 147 ++++++++---
 drivers/infiniband/hw/cxgb4/provider.c      |  46 +++-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c   | 117 ++++++++-
 include/rdma/ib_verbs.h                     |  70 ++----
 5 files changed, 521 insertions(+), 232 deletions(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 14606afbfaa8..dc086934a8ae 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -56,8 +56,10 @@ struct ib_port {
 	struct gid_attr_group *gid_attr_group;
 	struct attribute_group gid_group;
 	struct attribute_group pkey_group;
-	u8                     port_num;
 	struct attribute_group *pma_table;
+	struct attribute_group *prot_stats_attr_group;
+	struct rdma_protocol_stats *prot_stats;
+	u8                     port_num;
 };
 
 struct port_attribute {
@@ -80,6 +82,18 @@ struct port_table_attribute {
 	__be16			attr_id;
 };
 
+struct prot_stats_attribute {
+	struct attribute	attr;
+	ssize_t			(*show)(struct kobject *kobj,
+					struct attribute *attr, char *buf);
+	ssize_t			(*store)(struct kobject *kobj,
+					 struct attribute *attr,
+					 const char *buf,
+					 size_t count);
+	int			index;
+	u8			port_num;
+};
+
 static ssize_t port_attr_show(struct kobject *kobj,
 			      struct attribute *attr, char *buf)
 {
@@ -733,6 +747,220 @@ static struct attribute_group *get_counter_table(struct ib_device *dev,
 	return &pma_group;
 }
 
+static int update_protocol_stats(struct ib_device *dev,
+				 struct rdma_protocol_stats *stats,
+				 u8 port_num)
+{
+	int ret;
+
+	if (time_is_after_eq_jiffies(stats->timestamp + stats->lifespan))
+		return 0;
+	ret = dev->get_protocol_stats(dev, stats, port_num);
+	if (ret)
+		return ret;
+	stats->timestamp = jiffies;
+
+	return 0;
+}
+
+static ssize_t print_protocol_stat(struct rdma_protocol_stats *stats,
+				   int index, char *buf)
+{
+	return sprintf(buf, "%llu\n", stats->value[index]);
+}
+
+static ssize_t show_protocol_stats(struct kobject *kobj,
+				   struct attribute *attr, char *buf)
+{
+	struct ib_device *dev;
+	struct ib_port *port;
+	struct prot_stats_attribute *psa;
+	struct rdma_protocol_stats *stats;
+	int ret;
+
+	psa = container_of(attr, struct prot_stats_attribute, attr);
+	if (!psa->port_num) {
+		dev = container_of((struct device *)kobj,
+				   struct ib_device, dev);
+		stats = dev->prot_stats;
+	} else {
+		port = container_of(kobj, struct ib_port, kobj);
+		dev = port->ibdev;
+		stats = port->prot_stats;
+	}
+	ret = update_protocol_stats(dev, stats, psa->port_num);
+	if (ret)
+		return ret;
+	return print_protocol_stat(stats, psa->index, buf);
+}
+
+static ssize_t show_stats_lifespan(struct kobject *kobj,
+				   struct attribute *attr,
+				   char *buf)
+{
+	struct prot_stats_attribute *psa;
+	int msecs;
+
+	psa = container_of(attr, struct prot_stats_attribute, attr);
+	if (!psa->port_num) {
+		struct ib_device *dev = container_of((struct device *)kobj,
+						     struct ib_device, dev);
+		msecs = jiffies_to_msecs(dev->prot_stats->lifespan);
+	} else {
+		struct ib_port *p = container_of(kobj, struct ib_port, kobj);
+		msecs = jiffies_to_msecs(p->prot_stats->lifespan);
+	}
+	return sprintf(buf, "%d msecs (rounded from jiffies), 0-10000 allowed "
+		       "range\n", msecs);
+}
+
+static ssize_t set_stats_lifespan(struct kobject *kobj,
+				  struct attribute *attr,
+				  const char *buf, size_t count)
+{
+	struct prot_stats_attribute *psa;
+	int msecs;
+	int jiffies;
+	int ret;
+
+	ret = kstrtoint(buf, 10, &msecs);
+	if (ret)
+		return ret;
+	if (msecs < 0 || msecs > 10000)
+		return -EINVAL;
+	jiffies = msecs_to_jiffies(msecs);
+	psa = container_of(attr, struct prot_stats_attribute, attr);
+	if (!psa->port_num) {
+		struct ib_device *dev = container_of((struct device *)kobj,
+						     struct ib_device, dev);
+		dev->prot_stats->lifespan = jiffies;
+	} else {
+		struct ib_port *p = container_of(kobj, struct ib_port, kobj);
+		p->prot_stats->lifespan = jiffies;
+	}
+	return count;
+}
+
+static void free_prot_stats_attr_group(struct kobject *kobj,
+				       struct attribute_group *attr_group)
+{
+	struct attribute **attr;
+
+	sysfs_remove_group(kobj, attr_group);
+
+	for (attr = attr_group->attrs; *attr; attr++)
+		kfree(*attr);
+	kfree(attr_group);
+}
+
+static struct attribute *alloc_stats_attribute(int index, u8 port_num,
+					       char *name)
+{
+	struct prot_stats_attribute *psa;
+
+	psa = kmalloc(sizeof(*psa), GFP_KERNEL);
+	if (!psa)
+		return NULL;
+
+	psa->attr.name = name;
+	psa->attr.mode = S_IRUGO;
+	psa->show = show_protocol_stats;
+	psa->store = NULL;
+	psa->index = index;
+	psa->port_num = port_num;
+
+	return &psa->attr;
+}
+
+static struct attribute *alloc_stats_lifespan(char *name, u8 port_num)
+{
+	struct prot_stats_attribute *psa;
+
+	psa = kmalloc(sizeof(*psa), GFP_KERNEL);
+	if (!psa)
+		return NULL;
+
+	psa->attr.name = name;
+	psa->attr.mode = S_IWUSR | S_IRUGO;
+	psa->show = show_stats_lifespan;
+	psa->store = set_stats_lifespan;
+	psa->index = 0;
+	psa->port_num = port_num;
+
+	return &psa->attr;
+}
+
+static void create_protocol_stats(struct ib_device *device,
+				  struct ib_port *port, u8 port_num)
+{
+	struct attribute_group *psag = NULL;
+	struct rdma_protocol_stats *stats;
+	int i = 0, ret;
+
+	stats = device->alloc_protocol_stats(device, port_num);
+
+	if (!stats)
+		return;
+
+	if (!stats->dirname || !stats->name || stats->num_counters <= 0)
+		goto err;
+
+	/* Don't overwrite the stats lifetime if the driver set it */
+	if (stats->lifespan == 0)
+		stats->lifespan = msecs_to_jiffies(10);
+
+	psag = kzalloc(sizeof(*psag) +
+		       // 1 extra for the lifespan config entry
+		       sizeof(void *) * (stats->num_counters + 1),
+		       GFP_KERNEL);
+	if (!psag)
+		return;
+
+	ret = device->get_protocol_stats(device, stats, port_num);
+	if (ret)
+		goto err;
+
+	stats->timestamp = jiffies;
+
+	psag->name = stats->dirname;
+	psag->attrs = (void *)psag + sizeof(*psag);
+
+	for (i = 0; i < stats->num_counters; i++) {
+		psag->attrs[i] = alloc_stats_attribute(i, port_num,
+						       stats->name[i]);
+		if (!psag->attrs[i])
+			goto err;
+	}
+
+	/* treat an error here as non-fatal */
+	psag->attrs[i] = alloc_stats_lifespan("stats_lifespan", port_num);
+
+	if (port) {
+		struct kobject *kobj = &port->kobj;
+		ret = sysfs_create_group(kobj, psag);
+		if (ret)
+			goto err;
+		port->prot_stats_attr_group = psag;
+		port->prot_stats = stats;
+	} else {
+		struct kobject *kobj = &device->dev.kobj;
+		ret = sysfs_create_group(kobj, psag);
+		if (ret)
+			goto err;
+		device->prot_stats_attr_group = psag;
+		device->prot_stats = stats;
+	}
+
+	return;
+
+err:
+	kfree(stats);
+	for (; i >= 0; i--)
+		kfree(psag->attrs[i]);
+	kfree(psag);
+	return;
+}
+
 static int add_port(struct ib_device *device, int port_num,
 		    int (*port_callback)(struct ib_device *,
 					 u8, struct kobject *))
@@ -835,6 +1063,12 @@ static int add_port(struct ib_device *device, int port_num,
 			goto err_remove_pkey;
 	}
 
+	/* If port == 0, it means we have only one port, so the device should
+	 * hold the protocol stats
+	 */
+	if (device->alloc_protocol_stats && port_num)
+		create_protocol_stats(device, p, port_num);
+
 	list_add_tail(&p->kobj.entry, &device->port_list);
 
 	kobject_uevent(&p->kobj, KOBJ_ADD);
@@ -972,120 +1206,6 @@ static struct device_attribute *ib_class_attributes[] = {
 	&dev_attr_node_desc
 };
 
-/* Show a given an attribute in the statistics group */
-static ssize_t show_protocol_stat(const struct device *device,
-			    struct device_attribute *attr, char *buf,
-			    unsigned offset)
-{
-	struct ib_device *dev = container_of(device, struct ib_device, dev);
-	union rdma_protocol_stats stats;
-	ssize_t ret;
-
-	ret = dev->get_protocol_stats(dev, &stats);
-	if (ret)
-		return ret;
-
-	return sprintf(buf, "%llu\n",
-		       (unsigned long long) ((u64 *) &stats)[offset]);
-}
-
-/* generate a read-only iwarp statistics attribute */
-#define IW_STATS_ENTRY(name)						\
-static ssize_t show_##name(struct device *device,			\
-			   struct device_attribute *attr, char *buf)	\
-{									\
-	return show_protocol_stat(device, attr, buf,			\
-				  offsetof(struct iw_protocol_stats, name) / \
-				  sizeof (u64));			\
-}									\
-static DEVICE_ATTR(name, S_IRUGO, show_##name, NULL)
-
-IW_STATS_ENTRY(ipInReceives);
-IW_STATS_ENTRY(ipInHdrErrors);
-IW_STATS_ENTRY(ipInTooBigErrors);
-IW_STATS_ENTRY(ipInNoRoutes);
-IW_STATS_ENTRY(ipInAddrErrors);
-IW_STATS_ENTRY(ipInUnknownProtos);
-IW_STATS_ENTRY(ipInTruncatedPkts);
-IW_STATS_ENTRY(ipInDiscards);
-IW_STATS_ENTRY(ipInDelivers);
-IW_STATS_ENTRY(ipOutForwDatagrams);
-IW_STATS_ENTRY(ipOutRequests);
-IW_STATS_ENTRY(ipOutDiscards);
-IW_STATS_ENTRY(ipOutNoRoutes);
-IW_STATS_ENTRY(ipReasmTimeout);
-IW_STATS_ENTRY(ipReasmReqds);
-IW_STATS_ENTRY(ipReasmOKs);
-IW_STATS_ENTRY(ipReasmFails);
-IW_STATS_ENTRY(ipFragOKs);
-IW_STATS_ENTRY(ipFragFails);
-IW_STATS_ENTRY(ipFragCreates);
-IW_STATS_ENTRY(ipInMcastPkts);
-IW_STATS_ENTRY(ipOutMcastPkts);
-IW_STATS_ENTRY(ipInBcastPkts);
-IW_STATS_ENTRY(ipOutBcastPkts);
-IW_STATS_ENTRY(tcpRtoAlgorithm);
-IW_STATS_ENTRY(tcpRtoMin);
-IW_STATS_ENTRY(tcpRtoMax);
-IW_STATS_ENTRY(tcpMaxConn);
-IW_STATS_ENTRY(tcpActiveOpens);
-IW_STATS_ENTRY(tcpPassiveOpens);
-IW_STATS_ENTRY(tcpAttemptFails);
-IW_STATS_ENTRY(tcpEstabResets);
-IW_STATS_ENTRY(tcpCurrEstab);
-IW_STATS_ENTRY(tcpInSegs);
-IW_STATS_ENTRY(tcpOutSegs);
-IW_STATS_ENTRY(tcpRetransSegs);
-IW_STATS_ENTRY(tcpInErrs);
-IW_STATS_ENTRY(tcpOutRsts);
-
-static struct attribute *iw_proto_stats_attrs[] = {
-	&dev_attr_ipInReceives.attr,
-	&dev_attr_ipInHdrErrors.attr,
-	&dev_attr_ipInTooBigErrors.attr,
-	&dev_attr_ipInNoRoutes.attr,
-	&dev_attr_ipInAddrErrors.attr,
-	&dev_attr_ipInUnknownProtos.attr,
-	&dev_attr_ipInTruncatedPkts.attr,
-	&dev_attr_ipInDiscards.attr,
-	&dev_attr_ipInDelivers.attr,
-	&dev_attr_ipOutForwDatagrams.attr,
-	&dev_attr_ipOutRequests.attr,
-	&dev_attr_ipOutDiscards.attr,
-	&dev_attr_ipOutNoRoutes.attr,
-	&dev_attr_ipReasmTimeout.attr,
-	&dev_attr_ipReasmReqds.attr,
-	&dev_attr_ipReasmOKs.attr,
-	&dev_attr_ipReasmFails.attr,
-	&dev_attr_ipFragOKs.attr,
-	&dev_attr_ipFragFails.attr,
-	&dev_attr_ipFragCreates.attr,
-	&dev_attr_ipInMcastPkts.attr,
-	&dev_attr_ipOutMcastPkts.attr,
-	&dev_attr_ipInBcastPkts.attr,
-	&dev_attr_ipOutBcastPkts.attr,
-	&dev_attr_tcpRtoAlgorithm.attr,
-	&dev_attr_tcpRtoMin.attr,
-	&dev_attr_tcpRtoMax.attr,
-	&dev_attr_tcpMaxConn.attr,
-	&dev_attr_tcpActiveOpens.attr,
-	&dev_attr_tcpPassiveOpens.attr,
-	&dev_attr_tcpAttemptFails.attr,
-	&dev_attr_tcpEstabResets.attr,
-	&dev_attr_tcpCurrEstab.attr,
-	&dev_attr_tcpInSegs.attr,
-	&dev_attr_tcpOutSegs.attr,
-	&dev_attr_tcpRetransSegs.attr,
-	&dev_attr_tcpInErrs.attr,
-	&dev_attr_tcpOutRsts.attr,
-	NULL
-};
-
-static struct attribute_group iw_stats_group = {
-	.name	= "proto_stats",
-	.attrs	= iw_proto_stats_attrs,
-};
-
 static void free_port_list_attributes(struct ib_device *device)
 {
 	struct kobject *p, *t;
@@ -1093,6 +1213,11 @@ static void free_port_list_attributes(struct ib_device *device)
 	list_for_each_entry_safe(p, t, &device->port_list, entry) {
 		struct ib_port *port = container_of(p, struct ib_port, kobj);
 		list_del(&p->entry);
+		if (port->prot_stats) {
+			kfree(port->prot_stats);
+			free_prot_stats_attr_group(&port->kobj,
+						   port->prot_stats_attr_group);
+		}
 		sysfs_remove_group(p, port->pma_table);
 		sysfs_remove_group(p, &port->pkey_group);
 		sysfs_remove_group(p, &port->gid_group);
@@ -1149,11 +1274,8 @@ int ib_device_register_sysfs(struct ib_device *device,
 		}
 	}
 
-	if (device->node_type == RDMA_NODE_RNIC && device->get_protocol_stats) {
-		ret = sysfs_create_group(&class_dev->kobj, &iw_stats_group);
-		if (ret)
-			goto err_put;
-	}
+	if (device->alloc_protocol_stats)
+		create_protocol_stats(device, NULL, 0);
 
 	return 0;
 
@@ -1169,15 +1291,16 @@ err:
 
 void ib_device_unregister_sysfs(struct ib_device *device)
 {
-	/* Hold kobject until ib_dealloc_device() */
-	struct kobject *kobj_dev = kobject_get(&device->dev.kobj);
 	int i;
 
-	if (device->node_type == RDMA_NODE_RNIC && device->get_protocol_stats)
-		sysfs_remove_group(kobj_dev, &iw_stats_group);
-
 	free_port_list_attributes(device);
 
+	if (device->prot_stats) {
+		kfree(device->prot_stats);
+		free_prot_stats_attr_group(&device->dev.kobj,
+					   device->prot_stats_attr_group);
+	}
+
 	for (i = 0; i < ARRAY_SIZE(ib_class_attributes); ++i)
 		device_remove_file(&device->dev, ib_class_attributes[i]);
 
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 47cb927a0dd6..d3a674bf57a9 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -1218,58 +1218,124 @@ static ssize_t show_board(struct device *dev, struct device_attribute *attr,
 		       iwch_dev->rdev.rnic_info.pdev->device);
 }
 
+enum counters {
+	IPINRECEIVES,
+	IPINHDRERRORS,
+	IPINADDRERRORS,
+	IPINUNKNOWNPROTOS,
+	IPINDISCARDS,
+	IPINDELIVERS,
+	IPOUTREQUESTS,
+	IPOUTDISCARDS,
+	IPOUTNOROUTES,
+	IPREASMTIMEOUT,
+	IPREASMREQDS,
+	IPREASMOKS,
+	IPREASMFAILS,
+	TCPACTIVEOPENS,
+	TCPPASSIVEOPENS,
+	TCPATTEMPTFAILS,
+	TCPESTABRESETS,
+	TCPCURRESTAB,
+	TCPINSEGS,
+	TCPOUTSEGS,
+	TCPRETRANSSEGS,
+	TCPINERRS,
+	TCPOUTRSTS,
+	TCPRTOMIN,
+	TCPRTOMAX,
+	NR_COUNTERS
+};
+
+char *names[] = {
+	[IPINRECEIVES] = "ipInReceives",
+	[IPINHDRERRORS] = "ipInHdrErrors",
+	[IPINADDRERRORS] = "ipInAddrErrors",
+	[IPINUNKNOWNPROTOS] = "ipInUnknownProtos",
+	[IPINDISCARDS] = "ipInDiscards",
+	[IPINDELIVERS] = "ipInDelivers",
+	[IPOUTREQUESTS] = "ipOutRequests",
+	[IPOUTDISCARDS] = "ipOutDiscards",
+	[IPOUTNOROUTES] = "ipOutNoRoutes",
+	[IPREASMTIMEOUT] = "ipReasmTimeout",
+	[IPREASMREQDS] = "ipReasmReqds",
+	[IPREASMOKS] = "ipReasmOKs",
+	[IPREASMFAILS] = "ipReasmFails",
+	[TCPACTIVEOPENS] = "tcpActiveOpens",
+	[TCPPASSIVEOPENS] = "tcpPassiveOpens",
+	[TCPATTEMPTFAILS] = "tcpAttemptFails",
+	[TCPESTABRESETS] = "tcpEstabResets",
+	[TCPCURRESTAB] = "tcpCurrEstab",
+	[TCPINSEGS] = "tcpInSegs",
+	[TCPOUTSEGS] = "tcpOutSegs",
+	[TCPRETRANSSEGS] = "tcpRetransSegs",
+	[TCPINERRS] = "tcpInErrs",
+	[TCPOUTRSTS] = "tcpOutRsts",
+	[TCPRTOMIN] = "tcpRtoMin",
+	[TCPRTOMAX] = "tcpRtoMax",
+	[NR_COUNTERS] = NULL
+};
+
+static struct rdma_protocol_stats *iwch_alloc_stats(struct ib_device *ibdev,
+						    u8 port_num)
+{
+	struct rdma_protocol_stats *stats;
+
+	if (port_num != 0)
+		return NULL;
+
+	stats = kzalloc(sizeof(*stats) + NR_COUNTERS * sizeof(u64), GFP_KERNEL);
+	if (!stats)
+		return NULL;
+	stats->dirname = "iw_stats";
+	stats->name = names;
+	stats->num_counters = NR_COUNTERS;
+	return stats;
+}
+
 static int iwch_get_mib(struct ib_device *ibdev,
-			union rdma_protocol_stats *stats)
+			struct rdma_protocol_stats *stats,
+			u8 port)
 {
 	struct iwch_dev *dev;
 	struct tp_mib_stats m;
 	int ret;
 
+	if (port != 0 || !stats)
+		return -ENOSYS;
+
 	PDBG("%s ibdev %p\n", __func__, ibdev);
 	dev = to_iwch_dev(ibdev);
 	ret = dev->rdev.t3cdev_p->ctl(dev->rdev.t3cdev_p, RDMA_GET_MIB, &m);
 	if (ret)
 		return -ENOSYS;
 
-	memset(stats, 0, sizeof *stats);
-	stats->iw.ipInReceives = ((u64) m.ipInReceive_hi << 32) +
-				m.ipInReceive_lo;
-	stats->iw.ipInHdrErrors = ((u64) m.ipInHdrErrors_hi << 32) +
-				  m.ipInHdrErrors_lo;
-	stats->iw.ipInAddrErrors = ((u64) m.ipInAddrErrors_hi << 32) +
-				   m.ipInAddrErrors_lo;
-	stats->iw.ipInUnknownProtos = ((u64) m.ipInUnknownProtos_hi << 32) +
-				      m.ipInUnknownProtos_lo;
-	stats->iw.ipInDiscards = ((u64) m.ipInDiscards_hi << 32) +
-				 m.ipInDiscards_lo;
-	stats->iw.ipInDelivers = ((u64) m.ipInDelivers_hi << 32) +
-				 m.ipInDelivers_lo;
-	stats->iw.ipOutRequests = ((u64) m.ipOutRequests_hi << 32) +
-				  m.ipOutRequests_lo;
-	stats->iw.ipOutDiscards = ((u64) m.ipOutDiscards_hi << 32) +
-				  m.ipOutDiscards_lo;
-	stats->iw.ipOutNoRoutes = ((u64) m.ipOutNoRoutes_hi << 32) +
-				  m.ipOutNoRoutes_lo;
-	stats->iw.ipReasmTimeout = (u64) m.ipReasmTimeout;
-	stats->iw.ipReasmReqds = (u64) m.ipReasmReqds;
-	stats->iw.ipReasmOKs = (u64) m.ipReasmOKs;
-	stats->iw.ipReasmFails = (u64) m.ipReasmFails;
-	stats->iw.tcpActiveOpens = (u64) m.tcpActiveOpens;
-	stats->iw.tcpPassiveOpens = (u64) m.tcpPassiveOpens;
-	stats->iw.tcpAttemptFails = (u64) m.tcpAttemptFails;
-	stats->iw.tcpEstabResets = (u64) m.tcpEstabResets;
-	stats->iw.tcpOutRsts = (u64) m.tcpOutRsts;
-	stats->iw.tcpCurrEstab = (u64) m.tcpCurrEstab;
-	stats->iw.tcpInSegs = ((u64) m.tcpInSegs_hi << 32) +
-			      m.tcpInSegs_lo;
-	stats->iw.tcpOutSegs = ((u64) m.tcpOutSegs_hi << 32) +
-			       m.tcpOutSegs_lo;
-	stats->iw.tcpRetransSegs = ((u64) m.tcpRetransSeg_hi << 32) +
-				  m.tcpRetransSeg_lo;
-	stats->iw.tcpInErrs = ((u64) m.tcpInErrs_hi << 32) +
-			      m.tcpInErrs_lo;
-	stats->iw.tcpRtoMin = (u64) m.tcpRtoMin;
-	stats->iw.tcpRtoMax = (u64) m.tcpRtoMax;
+	stats->value[IPINRECEIVES] = ((u64)m.ipInReceive_hi << 32) +	m.ipInReceive_lo;
+	stats->value[IPINHDRERRORS] = ((u64)m.ipInHdrErrors_hi << 32) + m.ipInHdrErrors_lo;
+	stats->value[IPINADDRERRORS] = ((u64)m.ipInAddrErrors_hi << 32) + m.ipInAddrErrors_lo;
+	stats->value[IPINUNKNOWNPROTOS] = ((u64)m.ipInUnknownProtos_hi << 32) + m.ipInUnknownProtos_lo;
+	stats->value[IPINDISCARDS] = ((u64)m.ipInDiscards_hi << 32) + m.ipInDiscards_lo;
+	stats->value[IPINDELIVERS] = ((u64)m.ipInDelivers_hi << 32) + m.ipInDelivers_lo;
+	stats->value[IPOUTREQUESTS] = ((u64)m.ipOutRequests_hi << 32) + m.ipOutRequests_lo;
+	stats->value[IPOUTDISCARDS] = ((u64)m.ipOutDiscards_hi << 32) + m.ipOutDiscards_lo;
+	stats->value[IPOUTNOROUTES] = ((u64)m.ipOutNoRoutes_hi << 32) + m.ipOutNoRoutes_lo;
+	stats->value[IPREASMTIMEOUT] = 	m.ipReasmTimeout;
+	stats->value[IPREASMREQDS] = m.ipReasmReqds;
+	stats->value[IPREASMOKS] = m.ipReasmOKs;
+	stats->value[IPREASMFAILS] = m.ipReasmFails;
+	stats->value[TCPACTIVEOPENS] =	m.tcpActiveOpens;
+	stats->value[TCPPASSIVEOPENS] =	m.tcpPassiveOpens;
+	stats->value[TCPATTEMPTFAILS] = m.tcpAttemptFails;
+	stats->value[TCPESTABRESETS] = m.tcpEstabResets;
+	stats->value[TCPCURRESTAB] = m.tcpOutRsts;
+	stats->value[TCPINSEGS] = m.tcpCurrEstab;
+	stats->value[TCPOUTSEGS] = ((u64)m.tcpInSegs_hi << 32) + m.tcpInSegs_lo;
+	stats->value[TCPRETRANSSEGS] = ((u64)m.tcpOutSegs_hi << 32) + m.tcpOutSegs_lo;
+	stats->value[TCPINERRS] = ((u64)m.tcpRetransSeg_hi << 32) + m.tcpRetransSeg_lo,
+	stats->value[TCPOUTRSTS] = ((u64)m.tcpInErrs_hi << 32) + m.tcpInErrs_lo;
+	stats->value[TCPRTOMIN] = m.tcpRtoMin;
+	stats->value[TCPRTOMAX] = m.tcpRtoMax;
+
 	return 0;
 }
 
@@ -1373,6 +1439,7 @@ int iwch_register_device(struct iwch_dev *dev)
 	dev->ibdev.req_notify_cq = iwch_arm_cq;
 	dev->ibdev.post_send = iwch_post_send;
 	dev->ibdev.post_recv = iwch_post_receive;
+	dev->ibdev.alloc_protocol_stats = iwch_alloc_stats;
 	dev->ibdev.get_protocol_stats = iwch_get_mib;
 	dev->ibdev.uverbs_abi_ver = IWCH_UVERBS_ABI_VERSION;
 	dev->ibdev.get_port_immutable = iwch_port_immutable;
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index 7574f394fdac..f5a19617c770 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -446,18 +446,51 @@ static ssize_t show_board(struct device *dev, struct device_attribute *attr,
 		       c4iw_dev->rdev.lldi.pdev->device);
 }
 
+enum counters {
+	TCPINSEGS,
+	TCPOUTSEGS,
+	TCPRETRANSSEGS,
+	TCPOUTRSTS,
+	NR_COUNTERS
+};
+
+static char *names[] = {
+	[TCPINSEGS] = "tcpInSegs",
+	[TCPOUTSEGS] = "tcpOutSegs",
+	[TCPRETRANSSEGS] = "tcpRetransSegs",
+	[TCPOUTRSTS] = "tcpOutRsts",
+	[NR_COUNTERS] = NULL
+};
+
+static struct rdma_protocol_stats *c4iw_alloc_stats(struct ib_device *ibdev,
+						    u8 port_num)
+{
+	struct rdma_protocol_stats *stats;
+
+	if (port_num != 0)
+		return NULL;
+
+	stats = kzalloc(sizeof(*stats) + NR_COUNTERS * sizeof(u64), GFP_KERNEL);
+	if (!stats)
+		return NULL;
+	stats->dirname = "iw_stats";
+	stats->name = names;
+	stats->num_counters = NR_COUNTERS;
+	return stats;
+}
+
 static int c4iw_get_mib(struct ib_device *ibdev,
-			union rdma_protocol_stats *stats)
+			struct rdma_protocol_stats *stats,
+			u8 port)
 {
 	struct tp_tcp_stats v4, v6;
 	struct c4iw_dev *c4iw_dev = to_c4iw_dev(ibdev);
 
 	cxgb4_get_tcp_stats(c4iw_dev->rdev.lldi.pdev, &v4, &v6);
-	memset(stats, 0, sizeof *stats);
-	stats->iw.tcpInSegs = v4.tcp_in_segs + v6.tcp_in_segs;
-	stats->iw.tcpOutSegs = v4.tcp_out_segs + v6.tcp_out_segs;
-	stats->iw.tcpRetransSegs = v4.tcp_retrans_segs + v6.tcp_retrans_segs;
-	stats->iw.tcpOutRsts = v4.tcp_out_rsts + v6.tcp_out_rsts;
+	stats->value[TCPINSEGS] = v4.tcp_in_segs + v6.tcp_in_segs;
+	stats->value[TCPOUTSEGS] = v4.tcp_out_segs + v6.tcp_out_segs;
+	stats->value[TCPRETRANSSEGS] = v4.tcp_retrans_segs + v6.tcp_retrans_segs;
+	stats->value[TCPOUTRSTS] = v4.tcp_out_rsts + v6.tcp_out_rsts;
 
 	return 0;
 }
@@ -562,6 +595,7 @@ int c4iw_register_device(struct c4iw_dev *dev)
 	dev->ibdev.req_notify_cq = c4iw_arm_cq;
 	dev->ibdev.post_send = c4iw_post_send;
 	dev->ibdev.post_recv = c4iw_post_receive;
+	dev->ibdev.alloc_protocol_stats = c4iw_alloc_stats;
 	dev->ibdev.get_protocol_stats = c4iw_get_mib;
 	dev->ibdev.uverbs_abi_ver = C4IW_UVERBS_ABI_VERSION;
 	dev->ibdev.get_port_immutable = c4iw_port_immutable;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 4a740f7a0519..9fb4000f90ec 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -2361,36 +2361,131 @@ static int i40iw_port_immutable(struct ib_device *ibdev, u8 port_num,
 	return 0;
 }
 
+static char *i40iw_hw_stat_names[] = {
+	// 32bit names
+	[I40IW_HW_STAT_INDEX_IP4RXDISCARD] = "ip4InDiscards",
+	[I40IW_HW_STAT_INDEX_IP4RXTRUNC] = "ip4InTruncatedPkts",
+	[I40IW_HW_STAT_INDEX_IP4TXNOROUTE] = "ip4OutNoRoutes",
+	[I40IW_HW_STAT_INDEX_IP6RXDISCARD] = "ip6InDiscards",
+	[I40IW_HW_STAT_INDEX_IP6RXTRUNC] = "ip6InTruncatedPkts",
+	[I40IW_HW_STAT_INDEX_IP6TXNOROUTE] = "ip6OutNoRoutes",
+	[I40IW_HW_STAT_INDEX_TCPRTXSEG] = "tcpRetransSegs",
+	[I40IW_HW_STAT_INDEX_TCPRXOPTERR] = "tcpInOptErrors",
+	[I40IW_HW_STAT_INDEX_TCPRXPROTOERR] = "tcpInProtoErrors",
+	// 64bit names
+	[I40IW_HW_STAT_INDEX_IP4RXOCTS + I40IW_HW_STAT_INDEX_MAX_32] =
+		"ip4InOctets",
+	[I40IW_HW_STAT_INDEX_IP4RXPKTS + I40IW_HW_STAT_INDEX_MAX_32] =
+		"ip4InPkts",
+	[I40IW_HW_STAT_INDEX_IP4RXFRAGS + I40IW_HW_STAT_INDEX_MAX_32] =
+		"ip4InReasmRqd",
+	[I40IW_HW_STAT_INDEX_IP4RXMCPKTS + I40IW_HW_STAT_INDEX_MAX_32] =
+		"ip4InMcastPkts",
+	[I40IW_HW_STAT_INDEX_IP4TXOCTS + I40IW_HW_STAT_INDEX_MAX_32] =
+		"ip4OutOctets",
+	[I40IW_HW_STAT_INDEX_IP4TXPKTS + I40IW_HW_STAT_INDEX_MAX_32] =
+		"ip4OutPkts",
+	[I40IW_HW_STAT_INDEX_IP4TXFRAGS + I40IW_HW_STAT_INDEX_MAX_32] =
+		"ip4OutSegRqd",
+	[I40IW_HW_STAT_INDEX_IP4TXMCPKTS + I40IW_HW_STAT_INDEX_MAX_32] =
+		"ip4OutMcastPkts",
+	[I40IW_HW_STAT_INDEX_IP6RXOCTS + I40IW_HW_STAT_INDEX_MAX_32] =
+		"ip6InOctets",
+	[I40IW_HW_STAT_INDEX_IP6RXPKTS + I40IW_HW_STAT_INDEX_MAX_32] =
+		"ip6InPkts",
+	[I40IW_HW_STAT_INDEX_IP6RXFRAGS + I40IW_HW_STAT_INDEX_MAX_32] =
+		"ip6InReasmRqd",
+	[I40IW_HW_STAT_INDEX_IP6RXMCPKTS + I40IW_HW_STAT_INDEX_MAX_32] =
+		"ip6InMcastPkts",
+	[I40IW_HW_STAT_INDEX_IP6TXOCTS + I40IW_HW_STAT_INDEX_MAX_32] =
+		"ip6OutOctets",
+	[I40IW_HW_STAT_INDEX_IP6TXPKTS + I40IW_HW_STAT_INDEX_MAX_32] =
+		"ip6OutPkts",
+	[I40IW_HW_STAT_INDEX_IP6TXFRAGS + I40IW_HW_STAT_INDEX_MAX_32] =
+		"ip6OutSegRqd",
+	[I40IW_HW_STAT_INDEX_IP6TXMCPKTS + I40IW_HW_STAT_INDEX_MAX_32] =
+		"ip6OutMcastPkts",
+	[I40IW_HW_STAT_INDEX_TCPRXSEGS + I40IW_HW_STAT_INDEX_MAX_32] =
+		"tcpInSegs",
+	[I40IW_HW_STAT_INDEX_TCPTXSEG + I40IW_HW_STAT_INDEX_MAX_32] =
+		"tcpOutSegs",
+	[I40IW_HW_STAT_INDEX_RDMARXRDS + I40IW_HW_STAT_INDEX_MAX_32] =
+		"iwInRdmaReads",
+	[I40IW_HW_STAT_INDEX_RDMARXSNDS + I40IW_HW_STAT_INDEX_MAX_32] =
+		"iwInRdmaSends",
+	[I40IW_HW_STAT_INDEX_RDMARXWRS + I40IW_HW_STAT_INDEX_MAX_32] =
+		"iwInRdmaWrites",
+	[I40IW_HW_STAT_INDEX_RDMATXRDS + I40IW_HW_STAT_INDEX_MAX_32] =
+		"iwOutRdmaReads",
+	[I40IW_HW_STAT_INDEX_RDMATXSNDS + I40IW_HW_STAT_INDEX_MAX_32] =
+		"iwOutRdmaSends",
+	[I40IW_HW_STAT_INDEX_RDMATXWRS + I40IW_HW_STAT_INDEX_MAX_32] =
+		"iwOutRdmaWrites",
+	[I40IW_HW_STAT_INDEX_RDMAVBND + I40IW_HW_STAT_INDEX_MAX_32] =
+		"iwRdmaBnd",
+	[I40IW_HW_STAT_INDEX_RDMAVINV + I40IW_HW_STAT_INDEX_MAX_32] =
+		"iwRdmaInv",
+	[I40IW_HW_STAT_INDEX_MAX_64 + I40IW_HW_STAT_INDEX_MAX_32] = ""
+};
+
+/**
+ * i40iw_alloc_protocol_stats - Allocate a protocol stats structure
+ * @ibdev: ib dev struct
+ * @port_num: port on ib dev
+ */
+static struct rdma_protocol_stats *i40iw_alloc_protocol_stats(struct ib_device *ibdev,
+							      u8 port_num)
+{
+	struct i40iw_device *iwdev = to_iwdev(ibdev);
+	struct i40iw_sc_dev *dev = &iwdev->sc_dev;
+	struct rdma_protocol_stats *stats;
+
+	stats = kzalloc(sizeof(*stats) +
+			I40IW_HW_STAT_INDEX_MAX_32 * sizeof(u64) +
+			I40IW_HW_STAT_INDEX_MAX_64 * sizeof(u64), GFP_KERNEL);
+	if (!stats)
+		return NULL;
+	stats->dirname = "iw_stats";
+	stats->name = i40iw_hw_stat_names;
+	stats->num_counters = I40IW_HW_STAT_INDEX_MAX_32 +
+		I40IW_HW_STAT_INDEX_MAX_64;
+	// Only update vfs once per second
+	if (!dev->is_pf)
+		stats->lifespan = msecs_to_jiffies(1000);
+	return stats;
+}
+
 /**
  * i40iw_get_protocol_stats - Populates the rdma_stats structure
  * @ibdev: ib dev struct
  * @stats: iw protocol stats struct
  */
 static int i40iw_get_protocol_stats(struct ib_device *ibdev,
-				    union rdma_protocol_stats *stats)
+				    struct rdma_protocol_stats *stats,
+				    u8 port_num)
 {
 	struct i40iw_device *iwdev = to_iwdev(ibdev);
 	struct i40iw_sc_dev *dev = &iwdev->sc_dev;
 	struct i40iw_dev_pestat *devstat = &dev->dev_pestat;
 	struct i40iw_dev_hw_stats *hw_stats = &devstat->hw_stats;
-	struct timespec curr_time;
-	static struct timespec last_rd_time = {0, 0};
 	unsigned long flags;
 
-	curr_time = current_kernel_time();
-	memset(stats, 0, sizeof(*stats));
-
 	if (dev->is_pf) {
 		spin_lock_irqsave(&devstat->stats_lock, flags);
 		devstat->ops.iw_hw_stat_read_all(devstat,
 			&devstat->hw_stats);
 		spin_unlock_irqrestore(&devstat->stats_lock, flags);
 	} else {
-		if (((u64)curr_time.tv_sec - (u64)last_rd_time.tv_sec) > 1)
-			if (i40iw_vchnl_vf_get_pe_stats(dev, &devstat->hw_stats))
-				return -ENOSYS;
+		if (i40iw_vchnl_vf_get_pe_stats(dev, &devstat->hw_stats))
+			return -ENOSYS;
 	}
 
+	memcpy(&stats->value[0], &hw_stats, sizeof(*hw_stats));
+
+	/*
+	 * I'm opting not to remove this code in case we wish to add a
+	 * list of combined ip4 + ip6 stats in addition to the separate
+	 * stats already available.
 	stats->iw.ipInReceives = hw_stats->stat_value_64[I40IW_HW_STAT_INDEX_IP4RXPKTS] +
 				 hw_stats->stat_value_64[I40IW_HW_STAT_INDEX_IP6RXPKTS];
 	stats->iw.ipInTruncatedPkts = hw_stats->stat_value_32[I40IW_HW_STAT_INDEX_IP4RXTRUNC] +
@@ -2410,8 +2505,7 @@ static int i40iw_get_protocol_stats(struct ib_device *ibdev,
 	stats->iw.tcpOutSegs = hw_stats->stat_value_64[I40IW_HW_STAT_INDEX_TCPTXSEG];
 	stats->iw.tcpInSegs = hw_stats->stat_value_64[I40IW_HW_STAT_INDEX_TCPRXSEGS];
 	stats->iw.tcpRetransSegs = hw_stats->stat_value_32[I40IW_HW_STAT_INDEX_TCPRTXSEG];
-
-	last_rd_time = curr_time;
+	*/
 	return 0;
 }
 
@@ -2551,6 +2645,7 @@ static struct i40iw_ib_device *i40iw_init_rdma_device(struct i40iw_device *iwdev
 	iwibdev->ibdev.get_dma_mr = i40iw_get_dma_mr;
 	iwibdev->ibdev.reg_user_mr = i40iw_reg_user_mr;
 	iwibdev->ibdev.dereg_mr = i40iw_dereg_mr;
+	iwibdev->ibdev.alloc_protocol_stats = i40iw_alloc_protocol_stats;
 	iwibdev->ibdev.get_protocol_stats = i40iw_get_protocol_stats;
 	iwibdev->ibdev.query_device = i40iw_query_device;
 	iwibdev->ibdev.create_ah = i40iw_create_ah;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index fc0320c004a3..653cfa8e3ba3 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -403,55 +403,20 @@ enum ib_port_speed {
 	IB_SPEED_EDR	= 32
 };
 
-struct ib_protocol_stats {
-	/* TBD... */
-};
-
-struct iw_protocol_stats {
-	u64	ipInReceives;
-	u64	ipInHdrErrors;
-	u64	ipInTooBigErrors;
-	u64	ipInNoRoutes;
-	u64	ipInAddrErrors;
-	u64	ipInUnknownProtos;
-	u64	ipInTruncatedPkts;
-	u64	ipInDiscards;
-	u64	ipInDelivers;
-	u64	ipOutForwDatagrams;
-	u64	ipOutRequests;
-	u64	ipOutDiscards;
-	u64	ipOutNoRoutes;
-	u64	ipReasmTimeout;
-	u64	ipReasmReqds;
-	u64	ipReasmOKs;
-	u64	ipReasmFails;
-	u64	ipFragOKs;
-	u64	ipFragFails;
-	u64	ipFragCreates;
-	u64	ipInMcastPkts;
-	u64	ipOutMcastPkts;
-	u64	ipInBcastPkts;
-	u64	ipOutBcastPkts;
-
-	u64	tcpRtoAlgorithm;
-	u64	tcpRtoMin;
-	u64	tcpRtoMax;
-	u64	tcpMaxConn;
-	u64	tcpActiveOpens;
-	u64	tcpPassiveOpens;
-	u64	tcpAttemptFails;
-	u64	tcpEstabResets;
-	u64	tcpCurrEstab;
-	u64	tcpInSegs;
-	u64	tcpOutSegs;
-	u64	tcpRetransSegs;
-	u64	tcpInErrs;
-	u64	tcpOutRsts;
-};
-
-union rdma_protocol_stats {
-	struct ib_protocol_stats	ib;
-	struct iw_protocol_stats	iw;
+struct rdma_protocol_stats {
+	unsigned long	timestamp; /* when did we last update the counters */
+	unsigned long	lifespan; /* how long should the counters be considered
+				   * valid, presented to user in milliseconds,
+				   * but stored in jiffies
+				   */
+	char		*dirname; /* Sysfs directory name */
+	char		**name;   /* array of names of the counters in the
+				   * sysfs dir
+				   */
+	int		num_counters;
+	u64		value[]; /* The actual counters, array dynamically
+				  * sized based upon number of names
+				  */
 };
 
 /* Define bits for the various functionality this port needs to be supported by
@@ -1707,8 +1672,11 @@ struct ib_device {
 
 	struct iw_cm_verbs	     *iwcm;
 
+	struct rdma_protocol_stats *(*alloc_protocol_stats)(struct ib_device *device,
+							    u8 port_num);
 	int		           (*get_protocol_stats)(struct ib_device *device,
-							 union rdma_protocol_stats *stats);
+							 struct rdma_protocol_stats *stats,
+							 u8 port);
 	int		           (*query_device)(struct ib_device *device,
 						   struct ib_device_attr *device_attr,
 						   struct ib_udata *udata);
@@ -1926,6 +1894,8 @@ struct ib_device {
 	u8                           node_type;
 	u8                           phys_port_cnt;
 	struct ib_device_attr        attrs;
+	struct attribute_group	     *prot_stats_attr_group;
+	struct rdma_protocol_stats   *prot_stats;
 
 	/**
 	 * The following mandatory functions are used only at device
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
