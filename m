Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794393006;
	b=FsVMe/LWkTSAMaLvchfHiBOydrniz1Cg/3ifcVvDTyX8dVfxxtUR0nX+nznwXjSOcn4B
	 4iUoBiWizN57hawQspMLjzWv8ifUyZYQm/p2OBuPdyAO96/6RNzxvfYOLuRrx5c7pF+cP
	 dmT5D8vJn3OmEQGtz9HbRfO/YmRS6YyGx1xJ2PNrN1HBpN3dhxsvVD1dIGvhmcp1PDJiW
	 vPPZ3zgC5co0kgf6SdzeCfmDYKZfYuGS+sqEGAGpXhkReCHFOxINO0wLXxVoXFvkXWbuS
	 3DcpluExO2ZzuquvDUKNtgIThhxYKDgmvVOJq3oIRjxLwxGSCAzePhk7VXSbzQQ6L8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794393006;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=zqAMTKDTeHhyNUQW2d/fCvS7VzvdhoOnM0Q+QGkmlTo=;
	b=Z65M7f5EGfXMupwyqIIuO+ULlWa5o7FyQLvSB/Nzqm2dQarR/hE9cpyef2irnsLNtkUM
	 TeQSlCTcNN/3bHgSpgkJYJlPILv3eMqnS0xuCEYbhSlW4gxyDegr+DWaxKF6KYO+37nR8
	 sggTOEoPoUKUkXYVA2KMXlCj0WpJaPP/Zf2GI6LlitJVkLvmTc5LKFwVdQG8sFwmSUQKr
	 OesItkF/yp2DVgWh8U9i91m/ZgoWIQujd/MPPYthRS+vh1WCh9SfagI2Pg+/yOLF0ShvW
	 qlX7YVjcPewwRwUydZv1Iyh/gbTTuLZmrR6TBEUmxFlTNgP8aYzIXahIbuB1uf9wrDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q+Er4JiL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95864606A326;
	Wed, 11 Nov 2026 10:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q+Er4JiL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1C41F00A05;
	Wed, 11 Nov 2026 10:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794393006;
	bh=zqAMTKDTeHhyNUQW2d/fCvS7VzvdhoOnM0Q+QGkmlTo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=Q+Er4JiLAohTaIxmNCZgLfL1lkSd+RMM/69vUgO7pG+DEFwLQtidEwB1RvmLq+UTX
	 fgQKlf+w85QZxUEB6zaH21JLTb5bLaVIRFYnfGNFBS7iAJ2WD40H4PyJ8STO4/P66w
	 3WhxGykmJcGnJA3rcufzxrVZh8Rtv/aXoWitCLl75jaabqjIDfaMvRDZn3yR9RmNF6
	 3nDSrcLQAECQm9ykzHqIIvd3WhkEDinhTzHeXvh6xnN086PdgrWmrmtFHKE4gwQ0i/
	 WMP5UmRqYw6v/Oe6gX2g46sQ3PQjZ7rg/3Dv2lRaK5WFl05m9K9Fci/v3MPYtxMAFg
	 8fs5CAUvi4bsA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 21086380044C;
	Wed, 11 Nov 2026 10:30:06 +0000 (UTC)
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
Subject: Re: [PATCH net v2] net/rds: Do not unpin a page after a failed atomic
 pin
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179439300494.851123.16127162374822202712.git-patchwork-notify@kernel.org>
Date: Wed, 11 Nov 2026 10:30:04 +0000
References: <20261107041804.64213-1-kylebot@openai.com>
In-Reply-To: <20261107041804.64213-1-kylebot@openai.com>
To: Kyle Zeng <kylebot@openai.com>
Cc: linux-rdma@vger.kernel.org, achender@kernel.org, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>:

On Fri,  6 Nov 2026 20:18:04 -0800 you wrote:
> rds_cmsg_atomic() assumes that a non-NULL output from rds_pin_pages()
> represents a pin that it owns. However, pin_user_pages_fast() can roll
> back a fast-GUP pin after racing fork() and then fail in the slow path,
> for example after a concurrent mprotect(PROT_NONE). The output slot can
> still contain the already-unpinned page.
> 
> The common error path calls unpin_user_page() on that stale pointer.
> This can consume another subsystem's pin and allow the page to be freed
> while it is still in use. A local unprivileged reproducer triggers a
> KASAN use-after-free write through an io_uring registered buffer.
> 
> [...]

Here is the summary with links:
  - [net,v2] net/rds: Do not unpin a page after a failed atomic pin
    https://git.kernel.org/netdev/net/c/8d5ce4751fad

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


