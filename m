Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794334985;
	b=f3qZ54GbB4hkrPNNhTtgrykZhzsyaUIjL93Sbe91SE2Lm7kFZjHiAt9oxdAKUbZQDBju
	 d0fgqVvl2OrC8u1vwl1MR8lVDo2m3f0kZ1XiOLodxjK4SHxQohvVVFMlfpnw18CTjgnYg
	 2OZMppfwfI8g0Jsuh1SlGykYYfdHuy6JH1cNk0R66PSBqDSZBiiozpkfbq5v7ajvFEUXl
	 mKOQDEMoTIjfc1oD1yIea4k5SIjb4jNJFD14ZVB+PN/qVZJcsmACBgpIsw8/pxPqG9+zH
	 ProUbfEkFDvG/b8qYVr079GTh/CpF6F1qJ+8O/FjAD8PGCX3NsWFLI1+BxglLCYbXkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794334985;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=Lf1UOrn/59SxIWJYDfgHXSK5KpB9ctjHjG/DWAiJt/Q=;
	b=xZfFAQpdjmAioaXaZX55Je2lZKZHcZjvjE+EKLHDe+/GLptiLP2M4D6mK+EM5AsB5xFO
	 f0TFUcL8UL+S+Z0eFWN3lEzfNIeOwGtOSuZBaHJoqM6wjkQt8Sn9xhNlyS424WpHXfWLW
	 pUmE/jVSppJyuNoRpocFuLbEkH8+RtH3PEjzzr1kmZ0/sGIuCDXfq1kbmbDLTBM5p9nC8
	 PygzR4iZAQa+VEeAjTwcXjzFmbx5FlCvzh2U0A4IY+IObJKdeshZW4Tvo5X3+OC4qrLN5
	 JPYjoZ/7DZlYg4qxARQxclaxIgJhhO0RbXeTXuVsUeXSB3u58qGJf6FYjm88K5V/Vbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y8HhYK4z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415DD606A334;
	Tue, 10 Nov 2026 18:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y8HhYK4z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73CA1F0089F;
	Tue, 10 Nov 2026 18:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794334984;
	bh=Lf1UOrn/59SxIWJYDfgHXSK5KpB9ctjHjG/DWAiJt/Q=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=Y8HhYK4zDpEZDWObXQcT3KRsHZMvC+iJg/MpfZXcjo97qebaSWlos5oJDL1r97pDz
	 XuJFS3vlR19fQY/LY1n434lXSsgK5kwwJWDsMDpz5H1p/+Xl6LP1+1TOfSxc7a0z7w
	 XXorq9CX4+QOUQq0lVsvJjjsalPiMg2Ft/q7oLpBwkwCckM7lIARLsAQADmqWGEyEh
	 Yv9MdKIugvILWvdHBkB+lYuT8i3qsoXSqPHOsVSwhEPwxM/9OqNBks+zBwk/DbL8ci
	 d6ws9I5yLHHmTVNqJA9ZTY7G/0zrHrku48s02O+KX+WzhosuY1agNddpixc9nxj0tE
	 RscaQygSLHb3w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 9B16B39D608B;
	Tue, 10 Nov 2026 18:23:04 +0000 (UTC)
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
Subject: Re: [PATCH net v15] net/smc: fix lgr/lnk lifetime vs diag reader race
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179433498318.4118637.3265445978564570852.git-patchwork-notify@kernel.org>
Date: Tue, 10 Nov 2026 18:23:03 +0000
References: <20261102083122.1098393-1-mjambigi@linux.ibm.com>
In-Reply-To: <20261102083122.1098393-1-mjambigi@linux.ibm.com>
To: Mahanta Jambigi <mjambigi@linux.ibm.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, hidayath@linux.ibm.com,
 pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, stable@vger.kernel.org, netdev@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  2 Nov 2026 09:31:22 +0100 you wrote:
> The diag dump walks the socket hash table under a read_lock and
> dereferences conn->lgr and conn->lnk. Several paths expose a window
> where a hashed socket has freed or partially freed conn/lgr/lnk state.
> 
> First, smc_conn_abort() calls smc_conn_free() during early handshake
> aborts while the socket is still hashed in SMC_INIT, synchronously
> freeing the lgr on the smc_lgr_cleanup_early() path without holding the
> hash write_lock. A concurrent diag reader can load a non-NULL conn->lgr
> and dereference it after the kfree. Skip the connection, link group and
> DMB attributes in __smc_diag_dump() for sockets in SMC_INIT or
> SMC_CLOSED or fallen back to TCP, and take diag_mode from an is_smcd
> flag cached at connection creation.
> 
> [...]

Here is the summary with links:
  - [net,v15] net/smc: fix lgr/lnk lifetime vs diag reader race
    https://git.kernel.org/netdev/net/c/d7900fa51642

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


