From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 3/3] IB/core: Fix sysfs registration error flow
Date: Sun, 19 Mar 2017 10:55:57 +0200
Message-ID: <20170319085557.6023-4-leon@kernel.org>
References: <20170319085557.6023-1-leon@kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170319085557.6023-1-leon@kernel.org>
Sender: stable-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, Jack Morgenstein <jackm@dev.mellanox.co.il>, "# v4 . 2+" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm@dev.mellanox.co.il>

The kernel commit cited below restructured ib device management
so that the device kobject is initialized in ib_alloc_device.

As part of the restructuring, the kobject is now initialized in
procedure ib_alloc_device, and is later added to the device hierarchy
in the ib_register_device call stack, in procedure
ib_device_register_sysfs (which calls device_add).

However, in the ib_device_register_sysfs error flow, if an error
occurs following the call to device_add, the cleanup procedure
device_unregister is called. This call results in the device object
being deleted -- which results in various use-after-free crashes.

The correct cleanup call is device_del -- which undoes device_add
without deleting the device object.

The device object will then (correctly) be deleted in the
ib_register_device caller's error cleanup flow, when the caller invokes
ib_dealloc_device.

Fixes: 55aeed06544f6 ("IB/core: Make ib_alloc_device init the kobject")
Cc: <stable@vger.kernel.org> # v4.2+
Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
---
 drivers/infiniband/core/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index daadf3130c9f..48bb75503255 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -1301,7 +1301,7 @@ int ib_device_register_sysfs(struct ib_device *device,
 	free_port_list_attributes(device);
 
 err_unregister:
-	device_unregister(class_dev);
+	device_del(class_dev);
 
 err:
 	return ret;
-- 
2.12.0
