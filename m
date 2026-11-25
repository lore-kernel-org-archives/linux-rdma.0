Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795615692;
	b=gcA3QJ55Pmx9ck21MCM6q8QZPhSThDZ7wtEvqEcU8yh6nq8F84eZx2C8Csm4xhUREthe
	 EpuexHMS9Vk+QlzBd1VOCVsFRbK5IymbRbiQFGRDdaxHs/0cy92dahMF+4X8K/+oRXliu
	 6HZLog1ZJD9nfGPXq2FILWTT6lZSdlJnZKmph06oyO6ZQkbuqjIrdHRBp8HtHMIezlLB0
	 O/1/a0GjCNgr2GM2pBIQPpv0vj043GzMtBf4x4iWm+LDN6+NV26yuhtLuvycokv22N23T
	 L6B+ZeDZq0e+F1XSI1SOSKKO+aaeUvcHF5ERxYHs9xtJrfRM9cYBBtovHgAmG7MzTkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795615692;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=GbCYvltGS1vRdk4BTywX1cFRzeLqxpYtIIQ6NGtFrHo=;
	b=qdaOb39Rh3cEKKCcNFSJap7c2HhNctojsGsR+zmt9tV7tbZM6X1FR4U4Itu5/4BPOMnk
	 9l5HwSEJ1+7E0V8vZV5gBOepal02qoKx1hv0tteaStvtJjo5oXqPsUXCWUrm6duAEqNZ+
	 UJxpvnugK4IWl4809SBzqhtbJLSV/qs+fLhl41lj6VeCRYSAnOE3gYoFNtXt/XRNyGsYh
	 EInnwCWOyxOX/VCY7hTHP4YsA4NKFgLQZB7NVtF7oP5+/7/JzAtMz5AJUVrQnvBpPwyfN
	 LYH3e7yfkOUlU39rCkmEbWKk7Ltl57buhATmqCeoDVhF1NgED1Fr8dbpydahetVgjtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lcUky5J+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54888606A330;
	Wed, 25 Nov 2026 14:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lcUky5J+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044041F000EE;
	Wed, 25 Nov 2026 14:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795615692;
	bh=GbCYvltGS1vRdk4BTywX1cFRzeLqxpYtIIQ6NGtFrHo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=lcUky5J+s0jy7UW7bD2rbLZA8pX/c+aFO4hFTKKx0I/eINjtUQgGBq6McJ4yd4Rtt
	 3V2T7tixw0W4JIXl+0mkn2mNz1x/zw1qQFSR7SQ/csaRKMGHHQRCuQqFc4ReKyVUZg
	 LVfooRSd5JRNR1tRGfkfeLp6YzocePh0aMx9FgHG0jlMYUwEQ0qQfpG3CsphoXkPy5
	 3WJ4kKAmOYCZfXv3kOA6vvAZ23tIYMaX+HUOxptJ4tz+nY7gdxEAukRcEfcPOf7sTW
	 /u7EW1PY3gbpUPJLIer+4gS8hUaoO/uqw2Oy33VsHDQEXXp9ozRqo5mLp8nZy1eAJR
	 6H6TlPTIyi20A==
Subject:
 Re: [PATCH net-next 04/15] page_pool: Let memory providers take back net_iovs
From: netdev-bot+sashiko@kernel.org
To: bjorn@kernel.org
Cc: magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
 john.fastabend@gmail.com, andrii@kernel.org, eddyz87@gmail.com,
 memxor@gmail.com, ilias.apalodimas@linaro.org, alexanderduyck@fb.com,
 saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 michael.chan@broadcom.com, pavan.chebbi@broadcom.com, corbet@lwn.net,
 shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
 stuclar@meta.com, sdf@fomichev.me, horms@kernel.org, martin.lau@linux.dev,
 almasrymina@google.com, song@kernel.org, yonghong.song@linux.dev,
 jolsa@kernel.org, emil@etsalapatis.com, ihor.solodrai@linux.dev,
 rdunlap@infradead.org, kernel-team@meta.com, dimitri.daskalakis1@gmail.com,
 bobbyeshleman@meta.com, mohsin.bashr@gmail.com, kees@kernel.org,
 leitao@debian.org, maxime.chevallier@bootlin.com, cuitao@kylinos.cn,
 vadim.fedorenko@linux.dev, mike.marciniszyn@gmail.com, kuniyu@google.com,
 jiayuan.chen@linux.dev, mkarsten@uwaterloo.ca, razor@blackwall.org,
 dw@davidwei.uk, asml.silence@gmail.com, linux-rdma@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2026 14:08:08 +0000
Message-ID: <179561568855.3135.15810206390695616800@kernel.org>
In-Reply-To: <20261124125654.183091-4-bjorn@kernel.org>
References: <20261124125654.183091-4-bjorn@kernel.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] page_pool_hand_off() in net/core/page_pool.c (lines 846-851)
  branches on netmem_is_net_iov() and casts the netmem down to a net_iov…
