From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: [PATCH V3 rdma-next 4/4] RDMA/hns: Implement the disassociate_ucontext API
Date: Sat, 26 May 2018 16:41:47 +0800
Message-ID: <1527324107-56593-5-git-send-email-xavier.huwei@huawei.com>
References: <1527324107-56593-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1527324107-56593-1-git-send-email-xavier.huwei@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, xavier.huwei@huawei.com, lijun_nudt@163.com, oulijun@huawei.com, charles.chenxin@huawei.com, linux-kernel@vger.kernel.org, leonro@mellanox.com
List-Id: linux-rdma@vger.kernel.org

This patch implemented the IB core disassociate_ucontext API.

Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>

---
v2->v3: Addressed the comments from Jason. The related link:
	https://lkml.org/lkml/2018/5/22/967
v1->v2: no change.
---
 drivers/infiniband/hw/hns/hns_roce_device.h |  8 ++++
 drivers/infiniband/hw/hns/hns_roce_main.c   | 70 ++++++++++++++++++++++++++++-
 2 files changed, 77 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index da8512b..31221d5 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -217,11 +217,19 @@ struct hns_roce_uar {
 	unsigned long	logic_idx;
 };
 
+struct hns_roce_vma_data {
+	struct list_head list;
+	struct vm_area_struct *vma;
+	struct mutex *vma_list_mutex;
+};
+
 struct hns_roce_ucontext {
 	struct ib_ucontext	ibucontext;
 	struct hns_roce_uar	uar;
 	struct list_head	page_list;
 	struct mutex		page_mutex;
+	struct list_head	vma_list;
+	struct mutex		vma_list_mutex;
 };
 
 struct hns_roce_pd {
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index ac51372..42296f0 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -345,6 +345,8 @@ static struct ib_ucontext *hns_roce_alloc_ucontext(struct ib_device *ib_dev,
 	if (ret)
 		goto error_fail_uar_alloc;
 
+	INIT_LIST_HEAD(&context->vma_list);
+	mutex_init(&context->vma_list_mutex);
 	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RECORD_DB) {
 		INIT_LIST_HEAD(&context->page_list);
 		mutex_init(&context->page_mutex);
@@ -375,6 +377,50 @@ static int hns_roce_dealloc_ucontext(struct ib_ucontext *ibcontext)
 	return 0;
 }
 
+static void hns_roce_vma_open(struct vm_area_struct *vma)
+{
+	vma->vm_ops = NULL;
+}
+
+static void hns_roce_vma_close(struct vm_area_struct *vma)
+{
+	struct hns_roce_vma_data *vma_data;
+
+	vma_data = (struct hns_roce_vma_data *)vma->vm_private_data;
+	vma_data->vma = NULL;
+	mutex_lock(vma_data->vma_list_mutex);
+	list_del(&vma_data->list);
+	mutex_unlock(vma_data->vma_list_mutex);
+	kfree(vma_data);
+}
+
+static const struct vm_operations_struct hns_roce_vm_ops = {
+	.open = hns_roce_vma_open,
+	.close = hns_roce_vma_close,
+};
+
+static int hns_roce_set_vma_data(struct vm_area_struct *vma,
+				 struct hns_roce_ucontext *context)
+{
+	struct list_head *vma_head = &context->vma_list;
+	struct hns_roce_vma_data *vma_data;
+
+	vma_data = kzalloc(sizeof(*vma_data), GFP_KERNEL);
+	if (!vma_data)
+		return -ENOMEM;
+
+	vma_data->vma = vma;
+	vma_data->vma_list_mutex = &context->vma_list_mutex;
+	vma->vm_private_data = vma_data;
+	vma->vm_ops = &hns_roce_vm_ops;
+
+	mutex_lock(&context->vma_list_mutex);
+	list_add(&vma_data->list, vma_head);
+	mutex_unlock(&context->vma_list_mutex);
+
+	return 0;
+}
+
 static int hns_roce_mmap(struct ib_ucontext *context,
 			 struct vm_area_struct *vma)
 {
@@ -400,7 +446,7 @@ static int hns_roce_mmap(struct ib_ucontext *context,
 	} else
 		return -EINVAL;
 
-	return 0;
+	return hns_roce_set_vma_data(vma, to_hr_ucontext(context));
 }
 
 static int hns_roce_port_immutable(struct ib_device *ib_dev, u8 port_num,
@@ -424,6 +470,27 @@ static int hns_roce_port_immutable(struct ib_device *ib_dev, u8 port_num,
 	return 0;
 }
 
+static void hns_roce_disassociate_ucontext(struct ib_ucontext *ibcontext)
+{
+	struct hns_roce_ucontext *context = to_hr_ucontext(ibcontext);
+	struct hns_roce_vma_data *vma_data, *n;
+	struct vm_area_struct *vma;
+	int ret;
+
+	mutex_lock(&context->vma_list_mutex);
+	list_for_each_entry_safe(vma_data, n, &context->vma_list, list) {
+		vma = vma_data->vma;
+		ret = zap_vma_ptes(vma, vma->vm_start, PAGE_SIZE);
+		WARN_ONCE(ret, "%s: zap_vma_ptes failed", __func__);
+
+		vma->vm_flags &= ~(VM_SHARED | VM_MAYSHARE);
+		vma->vm_ops = NULL;
+		list_del(&vma_data->list);
+		kfree(vma_data);
+	}
+	mutex_unlock(&context->vma_list_mutex);
+}
+
 static void hns_roce_unregister_device(struct hns_roce_dev *hr_dev)
 {
 	struct hns_roce_ib_iboe *iboe = &hr_dev->iboe;
@@ -519,6 +586,7 @@ static int hns_roce_register_device(struct hns_roce_dev *hr_dev)
 
 	/* OTHERS */
 	ib_dev->get_port_immutable	= hns_roce_port_immutable;
+	ib_dev->disassociate_ucontext	= hns_roce_disassociate_ucontext;
 
 	ib_dev->driver_id = RDMA_DRIVER_HNS;
 	ret = ib_register_device(ib_dev, NULL);
-- 
1.9.1
