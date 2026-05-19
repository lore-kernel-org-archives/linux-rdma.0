Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88A12DF68;
	Tue, 19 May 2026 02:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779156630; cv=none; b=NbOlby+jMDRn1VYGxrrkhDtbAqejOa/p0vY5+A7RVbB767OQ1idAiyZcYVRAG+mmmtcWABl3e764rfxq53LtR5piVNTe43xWBafzC98Vu29hIi6Kor/Cn8I8iAW7vqeFXcd+tLvgoREkPAxikuuHcVNryQhfVKxHhGKWY9xs2O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779156630; c=relaxed/simple;
	bh=tztf4Nw5ut0/6DpoJ41Cp6mb7XeZ6UqH/1hSjhNFz7Q=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=BJd/XgpYjBb4jAFUrwbshPVlnRpZ9LD04sZMh0zb8Ph7v1Q46AXHuBfd4ohxKPhtegPuNJvIsT9c2gnmAb3YZdY48GirWXckYIJiUSjxfSSUS2a4ysHNxQES3lLHUgMp6+wi3HrBcbWnJUG7sRrrxJELjh8UxqoYlBWjVGTSIaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WWplNKEx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WWplNKEx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C8EC2BCB7;
	Tue, 19 May 2026 02:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779156630;
	bh=tztf4Nw5ut0/6DpoJ41Cp6mb7XeZ6UqH/1hSjhNFz7Q=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=WWplNKExtQuHDHTw8UbUhu2fO1NKnQ2AVH94j1ajgcn25WbgB2ljKdWg2SX9zbw7n
	 LhhSdjHhIFvE9F0HfoqDxxeVSd6fPJPfaE+ZDZU5c70F+LlypOp0Jc73yzH8nfPmJz
	 OwnIHSAFYWlwkkzlmzQkMjqA3saqd36t7YzJLHMC43lhCSKLEXxUBWbBkDxn2/S+qA
	 1rGyeaRH+U9gz63DJZKka+sSEEIMMZy2I3rPW/iKcklQKZawCf/gFEjTEOA7t7hsDS
	 Hh6Oc0iC/BY07nhLrQqYBHaJeYT+9LTwRSqzR1BezX8FXybyNOrz30JK2yi56NWc9t
	 VEa7IkVlcoNgg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 198D93930D10;
	Tue, 19 May 2026 02:10:43 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5 0/8] net: devmem: support devmem with netkit
 devices
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177915664163.2054007.6384747943531037676.git-patchwork-notify@kernel.org>
Date: Tue, 19 May 2026 02:10:41 +0000
References: <20260514-tcp-dm-netkit-v5-0-408c59b91e66@meta.com>
In-Reply-To: <20260514-tcp-dm-netkit-v5-0-408c59b91e66@meta.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, corbet@lwn.net,
 skhan@linuxfoundation.org, alexs@kernel.org, si.yanteng@linux.dev,
 dzm91@hust.edu.cn, michael.chan@broadcom.com, pavan.chebbi@broadcom.com,
 joshwash@google.com, hramamurthy@google.com, saeedm@nvidia.com,
 tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org, alexanderduyck@fb.com,
 kernel-team@meta.com, daniel@iogearbox.net, razor@blackwall.org,
 shuah@kernel.org, dw@davidwei.uk, sdf.kernel@gmail.com,
 mohsin.bashr@gmail.com, willemb@google.com, jiang.kun2@zte.com.cn,
 xu.xin16@zte.com.cn, wang.yaxin@zte.com.cn, netdev@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
 linux-kselftest@vger.kernel.org, sdf@fomichev.me, almasrymina@google.com,
 bobbyeshleman@meta.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 14 May 2026 10:22:27 -0700 you wrote:
> This series enables TCP devmem TX through netkit devices.
> 
> Netkit now supports queue leasing. A physical NIC's RX queue can be
> leased to a netkit guest interface inside a container namespace. This
> gives the container a devmem-capable data path on the RX side (bind-rx,
> etc...). On the TX side, the container process binds to its netkit guest
> interface and sends traffic that netkit redirects (via BPF or ip
> forwarding) to the physical NIC for DMA.
> 
> [...]

Here is the summary with links:
  - [net-next,v5,1/8] net: convert netmem_tx flag to enum
    https://git.kernel.org/netdev/net-next/c/7d3ab852dcd8
  - [net-next,v5,2/8] net: netkit: declare NETMEM_TX_NO_DMA mode
    https://git.kernel.org/netdev/net-next/c/6ce2bb048055
  - [net-next,v5,3/8] net: devmem: support TX over NETMEM_TX_NO_DMA devices
    https://git.kernel.org/netdev/net-next/c/1abe839b34ae
  - [net-next,v5,4/8] selftests: drv-net: ncdevmem: add -n flag to skip NIC configuration
    https://git.kernel.org/netdev/net-next/c/ecbdf3da7813
  - [net-next,v5,5/8] selftests: drv-net: make attr _nk_guest_ifname public
    https://git.kernel.org/netdev/net-next/c/28357ac667d4
  - [net-next,v5,6/8] selftests: drv-net: refactor devmem command builders into lib module
    https://git.kernel.org/netdev/net-next/c/6cac32fc3f1f
  - [net-next,v5,7/8] selftests: drv-net: add primary_rx_redirect support to NetDrvContEnv
    https://git.kernel.org/netdev/net-next/c/886a790b59f9
  - [net-next,v5,8/8] selftests: drv-net: add netkit devmem tests
    https://git.kernel.org/netdev/net-next/c/28c1cc999fbb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