- [Low] The kernel-doc for memory_provider_ops.hand_off in
  include/net/page_pool/memory_provider.h (lines 39-44) says a false…

--

page_pool: Let memory providers take back net_iovs

This commit adds a hand_off() memory provider op and an mp_hand_off flag
in struct net_iov. When a net_iov is marked, its last put goes to the
provider instead of the page pool cache, and it stays charged to the
pool. The hook is wired into __page_pool_put_page(),
page_pool_drain_frag() and page_pool_free_frag(). The commit also adds a
provider-owned mp_state byte.

> diff --git a/include/net/page_pool/memory_provider.h b/include/net/page_pool/memory_provider.h
> index d52c7a450c68e..bfc2841582225 100644
> --- a/include/net/page_pool/memory_provider.h
> +++ b/include/net/page_pool/memory_provider.h
> @@ -36,6 +36,12 @@ enum mp_flags {
>  struct memory_provider_ops {
>  	netmem_ref (*alloc_netmems)(struct page_pool *pool, gfp_t gfp);
>  	bool (*release_netmem)(struct page_pool *pool, netmem_ref netmem);
> +	/* Takes a free net_iov marked mp_hand_off that stays charged to the
> +	 * pool; the provider puts it back later. Returns false to have the
> +	 * pool recycle it instead. Called where the pool puts netmem, outside
> +	 * hard IRQ context. Needed by providers that mark net_iovs.
> +	 */

[Severity: Low]

Is "Returns false to have the pool recycle it instead" true for every
caller?

In __page_pool_put_page() and page_pool_drain_frag(), a false return falls
through to recycling, because __page_pool_page_can_be_recycled() is always
true for a net_iov.

page_pool_destroy() calls page_pool_free_frag(). There, a false return
falls through to this:

	if (!netmem || page_pool_unref_netmem(netmem, drain_count) ||
	    page_pool_hand_off(pool, netmem))
		return;

	page_pool_return_netmem(pool, netmem);

For a provider pool, page_pool_return_netmem() calls
mp_ops->release_netmem() and bumps pages_state_release_cnt. The net_iov is
then taken out of the pool instead of being recycled. The commit message
says a hand-off provider wants to avoid exactly this.

The only provider in the series, xsk_sink_hand_off(), always returns true,
so nothing reaches this path today. Could the comment or
page_pool_free_frag() be changed so the two agree?

> +	bool (*hand_off)(struct page_pool *pool, netmem_ref netmem);
>  	int (*init)(struct page_pool *pool);
>  	void (*destroy)(struct page_pool *pool);
>  	int (*nl_fill)(void *mp_priv, struct sk_buff *rsp,
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 8a1ea21ccdcdc..200b0569b9fe7 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -840,6 +840,16 @@ static bool __page_pool_page_can_be_recycled(netmem_ref netmem)
>  		!page_is_pfmemalloc(netmem_to_page(netmem)));
>  }
>  
> +/* A memory provider takes back a free net_iov it marked, see
> + * &memory_provider_ops.hand_off
> + */
> +static bool page_pool_hand_off(struct page_pool *pool, netmem_ref netmem)
> +{
> +	return netmem_is_net_iov(netmem) &&
> +	       unlikely(netmem_to_net_iov(netmem)->mp_hand_off) &&
> +	       pool->mp_ops->hand_off(pool, netmem);
> +}

[Severity: Low]

This isn't a bug, but does this fit the netmem abstraction rules?
page_pool_hand_off() branches on netmem_is_net_iov() and downcasts with
netmem_to_net_iov() inside page_pool core. Before this patch, page_pool.c
had no netmem_to_net_iov() call.

The netmem_ref kernel-doc in include/net/netmem.h says:

  Downcasting netmem_ref via netmem_to_page() or netmem_to_net_iov() in
  callers is not allowed unless a code path strictly requires a specific
  backing type ... In such cases, add a netmem helper here that handles
  both page and net_iov cases

Documentation/networking/netmem.rst also says core code should avoid
per-netmem-type branching. It also says new code must not assume that
using a memory provider implies net_iov memory.

The mp_hand_off flag lives in struct net_iov, and the hand_off() contract
only covers net_iovs. So a provider that hands out page-backed netmems
can't use this hook.

Would a netmem.h helper fit better here? For example, something like
netmem_mp_hand_off() that returns false for pages and is called from
page_pool core.

> +
>  /* If the page refcnt == 1, this will try to recycle the page.
>   * If pool->dma_sync is set, we'll try to sync the DMA area for
>   * the configured size min(dma_sync_size, pool->max_len).

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261124112707.118678-1-bjorn%40kernel.org
