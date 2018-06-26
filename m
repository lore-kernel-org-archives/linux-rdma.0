From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] IB/srpt: Support HCAs with more than two ports
Date: Tue, 26 Jun 2018 15:24:48 -0700
Message-ID: <20180626222448.11411-1-bart.vanassche@wdc.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Steve Wise <swise@opengridcomputing.com>, Christoph Hellwig <hch@infradead.org>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Since there are adapters that have four ports, increase the size of
the srpt_device.port[] array. This patch avoids that the following
warning is hit with quad port Chelsio adapters:

    WARN_ON(sdev->device->phys_port_cnt > ARRAY_SIZE(sdev->port));

Reported-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: <stable@vger.kernel.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 6 +++---
 drivers/infiniband/ulp/srpt/ib_srpt.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 3081c629a7f7..50f4f9806ac6 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2969,10 +2969,12 @@ static void srpt_add_one(struct ib_device *device)
 
 	pr_debug("device = %p\n", device);
 
-	sdev = kzalloc(sizeof(*sdev), GFP_KERNEL);
+	sdev = kzalloc(sizeof(*sdev) + device->phys_port_cnt *
+		       sizeof(*sdev->port), GFP_KERNEL);
 	if (!sdev)
 		goto err;
 
+	sdev->port = (void *)(sdev + 1);
 	sdev->device = device;
 	mutex_init(&sdev->sdev_mutex);
 
@@ -3023,8 +3025,6 @@ static void srpt_add_one(struct ib_device *device)
 			      srpt_event_handler);
 	ib_register_event_handler(&sdev->event_handler);
 
-	WARN_ON(sdev->device->phys_port_cnt > ARRAY_SIZE(sdev->port));
-
 	for (i = 1; i <= sdev->device->phys_port_cnt; i++) {
 		sport = &sdev->port[i - 1];
 		INIT_LIST_HEAD(&sport->nexus_list);
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 2361483476a0..b20ad6dbf966 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -410,7 +410,7 @@ struct srpt_device {
 	struct mutex		sdev_mutex;
 	bool			use_srq;
 	struct srpt_recv_ioctx	**ioctx_ring;
-	struct srpt_port	port[2];
+	struct srpt_port	*port;
 	struct ib_event_handler	event_handler;
 	struct list_head	list;
 };
-- 
2.17.1
