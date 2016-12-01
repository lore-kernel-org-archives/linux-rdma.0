From: Souptick Joarder <jrdr.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] infiniband: mthca: Replace pci_pool_alloc by pci_pool_zalloc
Date: Thu, 1 Dec 2016 11:36:24 +0530
Message-ID: <CAFqt6zYAM8CUsBmTxU9KGw3Xum9oWzJTs3azizuvvhGkPJ1kTQ@mail.gmail.com>
References: <20161128125126.GA32365@gnr743-HP-ZBook-15>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161128125126.GA32365@gnr743-HP-ZBook-15>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rameshwar Sahu <sahu.rameshwar73-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 28, 2016 at 6:21 PM, Souptick Joarder <jrdr.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> In mthca_create_ah(), pci_pool_alloc() followed by memset will be
> replaced by pci_pool_zalloc()
>
> Signed-off-by: Souptick joarder <jrdr.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mthca/mthca_av.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/hw/mthca/mthca_av.c b/drivers/infiniband/hw/mthca/mthca_av.c
> index bcac294..c202c89 100644
> --- a/drivers/infiniband/hw/mthca/mthca_av.c
> +++ b/drivers/infiniband/hw/mthca/mthca_av.c
> @@ -186,7 +186,7 @@ int mthca_create_ah(struct mthca_dev *dev,
>
>  on_hca_fail:
>         if (ah->type == MTHCA_AH_PCI_POOL) {
> -               ah->av = pci_pool_alloc(dev->av_table.pool,
> +               ah->av = pci_pool_zalloc(dev->av_table.pool,
>                                         GFP_ATOMIC, &ah->avdma);
>                 if (!ah->av)
>                         return -ENOMEM;
> @@ -196,7 +196,6 @@ int mthca_create_ah(struct mthca_dev *dev,
>
>         ah->key = pd->ntmr.ibmr.lkey;
>
> -       memset(av, 0, MTHCA_AV_SIZE);
>
>         av->port_pd = cpu_to_be32(pd->pd_num | (ah_attr->port_num << 24));
>         av->g_slid  = ah_attr->src_path_bits;
> --
> 1.9.1
>

Any comment on this patch?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
