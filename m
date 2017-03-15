From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-core v3 8/9] libbnxt_re: Add support for atomic operations
Date: Wed, 15 Mar 2017 21:15:15 +0200
Message-ID: <20170315191515.GH2079@mtr-leonro.local>
References: <1489574253-20300-1-git-send-email-devesh.sharma@broadcom.com>
 <1489574253-20300-9-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fCmRXBY78W5odcVA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1489574253-20300-9-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--fCmRXBY78W5odcVA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 15, 2017 at 06:37:32AM -0400, Devesh Sharma wrote:
> This patch adds support for compare-and-swap and fetch-and-add
> atomic operations in user library.
>
> v1->v2
>  -- Fixed the missing "break"
>  -- Changed macros to inline function
>
> Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> ---
>  providers/bnxt_re/bnxt_re-abi.h |  3 ++-
>  providers/bnxt_re/main.h        |  8 +++++-
>  providers/bnxt_re/memory.h      | 10 +++++++
>  providers/bnxt_re/verbs.c       | 58 +++++++++++++++++++++++++++++++++++------
>  4 files changed, 69 insertions(+), 10 deletions(-)
>
> diff --git a/providers/bnxt_re/bnxt_re-abi.h b/providers/bnxt_re/bnxt_re-abi.h
> index 581e1b7..557221b 100644
> --- a/providers/bnxt_re/bnxt_re-abi.h
> +++ b/providers/bnxt_re/bnxt_re-abi.h
> @@ -54,7 +54,8 @@ enum bnxt_re_wr_opcode {
>  	BNXT_RE_WR_OPCD_ATOMIC_FA	= 0x0B,
>  	BNXT_RE_WR_OPCD_LOC_INVAL	= 0x0C,
>  	BNXT_RE_WR_OPCD_BIND		= 0x0E,
> -	BNXT_RE_WR_OPCD_RECV		= 0x80
> +	BNXT_RE_WR_OPCD_RECV		= 0x80,
> +	BNXT_RE_WR_OPCD_INVAL		= 0xFF
>  };
>
>  enum bnxt_re_wr_flags {
> diff --git a/providers/bnxt_re/main.h b/providers/bnxt_re/main.h
> index 9d99c64..a417328 100644
> --- a/providers/bnxt_re/main.h
> +++ b/providers/bnxt_re/main.h
> @@ -236,9 +236,15 @@ static inline uint8_t bnxt_re_ibv_to_bnxt_wr_opcd(uint8_t ibv_opcd)
>  	case IBV_WR_RDMA_READ:
>  		bnxt_opcd = BNXT_RE_WR_OPCD_RDMA_READ;
>  		break;
> +	case IBV_WR_ATOMIC_CMP_AND_SWP:
> +		bnxt_opcd = BNXT_RE_WR_OPCD_ATOMIC_CS;
> +		break;
> +	case IBV_WR_ATOMIC_FETCH_AND_ADD:
> +		bnxt_opcd = BNXT_RE_WR_OPCD_ATOMIC_FA;
> +		break;
>  		/* TODO: Add other opcodes */
>  	default:
> -		bnxt_opcd = 0xFF;
> +		bnxt_opcd = BNXT_RE_WR_OPCD_INVAL;
>  		break;
>  	};
>
> diff --git a/providers/bnxt_re/memory.h b/providers/bnxt_re/memory.h
> index debb31a..d7e6a92 100644
> --- a/providers/bnxt_re/memory.h
> +++ b/providers/bnxt_re/memory.h
> @@ -83,6 +83,16 @@ static inline void iowrite32(__u32 *dst, uint32_t *src)
>  	*(volatile __u32 *)dst = *src;
>  }
>
> +static inline __u32 upper_32_bits(uint64_t n)
> +{
> +	return (__u32)((n >> 16) >> 16);
> +}
> +
> +static inline __u32 lower_32_bits(uint64_t n)
> +{
> +	return (__u32)(n & 0xFFFFFFFFUL);
> +}
> +
>  /* Basic queue operation */
>  static inline uint32_t bnxt_re_is_que_full(struct bnxt_re_queue *que)
>  {
> diff --git a/providers/bnxt_re/verbs.c b/providers/bnxt_re/verbs.c
> index e60010d..85d77cd 100644
> --- a/providers/bnxt_re/verbs.c
> +++ b/providers/bnxt_re/verbs.c
> @@ -1068,6 +1068,9 @@ static int bnxt_re_build_send_sqe(struct bnxt_re_qp *qp, void *wqe,
>
>  	/* Fill Header */
>  	opcode = bnxt_re_ibv_to_bnxt_wr_opcd(wr->opcode);
> +	if (opcode == BNXT_RE_WR_OPCD_INVAL)
> +		return -EINVAL;
> +
>  	hdr->rsv_ws_fl_wt |= (opcode & BNXT_RE_HDR_WT_MASK);
>
>  	if (is_inline) {
> @@ -1116,6 +1119,44 @@ static int bnxt_re_build_rdma_sqe(struct bnxt_re_qp *qp, void *wqe,
>  	return len;
>  }
>
> +static int bnxt_re_build_cns_sqe(struct bnxt_re_qp *qp, void *wqe,
> +				 struct ibv_send_wr *wr)
> +{
> +	struct bnxt_re_bsqe *hdr = wqe;
> +	struct bnxt_re_atomic *sqe = ((void *)wqe +
> +				      sizeof(struct bnxt_re_bsqe));
> +	int len;
> +
> +	len = bnxt_re_build_send_sqe(qp, wqe, wr, false);
> +	hdr->key_immd = wr->wr.atomic.rkey;
> +	sqe->rva_lo = lower_32_bits(wr->wr.atomic.remote_addr);
> +	sqe->rva_hi = upper_32_bits(wr->wr.atomic.remote_addr);
> +	sqe->cmp_dt_lo = lower_32_bits(wr->wr.atomic.compare_add);
> +	sqe->cmp_dt_hi = upper_32_bits(wr->wr.atomic.compare_add);
> +	sqe->swp_dt_lo = lower_32_bits(wr->wr.atomic.swap);
> +	sqe->swp_dt_hi = upper_32_bits(wr->wr.atomic.swap);
> +

Sorry for my question, but why do you need to separate uint64_t variable
to two __u32? Why can't you declare one __u64?

> +	return len;
> +}
> +
> +static int bnxt_re_build_fna_sqe(struct bnxt_re_qp *qp, void *wqe,
> +				 struct ibv_send_wr *wr)
> +{
> +	struct bnxt_re_bsqe *hdr = wqe;
> +	struct bnxt_re_atomic *sqe = ((void *)wqe +
> +				      sizeof(struct bnxt_re_bsqe));
> +	int len;
> +
> +	len = bnxt_re_build_send_sqe(qp, wqe, wr, false);
> +	hdr->key_immd = wr->wr.atomic.rkey;
> +	sqe->rva_lo = lower_32_bits(wr->wr.atomic.remote_addr);
> +	sqe->rva_hi = upper_32_bits(wr->wr.atomic.remote_addr);
> +	sqe->cmp_dt_lo = lower_32_bits(wr->wr.atomic.compare_add);
> +	sqe->cmp_dt_hi = upper_32_bits(wr->wr.atomic.compare_add);
> +
> +	return len;
> +}
> +
>  int bnxt_re_post_send(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
>  		      struct ibv_send_wr **bad)
>  {
> @@ -1169,27 +1210,28 @@ int bnxt_re_post_send(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
>  			else
>  				bytes = bnxt_re_build_send_sqe(qp, sqe, wr,
>  							       is_inline);
> -			if (bytes < 0)
> -				ret = (bytes == -EINVAL) ? EINVAL : ENOMEM;
>  			break;
>  		case IBV_WR_RDMA_WRITE_WITH_IMM:
>  			hdr->key_immd = wr->imm_data;
>  		case IBV_WR_RDMA_WRITE:
>  			bytes = bnxt_re_build_rdma_sqe(qp, sqe, wr, is_inline);
> -			if (bytes < 0)
> -				ret = ENOMEM;
>  			break;
>  		case IBV_WR_RDMA_READ:
>  			bytes = bnxt_re_build_rdma_sqe(qp, sqe, wr, false);
> -			if (bytes < 0)
> -				ret = ENOMEM;
> +			break;
> +		case IBV_WR_ATOMIC_CMP_AND_SWP:
> +			bytes = bnxt_re_build_cns_sqe(qp, sqe, wr);
> +			break;
> +		case IBV_WR_ATOMIC_FETCH_AND_ADD:
> +			bytes = bnxt_re_build_fna_sqe(qp, sqe, wr);
>  			break;
>  		default:
> -			ret = EINVAL;
> +			bytes = -EINVAL;
>  			break;
>  		}
>
> -		if (ret) {
> +		if (bytes < 0) {
> +			ret = (bytes == -EINVAL) ? EINVAL : ENOMEM;
>  			*bad = wr;
>  			break;
>  		}
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--fCmRXBY78W5odcVA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljJksMACgkQ5GN7iDZy
WKe17A//b6WHBubc0VK49FMdZRENNx/ENmaFq+eY8rj71vg0RefvZbZ3vKQdzWKo
r2S0hbW3iotpqY35Bii7/B7RTXH6+l/acyExnFIaY966wCqiH1P9e/UD1LUROzOr
C2ADp0YGK2dOya3CGFUq5ZFXR1NYM2HrdJV1l7Z9PLMZtwqVZrzoxm8u1rEYzit7
L95yi263GbcZFLXeruCnMqhjExehoPRejfnhqolJ1Gc8uRirkcDKeAH6iL+c9rjt
Si83hgB0g31DbNJLnIZFbSpjHprW2J5TKHUf+2jC3sIN3Kux9dmaPSckX6FI+8el
uyDhSxpvJP/Im0giyPYzdNIpNf8r3L38o+LnCk0WoolgjwiiDtm7ENh50N+ZdLZr
8s0ai4/V1KgVO0ppm/cfqH1pNPvo958146CIcjto8gmc5ZQBl82g6kI2uyjYHHYv
HfqhDQA8rAiC95dxVE5Aah4JcCcoYX8KrFTZQEl3SIkKvX7CNkpsFsr/TcQnuvqb
rEiBOY/301+SqOArfPv4L/tu3LZIxoKoHr8du3zqFwKd3CqnCs96wUAWEFQkr5w0
J1n5Ma8T+zn5BJLuep6d8G002l7o0qOwEBcDv0UV97+hKJaCDluNuOCN/6DMwYtv
pHviQ7fM8AnT5fG1TJ8yZJLsgKomU+VIbaFjLGPrcKWaLtqYpig=
=nM5N
-----END PGP SIGNATURE-----

--fCmRXBY78W5odcVA--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
