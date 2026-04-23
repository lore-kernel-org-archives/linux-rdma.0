Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27FE2BE053;
	Thu, 23 Apr 2026 19:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776972645; cv=none; b=UonZSmPQm2EnOwE6ir2I6YrTArW0sI6JRbkNEcSl3pTEEK84iqZMFHfvVQEHt8fMjQiH28DR7bt7nWQrVhT4GeyvQvMfiRjhI21f3ZQL+9D+kPPfVITZa+7i/sXKyKT4+a/CQGHlsgdbagcUxGowK/DGnn6EYZ2WJgfZbh2mSeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776972645; c=relaxed/simple;
	bh=wEEzDSvGh4RC49EaRHrMFFS5Pokda4U2Hdmfqzgnm3g=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=LwbrKrXMFN4OABt43XTBaoBK1UzVoJjc1OYvQeK1iYBW4a21M05E/3s23hG8DdjBBQjs6FJTlDd0OobewVeZwUzmYM7u1khrh5gMY25ws4VO/NRpsvhmY1cJcTbRArWv3+iQ8jEMrRHgWJZ9x8/QJRJMYx6eBdsSzr7lv62GCj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GaScGOxD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GaScGOxD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DA6C2BCAF;
	Thu, 23 Apr 2026 19:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776972644;
	bh=wEEzDSvGh4RC49EaRHrMFFS5Pokda4U2Hdmfqzgnm3g=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=GaScGOxD4HxDBUWJQEMe7sp8xVySbuIO6c2vJEHrUPhWFFdc37IdcarFOQQg/10wI
	 QZ0E55Ejq4ceZ8isrBDv+K5evNevtJObOY0Fk+/2yPMYDTdFk3i1DFWfgCWdLyr/kc
	 TEz/Tmx9f65PNtEvVBjdCNgjH5OObRS8dOTLUnAS+o6n1K0b1K5pqfcqEGR8wWiPUT
	 nAfX4Gx+trl044rPzE0shazF1Jaz+nO3519KU9i1UrAkjS5lIShLNbLpk6MnN6svvN
	 7SM0mEZZHLjVEuCyeXIcGw0im/UnswsmmU4YQINQKljlTPi9KLKZLJMRQ5xoFzRxHI
	 ZdCSVphC7OdpA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FC483809A90;
	Thu, 23 Apr 2026 19:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] net: rds: fix MR cleanup on copy error
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177697260580.733594.2705597671788388088.git-patchwork-notify@kernel.org>
Date: Thu, 23 Apr 2026 19:30:05 +0000
References: 
 <79c8ef73ec8e5844d71038983940cc2943099baf.1776764247.git.draw51280@163.com>
In-Reply-To: 
 <79c8ef73ec8e5844d71038983940cc2943099baf.1776764247.git.draw51280@163.com>
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 rds-devel@oss.oracle.com, achender@kernel.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 leon@kernel.org, santosh.shilimkar@oracle.com, jhubbard@nvidia.com,
 yuantan098@gmail.com, yifanwucs@gmail.com, tomapufckgml@gmail.com,
 bird@lzu.edu.cn, draw51280@163.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 22 Apr 2026 22:52:07 +0800 you wrote:
> From: Ao Zhou <draw51280@163.com>
> 
> __rds_rdma_map() hands sg/pages ownership to the transport after
> get_mr() succeeds. If copying the generated cookie back to user space
> fails after that point, the error path must not free those resources
> again before dropping the MR reference.
> 
> [...]

Here is the summary with links:
  - [net,1/1] net: rds: fix MR cleanup on copy error
    https://git.kernel.org/netdev/net/c/8141a2dc7008

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


