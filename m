Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795516806;
	b=Oh6I2atOzrV0eAxbyjf1iSaSJ/k8y1zTdbd2ERkSz8ORe2/X3KUApcmzvi04uEosYGA0
	 wKuSljgmJBZzHHVgRGifY7gusl+vSVou6agh34Wkvyom+hvJUVmvTfGWt0QGoml60srm3
	 E5e5or+vWDDgkghYa+aNlnW0lr7J9YnfaHSJ1h+n3C0KUfycH6p5sbWxSkXdhWLXZj+38
	 J61RkOv6ZhWB324dKICquL5LJWFJyLmPCE3XqiaBie4GOQbEPeEeavU6JNtkSQLwalHcP
	 3a+vcMErAxihwqgdReJvZGhqGsSIO6osEoIkNseMII9wWu90vChhkbagokTLgxHnmoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795516806;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=Ui1+smOVr+pnd5DDWGdUYL7ORY5N9ji8vtX7s+lkRuE=;
	b=cCikwFQdKdcHOe5JaYYN4j1NZTdb8jst7PUIJKV6eBf5vSbiGDU2tER0o+YK4FT6mFTl
	 k4bDl6iuLE2gQHUIeMZa2AmMUicLAouW2JGkSIUNtrKULLr729GZAPfxTrSckUq84yAwy
	 fuBSSAip21rDxESnWhaLpuJ4JYKpKZAuqi7tUQ+IK2D5W19J2CUW/NAA4FVs9v9zMrz+V
	 VxflOr1FaxtDvkGlCZG1nLoCRtXnkAoCn1J2xSdOTCndVXmkp8Nr6kftnlpWbDXlBsmi5
	 7ZII70OtQlwBOg8TrXZj7J6LUNi7Dq0joJ3I2spz4fmU0QnDweEPcypOKs0hj/YAMdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VUsLbtOA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEE3606A321;
	Tue, 24 Nov 2026 10:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VUsLbtOA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44CE21F000D2;
	Tue, 24 Nov 2026 10:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795516806;
	bh=Ui1+smOVr+pnd5DDWGdUYL7ORY5N9ji8vtX7s+lkRuE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=VUsLbtOAo5L0GkntsFUj6GS4fZC3U2mGzZyAFwTqMz25f9tXJzzaUulxCQ+wXJoHS
	 vidI7noBHL6CDe9j4n0Fjtzjsny/S5/CHDkTn/2yCqEdOBodCZrvtkSNWJEP/OpYcV
	 HQy2KmoFDiG2dDz6k1/Cf+1r9ChNFxXApcd1c5r3t5Q0g+ho+ok44K0BE6oplnpI84
	 khWNvwkBS54QO6id0ioPARmT7udipRZS2RSQB1pRzHWdEuUw7qBNM/JP2mO/LzaIWv
	 iigeOYIN00lW3CJ8k1Y4MEcvElsk0WZS/G7DO0ThmBDKLudKYigjb/Jd1B5dfxHfx7
	 VT4HVoy0F4jGA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A3333931043;
	Tue, 24 Nov 2026 10:40:06 +0000 (UTC)
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
Subject: Re: [pull-request] mlx5-next updates 2026-11-19
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179551680478.3438433.6644453172863737002.git-patchwork-notify@kernel.org>
Date: Tue, 24 Nov 2026 10:40:04 +0000
References: <20261119121123.2211400-1-tariqt@nvidia.com>
In-Reply-To: <20261119121123.2211400-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, cmi@nvidia.com,
 edwards@nvidia.com, gal@nvidia.com, jgg@ziepe.ca, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, markb@mellanox.com,
 mbloch@nvidia.com, michaelgur@nvidia.com, moshe@nvidia.com, parav@nvidia.com,
 phaddad@nvidia.com, saeedm@nvidia.com, shayd@nvidia.com, yishaih@mellanox.com

Hello:

This pull request was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Thu, 19 Nov 2026 14:11:23 +0200 you wrote:
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
  - [pull-request] mlx5-next updates 2026-11-19
    https://git.kernel.org/netdev/net-next/c/2c411cf17a4a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


