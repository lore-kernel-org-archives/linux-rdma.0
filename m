From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 09/16] IB/hfi1: Clean up pin_vector_pages()
 function
Date: Tue, 22 Aug 2017 18:46:59 +0300
Message-ID: <20170822154659.GE1724@mtr-leonro.local>
References: <20170822011657.32701.22207.stgit@scvm10.sc.intel.com>
 <20170822012702.32701.90032.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cDyoBSpeMmeqjtIY"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170822012702.32701.90032.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--cDyoBSpeMmeqjtIY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 21, 2017 at 06:27:03PM -0700, Dennis Dalessandro wrote:
> From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> Clean up pin_vector_pages() function by moving page pinning related code
> to a separate function since it really stands on its own.
>
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/hfi1/user_sdma.c |   79 ++++++++++++++++++--------------
>  1 files changed, 45 insertions(+), 34 deletions(-)
>
> diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
> index d5a2572..6f26253 100644
> --- a/drivers/infiniband/hw/hfi1/user_sdma.c
> +++ b/drivers/infiniband/hw/hfi1/user_sdma.c
> @@ -1124,11 +1124,53 @@ static u32 sdma_cache_evict(struct hfi1_user_sdma_pkt_q *pq, u32 npages)
>  	return evict_data.cleared;
>  }
>
> +static int pin_sdma_pages(struct user_sdma_request *req,
> +			  struct user_sdma_iovec *iovec,
> +			  struct sdma_mmu_node *node,
> +			  int npages)
> +{
> +	int pinned, cleared;
> +	struct page **pages;
> +	struct hfi1_user_sdma_pkt_q *pq = req->pq;
> +
> +	pages = kcalloc(npages, sizeof(*pages), GFP_KERNEL);
> +	if (!pages) {
> +		SDMA_DBG(req, "Failed page array alloc");

Please don't add prints after k[c|m|z]alloc failures, despite the fact
that it was before.

Thanks

> +		return -ENOMEM;
> +	}
> +	memcpy(pages, node->pages, node->npages * sizeof(*pages));
> +
> +	npages -= node->npages;
> +retry:
> +	if (!hfi1_can_pin_pages(pq->dd, pq->mm,
> +				atomic_read(&pq->n_locked), npages)) {
> +		cleared = sdma_cache_evict(pq, npages);
> +		if (cleared >= npages)
> +			goto retry;
> +	}
> +	pinned = hfi1_acquire_user_pages(pq->mm,
> +					 ((unsigned long)iovec->iov.iov_base +
> +					 (node->npages * PAGE_SIZE)), npages, 0,
> +					 pages + node->npages);
> +	if (pinned < 0) {
> +		kfree(pages);
> +		return pinned;
> +	}
> +	if (pinned != npages) {
> +		unpin_vector_pages(pq->mm, pages, node->npages, pinned);
> +		return -EFAULT;
> +	}
> +	kfree(node->pages);
> +	node->rb.len = iovec->iov.iov_len;
> +	node->pages = pages;
> +	atomic_add(pinned, &pq->n_locked);
> +	return pinned;
> +}
> +
>  static int pin_vector_pages(struct user_sdma_request *req,
>  			    struct user_sdma_iovec *iovec)
>  {
> -	int ret = 0, pinned, npages, cleared;
> -	struct page **pages;
> +	int ret = 0, pinned, npages;
>  	struct hfi1_user_sdma_pkt_q *pq = req->pq;
>  	struct sdma_mmu_node *node = NULL;
>  	struct mmu_rb_node *rb_node;
> @@ -1162,44 +1204,13 @@ static int pin_vector_pages(struct user_sdma_request *req,
>
>  	npages = num_user_pages(&iovec->iov);
>  	if (node->npages < npages) {
> -		pages = kcalloc(npages, sizeof(*pages), GFP_KERNEL);
> -		if (!pages) {
> -			SDMA_DBG(req, "Failed page array alloc");
> -			ret = -ENOMEM;
> -			goto bail;
> -		}
> -		memcpy(pages, node->pages, node->npages * sizeof(*pages));
> -
> -		npages -= node->npages;
> -
> -retry:
> -		if (!hfi1_can_pin_pages(pq->dd, pq->mm,
> -					atomic_read(&pq->n_locked), npages)) {
> -			cleared = sdma_cache_evict(pq, npages);
> -			if (cleared >= npages)
> -				goto retry;
> -		}
> -		pinned = hfi1_acquire_user_pages(pq->mm,
> -			((unsigned long)iovec->iov.iov_base +
> -			 (node->npages * PAGE_SIZE)), npages, 0,
> -			pages + node->npages);
> +		pinned = pin_sdma_pages(req, iovec, node, npages);
>  		if (pinned < 0) {
> -			kfree(pages);
>  			ret = pinned;
>  			goto bail;
>  		}
> -		if (pinned != npages) {
> -			unpin_vector_pages(pq->mm, pages, node->npages,
> -					   pinned);
> -			ret = -EFAULT;
> -			goto bail;
> -		}
> -		kfree(node->pages);
> -		node->rb.len = iovec->iov.iov_len;
> -		node->pages = pages;
>  		node->npages += pinned;
>  		npages = node->npages;
> -		atomic_add(pinned, &pq->n_locked);
>  	}
>  	iovec->pages = node->pages;
>  	iovec->npages = npages;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--cDyoBSpeMmeqjtIY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmcUfMACgkQ5GN7iDZy
WKeUeQ/+Pj2BW9g8WksJx5QnIX4Xpj8a4rcEmIRWu97Xo5VRLldM5Oa6pEeWCe4a
OL9pB2LPnKBLQZLYWkasK6iyn9tqP+zqwejZTSe1+NBvBU+5vWAj/d1FUh9jS2h0
3+6vCaPzENm5D+ykuMh2S0UWTq5y5p+PH5ub7nyuzAK5nN6+5492+GS1UJ1tkkP8
f96UZHvYimybXWLZGF5Yqcm9gHx93tOZInEh1OFutyQl9dUhugqSZku+m8dIlqGl
Gjl26xqiGXf41JBrstCN4Uz5GeWYcLvbvbSEQZ1WkqHzQkr4Xsyxy2dfadr0twlO
vMV5FBQdUyMld2eD7SOcWwN3K23RfyTiScN+9rm8wltYQF0RXAI0CO6BCoTjPcnG
OjoArH9tWcydxE2SGEiaZ1r/dpHF3qyuNFwC+tpOAHDXu/TQ7mhOFjeqD+sMGt9d
/k+KFEHO0gvyllsD/v0K4vZj2+anicn7T2Z/j/1NJTVVfLR/dIvK4yWHI+ZYaB00
vh35bgtbtYkjVQsQSo0cSA9v5QoStK0f3pl286OGHyNLqKr/UiExKTwjprUehp0i
jtJHz2lw/ddnvVgokEJf2HvH1q0SA7p4rKxaECWHKeYqXsN/oA//l4RPtn0mWCZC
mBP+OjW1yAUVjwy/ZL+a3SgW+cfEZL4/JVuL7WW2NiGmimVmRJs=
=Jifn
-----END PGP SIGNATURE-----

--cDyoBSpeMmeqjtIY--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
