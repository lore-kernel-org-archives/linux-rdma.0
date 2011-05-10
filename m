From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] librdmacm: define REUSEADDR option
Date: Tue, 10 May 2011 14:30:35 -0700
Message-ID: <20110510143035.ab736d58.weiny2@llnl.gov>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25DCC49B2D@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25DCC49B2D-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Christopher J. Morrone" <morrone2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 15 Apr 2011 23:48:27 -0700
"Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> Support equivalent of SO_REUSEADDR socket option.  When specified
> the rdma_cm_id will be bound to a reuseable address.  This will
> allow other users to bind to that same address.  This is needed
> to support lustre on clusters larger than 1024 nodes.
> 
> Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Acked-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>

> ---
>  include/rdma/rdma_cma.h |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/include/rdma/rdma_cma.h b/include/rdma/rdma_cma.h
> index b48cd2e..3648c97 100755
> --- a/include/rdma/rdma_cma.h
> +++ b/include/rdma/rdma_cma.h
> @@ -639,8 +639,9 @@ enum {
>  
>  /* Option details */
>  enum {
> -	RDMA_OPTION_ID_TOS	= 0,	/* uint8_t: RFC 2474 */
> -	RDMA_OPTION_IB_PATH	= 1	/* struct ibv_path_data[] */
> +	RDMA_OPTION_ID_TOS	 = 0,	/* uint8_t: RFC 2474 */
> +	RDMA_OPTION_ID_REUSEADDR = 1,   /* int: ~SO_REUSEADDR */
> +	RDMA_OPTION_IB_PATH	 = 1	/* struct ibv_path_data[] */
>  };
>  
>  /**
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
