Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C633F9F5C;
	Tue,  4 Aug 2026 02:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785811250; cv=none; b=WQGGROFEzvJ8IkXSamke8sGSCk030rdngjgBpCQH4oIuVFUQuWgQSMLK7tIdssBZ4Q7A1ZfJjMLh781agWc744sdD/HRUmp0X6WknyfkIdMUaxOL4J7AMf8oOBBmdHgtUxYaxbrDTEMFl+JPFL7jMikeMAnvhUDlovREuDtI7pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785811250; c=relaxed/simple;
	bh=nVyF0PlbsxSqR2QIno5VTkX07Iqlqh64cJ0ksmoZk5g=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=u4qMX0BaKcckdDW7VlRjDV/fmzkJP+KDUiuVII3eJ8kmjLZTGEjDrthwqDGYqwVI2Homr1Vwr0i0YvO7GPPsWvuQKei7uorp1xG+ecee16rgKj4W8kh2cjIJ3Bd9U05G31GVs1wVbtNsx+piuGLQlCeMCAbh5FyGFFeGmc8g4xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T13tUpv2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T13tUpv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E611F000E9;
	Tue,  4 Aug 2026 02:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785811248;
	bh=15lzLCqHAnV9ZJD5zJGXMNc+UlZaHfgR/lxWXia8vPs=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=T13tUpv2yXK6Yzj1j2/zKH4ixGDvrASWmFkzu+BEFxYXlXqxxCC5NsXM1jxT+ItkI
	 /0Z7Oltsnn6YDz2vLyNVtsYEMkvA2m9cg1CDjREs5YyO0bbDgKJpOHo5syKz9TtTST
	 v5GAyqmeM+ERPgFXrENFrsuRkyZAWeHQi5qfC1lQWWSdBXVaQiyq7bM47k4YOdjbYb
	 qxzJl5aNGiPTD0pNSPzwKqo+zQQnnGtmGthUdrp/E223IGEpnOa2V30iLkytrjtrwP
	 ++RvUqg/xbW/kf+xGtvzpF2FdyfWD4ACjkr+ZrFJ8MCiBYndrdWOTRogtaOV7NC019
	 Z8poserjtcerw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93A95392446B;
	Tue,  4 Aug 2026 02:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v13 0/2] net: mana: add ethtool private flag for
 full-page RX buffers
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178581120914.2928327.8546409528500669691.git-patchwork-notify@kernel.org>
Date: Tue, 04 Aug 2026 02:40:09 +0000
References: <20260729063347.3388035-1-dipayanroy@linux.microsoft.com>
In-Reply-To: <20260729063347.3388035-1-dipayanroy@linux.microsoft.com>
To: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
 decui@microsoft.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, leon@kernel.org,
 longli@microsoft.com, kotaranov@microsoft.com, horms@kernel.org,
 shradhagupta@linux.microsoft.com, ssengar@linux.microsoft.com,
 ernis@linux.microsoft.com, linux-hyperv@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, stephen@networkplumber.org,
 jacob.e.keller@intel.com, dipayanroy@microsoft.com, leitao@debian.org,
 kees@kernel.org, john.fastabend@gmail.com, hawk@kernel.org,
 bpf@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org, sdf@fomichev.me,
 yury.norov@gmail.com, pavan.chebbi@broadcom.com,
 schakrabarti@linux.microsoft.com, gargaditya@linux.microsoft.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 28 Jul 2026 23:21:27 -0700 you wrote:
> On some ARM64 platforms with 4K PAGE_SIZE, utilizing page_pool
> fragments for allocation in the RX refill path (~2kB buffer per
> fragment) causes 15-20% throughput regression under high connection
> counts (>16 TCP streams at 180+ Gbps). Using full-page buffers on
> these platforms shows no regression and restores line-rate
> performance.
> 
> [...]

Here is the summary with links:
  - [net-next,v13,1/2] net: mana: refactor mana_get_strings() and mana_get_sset_count() to use switch
    https://git.kernel.org/netdev/net-next/c/d52f80731055
  - [net-next,v13,2/2] net: mana: force full-page RX buffers via ethtool private flag
    https://git.kernel.org/netdev/net-next/c/5b5cb75fb86a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


