From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: linux-next: build failure after merge of the akpm tree
Date: Mon, 24 Sep 2012 12:36:43 -0700
Message-ID: <CAL1RGDUCThiu+vxy4d5QXvqfDCDUnHOBfZT97XB+Qy_bQrxCRg@mail.gmail.com>
References: <20120925000217.947b8cd8dca6979bfedee2ca@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120925000217.947b8cd8dca6979bfedee2ca-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 24, 2012 at 7:02 AM, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org> wrote:
> After merging the akpm tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> drivers/infiniband/hw/mlx4/cm.c: In function 'id_map_alloc':
> drivers/infiniband/hw/mlx4/cm.c:228:36: error: 'MAX_ID_MASK' undeclared (first use in this function)
>
> Caused by commit d7a4e9b679e9 ("IB/mlx4: Add CM paravirtualization") from
> the infiniband tree interacting with commit "idr: rename MAX_LEVEL to
> MAX_IDR_LEVEL" from the akpm tree.
>
> I have added the following merge fix patch for today:
>
> From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
> Date: Mon, 24 Sep 2012 23:57:53 +1000
> Subject: [PATCH] IB/mlx4: fix for MAX_ID_MASK to MAX_IDR_MASK name change
>
> Signed-off-by: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx4/cm.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/hw/mlx4/cm.c b/drivers/infiniband/hw/mlx4/cm.c
> index e25e4da..80079e5 100644
> --- a/drivers/infiniband/hw/mlx4/cm.c
> +++ b/drivers/infiniband/hw/mlx4/cm.c
> @@ -225,7 +225,7 @@ id_map_alloc(struct ib_device *ibdev, int slave_id, u32 sl_cm_id)
>                 ret = idr_get_new_above(&sriov->pv_id_table, ent,
>                                         next_id, &id);
>                 if (!ret) {
> -                       next_id = ((unsigned) id + 1) & MAX_ID_MASK;
> +                       next_id = ((unsigned) id + 1) & MAX_IDR_MASK;
>                         ent->pv_cm_id = (u32)id;
>                         sl_id_map_add(ibdev, ent);
>                 }

Andrew, any preference on how to handle this merge?

Jack/Amir, I wonder if there's some way we can avoid this code
entirely?  Is an IDR the right structure to use here, or would we
be better off with a radix tree maybe (where we can assign our
own ID)?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
