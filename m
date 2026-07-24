Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A714908DC;
	Fri, 24 Jul 2026 23:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784935846; cv=none; b=GLpYYm8D7osO7nQ4K4t6pyIMXBFF+mOrj6FOzAyy/R2JLICPT/niOCynXvrwCAJwr2yzmE7HxWq3Y851x7RDWR5+CIwHar5U2jo/eOy4zpFT4niYDnwTlDTVfxYzSPgQwF4V3y4yg9YU8u9HnMK9rmpIemUxW80f0nec/YG7KQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784935846; c=relaxed/simple;
	bh=910u7999uY1CvZ+GkxDlfIIdp+KVY0+z1+0DD/TacvQ=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=ovH6pumHb8+uJD9YBIb2k37mtz9ywX27Iey4m86i3tc0MCX98+1ZJD11KVZxm0TdVbPugR7iGXqBDGdNHiUPLe4kaJDzL533hzc+gd2K7SxVYg40cxPSQPM1lx8yJTco4qlfd6NuDEjYUbIeiiPd+hQmsNRn7cFR3PNIc2AtYLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lAJ/iPXo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lAJ/iPXo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A011F000E9;
	Fri, 24 Jul 2026 23:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784935844;
	bh=ga3A9bRt3c2UijdlcV9taAv0jfoLBpffPiPU4YFdUUs=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=lAJ/iPXoVsngNaY7eyrp2DoBsJiF3Mx+O8OExchfurctOn7Jji9pOnx6BHgUEdqmi
	 Nkt2cJyncXccag5U0UhVvw8J4vzpHh9axwdw+bPPAJvnldRvb44b4cnnFrDz2bZq1f
	 3J0jHHbqYhbi6K51pAxn4OaZhBzmK/pThRhweeuOQohSD2imF6jv4EZeC13iVagw2d
	 DR0bYDmOdwdOKHODijDiN94R99G9qpiinJwHwIN8gTUGzmfYf/YJf7L2s0pfzxFEbi
	 4/srgHJyocpJpHUQSDGqbTI5FxtvIwv13aN6e2ZL+Oq+7ZxhHb9UAwTTiKwr42FMOQ
	 FR1XJFrbNHq5A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 1982538111D8;
	Fri, 24 Jul 2026 23:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net/rds: use krealloc_array() for iovector
 growth
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178493581171.3350809.12976100620757445691.git-patchwork-notify@kernel.org>
Date: Fri, 24 Jul 2026 23:30:11 +0000
References: <20260717022537.331863-1-xiongwm2026@163.com>
In-Reply-To: <20260717022537.331863-1-xiongwm2026@163.com>
To: Weimin Xiong <xiongwm2026@163.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 17 Jul 2026 10:25:37 +0800 you wrote:
> Use krealloc_array() for growing the RDS iovector array. This makes the
> array allocation overflow-safe and derives the element size from the
> array pointer.
> 
> Reviewed-by: Allison Henderson <achender@kernel.org>
> Signed-off-by: Weimin Xiong <xiongwm2026@163.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net/rds: use krealloc_array() for iovector growth
    https://git.kernel.org/netdev/net-next/c/04026c998c24

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


