Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619434;
	b=DY1m79a4+oOPD5HkIgk53w5BKdfVAainLUf1ezUzK7NDWtR2U9LjZFJR1sxNyCKIUa/x
	 sWBjA7n+/l9/uq3klX6T1nJkMcAKZ/Kw1EIJ76AQ7N2jJdvWXv2JUIUpix+ziQaCwYEXH
	 XOFu3TRaza6W9TtVfv50Om5E3wbLZn45HKYLaeMCYla6X+qiG21vggcmFSGdS42vKaz0T
	 Uaat/6Ntg0dc76hbaHczn62PWGw1xFyVDLfQ62aZ1ME1TqrKzx/kP+uZTU70HIX1cj7cJ
	 Qee08/Ujpl1/8OY7nPGOsWC2bJ3aulLVcZ5s9jP/CjQ1yTncy2r8v794iydheUA7qLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619434;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=ZbE6/xbsj/Ta26P/SdRAHznnPHVS39Jy37MF9dpc3/M=;
	b=wBZW4q3uM9TYXkEKuoZNJHMx+wv9BLdRfwg0OHc4VJB4uOHd3t/EAjrX76v7fmgh2HA1
	 eK/9b0duTzLql3jtiacWvzcWuddRIlb8byQO0BC8cLea/ETaamA7BnC/315AZlEW2ptWp
	 6XM4Wk03+aZIlbiptaVbgJDMr8Yg/XS7sYvllmbRZaJRzTIDOEogmwJhdP1EELPjGLj93
	 1hvIgcQ/QCfDLgc8R5omRg/e9ky1In7AVuXXLaausVkdY6B6Amt+N5W5mJL3Dnf72DHJr
	 tWwzt2N6PUBEZYCp2t0EBMxYaqM4UThzKABw2sUP1MMKOUvBia7d9JlQzgb89FIldpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CxNebb0+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463AD606A33E;
	Wed, 25 Nov 2026 15:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CxNebb0+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082571F000C6;
	Wed, 25 Nov 2026 15:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795619434;
	bh=ZbE6/xbsj/Ta26P/SdRAHznnPHVS39Jy37MF9dpc3/M=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=CxNebb0+yh4Xtop77pwqnBTWUjjLCNFoVtu0uHyV4zO28wXBHM1mzEvodXQVb+N8C
	 elo5J02lrMUHdl9JHXyi9ewU1dNsM9wIeaIY0EF6CqHVV1IexlT0Su/w0dSM1taCJH
	 0fJllGNytqOmRPVBm6xr45UkNPfiXCU/Q5bq0CAo3UE+kz8vp8tXUxMSbRegjRUdqd
	 3mOGM/NGI+9hw4xPM8Wbp9kh9IIiOJw5JroGX/eWAPkCPX9JTRVIY9nMCByL69thmb
	 CJgAq7HNZFl+pkSeevBtT6cDZ2M2BPkiuFKoAjig6foHvIRZ9DGNnEZq6uHsNSoYaD
	 J0mvXN7z54+2g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F15183808209;
	Wed, 25 Nov 2026 15:10:33 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net/mlx5: Declare no DMA segment boundary
 restriction
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179561943251.592665.7058769841730060658.git-patchwork-notify@kernel.org>
Date: Wed, 25 Nov 2026 15:10:32 +0000
References: <20261120081819.2538191-1-tariqt@nvidia.com>
In-Reply-To: <20261120081819.2538191-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, gal@nvidia.com,
 leon@kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 moshe@nvidia.com, saeedm@nvidia.com, yishaih@nvidia.com

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 20 Nov 2026 10:18:17 +0200 you wrote:
> Hi,
> 
> This series by Yishai declares that the mlx5 devices have no DMA segment
> boundary restriction.
> 
> Regards,
> Tariq
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net/mlx5: Declare no DMA segment boundary restriction
    https://git.kernel.org/netdev/net-next/c/0ef669aa10e6
  - [net-next,2/2] net/mlx5: Declare no DMA segment boundary for data direct device
    https://git.kernel.org/netdev/net-next/c/7e25d974eb36

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


