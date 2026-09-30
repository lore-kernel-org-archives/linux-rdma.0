Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682BF509F1E;
	Wed, 30 Sep 2026 13:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790773264; cv=none; b=D4ju523mRzgiUixsCfDnIROgFl0ONYKyvjr30t72UVH9Gz9o5qdmiYKpY74TiCjXsvHqnMmbFctmWuqbKrO9aPH8EoA5YObJ+QV1/tv/OJ3Knjt9BG+mpXkznwH16LtWQGJ5D1mX78y2OqcNUgDJYsGJHSD21Im/rwx1c78rt80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790773264; c=relaxed/simple;
	bh=eDOBQ0sI6jwv2fSXrFVF9EVCCIef4Z7DGvmB2qPGXg0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WgTc8KA9p0Ce56fwSmsB+CU8ugUVWXG4pquumtWJn3+QyTNuubefbg38F5yDHfWlyPMMwtugBeOZlKiIzOhLzIJzjpQRHmXCOEcKUFkkhA84IEtZkjcVnWL5s88hps+k8MXC+waX9Parz8Bjkr5sDLhi6U1NYKYCGp7zsh/qLAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=omLMeigl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="omLMeigl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274971F00898;
	Wed, 30 Sep 2026 13:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790773251;
	bh=0mnA+wuSEJyKuBsuy6q0lDxhxJwnhdk5TJJeIGNWwi8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=omLMeiglE+i3zrVprdQbgl3rxkFCiIpWGagVXBZRkrnwEH6c2jpF+q00vrMvdo+h3
	 SLLexCfrNRmYh/AgrBQ5XWi3TXZzSW3QE8MIvKKe17XbLctF9KWnY0jRAtFkfo/hiJ
	 PgM3x8+WvzVPex+tMgLnTNp/rIV0nokOfFnj0joMHNmvCJUpeHhqmium9GJshAp7Bd
	 p/0o1t0aFXpywPWeTuJ2xuIEg2H4X39AJq8BP5Ctrf1ASMeXc8YvSYfCEQgmH/zXUZ
	 rHrSvsLAoLtno446KapA1g9cyXnmLUvDNNsCqnEGEyPXjGuxvdO/GaE9zP65Yz9asi
	 c2Kj71cOCazrw==
Date: Wed, 30 Sep 2026 16:00:47 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Honggang LI <honggangli@163.com>
Cc: zyjzyj2000@gmail.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] RDMA/rxe: Fix out-of-range unsigned-to-signed
 conversion for RDMA message in 2GiB size
Message-ID: <20260930130047.GF3401365@unreal>
References: <20260929055853.164026-1-honggangli@163.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929055853.164026-1-honggangli@163.com>

On Tue, Sep 29, 2026 at 01:58:53PM +0800, Honggang LI wrote:
> When RDMA READ request for 2GiB in single WR, res->read.resid is u32
> 0x80000000, which is INT_MIN (-2147483648).
> 
>     payload = min_t(int, res->read.resid, mtu);
> 
> The `min_t` function will return -2147483648 for payload. The wrong
> size is propagated through call chain, `read_reply` -> `prepare_ack_packet`
> -> `rxe_init_packet` -> `alloc_skb` . `alloc_skb` failed because of
> invalid size. The passive side failed to emit response packet for RDMA
> READ request.
> 
> After fixed it, the active side of RDMA READ failed with error code
> "IB_WC_LOC_PROT_ERR". When RDMA_READ_RESPONSE_FIRST packet recived by
> the active side, `do_read` call `copy_data`. dma->resid is u32 0x80000000.
> 
>    int resid	= dma->resid;
> 
> This conversion set resid to -2147483648. `copy_data` abort as length
> greater than resid.
> 
> RDMA SEND and WRITE 2GiB message works too, after fixed these two bugs.
> 
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Signed-off-by: Honggang LI <honggangli@163.com>
> ---
> Change log:
> v2 -> v1:
> Use u32 for must-be-unsized quantities, no unsigned-to-signed conversion
> 
>  drivers/infiniband/sw/rxe/rxe_loc.h  |  4 ++--
>  drivers/infiniband/sw/rxe/rxe_mr.c   |  8 ++++----
>  drivers/infiniband/sw/rxe/rxe_net.c  |  2 +-
>  drivers/infiniband/sw/rxe/rxe_resp.c | 17 +++++++++--------
>  4 files changed, 16 insertions(+), 15 deletions(-)

This patch doesn't apply.

Thanks

> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
> index 64d636bf80fd..b5aaba7cf76f 100644
> --- a/drivers/infiniband/sw/rxe/rxe_loc.h
> +++ b/drivers/infiniband/sw/rxe/rxe_loc.h
> @@ -64,7 +64,7 @@ int rxe_flush_pmem_iova(struct rxe_mr *mr, u64 iova, unsigned int length);
>  int rxe_mr_copy(struct rxe_mr *mr, u64 iova, void *addr,
>  		unsigned int length, enum rxe_mr_copy_dir dir);
>  int copy_data(struct rxe_pd *pd, int access, struct rxe_dma_info *dma,
> -	      void *addr, int length, enum rxe_mr_copy_dir dir);
> +	      void *addr, u32 length, enum rxe_mr_copy_dir dir);
>  int rxe_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg,
>  		  int sg_nents, unsigned int *sg_offset);
>  enum resp_states rxe_mr_do_atomic_op(struct rxe_mr *mr, u64 iova, int opcode,
> @@ -91,7 +91,7 @@ void rxe_mw_cleanup(struct rxe_pool_elem *elem);
>  
>  /* rxe_net.c */
>  struct sk_buff *rxe_init_packet(struct rxe_dev *rxe, struct rxe_av *av,
> -				int paylen, struct rxe_pkt_info *pkt);
> +				u32 paylen, struct rxe_pkt_info *pkt);
>  int rxe_prepare(struct rxe_av *av, struct rxe_pkt_info *pkt,
>  		struct sk_buff *skb);
>  int rxe_xmit_packet(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
> diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
> index 71d9ea477289..f2ffbefb9675 100644
> --- a/drivers/infiniband/sw/rxe/rxe_mr.c
> +++ b/drivers/infiniband/sw/rxe/rxe_mr.c
> @@ -418,13 +418,13 @@ int copy_data(
>  	int			access,
>  	struct rxe_dma_info	*dma,
>  	void			*addr,
> -	int			length,
> +	u32			length,
>  	enum rxe_mr_copy_dir	dir)
>  {
> -	int			bytes;
> +	u32			bytes;
>  	struct rxe_sge		*sge	= &dma->sge[dma->cur_sge];
> -	int			offset	= dma->sge_offset;
> -	int			resid	= dma->resid;
> +	u32			offset	= dma->sge_offset;
> +	u32			resid	= dma->resid;
>  	struct rxe_mr		*mr	= NULL;
>  	u64			iova;
>  	int			err;
> diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
> index 53daaf4c1eb2..f548f312b393 100644
> --- a/drivers/infiniband/sw/rxe/rxe_net.c
> +++ b/drivers/infiniband/sw/rxe/rxe_net.c
> @@ -536,7 +536,7 @@ int rxe_xmit_packet(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
>  }
>  
>  struct sk_buff *rxe_init_packet(struct rxe_dev *rxe, struct rxe_av *av,
> -				int paylen, struct rxe_pkt_info *pkt)
> +				u32 paylen, struct rxe_pkt_info *pkt)
>  {
>  	unsigned int hdr_len;
>  	struct sk_buff *skb = NULL;
> diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
> index 02b16e2b49b8..4e71bc985721 100644
> --- a/drivers/infiniband/sw/rxe/rxe_resp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_resp.c
> @@ -612,7 +612,7 @@ static enum resp_states check_rkey(struct rxe_qp *qp,
>  }
>  
>  static enum resp_states send_data_in(struct rxe_qp *qp, void *data_addr,
> -				     int data_len)
> +				     u32 data_len)
>  {
>  	int err;
>  
> @@ -827,20 +827,21 @@ static enum resp_states atomic_write_reply(struct rxe_qp *qp,
>  static struct sk_buff *prepare_ack_packet(struct rxe_qp *qp,
>  					  struct rxe_pkt_info *ack,
>  					  int opcode,
> -					  int payload,
> +					  u32 payload,
>  					  u32 psn,
>  					  u8 syndrome)
>  {
>  	struct rxe_dev *rxe = to_rdev(qp->ibqp.device);
>  	struct sk_buff *skb;
> -	int paylen;
> -	int pad;
> +	u32 paylen;
> +	u32 pad = 0;
>  	int err;
>  
>  	/*
>  	 * allocate packet
>  	 */
> -	pad = (-payload) & 0x3;
> +	if (payload % 4)
> +		pad = 4 - payload % 4;
>  	paylen = rxe_opcode[opcode].length + payload + pad + RXE_ICRC_SIZE;
>  
>  	skb = rxe_init_packet(rxe, &qp->pri_av, paylen, ack);
> @@ -934,9 +935,9 @@ static enum resp_states read_reply(struct rxe_qp *qp,
>  {
>  	struct rxe_pkt_info ack_pkt;
>  	struct sk_buff *skb;
> -	int mtu = qp->mtu;
> +	u32 mtu = qp->mtu;
>  	enum resp_states state;
> -	int payload;
> +	u32 payload;
>  	int opcode;
>  	int err;
>  	struct resp_res *res = qp->resp.res;
> @@ -982,7 +983,7 @@ static enum resp_states read_reply(struct rxe_qp *qp,
>  
>  	res->state = rdatm_res_state_next;
>  
> -	payload = min_t(int, res->read.resid, mtu);
> +	payload = min(res->read.resid, mtu);
>  
>  	skb = prepare_ack_packet(qp, &ack_pkt, opcode, payload,
>  				 res->cur_psn, AETH_ACK_UNLIMITED);
> -- 
> 2.54.0
> 
