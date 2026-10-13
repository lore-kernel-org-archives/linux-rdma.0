Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6773A33D6D6;
	Tue, 13 Oct 2026 08:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879734; cv=none; b=TLCIWsFXs+QhFFwKtL+0lw22qiGY+4gIXqYUYj3yQUS7pZoIvCUP9PL7GAWyl7aqB5l5tEEEVk4aQK0kw2kF5/HMNDnqP93HRylK5BdQZDKpM/shf/6k/jFNm6ATapUnSky1LLmcbPkxaAR0zvD/WJ9ElnV7Xp1YLolzK8Sjw50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879734; c=relaxed/simple;
	bh=0es844PUx4svQ45p33PKaAUnZiTU42TXnE0Mhc81baM=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=rGi/nCLHgJc4Tlxnq28xGPplznCZK17OpnuVR8ORxiBUfL0SmHjy4r/knNGCpPv9nvaOrnLM5lEqW+H044Xcydu9X3ElN5veEI8o+Rv2JFBnt45WHXYA6Iw7v5LhR3FzEnPUTs8Z9JAbbZHdajv5mfWEJEDdn+cOGhnvis8p1mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K/kPX8SI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K/kPX8SI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5041F00893;
	Tue, 13 Oct 2026 08:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791879733;
	bh=jtJpW3GxHlSyb5/wy2ba0TJw8XBw0a47WmxDIvlUS0U=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=K/kPX8SICntUS/Y4kKzJxmUwGUQQMKRm15Z8jtypmMAR+c4WnHemrjllP86V4qzOP
	 V9S9tsU8ydI2E3WWOuHUBStb6qKLWvdpp9LlKTN5GCPWX1Is+ZBKRrb7bT2j5p5zo1
	 V5Mk4YpQ1xbjBZLGhUk8eB8Ona9pUiN4e3e7k8Jhofn+qJUN7DTN/nhV5cWJ4tfZ2Z
	 8zjPhqOmwYvInrxYmT7/kADVTLpUYnX9R6tjVySgmhIXUs9U5b4nHrM59bm4SFZpLa
	 bZcOXKTHplt3+Ik40OmIkD3rcxITfqkzxEMTvrOZt9eW37A0QZq5NTU+Q7RKhwHUZK
	 MejcB57mtxHsA==
Message-ID: <sashiko-outbox-169237@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 6/6] net: kunit: test netmem, page_pool, and
 skb frag refcounting
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mina Almasry" <almasrymina@google.com>, linux-rdma@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <20261012082148.1698596-7-almasrymina@google.com>
References: <20261012082148.1698596-1-almasrymina@google.com>
 <20261012082148.1698596-7-almasrymina@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 08:22:12 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] net/kunit: kernel panic in TCP devmem test due to unset skb->unr=
eadable
--

commit 432a5016a6d079e3237437e79dd79f25313c4f7a
Author: Mina Almasry <almasrymina@google.com>

net: kunit: test netmem, page_pool, and skb frag refcounting
   =20
Verify that non-pp (page._refcount / binding->ref) and page_pool
(pp_ref_count) references stay balanced without cross-counter leaks or
underflows across regular pages, page_pool pages, non-pp net_iovs, and
page_pool net_iovs with both pp_recycle=3D0 and pp_recycle=3D1.

> diff --git a/net/core/net_test.c b/net/core/net_test.c
> index 9c3a590865d26..6f21e6baf7fb3 100644
> --- a/net/core/net_test.c
> +++ b/net/core/net_test.c
[ ... ]
> @@ -370,10 +370,1213 @@ static void ip_tunnel_flags_test_run(struct kunit=
 *test)
[ ... ]
> +static void netmem_ref_test_tcp_devmem_recv(struct kunit *test)
> +{
[ ... ]
> +	/* 1. Receive via tcp_recvmsg_dmabuf -> SO_DEVMEM_DONTNEED release */
> +	skb =3D alloc_skb(0, GFP_KERNEL);
> +	KUNIT_ASSERT_NOT_NULL(test, skb);
> +	skb->pp_recycle =3D 1;
> +	skb_add_rx_frag_netmem(skb, 0, niov_nm, 0, 64, PAGE_SIZE);
> +	napi_pp_get_page(niov_nm);
> +	TCP_SKB_CB(skb)->seq =3D 0;
> +	TCP_SKB_CB(skb)->end_seq =3D 64;
> +	skb_queue_tail(&sock->sk->sk_receive_queue, skb);

[Severity: Medium]
Does this code need to set skb->unreadable =3D 1 when injecting this devmem
fragment?

Without it, tcp_recvmsg_locked() checks skb_frags_readable(skb) and returns
true. The TCP stack will attempt to copy the payload using
skb_copy_datagram_msg() instead of processing it via tcp_recvmsg_dmabuf().

This leads to a kernel panic when __skb_datagram_iter() executes
skb_frag_foreach_page() and retrieves the page pointer via netmem_to_page().
Because the underlying memory is a net_iov, netmem_to_page() returns NULL a=
nd
the subsequent kmap_local_page(NULL) call crashes the kernel during test
execution.

> +
> +	msg.msg_control =3D cmsg_buf;
> +	msg.msg_controllen =3D sizeof(cmsg_buf);
> +	ret =3D kernel_recvmsg(sock, &msg, &iov, 0, 64,
> +			     MSG_SOCK_DEVMEM | MSG_DONTWAIT);
> +	KUNIT_ASSERT_EQ(test, ret, 64);
> +	KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), 3L);
> +	KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
> +			base_iov_ref);
[ ... ]
> +	/* 2. Receive second packet & destroy socket to test
> +	 * tcp_release_user_frags() -> napi_pp_put_page().
> +	 */
> +	skb =3D alloc_skb(0, GFP_KERNEL);
> +	KUNIT_ASSERT_NOT_NULL(test, skb);
> +	skb->pp_recycle =3D 1;
> +	skb_add_rx_frag_netmem(skb, 0, niov_nm, 0, 64, PAGE_SIZE);
> +	napi_pp_get_page(niov_nm);
> +	TCP_SKB_CB(skb)->seq =3D 64;
> +	TCP_SKB_CB(skb)->end_seq =3D 128;
> +	skb_queue_tail(&sock->sk->sk_receive_queue, skb);

[Severity: Medium]
Will this second injected SKB also trigger the same panic since it lacks
skb->unreadable =3D 1?

> +
> +	msg.msg_control =3D cmsg_buf;
> +	msg.msg_controllen =3D sizeof(cmsg_buf);
> +	ret =3D kernel_recvmsg(sock, &msg, &iov, 0, 64,
> +			     MSG_SOCK_DEVMEM | MSG_DONTWAIT);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012082148.1698=
596-1-almasrymina@google.com?part=3D6
