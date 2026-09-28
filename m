Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E545B369D5E;
	Mon, 28 Sep 2026 19:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790623122; cv=none; b=biXuB8QCZ8+Ufi8B0DJ7Vg5C+Qr4XsofrFtX+KRwrW09OtvZWriB/BVhp+XDXLUAq23lE2ICcThEMGOwZDu4m6YwSr4U9ZztKpfWK3HQn88qg446+ItcAyWySRHee848lTjIQBafYYhNgJe3PdtDBz7b8G6hovHMMEKzZP9a1Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790623122; c=relaxed/simple;
	bh=d1VQbwiVEJnrnWvNkhXwoPCVWMME9TO6RyCcEtoU06o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m2twJB6XtiCde3qs8vOmer0jiWkBN5xqdQhhpi4Pjckh8yJEH6NElTaFHocb71/qtiWnmagyZwdSHtV8JJQl60woBhSEmksVz+rMjpWN4V/mU0H7nYweD4juLWlxm0JkhOjyBJQv8uRMs4MhdIwb4aFzXthngQZ84jbKPuRqAJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fCeqvE77; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fCeqvE77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC9F81F00893;
	Mon, 28 Sep 2026 19:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790623120;
	bh=IfwDCpIqTNrmbQmDnN3FyT9IYGj2UesKbsIEKNomuwc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fCeqvE77oI8Lk+zetPmRRNxvG9bz5V4Acp2661WXI4EOvfwyzs8Hs89D8aPQtN76h
	 Z50YrEtMQ2vPELolzvLQii5EG4TMyGEfWE7Msb34f+oJ9zuYbmHd4F1zePOZclKVpl
	 R+MeK/20bD73sBvpn8NgepjGVCnC93KB44Pk0Fw81+zXjrrDfvaUnx/NoB/RR9V4lG
	 rItJMRKnQJz9a4SvtqB6eHqmtZUQqnE+bs9qrXYxXTnbMeZyxo7BBqCex2zCvZXwIG
	 HcTXzX81C8R0MCjcTGgD6hOt4BWOLBeWui6uocnkK9j6DqxtopHGbwYl68Pl3VtcBM
	 Y1fV0DHEhXuxg==
Date: Mon, 28 Sep 2026 22:18:37 +0300
From: Leon Romanovsky <leon@kernel.org>
To: quanyeyang@proton.me
Cc: "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Danil Kipnis <danil.kipnis@cloud.ionos.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Farhad Alemi <farhad.alemi@berkeley.edu>
Subject: Re: [PATCH] RDMA/rtrs-clt: Fix recv repost to satisfy ib_drain_rq
Message-ID: <20260928191837.GC563127@unreal>
References: <20260921-rtrs-fix-ib-drain-rq-v1-1-11b1637958ba@proton.me>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260921-rtrs-fix-ib-drain-rq-v1-1-11b1637958ba@proton.me>

On Mon, Sep 21, 2026 at 07:04:47AM -0700, Quanye Yang via B4 Relay wrote:
> From: Quanye Yang <quanyeyang@proton.me>
> 
> On disconnect the client error recovery path calls ib_drain_qp(), which
> requires one free RQ slot and that no recv WQEs are posted while the
> queue is being drained.
> 
> The legacy recv completion path deferred reposting invalidate receives
> and instead posted two empty recv WQEs when handling RDMA-with-IMM
> responses marked with invalidation.  If an invalidate receive never
> arrived, each such response increased RQ occupancy by one until
> ib_post_recv() started returning -ENOMEM and __ib_drain_rq() failed with:
> 
>   failed to drain recv queue: -12
> 
> Repost one empty recv WQE for every receive completion, including legacy
> SEND_WITH_INV invalidates, and only while the path is still connected
> so CQ polling cannot race with ib_drain_qp().  Size IO connection RQs to
> 2 * queue_depth + 1 to match the posted recv count and leave the drain
> slot.

Could you clarify what “legacy” means in this commit message?
Haris, Jack, does this patch look good to you?

Thanks

