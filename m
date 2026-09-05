Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41793A6405;
	Sat,  5 Sep 2026 20:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788639073; cv=none; b=HU66787wm00O5W9Smjb9V7tjNkpcwboFDfMj99OiCEnzU1Ip23/RW4ZYoiY/nde0OJ1sDthGruU4tvV3UvmzWoc+UoJoBGunhZ/DRkLdGc4W5TJcbKZM9HsUv/tHWlgnS6Qg1tHIUby7edmTm8taTCb2ygwFKGfqSFIJDqf+eXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788639073; c=relaxed/simple;
	bh=zNmPEWkAWJOwjVFsglsWhZexBMznHyFF0ItatOU1U9E=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=LmB478HYcWW4m/uTyoGvLNEyiX9HRDRq/ALUdoWFN/w7CsTQmqWj+udJkldVs0/uzkzc4fttiH0zpU6lKk63qHGzRPNFyKLWTkQrBHu2drl7cl4VwAq6ZI6jrycAGdeLDxxw0xyD1IuT45Y6hvfEBvezTlVM3f9gSq0vWUSa1Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BXBHrVvb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BXBHrVvb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372741F00A3A;
	Sat,  5 Sep 2026 20:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788639070;
	bh=AXg5dHlSBqWpnMvMJEeYG9/METqMlF1q4f8ALKKac+M=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=BXBHrVvblIvXjgVXs6Flrd5xPhXPxkrgqdf9/9UwN4fv+jXZGv9IlLBYTfLMVbZtx
	 5Cq1JvgOErh40wJhBiaUyEYLkfsuAYiQZAtzTnpOCe/o0WIHYhY7qH+4l6ozI/aC/Z
	 V9HcbU/KfYB1ewtrkNfO26Wo+zsDu61XsLdUMQqUsATJ3gT2HfRgPfGAcywS7NVPLz
	 srKYHTbHRQ6DN+MP8GW81JRYeMWOS+IyENtTFSdWJJhMfR2M3uVDf6yGrSNY/Kg4YV
	 uPNgjN2B0Y6lni2AqTkAnzySua/y6GDujrKAf+JZFu9w3f7UBkG0TXP5mdnai28LXp
	 bLnvLolRo5Ssg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93EF23924FED;
	Sat,  5 Sep 2026 20:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next,
 v3] net/mlx5: Use dma_wmb() for completion queue doorbell updates
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178863901018.1340372.4368763906703641808.git-patchwork-notify@kernel.org>
Date: Sat, 05 Sep 2026 20:10:10 +0000
References: <20260902023429.1717-1-lirongqing@baidu.com>
In-Reply-To: <20260902023429.1717-1-lirongqing@baidu.com>
To: lirongqing <lirongqing@baidu.com>
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
 hawk@kernel.org, john.fastabend@gmail.com, sdf@fomichev.me,
 borisp@nvidia.com, richardcochran@gmail.com, cratiu@nvidia.com,
 dtatulea@nvidia.com, cjubran@nvidia.com, kees@kernel.org,
 agoldberger@nvidia.com, horms@kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 2 Sep 2026 10:34:29 +0800 you wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> dma_*() barriers are specifically for ordering writes to DMA
> coherent memory that is accessible to both the CPU and DMA capable
> devices.
> 
> The dma_wmb() barrier is lighter than wmb() on some architectures
> because it only ensures ordering for DMA writes, not for all writes
> including MMIO accesses.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net/mlx5: Use dma_wmb() for completion queue doorbell updates
    https://git.kernel.org/netdev/net-next/c/31f961de2f90

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


