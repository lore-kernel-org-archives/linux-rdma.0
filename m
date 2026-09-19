Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52AD379C46;
	Sat, 19 Sep 2026 01:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789779691; cv=none; b=MhVkcD5ISGxlh+nQ25m325d13B1qpyYvqYzJX+sQRWVjlyu8ePhUuiPGUdPJJZb2FKXmyYTCbbJ0IZOrQ8L0HOqoTqpFRGheQizblZRBjS25gDe5G5qCoqhH/3zFcGWfqYtTRqjRIEjZeXXuqMKPed1Xt8ChcCLdy6TRXRYiiZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789779691; c=relaxed/simple;
	bh=tB58EVgfy0/5KYj84zuUO88RYwQ509SqkS1ppN0TSJ8=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=GQrEh5Owv3wxldcvYRRpL7l8c/0K4++WVkHePVR+UYXYacIJer1X99lLLJZkZk3Fz6kz0ziGEB2v3N3HbL88I1AO/LkbKZgVSBO2G6i2mOhUnzZzJYCg/ZPJW86lA57N2NhBdzpYc0iBaPDdphHH2ZuKCR5EYNzYYLk6yUZzgeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K3X1cgsn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K3X1cgsn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA30A1F00898;
	Sat, 19 Sep 2026 01:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789779676;
	bh=qK7mrY3OuW5ru9HkHZRVxNwKLylrgUS+oQ1Mt6LVVg0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=K3X1cgsnnf0eIdaMpZCsAvjsvMxjlyYA42fLQz9Dx71qi8MT9Vp7WiuEsA8M+nnPj
	 IxPG8GN7eJxjzJ8GnFeJGUoyCSqW7Pa88MJSPrNxvIJj3NMGjCdSzGdCGAeoVls/vJ
	 c2NEBlRHeZIzzOfbQSo4fcicCRCuBPzzfiWm6aROomWlTPnqm9lXTLiMm5/sRxjjjv
	 qOTqDGGZakqwTnoUm97hyP5Pv+VwJq9fMvca2esYpbx+V8JWgy0kLCi6uasFxcX15O
	 GBa8R0P5HzEiRS/tfCAVsAxwxDxWPkMVcDtEkuI33Td3GSnPzZzDuZQFNSk51W907t
	 7QwmMTUPkqwsQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 198493811978;
	Sat, 19 Sep 2026 01:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] net/mlx5: more HWS misc enhancements
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178977960889.1214202.9969611467837827041.git-patchwork-notify@kernel.org>
Date: Sat, 19 Sep 2026 01:00:08 +0000
References: <20260915111912.3926585-1-tariqt@nvidia.com>
In-Reply-To: <20260915111912.3926585-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 erezsh@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 saeedm@nvidia.com, kliteyn@nvidia.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 15 Sep 2026 14:19:06 +0300 you wrote:
> Hi,
> 
> This series by Yevgeny brings more misc improvements to the mlx5 HWS
> driver.
> 
> Regards,
> Tariq
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] net/mlx5: HWS, Return meaningful error code in hws_send_wqe_fw
    https://git.kernel.org/netdev/net-next/c/0ca19b9fdcb0
  - [net-next,2/6] net/mlx5: HWS, Fix error message in mlx5hws_cmd_generate_wqe
    https://git.kernel.org/netdev/net-next/c/59da9e5163e9
  - [net-next,3/6] net/mlx5: HWS, Replace kzalloc with kzalloc_obj
    https://git.kernel.org/netdev/net-next/c/23aacde37804
  - [net-next,4/6] net/mlx5: HWS, Add timeout mechanism to draining send queues
    https://git.kernel.org/netdev/net-next/c/7bf7c4367db6
  - [net-next,5/6] net/mlx5: HWS, Handle timeout draining the send queue for FW STEs
    https://git.kernel.org/netdev/net-next/c/03d41926d03a
  - [net-next,6/6] net/mlx5: HWS, Remove unneeded WRITE_ONCE in post send
    https://git.kernel.org/netdev/net-next/c/889f1d8c0eb2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


