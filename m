From: "Raju  Rangoju" <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: RE: [PATCH v2] nvmet-rdma: Fix a possible uninitialized variable
 dereference
Date: Tue, 14 Mar 2017 12:56:34 +0000
Message-ID: <CY1PR12MB07744A34FBDC946B01E80F83BC240@CY1PR12MB0774.namprd12.prod.outlook.com>
References: <1489412381-28947-1-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489412381-28947-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Patch looks good.=20

Tested-by: Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TZUIDd8j+nm9g@public.gmane.org=
.org] On Behalf Of Sagi Grimberg
Sent: 13 March 2017 19:10
To: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH v2] nvmet-rdma: Fix a possible uninitialized variable deref=
erence

When handling a new recv command, we grab a new rsp resource and check for =
the queue state being live. In case the queue is not in live state, we simp=
ly restore the rsp back to the free list. However in this flow we didn't se=
t rsp->queue yet, so we cannot dereference it.

Instead, make sure to initialize rsp->queue (and other rsp members) as soon=
 as possible so we won't reference uninitialized variables.

Reported-by: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reported-by: Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
- v1 broke srq, this one doesn't

 drivers/nvme/target/rdma.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c index =
9aa1da3778b3..ecc4fe862561 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -703,11 +703,6 @@ static void nvmet_rdma_handle_command(struct nvmet_rdm=
a_queue *queue,  {
 	u16 status;
=20
-	cmd->queue =3D queue;
-	cmd->n_rdma =3D 0;
-	cmd->req.port =3D queue->port;
-
-
 	ib_dma_sync_single_for_cpu(queue->dev->device,
 		cmd->cmd->sge[0].addr, cmd->cmd->sge[0].length,
 		DMA_FROM_DEVICE);
@@ -760,9 +755,12 @@ static void nvmet_rdma_recv_done(struct ib_cq *cq, str=
uct ib_wc *wc)
=20
 	cmd->queue =3D queue;
 	rsp =3D nvmet_rdma_get_rsp(queue);
+	rsp->queue =3D queue;
 	rsp->cmd =3D cmd;
 	rsp->flags =3D 0;
 	rsp->req.cmd =3D cmd->nvme_cmd;
+	rsp->req.port =3D queue->port;
+	rsp->n_rdma =3D 0;
=20
 	if (unlikely(queue->state !=3D NVMET_RDMA_Q_LIVE)) {
 		unsigned long flags;
--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in th=
e body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at  ht=
tp://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
