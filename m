From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] rdma/core: Really export ib_open_qp() to user space
Date: Fri, 14 Oct 2011 05:20:21 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E6AF56@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We need to add an entry into the uverbs and device command
tables to allow user space to actually call ib_open_qp.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
If possible, this should just be merged with the last patch in the XRC
series.

In my previous tests, this was not getting called.  I either did not
have enough MPI processes or the right MPI ranks running on a single
node to invoke this routine.  Once I bumped up the number of MPI
processes, I did see ib_open_qp() being called, failing, and MPI
aborting.  (The OCU mvapich2 alltoall benchmark with 4 processes all on
the same node can test this.)

I pulled the xrc patches in your for-next branch and ran some simple
tests against it.  Between the last time I tested XRC and now, I'm now
seeing mvapich2 hang during MPI finalize, which I'm debugging.  I can
use ctrl-c to abort the MPI job, and the system appears fine after.  The
librdmacm and ibverbs XRC tests are working fine.

 drivers/infiniband/core/uverbs_main.c |    3 ++-
 drivers/infiniband/hw/mlx4/main.c     |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 9c877e2..485ea6c 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -110,7 +110,8 @@ static ssize_t (*uverbs_cmd_table[])(struct ib_uverbs_file *file,
 	[IB_USER_VERBS_CMD_DESTROY_SRQ]		= ib_uverbs_destroy_srq,
 	[IB_USER_VERBS_CMD_OPEN_XRCD]		= ib_uverbs_open_xrcd,
 	[IB_USER_VERBS_CMD_CLOSE_XRCD]		= ib_uverbs_close_xrcd,
-	[IB_USER_VERBS_CMD_CREATE_XSRQ]		= ib_uverbs_create_xsrq
+	[IB_USER_VERBS_CMD_CREATE_XSRQ]		= ib_uverbs_create_xsrq,
+	[IB_USER_VERBS_CMD_OPEN_QP]		= ib_uverbs_open_qp
 };
 
 static void ib_uverbs_add_one(struct ib_device *device);
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 9cfa6f9..bc47d17 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1098,7 +1098,8 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 		(1ull << IB_USER_VERBS_CMD_MODIFY_SRQ)		|
 		(1ull << IB_USER_VERBS_CMD_QUERY_SRQ)		|
 		(1ull << IB_USER_VERBS_CMD_DESTROY_SRQ)		|
-		(1ull << IB_USER_VERBS_CMD_CREATE_XSRQ);	
+		(1ull << IB_USER_VERBS_CMD_CREATE_XSRQ)		|
+		(1ull << IB_USER_VERBS_CMD_OPEN_QP);
 
 	ibdev->ib_dev.query_device	= mlx4_ib_query_device;
 	ibdev->ib_dev.query_port	= mlx4_ib_query_port;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
