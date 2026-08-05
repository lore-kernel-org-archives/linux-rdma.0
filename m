Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90721D5CFE;
	Wed,  5 Aug 2026 01:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785892252; cv=none; b=tCOSLN3bDkpDtNG9EsFeeiuxZ6XxP9WOdPEk5wjxewojPm/6B8RiXgq/2VZYLeCcekyEXFqkqf2LAtFtuMjGy8fUD2N5GWciFykl+dz+ElZ28R0Ph5kxTv/0DHMWI8QqNAGHbAEdu3Q6t1h0+NpR2SiLk4q4M2pxo6tGNtY3oTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785892252; c=relaxed/simple;
	bh=5CwxZAe2MKYIfJwQo3tXDItu/jezIG8yeYlTQyRKzzM=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=YM731uhdIGunXtundgI/Q8i5q345clPRY19lDE2vmFlXJ0/geq3Xg1XXXjC8RJgMk7Ob709FDp8xxNmRqYhRfkenUq23METzy+uXt8ppMp7kBf1ohZPKxaLVyXUYO8XgPr6RofmPL3HIdSmJQMUVqwSpvwsP5U9driAn6u7TWyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TcXgD3wQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TcXgD3wQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511CE1F000E9;
	Wed,  5 Aug 2026 01:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785892251;
	bh=lJYjlK2i847vNY27tr3wThD4jqGfP/jIJrvB91fDsH8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=TcXgD3wQGiBwfKeJMe9unw5DREQvPn9Dcp+9BcswiOuEIBjWOQe4rLk/SoELjxXoS
	 VOaUb/rbpBAkUYK8prjNAt7TU1thAeU8PPbJjvHEaBmqU1dKnek4LW3NAJUUhTzY8G
	 4FuRCFBr8l6ERQy9Pj+oBUH9skiCJAiHZC3yvxHbm7BfaROoJ6xTNuiwO+BsntleLx
	 eofuqOQ76OXYzeQRp/qTs8cFDkz+jixcmR/agidxk47Q6bepH/ZuXBL1p052MnjmIi
	 Gjd8dudgEDq2NNy+d4N0ITeMdmmRrd3taYycEv8E0VnZCrtmYpXruCz6XhBEQ82Jf0
	 cRLgbnwd+9qnw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0B2A3926663;
	Wed,  5 Aug 2026 01:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v4 0/4] net/rds: Bug fix ports
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178589221139.3859963.4972940145974971539.git-patchwork-notify@kernel.org>
Date: Wed, 05 Aug 2026 01:10:11 +0000
References: <20260730041629.3512480-1-achender@kernel.org>
In-Reply-To: <20260730041629.3512480-1-achender@kernel.org>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, jhubbard@nvidia.com,
 leon@kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 29 Jul 2026 21:16:25 -0700 you wrote:
> Hi all,
> 
> This is a small set of net/rds bug fixes and ports from uek to upstream
> rds.  I've been working on extending the rds selftest case, but need to
> stabilize a few more bugs and the first few fall into net with Fixes
> tags. I decided to leverage fable for this set and I thought the ports we
> clean and well explained.
> 
> [...]

Here is the summary with links:
  - [net,v4,1/4] net/rds: don't use unpin_user_pages_dirty_lock() from atomic context
    https://git.kernel.org/netdev/net-next/c/d100966325f7
  - [net,v4,2/4] net/rds: hold the socket while an rds_mr references it
    https://git.kernel.org/netdev/net-next/c/9079adef042c
  - [net,v4,3/4] net/rds: fix rds_message leak in the rds_send_xmit() drop path
    https://git.kernel.org/netdev/net-next/c/eb8a59a17f4a
  - [net,v4,4/4] net/rds: unpin MR pages with unpin_user_pages_dirty_lock()
    https://git.kernel.org/netdev/net-next/c/a507023e6ff1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


