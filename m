Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C673F12FC;
	Fri, 17 Jul 2026 11:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784287840; cv=none; b=s3EdlqFcmeViEv0C/gc/fYxIixntSZIUZ4tP/ZdkBl/sHV/QPrM1mMLuEE0PW6CZvO17CqYGPuPZGm+SmvGt1h2BdfQa3aNPAfSnSbWtJlNLcvQmetDL+6J78SKAoCMmBi4luOsjv2kRjY0IfMfxNZvcsUpEO+k/c8u6U+Fr3iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784287840; c=relaxed/simple;
	bh=tCCW51UQqRAnCV9+aWPOkYDX40/UE0vGzPRCVq3yr5M=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=bSA+1IZ0bzBTs+mE2KPh5so2hgIkIl5/6ktqtwHR9CcdaTg0pa53etfCCZFFWyVojw8qkyJsAlB6+ZTqSHvh5azVU0p5vPvAYbjRLlu8lOmW+7NZQIqeFaFD6eIy7gqweYSZXLI7SAJUAtVNaCMOSkTt6oXYTXBfoLGhmPEsRQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OSvzOZUZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OSvzOZUZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5985D1F000E9;
	Fri, 17 Jul 2026 11:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784287838;
	bh=MI9UFehpVJgBRPPNLEaHUq+huwF0X6pl2FktHqQ844Y=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=OSvzOZUZWS3+F9kl+ZzWFW9Qe5knFbSkLKNReYFdC46rpsZKMG70TA82LOe47x2XE
	 ra0SeSvimTQID+D1hGDee01zYlX+sitxpaRHhe9Cp5MGvKXjOi5/KhtYBHUu5K6764
	 F2vaPIFke5HQpwovmiS928EuUorn2gzX0s0VmjUS65YpKWowe1/aqNgpwGets46lpz
	 /NVtKohTblYqcjk1Iv9ff1mdt/NoPYF9980q7zZ9GM5kce1fFsMOA201uzAfmpBvol
	 AoboEwsj1WvnFnTWw3tmfqGuj0TinD7sc+SZudqi8EFxnY4m4063AtL8CAMvprFDcA
	 4dprWjrKTRs8A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19B0F380CED4;
	Fri, 17 Jul 2026 11:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mana: Add debug knob to skip TX timeout
 recovery reset
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178428781064.1678100.7570986576117461503.git-patchwork-notify@kernel.org>
Date: Fri, 17 Jul 2026 11:30:10 +0000
References: <20260710132229.2851441-1-gargaditya@linux.microsoft.com>
In-Reply-To: <20260710132229.2851441-1-gargaditya@linux.microsoft.com>
To: Aditya Garg <gargaditya@linux.microsoft.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
 decui@microsoft.com, longli@microsoft.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 kotaranov@microsoft.com, horms@kernel.org, ernis@linux.microsoft.com,
 dipayanroy@linux.microsoft.com, ssengar@linux.microsoft.com,
 gargaditya@microsoft.com, linux-hyperv@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 10 Jul 2026 06:22:29 -0700 you wrote:
> Add a per-port debugfs boolean "tx_timeout_skip_reset" that, when
> enabled, makes mana_tx_timeout() log the TX timeout and return without
> queueing the per-port detach/attach recovery work.
> 
> This is a debug-only aid for bringup and qualification: skipping the
> recovery reset keeps the device and queue state intact so a TX timeout
> can be correlated with hardware telemetry. The knob defaults to false,
> so production recovery behaviour is unchanged.
> 
> [...]

Here is the summary with links:
  - [net-next] net: mana: Add debug knob to skip TX timeout recovery reset
    https://git.kernel.org/netdev/net-next/c/922cc43c6243

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


