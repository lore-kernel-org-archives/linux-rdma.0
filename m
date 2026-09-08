Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE63A2853FD;
	Tue,  8 Sep 2026 23:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788910871; cv=none; b=JgVaxCI11hwnvK6/PZ1t7+8w6/DtU//ySblKFzZnTuHywsUGpcDPVSpyN+Hx/9XwILjXF9mp6Wp1UUNDusHLxIJAqSy7hP8wf8wTtweXGf/zxoYeMZvEYDqKErotGNDGTz2Sz5+ZIzez00cWfHY0+RAtve6bM7XNK7RNcnChb1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788910871; c=relaxed/simple;
	bh=4FAZAPBSakihwQpbKH+2G2BWQM0JSzuSQhyj/LbVPEk=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=qDC3VkINDYDCU97IGwMkmDnyKPRqzSh73iu3hlhHi4czf5uisKUF33YyXUUl73hBDZZdXxqtNA7U3o45x+XDfGmbD10CCBF/e2bYDF8pzFoKI/QnWn/VIQHMtUcSzs0eyDBKfMQXjGdi2LXRkSk3aX1ar+fsbgTfSlJOO8vBgoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZxxpPckl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZxxpPckl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0CE1F00A3A;
	Tue,  8 Sep 2026 23:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788910870;
	bh=fjCOS4RTI31O9xBBv4SvyfkbLF/qGnIFX38EGfGx350=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=ZxxpPcklkEGI9HTIqa+zDv3LXse+4oEylcMra6jeAwmVrGtV3Ix18p6EHULOuZGYG
	 1/gwSn2Ex0s5VPS4FdimmptExVRQg7EPKqxXBDR+ysN/JI6+csD3KZqJjdSiQYu9ZF
	 2YKXbwxK6An2kJ7D53C596LRqXTqXFRhH+Xe+JzmA99oBehV7kLNF4tbgrLytfzXPI
	 OijnzW3S+hLCWvUKy2dpxUTyAgD1OXghJ21bjYxaHyW4vlCtJo3LopIHHNCnG0e4R+
	 3mYcjTeC2fyJw3s/9/HkvNVVMhsXghfKvMta/94+ChJF2TaLA/h5O+2kKZ8lCmkQeT
	 /bSE9HYhgGRVQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93C6D380820D;
	Tue,  8 Sep 2026 23:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] net: mana: Clear RDMA teardown and suspend state
 in
 mana_rdma_probe()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178891080813.64512.14455211971933232834.git-patchwork-notify@kernel.org>
Date: Tue, 08 Sep 2026 23:40:08 +0000
References: <20260902175153.3410560-1-longli@microsoft.com>
In-Reply-To: <20260902175153.3410560-1-longli@microsoft.com>
To: Long Li <longli@microsoft.com>
Cc: kotaranov@microsoft.com, kuba@kernel.org, davem@davemloft.net,
 pabeni@redhat.com, edumazet@google.com, andrew+netdev@lunn.ch, jgg@ziepe.ca,
 leon@kernel.org, haiyangz@microsoft.com, kys@microsoft.com,
 wei.liu@kernel.org, decui@microsoft.com, shradhagupta@linux.microsoft.com,
 horms@kernel.org, ernis@linux.microsoft.com, stephen@networkplumber.org,
 shirazsaleem@microsoft.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  2 Sep 2026 10:51:53 -0700 you wrote:
> mana_rdma_remove() sets gd->rdma_teardown to stop
> mana_rdma_service_handle() from acting on servicing events, but nothing
> ever clears it. A hardware service reset (GDMA_EQE_HWC_RESET_REQUEST)
> goes through mana_gd_suspend() -> mana_rdma_remove() and mana_gd_resume()
> -> mana_rdma_probe(), so from the first reset onwards every
> GDMA_EQE_HWC_SOC_SERVICE event returns early and RDMA suspend/resume
> servicing is silently dropped for the life of the device.
> 
> [...]

Here is the summary with links:
  - [net,v3] net: mana: Clear RDMA teardown and suspend state in mana_rdma_probe()
    https://git.kernel.org/netdev/net/c/f6d61fe4c19c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


