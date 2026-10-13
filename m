Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B18437187B;
	Tue, 13 Oct 2026 08:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791880501; cv=none; b=cx76gX7INepW8lrURLDe9RAKGjpMKClcT7EmhT7ifFDtlr8de0IjGjBb65QZuhfUaKuCDgIO+4nIvliXfjp38noVEhjCXGhLrB3lvmWMe67myq/Rp6/e+fkW+O2zs+DtGS/qWHAonB+F5pcnbrqZnyRHYeIzon1B7i9nIw6mfeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791880501; c=relaxed/simple;
	bh=L0KEnA9wUaxKzAGhOm5OumPcQcwrEh3rOjNVOAg6FeU=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oLbRdDoOzf7hkInffAUAB/qyEbnVv+H0IxntpvB+1xhbA2qCwDxHfjWU79ZnIoPL6ZAJdPosomNzLUFruZwgSIepc4XSirZjUrcaDUpcycZd7JJeToXD56TYWpvp/A1YNTM9PF6mMdmm/syVvXowoTWllb3D4vGKp4XJE8Z3ZXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gMWW3uFW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gMWW3uFW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82DAC1F00898;
	Tue, 13 Oct 2026 08:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791880499;
	bh=4pECVQoEhG1R3WDUdFD3/QePU912uEG/1AhCxV7n1PE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=gMWW3uFWCF5xEuoQirVZ8lPXpcBiZN63VGjKFqyfbQHT/0mr62hh+NRs8USuKmzG4
	 XqhceX0kblJbxb0uS/CYHxv2ojbno5VdQxuDxffiRWw7cUiViqqe7dvsou2RC0/UUb
	 a2fRYvzgw88BMPsb5rKEVip21lsE9UQwaz6KZpZmxKbad/LDYWM2btCZdlTy1xVaKB
	 8Q5AvXxp5SiZKthlKjz3fyxBjvaiwJ8JeZzGzdUaQq0r4hts42cBuFBLOMKcpgaEE6
	 ag0q0P10OyzeKK26iZDMPbjyR0y8BCCBYPkcbuPWHe+UbrHJpGY14iUJ3bw4v+kS8A
	 dxQYkJVDAn6tA==
Subject: Re: [PATCH net-next v2 6/6] net: kunit: test netmem, page_pool, and
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
 aleksandr.loktionov@intel.com, u.kleine-koenig@baylibre.com,
 shaojijie@huawei.com, mgr@kernel.org, j.raczynski@samsung.com
Date: Tue, 13 Oct 2026 08:34:58 +0000
Message-ID: <179188049811.434549.5158913693996438568@kernel.org>
In-Reply-To: <20261012082148.1698596-7-almasrymina@google.com>
References: <20261012082148.1698596-7-almasrymina@google.com>
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

- [Low] None of the new test cases register KUnit cleanup actions.

--

net: kunit: test netmem, page_pool, and skb frag refcounting

This adds KUnit cases to net/core/net_test.c. They check that non-pp
refcounts and page_pool pp_ref_count stay balanced across regular pages,
page_pool pages, and net_iovs, through the various skb frag helpers. It
also exports skb_shift() via EXPORT_SYMBOL_IF_KUNIT() so the test links
when built as a module.

> diff --git a/net/core/net_test.c b/net/core/net_test.c
> index 9c3a590865d26..6f21e6baf7fb3 100644
> --- a/net/core/net_test.c
> +++ b/net/core/net_test.c
> @@ -370,10 +370,1213 @@ static void ip_tunnel_flags_test_run(struct kunit *test)

[ ... ]

> +#ifdef CONFIG_INET
> +static void netmem_ref_test_tcp_devmem_recv(struct kunit *test)
> +{

[ ... ]

> +	KUNIT_ASSERT_EQ(test,
> +			sock_create_kern(&init_net, AF_INET, SOCK_STREAM,
> +					 IPPROTO_TCP, &sock),
> +			0);
> +	sock->sk->sk_state = TCP_ESTABLISHED;
> +	inet_csk(sock->sk)->icsk_ack.rcv_mss = 64;
> +	tcp_sk(sock->sk)->copied_seq = 0;
> +
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
> +	skb->pp_recycle = 1;
> +	skb_add_rx_frag_netmem(skb, 0, niov_nm, 0, 64, PAGE_SIZE);
> +	napi_pp_get_page(niov_nm);
> +	TCP_SKB_CB(skb)->seq = 0;
> +	TCP_SKB_CB(skb)->end_seq = 64;
> +	skb_queue_tail(&sock->sk->sk_receive_queue, skb);
> +
> +	msg.msg_control = cmsg_buf;
> +	msg.msg_controllen = sizeof(cmsg_buf);
> +	ret = kernel_recvmsg(sock, &msg, &iov, 0, 64,
> +			     MSG_SOCK_DEVMEM | MSG_DONTWAIT);
> +	KUNIT_ASSERT_EQ(test, ret, 64);

[Severity: Low]
If this assert fails, is the kernel TCP socket leaked along with the pool
and the percpu_ref data of the on-stack binding?

The page_pool_create() and percpu_ref_init() failure paths above release
everything by hand before asserting. The later asserts do not, which
includes this one, the KUNIT_ASSERT_NOT_NULL(test, skb) checks, and the
second KUNIT_ASSERT_EQ(test, ret, 64) after the second kernel_recvmsg().
None of sock_release(), page_pool_destroy() or percpu_ref_exit() run on
those paths.

The leaked socket's sk_receive_queue or sk_user_frags can still refer to
the on-stack niov. Nothing touches them afterwards, though, because the
socket is never released.

Other new cases follow the same pattern:

  netmem_ref_test_page(): the alloc_skb() assert runs while the test
  still owns the page from alloc_page().

  netmem_ref_test_pp_page(): the page_pool_dev_alloc_pages() assert
  skips page_pool_destroy().

  netmem_ref_test_release_data(): the percpu_ref_init() assert runs
  while the pp page still holds extra refs, so the pool and page leak.

  netmem_ref_test_skb_segment(): the reg_page, percpu_ref_init() and
  skb allocation asserts come after the pool and pp_page are set up,
  with no cleanup.

Could these use kunit_add_action_or_reset() or similar? Then teardown
would still happen when an assert aborts the case.

> +	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 3L);
> +	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
> +			base_iov_ref);

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261012082148.1698596-1-almasrymina%40google.com
