Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A554E420898;
	Tue, 28 Jul 2026 09:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785231195; cv=none; b=j4i7yVQQ9rZD4zaF1iWUl+35iUIIJZbe09GXJutmjCecPDeNAjM5ypnjEPMVF4xLHWBS7nETrwOYs9oqKKfMsqUdJTPHlDewi4XO8ZlAYY0vPix/W4euiJnlZUhAEYGWXRiHZOAbrARdZPfHsA/TFE8xuYVrOldM61ZDc++Zg9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785231195; c=relaxed/simple;
	bh=vwQOIcrkLHtf1F/QTORo2k/3DPd3qqpQYbGXzLbPgo4=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Rh3UYi6NI3CcUv+OkGNT8BncKfLfAjq2C3Y/ldvrSbkq63+jSErA39SE4eNLc16Bo1u3rz/TKhEuBVtRt4+F8WaCDW2CKUDzx9XAvmDqwZSgFPJ0J/deD7jRBzGWYgCyDo5s5y8OUMPLv8ClK33Euu720RUk5G/kXU1b8JOua1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Eli4/Gfb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eli4/Gfb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 639481F000E9;
	Tue, 28 Jul 2026 09:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785231194;
	bh=yXVJCu5/Qamnw1N6lX0XHc3lf1HIt2Qzb3ANNzVYI10=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=Eli4/Gfb8dN6uNEc2tTx9P+9Rn+1Z6lkKlyIa0MU8oL+jUhx87OF1rFrx8taywWZc
	 0qoTW8JVZTC0Cqr4qFBKYaFDCct3sK2e6KZD4JK9dTi/jHbJFbv7ZUzuVAjPJrPFkz
	 db512HBkJ4MQYWcMUhLfaL1yty/5l3FGPun8NVXp/IH5o2GvstNdlYbrN/nL8ycOYi
	 05AQ7KDJa0Es0uNVoVt+HiogV9bFWbkT1rbCCoMPKwtHQEZC/HLUq1W/zbWiACdHRi
	 MgRQ6NzKQfAmXlVXJTgWSzwh8wVS7XosRjk8TSFqZthcm+kHYV4JZMlmvCwk+K5HGB
	 zVYAYavrnwTnA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93ADE380CFE5;
	Tue, 28 Jul 2026 09:32:40 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v1] net/smc: fix socket use-after-free during link
 group
 termination
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178523115913.1642152.18219172215531493703.git-patchwork-notify@kernel.org>
Date: Tue, 28 Jul 2026 09:32:39 +0000
References: <20260723105454.87016-1-xuanqiang.luo@linux.dev>
In-Reply-To: <20260723105454.87016-1-xuanqiang.luo@linux.dev>
To: luoxuanqiang <xuanqiang.luo@linux.dev>
Cc: netdev@vger.kernel.org, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, wenjia@linux.ibm.com,
 mjambigi@linux.ibm.com, tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, kgraul@linux.ibm.com, ubraun@linux.ibm.com,
 linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
 luoxuanqiang@kylinos.cn, stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Thu, 23 Jul 2026 18:54:54 +0800 you wrote:
> From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
> 
> __smc_lgr_terminate() drops conns_lock after finding a connection in
> lgr->conns_all, but before taking a reference on its socket. The connection
> is embedded in the socket, and its registration reference protects it only
> while the connection remains in the tree.
> 
> [...]

Here is the summary with links:
  - [net,v1] net/smc: fix socket use-after-free during link group termination
    https://git.kernel.org/netdev/net/c/f621d6ebeebb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


