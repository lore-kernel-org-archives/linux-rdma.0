From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH master] RDMA/ocrdma: Fix load time panic during GID table init
Date: Thu, 13 Feb 2014 15:02:56 -0800
Message-ID: <CAG4TOxPmO2-_gGLd=urBZevzboiFLr4iEqskpxVBCurb4kmWNg@mail.gmail.com>
References: <bc0e7e5d-45c2-453f-ba7c-c81a1b1d1d94@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <bc0e7e5d-45c2-453f-ba7c-c81a1b1d1d94-3RiH6ntJJkOPfaB/Gd0HpljyZtpTMMwT@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 3, 2014 at 10:40 PM, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org> wrote:
>
> driver should use rdma_vlan_dev_real_dev() instead of using vlan_dev_real_dev()
> while building GID table for a vlan interface.
>
> Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_main.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
> index 91443bc..f7b1b27 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
> @@ -161,7 +161,9 @@ static void ocrdma_add_vlan_sgids(struct ocrdma_dev *dev)
>
>         rcu_read_lock();
>         for_each_netdev_rcu(&init_net, tmp) {
> -               if (netdev == tmp || vlan_dev_real_dev(tmp) == netdev) {
> +               if (
> +                       netdev && (netdev == tmp ||
> +                               rdma_vlan_dev_real_dev(tmp) == netdev)) {
>                         if (!netif_running(tmp) || !netif_oper_up(tmp))
>                                 continue;
>                         if (netdev != tmp) {
> @@ -208,7 +210,7 @@ static int ocrdma_inet6addr_event(struct notifier_block *notifier,
>         is_vlan = netdev->priv_flags & IFF_802_1Q_VLAN;
>         if (is_vlan) {
>                 vid = vlan_dev_vlan_id(netdev);
> -               netdev = vlan_dev_real_dev(netdev);
> +               netdev = rdma_vlan_dev_real_dev(netdev);
>         }
>
>         rcu_read_lock();

I applied this for my next pull request to go into 3.14, but I had to
massage it quite a bit to get it to apply.  There was only one call to
vlan_dev_real_dev(), and the context was a bit different.

I guess this is on top of some other patch set?  But I'm assuming we
need the fix for 3.14 even without those other patches.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
