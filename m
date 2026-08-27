Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE4D3DF002;
	Thu, 27 Aug 2026 09:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787821262; cv=none; b=BJg8Pw+2ed2Ei5IOCz/zVzsHFWdN0cgmuh7m246RYu0KuLbQ2sv4zgm1o5Rh9xo4CDS5freKVWFzrCokowr96oSh+fkX8+IUcdJDxqTKhbJTx/z6x1+NikDOpT2gTQXJ6/Deg5V3AasW3uOrjRb/py4V4Bs+akB+6DlHD3tE0cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787821262; c=relaxed/simple;
	bh=Q6whbzRcZ9k4sqkn3vnPC02YqrJxjmQO+AznUzABxII=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=NDX7FX+g/QxEqvDQ62b4cmikbtGY+1Ctj/obv7sE2RuFgI3+Gev5Pds6AuQUBN2CEL58qfl/Nh77roFHN+Y7hjYAMhz82/AI2AQjMsdgdTPaJst0lIxcOYtkq/iWEhEVeVT/VVhFN9O1x9PfpxqAUPLwkE/iPlayUnMn4A9bE7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ut6r+Eog; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ut6r+Eog"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D751F000E9;
	Thu, 27 Aug 2026 09:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787821260;
	bh=Cy1WBtGzGohXvJnJquGBxbpK6ws7/jW5rQvvqM89U5M=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=Ut6r+EoghYrldNXwq5zLlSANh6QqOsA19O+Y119Wcu+ZrAINkx6WGuWeqWaOkIlNv
	 AQ63IbchZDwQ8PKGsbwLdte7DSf1FqE7ZuclhGpC46+tBvicX+Nth8NTN64246aOk/
	 92ZvAw2trjiLq00kvOR+txon0FBMXToxjLKYojVAk91WWUAMduvmZiFccMUP4PhGKf
	 +MrALYBLg+wikUO3L3g2A555ii2eDEbg4kWytPI+0sZTQx2nuO4jwSvXMayC6xkO3l
	 5M65Gg4fEZ8BxrzuKU/hRvbDbcp0OrLwXWvR3jjEJDr9zDFoyd9pG0wijdfEaNvOV4
	 ccxvcdZnOEkwA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 197CF3809A13;
	Thu, 27 Aug 2026 09:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4] net/smc: release the internal TCP sock on IPPROTO_SMC
 socket creation failure
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178782120564.1115437.5627444476394032461.git-patchwork-notify@kernel.org>
Date: Thu, 27 Aug 2026 09:00:05 +0000
References: <178753843966.342810.566471390946765094@linux.alibaba.com>
In-Reply-To: <178753843966.342810.566471390946765094@linux.alibaba.com>
To: Yifei Chu <Chuyf26@linux.alibaba.com>
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
 sidraya@linux.ibm.com, mjambigi@linux.ibm.com, kuba@kernel.org,
 pabeni@redhat.com, tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-s390@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 24 Aug 2026 10:27:19 +0800 you wrote:
> IPPROTO_SMC sockets create an internal TCP sock ("clcsock") from the
> proto->init hook. When socket creation fails after proto->init has
> run - e.g. a cgroup BPF program attached to BPF_CGROUP_INET_SOCK_CREATE
> denies the socket - sk_common_release() only invokes sk_prot->destroy
> if it is set, but neither smc_inet_prot nor smc_inet6_prot defines it,
> and smc_destruct() returns early unless sk_state is SMC_CLOSED. As a
> result, every failing socket(AF_INET, SOCK_STREAM, IPPROTO_SMC) call
> leaks one tcp_sock, so an unprivileged task able to attach a deny-all
> BPF_CGROUP_INET_SOCK_CREATE program to its own cgroup can grow kernel
> memory unboundedly.
> 
> [...]

Here is the summary with links:
  - [v4] net/smc: release the internal TCP sock on IPPROTO_SMC socket creation failure
    https://git.kernel.org/netdev/net/c/cec261b0b4c5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


