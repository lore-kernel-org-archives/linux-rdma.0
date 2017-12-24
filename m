From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-rc 1/4] RDMA/core: Enforce requirement to hold lists_rwsem semaphore
Date: Sun, 24 Dec 2017 13:54:55 +0200
Message-ID: <20171224115458.27577-2-leon@kernel.org>
References: <20171224115458.27577-1-leon@kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171224115458.27577-1-leon@kernel.org>
Sender: stable-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: linux-rdma@vger.kernel.org, Daniel Jurgens <danielj@mellanox.com>, Majd Dibbiny <majd@mellanox.com>, Mark Bloch <markb@mellanox.com>, Moni Shoua <monis@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Add comment and run time check to the __ib_device_get_by_index()
function to remind that the caller should hold lists_rwsem semaphore.

Cc: <stable@vger.kernel.org> # v4.13
Fixes: ecc82c53f9a4 ("RDMA/core: Add and expose static device index")
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/device.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 30914f3baa5f..3aeaf11d0a83 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -134,10 +134,15 @@ static int ib_device_check_mandatory(struct ib_device *device)
 	return 0;
 }
 
+/*
+ * Caller to this function should hold lists_rwsem
+ */
 struct ib_device *__ib_device_get_by_index(u32 index)
 {
 	struct ib_device *device;
 
+	WARN_ON_ONCE(!rwsem_is_locked(&lists_rwsem));
+
 	list_for_each_entry(device, &device_list, core_list)
 		if (device->index == index)
 			return device;
@@ -526,8 +531,8 @@ int ib_register_device(struct ib_device *device,
 		if (!add_client_context(device, client) && client->add)
 			client->add(device);
 
-	device->index = __dev_new_index();
 	down_write(&lists_rwsem);
+	device->index = __dev_new_index();
 	list_add_tail(&device->core_list, &device_list);
 	up_write(&lists_rwsem);
 	mutex_unlock(&device_mutex);
-- 
2.15.1
