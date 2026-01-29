Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68501288C96;
	Thu, 29 Jan 2026 04:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769659818; cv=none; b=t7TUT/HEWPcn54mHlo44MSoge06T4vIjEIIJoQnmGrqk3YtaGMIDxzeo+YPPq52bbg3IuTbgeCe2ztXAFrp1rqdhpyWU0NXpqPAQ4FVbY5GEPqIMbRYCFrj8HTB9tC8NRr2+rMdbdpmdxWZ2eih6a6Wgs7o8fClu1cyXA+W8p0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769659818; c=relaxed/simple;
	bh=Z9XhaWwhC+dTsFmBP9WqQXbPwaY04N6Wz94IjIvW2ZE=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Q9WBKZR2vsRdM3TVqe1AXMa673Ys+CdObMKy5Zg2oHs67TWf9HQSM8qqLHfPKjXyQd+aybd1yZY+AwQCHdr/WxlDLXjvz5O882mykIzX6Mtku/q5gDBao6TC0FSkdQclF7SSu5UwzQGPHWsgVb4yPcsrFphyZIhLicIbvItgZ2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cwhFAiyf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cwhFAiyf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20228C116D0;
	Thu, 29 Jan 2026 04:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769659818;
	bh=Z9XhaWwhC+dTsFmBP9WqQXbPwaY04N6Wz94IjIvW2ZE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=cwhFAiyf9hazZGfonbK924QOzzJgCkNsi9SQJiqBBT2WUu4ikwfp7AmTQl0hAyVGv
	 sNSsrbCWXWhHJ7LOus7rJis05kBKf/YWGWV5QBdqAib54p5aZ28qMOmiHb0DXhv75k
	 AL8Mfqw2dj7YJycRbkPG2dgtWSHwuSPRbNx7/aloO6RsuF06RRgCzJsqnRb27vNFl3
	 HgZZDOMkVxNiDyZvcwYzKpjS/WtsZUI8NfVxJedunRY4DHtVw7/AISOl0ulKsnIlqk
	 5E9X088FCyx9BqKiiXH3ad8WL9z5V+W7z5EW59z27pXwYPTctssMZkI384Sb788hTY
	 M/7tgdkv0r34A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 8BCC1380AA61;
	Thu, 29 Jan 2026 04:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net/mlx5e: don't assume psp tx skbs are ipv6 csum
 handling
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <176965981134.2343973.3337681948486173683.git-patchwork-notify@kernel.org>
Date: Thu, 29 Jan 2026 04:10:11 +0000
References: <20260126-dzahka-fix-tx-csum-partial-v2-1-0a905590ea5f@gmail.com>
In-Reply-To: <20260126-dzahka-fix-tx-csum-partial-v2-1-0a905590ea5f@gmail.com>
To: Daniel Zahka <daniel.zahka@gmail.com>
Cc: borisp@nvidia.com, saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
 mbloch@nvidia.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 rrameshbabu@nvidia.com, raeds@nvidia.com, cratiu@nvidia.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 26 Jan 2026 11:38:17 -0800 you wrote:
> mlx5e_psp_handle_tx_skb() assumes skbs are ipv6 when doing a partial
> TCP checksum with tso. Make correctly mlx5e_psp_handle_tx_skb() handle
> ipv4 packets.
> 
> Fixes: e5a1861a298e ("net/mlx5e: Implement PSP Tx data path")
> Signed-off-by: Daniel Zahka <daniel.zahka@gmail.com>
> 
> [...]

Here is the summary with links:
  - [v2] net/mlx5e: don't assume psp tx skbs are ipv6 csum handling
    https://git.kernel.org/netdev/net/c/a62f7d62d2b1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


