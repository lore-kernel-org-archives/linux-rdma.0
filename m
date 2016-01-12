From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [patch] IB/cma: allocating too much memory in make_cma_ports()
Date: Tue, 12 Jan 2016 15:08:32 +0200
Message-ID: <CAAKD3BDw8422EjzChtU23u4gKx-vegCxBuwKkLhXL1ySmACRxw@mail.gmail.com>
References: <20160112092921.GB29804@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160112092921.GB29804@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 12, 2016 at 11:29 AM, Dan Carpenter
<dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> The issue here is that there is a cut and paste bug.  When we allocate
> cma_dev_group->default_ports_group we use "sizeof(*cma_dev_group->ports)"
> instead of "sizeof(*cma_dev_group->default_ports_group)".
>
> We're bumping up against the 80 character limit so I introduced a new
> local pointer "ports_group" to get around that.
>
> Fixes: 045959db65c6 ('IB/cma: Add configfs for rdma_cm')
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> Not tested.
>
> diff --git a/drivers/infiniband/core/cma_configfs.c b/drivers/infiniband/core/cma_configfs.c
> index bd1d640..18b112a 100644
> --- a/drivers/infiniband/core/cma_configfs.c
> +++ b/drivers/infiniband/core/cma_configfs.c
> @@ -158,6 +158,7 @@ static int make_cma_ports(struct cma_dev_group *cma_dev_group,
>         unsigned int i;
>         unsigned int ports_num;
>         struct cma_dev_port_group *ports;
> +       struct config_group **ports_group;
>         int err;
>
>         ibdev = cma_get_ib_dev(cma_dev);
> @@ -168,12 +169,9 @@ static int make_cma_ports(struct cma_dev_group *cma_dev_group,
>         ports_num = ibdev->phys_port_cnt;
>         ports = kcalloc(ports_num, sizeof(*cma_dev_group->ports),
>                         GFP_KERNEL);
> +       ports_group = kcalloc(ports_num + 1, sizeof(*ports_group), GFP_KERNEL);
>
> -       cma_dev_group->default_ports_group = kcalloc(ports_num + 1,
> -                                                    sizeof(*cma_dev_group->ports),
> -                                                    GFP_KERNEL);
> -
> -       if (!ports || !cma_dev_group->default_ports_group) {
> +       if (!ports || !ports_group) {
>                 err = -ENOMEM;
>                 goto free;
>         }
> @@ -187,15 +185,16 @@ static int make_cma_ports(struct cma_dev_group *cma_dev_group,
>                 config_group_init_type_name(&ports[i].group,
>                                             port_str,
>                                             &cma_port_group_type);
> -               cma_dev_group->default_ports_group[i] = &ports[i].group;
> +               ports_group[i] = &ports[i].group;
>         }
> -       cma_dev_group->default_ports_group[i] = NULL;
> +       ports_group[i] = NULL;
> +       cma_dev_group->default_ports_group = ports_group;
>         cma_dev_group->ports = ports;
>
>         return 0;
>  free:
>         kfree(ports);
> -       kfree(cma_dev_group->default_ports_group);
> +       kfree(ports_group);
>         cma_dev_group->ports = NULL;
>         cma_dev_group->default_ports_group = NULL;
>         return err;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi,

This is already fixed in [1].
Anyway, I'm fine with either one of them.

Acked-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Regards,
Matan

[1] http://www.spinics.net/lists/linux-rdma/msg32152.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
