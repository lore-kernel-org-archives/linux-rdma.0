Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51953A6F1A;
	Mon,  6 Jul 2026 11:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783335629; cv=none; b=W+FquI9U5zysQofb9DX99n/JAnwoGWtLUPyYVXcgccU8WgUFDa7ufbZypytos5KosBObdwE3ACwUqir/Yxcznrf7we/cdb6CGt1kiyLMNaTkeuQ1D9LlBsXMATzoh/TwRewwIbD1JC2gZQAO7cGY5zoZnTxUvMV9Vwf4RMpLEGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783335629; c=relaxed/simple;
	bh=9NE9im4wJR7qAsR8878UQoNkn+kFS1EWide76Zi/MW0=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=CL5cdAO69+fLWHCJaVVn4LJY0GrQfz0YD/CaUFl5/AQhzQ9+w4XHjlrLxyyDzTvaUhQCFup71Px7C5xtQ+6XcrahG+trv5pwZ7ymjLeF4wlmI3swhPpw9LM0Hgse0uJNlpb73Witc6oNfot/ZymfMbgr2HyB7M02Y5RNIcHnUNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KfUM2rTd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KfUM2rTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082FF1F000E9;
	Mon,  6 Jul 2026 11:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783335627;
	bh=LWYxhLz7Wktw2+hz9+SkbYBDVl0Ct3OosWMIW+3lDmM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=KfUM2rTdzHvqLH5A/Qf7UvXe6G8E9j089g3MmVE8/17TxyIp5XaFyWVWKp2vtwXOW
	 CXOzGRIufApQbxMjyUI5oe47QimQs8+0vHy7tm9dSmg4aaOMNX6r4+Jf/b2kSWs+/R
	 IGtE2//DlxGS4PfQYk0EPV/uaQIKkkfrL5t3ygyVThy7YLs8D0iZGs4Ju+k7KOJIzo
	 hugzI92DZB4udeJQS31/8tsa6+5kU0i5D1UPwuskoO0wHXocZDbNBimVI+7UbALygi
	 Ctdf/SvpriNAFoR461O0AZlFs+kUC3SAbemS5Ec/Pe3BdEUBHJh9KSa7uXaRL/teCM
	 jrFjgCm8MWZjg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D09773ABD2A5;
	Mon,  6 Jul 2026 11:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net/smc: fix UAF in smc_cdc_rx_handler() by
 pinning
 the socket
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178333560738.503923.14185605009995781053.git-patchwork-notify@kernel.org>
Date: Mon, 06 Jul 2026 11:00:07 +0000
References: <20260630183227.2044998-1-xmei5@asu.edu>
In-Reply-To: <20260630183227.2044998-1-xmei5@asu.edu>
To: Xiang Mei <xmei5@asu.edu>
Cc: sidraya@linux.ibm.com, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, wenjia@linux.ibm.com, mjambigi@linux.ibm.com,
 tonylu@linux.alibaba.com, guwen@linux.alibaba.com, netdev@vger.kernel.org,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, hwippel@linux.ibm.com, linux-rdma@vger.kernel.org,
 linux-s390@vger.kernel.org, bestswngs@gmail.com

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 30 Jun 2026 11:32:27 -0700 you wrote:
> smc_cdc_rx_handler() looks up the connection by token under the link
> group's conns_lock, drops the lock, and then dereferences conn and the
> smc_sock derived from it, ending in sock_hold(&smc->sk) inside
> smc_cdc_msg_recv(). No reference is held across the lock release.
> 
> The only reference pinning the socket while the connection is
> discoverable in the link group is taken in smc_lgr_register_conn()
> (sock_hold) and dropped in __smc_lgr_unregister_conn() (sock_put), both
> under conns_lock. Once the handler drops conns_lock, a concurrent
> close() -> smc_release() -> smc_conn_free() -> smc_lgr_unregister_conn()
> can drop that reference and free the smc_sock, so the handler's later
> sock_hold() runs on freed memory:
> 
> [...]

Here is the summary with links:
  - [net,v2] net/smc: fix UAF in smc_cdc_rx_handler() by pinning the socket
    https://git.kernel.org/netdev/net/c/9d160b35cc34

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


