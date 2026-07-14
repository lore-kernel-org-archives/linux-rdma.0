Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8347330675F;
	Tue, 14 Jul 2026 17:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784050330; cv=none; b=N4PVFJOYZkLerEAbWQQ8awoGNIIN5WjPjrM+cdKCYNJfZWowf7hc7mBf0BejlCcvxYgZytpuN006FnIL3NFUYBOC/tyD/huIyEbt2nwXMaAL3yNxjNh+FfE8rGmomgC97kR3KJKW5IAJELVoLLZQ+0E1LIaSDJb2uoKpT0rY7Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784050330; c=relaxed/simple;
	bh=CmvrkjVaGQ6MN//Cd8aKji1ytmpktL5xVzNiSdfE/nQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7QL+Gm5QZ3Se9n6EzIRKogkoOFqXcRUWEmcy+JaiioI1x1GJnXvc0CJifV/gRl3YogXWyMn4wPU7dqFi5n7855+stnqqrz2/aim701jf0ByZ1thOMtccdGgxt88/JcTpXjoK9kuey3xIT8zSyiItfxmcQmgBqX8c5bwczQoXOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TwMF7Ci3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TwMF7Ci3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9751F000E9;
	Tue, 14 Jul 2026 17:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784050329;
	bh=hChZb/2vVYNOySAV5fErj2Dtv3qUxLzms3YMHDC+iJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TwMF7Ci3I1oEymvv8ZbZKczzhf5SXnPIhnvI/khf841KbVsKM2h6/AZ5B1c4RZX1o
	 Ya+Vavn5/UZOM1QUd1M4m8zDFW6owFb26wGChXoIzlf5nnY7Y6clmJjHtgpz2R1Gtf
	 q16jwigAxeuDQlNpUsh4WtcqnP4h4alz5kaxKw8TWlPASY8kHAZlvCqix6zfedZaRS
	 vhzl/4uOWo4DHFhLK0pjAvO6VJpLTHUHZopU3ky4Hx3xsNHgm2/nqXCNo54c0UlWK7
	 pA7uHREgU7pSQT2mIydWNmc1M+mJkkusnz6RYr+xuqwR1Uwe6znR26X73yHbFroKIU
	 /dcGadmEcBD/Q==
From: Simon Horman <horms@kernel.org>
To: tariqt@nvidia.com
Cc: Simon Horman <horms@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	aleksandr.loktionov@intel.com,
	borisp@nvidia.com,
	cmi@nvidia.com,
	cratiu@nvidia.com,
	daniel.zahka@gmail.com,
	dtatulea@nvidia.com,
	gal@nvidia.com,
	jacob.e.keller@intel.com,
	jianbol@nvidia.com,
	lkayal@nvidia.com,
	leon@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	mbloch@nvidia.com,
	raeds@nvidia.com,
	rrameshbabu@nvidia.com,
	saeedm@nvidia.com,
	sdf@fomichev.me,
	sdf.kernel@gmail.com,
	willemdebruijn.kernel@gmail.com
Subject: Re: [PATCH net-next 15/15] net/mlx5e: psp: Report PSP dev registration errors
Date: Tue, 14 Jul 2026 18:31:52 +0100
Message-ID: <20260714173151.1863310-2-horms@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260707130858.969928-16-tariqt@nvidia.com>
References: <20260707130858.969928-16-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
Full review at: https://sashiko.dev
---
--- Patch [15]: [PATCH net-next 15/15] net/mlx5e: psp: Report PSP dev registration errors ---
commit 76afe7de4d1e708e7c01d267ef1fb9cf946de937
Author: Cosmin Ratiu <cratiu@nvidia.com>

net/mlx5e: psp: Report PSP dev registration errors

This commit updates mlx5e_psp_register() to return an error code instead
of void when psp_dev_create() fails. The caller, mlx5e_nic_enable(), is
also updated to check this return value and abort if PSP registration fails.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -6199,7 +6199,9 @@ static int mlx5e_nic_enable(struct mlx5e_priv *priv)
>  
>  	mlx5e_fs_init_l2_addr(priv->fs, netdev);
>  	mlx5e_ipsec_init(priv);
> -	mlx5e_psp_register(priv);
> +	err = mlx5e_psp_register(priv);
> +	if (err)
> +		goto out_ipsec_cleanup;

[Severity: High]
Could propagating this error cause the entire network interface to fail if
the optional PSP offload fails to register?

If psp_dev_create() fails (e.g., due to memory pressure or ID exhaustion
in xa_alloc_cyclic), mlx5e_nic_enable() will now abort, resulting in a
complete loss of networking capability for the device.

Notice how the code immediately following this handles MACsec initialization
failures by logging the error and allowing the NIC to continue operating:

	err = mlx5e_macsec_init(priv);
	if (err)
		mlx5_core_err(mdev, "MACsec initialization failed, %d\n", err);

Should PSP registration failure fall back gracefully and allow the core NIC
to function without the offload, similar to how MACsec is handled?

>  
>  	err = mlx5e_macsec_init(priv);
>  	if (err)
>  		mlx5_core_err(mdev, "MACsec initialization failed, %d\n", err);
