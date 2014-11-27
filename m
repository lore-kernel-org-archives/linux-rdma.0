From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH 07/16] ib/mad: create a jumbo MAD kmem_cache
Date: Thu, 27 Nov 2014 13:50:12 +0200
Message-ID: <54770FF4.3070807@mellanox.com>
References: <1415908465-24392-1-git-send-email-ira.weiny@intel.com>
 <1415908465-24392-8-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415908465-24392-8-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/13/2014 9:54 PM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> @@ -773,7 +782,12 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
>   	}
>   	local->mad_priv = NULL;
>   	local->recv_mad_agent = NULL;
> -	mad_priv = kmem_cache_alloc(ib_mad_cache, GFP_ATOMIC);
> +
> +	if (mad_agent_priv->qp_info->supports_jumbo_mads)
> +		mad_priv = kmem_cache_alloc(jumbo_mad_cache, GFP_ATOMIC);
> +	else
> +		mad_priv = kmem_cache_alloc(ib_mad_cache, GFP_ATOMIC);
> +
@ minimum (if you really think that one kmem cache for both jumbo and 
non-jumbo mads
isn't the way to get) lets have one pointer that is directed to the 
cache you want to use and this
way all branch as the above one and it's such can be avoided, right?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
