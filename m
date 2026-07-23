Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B5440BCB6;
	Thu, 23 Jul 2026 09:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784800286; cv=none; b=VFd0/RNLQoaqUvUy/ETmG9vqXEPlmoYmTXo2omSC9jbibivD4R1xDHfuj5K9wNJdJ+3H5Ho0hn3jSKY5u2zVHIH14wyXWZTTlQIRhq4a92xopyVDGCWmCJsPwuj946Le4W9Q1VyhiNvzHtGAdiOuYGWgFBrYUFukdThoxp8NBQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784800286; c=relaxed/simple;
	bh=LM5rQqEzffppaGyiZqTxi3jZAfJHrhhaXwtrM8qQvn4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VFMzLCquRcMEIyz+7nMW1PWmXTWGsUwBrtDRl5r281ScHYxC1iqLcz2VZCKfFGvCFMq/4wBAXMYHlQML0qcJ6pRbZXT+je3VLZfM0yp0OrfYII7QPM+/EbaWZS/hYtr7rPW8MWkcnoNZhk2f3qhRMZ/en1dT+RDWXl07ac8d4Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X70TIZiE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X70TIZiE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C6C1F000E9;
	Thu, 23 Jul 2026 09:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784800285;
	bh=b9dXVavXW2uhCSw9o8MziEw0cMDNNu3e8wEJxirI5tc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=X70TIZiEwIKJ0q2m39LW+Wz6Ai6PIdQtWCF62RP8YaGqvAT7WcP8L70DxcYZk72NW
	 luesPijGDsYtLohFVONh6MhmMw2VtkLgASq7Vs6j4k6jQRUYRdvY+u9VhPJokCOnW/
	 c1DIsjl0mmZcNZ8R9slBCS4uXHugUYqGajB5QC1vVxSyk7y0BG4nOCd3LLEJchtcY0
	 JpdkSiEBL4X4Pv2rXsRKKZxjKStjZ3fUr3CWejBcOworUTiTg38lN0YIA+euLQzPqq
	 mySFADqJYeQC+DslWCVtRNz+xx8LyeTcOydBLGlRfah4u+F5DNIuCYxG/CfpO45nR+
	 hJkGwuSq2/m2A==
Date: Thu, 23 Jul 2026 12:51:20 +0300
From: Leon Romanovsky <leon@kernel.org>
To: kensanya@163.com
Cc: bvanassche@acm.org, jgg@ziepe.ca, linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	TanZheng <tanzheng@kylinos.cn>
Subject: Re: [PATCH v2] RDMA/srpt: fix NULL deref when sending BUSY before
 target_init_cmd()
Message-ID: <20260723095120.GF110966@unreal>
References: <20260723024456.52851-1-kensanya@163.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723024456.52851-1-kensanya@163.com>

On Thu, Jul 23, 2026 at 10:44:56AM +0800, kensanya@163.com wrote:
> From: TanZheng <tanzheng@kylinos.cn>
> 
> If srpt_get_desc_tbl() fails, srpt_handle_cmd() jumps to
> target_send_busy() before target_init_cmd() has set cmd->se_tfo.
> target_send_busy() then dereferences a NULL se_tfo.
> 
> Call target_init_cmd() first with placeholder data_length and
> data_direction, parse the descriptor table next, then fill in the
> real data_length. That way target_send_busy() is safe if parsing
> fails.
> 
> target_send_busy() is only valid after a successful target_init_cmd().
> If target_init_cmd() itself fails, free the send ioctx tag locally
> with target_free_tag() instead of calling target_send_busy().
> 
> Fixes: 8b8807b9e982 ("scsi: RDMA/srpt: Fix handling of command / TMF submission failure")
> Link: https://lore.kernel.org/all/20260717025402.64054-1-kensanya@163.com/
> Suggested-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: TanZheng <tanzheng@kylinos.cn>
> ---
> v2:
> - On target_init_cmd() failure, use target_free_tag() instead of
>   target_send_busy()
> 
>  drivers/infiniband/ulp/srpt/ib_srpt.c | 36 +++++++++++++++++++--------
>  1 file changed, 26 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index f66cfd70c263..71af1fb0d380 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -1558,8 +1558,8 @@ static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
>  	struct srp_cmd *srp_cmd;
>  	struct scatterlist *sg = NULL;
>  	unsigned sg_cnt = 0;
> -	u64 data_len;
> -	enum dma_data_direction dir;
> +	u64 data_len = 0;
> +	enum dma_data_direction dir = DMA_NONE;
>  	int rc;
>  
>  	BUG_ON(!send_ioctx);
> @@ -1584,6 +1584,25 @@ static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
>  		break;
>  	}
>  
> +	/*
> +	 * Call target_init_cmd() before srpt_get_desc_tbl() so that
> +	 * cmd->se_tfo is set if descriptor parsing fails and
> +	 * target_send_busy() is used. data_length is filled in after a
> +	 * successful srpt_get_desc_tbl().
> +	 *
> +	 * target_send_busy() is only valid after a successful
> +	 * target_init_cmd(). On init failure free the tag locally.
> +	 */
> +	rc = target_init_cmd(cmd, ch->sess, &send_ioctx->sense_data[0],
> +			     scsilun_to_int(&srp_cmd->lun), 0 /* data_len */,
> +			     TCM_SIMPLE_TAG, DMA_NONE, TARGET_SCF_ACK_KREF);

1. TCM_SIMPLE_TAG -> you need to rebase to latest rdma-next.
2. You are hardcoding dir, while it can be overwritten in srpt_get_desc_tbl().

Thanks
