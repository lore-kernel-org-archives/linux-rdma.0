Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D3658E2D8;
	Thu, 15 Oct 2026 20:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792096664; cv=none; b=tLwasG4M0MOd25+GPj0nHRHr2aQkcg6qDZmuqkpYdjfZ1LD50mmyi7zHg1zo1+pZeTq1VinttMhAQYSiX8HJNhYj36pDltY70kyFs21NemJjTMuxdYYDw51du6/OhA+n33PN77pLYpPU/N7C+MrleRlZ3FUxMYT64Rf4Ftum8a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792096664; c=relaxed/simple;
	bh=wf0DCdSra89Ii7vNrD6zAe8Yv5q9Wi9fzar6HJdKa24=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GkE7vdpEAnAQ/b0KsJmGf2gvQFCZ06E3FRYl21QQ+95c0LjvawznE6F4AlBF3BFDKKCbBUOVABg5tkQRSzsWsuwHM50+i4vQYzZjpo+9n5HoBLSVO6PJPWef8zDxfYRc354knXU9RdOEfElPf+2n9ewrv9rpQIqXt14Yjwj50ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cz2WSigL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cz2WSigL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8521F000C5;
	Thu, 15 Oct 2026 20:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792096660;
	bh=5SJuG3nU0YOHzeceYqH37EIvxhX5JEqog2IlJeIpdYs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Cz2WSigLK3L0LZh7pgeFnnqpvACNV3QxA3KaNbQtTKLZQu7+aJDz3p27mxtCouWUk
	 0V5I7OF7noVkyGINwwcKRS2Jems00QFsoG4y1yLZz0cHbFwdrV77EaHKNM3Wd07xqk
	 KqOrJM8RMTZW/cDc+bPM+khfEvhnBQI2XxTfMZsmBD72o3z7Fg+pFUMgRGBnsm6HH2
	 wR8Ozi+gWYTcMyZusg61S62nYiONrweaazN5TwweiC7uWFUTiJH0EAXPUZXlqXhY8F
	 JOHrQuxAMjSAIKMBWMbYTnOZFrba9QeAks0xkYi3wnHhL//HkWCeUfN1OVqKgoqU3Z
	 d2Dof2ZFN4SnA==
Subject: Re: [PATCH net-next v3 2/6] net: skbuff: add napi_pp_get_page() and
 use it in tcp_recvmsg_dmabuf()
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
Date: Thu, 15 Oct 2026 20:37:38 +0000
Message-ID: <179209665863.434549.6637198029989888049@kernel.org>
In-Reply-To: <20261014173945.373295-3-almasrymina@google.com>
References: <20261014173945.373295-3-almasrymina@google.com>
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

- [Low] The commit message says that "no symmetric helper existed to
  acquire" a page_pool reference, "forcing callers like…

--

net: skbuff: add napi_pp_get_page() and use it in tcp_recvmsg_dmabuf()

This commit adds napi_pp_get_page(), which takes a page_pool pp_ref_count
reference on a netmem if it belongs to a page_pool, as the counterpart to
napi_pp_put_page(). It also converts tcp_recvmsg_dmabuf() to use it,
wrapped in WARN_ON_ONCE(), in place of the open-coded atomic_long_inc().

> While napi_pp_put_page() releases a page_pool pp_ref_count reference on
> a netmem, no symmetric helper existed to acquire one, forcing callers
> like tcp_recvmsg_dmabuf() to open-code atomic_long_inc() on
> niov->desc.pp_ref_count.

[Severity: Low]
Is this description accurate? A helper for this increment already exists
in include/net/page_pool/helpers.h:

static inline void page_pool_ref_netmem(netmem_ref netmem)
{
	atomic_long_inc(netmem_get_pp_ref_count_ref(netmem));
}

io_uring/zcrx.c already calls it in a similar zero-copy rx handoff:

	page_pool_ref_netmem(net_iov_to_netmem(niov));

Documentation/networking/netmem.rst also names page_pool_ref_netmem() as
the API for holding a page_pool reference. The new napi_pp_get_page()
calls it internally too.

Compared with page_pool_ref_netmem(), napi_pp_get_page() adds the
netmem_compound_head() lookup and a netmem_is_pp() check whose bool
result tells the caller whether the netmem is page_pool backed. Later
patches in the series seem to depend on that result, for example in
skb_netmem_ref(), which falls back to get_netmem() when it is false.

Could the commit message explain the page_pool membership check and
return value, rather than saying no helper existed? As written, it is
not clear why tcp_recvmsg_dmabuf() doesn't just call
page_pool_ref_netmem().

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261014173945.373295-1-almasrymina%40google.com
