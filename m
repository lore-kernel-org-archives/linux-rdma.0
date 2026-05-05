Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A436235B657;
	Tue,  5 May 2026 10:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777976460; cv=none; b=tYFFzyo9LiaOELsFCftqY1uZXQsD6TFRe5ujQF9ZnBuj0HZ6/4PpjMTS7KIdjpuivs35sjEcWRZzA3vafnUnIcxN5yWHOnaSPRSIeC8nombfcuC5ovOD5eNkGzWsgXIshde6LyRzHzKDgJwXrCA+hs6vwAy4W6+Ut4GfqgR3NPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777976460; c=relaxed/simple;
	bh=leghXJktf1RIFFo6BA/P1O4TGxDiVwVbjhQkh7sBwOM=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=coKB7ZFCt4MHoZkYGiqoc1W7HtR63MaxDatqqcaNptsWNvCaPaK7origP2Uu1tJY63kIExEVOo4qP+8GrexTzJs1MuZpRflbTzVAwm58bv3jZUGL7ynSMhaO45QCt/gAM1tr//ue4/UCLy84tjC65C6zctBpQqUq0bGTz3OINbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bglvbUhm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bglvbUhm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2677C2BCB4;
	Tue,  5 May 2026 10:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777976460;
	bh=leghXJktf1RIFFo6BA/P1O4TGxDiVwVbjhQkh7sBwOM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=bglvbUhmxgrBQ8yzV/ZTTuzG2QpNQpnTft2of/B82/TBI3zdWtyCgmigctccq9U3N
	 ewaS7+hUTGICgu1S9j/G7A/6e3WtsVUo9xlY5dFBbZ+AhaWUjz7rt0pncWrVEwaIPQ
	 y6Nss/e+RR5hV/BN/X9EhJMx+qLVMCpCsKKRxd6Z/1c7T1hIyVLg3FJL/YyrOkkAky
	 95KKRKqeIslOHR5pC8cdzGFA6Dr9KGtX1JTLrMlKpXtOduMTkoKuHpS195PjiByQgm
	 jfOVy3Nht+JRavQ8ikStJhbZproK8E7N2sVvC/Urc7sY4LIrka/2cGUtfXAVfPCJNF
	 /XK9QDwuIGpeA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B9ED1393020F;
	Tue,  5 May 2026 10:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/3] net: mana: Fix mana_destroy_rxq() cleanup for partial
 RXQ
 init
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177797641055.1553500.1206915425862203852.git-patchwork-notify@kernel.org>
Date: Tue, 05 May 2026 10:20:10 +0000
References: <20260430035935.1859220-1-dipayanroy@linux.microsoft.com>
In-Reply-To: <20260430035935.1859220-1-dipayanroy@linux.microsoft.com>
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
 daniel@iogearbox.net, ast@kernel.org, sdf@fomichev.me, yury.norov@gmail.com

Hello:

This series was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 29 Apr 2026 20:57:51 -0700 you wrote:
> When mana_create_rxq() fails partway through initialization (e.g. the
> hardware rejects the WQ object creation), the error path calls
> mana_destroy_rxq() to tear down a partially-initialized RXQ.
> This exposed multiple issues in mana_destroy_rxq() path, as it assumed
> the RXQ was always fully initialized, leading to multiple issues:
> 
> 1. xdp_rxq_info_unreg() was called on an unregistered xdp_rxq,
>    triggering a WARN_ON ("Driver BUG") in net/core/xdp.c.
> 
> [...]

Here is the summary with links:
  - [1/3] net: mana: check xdp_rxq registration before unreg in mana_destroy_rxq()
    https://git.kernel.org/netdev/net/c/e9e334f8063a
  - [2/3] net: mana: Skip WQ object destruction for uninitialized RXQ
    https://git.kernel.org/netdev/net/c/2a1c69118282
  - [3/3] net: mana: remove double CQ cleanup in mana_create_rxq error path
    https://git.kernel.org/netdev/net/c/3985c9a56da4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


