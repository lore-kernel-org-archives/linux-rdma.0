Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795295860;
	b=4LWfZQGV8EAqUVMRwCg46djKp9KfTG0rNZ7tD3V05K+nef/dAIC0oTQ85KeydY8ojmxt
	 0oSWw3yOOwdALv8YNHF1bKuPugWvFprAKInNXFrchjOo24YyVYggNFwNh0yzRAT2Aj3GM
	 avA8l9IlHnknjxebTdxv05FiQevfxmdaDLbbPkFd95HfktQq1r9MAvXM9xn6ZMjGQEHZR
	 YKdwK3T5MCxCWcowQ+9gJ1FDwuN4DsjnrHXV31jBfmK/TYBdJ74wUbRR7i0vpWpG67nDC
	 rOdg+PbYHluIH0H6T7nc7bZvoSZR2QvMV3v+exGUtdy4wbglTOgh5TQLcoRuZYH1UHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795295860;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=lt4/3eo5Ro++Q5zvwoZ/Jj9GGpOvoIsabAfw4HW8+cg=;
	b=30Qi6bE8vJIExCjwgbuHPEa2YU2yz9uMioylW+ur0NPKOEXfw50EFkEYdedYX8a86HXW
	 MV6IoCXCAAIyxNN8iSbOWDTR/T6r6ZoiG3pRIH7V8q2LIyB9y0omFR9D8fQHAongxg1pE
	 dhw7BIuiff9RBwjbnDOKt1v9NlqxPcy/V9GHytO9jsSRYOPT9+1K6Hu2VljgXKxN1rJwY
	 ALIeq1zYVLqKrIpw1oq7QmopyP/PleE2HeMvawD0wSd7YIvq/1F6U4cQTkEJWgIBya6E1
	 TD/jCOgJMCvoUUhLusCJPGPUmuMMVOwezB27RBym3fBawdxJySfRSyCx/KypRoyv4/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JpC8NfqZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C950606A332;
	Sat, 21 Nov 2026 21:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JpC8NfqZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0D31F000C0;
	Sat, 21 Nov 2026 21:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795295860;
	bh=lt4/3eo5Ro++Q5zvwoZ/Jj9GGpOvoIsabAfw4HW8+cg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=JpC8NfqZMbRIt59udK2ewxT4+VudKYaomNTJjr3ivV8JDEcmcU/eFQBRE+Mt2zigO
	 lNpTgrmGOSVGY5JHqmgZPyg0TyKPvbXkLBMVqNkcatw0Q32KDxymmz1t1bHd029nGV
	 WWD9fUOyGPQ4wHz0MllqI70nkoh+VagD6j0Fc86E534CfAKmeJLjsrGJsStpaoPT+z
	 W5+wOJgsBn7NDEA3QipKDFchGE619+KQC71jQoWfEZ9nU2ttDcqxD8ykXxUjOTeZSJ
	 x/lsdqheW3s6LhbhSnw4R9PUUp3Iu1XCKF8QXcxq6HzKt96x0W9bPYqvv5n0cpl7du
	 MbHcr8A9wWOPw==
Subject: Re: [PATCH net v6 3/8] net: don't fragment decrypted skbs
From: netdev-bot+sashiko@kernel.org
To: toddfreed@meta.com
Cc: netdev@vger.kernel.org, davem@davemloft.net, andrew+netdev@lunn.ch,
 bjorn@kernel.org, borisp@nvidia.com, cratiu@nvidia.com,
 daniel.zahka@gmail.com, dsahern@kernel.org, dtatulea@nvidia.com,
 edumazet@kernel.org, idosch@nvidia.com, kuba@kernel.org,
 john.fastabend@gmail.com, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, pabeni@redhat.com, raeds@nvidia.com,
 rrameshbabu@nvidia.com, sd@queasysnail.net, saeedm@nvidia.com,
 shuah@kernel.org, horms@kernel.org, tariqt@nvidia.com, weiwan@google.com,
 willemdebruijn.kernel@gmail.com, stable@vger.kernel.org
Date: Sat, 21 Nov 2026 21:17:38 +0000
Message-ID: <179529585831.3135.9494126075737773087@kernel.org>
In-Reply-To: <20261117203137.804424-4-toddfreed@meta.com>
References: <20261117203137.804424-4-toddfreed@meta.com>
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

- [Low] In ip6_fragment() (net/ipv6/ip6_output.c), the new
  skb_is_decrypted() refusal at lines 932-939 runs before the…

--

net: don't fragment decrypted skbs

This patch makes ip_do_fragment() and ip6_fragment() refuse to fragment
skbs that have skb->decrypted set. Without it, the resulting fragments
can be sent out in cleartext. In ip6_fragment() the new check sits after
the existing too-big checks so that PMTUD for a local socket keeps
working.

[ ... ]

> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> index cb648c8394310..5b19683f08e03 100644
> --- a/net/ipv6/ip6_output.c
> +++ b/net/ipv6/ip6_output.c
> @@ -929,6 +929,15 @@ int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
>  			mtu = IPV6_MIN_MTU;
>  	}
>  
> +	/* PSP and TLS offload need the packet's L4 header, which non-initial
> +	 * fragments do not have. Checked after the too-big checks above,
> +	 * so that PMTUD for a local socket works.
> +	 */
> +	if (unlikely(skb_is_decrypted(skb))) {
> +		err = -EMSGSIZE;
> +		goto fail;
> +	}
> +
>  	if (np) {
>  		u32 frag_size = READ_ONCE(np->frag_size);

[Severity: Low]
This isn't a bug, but the commit message says:

  in ip6_fragment(), check skb->decrypted after the too-big checks, so
  that a local socket still gets PKT_TOOBIG for path mtu discovery.

ip6_fragment() has one more too-big check after the np->frag_size clamp,
and the new check now runs before it:

	if (mtu < hlen + sizeof(struct frag_hdr) + 8)
		goto fail_toobig;

A decrypted skb that would have reached this check is now dropped with
-EMSGSIZE, and no ICMPV6_PKT_TOOBIG is sent.

At this point mtu is at least IPV6_MIN_MTU. So the bypassed check only
fires with about 1265 bytes or more of unfragmentable extension headers,
and the packet is dropped in either case. The code comment says "the
too-big checks above", which is accurate.

Could the commit message say that the check comes after the ignore_df and
frag_max_size too-big checks, so that it matches the code?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261117203137.804424-1-toddfreed%40meta.com
