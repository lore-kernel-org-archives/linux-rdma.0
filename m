From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/3] ib core: Make device counter infrastructure dynamic
Date: Tue, 15 Mar 2016 10:54:42 -0500
Message-ID: <20160315155455.173645653@linux.com>
References: <20160315155441.222586021@linux.com>
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=ib_counter_infrastructure
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, alonvi-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The current approach in ib_verbs.h is to define a struct with
statistics fields. ib_verbs is an abstraction layer for
device drivers and the protocol_stats should be abstract. However,
in practice these are actually device specific counters (also used
in such a way in Mellanox OFED). The device stats are a union
and in practice evolve to a union of device specific stats.

ARGH!!!

This should not be defined in a concrete way in ib_verbs.h since the
API definition needs to be device neutral.

What we need is an API that can return an arbitrary number
of counters that may be general or device specific.

Here we simply define an array of strings that describe the
counters and an array of 64 bit counters that are
displayed through sysfs. This makes ib_verbs API appropriately
abstract and device drivers do not need to update ib_verbs.h
(and thus break the API) to add more counters,.

This patch is groundwork to later define the protocol stats for
Mellanox devices.

The strings being used in the device drives should only be present
if the driver actually supports those counters. If there is
a standardized name then devices should use the same name
as in other infiniband device drivers.

