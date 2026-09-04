Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF6140B0ED;
	Fri,  4 Sep 2026 04:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788497221; cv=none; b=fc/t++N4p2OKqsPgTj9RV7dKH63vE363QyHQll3BWZHmXkrJTQnAQ3uVfFfKH2noMAhYK1gYMxw6gFdP/wxfd0vEN6y2UTFhb3kRP9RuphoUo3QSfzS5JB1fuy60gDaWSoMh3lPsiTHG4ZXPFuZ9mH0XWkRJ/HorXVbMDxtOHq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788497221; c=relaxed/simple;
	bh=QkU1BrWVOjjBdHZ+RatriKqA4LlT4FCvzA78OHCYaQQ=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NvxD/CXC6Ht1s3CXsHAVjgyfpJmr3Tp8wzoKZUfTcESA8RQEf/ug3CWJvGsIDhKJMqUTL1KvctLncVX2ENIme4k7YKMZiXI0SX8sg+5t4A10k6h7xY9+SGLSZJ7Eg6TiY5v55BUoO3jxjecevy0ERcyyhhWfmO8VN7SKkYHDJTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lUDyey98; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lUDyey98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998491F00AC4;
	Fri,  4 Sep 2026 04:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788497211;
	bh=Q/imD5hrhj+44J2mmqTh5W2E7CstdM2nPNEbQ2e/oiw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=lUDyey98lg2fP5xPpz/wgph3T4iqAy9/4rk0P5LZORotU2G1uq0siZWMsPfRLpoCq
	 dBHYpySVoCGrCZYN74P6Vn9JBlkLs96G9yMftSQ26Ha3hqN36wkMTt4d4ysQck4fKH
	 OEhedjZLLUMJCjvmsUIR1vunm3PIHUkM8lVosupHWP7c6kiZsvW57HFJU+1JAVv/XJ
	 Slr1G7Ng7bqFkJ41YMpQNYlNg4FOEC/8uOj35CM4+p9nFavy0zV9mnPsy5+hx/4up8
	 yZbE9qM5MyWxBmtlY8kqB3vDo9753sAagZKp3H7HBihFumEBB8tBaC+VExiadPkR+A
	 9oWviu5E5bK5A==
Subject: Re: [PATCH net-next v3 08/13] net: mana: do not bail out of
 mana_detach on dealloc failure
From: netdev-bot+sashiko@kernel.org
To: longli@microsoft.com
Cc: kotaranov@microsoft.com, kuba@kernel.org, davem@davemloft.net,
 pabeni@redhat.com, edumazet@google.com, andrew+netdev@lunn.ch, jgg@ziepe.ca,
 leon@kernel.org, haiyangz@microsoft.com, kys@microsoft.com,
 wei.liu@kernel.org, decui@microsoft.com, shradhagupta@linux.microsoft.com,
 horms@kernel.org, ernis@linux.microsoft.com, stephen@networkplumber.org,
 shirazsaleem@microsoft.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Fri, 04 Sep 2026 04:46:50 +0000
Message-ID: <178849721018.4131868.4122826158754695838@kernel.org>
In-Reply-To: <20260901014442.2945689-9-longli@microsoft.com>
References: <20260901014442.2945689-9-longli@microsoft.com>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 0 · Low: 1

- [Low] Commit-message framing concern: the reviewed patch removes the
  `return err` after `mana_dealloc_queues()` in `mana_detach()`…

--

net: mana: do not bail out of mana_detach on dealloc failure

This removes the early return that mana_detach() took when
mana_dealloc_queues() returned an error, so that netif_device_detach()
and mana_cleanup_port_context() always run. The error is now only
logged.

> mana_detach() sets port_is_up = false before calling
> mana_dealloc_queues(). If that call were to fail and return early,
> netif_device_detach() and mana_cleanup_port_context() are skipped,
> leaving the port in an inconsistent state where port_is_up is false but
> netif_device_present() still returns true.
>
> With the ethtool, MTU and XDP paths converted to pre-allocate and swap,
> the callers that reach this code with from_close == false are the TX
> timeout reset handler and the suspend path. For the reset handler the
> inconsistent state is fatal: its mana_detach() would overwrite
> port_st_save with false, so the following mana_attach() skips queue
> allocation and leaves the port permanently dead. For suspend it leaves
> the port context allocated across the transition.

[Severity: Low]
This isn't a bug in the code, but could the description of the reset
handler case be toned down, since the "permanently dead" port does not
look reachable?

mana_dealloc_queues() has exactly one non-zero return:

drivers/net/ethernet/microsoft/mana/mana_en.c:mana_dealloc_queues() {
	if (apc->port_is_up)
		return -EINVAL;
	...
}

and mana_detach() clears that flag two statements before the call:

drivers/net/ethernet/microsoft/mana/mana_en.c:mana_detach() {
	apc->port_st_save = apc->port_is_up;
	apc->port_is_up = false;
	...
	if (apc->port_st_save) {
		err = mana_dealloc_queues(ndev);
	...
}

Every other error inside mana_dealloc_queues(), such as the
mana_disable_vport_rx() failure, is only logged and the function ends with
an unconditional return 0.

The last paragraph does say "in practice cannot fail here since port_is_up
is already false", and the text uses "were to fail" / "would overwrite",
so the conditional framing is already there. Would it read better to state
up front that this is a robustness cleanup for an unreachable branch,
rather than describing a fatal reset-handler outcome first?

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index af2fdd5e876eb..5c5d1edd20f84 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -4594,10 +4594,8 @@ int mana_detach(struct net_device *ndev, bool from_close)
>  
>  	if (apc->port_st_save) {
>  		err = mana_dealloc_queues(ndev);
> -		if (err) {
> +		if (err)
>  			netdev_err(ndev, "%s failed to deallocate queues: %d\n", __func__, err);
> -			return err;
> -		}
>  	}
>  
>  	if (!from_close) {

The code change itself looks fine; with port_is_up already false the
deleted return was dead code, so no live caller changes behaviour here.
Consistent with that, there is no Fixes: tag on the patch.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260901014442.2945689-1-longli%40microsoft.com
