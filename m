From: Logan Gunthorpe <logang@deltatee.com>
Subject: [PATCH v7 13/13] nvmet: Optionally use PCI P2P memory
Date: Tue, 25 Sep 2018 10:22:31 -0600
Message-ID: <20180925162231.4354-14-logang@deltatee.com>
References: <20180925162231.4354-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180925162231.4354-1-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: Stephen Bates <sbates@raithlin.com>, Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Bjorn Helgaas <bhelgaas@google.com>, Jason Gunthorpe <jgg@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, Jens Axboe <axboe@kernel.dk>, Logan Gunthorpe <logang@deltatee.com>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org

We create a configfs attribute in each nvme-fabrics target port to
enable p2p memory use. When enabled, the port will only then use the
p2p memory if a p2p memory device can be found which is behind the
same switch hierarchy as the RDMA port and all the block devices in
use. If the user enabled it and no devices are found, then the system
will silently fall back on using regular memory.

If appropriate, that port will allocate memory for the RDMA buffers
for queues from the p2pmem device falling back to system memory should
anything fail.

Ideally, we'd want to use an NVME CMB buffer as p2p memory. This would
save an extra PCI transfer as the NVME card could just take the data
out of it's own memory. However, at this time, only a limited number
of cards with CMB buffers seem to be available.

Signed-off-by: Stephen Bates <sbates@raithlin.com>
Signed-off-by: Steve Wise <swise@opengridcomputing.com>
[hch: partial rewrite of the initial code]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/nvme/target/configfs.c    |  36 ++++++++
 drivers/nvme/target/core.c        | 138 +++++++++++++++++++++++++++++-
 drivers/nvme/target/io-cmd-bdev.c |   3 +
 drivers/nvme/target/nvmet.h       |  13 +++
 drivers/nvme/target/rdma.c        |   2 +
 5 files changed, 191 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index b37a8e3e3f80..0dfb0e0c3d21 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -17,6 +17,8 @@
 #include <linux/slab.h>
 #include <linux/stat.h>
 #include <linux/ctype.h>
+#include <linux/pci.h>
+#include <linux/pci-p2pdma.h>
 
 #include "nvmet.h"
 
@@ -1094,6 +1096,37 @@ static void nvmet_port_release(struct config_item *item)
 	kfree(port);
 }
 
+#ifdef CONFIG_PCI_P2PDMA
+static ssize_t nvmet_p2pmem_show(struct config_item *item, char *page)
+{
+	struct nvmet_port *port = to_nvmet_port(item);
+
+	return pci_p2pdma_enable_show(page, port->p2p_dev, port->use_p2pmem);
+}
+
+static ssize_t nvmet_p2pmem_store(struct config_item *item,
+		const char *page, size_t count)
+{
+	struct nvmet_port *port = to_nvmet_port(item);
+	struct pci_dev *p2p_dev = NULL;
+	bool use_p2pmem;
+	int error;
+
+	error = pci_p2pdma_enable_store(page, &p2p_dev, &use_p2pmem);
+	if (error)
+		return error;
+
+	down_write(&nvmet_config_sem);
+	port->use_p2pmem = use_p2pmem;
+	pci_dev_put(port->p2p_dev);
+	port->p2p_dev = p2p_dev;
+	up_write(&nvmet_config_sem);
+
+	return count;
+}
+CONFIGFS_ATTR(nvmet_, p2pmem);
+#endif /* CONFIG_PCI_P2PDMA */
+
 static struct configfs_attribute *nvmet_port_attrs[] = {
 	&nvmet_attr_addr_adrfam,
 	&nvmet_attr_addr_treq,
@@ -1101,6 +1134,9 @@ static struct configfs_attribute *nvmet_port_attrs[] = {
 	&nvmet_attr_addr_trsvcid,
 	&nvmet_attr_addr_trtype,
 	&nvmet_attr_param_inline_data_size,
+#ifdef CONFIG_PCI_P2PDMA
+	&nvmet_attr_p2pmem,
+#endif
 	NULL,
 };
 
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index bddd1599b826..7ade16cb4ed3 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/random.h>
 #include <linux/rculist.h>
+#include <linux/pci-p2pdma.h>
 
 #include "nvmet.h"
 
@@ -365,9 +366,29 @@ static void nvmet_ns_dev_disable(struct nvmet_ns *ns)
 	nvmet_file_ns_disable(ns);
 }
 
