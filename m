Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147BF49DBBE;
	Mon, 12 Oct 2026 16:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791822008; cv=none; b=eEGXCF+88nO/GaSrCZ8OLxx7AN1E1WUFhjdsC55GnHAo2uCeaN/9w+tbmnAzBnDpcGYg59N0NsVh7a9Q60B9zpz2drTG1I5WepcJ2WndVEDZKUk4L+uircnI99EOVtMxpt6xAWduD0FE0KDjUvEClTh6RiCjkwe0JSlEeNUPSpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791822008; c=relaxed/simple;
	bh=oO/9OvzsNv9yAEOKpmwFo1I13eXsovRVaqug9NVsDlY=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=btCvQi9ejkzc4uv6pB2wx6qaTwgFr4HuHOWC+bAMomb/Vz1Ltux4z1mRi3jSxjMxLf5Vr+Vl6SeCIv4MsubG41ccvsGbzZqMRy94FaXVYeiChmSBjGrwNv2uJzKKnVwWhNJ90nAhvIJxcp00ILA3qifOerERackkZGi+ok71RSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dx9HqwAJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dx9HqwAJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD98C1F0089B;
	Mon, 12 Oct 2026 16:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791822006;
	bh=zhqAnRnsa47xjlXiUf6w9ICr6x9CkLhuiI0AeQO0imY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=dx9HqwAJK7CDfjq+thP0ST8ALc2PppDAfkXOXnpPQ0qf14OMbnWr0tZXpjTU6O/Z1
	 BVeFr8zHkzxsFY2d03e/3tFtw72PxXPxYNe3nqIP6EuefV9iWo2L6qiwX4DOW2C4Xo
	 0jHcgQp5s1UMwlEP+dJEKeY/WDonhx+JlyYWEtaMo8Nz52lpBPJQa/WjYuRmxp2PVk
	 TNpR+dxYJP13kwOuefyeGjnR6T3yy2IGd3rTFvFjiizuDXUSE6nFkScEH3Z+HeZVLp
	 ekSd1q3chGDZ9KNagpq3AFx2Qii5xpNTvK/eTxhijdFM5Mgx8rfskOpIULwjY63LF1
	 xqvCCiCm8TEiA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B44A73924A5F;
	Mon, 12 Oct 2026 16:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v4 0/2] net/rds: RDMA-CM event handler fixes for
 non-IB
 devices
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179182200552.3524695.4623096369791034138.git-patchwork-notify@kernel.org>
Date: Mon, 12 Oct 2026 16:20:05 +0000
References: <20261003163408.250568-1-achender@kernel.org>
In-Reply-To: <20261003163408.250568-1-achender@kernel.org>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org,
 ljp1205831794@gmail.com, henrymei@tencent.com

Hello:

This series was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Sat,  3 Oct 2026 09:34:06 -0700 you wrote:
> Hi all,
> 
> This is v4 of Aohan Mei's fix for the uninitialized transport pointer
> in the RDMA-CM event handler (v1 at [1], v2 at [2], v3 at [3]), now a
> two-patch set.
> 
>   Patch 1 is the fix itself.  v3 only rejected a connect request
>   arriving on a non-IB device; the active side can bind an id to one
>   as well, and resolving a route on an iWARP id leaves
>   cm_id->route.path_rec unset, which the ROUTE_RESOLVED case
>   dereferences.  Such a connection is now dropped at ADDR_RESOLVED
>   instead of resolving a route.
> 
> [...]

Here is the summary with links:
  - [net,v4,1/2] net: rds: fix uninitialized trans dereference in CM event handler
    https://git.kernel.org/netdev/net/c/492ba6ac1b1f
  - [net,v4,2/2] net/rds: don't let the rdma_cm destroy an id RDS still owns on route failure
    https://git.kernel.org/netdev/net/c/98d446b7c013

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


