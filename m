From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags/ibroute.c: fix pull extra block for
 LFT
Date: Thu, 28 Mar 2013 08:50:13 -0700
Message-ID: <20130328085013.187818256f763f4e7c5eb084@intel.com>
References: <20130328075540.GA11235@r-ufm5-17.mtr.labs.mlnx>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130328075540.GA11235-Kyg1NGsloJ8bMuq+TCmafCexzy7lsfyC@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 28 Mar 2013 09:55:40 +0200
Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

> when we pull LFT we pull extra block, this may cause to failure.
> 
> Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied,
Ira

> ---
>  src/ibroute.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/src/ibroute.c b/src/ibroute.c
> index df48382..d4827c9 100644
> --- a/src/ibroute.c
> +++ b/src/ibroute.c
> @@ -360,7 +360,7 @@ char *dump_unicast_tables(ib_portid_t * portid, int startlid, int endlid)
>  	printf("       Port     Info \n");
>  	startblock = startlid / IB_SMP_DATA_SIZE;
>  	endblock = ALIGN(endlid, IB_SMP_DATA_SIZE) / IB_SMP_DATA_SIZE;
> -	for (block = startblock; block <= endblock; block++) {
> +	for (block = startblock; block < endblock; block++) {
>  		int status;
>  		DEBUG("reading block %d", block);
>  		if (!smp_query_status_via(lft, portid, IB_ATTR_LINEARFORWTBL, block,
> -- 
> 1.7.1
> 


-- 
Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
