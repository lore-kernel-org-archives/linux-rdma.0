Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C75478E5D;
	Thu, 24 Sep 2026 11:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790249481; cv=none; b=kabC3sa0FHr7z5HQaL5ujPZ6hIILQ28JoNQSDFr6dcdVpvKTMRXHVoYE/FQApNqHu2REo7xw3tv5EFHg3BLC4PjxEsJmurHtfM1zRannH8wgCPlBf2+sLX6sMdcoZNwk93B7bP6EWeoh64bbQt5LNmWcHUnli1b7+x/q/ZWx1B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790249481; c=relaxed/simple;
	bh=E+YwRQF6sr061n4Twr5/dcfvdLXfKbIUI0NhnA4wN6I=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=rhbm2OUC5JFdOYmeNu5AWzIrpkt+4LrrVUnjn8XtaXbuTqQTJbuW1+Fsh9N/Z3GDPMSBOMFkhTxKzBCrnJeRZMOWvWiuugN+roYjgdbTBxqatcYUsqsKPLd+7YDOzih/b8cQxaLml3DvEzDrpwR48+pseLH73+4PnU3HH/srEGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XrnMDLf8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XrnMDLf8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C07B1F000FF;
	Thu, 24 Sep 2026 11:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790249475;
	bh=jVYt9LR/ACHTnteAIkp0hZOwQS1WbcUcSBVU0GujKBY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=XrnMDLf8OJE502TZlweAxdFx62gYRVSGqBSGVIE9Nf9Y23ZoDf/P4T0A5BIgUfMLK
	 pTxoQatjJ9GUt9atOei9veHUj2gbIDrGYRXft3IKx3hm3VG2sZr625Bd/S1PVbGm41
	 Gw4gX/rO4Pc1fwuYP7dlGfbMy+eGfx6brqBS/burmLyYEJOq+RziXxnDxndYX63CpO
	 cTJA7kaDFO0Tfo3/W5hBxM6bfCOf5GxapRoVmLw9Of50ouYWrZle5qVZkPkPIEcpLy
	 BQmllia7qrppnv8F1JOB/fX/hnbvE9feJOXp9zJLZI/3p7bGDqC1wcT5klUvEbuC/P
	 ziNGHlK5MY2XA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 8159839EB07A;
	Thu, 24 Sep 2026 11:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] rds: ib: Clear the sg list when mapping an MR
 fails
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179024940440.1493433.560852484613339728.git-patchwork-notify@kernel.org>
Date: Thu, 24 Sep 2026 11:30:04 +0000
References: <20260922031546.3874605-1-cccccccccccc777777@gmail.com>
In-Reply-To: <20260922031546.3874605-1-cccccccccccc777777@gmail.com>
To: Dongliang Qin <cccccccccccc777777@gmail.com>
Cc: netdev@vger.kernel.org, achender@kernel.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 22 Sep 2026 11:15:45 +0800 you wrote:
> rds_ib_map_frmr() stores the caller's scatterlist in the MR before DMA
> mapping and registration can fail. On failure, __rds_rdma_map() unpins
> the pages and frees the scatterlist, but rds_ib_free_frmr() can still
> return the MR to the pool with the stale pointer set.
> 
> This leaves the pool with a dangling scatterlist and can lead to local
> privilege escalation. KASAN detects the resulting use-after-free when the
> MR is later torn down:
> 
> [...]

Here is the summary with links:
  - [net,v2] rds: ib: Clear the sg list when mapping an MR fails
    https://git.kernel.org/netdev/net/c/58eb1b3325ed

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


