Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794819425;
	b=mO3F2szx29KwVzNNLsPyVFIJeu+fnKZSIkzIB6aJ5oodf3CiSiTe1g9BuNhVMUV215oX
	 pPxgGDJCvhPSizWKoC8Ew3pcEd4CfQgE5lbZQvQFg7GiIWGuWSexWqHRboca9zHgYrfu6
	 hil3IT/iPTs6yB/gMbqCyh7kvlbUgvpjSY01d26jdhqFIvubRX8e/rTsG5XQscnyrnnzW
	 +47b3+qNWk3fyKNBjardrpx2YBkafYwdua2BAXzO5oV0pA5Rgt4EGt1etT05ePRiRMyij
	 gRe8EEKUOztSowDoT/R+vwvYTYcJrUglSD6J3yISDKgVyJQejD1fO2IfKRcHrNwxYTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794819425;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=XcSgc1+dMNRTvp2tbgv8mwp7vt/nIvrPSBIcSn71kns=;
	b=V8DZaHD1cZS0KQaaFuTAzHrUO0/x30qTh0rx1KRkYjZotJ8bnYxwg3RiLtNlauiuFZ2q
	 uRZ/8ozqijv0zHqn5P9Ej8o7RqJayGzunC5jzVxKfy168k1l5j4+EiosuSDg5X6hqaOs5
	 V7JTiiFAHYDcZxvdDCOveKmpR938PXjym+K/qJwYpIA9TAGnJF8yuo8C8Kw5EbD82EQPv
	 NLVFSGHw/hwF7Meyfar5mAFlDEoa3WufGM0ARJcTZ5mXVrCl3x4WOO6f+Dq0YM1kfw/UT
	 +JKyN6/cPkniHt/7iVoz2xzrzcN+SN4RD51DrqOcXmkbJrLx6GcI4Wo99w2kqf/417A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Trr8Ihy3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C60606A33E;
	Mon, 16 Nov 2026 08:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Trr8Ihy3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1DED1F000C5;
	Mon, 16 Nov 2026 08:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794819425;
	bh=XcSgc1+dMNRTvp2tbgv8mwp7vt/nIvrPSBIcSn71kns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Trr8Ihy3hcREY6/M9jH018NSW32Nz6/eYZJmSln/xc7ygjPe7Fps9H/hvS9V0+snm
	 KRk7iwxKEPuLeBd+fFkVzE2e06MP1Pv+MZ+zZJmelM/w4Dsf5SVLa+kGmpkkSlxsls
	 h//A4o5ULfe49Gk2+veA+t+iB9s2lstkXhFHHVHiPBqoZaPUOuIhk0TjMgZ4n8K+pJ
	 cNH/kBeWJuVrFs1u45TnbSJO9cwBHTvQ8NUaVQEK/HyaLhpJ/ASJFfSXERUH6nfcyk
	 ci9SH14o2hUi14t6AEX8PMOxoAzbfJAew2NnE6MA3izZu7jH6hcmQ94B3hTvzR9Tlb
	 LP2gl+Y1z48iA==
Date: Mon, 16 Nov 2026 10:57:01 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
	saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com,
	kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
	davem@davemloft.net, andrew+netdev@lunn.ch, dtatulea@nvidia.com,
	moshe@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V1 rdma-next 08/24] RDMA/mlx5: Derive
 mlx5_ib_adversarial_mode global from mlx5_core adversarial API
Message-ID: <20261116085701.GA11319@unreal>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-9-yishaih@nvidia.com>
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
In-Reply-To: <20261110134320.34408-9-yishaih@nvidia.com>

On Tue, Nov 10, 2026 at 03:43:04PM +0200, Yishai Hadas wrote:
> Cache mlx5_is_adversarial() in a driver-wide mlx5_ib_adversarial_mode
> in mlx5_ib_init(), shared through mlx5_ib.h. The mode is the same for
> all devices, so a global avoids reading it through every mlx5_ib_dev
> and keeps the checks at the call sites simple.

This patch and description makes no sense. The mlx5_is_adversarial() is
simple static pre-compiled branch "cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)".

> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/infiniband/hw/mlx5/main.c    | 3 +++
>  drivers/infiniband/hw/mlx5/mlx5_ib.h | 1 +
>  2 files changed, 4 insertions(+)
> 
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index 65455aedd559..f4f2ad80e76c 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -76,6 +76,7 @@ enum {
>  	MLX5_ATOMIC_SIZE_QP_8BYTES = 1 << 3,
>  };
>  
> +bool mlx5_ib_adversarial_mode;

It is not kernel style to throw random global values to cache existing
in-kernel API functions.

Thanks

>  static struct workqueue_struct *mlx5_ib_event_wq;
>  static LIST_HEAD(mlx5_ib_unaffiliated_port_list);
>  static LIST_HEAD(mlx5_ib_dev_list);
> @@ -5431,6 +5432,8 @@ static int __init mlx5_ib_init(void)
>  		return -ENOMEM;
>  	}
>  
> +	mlx5_ib_adversarial_mode = mlx5_is_adversarial();
> +
>  	ret = mlx5_ib_qp_event_init();
>  	if (ret)
>  		goto qp_event_err;
> diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> index 4a6ee14ffd7d..0f81b8aa487e 100644
> --- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
> +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> @@ -1582,6 +1582,7 @@ static inline int get_uars_per_sys_page(struct mlx5_ib_dev *dev, bool lib_suppor
>  }
>  
>  extern void *xlt_emergency_page;
> +extern bool mlx5_ib_adversarial_mode;
>  
>  int bfregn_to_uar_index(struct mlx5_ib_dev *dev,
>  			struct mlx5_bfreg_info *bfregi, u32 bfregn,
> -- 
> 2.18.1
> 
