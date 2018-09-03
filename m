From: Arseny Maslennikov <ar@cs.msu.ru>
Subject: [PATCH v3 3/3] IB/ipoib: Log sysfs 'dev_id' accesses from userspace
Date: Mon,  3 Sep 2018 19:13:16 +0300
Message-ID: <20180903161316.25121-4-ar@cs.msu.ru>
References: <20180903161316.25121-1-ar@cs.msu.ru>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180903161316.25121-1-ar@cs.msu.ru>
Sender: netdev-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: Arseny Maslennikov <ar@cs.msu.ru>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Arseny Maslennikov <ar@cs.msu.ru>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 38 +++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 30f840f874b3..7386e5bde3d3 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2386,6 +2386,42 @@ int ipoib_add_pkey_attr(struct net_device *dev)
 	return device_create_file(&dev->dev, &dev_attr_pkey);
 }
 
+/*
+ * We erroneously exposed the iface's port number in the dev_id
+ * sysfs field long after dev_port was introduced for that purpose[1],
+ * and we need to stop everyone from relying on that.
+ * Let's overload the shower routine for the dev_id file here
+ * to gently bring the issue up.
+ *
+ * [1] https://www.spinics.net/lists/netdev/msg272123.html
+ */
+static ssize_t dev_id_show(struct device *dev,
+			   struct device_attribute *attr, char *buf)
+{
+	struct net_device *ndev = to_net_dev(dev);
+	ssize_t ret = -EINVAL;
+
+	if (ndev->dev_id == ndev->dev_port) {
+		netdev_info_once(ndev,
+			"\"%s\" wants to know my dev_id. "
+			"Should it look at dev_port instead?\n",
+			current->comm);
+		netdev_info_once(ndev,
+			"See Documentation/ABI/testing/sysfs-class-net for more info.\n");
+	}
+
+	ret = sprintf(buf, "%#x\n", ndev->dev_id);
+
+	return ret;
+}
+static DEVICE_ATTR_RO(dev_id);
+
+int ipoib_intercept_dev_id_attr(struct net_device *dev)
+{
+	device_remove_file(&dev->dev, &dev_attr_dev_id);
+	return device_create_file(&dev->dev, &dev_attr_dev_id);
+}
+
 static struct net_device *ipoib_add_port(const char *format,
 					 struct ib_device *hca, u8 port)
 {
@@ -2427,6 +2463,8 @@ static struct net_device *ipoib_add_port(const char *format,
 	 */
 	ndev->priv_destructor = ipoib_intf_free;
 
+	if (ipoib_intercept_dev_id_attr(ndev))
+		goto sysfs_failed;
 	if (ipoib_cm_add_mode_attr(ndev))
 		goto sysfs_failed;
 	if (ipoib_add_pkey_attr(ndev))
-- 
2.19.0.rc1
