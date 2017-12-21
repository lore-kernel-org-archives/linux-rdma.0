From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [RFC PATCH rdma-next 02/14] RDMA/core: Enforce requirement to hold lists_rwsem semaphore
Date: Thu, 21 Dec 2017 20:17:36 +0200
Message-ID: <20171221181748.17126-3-leon@kernel.org>
References: <20171221181748.17126-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171221181748.17126-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add comment and run time check to the __ib_device_get_by_index()
function to remind that the caller should hold lists_rwsem semaphore.

Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/device.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 950310143ef2..7fe00a9b2318 100644
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

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
