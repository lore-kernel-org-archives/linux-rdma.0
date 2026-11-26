Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795685041;
	b=B7UPzP3rG96B9SgoZNdFBiancRfxbccpYqPQ7r10HQloEM20e94NdOpzjOXpXa36W3bK
	 fJ2cXSACsCmoRDMX2P0gn+/ohowkG2UrkEZ9jMuG80CimyC+r7NyCuw33P9bK3rfmRMKH
	 dyBx9E4nngW9V3e+ut6Djfiv14ujSCN/B2hlagvt1e19pJ/ECrwwHPrmFG+bAGhGHEKot
	 k8/JMNq3//0Sv1VTNsfObMyG+ULkfJyZJ3W2frHKKCk4T7ibv9w2oHB8MePAxrzrbpTC0
	 uK2vJhkW9VTHphfZN42EO3QClzSh076MuTvmptr6e9QiAkCqtM5trwyNGHQEabe6gfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795685041;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=GO7tR5tDstSJhSy6pQPYRFiJw09Ox+GG2RpQbvbvyg8=;
	b=uFB08f+7RnFD5/BIgDGoWZfyGiY5NNLOlwpcbYY2XnZtftB4lnO4SeURbOdy5o4A0PFW
	 t8i8VwEB50WZkSkS3ikS6rNLri3rLQaQQ3jlk1wCzzeR0GeRNIW5+fY7qimD0RWjHjKNz
	 wXz3P/OodGuG42SD50t8MXAWcdAL7aJCf2UBFUu2/JN50GJFhdtuFS4Pa0g8Z6oGfVk1h
	 o5GUKFol0MtPVEzYMykcs4keDc2hCAO/RtJer1kaG8Pn/eG4cTGspABIHx8tcJX6bL+Fi
	 VR93Od/76XxxHlHLOYbJi7a5XFl9oFtxvU9UmSux8w3s0O6YriF0KTq9egwPdobM98g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fDjOh5se;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38023606A31C;
	Thu, 26 Nov 2026 09:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fDjOh5se
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97651F000CA;
	Thu, 26 Nov 2026 09:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795685040;
	bh=GO7tR5tDstSJhSy6pQPYRFiJw09Ox+GG2RpQbvbvyg8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fDjOh5seSIIWpBRULEBC/WNH6I+NL0X/nzSFUMOqXLkVs11Pr6lHTL3MGYKm+SC4M
	 RNfUvQDiNrUFYgecSgqP+sSGy5AK0D+RIoOmeIvs0WpPFsIfdMKfcNb+evqEd4VCWP
	 LKQyrsBsxdbZub5XudjGCZftR61JOZqECDNLU253PBP6pwEWjBahjLpQvS/L3E1Bgi
	 0whwM7fG58lgMYRDhvcqm+P23peQ2t1UBtadW655dOwfZ6RudwK/m0dyYmTbmXBAwX
	 U4uAi8hfLbn7Q1MVTIQfYMo3dIdl98kymJBMh2ahLMdhE4qpgYXMMWBzgqtzgFMZH+
	 FN9aEP+TlownQ==
Date: Thu, 26 Nov 2026 11:23:56 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Ziyu Zhang <ziyuzhang201@gmail.com>
Cc: sagi@grimberg.me, mgurtovoy@nvidia.com, jgg@ziepe.ca,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com
Subject: Re: [PATCH] IB/iser: Fix deadlock during blocking connect
Message-ID: <20261126092356.GF774860@unreal>
References: <20261123144440.65441-1-ziyuzhang201@gmail.com>
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
In-Reply-To: <20261123144440.65441-1-ziyuzhang201@gmail.com>

On Mon, Nov 23, 2026 at 10:44:40PM +0800, Ziyu Zhang wrote:
> iser_connect() holds state_mutex while waiting for up_completion. The
> CMA handler for the same connection needs state_mutex before it can call
> iser_connected_handler() and complete up_completion. A blocking connect
> can therefore prevent its own connection completion and leave the waiter
> blocked until a signal arrives.
> 
> Drop state_mutex around the wait and reacquire it before checking the
> connection state, preserving serialization of state and cleanup paths.

You can't randomly drop locks without any explanation why it is safe.

Thanks

> 
> Fixes: 504130c039f9 ("IB/iser: Protect iser state machine with a mutex")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ziyu Zhang <ziyuzhang201@gmail.com>
> ---
>  drivers/infiniband/ulp/iser/iser_verbs.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
> index 55fe68e..9fe2d3f 100644
> --- a/drivers/infiniband/ulp/iser/iser_verbs.c
> +++ b/drivers/infiniband/ulp/iser/iser_verbs.c
> @@ -778,7 +778,9 @@ int iser_connect(struct iser_conn *iser_conn, struct sockaddr *src_addr,
>  	}
>  
>  	if (!non_blocking) {
> +		mutex_unlock(&iser_conn->state_mutex);
>  		wait_for_completion_interruptible(&iser_conn->up_completion);
> +		mutex_lock(&iser_conn->state_mutex);
>  
>  		if (iser_conn->state != ISER_CONN_UP) {
>  			err =  -EIO;
> -- 
> 2.34.1
> 
> 
