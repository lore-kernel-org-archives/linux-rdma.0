From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/4] IB/core: add port state cache
Date: Mon, 12 Dec 2016 14:11:56 +0200
Message-ID: <6b60d6b1-96ce-3710-7716-0df4b1895c44@mellanox.com>
References: <CAMGffE=gytHRs+SVOmNPCkWX6tZ9hkeFznqeQQs-TFJMMJi97g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMGffE=gytHRs+SVOmNPCkWX6tZ9hkeFznqeQQs-TFJMMJi97g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

On 12/12/2016 1:43 PM, Jinpu Wang wrote:
> From fc80c1730d94a38934c5c60f9b9561745723dfd9 Mon Sep 17 00:00:00 2001
> From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> Date: Mon, 12 Dec 2016 09:52:42 +0100
> Subject: [PATCH 1/4] IB/core: add port state cache
> 
> We need a port state cache in ib_core, later we will use in rdma_cm.
> 
> Signed-off-by: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> Reviewed-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> ---
>  drivers/infiniband/core/cache.c | 9 ++++++++-
>  include/rdma/ib_verbs.h         | 1 +
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
> index 1a2984c..025db27 100644
> --- a/drivers/infiniband/core/cache.c
> +++ b/drivers/infiniband/core/cache.c
> @@ -1109,6 +1109,8 @@ static void ib_cache_update(struct ib_device *device,
>      }
> 
>      device->cache.lmc_cache[port - rdma_start_port(device)] = tprops->lmc;
> +    device->cache.port_state_cache[port - rdma_start_port(device)] =
> +        tprops->state;
> 
>      write_unlock_irq(&device->cache.lock);
> 
> @@ -1168,7 +1170,11 @@ int ib_cache_setup_one(struct ib_device *device)
>                        (rdma_end_port(device) -
>                         rdma_start_port(device) + 1),
>                        GFP_KERNEL);
> -    if (!device->cache.pkey_cache ||
> +    device->cache.port_state_cache = kmalloc(sizeof
> *device->cache.port_state_cache *
> +                      (rdma_end_port(device) -
> +                       rdma_start_port(device) + 1),
> +                      GFP_KERNEL);
> +    if (!device->cache.pkey_cache || !device->cache.port_state_cache ||
Looking at the code, I see we can leak memory here.
if pkey_cache is allocated but lms_cache is not, we will return without freeing pkey_cache (or the other way around)
your code adds port_state_cache to the mix but with the same issue.
I guess that should be fixed.

>          !device->cache.lmc_cache) {
>          pr_warn("Couldn't allocate cache for %s\n", device->name);
>          return -ENOMEM;
> @@ -1213,6 +1219,7 @@ void ib_cache_release_one(struct ib_device *device)
>      gid_table_release_one(device);
>      kfree(device->cache.pkey_cache);
>      kfree(device->cache.lmc_cache);
> +    kfree(device->cache.port_state_cache);
>  }
> 
>  void ib_cache_cleanup_one(struct ib_device *device)
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 5ad43a4..a167ae0 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -1761,6 +1761,7 @@ struct ib_cache {
>      struct ib_pkey_cache  **pkey_cache;
>      struct ib_gid_table   **gid_cache;
>      u8                     *lmc_cache;
> +    enum ib_port_state     *port_state_cache;
>  };
> 
>  struct ib_dma_mapping_ops {
> 

Mark.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
