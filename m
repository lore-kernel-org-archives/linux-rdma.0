Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E742C15B0;
	Thu, 14 May 2026 02:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778725276; cv=none; b=lKum4wVG34JZYDscYKi2IdrbB/GN9rDvHDpIna0sVyJbwXVwynIpZEqfdFjl39zqGwBaX4b0nQUoPsGbGBCbdDID6tVV+RNIlrMrvVSiac/oczvDgM5KjywlgETY0yk6FLEKl9wY4za4VwKw3tG3fN5p8gYJ4pp5lqRWFSIOy94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778725276; c=relaxed/simple;
	bh=kM6VoDC0WliWY/KehZuRYTWjL7DQ4mIfaBdveZxiP6s=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=VvcndTezK2qtLz8EW8JiUI3gn5CL53EhXYBToFSklqSmvpgF3ZL+l/ZbS4kE73KhEY2D4JKoUz03y6J5YiMNoYe6DCzSIr5mIJ0pA++TnH4HonRWdKBSVMAHnRUMoYOv/BCrMcdPUkyjaFkEpBvc2AUGkPKMMsWa02EzC/rZ7BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g9CpHp4u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g9CpHp4u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2A5C19425;
	Thu, 14 May 2026 02:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778725276;
	bh=kM6VoDC0WliWY/KehZuRYTWjL7DQ4mIfaBdveZxiP6s=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=g9CpHp4upC/iyyZ86EvFVx4hiXQBGOTTC73dHN9sgoYqzavJlTWzulAkEbMYqHP5J
	 vgGtXiDDF82QHJ9g7WXTGeQ6RIbFVPZv3VvPBz07MmIaLo5IEBq5WHRIlavAob43zN
	 xui3lMfPG3i7FeVi4s9nT6EFmQZvrLHHucKG7oriRyneVHg/AcHEKewOtiNIC8hqRO
	 t7yem6kV2d2Mmnl+g3t1Cm5JNXZbnKfYnNF+lvBZuElxZBsyDKCAm8OFbHM+p2Nu+a
	 pPEcDCFM6UP49/8GJvkb1/o5PdHDhpgMHupgVuAZdxZRrejFAXb+HPBmRjVAkz+AtM
	 CySyXxS8tLWpQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7CE54382330B;
	Thu, 14 May 2026 02:20:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] net/mlx5e: improve RSS indirection table
 sizing
 and resizing
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177872522003.3924965.16128854514618119827.git-patchwork-notify@kernel.org>
Date: Thu, 14 May 2026 02:20:20 +0000
References: <20260511172719.330490-1-tariqt@nvidia.com>
In-Reply-To: <20260511172719.330490-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, saeedm@nvidia.com,
 leon@kernel.org, mbloch@nvidia.com, noren@nvidia.com, ychemla@nvidia.com,
 cjubran@nvidia.com, horms@kernel.org, gal@nvidia.com, kees@kernel.org,
 dtatulea@nvidia.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 11 May 2026 20:27:14 +0300 you wrote:
> Hi,
> 
> This series by Yael improves mlx5e RSS indirection table handling around
> channel count changes and large RSS configurations.
> 
> The series:
> * removes the XOR8-specific channel count limitation,
> * advertises the maximum supported RSS indirection table size,
> * fixes resizing of non-default RSS contexts,
> * allows resizing configured default RSS contexts during channel
>   changes,
> * and increases the default RSS spread factor from 2x to 4x to improve
>   traffic distribution for large channel counts.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] net/mlx5e: remove channel count limit for XOR8 RSS hash
    https://git.kernel.org/netdev/net-next/c/f7c35c668576
  - [net-next,2/5] net/mlx5e: advertise max RSS indirection table size to ethtool
    https://git.kernel.org/netdev/net-next/c/05ebdbaded05
  - [net-next,3/5] net/mlx5e: resize non-default RSS indirection tables on channel change
    https://git.kernel.org/netdev/net-next/c/6bf1c27586b6
  - [net-next,4/5] net/mlx5e: resize configured default RSS context table on channel change
    https://git.kernel.org/netdev/net-next/c/4f59c22f26f7
  - [net-next,5/5] net/mlx5e: increase RSS indirection table spread factor
    https://git.kernel.org/netdev/net-next/c/c75e7e599c62

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