> 
> Tested with a synthetic RTRS client flooding unpaired
> RTRS_IO_RSP_W_INV_IMM messages; error recovery no longer triggers
> __ib_drain_rq() warnings.
> 
> Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
> Signed-off-by: Quanye Yang <quanyeyang@proton.me>
> Tested-by: Quanye Yang <quanyeyang@proton.me>
> Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> Link: https://lore.kernel.org/linux-rdma/CA+0ovCihE2_pxLimjmmR8NMz4g-ie8dvvq1jmAj-Om33y3Vzfg@mail.gmail.com
> ---
>  drivers/infiniband/ulp/rtrs/rtrs-clt.c | 45 ++++++++++++----------------------
>  1 file changed, 15 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> index eac38b57b00d..ee6d5c3de16c 100644
> --- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> +++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> @@ -577,25 +577,21 @@ static struct ib_cqe io_comp_cqe = {
>  	.done = rtrs_clt_rdma_done
>  };
>  
> -/*
> - * Post x2 empty WRs: first is for this RDMA with IMM,
> - * second is for RECV with INV, which happened earlier.
> - */
> -static int rtrs_post_recv_empty_x2(struct rtrs_con *con, struct ib_cqe *cqe)
> +static int rtrs_clt_repost_recv(struct rtrs_clt_con *con)
>  {
> -	struct ib_recv_wr wr_arr[2], *wr;
> -	int i;
> +	struct rtrs_clt_path *clt_path = to_clt_path(con->c.path);
> +	int err;
>  
> -	memset(wr_arr, 0, sizeof(wr_arr));
> -	for (i = 0; i < ARRAY_SIZE(wr_arr); i++) {
> -		wr = &wr_arr[i];
> -		wr->wr_cqe  = cqe;
> -		if (i)
> -			/* Chain backwards */
> -			wr->next = &wr_arr[i - 1];
> -	}
> +	if (READ_ONCE(clt_path->state) != RTRS_CLT_CONNECTED)
> +		return 0;
>  
> -	return ib_post_recv(con->qp, wr, NULL);
> +	err = rtrs_post_recv_empty(&con->c, &io_comp_cqe);
> +	if (err) {
> +		rtrs_err(con->c.path, "rtrs_post_recv_empty(): %pe\n",
> +			 ERR_PTR(err));
> +		rtrs_rdma_error_recovery(con);
> +	}
> +	return err;
>  }
>  
>  static void rtrs_clt_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
> @@ -650,19 +646,7 @@ static void rtrs_clt_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
>  			rtrs_wrn(con->c.path, "Unknown IMM type %u\n",
>  				  imm_type);
>  		}
> -		if (w_inval)
> -			/*
> -			 * Post x2 empty WRs: first is for this RDMA with IMM,
> -			 * second is for RECV with INV, which happened earlier.
> -			 */
> -			err = rtrs_post_recv_empty_x2(&con->c, &io_comp_cqe);
> -		else
> -			err = rtrs_post_recv_empty(&con->c, &io_comp_cqe);
> -		if (err) {
> -			rtrs_err(con->c.path, "rtrs_post_recv_empty(): %pe\n",
> -				 ERR_PTR(err));
> -			rtrs_rdma_error_recovery(con);
> -		}
> +		rtrs_clt_repost_recv(con);
>  		break;
>  	case IB_WC_RECV:
>  		/*
> @@ -678,6 +662,7 @@ static void rtrs_clt_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
>  
>  			return  rtrs_clt_rkey_rsp_done(con, wc);
>  		}
> +		rtrs_clt_repost_recv(con);
>  		break;
>  	case IB_WC_RDMA_WRITE:
>  		/*
> @@ -1693,7 +1678,7 @@ static int create_con_cq_qp(struct rtrs_clt_con *con)
>  		clt_path->s.dev_ref++;
>  		/* QD * (REQ + RSP + FR REGS or INVS) + drain */
>  		max_send_wr = min(wr_limit, clt_path->queue_depth * 4 + 1);
> -		max_recv_wr = min(wr_limit, clt_path->queue_depth * 3 + 1);
> +		max_recv_wr = min(wr_limit, clt_path->queue_depth * 2 + 1);
>  		max_send_sge = 2;
>  	}
>  	atomic_set(&con->c.sq_wr_avail, max_send_wr);
> 
> ---
> base-commit: 93f51579e7df248780214094418f205253383cc5
> change-id: 20260921-rtrs-fix-ib-drain-rq-61dc85d0d759
> 
> Best regards,
> --  
> Quanye Yang <quanyeyang@proton.me>
> 
> 
