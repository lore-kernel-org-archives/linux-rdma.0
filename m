Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432D3377AB9
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 18:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790620449; cv=none; b=R4I/BhRZo6ElE9NPk7UAc6sXZqQOES/LEnT5LGAgq6WegJffPUL0flPaRxVK5L6DEWHGTx85sbnUl5h4p3mamNFah+bgaKKnqGDYRH8wK1Pluulc5u7PiIaAyLAXrlorgUUjJQSwWNhoZe9ystubA+zb7TrPLZRKvedstltCePI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790620449; c=relaxed/simple;
	bh=Z7Ho7crY1K+MTULksI5nlsAD1EDuh/KNI7miS0td2DM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P3xOKswDAvM8M2aMvQliXQyOXshGE6rQrZi1CJQ99K5Grv0GPIdjS9pTsFQvqX6+9Z2dE+//P48sG3liHS8kyr0z81EtlpX75qvuM6+sP9y0f/w6yTz/GRgNwF2xGLWovfOBFuhYkkIiK1fpm+08QlcgLUalri6ylfOodFHjaQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZB/yiCnz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZB/yiCnz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22EE1F000FF;
	Mon, 28 Sep 2026 18:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790620447;
	bh=lNhBN0SPgWqfTUUlKJmZupeV1Z8+F6FFAbcLQGpAnNs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZB/yiCnzm3usPbnBfDHrP7DRdEsKoFobyHNtxV8CqB3h9/b5WTPQj92R6Ahviqp1k
	 rsNRYoyZyuJOQW2i+uWnCHadXwyC4CmfUeM7ljKydMn1KUPGLKXASyOu9htOdMGiM6
	 aAQtabuETfG65qBwYUnoMXRIKa/oQBvuZQ77xb4y7SFDWLZ+/yTtiQY0xq0lI0zObh
	 /+3rQ/E1urvjT9QCtFU53Ve5m+DuVl24ajhyb2sTxKvzM6dqUz3U8enU02YltCePyI
	 el263Lfq+7IMxUN9Q6/v9qPkPw/5NYb+91VYqqBnYHau+7//GqbFQnU+k9W/ii7MWo
	 nF2mYCV6mNlYw==
Date: Mon, 28 Sep 2026 21:34:03 +0300
From: Leon Romanovsky <leon@kernel.org>
To: lirongqing <lirongqing@baidu.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] RDMA/mlx5: Fix CQ resize destination index mask
Message-ID: <20260928183403.GY563127@unreal>
References: <20260919100716.2221-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260919100716.2221-1-lirongqing@baidu.com>

On Sat, Sep 19, 2026 at 06:07:16PM +0800, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> In copy_resize_cqes, the destination CQE index is computed as
> (i + 1) & cq->resize_buf->nent, but resize_buf->nent is the power-of-two
> entry count, so the mask only yields 0 or nent -- and nent is one past the
> last valid slot. The following memcpy then writes out of bounds.
> 
> Use (nent - 1) as the wrap mask, consistent with get_sw_cqe which masks
> against cq->ibcq.cqe (the nent - 1 value).
> 
> Fixes: bde51583f49b ("IB/mlx5: Add support for resize CQ")
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  drivers/infiniband/hw/mlx5/cq.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
> index b0b1177..5bd5227 100644
> --- a/drivers/infiniband/hw/mlx5/cq.c
> +++ b/drivers/infiniband/hw/mlx5/cq.c
> @@ -1319,7 +1319,7 @@ static int copy_resize_cqes(struct mlx5_ib_cq *cq)
>  
>  	while (get_cqe_opcode(scqe64) != MLX5_CQE_RESIZE_CQ) {
>  		dcqe = mlx5_frag_buf_get_wqe(&cq->resize_buf->fbc,
> -					     (i + 1) & cq->resize_buf->nent);
> +					     (i + 1) & (cq->resize_buf->nent - 1));

I think the original intent was to use `(i + 1) % cq->resize_buf->nent`.

Thanks

>  		dcqe64 = dsize == 64 ? dcqe : dcqe + 64;
>  		sw_own = sw_ownership_bit(i + 1, cq->resize_buf->nent);
>  		memcpy(dcqe, scqe, dsize);
> -- 
> 2.9.4
> 
