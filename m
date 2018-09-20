From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 4/5] RDMA/core: Implement IB device rename function
Date: Thu, 20 Sep 2018 14:22:01 +0300
Message-ID: <20180920112202.9181-5-leon@kernel.org>
References: <20180920112202.9181-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180920112202.9181-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, linux-s390@vger.kernel.org, Ursula Braun <ubraun@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, Selvin Xavier <selvin.xavier@broadcom.com>, Steve Wise <swise@chelsio.com>, Lijun Ou <oulijun@huawei.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Ariel Elior <Ariel.Elior@cavium.com>, Christian Benvenuti <benve@cisco.com>, Adit Ranadive <aditr@vmware.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Generic implementation of IB device rename function.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/core_priv.h |  1 +
 drivers/infiniband/core/device.c    | 23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index d7399d5b1cb6..c5881756b799 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -87,6 +87,7 @@ int  ib_device_register_sysfs(struct ib_device *device,
 			      int (*port_callback)(struct ib_device *,
 						   u8, struct kobject *));
 void ib_device_unregister_sysfs(struct ib_device *device);
+int ib_device_rename(struct ib_device *ibdev, const char *name);

 typedef void (*roce_netdev_callback)(struct ib_device *device, u8 port,
 	      struct net_device *idev, void *cookie);
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index a9bc2a3f490c..36b79cd6b620 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -178,6 +178,29 @@ void ib_device_get_name(struct ib_device *ibdev, char *name)
 }
 EXPORT_SYMBOL(ib_device_get_name);

+int ib_device_rename(struct ib_device *ibdev, const char *name)
+{
+	struct ib_device *device;
+	int ret = 0;
+
+	if (!strcmp(name, ibdev->name))
+		return ret;
+
+	mutex_lock(&device_mutex);
+	list_for_each_entry(device, &device_list, core_list) {
+		if (!strcmp(name, device->name)) {
+			ret = -EEXIST;
+			goto out;
+		}
+	}
+
+	strlcpy(ibdev->name, name, IB_DEVICE_NAME_MAX);
+	ret = device_rename(&ibdev->dev, name);
+out:
+	mutex_unlock(&device_mutex);
+	return ret;
+}
+
 static int alloc_name(char *name)
 {
 	unsigned long *inuse;
