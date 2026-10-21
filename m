Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792542607;
	b=Ty5c9KmOUK1xhbPRBiy88qgVL4lFYD041qortwbMnRVGCX09GZUy6W1ll8prdMSjrDmB
	 is782XTO4/WXRvmyzGBuUuSzhbB8yawM6chvJOtl/1eNCQ+rk/+A3rhVwGM67FjQiwH7p
	 7QXvrJgJojggRBor6rPJ2z+FzW9otBD6Qd38q1vCD6HC5cYlHiauLMkm/qXv+cGXWdZc+
	 ZEIhL0pNTnYK0aaANshXcdHbp8OTGX1KeOuSPuFDDEfSMW7CfE799aadErMPwG+epZZt4
	 nbEA5TgFPD9HLO4nO0BzSXWU0F0Gu18QcwMw5zD33QX/3UozkKmlg4LdCstHuFL/NLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792542607;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=LKjCAiH5qiP3wJKkZahsAhQ/3u7L0s1+MefSYyAuKeA=;
	b=TsE7mghCUlr5zKmxjG/HDEFh82Y3NV28tfMPOOnDOzt1AfZg6Or1M5VCETEiGzEkkBtu
	 3TrOjInrBGQDE0EDqVu7QONndkkEGbmWyWOk9T9VmgaoZivmMW16xw32nQB7lAHGpjaFb
	 KXfIWp0O90Uw9CPavJaZG7w7RATzmLcnzx/V+U2FLNM1/3x0DGN7loxJUJ2w/tPPhEyKK
	 LQv6Zs8Y797HcYsxbCSVnvRK5O1sJjym0TI3RmkFQKA+isPnz07/7XNBbV7FdW04mvySU
	 2DYuuyLTN0EBnkSgJR/nXVsS1UJygRukz+cWEfReF8ptLfGitJBx8DI1WM6dxJpiD+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aW1VVzET;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED297606A31C;
	Wed, 21 Oct 2026 00:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aW1VVzET
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824AA1F000C9;
	Wed, 21 Oct 2026 00:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792542606;
	bh=LKjCAiH5qiP3wJKkZahsAhQ/3u7L0s1+MefSYyAuKeA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=aW1VVzETW4tqKrP8ybUBa9+EpBv5C689mcPLyhd13+KDZPyPrJaWhmeC9HYkRICMv
	 GYRXOprxcJu0pRVgMCgfunWxAkTy42dhzBIa+Gq7JiKEdDWGSndJEMWo2hKuWD5pjH
	 GkLoK+LBJLyp4vYQf1BmbxGDtH/XE8K3Y9kYJuIMf4bEmpt2Ikn837lqA4CT4dQ8/d
	 xlFZ0iEmcHpDKTJWFQvhL4rT9oXO0EWVU0qFbFE5Lxwvo8ZedChd9MPFf4Nqlj/R2I
	 UrCQaBjyN9gwc0S1C/EFr0a7noe8C382sCfbVkN6Sw1FNrw2AWtkmZmS9Nb4vYF304
	 pF7Qg2Q434H+A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 773883809A0C;
	Wed, 21 Oct 2026 00:30:06 +0000 (UTC)
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
Subject: Re: [PATCH net] net/smc: queue the copied chunk when smc_tx_sendmsg()
 faults
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179254260529.285569.7327576902059914467.git-patchwork-notify@kernel.org>
Date: Wed, 21 Oct 2026 00:30:05 +0000
References: <20261013-b4-disp-872a3689-v1-1-2a4c63b04761@proton.me>
In-Reply-To: <20261013-b4-disp-872a3689-v1-1-2a4c63b04761@proton.me>
To: Bryam Vargas <hexlabsecurity@proton.me>
Cc: kuba@kernel.org, dust.li@linux.alibaba.com, pabeni@redhat.com,
 edumazet@kernel.org, mjambigi@linux.ibm.com, davem@davemloft.net,
 sidraya@linux.ibm.com, alibuda@linux.alibaba.com, netdev@vger.kernel.org,
 ubraun@linux.ibm.com, linux-s390@vger.kernel.org, guwen@linux.alibaba.com,
 horms@kernel.org, linux-rdma@vger.kernel.org, hidayath@linux.ibm.com,
 tonylu@linux.alibaba.com, linux-kernel@vger.kernel.org, wenjia@linux.ibm.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 13 Oct 2026 15:45:01 -0500 you wrote:
> From: Bryam Vargas <hexlabsecurity@proton.me>
> 
> When a send wraps the end of the send buffer, smc_tx_sendmsg() copies
> the data in two chunks. If memcpy_from_msg() faults on the second one,
> smc_tx_sendmsg() returns send_done, which already counts the first
> chunk, but leaves tx_curs_prep and sndbuf_space as they were. send()
> reports bytes the peer never receives, and the next send() overwrites
> them. Any caller can hit this on its own stream with a buffer whose
> tail is unreadable.
> 
> [...]

Here is the summary with links:
  - [net] net/smc: queue the copied chunk when smc_tx_sendmsg() faults
    https://git.kernel.org/netdev/net/c/c0703534b223

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


