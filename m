From: Or Gerlitz <or.gerlitz@gmail.com>
Subject: Re: [patch] IB/iser: use after free in iser_snd_completion()
Date: Thu, 30 Jan 2014 23:04:51 +0200
Message-ID: <CAJZOPZ+NccdZU7n6pOs2hgim5PWQmU6PdvGxqcTxDErcJmALNA@mail.gmail.com>
References: <20140129131850.GD10678@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20140129131850.GD10678@elgon.mountain>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma <linux-rdma@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 29, 2014, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> We use "tx_desc" again after we free it.

yep, this is legacy code which isn't much of use over the last years
and hence the bug went in unnoticed


> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
> index 538822684d5b..334f34b1cd46 100644
> --- a/drivers/infiniband/ulp/iser/iser_initiator.c
> +++ b/drivers/infiniband/ulp/iser/iser_initiator.c
> @@ -610,11 +610,12 @@ void iser_snd_completion(struct iser_tx_desc *tx_desc,
>                 ib_dma_unmap_single(device->ib_device, tx_desc->dma_addr,
>                                         ISER_HEADERS_LEN, DMA_TO_DEVICE);
>                 kmem_cache_free(ig.desc_cache, tx_desc);
> +               tx_desc = NULL;
>         }
>
>         atomic_dec(&ib_conn->post_send_buf_count);
>
> -       if (tx_desc->type == ISCSI_TX_CONTROL) {
> +       if (tx_desc && tx_desc->type == ISCSI_TX_CONTROL) {
>                 /* this arithmetic is legal by libiscsi dd_data allocation */
>                 task = (void *) ((long)(void *)tx_desc -
>                                   sizeof(struct iscsi_task));
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
