Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792491012;
	b=YBzfMs/ZSyZ2v9qQPdIReThEzXGGuTkESk5u8hIvL+BK4RsVfCqnZ/3tJGzvSmON5X19
	 ut8fCWKpVEfDueqIBksmdVwPqaBL1u0nlViUtyU1/5PZqMpgRF+O6M5jLlScYXqWqFg1M
	 IBOEzbpD/7KEezSq6AGRefOvUoRzoIFBpWJTn7TxFfjC7mvj3ibX4hNTQtWIbYCaBaeMJ
	 G04CowQ5n+kHFg8SP6iLa1agyvpnxfoaSSQJTMu04tOHsFqiGURsvGTmiX1Z9FYsVYEVY
	 o9wuGLy4lud/2wmD6YF5bH8qBDp2DzQ72UTBaiZMJnYbfcQttGDdJoKG32LZDym3Yiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792491012;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=uoicQO4f1oIlbMf/wnSoUvyWA9k0FDoFbK9w/tU9zzY=;
	b=myugojFyM1IIcO/bOoVImZ6VlguOmJOgdtPpwhj7n3mLHSPDxJFv0XCnIkCle22nPkMU
	 WyyNh0wqL3BJZa+pxO6Gd/VvgfFhm8DAvm9LmFsVO2QG/8P7w9iZJPBnmC9u/QC+EO1SA
	 NCsCBpjMOfbYE61sJfCKpwkvoXwxyOx0m9P2/ywhQhWSq7pGclkQtBIngruHy2IGJ2BG4
	 HLqh3j8IGnhZBAChi+zmXoTSpJ3vvElYHo8b1ltd5z1LOh1OFz95ImsecirCvqHKrzh5m
	 1LPTDP/QAUcGdEk+nJi6+dKa60OOvkDQHt4XQ05Yz3gorgXG/7VKrngKY66YeoBy+vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="NQaf/wCW";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7D1606A31D;
	Tue, 20 Oct 2026 10:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NQaf/wCW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4F41F000C7;
	Tue, 20 Oct 2026 10:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792491011;
	bh=uoicQO4f1oIlbMf/wnSoUvyWA9k0FDoFbK9w/tU9zzY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=NQaf/wCWjOpeXVy7VgCUltILC98GqxD5mv7n1q4o+gNv7QPjZJdZOU7c+R1ea19wa
	 HHpvcWPQfip6dc5q6ssF98ErRyAPxasHc5Ak8dSbFoLfolwXVyizZHmPIjW4+EVtK3
	 DUyfPWNSOZ/x8CUVGogMEiWJan1HJEySJzZHDVuvTLHxRi2x94efoCQz8KT08Em7AW
	 fnJGa5oueMf339Lvm2o46F4Ui7j2tiE6bftFbYyRAszdGDcFPRRsalw6GZTOx+rHsI
	 DdytqtPSHitZbQIN06bYgwAiEAHxOU9pdd8+PlriXBc6cj49/EUDi+kzO3gktPYyLE
	 fc1lelZQ1RVlA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B443F3808209;
	Tue, 20 Oct 2026 10:10:11 +0000 (UTC)
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
Subject: Re: [PATCH net-next v3 0/6] net: unify symmetric netmem and page_pool
 refcounting
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179249101026.3632927.6502845375265155678.git-patchwork-notify@kernel.org>
Date: Tue, 20 Oct 2026 10:10:10 +0000
References: <20261014173945.373295-1-almasrymina@google.com>
In-Reply-To: <20261014173945.373295-1-almasrymina@google.com>
To: Mina Almasry <almasrymina@google.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, bpf@vger.kernel.org, ayush.sawal@chelsio.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, tariqt@nvidia.com, horms@kernel.org,
 steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
 ncardwell@google.com, kuniyu@google.com, john.fastabend@gmail.com,
 sd@queasysnail.net, ebiggers@kernel.org, kees@kernel.org,
 aleksandr.loktionov@intel.com, petrm@nvidia.com,
 u.kleine-koenig@baylibre.com, j.raczynski@samsung.com, wang.zhan@smartx.com,
 willemb@google.com

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 14 Oct 2026 17:37:14 +0000 you wrote:
> netmems (pages and net_iovs) have two independent refcounts: a non-pp
> refcount (page._refcount or binding->ref) governing backing memory
> lifetime, and pp_ref_count governing recycling within a page_pool while
> page_pool holds a single backing non-pp reference. SKBs with
> pp_recycle=1 own pp_ref_count references on page_pool fragments; SKBs
> with pp_recycle=0 own non-pp references.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/6] netmem: rename __get/__put_netmem() to get/put_net_iov()
    https://git.kernel.org/netdev/net-next/c/a868720467d9
  - [net-next,v3,2/6] net: skbuff: add napi_pp_get_page() and use it in tcp_recvmsg_dmabuf()
    https://git.kernel.org/netdev/net-next/c/729a47b803b5
  - [net-next,v3,3/6] net: skbuff: replace skb_page_unref() and __skb_frag_unref() with skb_netmem_unref()
    https://git.kernel.org/netdev/net-next/c/4d688084070e
  - [net-next,v3,4/6] net: skbuff: replace __skb_frag_ref() with symmetric skb_netmem_ref()
    https://git.kernel.org/netdev/net-next/c/1f6f88105e1d
  - [net-next,v3,5/6] net: skbuff: use skb_frag_ref() in skb_try_coalesce()
    https://git.kernel.org/netdev/net-next/c/447f58db3505
  - [net-next,v3,6/6] net: kunit: test netmem, page_pool, and skb frag refcounting
    https://git.kernel.org/netdev/net-next/c/2285346afc99

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


