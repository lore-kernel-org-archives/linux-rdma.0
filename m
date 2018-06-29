From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] IB/srpt: Support HCAs with more than two ports
Date: Fri, 29 Jun 2018 10:20:59 -0600
Message-ID: <20180629162059.GA21030@ziepe.ca>
References: <20180626222448.11411-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180626222448.11411-1-bart.vanassche@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>, Christoph Hellwig <hch@infradead.org>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 26, 2018 at 03:24:48PM -0700, Bart Van Assche wrote:
> Since there are adapters that have four ports, increase the size of
> the srpt_device.port[] array. This patch avoids that the following
> warning is hit with quad port Chelsio adapters:
> 
>     WARN_ON(sdev->device->phys_port_cnt > ARRAY_SIZE(sdev->port));
> 
> Reported-by: Steve Wise <swise@opengridcomputing.com>
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Steve Wise <swise@opengridcomputing.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/infiniband/ulp/srpt/ib_srpt.c | 6 +++---
>  drivers/infiniband/ulp/srpt/ib_srpt.h | 2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)

Can we write it this way instead? More typesafe.

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 1b0b285a0ae021..36d9fab7c99800 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2970,7 +2970,8 @@ static void srpt_add_one(struct ib_device *device)
 
 	pr_debug("device = %p\n", device);
 
-	sdev = kzalloc(sizeof(*sdev), GFP_KERNEL);
+	sdev = kzalloc(struct_size(sdev, port, device->phys_port_cnt),
+		       GFP_KERNEL);
 	if (!sdev)
 		goto err;
 
@@ -3024,8 +3025,6 @@ static void srpt_add_one(struct ib_device *device)
 			      srpt_event_handler);
 	ib_register_event_handler(&sdev->event_handler);
 
-	WARN_ON(sdev->device->phys_port_cnt > ARRAY_SIZE(sdev->port));
-
 	for (i = 1; i <= sdev->device->phys_port_cnt; i++) {
 		sport = &sdev->port[i - 1];
 		INIT_LIST_HEAD(&sport->nexus_list);
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 2361483476a025..444dfd7281b5fe 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -396,9 +396,9 @@ struct srpt_port {
  * @sdev_mutex:	   Serializes use_srq changes.
  * @use_srq:       Whether or not to use SRQ.
  * @ioctx_ring:    Per-HCA SRQ.
- * @port:          Information about the ports owned by this HCA.
  * @event_handler: Per-HCA asynchronous IB event handler.
  * @list:          Node in srpt_dev_list.
+ * @port:          Information about the ports owned by this HCA.
  */
 struct srpt_device {
 	struct ib_device	*device;
@@ -410,9 +410,9 @@ struct srpt_device {
 	struct mutex		sdev_mutex;
 	bool			use_srq;
 	struct srpt_recv_ioctx	**ioctx_ring;
-	struct srpt_port	port[2];
 	struct ib_event_handler	event_handler;
 	struct list_head	list;
+	struct srpt_port        port[];
 };
 
 #endif				/* IB_SRPT_H */
