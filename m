Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656ED27FB37;
	Thu, 28 May 2026 23:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780011606; cv=none; b=BQGFV8doq1hjau1p9nzIDVzAUwRAxRpRqV1D/1GWPmam0VPACG+WavSSxqkFEI2+hO7PNXsoNRy854UrbqauPyAA5tsIV/7AHk0yAYLy8Szu9Zv32bwcmxk0H77WHEnyZPW14V0WCSIRDV4k8b0xYejkCzcFIqTbAHd6qf1AnSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780011606; c=relaxed/simple;
	bh=in6VrdZBtwLirRhauWW/WIzQfgBg+9Z1mK9TuB8HtnM=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=VzQBpzp1K3yBCS/EOMYP/dWGJGSpItskAesJjOki+jflEhTdNKOl6nrykdJdNNRxpLT4Hniw1Fmm56zsf/sMRvvbdRyvqPCxa9Yh6NBpb9wKuDSf8KczAfQhYaYbBL9R5O7BeIb2rocQyA3wvwO3PYJIE8x3LLqOoo4M71ie6+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KHcs60g1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KHcs60g1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22F81F000E9;
	Thu, 28 May 2026 23:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780011605;
	bh=ccA9JNuVea+oGFW5GHOnVHXDZ35mVAr5HSPbvMi+HqI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=KHcs60g1UGpGNdC9riKi9wdpWYEtzHcMkgMKnrJbtr2AWVnM95SKtUyLTUk0cDAfh
	 jADa9/htHxWUbyL7Y1MqpYPad+Xhv5b9l9J1LumAVE5a5INNJWha4mNa5atJbCQDuI
	 t40/aj7B0jZ3kSQ1RZChLrFXVePVgTB651cV08Qxg/Hm/GAgapM9t79ORBeM2ybama
	 imVSzSDolFOL6UAi83GiB+eAqZxZUWk/glTccTJZMnZt1QYXFNZxdmd/kWMDQLBjUR
	 qf1WYA0CHpNa7jquz8w+kwTEhx3E61GDlwZX12cwZRrFACT8P6JiYCMTbNUHRYDYab
	 kRlcyD/4DMu9w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56F1D3811979;
	Thu, 28 May 2026 23:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 0/2] net: mana: Fix NULL dereferences during
 teardown
 after attach failure
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178001160914.1558963.14730809157167535263.git-patchwork-notify@kernel.org>
Date: Thu, 28 May 2026 23:40:09 +0000
References: <20260525081129.1230035-1-dipayanroy@linux.microsoft.com>
In-Reply-To: <20260525081129.1230035-1-dipayanroy@linux.microsoft.com>
To: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
 decui@microsoft.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, leon@kernel.org,
 longli@microsoft.com, kotaranov@microsoft.com, horms@kernel.org,
 shradhagupta@linux.microsoft.com, ssengar@linux.microsoft.com,
 ernis@linux.microsoft.com, shirazsaleem@microsoft.com,
 linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 stephen@networkplumber.org, jacob.e.keller@intel.com,
 dipayanroy@microsoft.com, leitao@debian.org, kees@kernel.org,
 john.fastabend@gmail.com, hawk@kernel.org, bpf@vger.kernel.org,
 daniel@iogearbox.net, ast@kernel.org, sdf@fomichev.me, yury.norov@gmail.com,
 pavan.chebbi@broadcom.com

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 25 May 2026 01:08:23 -0700 you wrote:
> When mana_attach() fails (e.g. during queue allocation), the error
> cleanup frees apc->tx_qp and apc->rxqs and sets them to NULL. Multiple
> subsequent teardown paths can then dereference these NULL pointers,
> causing kernel panics.
> 
> Patch 1 adds NULL guards in the low-level teardown functions
> (mana_fence_rqs, mana_destroy_vport, mana_dealloc_queues) so they are
> safe to call regardless of queue initialization state. This covers all
> callers: mana_remove(), mana_change_mtu() recovery, and internal error
> paths in mana_alloc_queues().
> 
> [...]

Here is the summary with links:
  - [net,v3,1/2] net: mana: Add NULL guards in teardown path to prevent panic on attach failure
    https://git.kernel.org/netdev/net/c/17bfe0a8c014
  - [net,v3,2/2] net: mana: Skip redundant detach on already-detached port
    https://git.kernel.org/netdev/net/c/5b05aa36ee24

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


