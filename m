Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792791606;
	b=srTo+xck6HewAGp9mvysn5RKfw9jF/hMJGknNWVCm7pdXCiO4KzSYpppfmP/Uk4QVnqs
	 Fuj1412LCkhm3JYTX7wMb7tmGdjqoy6WX7K2wjttmZ6ye6ufcPbx5/5F9l1wVfVcpFxkg
	 PsxncgFBI5lTESMMv5DCynJiZw/F6Xf2i7E+7ll5kZbd3IKztShneBZxxy5k471+nYa21
	 XfRvHbD9f5ia8qxIBM400tSKlSG+ZIcGASn/JZ79K9mCKaAmTyhLPXPLUiH31nqbL2Srz
	 2BSmEu5ETEs7oNhVg/V+KyFNXpyDKgx7LuhV+EWtGKiyYe5AMpTDOfqBC10GMZ0ucSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792791606;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=QvlxtsCfPvmf5mgtr+jVheio9NbYCsNvVal8cUWDtMA=;
	b=gcUzP9iM4G7YPJYEgOZjUt23pYF1HWsYfCU6gGhfa7jLnVoCc6eas1o/wQySVgxWhwPJ
	 bJyKbxCK5fj8sSVwej0YVGl/ZIcxYl1zrVlJ0loOmosM31YPqlhr6delgPL3doV8E7Tqc
	 bQPv1kVXZ918BTCYRy9vRjaPypTU3flJi3cO1rpx+QME1kOAJMAaSnVzJsY3YCbc/z7R6
	 E/q/A727xbGS/GMiOivrVzz+jjAbCGcnPfmdOTu8O0gow28g8DGdT0OQY9wraVQl339UJ
	 3vFItLQFps5tT81IId+oLIu81OiTG5BQo0T/uAr7hrU3l3tVt4CYHTKBERmRiqxvhmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZIHweqFn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0383E606A31D;
	Fri, 23 Oct 2026 21:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZIHweqFn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D151F01825;
	Fri, 23 Oct 2026 21:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792791605;
	bh=QvlxtsCfPvmf5mgtr+jVheio9NbYCsNvVal8cUWDtMA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=ZIHweqFnOpO02JONhCQ5DYo6lUpYkg36EHRNipWkY33nvKU7zdfP4388aIldtmU3x
	 w3jNSzjeE9DVAfNzmZrgRJDbdMl1WEHr5e/wdm05y6p28P0G2SOLz2jipz1D9aeRSi
	 whNCC77rBldKABjommfSDcE5U7GWIi0gl5/kgrJG6K6Fr5edPtDPBvKK86NnNki1tj
	 krtExb8eU8HZLV38VHLpIqKhUW2MpCZ9GpwkWD+Cj9vz9KXc/OIeiYfCTQmpsbT3/A
	 se278PEW4SNyTw4cU8MF+FCgquZND7JwhK8j4jGEnEhFf5QGhVU8D+l7ZM/Ac6HYpF
	 wPR6lMUX8u3Hw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BE578391B158;
	Fri, 23 Oct 2026 21:40:05 +0000 (UTC)
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
Subject: Re: [PATCH net] net/mlx5e: IPsec,
 Fix out-of-bounds comparison of neighbour keys
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179279160457.1284438.12304936750048300423.git-patchwork-notify@kernel.org>
Date: Fri, 23 Oct 2026 21:40:04 +0000
References: <20261021064231.3466989-1-tariqt@nvidia.com>
In-Reply-To: <20261021064231.3466989-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 borisp@nvidia.com, fmancera@suse.de, gal@nvidia.com, jianbol@nvidia.com,
 kees@kernel.org, leon@kernel.org, leonro@nvidia.com,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 prathameshdeshpande7@gmail.com, saeedm@nvidia.com, horms@kernel.org,
 sridhar.samudrala@intel.com, ychemla@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 21 Oct 2026 09:42:31 +0300 you wrote:
> From: Gal Pressman <gal@nvidia.com>
> 
> mlx5e_ipsec_netevent_event() keeps the L2 headers of offloaded tunnel
> mode SAs up to date: on every neighbour change it looks for SAs whose
> endpoint matches the neighbour's address. The compare width, 4 bytes for
> IPv4 or 16 for IPv6, is chosen from the SA's address family, with no
> check that the neighbour is of the same family.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5e: IPsec, Fix out-of-bounds comparison of neighbour keys
    https://git.kernel.org/netdev/net/c/520631554a68

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


