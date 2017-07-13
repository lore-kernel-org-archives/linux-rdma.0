From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/8] mlx4: Add sparse annotations
Date: Thu, 13 Jul 2017 10:23:43 +0300
Message-ID: <20170713072343.GI1528@mtr-leonro.local>
References: <1499894262-10761-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1499894262-10761-4-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3F6LqILQjGsImgZu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1499894262-10761-4-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--3F6LqILQjGsImgZu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 12, 2017 at 03:17:37PM -0600, Jason Gunthorpe wrote:
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  CMakeLists.txt          |  4 +--
>  providers/mlx4/cq.c     |  8 +++--
>  providers/mlx4/dbrec.c  |  6 ++--
>  providers/mlx4/mlx4.h   | 16 +++++-----
>  providers/mlx4/mlx4dv.h | 84 ++++++++++++++++++++++++-------------------------
>  providers/mlx4/qp.c     |  4 +--
>  providers/mlx4/verbs.c  | 11 ++-----
>  7 files changed, 64 insertions(+), 69 deletions(-)
>
> diff --git a/CMakeLists.txt b/CMakeLists.txt
> index 16196205035f61..1f319390f2e05c 100644
> --- a/CMakeLists.txt
> +++ b/CMakeLists.txt
> @@ -414,8 +414,8 @@ add_subdirectory(providers/cxgb3) # NO SPARSE
>  add_subdirectory(providers/cxgb4) # NO SPARSE
>  add_subdirectory(providers/hns) # NO SPARSE
>  add_subdirectory(providers/i40iw) # NO SPARSE
> -add_subdirectory(providers/mlx4) # NO SPARSE
> -add_subdirectory(providers/mlx4/man) # NO SPARSE
> +add_subdirectory(providers/mlx4)
> +add_subdirectory(providers/mlx4/man)
>  add_subdirectory(providers/mlx5) # NO SPARSE
>  add_subdirectory(providers/mlx5/man) # NO SPARSE
>  add_subdirectory(providers/mthca) # NO SPARSE
> diff --git a/providers/mlx4/cq.c b/providers/mlx4/cq.c
> index 50adebb82237f2..afc0e3b8c8eeb1 100644
> --- a/providers/mlx4/cq.c
> +++ b/providers/mlx4/cq.c
> @@ -287,7 +287,7 @@ static inline int mlx4_parse_cqe(struct mlx4_cq *cq,
>  		case MLX4_RECV_OPCODE_SEND_INVAL:
>  			wc->opcode   = IBV_WC_RECV;
>  			wc->wc_flags |= IBV_WC_WITH_INV;
> -			wc->imm_data = be32toh(cqe->immed_rss_invalid);
> +			wc->invalidated_rkey = be32toh(cqe->immed_rss_invalid);
>  			break;
>  		case MLX4_RECV_OPCODE_SEND:
>  			wc->opcode   = IBV_WC_RECV;
> @@ -550,13 +550,15 @@ static uint32_t mlx4_cq_read_wc_vendor_err(struct ibv_cq_ex *ibcq)
>  	return ecqe->vendor_err;
>  }
>
> -static uint32_t mlx4_cq_read_wc_imm_data(struct ibv_cq_ex *ibcq)
> +static __be32 mlx4_cq_read_wc_imm_data(struct ibv_cq_ex *ibcq)
>  {
>  	struct mlx4_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
>
>  	switch (mlx4dv_get_cqe_opcode(cq->cqe)) {
>  	case MLX4_RECV_OPCODE_SEND_INVAL:
> -		return be32toh(cq->cqe->immed_rss_invalid);
> +		/* This is returning invalidate_rkey which is in host order, see
> +		 * ibv_wc_read_invalidated_rkey */
> +		return (__force __be32)be32toh(cq->cqe->immed_rss_invalid);

Jason,
It is insane construction, convert to host-> force to be32 -> use as uint32_t.

>  	default:
>  		return cq->cqe->immed_rss_invalid;
>  	}
> diff --git a/providers/mlx4/dbrec.c b/providers/mlx4/dbrec.c
> index 3e875738fa61d8..84b01770dcb2c5 100644
> --- a/providers/mlx4/dbrec.c
> +++ b/providers/mlx4/dbrec.c
> @@ -84,7 +84,7 @@ static struct mlx4_db_page *__add_page(struct mlx4_context *context,
>  	return page;
>  }
>
> -uint32_t *mlx4_alloc_db(struct mlx4_context *context, enum mlx4_db_type type)
> +__be32 *mlx4_alloc_db(struct mlx4_context *context, enum mlx4_db_type type)
>  {
>  	struct mlx4_db_page *page;
>  	uint32_t *db = NULL;
> @@ -113,10 +113,10 @@ found:
>  out:
>  	pthread_mutex_unlock(&context->db_list_mutex);
>
> -	return db;
> +	return (__force __be32 *)db;
>  }

I see that librdmacm/rsocket.c full of these __force annotations.
I would be very happy to see it fixed rather suppressed, but don't know
if it is realistic goal or not.

Thanks

--3F6LqILQjGsImgZu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllnH/8ACgkQ5GN7iDZy
WKdi4A//bte/zxxh4ldfVwTxXgYTqO4NrZAV5PI3yQ1X59ovefa03XCyrP61mLEc
P+FYk3Nw0i0Ci26TCaW6CRIlv7BGMSP3vUaweQuXAnWvuERk5zutfpTs+DXI/t72
BeLsTXVQbnS77cn8s9HjAEEU1Tu3u3pjYCaAEjyoLeqmW0gH6VbxFV5eH4d4/YiL
tIVAsTv62lq1H9a2pePAAD1ix24hPF8Lkc9G3N1Uwi4CKnfPkFW34d1PGWyF6RBQ
zIIe7FRSyEHi0lAl0jzqP1CbR8ZGPfh+XGfAN+cjQ+n8XKJYFPrRYh3k6hDYz2Vp
dNP/lQ7NTOlyvwl6ebYswQRgoE0RB9SKFh5/HQKWjBASAK4WKPSQyLwYHsfAGI+H
07gb/Hc+TJZ6uL9EbWT5pidu1TJSSUNoG4WhfWQY09RFvLsTZjkYxkO7BYcnR8fm
1I9b8lHlnkmyBQyJ3bx+PjPwYEkBod6xuXsF9fmnehBpmttlS2mjvOHBFiZ5K4UN
Lwyml+gfjHHxO0wTyycib9zKH7nMxx72PlGSyKsi2+HWSkB0VXbqBPRZo9NtGN3G
OeUQNSZW2HMxcL3wbKGnDbfw23nBOYtiH1AiPXdR7oYynuMYk2unrE/BSwptZesz
O56yZLh7eFuHKVJ77X4m7AeEQsunQG6UulxTvELecu3ujg8EPJw=
=NAFx
-----END PGP SIGNATURE-----

--3F6LqILQjGsImgZu--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
