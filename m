Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794819705;
	b=E9e++MVUYPOj8P9HQH2thBMFUtOcpzHyYL6qHb5jwwwbhlBg8upAyUi4KpXG0EG/A5le
	 LE45CpVnoy5JIHb25foXDLGfvhoT8CmAWkzPHB86e6SRt3l96UZ9Voi3F5okhAhj2KcX0
	 qSa9QSckDXs5DK5+UsBHJvyXEmufGzc+pYscHNW1rT8Ddu1JZ/8r+kVfNDQj/P74MLzUK
	 QEIVKvJ5K4t5Z3aqsdxcreUB/ZipDVkhsdo6klO4KImnr2yOY8BfLsj1SqP4dH/ahf4B/
	 qAYbArQBTI28atf/pakgIGOS2B/lFZ+V2JUZCDYMEZUARH4gCpNzYts+eFhZJjd68Jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794819705;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=INWogzm8PidxyjUr/FFx7LS/Jeuuu1yeGh+jYBpFEF4=;
	b=g7dwV132zYIjpw8PEF1PcmsDMqDbDbFf99Xn5OhCsQ7xpZd/n0LkpeTCXMrdP9sx00QV
	 hxLmsi2KmU5x7fOJcc6l307nwJuDhgAboRGGEqqrWeAze05fvH0M+MP3YoU9+e9OWXXVK
	 gnKGLcxfTNfPzbKjk8SBpQ5Ka3MSX7ItSUUUlvYRRiRBiEWBSpftn99u83ln3Fm1qoEmK
	 AxT/LjV9J0NrkxwRuYw6rI1Wi0b+DBJoVcXxCAG0jLgYYBUcPjgjv2CrYfXMrHVxDLhXU
	 MD22mniZjfDyRkPKlHV+P8VR/13vQIkL/99YyPG7me7mdm/40/ebqKQTeeM0phaPGQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K7kbq3xV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60557606A31C;
	Mon, 16 Nov 2026 09:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K7kbq3xV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB451F000C4;
	Mon, 16 Nov 2026 09:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794819705;
	bh=INWogzm8PidxyjUr/FFx7LS/Jeuuu1yeGh+jYBpFEF4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K7kbq3xVTbeXNgqE/m00Dbp5Pibd2rcnbtPD1z5d/ZOE75zzcL++Z/tI4Hia9fvYe
	 l5dzJnRf7a3gSqnTFcHpT7QA4xFeQ7RALAJnfr1jIQ7ZkXVXhgoiO11+y34aBZV6im
	 HKN6p8Yc9EEXAirgGxTrzMp9kG31uGJLYNFhpjJGjmzONwEucqhrL0lOZzN2G1b/fb
	 4cWZLzViAtSGplkqx/+jrfnWXhSrY6pbFST1GsAp5vgrLsTpD/cTI8N9/dhzP1asUS
	 lRyp8JpLcuwOYlN7DqvJd7iqc0iIEIw/IjrPPw1WIDjyKvho2XE6yPrP+ukMMZeO/Y
	 UVCz8/a+4Y4Hg==
Date: Mon, 16 Nov 2026 11:01:41 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
	saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com,
	kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
	davem@davemloft.net, andrew+netdev@lunn.ch, dtatulea@nvidia.com,
	moshe@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V1 rdma-next 11/24] RDMA/mlx5: Introduce per-CQ poll_one
 hook in mlx5_ib_cq
Message-ID: <20261116090141.GC11319@unreal>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-12-yishaih@nvidia.com>
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
In-Reply-To: <20261110134320.34408-12-yishaih@nvidia.com>

On Tue, Nov 10, 2026 at 03:43:07PM +0200, Yishai Hadas wrote:
> Add a poll_one function pointer to struct mlx5_ib_cq and initialize it
> to mlx5_poll_one in both mlx5_ib_create_cq() (kernel-ULP CQs) and
> mlx5_ib_create_user_cq() (uverbs CQs, the path used by both the
> modern ioctl-based and legacy write-based CQ creation commands).
> mlx5_ib_poll_cq() is updated to dispatch through the pointer instead
> of calling mlx5_poll_one() directly.
> 
> This is a pure refactor with no behaviour change.

That is only partially true. mlx5_ib_poll_cq() is on the data path, and this
change adds indirection to a path that is already full of likely()/unlikely()
annotations.

Thanks


> The indirection allows a specialised poll_one implementation to be installed on a
> specific CQ, which a follow-up patch uses to verify the UMR CQ against
> a hostile NIC.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/infiniband/hw/mlx5/cq.c      | 9 ++++++++-
>  drivers/infiniband/hw/mlx5/mlx5_ib.h | 2 ++
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
> index 55ffd7d4de51..11c1153747c2 100644
> --- a/drivers/infiniband/hw/mlx5/cq.c
> +++ b/drivers/infiniband/hw/mlx5/cq.c
> @@ -633,7 +633,7 @@ int mlx5_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
>  		soft_polled = poll_soft_wc(cq, num_entries, wc, false);
>  
>  	for (npolled = 0; npolled < num_entries - soft_polled; npolled++) {
> -		if (mlx5_poll_one(cq, &cur_qp, wc + soft_polled + npolled))
> +		if (cq->poll_one(cq, &cur_qp, wc + soft_polled + npolled))
>  			break;
>  	}
>  
> @@ -1010,6 +1010,8 @@ int mlx5_ib_create_user_cq(struct ib_cq *ibcq,
>  
>  	cq->mcq.comp = mlx5_add_cq_to_tasklet;
>  	cq->mcq.tasklet_ctx.comp = mlx5_ib_cq_comp;
> +	/* Set before the CQ is created, see mlx5_ib_create_cq() */
> +	cq->poll_one = mlx5_poll_one;
>  
>  	err = mlx5_core_create_cq(dev->mdev, &cq->mcq, cqb, inlen, out, sizeof(out));
>  	if (err)
> @@ -1093,6 +1095,11 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
>  	MLX5_SET64(cqc, cqc, dbr_addr, cq->db.dma);
>  
>  	cq->mcq.comp = mlx5_ib_cq_comp;
> +	/*
> +	 * Set before mlx5_core_create_cq(). No real CQE can arrive before a
> +	 * QP uses the CQ, but a forged one can make mlx5_ib_poll_cq() call it.
> +	 */
> +	cq->poll_one = mlx5_poll_one;
>  
>  	err = mlx5_core_create_cq(dev->mdev, &cq->mcq, cqb, inlen, out,
>  				  sizeof(out));
> diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> index 980b41800df5..4833f42b3fd1 100644
> --- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
> +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> @@ -592,6 +592,8 @@ struct mlx5_ib_cq {
>  	enum ib_cq_notify_flags notify_flags;
>  	struct work_struct	notify_work;
>  	u16			private_flags; /* Use mlx5_ib_cq_pr_flags */
> +	int (*poll_one)(struct mlx5_ib_cq *cq, struct mlx5_ib_qp **cur_qp,
> +			struct ib_wc *wc);
>  };
>  
>  struct mlx5_ib_wc {
> -- 
> 2.18.1
> 
