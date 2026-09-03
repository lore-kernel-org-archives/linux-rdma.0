Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F5A2AD03;
	Thu,  3 Sep 2026 03:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788404480; cv=none; b=MjkEvKokIJM0dMnbUrE9RfIgUpKZf41YP2wqZBHgO69VOVaa2JTa+v2onjahoylJhkLL7GDBBO2DOh8vQt6mmn2fHyuRNI8pEWmPfwjZ9GxkwM8EuWoFRkE7zPL1klDUPBVZBELp2yvL+Moxg+nuLlQcM+VOibRPM7lS58CSVT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788404480; c=relaxed/simple;
	bh=2wjBNr9zTeYBzJvMLcuEBJDe85XHin4tX2QnoAgrx0U=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=dLws43PPBrztd6CLmikuGK+Z1T9nD7wivYSa3YmyHsKFhhU1R2Ekf9RglBtIZGrft++lG/qCxMVh1EGTXARMkpcAtMGnbPs5RM+x9j+bfdPag9FMcoVh51h7yJZ1Vkmf7RJ5Y/qNldantsKmXsVrPky8jMtq4rYqsc3d1sO1DK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jhS/qaCo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jhS/qaCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 404301F000E9;
	Thu,  3 Sep 2026 03:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788404478;
	bh=dti6P2+fpan/PWRRo7IXt81V3LD0ZHyIpNZKNTiMv7s=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=jhS/qaCoEEHLJyM7vqa6Ade3SeGgNeTY7bC1c4ugZal04x8VjEa/6uRQyCB9tnqvW
	 fBhaYYASwOel6BpZUpk5AXJ5PIdlE52AsxtS9Y9uE+fxtKXJf2moItwdBixyBZQFhr
	 BmCbv5VBg8ViWysBMvE5eeF2JBP6XXgWBNbboTM5FNzoeX02lJWB9qWztwZ6XchB/K
	 a9wTTV9BerNueyAU/mG3lCCUAj4hqZeSg6ADmO8V0ibOSTbBrOTtChTKA15R97D0Ar
	 fAb3YgoCm1fGO840kdO6dLzmkfjFmopILtP+x4Ho0DSXPvhR8LG0JCEL0Lc46OH5I8
	 OQYq5YEgkf2mw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19A7D392705B;
	Thu,  3 Sep 2026 03:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v5 0/7] net/rds: own the fastpath locks across
 connection
 teardown
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178840441963.3061644.9034056329969697998.git-patchwork-notify@kernel.org>
Date: Thu, 03 Sep 2026 03:00:19 +0000
References: <20260828223921.202913-1-achender@kernel.org>
In-Reply-To: <20260828223921.202913-1-achender@kernel.org>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, jhubbard@nvidia.com,
 woni9911@gmail.com, michal.kubiak@intel.com, leon@kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 28 Aug 2026 15:39:14 -0700 you wrote:
> Hi all,
> 
> This is v5 of the follow-up set to "net/rds: Bug fix ports, part 2"
> [1] (v1 at [2], v2 at [3], v3 at [4], v4 at [5]).  During review of part 2, the
> later half of that series needed more work than a respin, so it was
> split off into this set together with the companion fixes identified
> along the way.  As discussed on the v2 thread, it is targeted at net.
> 
> [...]

Here is the summary with links:
  - [net,v5,1/7] net/rds: use wq_has_sleeper() in release_in_xmit()
    https://git.kernel.org/netdev/net/c/6d0c8b707391
  - [net,v5,2/7] net/rds: use clear_bit_unlock() in release_refill()
    https://git.kernel.org/netdev/net/c/17c4476dbb9c
  - [net,v5,3/7] net/rds: clear cp_flags bits individually in rds_conn_path_reset()
    https://git.kernel.org/netdev/net/c/103c4b13c4f5
  - [net,v5,4/7] net/rds: tcp: don't force RDS_CONN_RESETTING over a concurrent shutdown
    https://git.kernel.org/netdev/net/c/e8e60d74fec4
  - [net,v5,5/7] net/rds: acquire RDS_IN_XMIT in rds_tcp_reset_callbacks()
    https://git.kernel.org/netdev/net/c/02c5f9dc2efd
  - [net,v5,6/7] net/rds: acquire the fastpath locks in rds_conn_shutdown()
    https://git.kernel.org/netdev/net/c/813f3582ac7a
  - [net,v5,7/7] net/rds: don't let rds_conn_shutdown() consume a concurrent drop
    https://git.kernel.org/netdev/net/c/260c6308fe2e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


