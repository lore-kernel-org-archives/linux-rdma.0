From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 11/37] librdmacm: add zalloc call
Date: Wed, 7 Apr 2010 13:19:38 -0600
Message-ID: <20100407191938.GF15629@obsidianresearch.com>
References: <53A8AB949BCE4311B58A4881EC549E90@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <53A8AB949BCE4311B58A4881EC549E90-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 07, 2010 at 10:12:44AM -0700, Sean Hefty wrote:
> Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
>  src/cma.c |    6 ++----
>  src/cma.h |   10 ++++++++++
>  2 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/src/cma.c b/src/cma.c
> index a85448b..4025aeb 100644
> +++ b/src/cma.c
> @@ -342,11 +342,10 @@ static struct cma_id_private *ucma_alloc_id(struct rdma_event_channel *channel,
>  {
>  	struct cma_id_private *id_priv;
>  
> -	id_priv = malloc(sizeof *id_priv);
> +	id_priv = zalloc(sizeof *id_priv);
>  	if (!id_priv)
>  		return NULL;

Maybe use calloc(,1 sizeof(x)); instead?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
