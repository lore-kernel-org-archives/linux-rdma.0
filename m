Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793097608;
	b=4Re2ZMPCzDKpXJvWPi0hAencezj8Tk2U+oa09/fmDzr0nmNjpqlkn5PD+zbSG16BU8XU
	 PbmcQ1vGNqvRTqY0E15KwsGa+RRu9+b6RC2V3gtgHgiuVPMmJaMGRKKufKMBroNq1M9TT
	 P7BtHvi5RRxLfIyZrVzdRj8jgGgFCBivL/SQXXbI36do5ItMmjPE2fWjS9NK7rua7IW04
	 dWasnTDj/sz6GT5Yo5VL8dYwfyHCaCDQgm3ZhPQFDqTcbotba8HawAqCAptnyfJIDNHMA
	 SDM/5S6zw2LtDXUIGWWhoM3eTzljJEUYWF+XRr2mnPKOYHWRXuiFX64GKcKGdD2KQ/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793097608;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=GuGgE8OKtJwoAitwY4DD0ELaMDg6PGFPllXF4+JMIEM=;
	b=q3MnP4JL8WhIf3xArVHvIYSc8uYDlfbXGcYzgFGjkEI1InE1yZ4tH297XBqnawPHvFEF
	 ywKnt0EVxL7O8DPLSIrwuGi1p5v/MRFD4L2HolvCgyP4PEKmRc1cEh9dR8aSavHAZJejq
	 AQww7h6/ywzrw2S2wXxunfR204fpfwbCqTsNVTxqW2FnTz5rofojXVqLYhi/sQRhEhnHa
	 iPsQffPsPesfqcuXwjdS5nUQnVgukknf2F8hS+nWQihoOSB8yUNAf2vM/UrrPdTtDXPT0
	 Qf7JPyebiLSzwpQ87fOesqtBcxu3WsGsHAgoN00VB8K6xsEW9aG8qD5eMHYqaVgigrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IcaPz4Zv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE58D606A31A;
	Tue, 27 Oct 2026 10:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IcaPz4Zv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E44B1F01825;
	Tue, 27 Oct 2026 10:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793097607;
	bh=GuGgE8OKtJwoAitwY4DD0ELaMDg6PGFPllXF4+JMIEM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=IcaPz4ZvjFKpqFzQXEKc+RJvHPcrk4QFFmYHigqPle8EU3LugD8/nQwNhnZ8uCmGI
	 GOgLtG7lxV9v4y9SDE1dJiEp9fZ5lJAHpsDiDN1YJ9jMC47PDPbQ9mB1f/o13q7Cl3
	 oJt6orM4CuDRotWB2p0HIYv3bH9Re0/ys/wF8sYVG7coTLT7qSCbxqndYsys3BGzMo
	 ElDnOf/K/tsWPx+riRNxuhxSjYyAjg5+FlBlQddRCzVQPBeSDmjH3MvlMo7BAP9f4H
	 coEmjWatB/F0Rz17bW+Wrggy8joatN1SAwK/0IHw2mL2ZeD7D9cjfl4s2mfBXqtMr0
	 rs7dee0iubtoA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 445853AA8FFF;
	Tue, 27 Oct 2026 10:40:07 +0000 (UTC)
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
Subject: Re: [PATCH net 0/2] net/rds: fix init failures leaving built-in
 transports on a dead core
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179309760607.3719222.9152357183301590944.git-patchwork-notify@kernel.org>
Date: Tue, 27 Oct 2026 10:40:06 +0000
References: <20261021195837.142802-1-achender@kernel.org>
In-Reply-To: <20261021195837.142802-1-achender@kernel.org>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, oleg@redhat.com,
 joel.granados@kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 21 Oct 2026 12:58:35 -0700 you wrote:
> The kernel test robot hit a slab-use-after-free on rds_wq at boot with
> CONFIG_SYSCTL=n and RDS, RDS_RDMA and RDS_TCP built in [1].  Two
> separate bugs are involved.
> 
> With CONFIG_SYSCTL=n, register_net_sysctl() is a stub that returns
> NULL, and RDS treats that as -ENOMEM, so rds_init() fails even though
> every tunable has a usable default.  Patch 1 only treats NULL as a
> failure when sysctl support is built in.
> 
> [...]

Here is the summary with links:
  - [net,1/2] net/rds: do not fail init when CONFIG_SYSCTL=n
    https://git.kernel.org/netdev/net/c/fbea154a8664
  - [net,2/2] net/rds: do not initialize transports after rds_init() failed
    https://git.kernel.org/netdev/net/c/ffbbc315b8b8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


