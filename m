Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20593B71C7;
	Sat,  5 Sep 2026 20:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788639679; cv=none; b=BWnNJC3k0jK5/skI9DnonVvl62ZySeqj0tC4kHap5ggfsH8mTHCRRZ6g7JBrG8M8URU/ebJxfLXbvr12IgYTEdTTGVpB+LeuARcZX5F49VWTP+ty0dPFdFbFN7+P9qLzaGFZDDEA4ZJQz0374NV7OaEi5L9pa5jEN6OEX8+p8C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788639679; c=relaxed/simple;
	bh=0Kb5/7xuysbISIHQrAuiAw1EDJDpmWkMOT4W5q6plyQ=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=h9ZV6U1rm2yuH3Og14BXtPgZQuuZLvZPZBDkXmW0FhAHzXsde9va8RociQqoME2ctsgziHsydM6nAhl7eIhFDReGRLZFTjKdgEOk3fD77wCrS96ouJ/+xQUbwXN5r/IZKSla5L6A1oqeimbAqMGh4vwoR1AdI01pZPUHqxOlpjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WKEIVRTq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WKEIVRTq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7508B1F00A3A;
	Sat,  5 Sep 2026 20:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788639677;
	bh=KEYiUjUik4xiM8PQEiZL/uWoyMiw0EfkNYxILgOTgIY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=WKEIVRTqYWcMFMKEz/DJQ8Eju+Nye9uM3OX4ArNA6rRAaknh0iHVP4obJvJn0qxaN
	 JkavfR833TqoEf7Uy+Clu71HZHNJvINcJrhAsmfJYVE5bcM/Dgp9nmXEdje9pZiLTC
	 Tzkul0t3+N4SI4XKk7k+7VZtD394+YGYavAsLvasKYAqDvBmsBeKQiinCcUy/qoXAc
	 0SLAxQgGLoWKlHsPaQClaKinNoPbXWq2WaOneYfZLmDUZ7MIaC4Uh+0EODIk7J8ZUE
	 4cpoZmH5vins2689sLFpW25pXg307kbrRvVV4OLsCqT9OsDwCRyMe9DUVK8KMyhxYk
	 zO3yNKntlo9jQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0B193924FED;
	Sat,  5 Sep 2026 20:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/mlx5e: Fix use-after-free race in
 sample_restore_put()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178863961739.1343052.3956576142204287970.git-patchwork-notify@kernel.org>
Date: Sat, 05 Sep 2026 20:20:17 +0000
References: <20260902193341.3668809-1-tariqt@nvidia.com>
In-Reply-To: <20260902193341.3668809-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 cjubran@nvidia.com, cmi@nvidia.com, gal@nvidia.com, kees@kernel.org,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, ozsh@nvidia.com, saeedm@nvidia.com, shshitrit@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 2 Sep 2026 22:33:41 +0300 you wrote:
> From: Carolina Jubran <cjubran@nvidia.com>
> 
> Concurrent teardown of TC sample rules sharing the same restore
> context may re-read restore->count after dropping restore_lock.
> At that point another thread may already have completed cleanup and
> freed the restore object.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5e: Fix use-after-free race in sample_restore_put()
    https://git.kernel.org/netdev/net/c/af3aef0245ab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