Note on cxgb3/4 portions:
- I was unable to test because of the lack of hardware
- The counters that are never incremented were omitted. There may be the
  impression that less counter are supported. But the other counters
  have never been supported.

Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Index: linux/drivers/infiniband/core/sysfs.c
===================================================================
--- linux.orig/drivers/infiniband/core/sysfs.c
+++ linux/drivers/infiniband/core/sysfs.c
@@ -58,6 +58,7 @@ struct ib_port {
 	struct attribute_group pkey_group;
 	u8                     port_num;
 	struct attribute_group *pma_table;
+	struct attribute_group *ag;
 };
 
 struct port_attribute {
@@ -80,6 +81,16 @@ struct port_table_attribute {
 	__be16			attr_id;
 };
 
+struct ib_port_stats {
+	struct port_attribute	attr;
+	u32			index;
+};
+
+struct ib_device_stats {
+	struct device_attribute	attr;
+	u32			index;
+};
+
 static ssize_t port_attr_show(struct kobject *kobj,
 			      struct attribute *attr, char *buf)
 {
@@ -733,6 +744,151 @@ static struct attribute_group *get_count
 	return &pma_group;
 }
 
+static ssize_t show_protocol_stats(struct ib_device *dev, int index,
+				   u8 port, char *buf)
+{
+	struct rdma_protocol_stats stats = {0};
+	ssize_t ret;
+
+	ret = dev->get_protocol_stats(dev, &stats, port);
+	if (ret)
+		return ret;
+
+	return sprintf(buf, "%llu\n", stats.value[index]);
+}
+
+static ssize_t show_device_protocol_stats(struct device *device,
+					  struct device_attribute *attr,
+					  char *buf)
+{
+	struct ib_device *dev = container_of(device, struct ib_device, dev);
+	struct ib_device_stats *ds;
+
+	ds = container_of(attr, struct ib_device_stats, attr);
+	return show_protocol_stats(dev, ds->index, 0, buf);
+}
+
+static ssize_t show_port_protocol_stats(struct ib_port *p,
+					struct port_attribute *attr,
+					char *buf)
+{
+	struct ib_port_stats *ps;
+
+	ps = container_of(attr, struct ib_port_stats, attr);
+	return	show_protocol_stats(p->ibdev, ps->index, p->port_num, buf);
+}
+
+static void free_protocol_stats(struct kobject *kobj,
+				struct attribute_group *ag)
+{
+	struct attribute **da;
+
+	sysfs_remove_group(kobj, ag);
+
+	for (da = ag->attrs; *da; da++)
+		kfree(*da);
+
+	kfree(ag->attrs);
+	kfree(ag);
+}
+
+static struct attribute *alloc_stats_port(u32 index, u8 port, char *name)
+{
+	struct ib_port_stats *ps;
+
+	ps = kmalloc(sizeof(*ps), GFP_KERNEL);
+	if (!ps)
+		return NULL;
+
+	ps->attr.attr.name = name;
+	ps->attr.attr.mode = S_IRUGO;
+	ps->attr.show = show_port_protocol_stats;
+	ps->attr.store = NULL;
+	ps->index = index;
+
+	return &ps->attr.attr;
+}
+
+static struct attribute *alloc_stats_device(u32 index, u8 port, char *name)
+{
+	struct ib_device_stats *da;
+
+	da = kmalloc(sizeof(*da), GFP_KERNEL);
+	if (!da)
+		return NULL;
+
+	da->attr.attr.name = name;
+	da->attr.attr.mode = S_IRUGO;
+	da->attr.show = show_device_protocol_stats;
+	da->attr.store = NULL;
+	da->index = index;
+
+	return &da->attr.attr;
+}
+
+static struct attribute *alloc_stats_attribute(u32 index, u8 port, char *name)
+{
+	return (port) ? alloc_stats_port(index, port, name) :
+		alloc_stats_device(index, port, name);
+}
+
+static struct attribute_group *create_protocol_stats(struct ib_device *device,
+						     struct kobject *kobj,
+						     u8 port) {
+	struct attribute_group *ag;
+	struct rdma_protocol_stats stats = {0};
+	u32 counters;
+	u32 i;
+	int ret;
+
+	ret = device->get_protocol_stats(device, &stats, port);
+
+	if (ret || !stats.name)
+		return NULL;
+
+	ag = kzalloc(sizeof(*ag), GFP_KERNEL);
+	if (!ag)
+		return NULL;
+
+	ag->name = stats.dirname;
+
+	for (counters = 0; stats.name[counters]; counters++)
+		;
+
+	BUG_ON(counters > MAX_NR_PROTOCOL_STATS);
+
+	ag->attrs = kcalloc((counters + 1), sizeof(struct attribute *),
+			    GFP_KERNEL);
+	if (!ag->attrs)
+		goto nomem;
+
+	for (i = 0; i < counters; i++) {
+		struct attribute *attr;
+
+		attr = alloc_stats_attribute(i, port, stats.name[i]);
+		if (!attr)
+			goto nomem2;
+
+		ag->attrs[i] = attr;
+	}
+	ag->attrs[counters] = NULL;
+
+	ret = sysfs_create_group(kobj, ag);
+
+	if (ret)
+		goto nomem2;
+
+	return ag;
+nomem2:
+	for (i = 0; i < counters; i++)
+		kfree(ag->attrs[i]);
+
+	kfree(ag->attrs);
+nomem:
+	kfree(ag);
+	return NULL;
+}
+
 static int add_port(struct ib_device *device, int port_num,
 		    int (*port_callback)(struct ib_device *,
 					 u8, struct kobject *))
@@ -835,6 +991,12 @@ static int add_port(struct ib_device *de
 			goto err_remove_pkey;
 	}
 
+	/* If port == 0, it means we have only one port, so the device should
+	 * hold the protocol stats
+	 */
+	if (device->get_protocol_stats && port_num)
+		p->ag = create_protocol_stats(device, &p->kobj, port_num);
+
 	list_add_tail(&p->kobj.entry, &device->port_list);
 
 	kobject_uevent(&p->kobj, KOBJ_ADD);
@@ -972,120 +1134,6 @@ static struct device_attribute *ib_class
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
@@ -1093,6 +1141,8 @@ static void free_port_list_attributes(st
 	list_for_each_entry_safe(p, t, &device->port_list, entry) {
 		struct ib_port *port = container_of(p, struct ib_port, kobj);
 		list_del(&p->entry);
+		if (port->ag)
+			free_protocol_stats(&port->kobj, port->ag);
 		sysfs_remove_group(p, port->pma_table);
 		sysfs_remove_group(p, &port->pkey_group);
 		sysfs_remove_group(p, &port->gid_group);
@@ -1149,12 +1199,14 @@ int ib_device_register_sysfs(struct ib_d
 		}
 	}
 
-	if (device->node_type == RDMA_NODE_RNIC && device->get_protocol_stats) {
-		ret = sysfs_create_group(&class_dev->kobj, &iw_stats_group);
-		if (ret)
-			goto err_put;
-	}
+	if (!device->get_protocol_stats)
+		return 0;
+
+	device->ag = create_protocol_stats(device, &class_dev->kobj, 0);
 
+	/* If create_protocol_stats returns NULL it might not be a failure, so
+	 * do nothing
+	 */
 	return 0;
 
 err_put:
@@ -1169,15 +1221,13 @@ err:
 
 void ib_device_unregister_sysfs(struct ib_device *device)
 {
-	/* Hold kobject until ib_dealloc_device() */
-	struct kobject *kobj_dev = kobject_get(&device->dev.kobj);
 	int i;
 
-	if (device->node_type == RDMA_NODE_RNIC && device->get_protocol_stats)
-		sysfs_remove_group(kobj_dev, &iw_stats_group);
-
 	free_port_list_attributes(device);
 
+	if (device->ag)
+		free_protocol_stats(&device->dev.kobj, device->ag);
+
 	for (i = 0; i < ARRAY_SIZE(ib_class_attributes); ++i)
 		device_remove_file(&device->dev, ib_class_attributes[i]);
 
Index: linux/drivers/infiniband/hw/cxgb3/iwch_provider.c
===================================================================
--- linux.orig/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ linux/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -1218,12 +1218,46 @@ static ssize_t show_board(struct device
 		       iwch_dev->rdev.rnic_info.pdev->device);
 }
 
+char *names[] = {
+	"ipInReceives",
+	"ipInHdrErrors",
+	"ipInAddrErrors",
+	"ipInUnknownProtos",
+	"ipInDiscards",
+	"ipInDelivers",
+	"ipOutRequests",
+	"ipOutDiscards",
+	"ipOutNoRoutes",
+	"ipReasmTimeout",
+	"ipReasmReqds",
+	"ipReasmOKs",
+	"ipReasmFails",
+	"tcpActiveOpens",
+	"tcpPassiveOpens",
+	"tcpAttemptFails",
+	"tcpEstabResets",
+	"tcpCurrEstab",
+	"tcpInSegs",
+	"tcpOutSegs",
+	"tcpRetransSegs",
+	"tcpInErrs",
+	"tcpOutRsts",
+	"tcpRtoMin",
+	"tcpRtoMax",
+	NULL
+};
+
 static int iwch_get_mib(struct ib_device *ibdev,
-			union rdma_protocol_stats *stats)
+			struct rdma_protocol_stats *stats,
+			u8 port)
 {
 	struct iwch_dev *dev;
 	struct tp_mib_stats m;
 	int ret;
+	u64 *p;
+
+	if (port != 0)
+		return 0;
 
 	PDBG("%s ibdev %p\n", __func__, ibdev);
 	dev = to_iwch_dev(ibdev);
@@ -1231,45 +1265,53 @@ static int iwch_get_mib(struct ib_device
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
+	stats->dirname = "iw_stats";
+	stats->name = names;
+
+	p = stats->value;
+	*p++ = ((u64)m.ipInReceive_hi << 32) +
+		m.ipInReceive_lo;
+	*p++ = ((u64)m.ipInHdrErrors_hi << 32) +
+		m.ipInHdrErrors_lo;
+	*p++ = ((u64)m.ipInAddrErrors_hi << 32) +
+		m.ipInAddrErrors_lo;
+	*p++ = ((u64)m.ipInUnknownProtos_hi << 32) +
+		m.ipInUnknownProtos_lo;
+	*p++ = ((u64)m.ipInDiscards_hi << 32) +
+		m.ipInDiscards_lo;
+	*p++ = ((u64)m.ipInDelivers_hi << 32) +
+		m.ipInDelivers_lo;
+	*p++ = ((u64)m.ipOutRequests_hi << 32) +
+		m.ipOutRequests_lo;
+	*p++ = ((u64)m.ipOutDiscards_hi << 32) +
+		m.ipOutDiscards_lo;
+	*p++ = ((u64)m.ipOutNoRoutes_hi << 32) +
+		m.ipOutNoRoutes_lo;
+	*p++ = (u64)m.ipReasmTimeout;
+	*p++ = (u64)m.ipReasmReqds;
+	*p++ = (u64)m.ipReasmOKs;
+	*p++ = (u64)m.ipReasmFails;
+	*p++ = (u64)m.tcpActiveOpens;
+	*p++ = (u64)m.tcpPassiveOpens;
+	*p++ = (u64)m.tcpAttemptFails;
+	*p++ = (u64)m.tcpEstabResets;
+	*p++ = (u64)m.tcpOutRsts;
+	*p++ = (u64)m.tcpCurrEstab;
+	*p++ = ((u64)m.tcpInSegs_hi << 32) +
+		m.tcpInSegs_lo;
+	*p++ = ((u64)m.tcpOutSegs_hi << 32) +
+		m.tcpOutSegs_lo;
+	*p++ = ((u64)m.tcpRetransSeg_hi << 32) +
+		m.tcpRetransSeg_lo;
+	*p++ = ((u64)m.tcpInErrs_hi << 32) +
+		m.tcpInErrs_lo;
+	*p++ = (u64)m.tcpRtoMin;
+	*p++ = (u64)m.tcpRtoMax;
+
+	/* Emsure we provided all values */
+	BUG_ON(p - stats->value !=
+	       (sizeof(names) / sizeof(char *)) - 1);
+
 	return 0;
 }
 
Index: linux/drivers/infiniband/hw/cxgb4/provider.c
===================================================================
--- linux.orig/drivers/infiniband/hw/cxgb4/provider.c
+++ linux/drivers/infiniband/hw/cxgb4/provider.c
@@ -445,18 +445,32 @@ static ssize_t show_board(struct device
 		       c4iw_dev->rdev.lldi.pdev->device);
 }
 
+static char *names[] = {
+	"tcpInSegs",
+	"tcpOutSegs",
+	"tcpRetransSegs",
+	"tcpOutRsts",
+	NULL
+};
+
 static int c4iw_get_mib(struct ib_device *ibdev,
-			union rdma_protocol_stats *stats)
+			struct rdma_protocol_stats *stats,
+			u8 port)
 {
 	struct tp_tcp_stats v4, v6;
 	struct c4iw_dev *c4iw_dev = to_c4iw_dev(ibdev);
 
+	if (port != 0)
+		return 0;
+
 	cxgb4_get_tcp_stats(c4iw_dev->rdev.lldi.pdev, &v4, &v6);
-	memset(stats, 0, sizeof *stats);
-	stats->iw.tcpInSegs = v4.tcp_in_segs + v6.tcp_in_segs;
-	stats->iw.tcpOutSegs = v4.tcp_out_segs + v6.tcp_out_segs;
-	stats->iw.tcpRetransSegs = v4.tcp_retrans_segs + v6.tcp_retrans_segs;
-	stats->iw.tcpOutRsts = v4.tcp_out_rsts + v6.tcp_out_rsts;
+	stats->value[0] = v4.tcp_in_segs + v6.tcp_in_segs;
+	stats->value[1] = v4.tcp_out_segs + v6.tcp_out_segs;
+	stats->value[2] = v4.tcp_retrans_segs + v6.tcp_retrans_segs;
+	stats->value[3] = v4.tcp_out_rsts + v6.tcp_out_rsts;
+
+	stats->name = names;
+	stats->dirname = "iw_stats";
 
 	return 0;
 }
