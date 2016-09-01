From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH for-next 02/10] IB/hns: Register add_gid and del_gid for GID Table management
Date: Fri, 2 Sep 2016 05:37:17 +0800
Message-ID: <1472765845-118972-3-git-send-email-salil.mehta@huawei.com>
References: <1472765845-118972-1-git-send-email-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1472765845-118972-1-git-send-email-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: salil.mehta@huawei.com, xavier.huwei@huawei.com, oulijun@huawei.com, yisen.zhuang@huawei.com, mehta.salil.lnk@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

This patch adds support of add_gid() and del_gid() function in the
HNS RoCE driver for manipulation of the GID table associated with
port. This shall be used be used by CM when connection is
established.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Reviewed-by: Wei Hu <xavier.huwei@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_main.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index 39e69c3..4e93120 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -158,6 +158,19 @@ static void hns_roce_update_gids(struct hns_roce_dev *hr_dev, int port)
 	ib_dispatch_event(&event);
 }
 
+static int hns_roce_add_gid(struct ib_device *device, u8 port_num,
+			    unsigned int index, const union ib_gid *gid,
+			    const struct ib_gid_attr *attr, void **context)
+{
+	return 0;
+}
+
+static int hns_roce_del_gid(struct ib_device *device, u8 port_num,
+			    unsigned int index, void **context)
+{
+	return 0;
+}
+
 static int handle_en_event(struct hns_roce_dev *hr_dev, u8 port,
 			   unsigned long event)
 {
@@ -639,6 +652,8 @@ static int hns_roce_register_device(struct hns_roce_dev *hr_dev)
 	ib_dev->get_link_layer		= hns_roce_get_link_layer;
 	ib_dev->get_netdev		= hns_roce_get_netdev;
 	ib_dev->query_gid		= hns_roce_query_gid;
+	ib_dev->add_gid			= hns_roce_add_gid;
+	ib_dev->del_gid			= hns_roce_del_gid;
 	ib_dev->query_pkey		= hns_roce_query_pkey;
 	ib_dev->alloc_ucontext		= hns_roce_alloc_ucontext;
 	ib_dev->dealloc_ucontext	= hns_roce_dealloc_ucontext;
-- 
1.7.9.5
