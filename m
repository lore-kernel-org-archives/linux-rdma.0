Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2B2371884;
	Thu, 19 Mar 2026 23:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773963094; cv=none; b=k4nUY91epDUWL1Ho7akOcAtWY33ry723bopkKXX5RaEXtKUjMtNfA5rDMkC1lXTvz7l9HHBUAUvUs8a0H/xnYGdIcsjt0IvG9ROsCcv+Y4B2CEgRCZnTF2BMgE6IjBlCXz00nori3yiHOLomnrOtBtZVpUWN/vNROANI+ME/Wrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773963094; c=relaxed/simple;
	bh=2ceLYHitrpgWnbijBLEURAHrA3SxUbD0jlo2sSsj2kA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uyGyfd2SCPqR6H3F0lYiHWYmeL0z/E86ye/QyED9rU+roIGG2ShRIJpIc8zAzxgUaaFWzLo3XW1YAeCLbHl9sYL6c47APKt6DDcBx3lPE++XZ+qKaoLWE0oGCY/E/af02/3ohv7pMu/BZ0sr8TYMvgsbRBLAmFpVFwbqG8N+tYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CVuqtNjF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CVuqtNjF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8E3C19424;
	Thu, 19 Mar 2026 23:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773963093;
	bh=2ceLYHitrpgWnbijBLEURAHrA3SxUbD0jlo2sSsj2kA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=CVuqtNjFaPpOozcHQ0mF58SrW1xcRvHJ1UN1gqC0BYNd+HIegbIO7XleLF+7YguxL
	 9TDKoFqvqyOP4tDys+vTYocI/ji8rRjvUQf/Cl2rQw/e1piNSzXBezeMi8yoNlAb3o
	 xVhaaSxLG2VFUXOPfuJ1SY+vrHcBj/MVU7riKCdMk3Viu1LX1lcinFUIUBdcy84xfM
	 fCXd4jRrWkMJiQnxmrYGHv99ZG2qdINt+MCASHRn10VCCClzQh24dmch7hNXeUTLa6
	 leIj0kVLiUYnU6wCckdIaclYQAnLJUvuV7IaE2aqyhXp9SdWSTcDrSGWW/herYMFD2
	 Iq4hekz6OvrcA==
Date: Thu, 19 Mar 2026 16:31:31 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Byungchul Park <byungchul@sk.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
 harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
 sdf@fomichev.me, saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
 mbloch@nvidia.com, andrew+netdev@lunn.ch, edumazet@google.com,
 pabeni@redhat.com, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, horms@kernel.org, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, ilias.apalodimas@linaro.org,
 willy@infradead.org, brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
 usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
 almasrymina@google.com, toke@redhat.com, asml.silence@gmail.com,
 bpf@vger.kernel.org, linux-rdma@vger.kernel.org, sfr@canb.auug.org.au,
 dw@davidwei.uk, ap420073@gmail.com, dtatulea@nvidia.com
Subject: Re: [PATCH v5] mm: introduce a new page type for page pool in page
 type
Message-ID: <20260319163131.2f160a5d@kernel.org>
In-Reply-To: <20260316223113.20097-1-byungchul@sk.com>
References: <20260316222901.GA59948@system.software.com>
	<20260316223113.20097-1-byungchul@sk.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 17 Mar 2026 07:31:13 +0900 Byungchul Park wrote:
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

Acked-by: Jakub Kicinski <kuba@kernel.org>
