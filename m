From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 1/4] IB/IPoIB: Convert IPoIB to
 memalloc_noio_* calls
Date: Mon, 29 May 2017 12:44:46 -0400
Message-ID: <6f8f8d7b-40ba-f0ec-77cd-3c5b20dead23@intel.com>
References: <20170523113816.32657-1-leon@kernel.org>
 <20170523113816.32657-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170523113816.32657-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/23/2017 7:38 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Commit 21caf2fc1931 ("mm: teach mm by current context info to not do I/O
> during memory allocation") added the memalloc_noio_(save|restore) functions
> to enable people to modify the MM behavior by disabling I/O during memory
> allocation. This was further extended in Fixes: 934f3072c17c ("mm: clear
> __GFP_FS when PF_MEMALLOC_NOIO is set"). memalloc_noio_* functions prevent
> allocation paths recursing back into the filesystem without explicitly
> changing the flags for every allocation site.
> 
> However the IPoIB hasn't been keeping up with the changes and missed
> completely these memalloc_noio_* calls. This led to update of
> allocation site with special QP creation flag, see commit 09b93088d750
> ("IB: Add a QP creation flag to use GFP_NOIO allocations"), while this
> flag is supported by small number of drivers in IB stack.
> 
> Let's change it by updating to memalloc_noio_* calls and allow
> for every driver underneath enjoy NOIO allocations.
> 
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> @@ -1131,10 +1127,11 @@ static int ipoib_cm_tx_init(struct ipoib_cm_tx *p, u32 qpn,
>   			    struct sa_path_rec *pathrec)
>   {
>   	struct ipoib_dev_priv *priv = ipoib_priv(p->dev);
> +	unsigned int noio_flag;

>   	int ret;
>   
> -	p->tx_ring = __vmalloc(ipoib_sendq_size * sizeof *p->tx_ring,
> -			       GFP_NOIO, PAGE_KERNEL);
> +	noio_flag = memalloc_noio_save();

NIT: Maybe just call this "flags" since there could be other flags in 
current->flags when calling memalloc_noio_save()

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
