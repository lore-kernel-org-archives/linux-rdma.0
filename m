From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH 1/3] RDMA/device: Fix device removal notification when ib_clients set .add callout to NULL
Date: Wed, 28 Jun 2017 13:05:36 +0300
Message-ID: <1498644338-19719-2-git-send-email-sagi@grimberg.me>
References: <1498644338-19719-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498644338-19719-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ib_clients can indeed fill .add to NULL, but then they will not see
any device removal notifications. The reason is that that
ib_register_client and ib_register_device checked existence of .add
before adding the creating a corresponding client_data and adding
it to the list. Simple condition reverse fixes the issue.

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/infiniband/core/device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 81d447da0048..26eb428af473 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -414,7 +414,7 @@ int ib_register_device(struct ib_device *device,
 	device->reg_state = IB_DEV_REGISTERED;
 
 	list_for_each_entry(client, &client_list, list)
-		if (client->add && !add_client_context(device, client))
+		if (!add_client_context(device, client) && client->add)
 			client->add(device);
 
 	down_write(&lists_rwsem);
@@ -499,7 +499,7 @@ int ib_register_client(struct ib_client *client)
 	mutex_lock(&device_mutex);
 
 	list_for_each_entry(device, &device_list, core_list)
-		if (client->add && !add_client_context(device, client))
+		if (!add_client_context(device, client) && client->add)
 			client->add(device);
 
 	down_write(&lists_rwsem);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