Index: linux/include/rdma/ib_verbs.h
===================================================================
--- linux.orig/include/rdma/ib_verbs.h
+++ linux/include/rdma/ib_verbs.h
@@ -394,55 +394,13 @@ enum ib_port_speed {
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
+#define MAX_NR_PROTOCOL_STATS 120
+struct rdma_protocol_stats {
+	char *dirname;		/* Directory name */
+	char **name;		/* NULL terminated list of strings for the names
+				 * of the counters
+				 */
+	u64 value[MAX_NR_PROTOCOL_STATS];
 };
 
 /* Define bits for the various functionality this port needs to be supported by
@@ -1665,7 +1623,8 @@ struct ib_device {
 	struct iw_cm_verbs	     *iwcm;
 
 	int		           (*get_protocol_stats)(struct ib_device *device,
-							 union rdma_protocol_stats *stats);
+							 struct rdma_protocol_stats *stats,
+							 u8 port);
 	int		           (*query_device)(struct ib_device *device,
 						   struct ib_device_attr *device_attr,
 						   struct ib_udata *udata);
@@ -1871,6 +1830,7 @@ struct ib_device {
 	u8                           node_type;
 	u8                           phys_port_cnt;
 	struct ib_device_attr        attrs;
+	struct attribute_group	     *ag;
 
 	/**
 	 * The following mandatory functions are used only at device

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
