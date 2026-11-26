Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795719546;
	b=wdyrgFnw5FY6IdMCmHci7myd/DJoAu6NpMGycAUnxjWc/95gnKgHcBe+q9ETCDXtKjtb
	 Vl5BuCS51wZuvUZDH4+/mCVTFpGFx73dbTozRcfLwKxiY4kPB2+cS8xZ28Ep37z4A5DIm
	 M/XQ1t2pLqR6sKjfOM9Afk6MeDuYPkWY7W2/uLO2GG2bZs27IVrW0k4BNrWTTl4fgDIk1
	 07puO+3pTwFB+6N7xT6ITEPCHEq8qR+yh7msU3OVzLxBEMbr2nvAXLCNOyO3Vu8TFLB2w
	 4vDS2hebUE2PsZV5BWN6wrobMCCpQ7ouCWOxBXSEmL24nMrLjUPnsEDBpoKzv12nFBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795719546;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=7TLKfvlvT+MRkWP8crbenCPFrE3NXdE6ME678FECuzQ=;
	b=DeRNlBAfwkBKOejlDjQgvMQBHZGaN4+N8Y9j6IoZwEBW9EtFeCVHdwDihp+KDfP2ebJa
	 qbukvFK6BPfBYNJmkv0P2+6EBN9IUAmLIU6hMWeODJVOH/5J4Qh6b1Hh3lajmyrXJbey0
	 AhPpIw/EPVCPo/RNug0MT3szUdiR4lSRReHumE0U39KEWCB4NQhhG0ulUYLWa945rh18J
	 BC0StqR1jIjDe6BKyXcJf8FkwXLbiCcIc4OPTlYyfLbPKyOFu8CihkewWNCNxtnLpLgVU
	 5n4PugizXFlZhpB8UtVrXDYKjVHlYld+tzZdmxvZ7DmOfRXHJB7gPz1yN9Our6s+Fuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U3uTbs5R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65E3606A31C;
	Thu, 26 Nov 2026 18:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U3uTbs5R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8391F000C4;
	Thu, 26 Nov 2026 18:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795719546;
	bh=7TLKfvlvT+MRkWP8crbenCPFrE3NXdE6ME678FECuzQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U3uTbs5RLsa5K1jF1D5NTXQyCYB6MtmX19bRIW6SocYMvoB5oK2FtpzI3kxaP2Uii
	 AJUEBZRkmPv4L+vZmgRSgCT5qNxA0AI1oWn5hpxN+TfuANreLPHy4bdShUQ0ATk3oE
	 np2+8QH5chPeXe/QXlE3VZ56iQ0dymsVstpM5WsYewfPXWimlX+yd6R5bGwveBcps4
	 FNAtVR31GPI7z6S2QE1yEXwvzo0cpob4Kgm15dJnbMwZYX0XqZFahNvqeFbKe3SCIS
	 74D00Uc2BTf1lL4SjR4eKDphSyB1iOh6YgpJiENBGBOzWXV0NADhoqB8QrEvHBBByH
	 ZmvFU40zXPLxw==
Date: Thu, 26 Nov 2026 20:59:02 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Mahanta Jambigi <mjambigi@linux.ibm.com>
Cc: linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH rdma-next] RDMA/mlx5: Read the CQ consumer index under
 cq->lock when arming
Message-ID: <20261126185902.GW774860@unreal>
References: <20261125084054.1349677-1-mjambigi@linux.ibm.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261125084054.1349677-1-mjambigi@linux.ibm.com>

On Wed, Nov 25, 2026 at 09:40:54AM +0100, Mahanta Jambigi wrote:
> mlx5_ib_arm_cq() reads cq->mcq.cons_index after dropping cq->lock, while
> the poll path advances the index under that lock. A ULP that arms the CQ
> from process context while the completion tasklet polls races on the
> index, as SMC-R does from smc_wr_tx_send():
> 
>     BUG: KCSAN: data-race in mlx5_ib_arm_cq [mlx5_ib] / mlx5_poll_one
>     [mlx5_ib]

Please add full non-trimmed dmesg stack trace to the commit message and
resend.

Thanks

> 
> Read the index under cq->lock, which every writer of it already holds,
> so the doorbell is programmed with a consistent value. A stale index can
> only cause a spurious completion event, never a lost one.
> 
> Fixes: ce0f75093282 ("net/mlx5_core: Modify arm CQ in preparation for upcoming Ethernet driver")
> Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
> ---
> Note: mlx5_cq_arm() also reads cq->arm_sn, which eq.c increments without
> cq->lock. That pair is pre-existing and separate from the race fixed here;
> this patch does not change it, and I have not analyzed what a stale sn
> does to the arm protocol.
> 
>  drivers/infiniband/hw/mlx5/cq.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
> index 55ffd7d4de51..8f4389b4eb6f 100644
> --- a/drivers/infiniband/hw/mlx5/cq.c
> +++ b/drivers/infiniband/hw/mlx5/cq.c
> @@ -651,6 +651,7 @@ int mlx5_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
>  	struct mlx5_ib_cq *cq = to_mcq(ibcq);
>  	void __iomem *uar_page = mdev->priv.bfreg.up->map;
>  	unsigned long irq_flags;
> +	u32 cons_index;
>  	int ret = 0;
> 
>  	spin_lock_irqsave(&cq->lock, irq_flags);
> @@ -659,12 +660,16 @@ int mlx5_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
> 
>  	if ((flags & IB_CQ_REPORT_MISSED_EVENTS) && !list_empty(&cq->wc_list))
>  		ret = 1;
> +	/* The poll path advances cons_index under cq->lock; take the
> +	 * snapshot here so the doorbell sees a consistent index.
> +	 */
> +	cons_index = cq->mcq.cons_index;
>  	spin_unlock_irqrestore(&cq->lock, irq_flags);
> 
>  	mlx5_cq_arm(&cq->mcq,
>  		    (flags & IB_CQ_SOLICITED_MASK) == IB_CQ_SOLICITED ?
>  		    MLX5_CQ_DB_REQ_NOT_SOL : MLX5_CQ_DB_REQ_NOT,
> -		    uar_page, to_mcq(ibcq)->mcq.cons_index);
> +		    uar_page, cons_index);
> 
>  	return ret;
>  }
> --
> 2.39.2
> 
