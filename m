Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794822326;
	b=XyqM+f+sLJk5RgQ6w9i7yQqI45wYvQRrF0sAPXKQM6KTibpb+lIv2/eKU8U/qyLcp75H
	 1R2EkuesgBc5mQhh8Nr4QbMGNyw/RRBUvvszz8kap9NryUg20B79/s6Mk08kzMf1Db0+u
	 zMAhfsGTUR/F6jHP+0jC6lBjZ62J9q3VYhE+RaZzgTivn1FoNbI6aw4Qk8ZYS6mvKTTk+
	 pgpZonxkz6mVMwaBZd0CldACONRKKXmHkPI0MeDkOcMxoxiFOUkSbiEGpY7vGLBS5Fz1q
	 RVci4UArVsYWFaZ8XVftvb7BR25rNwPkRvRn1DcYzSIHpFSEhqSTwqzpycZXa7Yh9BQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794822326;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=AcJ12s1T668XtamSJZSY4eaKeD4//TNPNhdEPiqg3+I=;
	b=3gT39uNFpVcEvkFRJT5pFdp3EMqvltyi4Vb+TNE68eiV2EDS4riXHIn5W/bttiw6sKAO
	 ts0EZXuQUJAxWFLtnOB+/XtkIPfwsRxBxtOZkoPHZSt53ugqfMovk1THV2+b3qMZnM51j
	 wJkAiLR4+4oHsDJvjZVKWE/sIesTHRgUpM+UmkuIEcuEIFmoWHs6xyRMFPaerjr+MsBV0
	 N6K95xLQJ0Ighb3hfd03ffryX7JBq1+w0MVVGmGBfERQkQNqLPA3J3OT8foeBd2GNLZnz
	 eWIg6ZpIs/S7dPWkprsml1lTNbH5gn2PYUSOd+oADYrYp6LJf/keYSLHwxhdsAuXo7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="RlID/iSc";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF06606A883;
	Mon, 16 Nov 2026 09:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RlID/iSc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02181F000C5;
	Mon, 16 Nov 2026 09:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822326;
	bh=AcJ12s1T668XtamSJZSY4eaKeD4//TNPNhdEPiqg3+I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RlID/iScKk/npFb3nzVihDSZbSjR36bOTG5uFNynERlxJHAyAaxDDRWlmw1HygnIG
	 2IjNMrZrykMLbUgmfN2a64nDjKPoJzpCK4XCQAosnqgeO3HML34/NES0d6IMrgnl+u
	 Eh2WK99Ek12/k7/jmvKXPKbBuFmDuHFVyLC2DdzOhZoT72O2jyuLBRw9WP6wt6qvXt
	 epwPSekkeTf5kp6vN5xOiAJVXs9jCKEEY8JNWAX+JJc70vIKM+v9oHDeeixUbslmLu
	 4RZxu2MAJuEXzgxGI2YggIr/FM8NoIL2QGbV7tBJv+NzQx90i5ZtN8FOSvjkeEjxLK
	 jDx056MEtnVhg==
Date: Mon, 16 Nov 2026 11:45:22 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
	saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com,
	kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
	davem@davemloft.net, andrew+netdev@lunn.ch, dtatulea@nvidia.com,
	moshe@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V1 rdma-next 02/24] net/mlx5: Derive adversarial mode
 from CC guest memory encryption
Message-ID: <20261116094522.GF11319@unreal>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-3-yishaih@nvidia.com>
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
In-Reply-To: <20261110134320.34408-3-yishaih@nvidia.com>

On Tue, Nov 10, 2026 at 03:42:58PM +0200, Yishai Hadas wrote:
> Add mlx5_is_adversarial() to report whether the driver treats the NIC
> as untrusted. In a confidential computing guest, the hypervisor and any
> passthrough device are outside the guest's trust boundary, so the mode
> is derived from cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT).
> 
> This turns adversarial mode on automatically in such guests, without
> any administrator configuration.
> 
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/main.c | 7 +++++++
>  include/linux/mlx5/driver.h                    | 1 +
>  2 files changed, 8 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> index 1a45474ce03d..f9e10464a71b 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> @@ -31,6 +31,7 @@
>   */
>  
>  #include <linux/highmem.h>
> +#include <linux/cc_platform.h>
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/errno.h>
> @@ -484,6 +485,12 @@ bool mlx5_is_roce_on(struct mlx5_core_dev *dev)
>  }
>  EXPORT_SYMBOL(mlx5_is_roce_on);
>  
> +bool mlx5_is_adversarial(void)
> +{
> +	return cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT);
> +}
> +EXPORT_SYMBOL_GPL(mlx5_is_adversarial);

I would expect all drivers to follow the driver core's trust level instead.
https://lore.kernel.org/all/20261109-device-trust-core-v2-0-3b12d9a9f861@nvidia.com/

Thanks
