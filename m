Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE0B4322EE;
	Sun, 11 Oct 2026 11:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791716813; cv=none; b=XMA+lE81yQK5VwP0JX/POQW+tu5oeNoWMrNJWsuO0gsaxpnbVkKf94yV7Dw+Je0pXI6KaErVItrePqEcKETGjJ/vTy+AQicH+mJo1gPdM+44Sq+BComYjqbg0x0S8R71wK5J4pn+En2hpj1iEutotpLM+ifUTOuUmOozVF1+MIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791716813; c=relaxed/simple;
	bh=d7I8gV6Nc3KMxo3X18vHRxh0AUQfrGhOEOYGbdjvcFM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=QBu3LZj8IEpzxD2z9UhMVg+EUTT6CKodkhLVHyXvv0GKET0BqXLvzQQYHPwiFQvH00g1hR49aqhEfmxrtXLALeamcBwdpcxhKj4jxp0x902f3RxjIn2Jjdbt+wAJ4ev6CDoXXlCZaX/ZQiLMoNgMunfQnEfDaeREdcSXC98po9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U/0Tw7Ka; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U/0Tw7Ka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B181F0089B;
	Sun, 11 Oct 2026 11:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791716811;
	bh=tB93usv9qJmJnhkuOxAsCM4k10KjPYdZURRPqNDH2jo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=U/0Tw7Kagyrvkokwf0NMCfZ52tCDs16zy1QciNdU2K4cWzwCzj65MJTFck/Zwcwqt
	 /3Tw3qinfiI7UErckvfLGShg0moLaDVU2jzmTfH0Xo/9ZGDZ7rSweMxXc1Gi67Wj8Y
	 ZajVIusQJn1vI4OCUgJ38I7a/oGhVE/MmlIbTKU2rj9XxmfjSIW1Yb9fLU2RpfChYZ
	 bbDXBZEAFmOPOyO6wl8294/XYnvLD/jBSebz5kR+71UC54hRcfyC2FtNS/gw9xtwFf
	 vQZ1k8xr5cstED9dAyKbaylAzUhBk2v82I/qFGR/o94UcrjYPNeJFweNrPO+XQsH2s
	 Yl2tK1mYVv/uw==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>, 
 netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>, 
 Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Gal Pressman <gal@nvidia.com>, Jakub Kicinski <kuba@kernel.org>, 
 open list <linux-kernel@vger.kernel.org>, Moshe Shemesh <moshe@nvidia.com>, 
 Nimrod Oren <noren@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, 
 Paolo Abeni <pabeni@redhat.com>, Shay Drory <shayd@nvidia.com>
In-Reply-To: <20261005084047.237081-1-tariqt@nvidia.com>
References: <20261005084047.237081-1-tariqt@nvidia.com>
Subject: Re: [PATCH mlx5-next 0/2] mlx5-next updates 2026-10-05
Message-Id: <179171680884.3031064.1016849448446915116.b4-ty@kernel.org>
Date: Sun, 11 Oct 2026 07:06:48 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 05 Oct 2026 11:40:45 +0300, Tariq Toukan wrote:
> This series contains mlx5 shared updates as preparation for upcoming
> features.
> 
> Regards,
> Tariq
> 
> Or Har-Toov (1):
>   net/mlx5: Add cap_tx_speed and effective_tx_speed support to IFC
> 
> [...]

Applied, thanks!

[1/2] net/mlx5: Add cap_tx_speed and effective_tx_speed support to IFC
      https://git.kernel.org/rdma/rdma/c/4c5679222f6b9b
[2/2] net/mlx5: IFC, Add capability bits for virtual LAG
      https://git.kernel.org/rdma/rdma/c/41de84543574f2

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

