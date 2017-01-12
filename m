From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH] nvmet-rdma: Fix missing dma sync to nvme data structures
Date: Thu, 12 Jan 2017 22:45:04 +0000
Message-ID: <VI1PR0502MB30082DF2A5D15C0AB8EB7E32D1790@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <1484260948-3227-1-git-send-email-parav@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1484260948-3227-1-git-send-email-parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Missed out Max's review signature. Resending it.

Parav

> -----Original Message-----
> From: Parav Pandit [mailto:parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org]
> Sent: Thursday, January 12, 2017 4:42 PM
> To: hch-jcswGhMUV9g@public.gmane.org; sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org; linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org; linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Cc: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: [PATCH] nvmet-rdma: Fix missing dma sync to nvme data structures
>=20
> This patch performs dma sync operations on nvme_commmand, inline
> page(s) and nvme_completion.
>=20
> nvme_command and write cmd inline data is synced
> (a) on receiving of the recv queue completion for cpu access.
> (b) before posting recv wqe back to rdma adapter for device access.
>=20
> nvme_completion is synced
> (a) on receiving send completion for nvme_completion for cpu access.
> (b) before posting send wqe to rdma adapter for device access.
>=20
> Pushing this patch through linux-rdma git tree as its more relavant with =
Bart's
> changes for dma_map_ops of[1].
>=20
> [1] https://patchwork.kernel.org/patch/9514085/
>=20
> Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/nvme/target/rdma.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
>=20
> diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c inde=
x
> 8c3760a..c6468b3 100644
> --- a/drivers/nvme/target/rdma.c
> +++ b/drivers/nvme/target/rdma.c
> @@ -438,6 +438,14 @@ static int nvmet_rdma_post_recv(struct
> nvmet_rdma_device *ndev,  {
>  	struct ib_recv_wr *bad_wr;
>=20
> +	dma_sync_single_for_device(ndev->device->dma_device,
> +			cmd->sge[0].addr, sizeof(*cmd->nvme_cmd),
> +			DMA_FROM_DEVICE);
> +
> +	if (cmd->sge[1].addr)
> +		dma_sync_single_for_device(ndev->device->dma_device,
> +				cmd->sge[1].addr,
> NVMET_RDMA_INLINE_DATA_SIZE,
> +				DMA_FROM_DEVICE);
>  	if (ndev->srq)
>  		return ib_post_srq_recv(ndev->srq, &cmd->wr, &bad_wr);
>  	return ib_post_recv(cmd->queue->cm_id->qp, &cmd->wr, &bad_wr);
> @@ -507,6 +515,10 @@ static void nvmet_rdma_send_done(struct ib_cq
> *cq, struct ib_wc *wc)
>  	struct nvmet_rdma_rsp *rsp =3D
>  		container_of(wc->wr_cqe, struct nvmet_rdma_rsp,
> send_cqe);
>=20
> +	dma_sync_single_for_cpu(rsp->queue->dev->device->dma_device,
> +			rsp->send_sge.addr, sizeof(*rsp->req.rsp),
> +			DMA_TO_DEVICE);
> +
>  	nvmet_rdma_release_rsp(rsp);
>=20
>  	if (unlikely(wc->status !=3D IB_WC_SUCCESS && @@ -538,6 +550,11
> @@ static void nvmet_rdma_queue_response(struct nvmet_req *req)
>  		first_wr =3D &rsp->send_wr;
>=20
>  	nvmet_rdma_post_recv(rsp->queue->dev, rsp->cmd);
> +
> +	dma_sync_single_for_device(rsp->queue->dev->device-
> >dma_device,
> +			rsp->send_sge.addr, sizeof(*rsp->req.rsp),
> +			DMA_TO_DEVICE);
> +
>  	if (ib_post_send(cm_id->qp, first_wr, &bad_wr)) {
>  		pr_err("sending cmd response failed\n");
>  		nvmet_rdma_release_rsp(rsp);
> @@ -698,6 +715,16 @@ static void nvmet_rdma_handle_command(struct
> nvmet_rdma_queue *queue,
>  	cmd->n_rdma =3D 0;
>  	cmd->req.port =3D queue->port;
>=20
> +	dma_sync_single_for_cpu(queue->dev->device->dma_device,
> +			cmd->cmd->sge[0].addr, sizeof(*cmd->cmd-
> >nvme_cmd),
> +			DMA_FROM_DEVICE);
> +
> +	if (cmd->cmd->sge[1].addr)
> +		dma_sync_single_for_cpu(queue->dev->device-
> >dma_device,
> +				cmd->cmd->sge[1].addr,
> +				NVMET_RDMA_INLINE_DATA_SIZE,
> +				DMA_FROM_DEVICE);
> +
>  	if (!nvmet_req_init(&cmd->req, &queue->nvme_cq,
>  			&queue->nvme_sq, &nvmet_rdma_ops))
>  		return;
> --
> 1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
