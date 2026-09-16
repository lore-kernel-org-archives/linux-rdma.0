Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8432765DF;
	Wed, 16 Sep 2026 01:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789520471; cv=none; b=PZajSvk8U1dyugitqrAW3PslZFA3MKP0m43yj2LbjJNtbItN30WXIdKWVw6KSjwOLN/eXVLgWuMwnRaGpMHln9ZFYTrW9P/4tmBS5DwvjNMepicvuzYZVdU9TnXiPJ/Noz39bbba0wqvyf9AfnM3YAs7BlPPkzXbphLmg5unZ7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789520471; c=relaxed/simple;
	bh=9gc2wxDRVNySeG1wffhpjDGFp1KH+YlSZyJ1bd3qLNE=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=gekTMLyrC8BALQK8I+zpGqp23tT/XPwzBSOX4fPrID/g8CiVfi1OpzS0pQIeb8Z7ffJOkIbe6qVm1G9bW6KbAAnM/idwf3jBPztDJAzGy+kAarJJN0mPlwWI02ts8pw2tC4MFsCCSr9oydD9VDQrxNe2PMqs3a/sYGuXQdeabbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ki2URNy4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ki2URNy4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAF871F000FF;
	Wed, 16 Sep 2026 01:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789520469;
	bh=GkVTuFIlCWtgACl+1vvYBeFucxC8Jlxo3kUZZYYG1HY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=Ki2URNy4nXA/xuG7bO4MFkSyW/JwG1QTknX/Vdl6jDtwjqX8Xin8eiygIgNpn1yT5
	 ntD+O5/hi+gwc8qCR1oVULWRsvxMUne7lftJx1rZmrXF0Dby2dUr4Z8KjuT7hn/zy9
	 rarpHSV+OBiAccXQK8F4oMmY7Nzb6n1iCBXEYuAN639s8K0AP0Fd9cdvm6AAjWITjF
	 gjjMUUtipwQfPNoZjsZ5aku3dn3SS3pQ1w3KPcUToa2isnxhO+LeTfYNJohmxHeZ/n
	 +PRIqTmmMGx8iSmMylUmhyvmWMMzE+Z/gPY+5huqHWVMIZUH2QUjQvoxvz2VPZ3xbs
	 Nzq7qkidgYOHQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56A2E3927074;
	Wed, 16 Sep 2026 01:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: mana: Use the HWC destination queues
 reported by the hardware
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178952040388.2343259.9924466903523811336.git-patchwork-notify@kernel.org>
Date: Wed, 16 Sep 2026 01:00:03 +0000
References: <20260910014427.54272-1-mawasthi@linux.microsoft.com>
In-Reply-To: <20260910014427.54272-1-mawasthi@linux.microsoft.com>
To: Manish Awasthi <mawasthi@linux.microsoft.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
 decui@microsoft.com, longli@microsoft.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 kotaranov@microsoft.com, linux-hyperv@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, horms@kernel.org, gargaditya@linux.microsoft.com,
 ernis@linux.microsoft.com, kees@kernel.org, paulros@microsoft.com,
 mawasthi@microsoft.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 10 Sep 2026 01:44:27 +0000 you wrote:
> The hardware provides valid HWC destination vRQ and vRCQ IDs for all PFs
> and VFs. Use these IDs unconditionally in mana_hwc_send_request(), as
> the PF-specific gate is not required.
> 
> Signed-off-by: Manish Awasthi <mawasthi@linux.microsoft.com>
> Reviewed-by: Long Li <longli@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: mana: Use the HWC destination queues reported by the hardware
    https://git.kernel.org/netdev/net-next/c/4e8b65ecb64c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


