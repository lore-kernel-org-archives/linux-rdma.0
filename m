Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34403DB64B;
	Thu, 10 Sep 2026 15:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789053680; cv=none; b=GJ9tEBwcn1ke4hOsO62SbNTyVXZRr+jna5/iR5zmnlXN5MfBXEi3pgD4UDS0zP9VKkUXXx/k5/A0bJZASxJOYNWpKD/iKNpoXFXpxK19fyaM4+1jDfia49YnSPmiln6Py4CV0x7/ac4MGKmilOkNnL1TQo1YKDNdEe4N+nAmoNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789053680; c=relaxed/simple;
	bh=lQrR/NQniI4VsVmRj+f09Njkvc/mgDaiKYr85iY4+ls=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=HC/Ys4Z/eOzTjTa4erNTLtCK45hTn2YJMzyVlSUifKoWBLhBOQXXnUs9ctqbkXv7Nta23A2IdLQmv2rIm16hFiD7ZZhToMEkeBUy62qVNMHOkXY5tOyAmOXCTkxiM/4Req9cPaIdWxAkcUqmGoAxyumtlE8Ycnchk5TRizO+iAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TyA7lnfN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TyA7lnfN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 665DF1F00893;
	Thu, 10 Sep 2026 15:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789053668;
	bh=/o6Lf7XnOGTlaFywaXjjRieZKJoqvdthEim0g1lVyOQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=TyA7lnfNOlGk5PC7wmVwZW1HJ+GAujB2fAgFp+iXSl9UwUtzk3g/3wQiUligwNj4D
	 jWcTqWnCCOO5YwnC7hMiBvCmrFKBpS+k8QLRgZ6Llsgo3RNaY/MMBs8b2DTN8TY0GR
	 t2WRGUl1OKeJzi4ta8ybYbeFj2FzEmuk0isHpWldS7z9xIfiK7BOUwcyLoqOBDptCl
	 OS0x7GfUQLgmHDocrw2yRcdn1UDRGmbGIEcHR5DKvm8zm55wrcKeh+5RPy4Ijc1eMy
	 nhmn8gkdHui7Uhkaa73SbTiXk2gUzbbUuE6/WvzsRqxN+m3OJ8O0OlkvTToZbAlJhN
	 zTF+nHCOqmuoQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19929380CEF8;
	Thu, 10 Sep 2026 15:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mana: restore the XDP program pointer when
 pre-allocation fails
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178905360563.1492964.7576375446845174702.git-patchwork-notify@kernel.org>
Date: Thu, 10 Sep 2026 15:20:05 +0000
References: <20260904202640.3900685-1-longli@microsoft.com>
In-Reply-To: <20260904202640.3900685-1-longli@microsoft.com>
To: Long Li <longli@microsoft.com>
Cc: kotaranov@microsoft.com, kuba@kernel.org, davem@davemloft.net,
 pabeni@redhat.com, edumazet@google.com, andrew+netdev@lunn.ch, jgg@ziepe.ca,
 leon@kernel.org, haiyangz@microsoft.com, kys@microsoft.com,
 wei.liu@kernel.org, decui@microsoft.com, shradhagupta@linux.microsoft.com,
 horms@kernel.org, ernis@linux.microsoft.com, stephen@networkplumber.org,
 shirazsaleem@microsoft.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, sdf@fomichev.me,
 daniel@iogearbox.net, hawk@kernel.org, ast@kernel.org,
 john.fastabend@gmail.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  4 Sep 2026 13:26:40 -0700 you wrote:
> mana_xdp_set() publishes the new program into apc->bpf_prog before it
> allocates anything, because mana_pre_alloc_rxbufs() sizes the buffers
> from it via mana_get_rxbuf_cfg(). When that allocation fails the
> function returns the error directly, skipping the err_dealloc_rxbuffs
> label which is the only place that restores the previous pointer.
> 
> The attach is reported as failed, so the BPF core drops the reference it
> held for the caller and the program can be freed, while apc->bpf_prog
> still points at it. The next consumer of mana_xdp_get() - typically
> mana_chn_setxdp() from mana_alloc_queues() on the following ifup, or
> after a TX timeout reset - then calls bpf_prog_add() on freed memory.
> 
> [...]

Here is the summary with links:
  - [net] net: mana: restore the XDP program pointer when pre-allocation fails
    https://git.kernel.org/netdev/net/c/4c46beb807ef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


