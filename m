From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH V2 for-next 1/9] IB/hns: Register HNS RoCE Driver get_netdev() with IB Core
Date: Tue, 13 Sep 2016 20:49:22 +0100
Message-ID: <20160913194930.273964-2-salil.mehta@huawei.com>
References: <20160913194930.273964-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160913194930.273964-1-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: salil.mehta@huawei.com, xavier.huwei@huawei.com, oulijun@huawei.com, yisen.zhuang@huawei.com, mehta.salil.lnk@gmail.com, xuwei5@hisilicon.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

This patch adds get_netdev() function to the IB device. This shall be
used to fetch netdev corresponding to the port number. This function
would be called by IB core(Generic CM Agent) for example, when the
RDMA connection is being established.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Reviewed-by: Wei Hu <xavier.huwei@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_main.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index f64f0dd..39e69c3 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -372,6 +372,25 @@ static int hns_roce_query_device(struct ib_device *ib_dev,
 	return 0;
 }
 
+static struct net_device *hns_roce_get_netdev(struct ib_device *ib_dev,
+					      u8 port_num)
+{
+	struct hns_roce_dev *hr_dev = to_hr_dev(ib_dev);
+	struct net_device *ndev;
+
+	if (port_num < 1 || port_num > hr_dev->caps.num_ports)
+		return NULL;
+
+	rcu_read_lock();
+
+	ndev = hr_dev->iboe.netdevs[port_num - 1];
+	if (ndev)
+		dev_hold(ndev);
+
+	rcu_read_unlock();
+	return ndev;
+}
+
 static int hns_roce_query_port(struct ib_device *ib_dev, u8 port_num,
 			       struct ib_port_attr *props)
 {
@@ -618,6 +637,7 @@ static int hns_roce_register_device(struct hns_roce_dev *hr_dev)
 	ib_dev->query_port		= hns_roce_query_port;
 	ib_dev->modify_port		= hns_roce_modify_port;
 	ib_dev->get_link_layer		= hns_roce_get_link_layer;
+	ib_dev->get_netdev		= hns_roce_get_netdev;
 	ib_dev->query_gid		= hns_roce_query_gid;
 	ib_dev->query_pkey		= hns_roce_query_pkey;
 	ib_dev->alloc_ucontext		= hns_roce_alloc_ucontext;
-- 
1.9.1
