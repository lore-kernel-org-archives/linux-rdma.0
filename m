Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B455022A4E8;
	Mon, 27 Jul 2026 06:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785134124; cv=none; b=gTOAc/KqClGaG+NoL/YkRjipnlG10UHXJmhcztpF4tu/v2lhytbRUBdNwT5om9aZp/GxsqDwfmYRaBrlCWp5J8ocesS6x9Rxjm8S+fyWiNZ/FKvPbBy/kgKDFozj7f2blq5D6ka1mLh0WAOyUHNxoMqlc2bCwSvCGEbtANhu3Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785134124; c=relaxed/simple;
	bh=uPa/aCP5cIR/1XZeQUFPEsORxw7LNIg6WXiFiibYjkQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=MX7yjiPWo9dagZxhMffFP57L9xzLLZjM6o2nIEtq3zzmktq8PGygAnZ5K5tqBvOiT76ONxob/xR3Rih3f4u4iOXO3fQH2qOkj7EA0gjZ9vqvB3TCI7VTwT+3eCG8ldLpHyouT8xr/qdnCOGnnBhzPfz464UBgmErxTAl8kmwYjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EtPnmYyQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EtPnmYyQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A031F000E9;
	Mon, 27 Jul 2026 06:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785134123;
	bh=rz9q+O8i9CBp9KS/z7x+Vt1GrcrYydUkklGPSZvnPy8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=EtPnmYyQ5IITbWQjNvyfWAiMd1qtcR5W8IuaM7tUsGG4yOLyAcEJvrinX9gGyVDwt
	 KDrVpd3aqLRGrE79Jnl3IGZ/j9ZFKdnF6GlUWolHO4tFuoVx73DWCLezcPvTtNS9HS
	 xyD+5EQlm3A1Fnkur1z54ewi0vdbbnEJ9NvhIbWpt5vbL3KR2yZ+e6udfX3RKUQsQj
	 degq/Z5LdNYUnJI75iylyuHu7Yv5XS12yTtpMHVicNWpvS8g2CLgXlLAzI5kNp6SYn
	 xp7uVk+KyhTQvd0Ay/l+7vzzSEdilIKCd77l6QWyM/RZ+0PnCjkSRtZOrUOPiGperF
	 n5K/ZWvRd5Wgg==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Saeed Mahameed <saeedm@nvidia.com>, 
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, 
 Edward Srouji <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 netdev@vger.kernel.org, Michael Guralnik <michaelgur@nvidia.com>, 
 Patrisious Haddad <phaddad@nvidia.com>
In-Reply-To: <20260726-deprecate-lat-qps-v2-0-5e0c2ee55046@nvidia.com>
References: <20260726-deprecate-lat-qps-v2-0-5e0c2ee55046@nvidia.com>
Subject: Re: (subset) [PATCH rdma-next v2 0/2] mlx5: Deprecate
 latency-sensitive QPs feature
Message-Id: <178513412028.578131.5826931942866636137.b4-ty@kernel.org>
Date: Mon, 27 Jul 2026 02:35:20 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sun, 26 Jul 2026 12:09:39 +0300, Edward Srouji wrote:
> New HW no longer implements a separate class for latency-sensitive QPs
> and advertises this by a new cap bit.
> REG_UMR is the only QP that used this feature, so gate its usage of the
> feature on this cap.

Applied, thanks!

[1/2] net/mlx5: Add qp_latency_sensitive_disable cap bit
      https://git.kernel.org/rdma/rdma/c/36b1d3299d0b6a

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

