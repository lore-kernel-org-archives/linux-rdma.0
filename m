From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/2] IB/core: Remove the locking for character device bitmap
Date: Mon,  8 Jan 2018 12:15:37 +0200
Message-ID: <20180108101538.16451-2-leon@kernel.org>
References: <20180108101538.16451-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180108101538.16451-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Huy Nguyen <huyn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Huy Nguyen <huyn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Remove the locks that protect character device bitmap of
uverbs, umad and issm.

The character device bit maps are accessed in "client->add" and
"client->remove" calls from ib_register_device and ib_unregister_device
respectively. These calls are already protected by the "device_mutex"
mutex. Thus, the spinlocks are not needed.

Signed-off-by: Huy Nguyen <huyn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/user_mad.c    | 5 -----
 drivers/infiniband/core/uverbs_main.c | 5 -----
 2 files changed, 10 deletions(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index d4de187b1064..608176e9cd5d 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -129,7 +129,6 @@ static struct class *umad_class;
 
 static const dev_t base_dev = MKDEV(IB_UMAD_MAJOR, IB_UMAD_MINOR_BASE);
 
-static DEFINE_SPINLOCK(port_lock);
 static DECLARE_BITMAP(dev_map, IB_UMAD_MAX_PORTS);
 
 static void ib_umad_add_one(struct ib_device *device);
@@ -1172,15 +1171,12 @@ static int ib_umad_init_port(struct ib_device *device, int port_num,
 	int devnum;
 	dev_t base;
 
-	spin_lock(&port_lock);
 	devnum = find_first_zero_bit(dev_map, IB_UMAD_MAX_PORTS);
 	if (devnum >= IB_UMAD_MAX_PORTS) {
-		spin_unlock(&port_lock);
 		devnum = find_overflow_devnum(device);
 		if (devnum < 0)
 			return -1;
 
-		spin_lock(&port_lock);
 		port->dev_num = devnum + IB_UMAD_MAX_PORTS;
 		base = devnum + overflow_maj;
 		set_bit(devnum, overflow_map);
@@ -1189,7 +1185,6 @@ static int ib_umad_init_port(struct ib_device *device, int port_num,
 		base = devnum + base_dev;
 		set_bit(devnum, dev_map);
 	}
-	spin_unlock(&port_lock);
 
 	port->ib_dev   = device;
 	port->port_num = port_num;
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 381fd9c096ae..9e06f810bbeb 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -69,7 +69,6 @@ enum {
 
 static struct class *uverbs_class;
 
-static DEFINE_SPINLOCK(map_lock);
 static DECLARE_BITMAP(dev_map, IB_UVERBS_MAX_DEVICES);
 
 static ssize_t (*uverbs_cmd_table[])(struct ib_uverbs_file *file,
@@ -1062,15 +1061,12 @@ static void ib_uverbs_add_one(struct ib_device *device)
 	INIT_LIST_HEAD(&uverbs_dev->uverbs_file_list);
 	INIT_LIST_HEAD(&uverbs_dev->uverbs_events_file_list);
 
-	spin_lock(&map_lock);
 	devnum = find_first_zero_bit(dev_map, IB_UVERBS_MAX_DEVICES);
 	if (devnum >= IB_UVERBS_MAX_DEVICES) {
-		spin_unlock(&map_lock);
 		devnum = find_overflow_devnum();
 		if (devnum < 0)
 			goto err;
 
-		spin_lock(&map_lock);
 		uverbs_dev->devnum = devnum + IB_UVERBS_MAX_DEVICES;
 		base = devnum + overflow_maj;
 		set_bit(devnum, overflow_map);
@@ -1079,7 +1075,6 @@ static void ib_uverbs_add_one(struct ib_device *device)
 		base = devnum + IB_UVERBS_BASE_DEV;
 		set_bit(devnum, dev_map);
 	}
-	spin_unlock(&map_lock);
 
 	rcu_assign_pointer(uverbs_dev->ib_dev, device);
 	uverbs_dev->num_comp_vectors = device->num_comp_vectors;
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
