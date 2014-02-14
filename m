From: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH master] RDMA/ocrdma: Fix load time panic during GID
 table init
Date: Fri, 14 Feb 2014 06:01:13 +0000
Message-ID: <fe4011f3-3d3b-4920-8201-fb337da52c76@CMEXHTCAS1.ad.emulex.com>
References: <bc0e7e5d-45c2-453f-ba7c-c81a1b1d1d94@CMEXHTCAS2.ad.emulex.com>
 <CAG4TOxPmO2-_gGLd=urBZevzboiFLr4iEqskpxVBCurb4kmWNg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxPmO2-_gGLd=urBZevzboiFLr4iEqskpxVBCurb4kmWNg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Selvin Xavier <Selvin.Xavier-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

The patch was cut before Or's IP based GID changes in master, and is expected as a bug fix for 3.13 .x. I think I am late for this to happen. 

Yes, this needs a fix even in 3.14.
After Or's IP based GID changes the context has been changed _from_ 
ocrdma_inet6addr_event() and  ocrdma_add_vlan_sgids() _to_ ocrdma_addr_event() causing only one call to rdma_vlan_dev_real_dev.

-Regards
 Devesh

-----Original Message-----
From: roland.dreier-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org [mailto:roland.dreier-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org] On Behalf Of Roland Dreier
Sent: Friday, February 14, 2014 4:33 AM
To: Devesh Sharma
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Selvin Xavier
Subject: Re: [PATCH master] RDMA/ocrdma: Fix load time panic during GID table init

On Mon, Feb 3, 2014 at 10:40 PM, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org> wrote:
>
> driver should use rdma_vlan_dev_real_dev() instead of using 
> vlan_dev_real_dev() while building GID table for a vlan interface.
>
> Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_main.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c 
> b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
> index 91443bc..f7b1b27 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
> @@ -161,7 +161,9 @@ static void ocrdma_add_vlan_sgids(struct 
> ocrdma_dev *dev)
>
>         rcu_read_lock();
>         for_each_netdev_rcu(&init_net, tmp) {
> -               if (netdev == tmp || vlan_dev_real_dev(tmp) == netdev) {
> +               if (
> +                       netdev && (netdev == tmp ||
> +                               rdma_vlan_dev_real_dev(tmp) == 
> + netdev)) {
>                         if (!netif_running(tmp) || !netif_oper_up(tmp))
>                                 continue;
>                         if (netdev != tmp) { @@ -208,7 +210,7 @@ 
> static int ocrdma_inet6addr_event(struct notifier_block *notifier,
>         is_vlan = netdev->priv_flags & IFF_802_1Q_VLAN;
>         if (is_vlan) {
>                 vid = vlan_dev_vlan_id(netdev);
> -               netdev = vlan_dev_real_dev(netdev);
> +               netdev = rdma_vlan_dev_real_dev(netdev);
>         }
>
>         rcu_read_lock();

I applied this for my next pull request to go into 3.14, but I had to massage it quite a bit to get it to apply.  There was only one call to vlan_dev_real_dev(), and the context was a bit different.

I guess this is on top of some other patch set?  But I'm assuming we need the fix for 3.14 even without those other patches.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
