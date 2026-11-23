Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442406;
	b=yLPNjY/vwtQYM4elKptHSLt2eGVjMoTDOO/IktyKnTQ6ftK+1cey5sI2el1loAtdOQz+
	 ND6SsP8pH7zeyvDLwnvZc48V9DcRrJ2ACp7qGCm/SGAcBKoINuqHPHlgLVZSAX1oHlQM0
	 izWKxl/wPbfj4xX+t4wchPKVsnBU+2BECb1BsSGuA2hxhatLdKST0dJ9pOiukb07ReGym
	 QtTRYeIld+1zIyeZQLdLMzx74EgO9ZOhYvngpGfuY3hmSBKRmhDNzY3Fu68aCLYE+HzY5
	 6za6mwgV+U8RtlVi1z67Asj17w3JprKV1vbqkulWuUWRIFBWBJgYUB3OiWjEnusBZlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442406;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=VjoJzAq8xiOMF7dZn6eDDufnCmi9o4SjveZSWHouqDg=;
	b=UdFBBJCTbjWFFZOA5E/Zauk6d1S1jZe2EuHQ1NvNbaHIlA6m4foS5+R3U6J6qoQapNCd
	 1JZ5smW0PVGGQJd+ImxHbVx1g9lfyayyBJMbjZwD9TGYyKBe1VoMmYEUJhRIaw/+rJk3P
	 x1UfonFZDtLyU8GuLFjwz5LwniDusXKfx9IYAVrxrzF3n/MvD/C3O+BTxnNEXEf9e6zwE
	 v1s/Akm9hLwwRxKviiiyJjW9EE4qKiaZN2broHjUayM9wQ4iPJYIIvS+vfMnPL5d7jTTv
	 +b9wjdzYwTgGAhburGPCLnCJFarmDiAE5mzTvqlGpGsG4ZYPHqzhO5Z/OI6Oy0nscmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZDqyxe92;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F43606A337;
	Mon, 23 Nov 2026 14:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZDqyxe92
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6681F00A00;
	Mon, 23 Nov 2026 14:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795442406;
	bh=VjoJzAq8xiOMF7dZn6eDDufnCmi9o4SjveZSWHouqDg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=ZDqyxe92ybY4QAk2aV2iBoUN4mM6tstj1zu+6J3/S6pJ2wFQV+dnW8znkuegFs2Z+
	 bennJ1wU6xppI2MeJLy+vHwCA42Ghs1W/RzHLjnC9BVFN3wYqL6osY434AkEX/rwu/
	 GNoDqS7RSreYhMFoIsJKiSWKez9qTaIth8PjlLJIPKYo80PIAiFqzpKDIKbhoHaDlL
	 ROg/06OLrYcPuku/H0CvYjiIsbwp2szsaZDQ/NLks+Ke2Spn0jxmGmUEgfiaWfwJuC
	 80yfAp53xiYVd8rYPuHEgedDkuIK9l6RgdE8o/U+L9qIRsyxECHKxxRZZKLK+yukT1
	 vqiHvH+nBDJNQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F1592392EDAE;
	Mon, 23 Nov 2026 14:00:05 +0000 (UTC)
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
Subject: Re: [PATCH net] net/mlx5e: TC,
 fix a NULL pointer write in the peer flow error path
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179544240455.2408834.998439660061134441.git-patchwork-notify@kernel.org>
Date: Mon, 23 Nov 2026 14:00:04 +0000
References: <20261118025708.86215-1-enderaoelyther@gmail.com>
In-Reply-To: <20261118025708.86215-1-enderaoelyther@gmail.com>
To: Zhao Li <enderaoelyther@gmail.com>
Cc: saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, moshe@nvidia.com, shayd@nvidia.com,
 agoldberger@nvidia.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 18 Nov 2026 10:57:08 +0800 you wrote:
> The peer flow add path hands the duplicated flow over to the origin
> flow before it looks up the peer entry for the peer vhca_id. When
> that entry is missing, the function returns -ENODEV, and the caller
> then deletes the duplicated flow with list_del() on its peer node, a
> list head that was never initialised and never linked. list_del() on
> such a node writes through the NULL page.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5e: TC, fix a NULL pointer write in the peer flow error path
    https://git.kernel.org/netdev/net/c/7b0c5f0c757c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


