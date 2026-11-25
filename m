Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795635962;
	b=srOzr2v7oXAr1gUNZiShTcHXn3b6qguJm5mo0RSBhOHwWRWuGHWNY48dY43eVXaR2/pj
	 Q2V5dBtm++VC6yegtbtXq/ZsAI9eQ0PzZyHeXPile1sTRuZBIU/xxGavqOZgsm/ueDhvT
	 xpPnbBD0V1gp+Dk/Gh3w9YTeD04h35oCP1jiBlMPsrrBhT7SkPlAvJhDu2MY62D4VZHd/
	 bqC3dkphqcPS4QlbESZqO9W8sAqR5fGUPXCl8j1mSZSKT+upvrT0NLDlGt21aP7t8n802
	 vvwrIWi5sWaYbCLWWsyJFGiYVfoet2yNSGjUCfmJFL0Hc3knhtceouVGDtuiKZRXHGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795635962;
	h=Received:DKIM-Signature:From:To:Cc:Subject:In-Reply-To:References:
	 Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=vYrHubQhIzK/ork0V0gkVDMcpei3zJK7hFk5RZ+fCWw=;
	b=NeCMDq18cvJgjgouYyH4mOiiQYkW+r0uFcsToZQ3KDMO0Hw5Mb8K8kY3Lov+n6xR69dS
	 CHP8tlZE9P3riUfz1poZiZ3IviGLtOsjvWiqCNYSSsE+B+2xnsM1FqqlUut6UaumCMPJb
	 6u6TW/QjeNKssXKqJL8VxoHSXceRrOIkvOD4XEW8ENRPWXySXicXCh0ulTF/Cw2EuGN2M
	 tojelY7MAXsm1BpflTRTRUI3Gyzv3N6sArr4NzglQdFnc1VFtki4c08eXLMCpI4NbeTvG
	 YJ2+EkDiRyoSf5PzUwGtyWZCn43wLwGm9EvwRf2FAdNTRHGVrGWL+uHnows4HtXwQ5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A5VgDqTH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6321C606A323;
	Wed, 25 Nov 2026 19:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A5VgDqTH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 550CF1F000E6;
	Wed, 25 Nov 2026 19:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795635961;
	bh=vYrHubQhIzK/ork0V0gkVDMcpei3zJK7hFk5RZ+fCWw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=A5VgDqTHBQBIcGWxj8ZlWowBpHDzCW7y8I+5bmgx99dahG052n5ez8Y5oLeMxv6UZ
	 O4dpKL90vapusvkXypytmxThWxcZhZTdSlLHt6XGohKfhpLwp5dvAlHpqpGQLRhNeP
	 pxCDCnt8cgAFaaqEA6id/VtfF06vyWsEcGRMVwxNKCBGw9BNRRx0/e3UhupBTPQd7l
	 4SwWcBMhIAgW0lYLeJ3KJYLpN36e+Ar123CE7QVrLR5V2IjzeFDW8eH5nQJGuw7usk
	 YjU/fJSONeysT1XOzyHxC1R68KgDf3mj+O73DAoo30030IBzmQatD4mlX5dU9AoOrT
	 stbbXFnrwwpng==
From: =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To: netdev-bot+sashiko@kernel.org
Cc: magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, andrew+netdev@lunn.ch, ast@kernel.org,
 daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
 andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com,
 ilias.apalodimas@linaro.org, alexanderduyck@fb.com, saeedm@nvidia.com,
 tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 michael.chan@broadcom.com, pavan.chebbi@broadcom.com, corbet@lwn.net,
 shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
 stuclar@meta.com, sdf@fomichev.me, horms@kernel.org, martin.lau@linux.dev,
 almasrymina@google.com, song@kernel.org, yonghong.song@linux.dev,
 jolsa@kernel.org, emil@etsalapatis.com, ihor.solodrai@linux.dev,
 rdunlap@infradead.org, kernel-team@meta.com,
 dimitri.daskalakis1@gmail.com, bobbyeshleman@meta.com,
 mohsin.bashr@gmail.com, kees@kernel.org, leitao@debian.org,
 maxime.chevallier@bootlin.com, cuitao@kylinos.cn,
 vadim.fedorenko@linux.dev, mike.marciniszyn@gmail.com, kuniyu@google.com,
 jiayuan.chen@linux.dev, mkarsten@uwaterloo.ca, razor@blackwall.org,
 dw@davidwei.uk, asml.silence@gmail.com, linux-rdma@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 04/15] page_pool: Let memory providers take
 back net_iovs
