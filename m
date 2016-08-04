From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2] IB/hfi1: Allocate cpu mask on the heap to silence warning
Date: Wed, 3 Aug 2016 20:20:54 -0400
Message-ID: <20160804002053.GA11420@phlsvsds.ph.intel.com>
References: <1470266416-31052-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1470266416-31052-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 03, 2016 at 07:20:16PM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> If CONFIG_FRAME_WARN is small (1K) and CONFIG_NR_CPUS big
> then a frame size warning is triggered during build.
> Allocate the cpu mask dynamically to silence the warning.
> 
> INTERNAL: PR 134711 - The presubmit tests need to be enhanced to test
> INTERNAL: for large stack frames

V3 sent without this cruft in it...

Sorry about that,
Ira

>
> 
> Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Change-Id: I28eeec845666ae554cf969c381a76e6564bdcc7b
> 
> ---
> Changes from V1:
> 	Return -ENOMEM if zalloc_cpumask_var fails
> 
>  drivers/infiniband/hw/hfi1/affinity.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/hfi1/affinity.c b/drivers/infiniband/hw/hfi1/affinity.c
> index 79575ee873f2..9bbb21459166 100644
> --- a/drivers/infiniband/hw/hfi1/affinity.c
> +++ b/drivers/infiniband/hw/hfi1/affinity.c
> @@ -682,7 +682,7 @@ int hfi1_set_sdma_affinity(struct hfi1_devdata *dd, const char *buf,
>  			   size_t count)
>  {
>  	struct hfi1_affinity_node *entry;
> -	struct cpumask mask;
> +	cpumask_var_t mask;
>  	int ret, i;
>  
>  	spin_lock(&node_affinity.lock);
> @@ -692,19 +692,24 @@ int hfi1_set_sdma_affinity(struct hfi1_devdata *dd, const char *buf,
>  	if (!entry)
>  		return -EINVAL;
>  
> -	ret = cpulist_parse(buf, &mask);
> +	ret = zalloc_cpumask_var(&mask, GFP_KERNEL);
> +	if (!ret)
> +		return -ENOMEM;
> +
> +	ret = cpulist_parse(buf, mask);
>  	if (ret)
> -		return ret;
> +		goto out;
>  
> -	if (!cpumask_subset(&mask, cpu_online_mask) || cpumask_empty(&mask)) {
> +	if (!cpumask_subset(mask, cpu_online_mask) || cpumask_empty(mask)) {
>  		dd_dev_warn(dd, "Invalid CPU mask\n");
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto out;
>  	}
>  
>  	mutex_lock(&sdma_affinity_mutex);
>  	/* reset the SDMA interrupt affinity details */
>  	init_cpu_mask_set(&entry->def_intr);
> -	cpumask_copy(&entry->def_intr.mask, &mask);
> +	cpumask_copy(&entry->def_intr.mask, mask);
>  	/*
>  	 * Reassign the affinity for each SDMA interrupt.
>  	 */
> @@ -720,8 +725,9 @@ int hfi1_set_sdma_affinity(struct hfi1_devdata *dd, const char *buf,
>  		if (ret)
>  			break;
>  	}
> -
>  	mutex_unlock(&sdma_affinity_mutex);
> +out:
> +	free_cpumask_var(mask);
>  	return ret ? ret : strnlen(buf, PAGE_SIZE);
>  }
>  
> -- 
> 1.8.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
