Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4E14E9C13;
	Thu, 15 Oct 2026 20:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792096664; cv=none; b=YpZjGUmgF+rsy2gWH0/XxhZXxwynQuS1AKO7hH+FHSsulLV6JvTzZPQS+fzBnyfNYliUWiMzSBh+21V61LlJby2r3l6ZrZBJ1OYzwk3vxHGgSrylq1ksxMn2m3nb29M18RYlfTqkvk75j/4f4GyR6Wv4I0cZOaGUM8NmQcmAdmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792096664; c=relaxed/simple;
	bh=EG4TRSJVOCquNKnKcyX6etbYRtxrpkDF1nyA67p2apE=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aL2X+UIFlCU4kgOuS7EbCBP8KzTQ6UfbB+ywUFRFNEQ+1/gQUXulwAw2+R7XMbapIOP+6+HxlmIQEfOKkvxy000kKwZPPGX8Gu8HBFjD8+gGuOcy+E/CmuUl8uyA/rizDEZuJ6ZFIuV0RG7Rkh5AtwAAOhBRoNBcksc7iaVfEkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eWojfMnS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eWojfMnS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0040C1F000C4;
	Thu, 15 Oct 2026 20:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792096658;
	bh=LnrcHInkIUuKUkiOYnqJIKEQ9+OaYUzCOIKcMOePBG0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=eWojfMnSj5DGu+TTKbPr8UY9uauI+nrAQkJSunKpAn4vfH7lifT6JqbZx/93mk2tx
	 4xbe2t/9EEcUSATKScdXRYH9xTzalNR6MmPP+DqDvL4h/BSTE8JKea2K//ksR0XPsy
	 UwIWsI0Vea6C+drnTyO0nAqdoqkfWMB3+PAqbz3xI9dNXS2R0HNLcM1MZ4hLIMBj2j
	 azOf5f/gDfwSe/2yspfaGMLTOXpnPzitR5CeZWoq94pSyR4z2ESk3pIXDB/mgd6VaC
	 /AS4tI5vwsVMbLTpCOMdPbZa7WbV7anLA53vfWLmXEnzmEcMMwSpWOq+wJPq2Ossbp
	 vTdVo3OTCU8pQ==
Subject: Re: [PATCH net-next v3 1/6] netmem: rename __get/__put_netmem() to
 get/put_net_iov()
From: netdev-bot+sashiko@kernel.org
To: almasrymina@google.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, bpf@vger.kernel.org, ayush.sawal@chelsio.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, tariqt@nvidia.com, horms@kernel.org,
 steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
 ncardwell@google.com, kuniyu@google.com, john.fastabend@gmail.com,
 sd@queasysnail.net, ebiggers@kernel.org, kees@kernel.org,
 aleksandr.loktionov@intel.com, petrm@nvidia.com, u.kleine-koenig@baylibre.com,
 j.raczynski@samsung.com, wang.zhan@smartx.com, willemb@google.com
Date: Thu, 15 Oct 2026 20:37:36 +0000
Message-ID: <179209665647.434549.4410094840593695015@kernel.org>
In-Reply-To: <20261014173945.373295-2-almasrymina@google.com>
References: <20261014173945.373295-2-almasrymina@google.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] At this commit, generic RX skb handling can reach the new
  else-branch DEBUG_NET_WARN_ON_ONCE(true) in get_net_iov()…
- [Low] The new kerneldoc for get_netmem()/put_netmem() in
  include/net/netmem.h says they always take or drop a non-pp backing…

--

netmem: rename __get/__put_netmem() to get/put_net_iov()

This commit renames __get_netmem()/__put_netmem() to get_net_iov() and
put_net_iov(), which now take a struct net_iov directly. It adds kerneldoc
for get_netmem()/put_netmem() and the new helpers. It also adds a
DEBUG_NET_WARN_ON_ONCE() for net_iov types that do not support non-pp
references.

