From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH rfc 1/3] nvmet: allow assignment of a cpulist for each nvmet port
Date: Sun,  2 Jul 2017 18:01:32 +0300
Message-ID: <1499007694-7231-2-git-send-email-sagi@grimberg.me>
References: <1499007694-7231-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1499007694-7231-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Users might want to assign specific affinity in the form of
a cpumap to a nvmet port. This can make sense in multi-socket
systems where each socket is connected to a HBA (e.g. RDMA device)
and a set of backend storage devices (e.g. NVMe or other PCI
storage devices) where the user wants to provision the backend
storage via the HBA belonging to the same numa socket.

So, allow the user to pass a cpulist, however if the
underlying devices do not expose access to these mappings
the transport drivers is not obligated to enforce it so it
is merely a hint.

Default to all online cpumap.

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/nvme/target/configfs.c | 75 ++++++++++++++++++++++++++++++++++++++++++
 drivers/nvme/target/nvmet.h    |  4 +++
 2 files changed, 79 insertions(+)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index a358ecd93e11..095c2e6b4116 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -17,12 +17,63 @@
 #include <linux/slab.h>
 #include <linux/stat.h>
 #include <linux/ctype.h>
+#include <linux/cpumask.h>
 
 #include "nvmet.h"
 
 static struct config_item_type nvmet_host_type;
 static struct config_item_type nvmet_subsys_type;
 
+static ssize_t nvmet_addr_cpulist_show(struct config_item *item,
+		char *page)
+{
+	struct nvmet_port *port = to_nvmet_port(item);
+
+	return sprintf(page, "%*pbl\n", cpumask_pr_args(port->cpumask));
+}
+
+static ssize_t nvmet_addr_cpulist_store(struct config_item *item,
+		const char *page, size_t count)
+{
+	struct nvmet_port *port = to_nvmet_port(item);
+	cpumask_var_t cpumask;
+	int i, err;
+
+	if (port->enabled) {
+		pr_err("Cannot specify cpulist while enabled\n");
+		pr_err("Disable the port before changing cores\n");
+		return -EACCES;
+	}
+
+	if (!alloc_cpumask_var(&cpumask, GFP_KERNEL))
+		return -ENOMEM;
+
+	err = cpulist_parse(page, cpumask);
+	if (err) {
+		pr_err("bad cpumask given (%d): %s\n", err, page);
+		return err;
+	}
+
+	if (!cpumask_intersects(cpumask, cpu_online_mask)) {
+		pr_err("cpulist consists of offline cpus: %s\n", page);
+		return err;
+	}
+
+	/* copy cpumask */
+	cpumask_copy(port->cpumask, cpumask);
+	free_cpumask_var(cpumask);
+
+	/* clear port cpulist */
+	port->nr_cpus = 0;
+	/* reset port cpulist */
+	for_each_cpu(i, cpumask)
+		port->cpus[port->nr_cpus++] = i;
+
+	return count;
+}
+
+CONFIGFS_ATTR(nvmet_, addr_cpulist);
+
 /*
  * nvmet_port Generic ConfigFS definitions.
  * Used in any place in the ConfigFS tree that refers to an address.
@@ -821,6 +872,7 @@ static struct config_group *nvmet_referral_make(
 		return ERR_PTR(-ENOMEM);
 
 	INIT_LIST_HEAD(&port->entry);
+
 	config_group_init_type_name(&port->group, name, &nvmet_referral_type);
 
 	return &port->group;
@@ -842,6 +894,8 @@ static void nvmet_port_release(struct config_item *item)
 {
 	struct nvmet_port *port = to_nvmet_port(item);
 
+	kfree(port->cpus);
+	free_cpumask_var(port->cpumask);
 	kfree(port);
 }
 
@@ -851,6 +905,7 @@ static struct configfs_attribute *nvmet_port_attrs[] = {
 	&nvmet_attr_addr_traddr,
 	&nvmet_attr_addr_trsvcid,
 	&nvmet_attr_addr_trtype,
+	&nvmet_attr_addr_cpulist,
 	NULL,
 };
 
@@ -869,6 +924,7 @@ static struct config_group *nvmet_ports_make(struct config_group *group,
 {
 	struct nvmet_port *port;
 	u16 portid;
+	int i;
 
 	if (kstrtou16(name, 0, &portid))
 		return ERR_PTR(-EINVAL);
@@ -881,6 +937,20 @@ static struct config_group *nvmet_ports_make(struct config_group *group,
 	INIT_LIST_HEAD(&port->subsystems);
 	INIT_LIST_HEAD(&port->referrals);
 
+	if (!alloc_cpumask_var(&port->cpumask, GFP_KERNEL))
+		goto err_free_port;
+
+	port->nr_cpus = num_possible_cpus();
+
+	port->cpus = kcalloc(sizeof(int), port->nr_cpus, GFP_KERNEL);
+	if (!port->cpus)
+		goto err_free_cpumask;
+
+	for_each_possible_cpu(i) {
+		cpumask_set_cpu(i, port->cpumask);
+		port->cpus[i] = i;
+	}
+
 	port->disc_addr.portid = cpu_to_le16(portid);
 	config_group_init_type_name(&port->group, name, &nvmet_port_type);
 
@@ -893,6 +963,11 @@ static struct config_group *nvmet_ports_make(struct config_group *group,
 	configfs_add_default_group(&port->referrals_group, &port->group);
 
 	return &port->group;
+
+err_free_cpumask:
+	free_cpumask_var(port->cpumask);
+err_free_port:
+	return ERR_PTR(-ENOMEM);
 }
 
 static struct configfs_group_operations nvmet_ports_group_ops = {
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 747bbdb4f9c6..20ed676dc335 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -97,6 +97,10 @@ struct nvmet_port {
 	struct list_head		referrals;
 	void				*priv;
 	bool				enabled;
+
+	int				nr_cpus;
+	cpumask_var_t			cpumask;
+	int				*cpus;
 };
 
 static inline struct nvmet_port *to_nvmet_port(struct config_item *item)
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
