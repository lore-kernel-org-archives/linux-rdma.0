Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3263B14B7;
	Tue, 13 Oct 2026 08:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791880495; cv=none; b=aw0OSN74ssa7gFPtYoBmwVx+tHW/eGhN30iyawvAcifxvOIcfTut8RMcf9/GlW/QOqL3Pf79mmM4dPvkvvBf9xD6AcDazhLQloDxbQd/isUMfXCFtamVecVOxBJMrszVxJvfGHjafJ5pO0Z056tqd81MssBCQrZGmYv/MuPGvR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791880495; c=relaxed/simple;
	bh=a6dZzjkcWEIszxGRfmbU0La8cN7whKAptNE7Ebg9L3w=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DT44ctdE1a9PwG87XrLX2GDx+TCYGHaggbiWlN0DIVSE3pjs1v924yHR7ShiId64Dz05BCuVKhujz/gXlN5QJGlmkuDAx8SPdPwR7JVkTmKs6cz20CNAxZFg4aB635sVXjQu7k+gmTs91US2RPfaZ2NWfa3TN26IxHGeZ+6tvFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MiFcmius; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MiFcmius"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA3E1F000FF;
	Tue, 13 Oct 2026 08:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791880493;
	bh=lWHulRdxB7YBtnOlQwup2s7pTueKJLf41Cz8I2mG7no=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=MiFcmiusNrq70X9r4yaLFqpwLsi8VKljSmwFbeoV2w2E5yCSG1nGbpvL44xvR57ow
	 nKsAaz8e2xg41raZiCJHs9TPt7aalRH4K+WNJ/6K6YmMphEHDyVLKi+Wq92f7PKPZB
	 GGomSf6SfAZXSh/54U7Da2AQff/AMFG/VyXk7cL3XTygoSQ6r6wqrpbcArMl1qM3WM
	 WhW40R80P58XD7aDuAEe0lCgsDnHH27qDabxUuEckaXPMQ3y1Bcra3w73ubxKQIkvG
	 KMqFEwDnstM5VnBE6GP61Vbqg5uOIWzyNfNoneYTGzGaBrxkiBSIkuQvFXqYKu+w0Q
	 jH8nyOPvSau6Q==
Subject: Re: [PATCH net-next v2 1/6] netmem: rename __get/__put_netmem() to
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
 aleksandr.loktionov@intel.com, u.kleine-koenig@baylibre.com,
 shaojijie@huawei.com, mgr@kernel.org, j.raczynski@samsung.com
Date: Tue, 13 Oct 2026 08:34:51 +0000
Message-ID: <179188049192.434549.15748478382519808076@kernel.org>
In-Reply-To: <20261012082148.1698596-2-almasrymina@google.com>
References: <20261012082148.1698596-2-almasrymina@google.com>
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

- [Low] The new kernel-doc for get_netmem() and put_netmem() in
  include/net/netmem.h is wrong for one of the two net_iov types.

--

netmem: rename __get/__put_netmem() to get/put_net_iov()

This commit renames __get_netmem()/__put_netmem() to get_net_iov() and
put_net_iov(), changing them to take a struct net_iov pointer. It adds
kernel-doc to get_netmem()/put_netmem() and the new helpers, and adds a
DEBUG_NET_WARN_ON_ONCE() for net_iov types without non-pp reference
support.

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
Is this kernel-doc accurate for every net_iov type?

get_net_iov() only takes a reference when net_is_devmem_iov() is true,
which means the NET_IOV_DMABUF type:

net/core/skbuff.c:get_net_iov() {
	if (net_is_devmem_iov(niov))
		net_devmem_get_net_iov(niov);
	else
		DEBUG_NET_WARN_ON_ONCE(true);
}

For NET_IOV_IOURING (io_uring zcrx) niovs, and for all niovs when
CONFIG_NET_DEVMEM=n, neither get_netmem() nor put_netmem() takes or drops
any reference.

Without CONFIG_DEBUG_NET, DEBUG_NET_WARN_ON_ONCE() expands to
BUILD_BUG_ON_INVALID(). On production kernels that case is skipped
silently, so the "warning if @niov does not support non-pp references"
in the get_net_iov()/put_net_iov() kernel-doc never fires there.

The commit message has a similar statement:

    Make the non-pp layer explicit and symmetric across both
    netmem types: get/put_netmem() dispatches to get/put_page() for pages
    and get/put_net_iov() for net_iovs, always acquiring or releasing a
    non-pp reference regardless of page_pool membership.

This doesn't change runtime behavior, since __get_netmem()/__put_netmem()
also did nothing for io_uring niovs. A future caller that relies on this
kernel-doc could still pair get_netmem()/put_netmem() on a zcrx niov and
get no lifetime protection.

Could the get_netmem()/put_netmem() kernel-doc say that NET_IOV_IOURING
has no non-pp refcount, so these helpers do nothing for it? It could also
say that the warning only exists under CONFIG_DEBUG_NET.

>  static __always_inline void get_netmem(netmem_ref netmem)
>  {
>  	if (netmem_is_net_iov(netmem))
> -		__get_netmem(netmem);
> +		get_net_iov(netmem_to_net_iov(netmem));
>  	else
>  		get_page(netmem_to_page(netmem));
>  }
>  
> +/**
> + * put_netmem - release a non-page_pool reference on a netmem
> + * @netmem: netmem to unreference
> + *
> + * Drops a non-pp backing reference (page._refcount via put_page() or
> + * binding->ref via put_net_iov()) regardless of page_pool membership.
> + * Counterpart to get_netmem().
> + */

The same question applies to put_netmem(). put_net_iov() only calls
net_devmem_put_net_iov() for NET_IOV_DMABUF niovs.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261012082148.1698596-1-almasrymina%40google.com
