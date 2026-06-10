Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD4B22A817;
	Wed, 10 Jun 2026 01:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781053218; cv=none; b=FZDvNkCo8/KCW4Dy0sV052VHcdbrJ5yOYxd2jX/7Lu6hJK2/HlsguZv+Ka1R/lPhkUtG85hS+oYl6uCgsa/OgPP1yeCfoQORCWDU0TtHhnt2HdpsiscnNrjiLUpn9rwr6ADUILjIWgr7beowHnXQmMNwTwSkMHAdC3fGCrSHqIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781053218; c=relaxed/simple;
	bh=hbRiHEExZ2Rxt0AQCQ6La/MmMFjf7F6cK9zj4Z3IbW4=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=fkxbT8Ohl2kj0rqUSl+TAcBViOTszRX76gW+R6dQlnf3eVs3lcFxzmqp7xY31u4Jl9IOzrGFuSJ4Ilb/qtbGVYVoYXL822QwoZX5jwzVfuvG+DmPDw3BjaB8AtQqaUuKpiT6jmEXan2WYo71593/451KGqkSwtkCEcWPyoNEU+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eWuD4Si+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eWuD4Si+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05D61F00893;
	Wed, 10 Jun 2026 01:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781053217;
	bh=W7mllDzT2FsJ+OI1O7OpbTo1+G3QNmtAmeh22+A4/oM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=eWuD4Si+O0KHmopNJAThHxDeSDFNAh+MvVEHVF/vdBzhtE5BTMac8XGu+Jt+/xYAg
	 xExK8oaeEnRO5ZpxIn91csKWMazi4GG2dmwFbUEKSS7GR+tS07/KkYSl3JLITxdm1/
	 /gVcyVfJiKEwJEGwUOE7ARo2ruKq7dB99619Qtv2mSom5sQZ8++NrMWxc5rZsUgaZI
	 U5qkJo8uTC1L+kH3IcJHtmIvvDOBw8aHa/NXgTbM1mbkzT+mWBCAg46jbE7bhKf50u
	 +fnDUAMVMKtUMmJid/m9hLpAwq3RMLHmbjoAHrl+KOC1GOKjwBZv0qbRSUR4Ce//sd
	 b08K4jyX/3Sjg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 1982C3930A12;
	Wed, 10 Jun 2026 01:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mana: Add support for PF device 0x00C1
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178105321563.2773882.757132488174219271.git-patchwork-notify@kernel.org>
Date: Wed, 10 Jun 2026 01:00:15 +0000
References: <20260605212302.2135499-1-haiyangz@linux.microsoft.com>
In-Reply-To: <20260605212302.2135499-1-haiyangz@linux.microsoft.com>
To: Haiyang Zhang <haiyangz@linux.microsoft.com>
Cc: linux-hyperv@vger.kernel.org, netdev@vger.kernel.org, kys@microsoft.com,
 haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
 longli@microsoft.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 kotaranov@microsoft.com, horms@kernel.org, shradhagupta@linux.microsoft.com,
 ernis@linux.microsoft.com, dipayanroy@linux.microsoft.com,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 paulros@microsoft.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  5 Jun 2026 14:22:56 -0700 you wrote:
> From: Haiyang Zhang <haiyangz@microsoft.com>
> 
> Update the device id table to include the new device id 0x00C1.
> This device's BAR layout is similar to VF's, update the function,
> mana_gd_init_registers(), accordingly.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: mana: Add support for PF device 0x00C1
    https://git.kernel.org/netdev/net-next/c/53a65db20a4f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


