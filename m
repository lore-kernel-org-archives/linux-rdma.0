Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794083083;
	b=o1raAIT+E6wGOa6pxDgd89UY43SXPtBED/VmngCkZ8P2+MT3RqHgG1xkDafLQQPG9PoM
	 yduhSytOvWTsJ8Cx6Nkw8Dst0MpDxPO9eDfPPabhHStXkt9OhYruV7TJ61YMs8p2kBMRN
	 TxP5xcsOkZWecBnIsDrT4MK3NpVdO/vdbtcDUmQ9smeud8cdigOLy9UeJ271/tKE7J9gm
	 lgcf4f3L75NZqVbY7VTEP1DK6zXRFF5MyuR1zIbXeqiKviTAnXhZcitmw8BaUXRGShfTU
	 zH+VrTxINpwtY8eNPFKszglZqYOa7R4mNJZenIonyHcy1y+Nxv0vPthjlveLIwOLXLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794083083;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=fHBfhv5Os1UERuh0WwXS8t9EiYrGbuhZFIIikND+GOk=;
	b=SPSJcD7E/VFlvPbUF0TNg2B1zSwAQR8EDkGs0iyih/BZHyEwqmH5rijITLTHLXQr7IjE
	 K7U7f3SbfGFjO4PGAGduIapvleQ7FgNgT8atcqzKdPuJcN+4G3Oc8Gxq07zvhbi+9SGIB
	 Kst8Sq2bn11iaDJQh58BDOnjHeZCFGaQV/vDvv0I5NFlBsKrJnYOp10iTArSqAHC8VPhk
	 R8sRuDQ67trXvspsXxY58q3tRQEVbuZsv/H49OPXJFdDNHUgvQrZIRkXEtJilYYTsyr3/
	 ibp1/xg5Ks4S3nstvrCfwCCv42qjB/vzV8zIL5LRx0DAFJcoFU+DQ93Kze1bvWKNjbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jsqePyln;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772DE606D807;
	Sat,  7 Nov 2026 20:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jsqePyln
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420521F008A1;
	Sat,  7 Nov 2026 20:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794083083;
	bh=fHBfhv5Os1UERuh0WwXS8t9EiYrGbuhZFIIikND+GOk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=jsqePylnZzrLJn3BHHzddesh0LiLeTPKYZjdV9Q0ubuSMWB0jMTGT+OLZGG2PNZne
	 QNPI2t40o/OozbyE1V+Z8BqYpeWaldOkczQQJ98qhodgr74dITGRpb7onHiRd3Xl+T
	 HMZTpH1rDtM92zhpu8yultB0xEaIVSvB3rqxgF+8i41lzOKBUyZxN+u8EX8E//pMPf
	 VwchixEWAcejgzEe6Bsga/+I4Wq44mk2pasKfQ2TnxW9N4INhZMU57Lb3Se2NhxNRi
	 JCUwUp2g3zMYKlebv5M0ya9VipDPjqgVQKaQkFBLaL8C940Zt3AROIQ3AsrSUjzt94
	 Cu8wAU14nIuYQ==
Subject: Re: [PATCH rdma-next 02/23] net/mlx5: Derive adversarial mode from CC
 guest memory encryption
From: netdev-bot+sashiko@kernel.org
To: yishaih@nvidia.com
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
 davem@davemloft.net, andrew+netdev@lunn.ch, dtatulea@nvidia.com,
 moshe@nvidia.com, maorg@nvidia.com
Date: Sat, 07 Nov 2026 20:24:41 +0000
Message-ID: <179408308185.994134.9934571250726048143@kernel.org>
In-Reply-To: <20261103163949.1554-3-yishaih@nvidia.com>
References: <20261103163949.1554-3-yishaih@nvidia.com>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] mlx5_is_adversarial() in
  drivers/net/ethernet/mellanox/mlx5/core/main.c is exported…
- [Low] mlx5_is_adversarial(void) takes no device argument and returns
  cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT), so the decision applies to…

--

net/mlx5: Derive adversarial mode from CC guest memory encryption

This patch adds mlx5_is_adversarial(), exported from mlx5_core. It
reports whether the driver should treat the NIC as untrusted. The result
comes from cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT), so it is true in
any confidential computing guest.

> Add mlx5_is_adversarial() to report whether the driver treats the NIC
> as untrusted. In a confidential computing guest, the hypervisor and any
> passthrough device are outside the guest's trust boundary, so the mode
> is derived from cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT).
>
> This turns adversarial mode on automatically in such guests, without
> any administrator configuration.

[Severity: Low]
This isn't a bug, but is the last sentence accurate for this patch on its
own? Nothing calls mlx5_is_adversarial() at this commit, so this patch by
itself does not change behaviour in a CC guest.

The callers arrive later in the series:

  "net/mlx5: Add capability filtering in adversarial mode" (caps_filter.c)

  "RDMA/mlx5: Derive mlx5_ib_adversarial_mode global from mlx5_core
  adversarial API" (drivers/infiniband/hw/mlx5/main.c)

Could the changelog say that the users come in follow-up patches?

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> index 1a45474ce03db..f9e10464a71b5 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c

[ ... ]

> @@ -484,6 +485,12 @@ bool mlx5_is_roce_on(struct mlx5_core_dev *dev)
>  }
>  EXPORT_SYMBOL(mlx5_is_roce_on);
>  
> +bool mlx5_is_adversarial(void)
> +{
> +	return cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT);

[Severity: Low]
This isn't a bug, but this check treats every device in a CC guest as
adversarial, and the helper takes no device argument. That matches the
current tree, which has no guest-side way to detect a trusted (T=1)
device.

ib_register_device() in drivers/infiniband/core/device.c uses the same
check and documents the assumption:

	/*
	 * In a CoCo guest every device is currently assumed to be untrusted
	 * (T=0) and therefore subject to DMA bouncing. Once trusted (T=1)
	 * device detection is wired up, narrow this check to exclude such
	 * devices.
	 */
	if (dma_device && cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
		device->cc_dma_bounce = 1;

Would a similar comment here, or a note in the changelog, be worth
adding? Once T=1 detection exists, narrowing this check would also mean
giving mlx5_is_adversarial() a device argument.

> +}
> +EXPORT_SYMBOL_GPL(mlx5_is_adversarial);

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261103163949.1554-1-yishaih%40nvidia.com
