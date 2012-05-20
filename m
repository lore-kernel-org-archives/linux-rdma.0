From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: possible bug when scaling MTT table size with system ram
Date: Sun, 20 May 2012 15:04:02 +0300
Message-ID: <4FB8DDB2.8050506@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland,

Yishai Hadas from Mellanox noted that commit db5a7a65c05 "mlx4_core: 
Scale size of MTT table
with system RAM" seems to introduce a bug, where if request->num_mtt 
becomes 2^25 or higher

> +       /*
> +        * We want to scale the number of MTTs with the size of the
> +        * system memory, since it makes sense to register a lot of
> +        * memory on a system with a lot of memory.  As a heuristic,
> +        * make sure we have enough MTTs to cover twice the system
> +        * memory (with PAGE_SIZE entries).
> +        *
> +        * This number has to be a power of two and fit into 32 bits
> +        * due to device limitations, so cap this at 2^31 as well.
> +        * That limits us to 8TB of memory registration per HCA with
> +        * 4KB pages, which is probably OK for the next few months.
> +        */
> +       si_meminfo(&si);
> +       request->num_mtt =
> +               roundup_pow_of_two(max_t(unsigned, request->num_mtt,
> +                                        min(1UL << 31,
> +                                            si.totalram >> 
> (log_mtts_per_seg - 1))));
> +


we are somehow getting into a situation where mlx4_buddy_init needs to 
allocate > 128KB using
kmalloc, which is impossible... he was suggesting to replace 
kmalloc/kfree with vmalloc/vfree
(see below). What's your thinking here? should we go to get_free_pages? 
limit by 2^25? something else?


Or.

> --- a/drivers/net/ethernet/mellanox/mlx4/mr.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/mr.c
> @@ -129,7 +129,7 @@ static int mlx4_buddy_init(struct mlx4_buddy 
> *buddy, int max_order)
>
>         for (i = 0; i <= buddy->max_order; ++i) {
>                 s = BITS_TO_LONGS(1 << (buddy->max_order - i));
> -               buddy->bits[i] = kmalloc(s * sizeof (long), GFP_KERNEL);
> +               buddy->bits[i] = vmalloc(s * sizeof(long));
>                 if (!buddy->bits[i])
>                         goto err_out_free;
>                 bitmap_zero(buddy->bits[i], 1 << (buddy->max_order - i));
> @@ -142,7 +142,7 @@ static int mlx4_buddy_init(struct mlx4_buddy 
> *buddy, int max_order)
>
>  err_out_free:
>         for (i = 0; i <= buddy->max_order; ++i)
> -               kfree(buddy->bits[i]);
> +               vfree(buddy->bits[i]);
>
>  err_out:
>         kfree(buddy->bits);
> @@ -156,7 +156,7 @@ static void mlx4_buddy_cleanup(struct mlx4_buddy 
> *buddy)
>         int i;
>
>         for (i = 0; i <= buddy->max_order; ++i)
> -               kfree(buddy->bits[i]);
> +               vfree(buddy->bits[i]);
>
>         kfree(buddy->bits);
>         kfree(buddy->num_free);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
