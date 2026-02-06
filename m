Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE009296BD1;
	Fri,  6 Feb 2026 02:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770346210; cv=none; b=uLKZvjSo1EnLc9r4Rkd6MTXKKvrWaIs6woFMXffPICZCadSzqMZC8IYTGsXVGphW3V1CNVL9RGfbVSOHx3wKnEpjw+C9+elKO6fxnT9HI4tGsYUIqgIsqlxpiaNOZxAufGjmn2Abs+yXgM94FCGe91HTQuDeIl/ZznRf98WqHBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770346210; c=relaxed/simple;
	bh=IKqatH5kV7eJzphFpYS2pLpw0eu1bizRSPviTdXrV9U=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=EtnV8ZNDch3y8cp76Cu9nKlK4Z+eux1DSkLVowQywqBgbb/TmwLsNxu3L/hN95Hqp0khQKloQ1d/IFOHqZ+HyB3DZjwrAdu0xZTdm5z/aucboTzx4hAATnCaAa1TNplz1nkTOTNYUDb2rb1QnUXgYW1ovjIcEXXNPO5zGbvOuMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ham0/mMO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ham0/mMO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B82C19423;
	Fri,  6 Feb 2026 02:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770346210;
	bh=IKqatH5kV7eJzphFpYS2pLpw0eu1bizRSPviTdXrV9U=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Ham0/mMOyxWGoj1xC6QhxAw92XqPpC7GQGF8wlGHB9XaJ0v0gU1FojKU4BACGIY6X
	 fr2u3s1PgMuDS4YUaQmh6hVTpT1dJOniQUgvqMuPq0XiY5UAY7nKW6t/3tgqQDqv7L
	 YsKR3TIHsrDJkz2089TOugAN0oxJZBylc2hFOOP4bI9laKITssVrHqk8AJXjUSBdwC
	 xDGoiKHS5gslAgFQOrV9M75cxLAwKbyQFM+JO3EOV1wrxKCDN3ZWbrrJp26pO14/SM
	 heY1F5MBQujBdk6Y9vHshmzS6uyAv4JhOVXLjCut5AIFQIoEtrBLZoIFHoIprGHlBt
	 AyeaRuKjUiJcg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 480BC3808200;
	Fri,  6 Feb 2026 02:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V2] net/mlx5e: SHAMPO, Switch to header memcpy
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177034620808.657894.1041994885546152344.git-patchwork-notify@kernel.org>
Date: Fri, 06 Feb 2026 02:50:08 +0000
References: <20260204200345.1724098-1-tariqt@nvidia.com>
In-Reply-To: <20260204200345.1724098-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, saeedm@nvidia.com,
 leon@kernel.org, mbloch@nvidia.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, gal@nvidia.com,
 moshe@nvidia.com, dtatulea@nvidia.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 4 Feb 2026 22:03:45 +0200 you wrote:
> From: Dragos Tatulea <dtatulea@nvidia.com>
> 
> Previously the HW-GRO code was using a separate page_pool for the header
> buffer. The pages of the header buffer were replenished via UMR. This
> mechanism has some drawbacks:
> - Reference counting on the page_pool page frags is not cheap.
> - UMRs have HW overhead for updating and also for access. Especially for
>   the KLM type which was previously used.
> - UMR code for headers is complex.
> 
> [...]

Here is the summary with links:
  - [net-next,V2] net/mlx5e: SHAMPO, Switch to header memcpy
    https://git.kernel.org/netdev/net-next/c/24cf78c73831

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


