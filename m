Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED951A6831;
	Fri,  1 May 2026 00:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777596059; cv=none; b=quycAsEk8KbntXJeeBaCWRU4QRADrFmLGOcUlZgL37TDdi4CQDuYwS7xe1DykbYZbLhXu3X3n/Lk4iPo4/xKuNzebGTTxZQ9e5CKvQN5uZE5LOH+kJTMufJ7E8GS/HZ9+xMsbYtvsEIqFKF3FsoADV9gWOdhcHrK1Sd1H/twnDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777596059; c=relaxed/simple;
	bh=PtLrFph3lbPc8YZ5Wtnug2wfYQTeFOm+zgR85PMU9o8=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Qy5gNkr7nC54sibSYEsjz3vwKIq/QmXIJwND0QdhP2OQEyILPzc1+nEcc0ruDVkT6emUZKGv9Wi+52DdZr4rZCDLIWVSLTDe2K99kIvz7xYDcbNyIzCUu7a+QPh7PiKnHJgjwdjobxMg1E4H7tnmqcvhIYI0KQUA4Scyoe0e5p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HHV/X1fL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HHV/X1fL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96054C2BCB3;
	Fri,  1 May 2026 00:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777596058;
	bh=PtLrFph3lbPc8YZ5Wtnug2wfYQTeFOm+zgR85PMU9o8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=HHV/X1fL7ldck/K9s6hXOe92t/h8W0JZ5mNaSTTGebMlhVCCgi+/cPQ7LGU57gmt0
	 Y6HR1EAkGrNT/DDBgeUI2bwkDKHZMbqFYmLJjfV3DaWaXwKtPb4j0BirU2TSubxhND
	 mznGy+8x6+fsCRIXt9EGLXTxj4f5okvfLhBHCez1WaPFZ3I5oN41ZW0BTEs/w9Uup+
	 q5oBqXjH54Nj3zmx5kBACPxazYV+BIrviec4Rj7w7NWGJQDW7wsTZ54/qJPfVUEB2u
	 jgzb/pRBPZM04vrRxtSdwuo/44u/+UGtjEt5OLLIn0NL74ahCi+8F+r3lHIbpLS+Ww
	 GTxM03khH/5/A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02BFD380CEC4;
	Fri,  1 May 2026 00:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] net/smc: cap allocation order for SMC-R
 physically contiguous buffers
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177759601254.3265014.6576952498122987091.git-patchwork-notify@kernel.org>
Date: Fri, 01 May 2026 00:40:12 +0000
References: <20260429021637.21815-1-alibuda@linux.alibaba.com>
In-Reply-To: <20260429021637.21815-1-alibuda@linux.alibaba.com>
To: D. Wythe <alibuda@linux.alibaba.com>
Cc: davem@davemloft.net, dust.li@linux.alibaba.com, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, sidraya@linux.ibm.com,
 wenjia@linux.ibm.com, mjambigi@linux.ibm.com, horms@kernel.org,
 tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-s390@vger.kernel.org, netdev@vger.kernel.org,
 oliver.yang@linux.alibaba.com, pasic@linux.ibm.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 29 Apr 2026 10:16:37 +0800 you wrote:
> The alloc_pages() cannot satisfy requests exceeding MAX_PAGE_ORDER,
> and attempting such allocations will lead to guaranteed failures
> and potential kernel warnings.
> 
> For SMCR_PHYS_CONT_BUFS, cap the allocation order to MAX_PAGE_ORDER.
> This ensures the attempts to allocate the largest possible physically
> contiguous chunk succeed, instead of failing with an invalid order.
> This also avoids redundant "try-fail-degrade" cycles in
> __smc_buf_create().
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net/smc: cap allocation order for SMC-R physically contiguous buffers
    https://git.kernel.org/netdev/net-next/c/4cc5130ee84a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


