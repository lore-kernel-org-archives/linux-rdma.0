Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794434418;
	b=JiOhcIhm/38g3XhLfL1GjP9/2IVm2hRHUTgt+pC1ATUQ2Z+TutI+koXjOmTaw7hxOj8E
	 mV0+0xG8+7iaOf96xeAURnAZmRx+1TO4Q2pP+CRo85T3kswPZsr/OJHyDBuBVLxxTGs9R
	 oFuRegegqugwG7fvRuRnLoGWrirFzr95v3uwCR1ECarcrmTOZa+gV5RrzWyayndDK9Sd2
	 X3duIbsGm2ksXyPjYHVfK3dfnItAbdSI/yW6nxKsEdJ21b9WpY3rji36asiPfZI5DOEZw
	 TknYFx0R8TsS/s/C7yL+m3yMEnH8j40mmAkI6Uba0eMEgaKWj752uQ5CquE7kayZnCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794434418;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=ZD+L7G0dU9ZfLr8VDs3t/alXkxiNHldnHOnuvBLTnb0=;
	b=hixWUg02MTZzUw76zrcjLOAxRzoRN6HLAoaBFvfVdcw/iys/tyTlmYSN/lFlXwvEpGzE
	 g5K5CTI7u7Ybcu6qN7H6pOdayzaszzZa0UQBBDpW3j6PNeRBaZnn54B925apovD7qH+QC
	 umbm0chs4lpjZaFeZ3HTQytYA4YVm7zgn3oF6xyvRMKwgslrdElvVRpiZMJwQhkC1tFr9
	 MHymddaGaIs6r0tw1rzFKqCDpyukTofz6puljU7J4B5oga0lEKSee2AwFtG5M6hLzQ6YG
	 3Q1TgCrqN4dFLJY7QnXlqpoLJS0WR8yswfL23Xj/KCgu5eFfqBYOCXij37zc/f6pZMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SZC0fHC2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0B060A380B;
	Wed, 11 Nov 2026 22:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SZC0fHC2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C0021F00A05;
	Wed, 11 Nov 2026 22:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794434418;
	bh=ZD+L7G0dU9ZfLr8VDs3t/alXkxiNHldnHOnuvBLTnb0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=SZC0fHC2sEzh1SgQc4GqLtV3ex+qumWHXq3nWuHaynPOccBRpiyVoKKPF2VTapw7B
	 neFFHFP8p89wehMMrCBJXLkR/Sozm9PwrtgRkC57bKWV2jmODqXcWtvgmQsSQasrXO
	 ujGp+Kwo0VH8uSGrwMtJ2NLgxqbxhXw0jn41bYWF9C2GD/KOy1VkjFDOBndsbrhTZD
	 voplX13Yi6IKiLZgUTx3trsGz6n8GQcHil4VqgX0lHam4ZsEInLEyaFj6Aeh3E26fT
	 PJVLu/xKJQGwrAjMwseoHVPwqb/qcG+9cQ9erpVbSVHoOOohNAea7TZFASJKFKV3kO
	 /jg6H9Bitx1hA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 21229391AFAA;
	Wed, 11 Nov 2026 22:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next v3 0/3] bnge changes for RoCE driver
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179443441673.1663612.10927494746616901156.git-patchwork-notify@kernel.org>
Date: Wed, 11 Nov 2026 22:00:16 +0000
References: <20261105090154.1293846-1-siva.kallam@broadcom.com>
In-Reply-To: <20261105090154.1293846-1-siva.kallam@broadcom.com>
To: Siva Reddy Kallam <siva.kallam@broadcom.com>
Cc: leonro@nvidia.com, jgg@nvidia.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, horms@kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 vikas.gupta@broadcom.com, ajit.khaparde@broadcom.com,
 dharmender.garg@broadcom.com, sachin.holla@broadcom.com

Hello:

This series was applied to netdev/net-next.git (main)
by Siva Reddy Kallam <siva.kallam@broadcom.com>:

On Thu,  5 Nov 2026 01:01:51 -0800 you wrote:
> Add bnge specific changes needed for RoCE MPC channel
> support.
> 
> v2->v3:
> - Addressed Shasiko review comments
> 
> v1->v2:
> - Created pull request for RoCE MPC channel changes
>   of bnge driver
> - Addressed Shasiko review comments
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/3] bnge: Pass BAR1 doorbell mapping to RoCE auxiliary device
    https://git.kernel.org/netdev/net-next/c/db8054497971
  - [net-next,v3,2/3] bnge: Update HSI
    https://git.kernel.org/netdev/net-next/c/ac1ae795c555
  - [net-next,v3,3/3] bnge: Reserve ring resources for upcoming RoCE MPC support
    https://git.kernel.org/netdev/net-next/c/d60317882851

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


