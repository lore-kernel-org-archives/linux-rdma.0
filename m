Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFFBD311967;
	Thu, 23 Jul 2026 17:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784829050; cv=none; b=iShgIan9ygiQUP/qIKYLJuR1DAMUp5JVSOEMWHv7MJwIZAFEJq3rlZ44Ne31E3tzCgwf+VUunFX2zvI7sKzoWeFoLGvpLYnJZSwVXZPWuVhHR9GXUotPz5RTE3mazM+MTn/usIf47urcBWVc5XLS8YkA4k+r5RPgY5mDb2bEZ7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784829050; c=relaxed/simple;
	bh=UpXunTny8q0d+EBxnlGdpa6pw0AVIGMzh2A37PFI2J0=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=ZXNYMcXJHEKGBEYL4bM3ddcMFQPW9u3AqBs8CiDpEItCvMaSmEMfIdViUq2PGGn/oov2hdMzBTv5odIlHxOD6XGzCF/p0Objob3ch1Y0f6dUJS5LnA1AjFtp4TxCCK+djoRFEUuzuQmT3EC9nfw3e7xZGnuUvF5A6pvWt/cytDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XkPqWbZ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XkPqWbZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C23F31F000E9;
	Thu, 23 Jul 2026 17:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784829047;
	bh=B+PqI29zSq149CkgteSgqs454iSy2RBnFhlJenHlt50=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=XkPqWbZ4KS2RpSbrn9WUl77D8MKR7MiCE0ay49yIJmx98p9saWbSzcBroPDAEo4qv
	 pNl2TmrSbS4aS+mJ9XbTvedZwo7f3ZsJg7zAuLfQHVWWm2J2QB318rUkyOhPcQS9if
	 ZhihgBGH0yp4HnE239dI6JMyzouSaJF7oh2Cbme7qnfey1ePXORxYOCLxbDFd5p2l8
	 f+gnP+ZEWs/Ls/9pXzKWq4dwta16N2+j33tP3lhwrtlDN5RXyldzatJp9iTjUx4pzY
	 lDVHZW3fuxlhlPuVC74WTm0GcSnHn1BDRQa6E4H9rCRAL1z0PX8yeNAeaAiq0MZGdl
	 eUvKIRa8mhUtA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D095D39244D2;
	Thu, 23 Jul 2026 17:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [pull-request] mlx5-next updates 2026-07-22
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178482900740.2806151.11446295939552946394.git-patchwork-notify@kernel.org>
Date: Thu, 23 Jul 2026 17:50:07 +0000
References: <20260722071030.1693021-1-tariqt@nvidia.com>
In-Reply-To: <20260722071030.1693021-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, leon@kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, saeedm@nvidia.com,
 alazar@nvidia.com, valex@nvidia.com, cratiu@nvidia.com, dtatulea@nvidia.com,
 feliu@nvidia.com, kees@kernel.org, linux-kernel@vger.kernel.org,
 parav@nvidia.com, shayd@nvidia.com, horms@kernel.org, kliteyn@nvidia.com

Hello:

This pull request was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 22 Jul 2026 10:10:30 +0300 you wrote:
> Hi,
> 
> The following pull-request contains common mlx5 updates
> for your *net-next* tree.
> Please pull and let me know of any problem.
> 
> Regards,
> Tariq
> 
> [...]

Here is the summary with links:
  - [pull-request] mlx5-next updates 2026-07-22
    https://git.kernel.org/netdev/net-next/c/1324135c4167

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


