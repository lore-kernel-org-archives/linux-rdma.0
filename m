Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02414562A9;
	Thu, 13 Aug 2026 11:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786618868; cv=none; b=PETcHUGHNs30h1H+E5hUJhsXSQIMvztAIOhlCI5QMvblqe7UsrZMYQWdYVGs4ja4fw2CEYjiikXqs5Is4IbJgW38I7PKZbvvnCXxfkKwqG6Vin//Kw4528lwEVtxUj3v+AMEJVeTHdjIlvOE7gHvXD/ACioOYyTL5ooCPKXRw40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786618868; c=relaxed/simple;
	bh=VSeJ7leKQieNtdlMGBWHX9C5sEQ51sEOq8ri6ysJpEo=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=cgLatgVOdeRrPht23870XRJT052hSDoBo5PKlPiaheBqLkJuRfz5XN3RoOOEG5Vv1wk92ThQP5Ns+r/I+QQq6/BTSfmAFTdFEPfIAicVOm+ny9voDdlk8kQ6WWxmCsUMJG3v3y2pxgsn4c/Mz9r+Oz1PG+hKchaGUgr9aafGMT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BiCt8zWx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BiCt8zWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECADB1F000E9;
	Thu, 13 Aug 2026 11:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786618856;
	bh=0gJJ6Cuw+eG1RSmwRXMpuxGqsREFFzmIfjK5r+o+dM8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=BiCt8zWxiT7o1R+aRBUhS7rMKQGkTbelsdAlMff0MbjRR+MNzoeE2cmFLidVV8X5V
	 magxfpG8J23SHZLbBXL3pzPpwaDE7zFLaJQQV40RV555vtxRoTXa3AQ1/WXrBSTDHl
	 /N9npcFQIAsE/2gXl+1PYw7nghL9mGubqDnhEvwq9QFmWpRFyAvG3kX/B2m3XxAibE
	 nqmN/Bktx05ZVQgCG10FiIrbykNAT4IF5++9Cu85XSO2Ayi+OkdAuHYIv8Jh+vaLA8
	 dcDm0A2KVIRVQGOpAKm+UWXAFBfT8fviIhS/ZuCkgvYglqLqmrUGWuQjQT+i/cBdG1
	 16hvTLW3694/A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19925380CFD7;
	Thu, 13 Aug 2026 11:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] net/rds: Bug fix ports, part 2
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178661881063.2374993.11164110146414365465.git-patchwork-notify@kernel.org>
Date: Thu, 13 Aug 2026 11:00:10 +0000
References: <20260809005103.82371-1-achender@kernel.org>
In-Reply-To: <20260809005103.82371-1-achender@kernel.org>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, jhubbard@nvidia.com,
 leon@kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Sat,  8 Aug 2026 17:51:01 -0700 you wrote:
> Hi all,
> 
> This is the next batch of net/rds fixes ported from the Oracle UEK
> kernel, following up on the first set now in net-next [1].
> 
> This is v2 of patches 1 and 2 of "net/rds: Bug fix ports, part 2"
> [2], which contained two initialization-hardening ports.  While
> re-reviewing v1's patches 3 and 4 (the fastpath-lock teardown changes)
> I found their locking needs more rework than a respin should carry, so
> they are split out and will return as their own series together with
> two companion fixes.  The two patches here are independent of them.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] net/rds: reinitialize to_be_dropped on rds_send_xmit() restart
    https://git.kernel.org/netdev/net-next/c/a364a7c168d0
  - [net-next,v2,2/2] net/rds: initialize i_conn_path in rds_inc_init()
    https://git.kernel.org/netdev/net-next/c/ff8376b2458d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


