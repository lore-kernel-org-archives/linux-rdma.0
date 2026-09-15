Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1191486E51;
	Tue, 15 Sep 2026 11:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789472959; cv=none; b=u22IqDIhFMhct3+c7TbH0K92F2rMQOPz2ewWSc7GYTJPIc/M6k7dQzn3O04kHjmLolUHwCRE3wq1RKG+S6d2UirRawC+TzPangKw4QNh5Etr8pq4Gylqcq+wecnuRKaVhoPmSaYukwHmS/1PBzbb5QYXUQ96laWLTLnfJpvnKDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789472959; c=relaxed/simple;
	bh=DyenADku4Ln8wkpnsa+tnu9/7S/0K5yXS0acloArQ1I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GxL03KwM7QiT/xiwYepPS5+E1H/6SHfKT1cwoYdGU9hmmr4CLkH3s8EdlVn7SYeRdHG0wOvrOvNNiZx+JjneOZBD7tczfuYdToEppIVTCK3y5HKU54426SkZOoudcYEkRQWSIWdbhzWNrOP0c0dwy8O7U3fU9LWPum6fqpFkEgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kYxfflnP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kYxfflnP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4D11F00893;
	Tue, 15 Sep 2026 11:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472958;
	bh=4/+uXQplOjFYVA2X7ySNwf4JAE8IWCZdizV/JLqFrVQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kYxfflnPoNNpMSdrSK6ZuB6UOayjNvHsVdX3mVDtSrCDzdWVF+x3XF87FWQhszcbY
	 JjlfvysusZO8j2Ju2bchpA6PD0oe+4ZGt9t7L5kySEjTZuWd4PW6CWrRAvcWDFrGbX
	 ftOi9I4z5W6J2ZAGMqWqdF8FuQGMnVX2bMJqxbXGeolraorz1YRd6Lj2k/pftB4BQ/
	 gmrTr4XBySJpohV8KTDF3lw/QODNIH+iIZ1ZFhWDK2lnmpMUanHlcyMUGnbedNxvFx
	 lQvL5NCEiGZG7nKHULDT2cIpdAB3iGnncTqfmWYWBN6dSCo9cRvIevXp8Y2acPXjTp
	 9enaewK/wn0xA==
Date: Tue, 15 Sep 2026 14:49:14 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Honggang LI <honggangli@163.com>
Cc: zyjzyj2000@gmail.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/rxe: Fix out-of-range unsigned-to-signed conversion
 for RDMA message in 2GiB size
Message-ID: <20260915114914.GL13683@unreal>
References: <20260915064532.194540-1-honggangli@163.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915064532.194540-1-honggangli@163.com>

On Tue, Sep 15, 2026 at 02:45:32PM +0800, Honggang LI wrote:
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
> greater than resid. Change resid to int64_t fixes this issue.

Why not size_t?

> 
> RDMA SEND and WRITE 2GiB message works too, after fixed these two bugs.
> 
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Signed-off-by: Honggang LI <honggangli@163.com>
> ---
>  drivers/infiniband/sw/rxe/rxe_loc.h  | 2 +-
>  drivers/infiniband/sw/rxe/rxe_mr.c   | 4 ++--
>  drivers/infiniband/sw/rxe/rxe_resp.c | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
> index 64d636bf80fd..9acf2494bb94 100644
> --- a/drivers/infiniband/sw/rxe/rxe_loc.h
> +++ b/drivers/infiniband/sw/rxe/rxe_loc.h
> @@ -64,7 +64,7 @@ int rxe_flush_pmem_iova(struct rxe_mr *mr, u64 iova, unsigned int length);
>  int rxe_mr_copy(struct rxe_mr *mr, u64 iova, void *addr,
>  		unsigned int length, enum rxe_mr_copy_dir dir);
>  int copy_data(struct rxe_pd *pd, int access, struct rxe_dma_info *dma,
> -	      void *addr, int length, enum rxe_mr_copy_dir dir);
> +	      void *addr, int64_t length, enum rxe_mr_copy_dir dir);
>  int rxe_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg,
>  		  int sg_nents, unsigned int *sg_offset);
>  enum resp_states rxe_mr_do_atomic_op(struct rxe_mr *mr, u64 iova, int opcode,
> diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
> index 71d9ea477289..1a9005f11079 100644
> --- a/drivers/infiniband/sw/rxe/rxe_mr.c
> +++ b/drivers/infiniband/sw/rxe/rxe_mr.c
> @@ -418,13 +418,13 @@ int copy_data(
>  	int			access,
>  	struct rxe_dma_info	*dma,
>  	void			*addr,
> -	int			length,
> +	int64_t			length,
>  	enum rxe_mr_copy_dir	dir)
>  {
>  	int			bytes;
>  	struct rxe_sge		*sge	= &dma->sge[dma->cur_sge];
>  	int			offset	= dma->sge_offset;
> -	int			resid	= dma->resid;
> +	int64_t			resid	= dma->resid;
>  	struct rxe_mr		*mr	= NULL;
>  	u64			iova;
>  	int			err;
> diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
> index 02b16e2b49b8..52bce17511dc 100644
> --- a/drivers/infiniband/sw/rxe/rxe_resp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_resp.c
> @@ -982,7 +982,7 @@ static enum resp_states read_reply(struct rxe_qp *qp,
>  
>  	res->state = rdatm_res_state_next;
>  
> -	payload = min_t(int, res->read.resid, mtu);
> +	payload = min_t(u32, res->read.resid, mtu);

Why don't we use the proper types from the start to avoid the need for
u32 casts?

Thanks

>  
>  	skb = prepare_ack_packet(qp, &ack_pkt, opcode, payload,
>  				 res->cur_psn, AETH_ACK_UNLIMITED);
> -- 
> 2.54.0
> 
