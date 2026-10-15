Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42EF58E2BA;
	Thu, 15 Oct 2026 20:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792096669; cv=none; b=ulE0HjS5J8+6cbdLA9Ofl1aP3AGPhdG2mnWDCG9HDMoE5tVH412EorWKXNDh2FOplrH+aXvJBEkBdy1KxL1XQnQwO96rX25gUMWgMmJ1/FBs38dUvKCjKylaWaDV1efH3bmIKO5zbYlUoC3pwG1j49zKRsuwIOAJw5r2JBRVtHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792096669; c=relaxed/simple;
	bh=/9EOvdxzHRtiXIwvOcxYC554zJzwlbC2TwkzL4yMq0o=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SqCmPdCKy+PClJOtTKIn0qjBaB4FbxXR6y4xq1N7ivKFU5O0dAHtXInUrf8H1KNs2K6SfmwiALgB9hHodMgEENainEdZcEICr9YuZ6a8kJDowFdJ/jufC3zz96zHQzckg1il0cad5L4C+CyhK66UW+IzoPdxIwCNEUf0nqLuOAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DbW8iILu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DbW8iILu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F561F000C4;
	Thu, 15 Oct 2026 20:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792096666;
	bh=z7ZmkhH9JYzNFrXILASZ7xZ3lAAHTbbGP6iDfmetY9o=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=DbW8iILuHxSVD5zmr/NhveSPXDVUwA68ISBGeKYyuwaupWmCpyLYmj1hkurU9E4+A
	 L1259GhqyMKY56PzAHzlLnoLNzirv6bRiMnFXsgOPQN8L6ZlIL1qzBU7EBL0P0z0sd
	 6nwPF6skttBewQOrtG4tsb6xmiBs4QnZvV+69SR/pos84ePCD1JCUlsj6dF1BRTIgR
	 C7Heq4kuRwLnPSb9zzARNmFmHV4Ph9FzmoI3LdxMt8u/AnuVCdr1IttyU8eJ2j6ig4
	 vzlpTZmHv3qxTvAd4dTVPk7WMFe26pq7CK4mOlu/y1/sgqp+EJQbRCcEbnnljTBp+q
	 ITQNV/M5mzJsA==
Subject: Re: [PATCH net-next v3 6/6] net: kunit: test netmem, page_pool, and
 skb frag refcounting
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
Date: Thu, 15 Oct 2026 20:37:44 +0000
Message-ID: <179209666474.434549.10472911839946149869@kernel.org>
In-Reply-To: <20261014173945.373295-7-almasrymina@google.com>
References: <20261014173945.373295-7-almasrymina@google.com>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The new netmem refcount KUnit cases do not register deferred
  cleanup (for example with kunit_add_action_or_reset()).

--

net: kunit: test netmem, page_pool, and skb frag refcounting

This commit adds KUnit cases to net/core/net_test.c. They check that page
refcounts, devmem binding refs and pp_ref_count stay balanced for regular
pages, page_pool pages and devmem net_iovs across many skb helpers. It
also exports skb_shift() via EXPORT_SYMBOL_IF_KUNIT() so the test links
when built as a module.

> diff --git a/net/core/net_test.c b/net/core/net_test.c
> index bc2ef7612e7df..2bb01430a89f7 100644
> --- a/net/core/net_test.c
> +++ b/net/core/net_test.c
> @@ -457,10 +457,1231 @@ static void ip_tunnel_flags_test_run(struct kunit *test)

[ ... ]

> +#ifdef CONFIG_INET
> +static void netmem_ref_test_tcp_devmem_recv(struct kunit *test)
> +{

[ ... ]

> +	pool = page_pool_create(&pp_params);
> +	if (IS_ERR(pool)) {
> +		sock->sk->sk_state = TCP_CLOSE;
> +		sock_release(sock);
> +		KUNIT_ASSERT_FALSE(test, IS_ERR(pool));
> +	}
> +
> +	ret = percpu_ref_init(&binding.ref, dummy_percpu_ref_release,
> +			      PERCPU_REF_INIT_ATOMIC, GFP_KERNEL);
> +	if (ret) {
> +		page_pool_destroy(pool);
> +		sock->sk->sk_state = TCP_CLOSE;
> +		sock_release(sock);
> +		KUNIT_ASSERT_EQ(test, ret, 0);
> +	}

[ ... ]

> +	/* 1. Receive via tcp_recvmsg_dmabuf -> SO_DEVMEM_DONTNEED release */
> +	skb = alloc_skb(0, GFP_KERNEL);
> +	KUNIT_ASSERT_NOT_NULL(test, skb);

[ ... ]

> +	ret = kernel_recvmsg(sock, &msg, &iov, 0, 64,
> +			     MSG_SOCK_DEVMEM | MSG_DONTWAIT);
> +	KUNIT_ASSERT_EQ(test, ret, 64);

[Severity: Low]

If this KUNIT_ASSERT_EQ() fails, KUnit aborts the case and the teardown at
the end of netmem_ref_test_tcp_devmem_recv() never runs. Does that leak
the kernel TCP socket, the page_pool and the percpu_ref data?

The page_pool_create() and percpu_ref_init() failure paths above call
sock_release() and page_pool_destroy() before they assert. The later
checks do not:

    KUNIT_ASSERT_NOT_NULL(test, skb);
    ...
    KUNIT_ASSERT_EQ(test, ret, 64);

This applies to both the first and the second receive. On those paths the
socket's receive queue or sk_user_frags may still point at the on-stack
niov.

The other new cases follow the same pattern:

netmem_ref_test_page() leaks the page if alloc_skb() fails.

netmem_ref_test_pp_page() and netmem_ref_test_skb_segment() leak the
pool, its pages, reg_page and the percpu_ref if any of their
KUNIT_ASSERT_*() checks trip.

Could the teardown be registered with kunit_add_action_or_reset() so it
also runs when an assertion fails?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261014173945.373295-1-almasrymina%40google.com
