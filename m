Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794916692;
	b=PyMi1cv7smaMTe7Q3myw59MulJmINWoC8t4mbRIdXbJ8SJVEnsN3VhRxOoaOlMFcxlFZ
	 mUHN65QrACgjjJYKiSEFn1tOiKrGy8p9miRwDQs1JY7JYpJG5STvNqNzdimbcl65iwEGd
	 VqUxMkdOrbrS9Kr/jevKEEOyEDavUTWgPUHtUg68FlO8oKQwsPbXjC6+96PhMZOp1DdDt
	 CsCvO9hxNL3X23GUB7yRcJnmakq2R31u0AneYXdg9paTpeE6IsmhpQb1nKm9Cbw4fgLk+
	 zSJWMocS29Lj/zu1Fd1p8tTAtA3uFaOPV2PUCwObc0QFqfm5aDIlhgrHbnuBe5eGZZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794916692;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=uQsg9cbXgPGnWTrR12hIhc3L1CckILBXPhZ/5G/thIc=;
	b=4LRQPpKH1d1t14EXAJsy1cD9Zx0UhWMBoGSvwjw1Ip0PkMBYfkF7tCBCaYc7/GQ0TWgt
	 JB85us9XEj1772gaB6ioGWdhYYrllZXksWfoH81x6yybc3R7K65J4AvXg6AMgdZ7MZ+yF
	 qUm60Q6EfvdSW6IlIJZ4ybLX/+uLCJ168z3HveuEca7LxLmcLuW1gQ72j2btvGfgFxbda
	 8o1ldtAuuDIuatgQAI77tUf/sb7mBPiKGRosfZBVltDuDlmR7cm6BmnRT4wGRe9O6eRd/
	 VxfHtPpia9HEVQwHYE7kP7flM06UUoDtDlknIZZiCtY5Ti7dxWbTwEv0+Wa4eJepI6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JryBEltg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A944A606A31C;
	Tue, 17 Nov 2026 11:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JryBEltg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B961F000C4;
	Tue, 17 Nov 2026 11:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794916691;
	bh=uQsg9cbXgPGnWTrR12hIhc3L1CckILBXPhZ/5G/thIc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=JryBEltgfE+PEBaUn1crtsNN5a15s68RO/QM/OyXGcHftUiZU5BSbZyK2vc3Yiu8D
	 wbFqEvJD7qEReowSaUlBupDlCHdKuET3NphrBwZC7NCms4MqK+glTHHSJYUiPSI7pp
	 u0R13/KHx1r6zcyHgFRbPQyVetA2rvPaKmPR9RKFLsTZKnKmwz6NDU3aL3taP8XMxI
	 utqh3ZhJQlH9dF8OGKOAomi1njitPX4+pMr83XgwzAfMSHArnc1BRJMyYnergy4hV2
	 F4f1DyT+SgrCAzR9fJGHyxbzGdrrtzNGNKSajZ52CTTDdO4f3iszan+hoV0WXU8mlI
	 k0j3XTy6WQh/w==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>, 
 netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>, 
 Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, Chris Mi <cmi@nvidia.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
 Gal Pressman <gal@nvidia.com>, Jakub Kicinski <kuba@kernel.org>, 
 open list <linux-kernel@vger.kernel.org>, Moshe Shemesh <moshe@nvidia.com>, 
 Paolo Abeni <pabeni@redhat.com>, Parav Pandit <parav@nvidia.com>, 
 Shay Drori <shayd@nvidia.com>
In-Reply-To: <20261116144554.1194389-1-tariqt@nvidia.com>
References: <20261116144554.1194389-1-tariqt@nvidia.com>
Subject: Re: [PATCH mlx5-next 0/3] mlx5-next updates 2026-11-16
Message-Id: <179491668884.7160.16573878848653853300.b4-ty@kernel.org>
Date: Tue, 17 Nov 2026 06:58:08 -0500
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 16 Nov 2026 16:45:51 +0200, Tariq Toukan wrote:
> This series contains mlx5 shared updates as preparation for
> upcoming features.
> 
> Regards,
> Tariq
> 
> Chris Mi (1):
>   net/mlx5: Add MLX5_PCI_PF_TYPE_QUERY_PF to mlx5_ifc
> 
> [...]

Applied, thanks!

[1/3] net/mlx5: Extend nic_cap_reg layout to its full register size
      https://git.kernel.org/rdma/rdma/c/7ababe9e9414ac
[2/3] net/mlx5: Add IFC bits for SW RoCE monitor matched packets counter
      https://git.kernel.org/rdma/rdma/c/97d5d1636d96ba
[3/3] net/mlx5: Add MLX5_PCI_PF_TYPE_QUERY_PF to mlx5_ifc
      https://git.kernel.org/rdma/rdma/c/b77e82a6ebdf45

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

