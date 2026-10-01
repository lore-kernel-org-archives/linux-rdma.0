Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C954D7957;
	Thu,  1 Oct 2026 00:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790812811; cv=none; b=IJhLb/TQroD4Qv1DMNB9TzU7yv9kpHkfFBpkypgH87LDxPoFuDKXP9XPnS/Qb/tFQObWS/Lm+8PoWLKK+9OmHNn2/r95shlR/pMFLoqjb5W9zokzg+SlXFqPeQvWkQuKts9BG5vNUnizhWlLeSQXYVMjPeDWsFXzUJAo+IvviIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790812811; c=relaxed/simple;
	bh=GuSentHMa62HhKbCmsHJIdwrlnUNOOsQQ+U3vx6mEw4=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=OmIV7FXnfKBAtslx5wRxGy43F05+j2xFlJ9Vfqn+KlVI/pACjypV1rmAl+7PF16nGk4+oQuieKFFPOyuNbQnhVJIzGViBrefVCB1XLi+hdMreX7/IO6RjgdKCvAmP+2NRYkufugsxUrliMKLmUwmbaEmogxtubJdT1qO12vPjSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kGI2aYlD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kGI2aYlD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450191F000FF;
	Thu,  1 Oct 2026 00:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790812810;
	bh=m6YsxEBh3PP1LMHxC7LJSLju1ESDaiUsv95jhHIbkUM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=kGI2aYlD0dcVyu64QjX8OsIFQfDflvSrBdRXKggFDPG+YjnTkcUcMRegUZnrP9FDV
	 8WEsBNVWxwEvqXKq4jdtCDBJMOAaumo48SdlMWFwj/QM6RvP83NCDQ2EtIlpIIxY66
	 CPdaTp0D227gpw3X1Jsmcht3bJGhRxwfCADuvfRN7tz4dxJPlSa4acmUkqRNAUyFvS
	 nyWRba/hMG9NUIVtMjC4GIZdf7zlCSSdjvIflxjre7j6luCRMrreOizvGt4DNic9dM
	 iJKoarvGZ4fAknF7UmWq9w8YcalmTwHK86PQaC1rElJGhzUg9OPDINsF36rV/hJA5/
	 yekaF8zuz+/XA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A1D23AA6A61;
	Thu,  1 Oct 2026 00:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/smc: Serialize link activation with teardown
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179081280877.2182141.2612806468126362677.git-patchwork-notify@kernel.org>
Date: Thu, 01 Oct 2026 00:00:08 +0000
References: <20260927074547.3694742-1-nicoyip.dev@gmail.com>
In-Reply-To: <20260927074547.3694742-1-nicoyip.dev@gmail.com>
To: Chengfeng Ye <nicoyip.dev@gmail.com>
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
 sidraya@linux.ibm.com, mjambigi@linux.ibm.com, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, kgraul@linux.ibm.com,
 ubraun@linux.ibm.com, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 27 Sep 2026 15:45:47 +0800 you wrote:
> smc_llc_link_active() marks a link active before scheduling its testlink
> work. The first-link confirmation paths call it without llc_conf_mutex,
> allowing link-down processing to clear the link between these operations:
> 
>   Connection setup                    Link-down worker
>   smc_llc_link_active()
>     link->state = SMC_LNK_ACTIVE
>                                       smcr_link_clear()
>                                         link->clearing = 1
>                                         smc_llc_link_clear()
>                                           cancel_delayed_work_sync()
>     schedule_delayed_work()
> 
> [...]

Here is the summary with links:
  - [net] net/smc: Serialize link activation with teardown
    https://git.kernel.org/netdev/net-next/c/6cccd4b720e2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


