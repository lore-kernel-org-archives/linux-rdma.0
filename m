Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795131006;
	b=rMSjKMMwe6rWaOO1M7RQ4n8gz96cwUHUMgsZJmJpmqtXNSML9KtN04wmvjFrN7u+5bKz
	 BHKLlXraSQ5cUNYRBPpOuvAiPHqmDrr3z1cVc2vXQ3w7qURqPEqrfdwi5DgtG0BD1bfXC
	 WeSdS4NATb6VUsNnhggLRD+882O3yTAzC8dSdqGqOxBomLuiihObnY/cDQyCQ9XEbB2c4
	 q0Fjisg2gNyoLgo3PHPLYjN/qg7zxJmdnsKKSvIoR5ZPqSEJ61Ye5ZY25BqtEHpJfPWqr
	 eicVLUqXOE80hLK8e6NZ/MwQzlVguBJmRM3uVGVXjAoIVXVYtE24QADh1jN2vUl9jQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795131006;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=DWg9qHRxGrI8RIln0yvvTi/qV4EItOlaWMXukxuCsJA=;
	b=pcdd9barLzg4J69lQ4ECzFUsFzBBGoGr7huMXDXZZXOGAY8nYvf/9IC5I3ohpqu2kuwq
	 XMA3cU6vRXhx5DHtRs58+QedVux4YvCJV++vISy7a/n3GzrroHGcIciYZqgPPkXF2mT9h
	 2gbH3NkbC6cF/cUD0o5Dsegu0/NHIrux07oSYO2UQkWhmkDVXIxCLuZ6I7ZxYH1JA7NPP
	 87kNQWWCjqlt9EvYjbar3I9CHzovABU2J/+79sjJNE1hgMXr4GCOugaAczKHI0Bd/c39N
	 rcBc5dXrWFILjADJWhgVi2ctCMTulALzmaCTz+iC3G4GDStF8EQ+dVnAlfcQlMhTRww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SZX6FXe5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C637606A32A;
	Thu, 19 Nov 2026 23:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SZX6FXe5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF15B1F000C6;
	Thu, 19 Nov 2026 23:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795131005;
	bh=DWg9qHRxGrI8RIln0yvvTi/qV4EItOlaWMXukxuCsJA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=SZX6FXe5d8jQufXqT/cesFjasKNuivTyeCROdgvHQj/nm9L1upeXwdBzwT2Ab23o4
	 5i4ilyPRgH8n1fx2mod8wJszTWJQbHycvkxSkDJLouHhHINlYm1dPUOVKxEAtSWMna
	 Hz5p6qJthyoSQb/J4UAZh0A2x/jg8mNYSBDaaR50wobJjTY66LVP22geOeazp9V5Dr
	 8OBqW8oY9geT3LLhkPkoUQRQZyByjE/4jTTe6Zwdp58DPW6oLorWxjPFnhcPDJVnd1
	 n9L+fbkaxJJgz3YB72sjOmXZnZQDzP/YBGBbHchR5V1v3YTbUO7vj2GzPzcttcX8uY
	 vpmTdTewHMitQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B44AF3808209;
	Thu, 19 Nov 2026 23:30:05 +0000 (UTC)
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
Subject: Re: [PATCH net] net/smc: check every link before skipping the RMB
 registration
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179513100453.3921246.8361050512284832541.git-patchwork-notify@kernel.org>
Date: Thu, 19 Nov 2026 23:30:04 +0000
References: <20261113-b4-disp-08835f86-v1-1-b2ee1b9b94e2@proton.me>
In-Reply-To: <20261113-b4-disp-08835f86-v1-1-b2ee1b9b94e2@proton.me>
To: Bryam Vargas <hexlabsecurity@proton.me>
Cc: edumazet@kernel.org, sidraya@linux.ibm.com, dust.li@linux.alibaba.com,
 alibuda@linux.alibaba.com, mjambigi@linux.ibm.com, pabeni@redhat.com,
 kuba@kernel.org, davem@davemloft.net, horms@kernel.org,
 linux-s390@vger.kernel.org, guwen@linux.alibaba.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 tonylu@linux.alibaba.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 13 Nov 2026 14:11:44 -0500 you wrote:
> From: Bryam Vargas <hexlabsecurity@proton.me>
> 
> smcr_lgr_reg_rmbs() skips the MR registration (its fast path) when the
> RMB is registered on every active link, but the check reads is_reg_mr[]
> at the index of the connection's link for each link it walks. An RMB
> that sits unused in the pool when a link is added is not registered on
> that link. A later connection on the older link that reuses it takes
> the fast path, never registers it on the newer link, and its
> CONFIRM_RKEY still gives the peer an rkey for that link. After a
> failover to the newer link, the peer's RDMA writes into the RMB fail
> with a remote access error, that link goes down too and, with no other
> link left, the link group is terminated.
> 
> [...]

Here is the summary with links:
  - [net] net/smc: check every link before skipping the RMB registration
    https://git.kernel.org/netdev/net-next/c/7e23d36038cb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