> diff --git a/include/net/netmem.h b/include/net/netmem.h
> index 0cc8572f62caf..697d50c51a5ee 100644
> --- a/include/net/netmem.h
> +++ b/include/net/netmem.h
> @@ -399,21 +399,37 @@ static inline bool net_is_devmem_iov(const struct net_iov *niov)
>  }
>  #endif
>  
> -void __get_netmem(netmem_ref netmem);
> -void __put_netmem(netmem_ref netmem);
> +void get_net_iov(struct net_iov *niov);
> +void put_net_iov(struct net_iov *niov);
>  
> +/**
> + * get_netmem - acquire a non-page_pool reference on a netmem
> + * @netmem: netmem to reference
> + *
> + * Acquires a non-pp backing reference (page._refcount via get_page() or
> + * binding->ref via get_net_iov()) regardless of page_pool membership.
> + * Counterpart to put_netmem().
> + */

[Severity: Low]
Does this description hold for every net_iov type?

io_uring zcrx sets up its net_iovs with net_iov_init(..., NET_IOV_IOURING)
in io_uring/zcrx.c, so net_is_devmem_iov() returns false for them. For
those niovs, get_net_iov() and put_net_iov() don't change any refcount:

net/core/skbuff.c:get_net_iov() {
	if (net_is_devmem_iov(niov))
		net_devmem_get_net_iov(niov);
	else
		DEBUG_NET_WARN_ON_ONCE(true);
}

Without CONFIG_DEBUG_NET, the else branch compiles to
BUILD_BUG_ON_INVALID(). The same is true for every net_iov when
CONFIG_NET_DEVMEM=n.

The kerneldoc for get_net_iov() does mention the warning. get_netmem() is
the public entry point, though, and its kerneldoc doesn't mention this
limit.

The put_netmem() kerneldoc below uses the same wording. So does the commit
message:

    always acquiring or releasing a non-pp reference regardless of
    page_pool membership.

The skb_netmem_ref()/skb_netmem_unref() kerneldoc added later in the series
repeats the claim ("otherwise acquires a non-pp backing reference via
get_netmem()").

Could these comments say that only pages and devmem net_iovs get a
reference here?

>  static __always_inline void get_netmem(netmem_ref netmem)
>  {
>  	if (netmem_is_net_iov(netmem))
> -		__get_netmem(netmem);
> +		get_net_iov(netmem_to_net_iov(netmem));
>  	else
>  		get_page(netmem_to_page(netmem));
>  }

[ ... ]

> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index b25d8e2c9aafe..23a40e1ec2b15 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -7555,23 +7555,39 @@ bool csum_and_copy_from_iter_full(void *addr, size_t bytes,

[ ... ]

> +void get_net_iov(struct net_iov *niov)
>  {
> -	struct net_iov *niov = netmem_to_net_iov(netmem);
> -
>  	if (net_is_devmem_iov(niov))
> -		net_devmem_get_net_iov(netmem_to_net_iov(netmem));
> +		net_devmem_get_net_iov(niov);
> +	else
> +		DEBUG_NET_WARN_ON_ONCE(true);

[Severity: Medium]
At this point in the series, can generic RX skb handling hit this warning
for io_uring zcrx niovs?

packet_rcv() accepts unreadable skbs and clones shared ones, so the
original skb is left cloned. If pskb_expand_head() later runs on that skb,
for example from ___pskb_trim() or from skb_ensure_writable() in netfilter
or tc, it takes a reference on every frag:

pskb_expand_head()
  skb_frag_ref()
    __skb_frag_ref()
      get_netmem()
        get_net_iov()
          DEBUG_NET_WARN_ON_ONCE(true)

skb_release_data() then sets skb->pp_recycle = 0. The final free therefore
goes through put_netmem()->put_net_iov() and hits the same warning in
put_net_iov().

Before this patch, both calls were silent no-ops for these niovs. With
CONFIG_DEBUG_NET this gives a WARN splat, or a panic with panic_on_warn.
The trigger is RX traffic on a zcrx queue while a packet socket tap is
active.

The later patch in this series, "net: skbuff: replace __skb_frag_ref() with
symmetric skb_netmem_ref()", seems to fix this. It changes skb_frag_ref()
to use napi_pp_get_page() when pp_recycle is set. It also stops
skb_release_data() from clearing pp_recycle, and it carries pp_recycle
through the copy, split and segment paths.

Could the series be reordered so this warning can't be reached at
intermediate commits, which would help bisection?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261014173945.373295-1-almasrymina%40google.com