In-Reply-To: <179561568855.3135.15810206390695616800@kernel.org>
References: <20261124125654.183091-4-bjorn@kernel.org>
 <179561568855.3135.15810206390695616800@kernel.org>
Date: Wed, 25 Nov 2026 20:45:59 +0100
Message-ID: <87bj7coft4.fsf@all.your.base.are.belong.to.us>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

netdev-bot+sashiko@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found more severe
> issue(s) in other patches of this series. This mail is only an FYI, in ca=
se
> you want to address the nit picks below when you respin.
>
> Low priority / nit picks for your consideration:
>
> - [Low] page_pool_hand_off() in net/core/page_pool.c (lines 846-851)
>   branches on netmem_is_net_iov() and casts the netmem down to a net_iov=
=E2=80=A6
> - [Low] The kernel-doc for memory_provider_ops.hand_off in
>   include/net/page_pool/memory_provider.h (lines 39-44) says a false=E2=
=80=A6
>
> --
>
> page_pool: Let memory providers take back net_iovs
>
> This commit adds a hand_off() memory provider op and an mp_hand_off flag
> in struct net_iov. When a net_iov is marked, its last put goes to the
> provider instead of the page pool cache, and it stays charged to the
> pool. The hook is wired into __page_pool_put_page(),
> page_pool_drain_frag() and page_pool_free_frag(). The commit also adds a
> provider-owned mp_state byte.
>
>> diff --git a/include/net/page_pool/memory_provider.h b/include/net/page_=
pool/memory_provider.h
>> index d52c7a450c68e..bfc2841582225 100644
>> --- a/include/net/page_pool/memory_provider.h
>> +++ b/include/net/page_pool/memory_provider.h
>> @@ -36,6 +36,12 @@ enum mp_flags {
>>  struct memory_provider_ops {
>>  	netmem_ref (*alloc_netmems)(struct page_pool *pool, gfp_t gfp);
>>  	bool (*release_netmem)(struct page_pool *pool, netmem_ref netmem);
>> +	/* Takes a free net_iov marked mp_hand_off that stays charged to the
>> +	 * pool; the provider puts it back later. Returns false to have the
>> +	 * pool recycle it instead. Called where the pool puts netmem, outside
>> +	 * hard IRQ context. Needed by providers that mark net_iovs.
>> +	 */
>
> [Severity: Low]
>
> Is "Returns false to have the pool recycle it instead" true for every
> caller?

You're right, at destroy a false return releases the net_iov, which is
what a dying pool should do. I'll fix the comment.

> [Severity: Low]
>
> This isn't a bug, but does this fit the netmem abstraction rules?
> page_pool_hand_off() branches on netmem_is_net_iov() and downcasts with
> netmem_to_net_iov() inside page_pool core. Before this patch, page_pool.c
> had no netmem_to_net_iov() call.
>
> The netmem_ref kernel-doc in include/net/netmem.h says:
>
>   Downcasting netmem_ref via netmem_to_page() or netmem_to_net_iov() in
>   callers is not allowed unless a code path strictly requires a specific
>   backing type ... In such cases, add a netmem helper here that handles
>   both page and net_iov cases
>
> Documentation/networking/netmem.rst also says core code should avoid
> per-netmem-type branching. It also says new code must not assume that
> using a memory provider implies net_iov memory.
>
> The mp_hand_off flag lives in struct net_iov, and the hand_off() contract
> only covers net_iovs. So a provider that hands out page-backed netmems
> can't use this hook.
>
> Would a netmem.h helper fit better here? For example, something like
> netmem_mp_hand_off() that returns false for pages and is called from
> page_pool core.

Yeah, let's use a helper.
