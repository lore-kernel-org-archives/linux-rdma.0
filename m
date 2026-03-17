Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD52355F47;
	Tue, 17 Mar 2026 09:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773739221; cv=none; b=Ddbd9q5PbtBkB/ysZoih+Kq+cG0wKNHPQc2tiImppd7fy4F1dR33LP/CoEhPLE1tdNrx2mnZe2l6eWx36+QePcSZr258lomPIDZ+UfhcTdJWtfHMWujMzPBWXZLf7TFo7tv7LOKoWEsbtqn+54Ilwt/WMkCSwUvWQvk0p7niZRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773739221; c=relaxed/simple;
	bh=xP5eeh+0a9lPEEEUwZteoXw337RUHoxL4t15/sE4OyQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k5bz8A1mUAXNsjcaUJmYP6jjsm/T6HFL+MhKNhIE9TTT5Um9Mo4z0cPzPGh0NF/+ixJEFfwxnV7ttbGPiREmFhPDAu6BgcobvjJ2fDuHfyctOJbrdNssfpFkctCMnxbC9Xlar+rc1OomdisyBIlPG2S95pLfJFxR6hfNtzbnPQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q3mMbdgS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q3mMbdgS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F197EC4CEF7;
	Tue, 17 Mar 2026 09:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773739220;
	bh=xP5eeh+0a9lPEEEUwZteoXw337RUHoxL4t15/sE4OyQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Q3mMbdgSSCoLb+Sp3+NLMDtSmduFKJ1HwBvWTNYqaZZrhOMgjV3NLCz+1Mo80CqlV
	 mA2/HTSJXUeM6c/hGvrXdQO3BlsuYbjvXvPYPFXZB81glWCytcEIHBWi58Dk1yXGux
	 wvBrH3ZVkhAo9fxbiWu7TKPHrUaPHgz5VRNHuNoESIhN5sBk4/itodd6tiWozDEb3f
	 sJBxbSQ3etYNS/ptv4SVDIsmTKRDWs6MfUTieQcQVvLcWI71Fa/BZwrrzOJKTbqXhY
	 XUbs8zOP7T+vpbfLLu/MbQ7V61SISUqGtsTc9IFXJKnoFMX+7YRldqFTvi5ou2J/Zm
	 pON1rcXFZLIhA==
Message-ID: <ebd00055-d4aa-4612-8bf3-ef0a308512f8@kernel.org>
Date: Tue, 17 Mar 2026 10:20:08 +0100
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] mm: introduce a new page type for page pool in page
 type
To: Byungchul Park <byungchul@sk.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org, netdev@vger.kernel.org,
 Jakub Kicinski <kuba@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Toke Hoiland Jorgensen <toke@redhat.com>
Cc: linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
 harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, kuba@kernel.org, john.fastabend@gmail.com,
 sdf@fomichev.me, saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
 mbloch@nvidia.com, andrew+netdev@lunn.ch, edumazet@google.com,
 pabeni@redhat.com, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, ilias.apalodimas@linaro.org, willy@infradead.org,
 brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
 usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
 almasrymina@google.com, toke@redhat.com, asml.silence@gmail.com,
 bpf@vger.kernel.org, linux-rdma@vger.kernel.org, sfr@canb.auug.org.au,
 dw@davidwei.uk, ap420073@gmail.com, dtatulea@nvidia.com
References: <20260316222901.GA59948@system.software.com>
 <20260316223113.20097-1-byungchul@sk.com>
Content-Language: en-US
From: Jesper Dangaard Brouer <hawk@kernel.org>
In-Reply-To: <20260316223113.20097-1-byungchul@sk.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit




On 16/03/2026 23.31, Byungchul Park wrote:
> Currently, the condition 'page->pp_magic == PP_SIGNATURE' is used to
> determine if a page belongs to a page pool.  However, with the planned
> removal of @pp_magic, we should instead leverage the page_type in struct
> page, such as PGTY_netpp, for this purpose.
> 
> Introduce and use the page type APIs e.g. PageNetpp(), __SetPageNetpp(),
> and __ClearPageNetpp() instead, and remove the existing APIs accessing
> @pp_magic e.g. page_pool_page_is_pp(), netmem_or_pp_magic(), and
> netmem_clear_pp_magic().
> 
> Plus, add @page_type to struct net_iov at the same offset as struct page
> so as to use the page_type APIs for struct net_iov as well.  While at it,
> reorder @type and @owner in struct net_iov to avoid a hole and
> increasing the struct size.
> 
> This work was inspired by the following link:
> 
>    https://lore.kernel.org/all/582f41c0-2742-4400-9c81-0d46bf4e8314@gmail.com/
> 
> While at it, move the sanity check for page pool to on the free path.
> 
[...]
see below

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 9f2fe46ff69a1..ee81f5c67c18f 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1044,7 +1044,6 @@ static inline bool page_expected_state(struct page *page,
>   #ifdef CONFIG_MEMCG
>   			page->memcg_data |
>   #endif
> -			page_pool_page_is_pp(page) |
>   			(page->flags.f & check_flags)))
>   		return false;
>   
> @@ -1071,8 +1070,6 @@ static const char *page_bad_reason(struct page *page, unsigned long flags)
>   	if (unlikely(page->memcg_data))
>   		bad_reason = "page still charged to cgroup";
>   #endif
> -	if (unlikely(page_pool_page_is_pp(page)))
> -		bad_reason = "page_pool leak";
>   	return bad_reason;
>   }
>   
> @@ -1381,9 +1378,17 @@ __always_inline bool __free_pages_prepare(struct page *page,
>   		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
>   		folio->mapping = NULL;
>   	}
> -	if (unlikely(page_has_type(page)))
> +	if (unlikely(page_has_type(page))) {
> +		/* networking expects to clear its page type before releasing */
> +		if (is_check_pages_enabled()) {
> +			if (unlikely(PageNetpp(page))) {
> +				bad_page(page, "page_pool leak");
> +				return false;
> +			}
> +		}
>   		/* Reset the page_type (which overlays _mapcount) */
>   		page->page_type = UINT_MAX;
> +	}

I need some opinions here.  When CONFIG_DEBUG_VM is enabled we get help
finding (hard to find) page_pool leaks and mark the page as bad.

When CONFIG_DEBUG_VM is disabled we silently "allow" leaking.
Should we handle this more gracefully here? (release pp resources)

Allowing the page to be reused at this point, when a page_pool instance
is known to track life-time and (likely) have the page DMA mapped, seems
problematic to me.  Code only clears page->page_type, but IIRC Toke
added DMA tracking in other fields (plus xarray internally).

I was going to suggest to simply re-export page_pool_release_page() that
was hidden by 535b9c61bdef ("net: page_pool: hide
page_pool_release_page()"), but that functionality was lost in
07e0c7d3179d ("net: page_pool: merge page_pool_release_page() with
page_pool_return_page()"). (Cc Jakub/Kuba for that choice).
Simply page_pool_release_page(page->pp, page).

Opinions?

--Jesper
