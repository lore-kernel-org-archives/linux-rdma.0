Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE8B34BA44;
	Sat, 27 Sep 2025 16:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758989411; cv=none; b=VfKQyvSLOzKB6gCjVT59RZcnMAquL5o+ie8K7Ptf3+3xM6KhW1w3QmdCecWulMxjdFzuv/xJQ1xo5uZyEcWqIln6qrcNzst9ZpU7X2YqQLYe9QanQW08wGwWjEZpH2GcnSLufcWgfhb4x8VB6GFeM8pnIQEdlFdhD4xQ0igZtTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758989411; c=relaxed/simple;
	bh=ev5YaEcdNDd8xgqhscRl3g/y7q6SQvbWPEW8fef/qDQ=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=CAJilGXfVTDsN7QozW0Hcg1azdrp9wtIPUyv7izb8nnipx7uYvhAMJBYwVm6y/obMPW1y+1PwPKBpVhY39fTb5MRby++06UGMgZmPe6R0jHiHdb/ckC/RH7fx/X8Z61Tu73PtFLtBUcAmTQJLKt2UwNf5+n7JHxpIMmWSi9JSxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dghNZxes; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dghNZxes"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C9FFC4CEE7;
	Sat, 27 Sep 2025 16:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758989411;
	bh=ev5YaEcdNDd8xgqhscRl3g/y7q6SQvbWPEW8fef/qDQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=dghNZxesHnGpCCFrvrVhXj1t0I0eoeanHRs6vL5nI3Ls+jlNhBKcyZBpzBs79RXcX
	 4q597vt+4SenpOt9FgURe5EK1QYGyfCJRRfzs8g+577Sy3t5SETwiugnvKADwRq7XF
	 /BEN7+XrisrMlxZawIgYJDK2yGgXDpEdf7yXLP3+Ddh7BEGHXM9F33nUjiKnrDf3Di
	 5AV8TnOAu8bY5IFfgwOtjUBGH6PhO3w6mk+a0+tWBX9/oZ99JjYW/SVxpc8OTig6NR
	 5KOUX+2WnMLyntHTMyJkK/TUkVLyehN/kzxMQeot+uZMEogvVOOUvNJnX0KLYpTM50
	 IchWPgOT+eRTg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33C6B39D0C3F;
	Sat, 27 Sep 2025 16:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/mlx5: Expose uar access and odp page fault
 counters
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175898940601.282763.5708698499791039235.git-patchwork-notify@kernel.org>
Date: Sat, 27 Sep 2025 16:10:06 +0000
References: <1758797130-829564-1-git-send-email-tariqt@nvidia.com>
In-Reply-To: <1758797130-829564-1-git-send-email-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, jiri@resnulli.us, corbet@lwn.net,
 saeedm@nvidia.com, leon@kernel.org, mbloch@nvidia.com,
 netdev@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, gal@nvidia.com,
 maorg@nvidia.com, moshe@nvidia.com, agoldberger@nvidia.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 25 Sep 2025 13:45:30 +0300 you wrote:
> From: Akiva Goldberger <agoldberger@nvidia.com>
> 
> Add three counters to vnic health reporter:
> bar_uar_access, odp_local_triggered_page_fault, and
> odp_remote_triggered_page_fault.
> 
> - bar_uar_access
>     number of WRITE or READ access operations to the UAR on the PCIe
>     BAR.
> - odp_local_triggered_page_fault
>     number of locally-triggered page-faults due to ODP.
> - odp_remote_triggered_page_fault
>     number of remotly-triggered page-faults due to ODP.
> 
> [...]

Here is the summary with links:
  - [net-next] net/mlx5: Expose uar access and odp page fault counters
    https://git.kernel.org/netdev/net-next/c/e835faaed2f8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


