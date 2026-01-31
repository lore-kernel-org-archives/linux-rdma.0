Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9D78C1F;
	Sat, 31 Jan 2026 03:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769830813; cv=none; b=fFmuHX/gUZwTDPvhtGpB5XJ4HoCm6ZF3WKGBfcwUnH/R+2Mc6ZthuYVfL8Ki18VWqDO6hHzKHHOKMFp1+gvJj+T6XVfQEM+YCCGOVVFcfb3qTy4lIB8djA9oIxWimGRn4Is5+VzLqcsKVsah5ToiSvnXU05H73IrD+ArkO4Sfmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769830813; c=relaxed/simple;
	bh=SPa2ky00MTlgAVW6CPBZYtqiEy57G6865mcHfn5Fva4=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=GHjTfJDCWI3dADeupbBZaDztd8osojiHOtoCSgU8S2Pp6vAoakKgDHYf9RRTVCcIB9NGGZfz4aXPR25FQneWUvJH8+BLTuoOXmICiMGV2GkCGI1HQwKK8r3aWcPYHrot3HkEnDZqVz/lCu1gw0pk0/D/IFMLXvqL2p/FKiC7vpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hl3Q32je; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hl3Q32je"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D19C4CEF1;
	Sat, 31 Jan 2026 03:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769830812;
	bh=SPa2ky00MTlgAVW6CPBZYtqiEy57G6865mcHfn5Fva4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=hl3Q32jesSmbR2hXuuoqdTRzotmtlIy8xD0XeqEbyuc9r4NTXzG/9oaF/N5Kwu5fv
	 MUoKS06t3AlPtYepLp0PSJunGKx888rIwCL+4lV7WSO4YOJDSOf71G9CtDHgtBx+D9
	 cKkDpPzvSdZdB/f3JUfhfmv/vJeHPwGI3KVZGEa9SsnjNbI9lHWJJuv431vHpNyCW3
	 RzujlV7YGmCYVQxuTg2KY7b/QkinWmBPtCIGwT9dr5y7+3dcEMNPg5K9yP5/7abpAS
	 wW3Er7XEk4OslLCDAE50UnOx+b0wfPh9yLjn4gJBhaYxFp7our83XPoZjkZrF2+z/D
	 5idM+zmOLWGMw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 11B0B380CFFF;
	Sat, 31 Jan 2026 03:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] Revert "net/smc: Introduce TCP ULP support"
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <176983080486.3985311.3826362708256060586.git-patchwork-notify@kernel.org>
Date: Sat, 31 Jan 2026 03:40:04 +0000
References: <20260128055452.98251-1-alibuda@linux.alibaba.com>
In-Reply-To: <20260128055452.98251-1-alibuda@linux.alibaba.com>
To: D. Wythe <alibuda@linux.alibaba.com>
Cc: davem@davemloft.net, dust.li@linux.alibaba.com, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, sidraya@linux.ibm.com,
 wenjia@linux.ibm.com, mjambigi@linux.ibm.com, horms@kernel.org,
 tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-s390@vger.kernel.org, netdev@vger.kernel.org,
 oliver.yang@linux.alibaba.com, viro@zeniv.linux.org.uk

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 28 Jan 2026 13:54:52 +0800 you wrote:
> This reverts commit d7cd421da9da2cc7b4d25b8537f66db5c8331c40.
> 
> As reported by Al Viro, the TCP ULP support for SMC is fundamentally
> broken. The implementation attempts to convert an active TCP socket
> into an SMC socket by modifying the underlying `struct file`, dentry,
> and inode in-place, which violates core VFS invariants that assume
> these structures are immutable for an open file, creating a risk of
> use after free errors and general system instability.
> 
> [...]

Here is the summary with links:
  - [net] Revert "net/smc: Introduce TCP ULP support"
    https://git.kernel.org/netdev/net-next/c/df31a6b0a305

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