+static int nvmet_p2pdma_add_client(struct nvmet_ctrl *ctrl,
+		struct nvmet_ns *ns)
+{
+	int ret;
+
+	if (!blk_queue_pci_p2pdma(ns->bdev->bd_queue)) {
+		pr_err("peer-to-peer DMA is not supported by %s\n",
+		       ns->device_path);
+		return -EINVAL;
+	}
+
+	ret = pci_p2pdma_add_client(&ctrl->p2p_clients, nvmet_ns_dev(ns));
+	if (ret)
+		pr_err("failed to add peer-to-peer DMA client %s: %d\n",
+		       ns->device_path, ret);
+
+	return ret;
+}
+
 int nvmet_ns_enable(struct nvmet_ns *ns)
 {
 	struct nvmet_subsys *subsys = ns->subsys;
+	struct nvmet_ctrl *ctrl;
 	int ret;
 
 	mutex_lock(&subsys->lock);
@@ -389,6 +410,14 @@ int nvmet_ns_enable(struct nvmet_ns *ns)
 	if (ret)
 		goto out_dev_put;
 
+	list_for_each_entry(ctrl, &subsys->ctrls, subsys_entry) {
+		if (ctrl->p2p_dev) {
+			ret = nvmet_p2pdma_add_client(ctrl, ns);
+			if (ret)
+				goto out_remove_clients;
+		}
+	}
+
 	if (ns->nsid > subsys->max_nsid)
 		subsys->max_nsid = ns->nsid;
 
@@ -417,6 +446,9 @@ int nvmet_ns_enable(struct nvmet_ns *ns)
 out_unlock:
 	mutex_unlock(&subsys->lock);
 	return ret;
+out_remove_clients:
+	list_for_each_entry(ctrl, &subsys->ctrls, subsys_entry)
+		pci_p2pdma_remove_client(&ctrl->p2p_clients, nvmet_ns_dev(ns));
 out_dev_put:
 	nvmet_ns_dev_disable(ns);
 	goto out_unlock;
@@ -425,6 +457,7 @@ int nvmet_ns_enable(struct nvmet_ns *ns)
 void nvmet_ns_disable(struct nvmet_ns *ns)
 {
 	struct nvmet_subsys *subsys = ns->subsys;
+	struct nvmet_ctrl *ctrl;
 
 	mutex_lock(&subsys->lock);
 	if (!ns->enabled)
@@ -450,6 +483,12 @@ void nvmet_ns_disable(struct nvmet_ns *ns)
 	percpu_ref_exit(&ns->ref);
 
 	mutex_lock(&subsys->lock);
+
+	list_for_each_entry(ctrl, &subsys->ctrls, subsys_entry) {
+		pci_p2pdma_remove_client(&ctrl->p2p_clients, nvmet_ns_dev(ns));
+		nvmet_add_async_event(ctrl, NVME_AER_TYPE_NOTICE, 0, 0);
+	}
+
 	subsys->nr_namespaces--;
 	nvmet_ns_changed(subsys, ns->nsid);
 	nvmet_ns_dev_disable(ns);
@@ -727,6 +766,23 @@ EXPORT_SYMBOL_GPL(nvmet_req_execute);
 
 int nvmet_req_alloc_sgl(struct nvmet_req *req, struct nvmet_sq *sq)
 {
+	struct pci_dev *p2p_dev = NULL;
+
+	if (IS_ENABLED(CONFIG_PCI_P2PDMA)) {
+		if (sq->ctrl)
+			p2p_dev = sq->ctrl->p2p_dev;
+
+		req->p2p_dev = NULL;
+		if (sq->qid && p2p_dev) {
+			req->sg = pci_p2pmem_alloc_sgl(p2p_dev, &req->sg_cnt,
+						       req->transfer_len);
+			if (req->sg) {
+				req->p2p_dev = p2p_dev;
+				return 0;
+			}
+		}
+	}
+
 	req->sg = sgl_alloc(req->transfer_len, GFP_KERNEL, &req->sg_cnt);
 	if (!req->sg)
 		return -ENOMEM;
@@ -737,7 +793,11 @@ EXPORT_SYMBOL_GPL(nvmet_req_alloc_sgl);
 
 void nvmet_req_free_sgl(struct nvmet_req *req)
 {
-	sgl_free(req->sg);
+	if (req->p2p_dev)
+		pci_p2pmem_free_sgl(req->p2p_dev, req->sg);
+	else
+		sgl_free(req->sg);
+
 	req->sg = NULL;
 	req->sg_cnt = 0;
 }
@@ -939,6 +999,79 @@ bool nvmet_host_allowed(struct nvmet_req *req, struct nvmet_subsys *subsys,
 		return __nvmet_host_allowed(subsys, hostnqn);
 }
 
+/*
+ * If allow_p2pmem is set, we will try to use P2P memory for the SGL lists for
+ * Ι/O commands. This requires the PCI p2p device to be compatible with the
+ * backing device for every namespace on this controller.
+ */
+static void nvmet_setup_p2pmem(struct nvmet_ctrl *ctrl, struct nvmet_req *req)
+{
+	struct nvmet_ns *ns;
+	int ret;
+
+	if (!req->port->use_p2pmem || !req->p2p_client)
+		return;
+
+	mutex_lock(&ctrl->subsys->lock);
+
+	ret = pci_p2pdma_add_client(&ctrl->p2p_clients, req->p2p_client);
+	if (ret) {
+		pr_err("failed adding peer-to-peer DMA client %s: %d\n",
+		       dev_name(req->p2p_client), ret);
+		goto free_devices;
+	}
+
+	list_for_each_entry_rcu(ns, &ctrl->subsys->namespaces, dev_link) {
+		ret = nvmet_p2pdma_add_client(ctrl, ns);
+		if (ret)
+			goto free_devices;
+	}
+
+	if (req->port->p2p_dev) {
+		/* A specific P2P device was selected in configfs */
+		if (!pci_p2pdma_assign_provider(req->port->p2p_dev,
+						&ctrl->p2p_clients)) {
+			pr_info("peer-to-peer memory on %s is not supported\n",
+				pci_name(req->port->p2p_dev));
+			goto free_devices;
+		}
+		ctrl->p2p_dev = pci_dev_get(req->port->p2p_dev);
+	} else {
+		/*
+		 * No P2P device was provided in configfs, therefore find one
+		 * automatically.
+		 */
+		ctrl->p2p_dev = pci_p2pmem_find(&ctrl->p2p_clients);
+		if (!ctrl->p2p_dev) {
+			pr_info("no supported peer-to-peer memory devices found\n");
+			goto free_devices;
+		}
+	}
+
+	mutex_unlock(&ctrl->subsys->lock);
+
+	pr_info("using peer-to-peer memory on %s\n", pci_name(ctrl->p2p_dev));
+	return;
+
+free_devices:
+	pci_p2pdma_client_list_free(&ctrl->p2p_clients);
+	mutex_unlock(&ctrl->subsys->lock);
+}
+
+static void nvmet_release_p2pmem(struct nvmet_ctrl *ctrl)
+{
+	if (!ctrl->p2p_dev)
+		return;
+
+	mutex_lock(&ctrl->subsys->lock);
+
+	pci_p2pdma_client_list_free(&ctrl->p2p_clients);
+	pci_dev_put(ctrl->p2p_dev);
+	ctrl->p2p_dev = NULL;
+
+	mutex_unlock(&ctrl->subsys->lock);
+}
+
 u16 nvmet_alloc_ctrl(const char *subsysnqn, const char *hostnqn,
 		struct nvmet_req *req, u32 kato, struct nvmet_ctrl **ctrlp)
 {
@@ -980,6 +1113,7 @@ u16 nvmet_alloc_ctrl(const char *subsysnqn, const char *hostnqn,
 
 	INIT_WORK(&ctrl->async_event_work, nvmet_async_event_work);
 	INIT_LIST_HEAD(&ctrl->async_events);
+	INIT_LIST_HEAD(&ctrl->p2p_clients);
 
 	memcpy(ctrl->subsysnqn, subsysnqn, NVMF_NQN_SIZE);
 	memcpy(ctrl->hostnqn, hostnqn, NVMF_NQN_SIZE);
@@ -1041,6 +1175,7 @@ u16 nvmet_alloc_ctrl(const char *subsysnqn, const char *hostnqn,
 		ctrl->kato = DIV_ROUND_UP(kato, 1000);
 	}
 	nvmet_start_keep_alive_timer(ctrl);
+	nvmet_setup_p2pmem(ctrl, req);
 
 	mutex_lock(&subsys->lock);
 	list_add_tail(&ctrl->subsys_entry, &subsys->ctrls);
@@ -1079,6 +1214,7 @@ static void nvmet_ctrl_free(struct kref *ref)
 	flush_work(&ctrl->async_event_work);
 	cancel_work_sync(&ctrl->fatal_err_work);
 
+	nvmet_release_p2pmem(ctrl);
 	ida_simple_remove(&cntlid_ida, ctrl->cntlid);
 
 	kfree(ctrl->sqs);
diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index 7bc9f6240432..5660dd7ca755 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -78,6 +78,9 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *req)
 		op = REQ_OP_READ;
 	}
 
+	if (is_pci_p2pdma_page(sg_page(req->sg)))
+		op_flags |= REQ_NOMERGE;
+
 	sector = le64_to_cpu(req->cmd->rw.slba);
 	sector <<= (req->ns->blksize_shift - 9);
 
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 7d6cb61021e4..297861064dd8 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -84,6 +84,11 @@ static inline struct nvmet_ns *to_nvmet_ns(struct config_item *item)
 	return container_of(to_config_group(item), struct nvmet_ns, group);
 }
 
+static inline struct device *nvmet_ns_dev(struct nvmet_ns *ns)
+{
+	return disk_to_dev(ns->bdev->bd_disk);
+}
+
 struct nvmet_cq {
 	u16			qid;
 	u16			size;
@@ -134,6 +139,8 @@ struct nvmet_port {
 	void				*priv;
 	bool				enabled;
 	int				inline_data_size;
+	bool				use_p2pmem;
+	struct pci_dev			*p2p_dev;
 };
 
 static inline struct nvmet_port *to_nvmet_port(struct config_item *item)
@@ -182,6 +189,9 @@ struct nvmet_ctrl {
 	__le32			*changed_ns_list;
 	u32			nr_changed_ns;
 
+	struct pci_dev		*p2p_dev;
+	struct list_head	p2p_clients;
+
 	char			subsysnqn[NVMF_NQN_FIELD_LEN];
 	char			hostnqn[NVMF_NQN_FIELD_LEN];
 };
@@ -294,6 +304,9 @@ struct nvmet_req {
 
 	void (*execute)(struct nvmet_req *req);
 	const struct nvmet_fabrics_ops *ops;
+
+	struct pci_dev *p2p_dev;
+	struct device *p2p_client;
 };
 
 extern struct workqueue_struct *buffered_io_wq;
diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index b0d0cedc74bb..e5f00449ac68 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -749,6 +749,8 @@ static void nvmet_rdma_handle_command(struct nvmet_rdma_queue *queue,
 		cmd->send_sge.addr, cmd->send_sge.length,
 		DMA_TO_DEVICE);
 
+	cmd->req.p2p_client = &queue->dev->device->dev;
+
 	if (!nvmet_req_init(&cmd->req, &queue->nvme_cq,
 			&queue->nvme_sq, &nvmet_rdma_ops))
 		return;
-- 
2.19.0
