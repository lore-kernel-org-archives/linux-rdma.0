Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5498C259CBD;
	Thu, 19 Feb 2026 15:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771513816; cv=none; b=fCZLWg+VIS9tp8l+gttLe7nDu9HjslrHdokOC1BNu7vRqmJhCTaLik6yKT4cCeDhbAXDCX/Mq+X2F/vlrUomtQb9PXAtkHyeOZFyFYRkFsP36q1Kr4MzMwg7zAEkDEsB+BDEdGAjiMf8OIQ45ELO0g0MwqAlKrJgvH7YNAv318g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771513816; c=relaxed/simple;
	bh=bnx2UJT58n90YGkS84Z9IcHcboH7QYnKVdXsqM/bQsU=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=UFXrIJJ7UI5TaYeXPaROjPd82D81gaWK96Wd9AcgOdBGwdhR8fAOIfF84Gmpgbbb6C3VENCzsYghr76+nJ+ARX0LNJL1Uuj+87au81w3517LG8KsN2zeIoD6YHkVOSgtK9aTv3lg3zgFFd5fJPD5lbskJmpQOoYcgKoNf+7ZE54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pKWnAruE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pKWnAruE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9868C4CEF7;
	Thu, 19 Feb 2026 15:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771513815;
	bh=bnx2UJT58n90YGkS84Z9IcHcboH7QYnKVdXsqM/bQsU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=pKWnAruEV0Qi0e3N4AyzAkwp99frRmLPxDq6LnohhNozwYxSu7EVANoa+FMzBClps
	 LV02sIgIGnrb/y4uRzP5UF3Z2w6b5VPjVqLXG3kGfd45ynVNV9gHLVSFeo2covTvtC
	 V4qlAMgLQ4CiDyj3KA30CVhylkPNkhugi5qv9hiMDMyOAgV/YtaopFEzq0fkpr47pq
	 kcFFzPy46lwta9JCMR1smrJa1nkoksYPjn+cm76WvETPrArGcyyX7xvNZtxb93qmYu
	 VPRYTF8k/R02f0ctCYJ016Terrlf7Z7F2Goc5bUdcXVlarD78mWzFChMNiUZPtpCTw
	 Q/uc+W9vsNnZQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 0B26D380CEF3;
	Thu, 19 Feb 2026 15:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/rds: Fix NULL pointer dereference in
 rds_tcp_accept_one
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177151380683.2260009.6858466914416054623.git-patchwork-notify@kernel.org>
Date: Thu, 19 Feb 2026 15:10:06 +0000
References: <20260216222643.2391390-1-achender@kernel.org>
In-Reply-To: <20260216222643.2391390-1-achender@kernel.org>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
 pabeni@redhat.com, edumazet@google.com, rds-devel@oss.oracle.com,
 kuba@kernel.org, horms@kernel.org, linux-rdma@vger.kernel.org,
 allison.henderson@oracle.com

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 16 Feb 2026 15:26:43 -0700 you wrote:
> Save a local pointer to new_sock->sk and hold a reference before
> installing callbacks in rds_tcp_accept_one. After
> rds_tcp_set_callbacks() or rds_tcp_reset_callbacks(), tc->t_sock is
> set to new_sock which may race with the shutdown path.  A concurrent
> rds_tcp_conn_path_shutdown() may call sock_release(), which sets
> new_sock->sk = NULL and may eventually free sk when the refcount
> reaches zero.
> 
> [...]

Here is the summary with links:
  - [net] net/rds: Fix NULL pointer dereference in rds_tcp_accept_one
    https://git.kernel.org/netdev/net/c/6bf45704a92a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


