From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: ratelimit PFNs busy info message
Date: Wed, 02 Aug 2017 14:05:16 -0400
Message-ID: <1501697116.109555.9.camel@redhat.com>
References: <499c0f6cc10d6eb829a67f2a4d75b4228a9b356e.1501695897.git.jtoppins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <499c0f6cc10d6eb829a67f2a4d75b4228a9b356e.1501695897.git.jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Hillf Danton <hillf.zj-gPhfCIXyaqCqndwCJWfcng@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-08-02 at 13:44 -0400, Jonathan Toppins wrote:
> The RDMA subsystem can generate several thousand of these messages
> per
> second eventually leading to a kernel crash. Ratelimit these messages
> to prevent this crash.
> 
> Signed-off-by: Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Tested-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  mm/page_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 6d30e914afb6..07b7d3060b21 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7666,7 +7666,7 @@ int alloc_contig_range(unsigned long start,
> unsigned long end,
>  
>  	/* Make sure the range is really isolated. */
>  	if (test_pages_isolated(outer_start, end, false)) {
> -		pr_info("%s: [%lx, %lx) PFNs busy\n",
> +		pr_info_ratelimited("%s: [%lx, %lx) PFNs busy\n",
>  			__func__, outer_start, end);
>  		ret = -EBUSY;
>  		goto done;


FWIW, I've been carrying a version of this for several kernel versions.
 I don't remember when they started, but we have one (and only one)
class of machines: Dell PE R730xd, that generate these errors.  When it
happens, without a rate limit, we get rcu timeouts and kernel oopses. 
With the rate limit, we just get a lot of annoying kernel messages but
the machine continues on, recovers, and eventually the memory
operations all succeed.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
