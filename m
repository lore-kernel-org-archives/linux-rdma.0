Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CAD39525E;
	Sat,  5 Sep 2026 20:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788639677; cv=none; b=k2p4koLNP5Bd/CqhImYJ3NlAUjO6Q8akoRuIQ9MvsuzoAr+87+uSf0NT380x5RTf97rPcfVRrZlMrsIFLOB4n+slbgS3afpARETKYPoyMbsuDbQT0hJq2iqER+d3cojSRSlzBJp8gTXo6xNgr/zhxKTRe+2/gg3HvrI91ystqFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788639677; c=relaxed/simple;
	bh=2vzPcWDS/oVBpdle9wrq9q0rOBxJ52CrDHd3uby+BQ4=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=pyd2SEmPSvkVfQ00fVq68+fHW4nKJGVJfRTFIjfA4nPOQU1G3JLlwW0TkgHLuVGXxC8+aFjZ47RgLezqsh9ymnmao0dyZxmV1daYc5FKYW0OMQ210BtL/RLyE6b9hl7+FsdY8t52TYB0wwQC4oxEM32OYQOYG4mFF9oadiRWz9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aW/OKk2d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aW/OKk2d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECCDE1F00A3D;
	Sat,  5 Sep 2026 20:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788639676;
	bh=1SJuKG8pe/HshAko7mOojsH5e7jj3/3jll2CeOyiYZo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=aW/OKk2dv0e1lU3xpIphBzaz7+rROgGhF1czaVdEtWgbp5Z+wxulVb3sOlBscoY2M
	 iA9l0DfP4w03Y8e3lDGlTqKcUQIZwp7Pwrs8WUAYu6FUxD/lV5o10M9fbtTsMmrOz7
	 FTVhPXmB67bKT30l3E66bwlsEAGtl0W75Y6Lbl53gCVIk03569BNkAcox4WPTVNgQU
	 XCMNYkNXE35cRVfImwj0CRYihubeFmhq2leOn9l7tt17ca34ENNTiF6zWgB8ptE9K6
	 UF/qJLbCvgq5lkPT7Snru0sjQrV9QDR25XSMxyHViuy5jUaaoh1NGyuc2A19cazWkQ
	 1rR41Mh4/HZdA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 569273924FED;
	Sat,  5 Sep 2026 20:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/mlx5e: Fix ETS zero BW reporting when one TC
 holds
 100%
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178863961589.1343052.15095893020374737369.git-patchwork-notify@kernel.org>
Date: Sat, 05 Sep 2026 20:20:15 +0000
References: <20260902193224.3668743-1-tariqt@nvidia.com>
In-Reply-To: <20260902193224.3668743-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 alazar@nvidia.com, cjubran@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 saeedm@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 2 Sep 2026 22:32:24 +0300 you wrote:
> From: Carolina Jubran <cjubran@nvidia.com>
> 
> When ETS TCs with zero bandwidth are configured, the driver programs the
> firmware using an alternate representation. On get, it needs
> to recognize that representation so those TCs can be translated back and
> reported as 0% bandwidth.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5e: Fix ETS zero BW reporting when one TC holds 100%
    https://git.kernel.org/netdev/net/c/e7ee89740800

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


