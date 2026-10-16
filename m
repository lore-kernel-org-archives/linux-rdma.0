Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC734FD788;
	Fri, 16 Oct 2026 00:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792108816; cv=none; b=vAY5kzIlch49JZgAZtWr9vMAscHR6LT8AkcnL8vOrrCbgud/41jHIHxeAonJe1AzyvjyuIpv5qMpEnxuu0Le92pYbim6gKMEPccHUxLp4exkjkfvluo1i+RCWe9n39yPhfg8APSIRcGHZT7ThjoNHWP77M5p4wO6c71b4KOpwdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792108816; c=relaxed/simple;
	bh=cdExuXXo9FKQrz0RBdXCalvIvyGrwJ87Ga+i0US+HYA=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=F8sJVyATxlEm1j56+BjL7d0eUh5Ew0fkK1tyyeP3u3ZUgEHn++uvcrZ8yKm4Gp5StatLDKM7wy5kqwtHRcEbunzMM6uGKU+XqdTDoMP7ScTdnUg6XV8x7ADPo9RdjjOPU8lxn3WeM0V906RhFNXoqOmY7D3O8gNachHGjB0fjmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TAiocvtC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TAiocvtC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818FB1F000C6;
	Fri, 16 Oct 2026 00:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792108814;
	bh=ex47Nr/zvn6kd9rPY/ZRrK6vE8/oo+5Rna1nqrVO/Wo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=TAiocvtCJw4tjcNWBaW/mNsoi+cQHXcK+OIl4xh7G8p2ktlRfjOXFjeTyz1rgRpPA
	 YFvFzPc3JWDegPSVaNkf3RQ9vxHPC/YxuF86ELBd5Iu7ogQqFETsSqWkc5YjMH8Axr
	 UEJl7x03B8MNuiw6jlAeatpeJcaMGmVrZZtbOFeasL/iRmUkbX3y1Iq47H80V1OhZf
	 82BO2HSYnSjTE0LVMcy0iNhYWMzA+EOlQrEnFFQZbd5jrIn21GZIZ3UCA1yquJMhS7
	 QlnjyTS6UJo49z+6HhneRQGDa0uPv0YVAZLtZVpd9Iz1R98d5yymdtoaiFa5Z8+PIm
	 Wszt4BzYcP7hg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 774473808209;
	Fri, 16 Oct 2026 00:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net/smc: hold a reference on net_device returned by
 pnet_find_base_ndev()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179210881301.4163852.1185798622656959268.git-patchwork-notify@kernel.org>
Date: Fri, 16 Oct 2026 00:00:13 +0000
References: <20261007040009.137568-1-atharva.a.vartak@gmail.com>
In-Reply-To: <20261007040009.137568-1-atharva.a.vartak@gmail.com>
To: Atharva Vartak <atharva.a.vartak@gmail.com>
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
 sidraya@linux.ibm.com, mjambigi@linux.ibm.com, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, ubraun@linux.ibm.com,
 hwippel@linux.ibm.com, linux-rdma@vger.kernel.org,
 linux-s390@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, w@1wt.eu

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  7 Oct 2026 00:00:09 -0400 you wrote:
> pnet_find_base_ndev() resolves the base net_device for stacked devices
> under RTNL, then drops the lock and returns the raw pointer without
> taking a reference.  All three callers dereference the pointer after
> RTNL has been released, creating a use-after-free window if the device
> is concurrently unregistered.
> 
> Take a reference with netdev_hold() before dropping RTNL and add the
> matching netdev_put() in every return path of the three callers:
> 
> [...]

Here is the summary with links:
  - [v2] net/smc: hold a reference on net_device returned by pnet_find_base_ndev()
    https://git.kernel.org/netdev/net-next/c/e6435b2cc5fd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


