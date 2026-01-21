Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2870222582;
	Wed, 21 Jan 2026 02:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768962627; cv=none; b=XHAoh4+Aw27/cgeEVAwaSKnWND0dkhMjtypbicfyMKqVKwn7tOprM8Y7g0SQ1S9xAiQ25ifWiWwMr5/cxPb0x+YmNUFsSjCWyAVB8ORd66IpNzbqwAE4xQXyt8GnNzSEepBwrbL6OEATnuDCHN4TYIXEwadUPZyf6c9DPz9nYJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768962627; c=relaxed/simple;
	bh=k+TKUc0GuHIF6ay52xPME+n8NJ6l+KMX+dcDoV1zwYg=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=cqIA9PdI81vxr/xN6wvqDGg0vorQf1ExoD9ngvP544824zr5S6hnifvhoBBlK1pAlOwmhQ4iAvU/6TAM5Tm52ox/Dk18+bn7rh4g0sKUyDqkqugOKBl5MT7z6/Z9g4ahdm0vijft3WEUfr91NYIFlwxeJIKbjrk0Ri9Ij6GCii4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pLvm/pDw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pLvm/pDw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732FDC19423;
	Wed, 21 Jan 2026 02:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768962627;
	bh=k+TKUc0GuHIF6ay52xPME+n8NJ6l+KMX+dcDoV1zwYg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=pLvm/pDwlgzXSpfVDffw9uzj+IkP4xrcNZdjjzUdCGLXJ1abSoqNFjkFD4jnZM7o1
	 8v3avbwWS/H00VtHBma9uvdXbZ3UqbRKzj9n1tyEt6y7nT/OzWVxV0435VdnZwWLDL
	 8i9x95dcuAE6XvJHE07IwHxEoifw7OYWGUOJrg0Do00VudSv+P6JsIahzlGH2vSfal
	 EdHrIoOqn+4dhlyrhWdkz6gl8zMLKp4jsYIb75b0hqoMCjSDCwMVyNuE4ZmF3LE/in
	 O7M4s6Jpe+RKrsqRaYQc2GfENxojh0PRm4YyCGZgWmPMQyxljZDoYX6QubuJjG7gkh
	 gU2z5oCEoCISw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 11BD5380820D;
	Wed, 21 Jan 2026 02:30:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 1/2] net: remove legacy way to get/set HW
 timestamp config
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <176896262485.696500.7276448637891401906.git-patchwork-notify@kernel.org>
Date: Wed, 21 Jan 2026 02:30:24 +0000
References: <20260116062121.1230184-1-vadim.fedorenko@linux.dev>
In-Reply-To: <20260116062121.1230184-1-vadim.fedorenko@linux.dev>
To: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, kory.maincent@bootlin.com,
 richardcochran@gmail.com, horms@kernel.org, shuah@kernel.org,
 sdf@fomichev.me, tariqt@nvidia.com, leon@kernel.org,
 linux-rdma@vger.kernel.org, netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 16 Jan 2026 06:21:20 +0000 you wrote:
> With all drivers converted to use ndo_hwstamp callbacks the legacy way
> can be removed, marking ioctl interface as deprecated.
> 
> Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
> ---
> v1 -> v2:
> * added cleanup in Infiniband
> * adjusted documentation to remove mentions of legacy way
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] net: remove legacy way to get/set HW timestamp config
    https://git.kernel.org/netdev/net-next/c/5062245a5a7f
  - [net-next,v2,2/2] selftests: drv-net: extend HW timestamp test with ioctl
    https://git.kernel.org/netdev/net-next/c/49743f27268f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


