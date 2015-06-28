From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Use flow-counters for process_mad only when appropriate
Date: Sun, 28 Jun 2015 13:33:38 +0300
Message-ID: <CAJ3xEMjtgvK_FfYi0DNz4rhgRv-Aj__ahf3BuA-KmrZVWVUOdA@mail.gmail.com>
References: <1435243538-26937-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1435243538-26937-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hadar Har-Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 25, 2015 at 5:45 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> For IB links, reading HCA flow counters through iboe_process_mad() should
> be used when mlx4_ib_process_mad() is invoked only for VFs PMA queries and
> exactly nothing else.
>
> Fixes: 7193a141eb74 ('IB/mlx4: Set VF to read from QP counters')
> Reported-by: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>
> Hi Doug, Dave
>
> Doug, I've rebased the patch on top of Ira's fix [1], also you would need to
> merge the mlx4 (7193a141eb74 etc) changes that went-in through net-next for
> the patch to apply -- simply fetch from the latest upstream tree, they're there.

Doug, we still have few concerns re the original patch... please wait
few days with this one
till we are sure it's the right fix.

Or.


>
> Dave, to make it clear, the fix will go through the IB subsystem, as it
> depends on other changes on that area.
>
> thanks,
>
> Or.
>
> [1] https://patchwork.kernel.org/patch/6671931/
>
>  drivers/infiniband/hw/mlx4/mad.c | 29 +++++++++++++++++++----------
>  1 file changed, 19 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
> index 9a810e3..68b3dfa 100644
> --- a/drivers/infiniband/hw/mlx4/mad.c
> +++ b/drivers/infiniband/hw/mlx4/mad.c
> @@ -860,22 +860,31 @@ int mlx4_ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
>         struct mlx4_ib_dev *dev = to_mdev(ibdev);
>         const struct ib_mad *in_mad = (const struct ib_mad *)in;
>         struct ib_mad *out_mad = (struct ib_mad *)out;
> +       enum rdma_link_layer link = rdma_port_get_link_layer(ibdev, port_num);
>
>         if (WARN_ON_ONCE(in_mad_size != sizeof(*in_mad) ||
>                          *out_mad_size != sizeof(*out_mad)))
>                 return IB_MAD_RESULT_FAILURE;
>
> -       switch (rdma_port_get_link_layer(ibdev, port_num)) {
> -       case IB_LINK_LAYER_INFINIBAND:
> -               if (!mlx4_is_slave(dev->dev))
> -                       return ib_process_mad(ibdev, mad_flags, port_num, in_wc,
> -                                             in_grh, in_mad, out_mad);
> -       case IB_LINK_LAYER_ETHERNET:
> -               return iboe_process_mad(ibdev, mad_flags, port_num, in_wc,
> -                                         in_grh, in_mad, out_mad);
> -       default:
> -               return -EINVAL;
> +       /* iboe_process_mad() which uses the HCA flow-counters to implement IB PMA
> +        * queries, should be called only by VFs and for that specific purpose
> +        */
> +       if (link == IB_LINK_LAYER_INFINIBAND) {
> +               if (mlx4_is_slave(dev->dev) &&
> +                   in_mad->mad_hdr.mgmt_class == IB_MGMT_CLASS_PERF_MGMT &&
> +                   in_mad->mad_hdr.attr_id == IB_PMA_PORT_COUNTERS)
> +                       return iboe_process_mad(ibdev, mad_flags, port_num, in_wc,
> +                                               in_grh, in_mad, out_mad);
> +
> +               return ib_process_mad(ibdev, mad_flags, port_num, in_wc,
> +                                     in_grh, in_mad, out_mad);
>         }
> +
> +       if (link == IB_LINK_LAYER_ETHERNET)
> +               return iboe_process_mad(ibdev, mad_flags, port_num, in_wc,
> +                                       in_grh, in_mad, out_mad);
> +
> +       return -EINVAL;
>  }
>
>  static void send_handler(struct ib_mad_agent *agent,
> --
> 2.3.7
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
