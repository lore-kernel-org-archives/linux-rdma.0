Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795575010;
	b=p0JwYCu9FaMdbp+zCpZ9jcTlHo5UGKGrc1KUFc8XSl0+sUb3hJGhJUIh2G/0Dpz0TkY5
	 tzVaKmbgzga1vvKodhv4nRiNihFGFQyoJdq6vFmaK3D1UljrQK+LG8m0sqXmfj66njeHV
	 6Wv1AHVy292vRbqb/AaRZM2F+FD8K9flrKm6lzYy4mJg0j5qJUNHLOWB9zZ8P6p8vu3oO
	 oZY4D9EQ3nZdVsC4m8q4HaNYomuS4be+YUbPe7FLo0vTRkJRMwWJqYGIqjS2tuONzWSVf
	 N1XWzzwfh9g8WHgPCB/r3qpM/8k2S0fMk7BGjdUTxx9zEJSke0BELxlmzF3tVftJH+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795575010;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=JHvutqVI3UTf5KPiqly4KEao0n0pd5IR5xQU3YvP3BY=;
	b=14KEYAQNLER4G2Y34zOvcZBTYg9rYgVaHSBXIPf6h57dB9Mtj6Q5APeCO4Ze72ExWVUg
	 qM/OkzY5bWagQsJIIBLK0+pfsc6Z2FtskDjXwP1ri/E1yXAbyXkUvOSYcnvsNNvSmQ7Av
	 iYWCAZVVGuT039H9qmGk5hKgok+bjglG+/6AeLlCPu88EBoVRuOsBqivAjoCQ8au40mxE
	 krNC+wzYC33whwIA8eb071G9kMtGGqlQ2zlELVLQBG6viPHcSrWs9rMCmT/+v/vtPJgCX
	 UeSYNqP+mzjRcihS2q54mi0nKAkCStGlxq9rCjeRta77bOuWlR4EV4BHNQz7ECnPUNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ndolS7q4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7578D606A321;
	Wed, 25 Nov 2026 02:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ndolS7q4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0844C1F000D0;
	Wed, 25 Nov 2026 02:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795575010;
	bh=JHvutqVI3UTf5KPiqly4KEao0n0pd5IR5xQU3YvP3BY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=ndolS7q4vKe6lQ3Qkr5cmwT4nBehUaxCv26jyr4sEe/BFBS+hYnoaF4WW8uli5bfb
	 YfpdVX0CLRkAYPe9nUTUgkuXR3XloMxT6Y7fOa6VXWMtih4pxC0kmYQTTLIMBBzGZz
	 X5zYHLP2MqDugyRx6lB1VkQeC/z5mC10bGSM5Qw6TU0YKg5dj/W86gKiFOMWSAuFYm
	 PAQJIfDyGrdXUjNta8ABATyX8OAJP2JNBiIrVSa0HJlLe3zp8rZbV5A3uq8k3OJjwA
	 clUnNOot1YGnJz9M/jF1fE+dr5tVXMQPL1ZZWNjHW+tFPoJkVqmeK6JsWjIKgXRH30
	 Dk16iOSkxMLHA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F14D43808209;
	Wed, 25 Nov 2026 02:50:09 +0000 (UTC)
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
Subject: Re: [PATCH net-next v3 0/3] ionic: make the device command timeout
 configurable
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179557500851.181897.10642489657303885354.git-patchwork-notify@kernel.org>
Date: Wed, 25 Nov 2026 02:50:08 +0000
References: <20261119-b4-ionic-cmd-timeout-v3-0-2cdb8fca15fd@amd.com>
In-Reply-To: <20261119-b4-ionic-cmd-timeout-v3-0-2cdb8fca15fd@amd.com>
To: Nikhil P. Rao <nikhil.rao@amd.com>
Cc: brett.creeley@amd.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 abhijit.gangurde@amd.com, allen.hubbe@amd.com, jgg@ziepe.ca, leon@kernel.org,
 jiri@resnulli.us, horms@kernel.org, corbet@lwn.net,
 skhan@linuxfoundation.org, rdunlap@infradead.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-doc@vger.kernel.org, eric.joyner@amd.com, ArunKumar.Prakash@amd.com

Hello:

This series was applied to netdev/net-next.git (main)
by Willem de Bruijn <willemb@google.com>:

On Thu, 19 Nov 2026 00:32:30 +0000 you wrote:
> ionic waits a fixed 5 seconds for device and admin queue commands, and
> the RDMA driver gives its admin queue 2 seconds. Some commands can take
> the firmware longer than that, for example while a PFC configuration
> change flaps the links. The firmware is alive but slow, yet the
> timed-out command and everything queued behind it fail, and an RDMA
> admin queue timeout resets the RDMA LIF so that later verbs fail with
> -ENODEV.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/3] ionic: make the command timeout per device
    https://git.kernel.org/netdev/net-next/c/243b74542587
  - [net-next,v3,2/3] RDMA/ionic: Use the ionic command timeout for the admin queue
    https://git.kernel.org/netdev/net-next/c/54b7ae13fea9
  - [net-next,v3,3/3] ionic: add devlink param for command timeout
    https://git.kernel.org/netdev/net-next/c/1ea3c5d90fa5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


