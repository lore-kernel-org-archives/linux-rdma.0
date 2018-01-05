From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [rdma for-next] bnxt_re: report RoCE device support at info level
Date: Fri, 5 Jan 2018 15:22:02 +0530
Message-ID: <CANjDDBho+uSNdzB3xg0v81fnEF-dbtMikWmftRRC9XyoUdjipw@mail.gmail.com>
References: <ac1582130cbb59814d113ec5a3d1f3805c7e3d7e.1515099853.git.jtoppins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ac1582130cbb59814d113ec5a3d1f3805c7e3d7e.1515099853.git.jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Acked-By: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

On Fri, Jan 5, 2018 at 2:34 AM, Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Reporting that a device doesn't support RoCE seems like a valuable piece
> of information to have when trying to determine why a driver is not binding
> to a device. Better to report this at info log level instead of requiring
> a user to enable all debug messages in the driver.
>
> Signed-off-by: Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/bnxt_re/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
> index aafc19aa5de1..bf268bf1f496 100644
> --- a/drivers/infiniband/hw/bnxt_re/main.c
> +++ b/drivers/infiniband/hw/bnxt_re/main.c
> @@ -417,7 +417,7 @@ static struct bnxt_en_dev *bnxt_re_dev_probe(struct net_device *netdev)
>                 return ERR_PTR(-EINVAL);
>
>         if (!(en_dev->flags & BNXT_EN_FLAG_ROCE_CAP)) {
> -               dev_dbg(&pdev->dev,
> +               dev_info(&pdev->dev,
>                         "%s: probe error: RoCE is not supported on this device",
>                         ROCE_DRV_MODULE_NAME);
>                 return ERR_PTR(-ENODEV);
> --
> 2.13.6
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
