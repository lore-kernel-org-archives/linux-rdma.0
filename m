Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF703F4DEB;
	Thu, 23 Jul 2026 21:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784841640; cv=none; b=hZ+3ACE1JrYNA1grCZ4Nl5vdbt6rD3RSXdTEiJAMSF3wHCVeSAaw2kCKX+x+CDHkkGvTwM3OggzBgfdisvzbeZlrBPU9flNBSCV8rIt13nYIZ3Ft5wf6L80l5xM7Ze/z6XizV7OfkaUKZ6XjC9L7R/k33e9EH6pZ06PI6oTSZEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784841640; c=relaxed/simple;
	bh=3R2mKj1ixYx/KmniWVhAjArG/H9dRVhvA0vRgiefncw=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=d1ZfrklPBrC7AbIc2Q1tnHqEXfVdK/Ozu5FuA0M/Tm+gtEt21uyrcaPQq02pxf3T/j+rW1wi2trQWtl9IUaAG36qwNQwFUvVbCAiSWiESN8phCP3iX/s5nbltTcNEgdXHakyd0iUEXovLHHCSHnRSgH8nTYzOnWNaYzHd9Ao3po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EZGr01yv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EZGr01yv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05771F000E9;
	Thu, 23 Jul 2026 21:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784841639;
	bh=PXNq8JIvh+zp1A7Lo6v0+lC93cOzhl0mgYF1LeqblY4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=EZGr01yvJI4Dy2j4fhmUIO+UccI17FIw24Uf4lrJGGG2Gzbhjs42If154IjIaiyhy
	 c1o+LCtK/Uk/1wuRks+PjrgcVDzuBSEOfc7xL7FhVTQkKVkxlEVvxXQXfun2n7+EPd
	 jtjEwvvK4PA8XnUqTHUU+w2BRsTi0FsyyfYvAwAQ6M4TVA2Xey1IvSJUqdFl8A9eOh
	 Yb8LIT7ASzHj6t4UIpQvr4VfP1UW1psil+XnVkXgAFMPLs/zH8kpJ60j0eLxBABI8Y
	 xtmZxHjACY3ZcsURWG+dZXOKfFgqtykrEBhjlyTGfRgAT3fN1/hMP2nE6SBmB3M+6A
	 ebtmXNdDBTo9w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 198923924A1E;
	Thu, 23 Jul 2026 21:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v4] rds: tcp: hold the RCU lock across ipv6_chk_addr()
 in
 rds_tcp_laddr_check()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178484160664.2877680.17585113396964964552.git-patchwork-notify@kernel.org>
Date: Thu, 23 Jul 2026 21:20:06 +0000
References: <20260722210203.565803-1-xmei5@asu.edu>
In-Reply-To: <20260722210203.565803-1-xmei5@asu.edu>
To: Xiang Mei (Microsoft) <xmei5@asu.edu>
Cc: kuba@kernel.org, achender@kernel.org, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, horms@kernel.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
 linux-kernel@vger.kernel.org, santosh.shilimkar@oracle.com,
 ka-cheong.poon@oracle.com, Ilia.Gavrilov@infotecs.ru, bestswngs@gmail.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 22 Jul 2026 14:02:03 -0700 you wrote:
> rds_tcp_laddr_check() looks up a scoped IPv6 interface with
> dev_get_by_index_rcu(), drops the RCU read-side lock, and only then
> passes the bare struct net_device * into ipv6_chk_addr().
> 
> dev_get_by_index_rcu() only keeps the device alive within the same RCU
> read-side section. After rcu_read_unlock(), a concurrent RTM_DELLINK can
> free the net_device; ipv6_chk_addr() then dereferences the stale pointer
> in __ipv6_chk_addr_and_flags() (e.g. l3mdev_master_dev_rcu(dev)), reading
> freed memory.
> 
> [...]

Here is the summary with links:
  - [net,v4] rds: tcp: hold the RCU lock across ipv6_chk_addr() in rds_tcp_laddr_check()
    https://git.kernel.org/netdev/net/c/78f75d632f74

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


