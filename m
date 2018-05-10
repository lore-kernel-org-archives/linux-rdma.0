From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] IB/srpt: Increase port count
Date: Thu, 10 May 2018 15:32:09 -0700
Message-ID: <20180510223209.10277-1-bart.vanassche@wdc.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Steve Wise <swise@opengridcomputing.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Since there are adapters that have four ports, increase the size of
the srpt_device.port[] array. This patch avoids that the following
warning is hit with quad port Chelsio adapters:

    WARN_ON(sdev->device->phys_port_cnt > ARRAY_SIZE(sdev->port));

Reported-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: <stable@vger.kernel.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 2361483476a0..b72f1f4066fa 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -410,7 +410,7 @@ struct srpt_device {
 	struct mutex		sdev_mutex;
 	bool			use_srq;
 	struct srpt_recv_ioctx	**ioctx_ring;
-	struct srpt_port	port[2];
+	struct srpt_port	port[4];
 	struct ib_event_handler	event_handler;
 	struct list_head	list;
 };
-- 
2.16.3
