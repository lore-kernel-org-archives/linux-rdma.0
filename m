Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795135211;
	b=njSJ0YzMxl+skyHqX6SihXUtfXIxNCFmCpkvIN0LJiRRcsMjEkiwMMhv0Wc6KGqXLXZ0
	 43uioB9UU1AnXkXjIUCpQPwjbdUwxV4sU6+Dig7zI0ye0ZUuOp9H9DbCUVrjcgCrHb14z
	 jOy4BVhdCefbAoMmgyNg18zaLSNCewCpp4581KbnohQ1kofkFA0yTfH28ODw6Z/LQ/FIc
	 8Odvv7ereHaPKq1uLSuumFubC6h5ykQ1G40WNsNX3a8ayJgAjgkMbT6Jmp0n1gzye8ERy
	 8n5qqsUvtaalRv9PMYyzDdsTj/NVqaW3T5fAmZmdOaZwZOBVrANyLB+sWo3o9KTHlIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795135211;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=fuYqGKz8tF4JVrpW4P/SNbiXiq0ATgFGBBkKRffwfsU=;
	b=yLbyjTjcP929ft1uc7D8ly4zWmYVYWQKfFVlsXZTD0i/Ll6cFm43bTgwNxpsnEcErfGl
	 QGVM9xcHvXiqV9AXgRzT78/CrfAixg+w1R53MZnIZBj7AY+7Qv6I6IT+zWWx9MBtwjyhi
	 a9SjwO7YU83nONUDr+xaBxozAtw4ttZl+is9nz+hsrW/zHiyx94Y+kdhnbg58iApa05N7
	 dI8vKtrRYJvgqFQOuKZQGXqKhjGnTfInc5OC777sKSx/nf1nbKvDJ5Ev2+EtUqOcaxxJC
	 KK8mO4c0W4quH+AvK/8sEfc2VgBK8mNxxT80RBzPvSEDO8JmQDo1rJrcq34AaBw8gbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P38cuAm1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C705606A325;
	Fri, 20 Nov 2026 00:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P38cuAm1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDED41F000CA;
	Fri, 20 Nov 2026 00:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795135210;
	bh=fuYqGKz8tF4JVrpW4P/SNbiXiq0ATgFGBBkKRffwfsU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=P38cuAm1/jpCPpAmQZGHjFmU/VWaKCTzHLPwz1seUQkeISuENbSe6IDHejHP7bfCC
	 H94Oi/lI/dJJIeW+ADTqDWSLz8UxwXCmPOG1BHMt9CyLQTiL1Vv4GY9ZVvlQ5+E7Lw
	 xrZoF96hpw0e4qDEbqyd5j5515wcsyIpSZuC7/tT2p2KeGQWPDzNGh/+iWrlxsH1qw
	 uSFnHwf1bYj2jn3ZLWcxEuBpgbVszqIMmpnOfMBMS3WaUUQ9rfUPjbYk52Zd0JKJjc
	 uAB3nECbYD4UFmu67/kuYvRFhQnOdR1YCQrdpK6bB+mFn6J9uZly8EBp4BXCKUV1/C
	 0fmaJIsQs15uA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B45673808209;
	Fri, 20 Nov 2026 00:40:10 +0000 (UTC)
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
Subject: Re: [PATCH net-next V2 00/10] net/mlx5: LAG,
 preparations for LAG over VFs/SFs
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179513520953.3950719.4715041705999451652.git-patchwork-notify@kernel.org>
Date: Fri, 20 Nov 2026 00:40:09 +0000
References: <20261116103010.1129666-1-tariqt@nvidia.com>
In-Reply-To: <20261116103010.1129666-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 cjubran@nvidia.com, cratiu@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 moshe@nvidia.com, ohartoov@nvidia.com, phaddad@nvidia.com, saeedm@nvidia.com,
 shayd@nvidia.com, udar@nvidia.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 16 Nov 2026 12:30:00 +0200 you wrote:
> Hi,
> 
> This series by Shay is the first part of enabling a LAG over functions
> that do not represent a physical port - a "virtual LAG" (virt LAG) of
> VFs or SFs acting as nested e-switch managers. New FW lets a VF/SF front
> the physical uplinks through a multi-uplink e-switch; such a function
> reports num_lag_ports < 2 and drives port selection via the e-switch
> (port_select_eswitch) rather than the HW port-selection flow table. A
> virt LAG is therefore a software-managed, shared-FDB MPESW LAG: the
> driver builds the LAG demux and vport-LAG in software.
> 
> [...]

Here is the summary with links:
  - [net-next,V2,01/10] net/mlx5: Distinguish VFs/SFs in the SW system image GUID for LAG grouping
    https://git.kernel.org/netdev/net-next/c/c25049685e16
  - [net-next,V2,02/10] net/mlx5: LAG, select the MPESW master from the live member snapshot
    https://git.kernel.org/netdev/net-next/c/2bfcb28b10e8
  - [net-next,V2,03/10] net/mlx5: LAG, skip phys LAG prerequisites for a virt LAG
    https://git.kernel.org/netdev/net-next/c/a2d029ad50e2
  - [net-next,V2,04/10] net/mlx5: LAG, treat virt LAG as a software managed LAG
    https://git.kernel.org/netdev/net-next/c/b03cb2fdbbdb
  - [net-next,V2,05/10] net/mlx5: LAG, decouple iteration end-of-walk from MLX5_MAX_PORTS
    https://git.kernel.org/netdev/net-next/c/4eef67c32a7b
  - [net-next,V2,06/10] net/mlx5: LAG, rename PF naming to fn
    https://git.kernel.org/netdev/net-next/c/1e6086bcd491
  - [net-next,V2,07/10] net/mlx5: LAG, resolve affinity indices only in queue-affinity mode
    https://git.kernel.org/netdev/net-next/c/26da1e56cef9
  - [net-next,V2,08/10] net/mlx5: LAG: replace fixed MLX5_MAX_PORTS arrays with dynamic allocation
    https://git.kernel.org/netdev/net-next/c/b7826ed4d0b5
  - [net-next,V2,09/10] net/mlx5: LAG, drop MLX5_MAX_PORTS scratch array from device rescan
    https://git.kernel.org/netdev/net-next/c/0da8bb5da54f
  - [net-next,V2,10/10] net/mlx5: LAG, do not add a device to an already-active virt LAG
    https://git.kernel.org/netdev/net-next/c/5830905813d0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


