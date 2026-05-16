Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7AE632;
	Sat, 16 May 2026 00:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778890223; cv=none; b=DTwC53+gYsQ2g95Uwc0Ehz+cu8X9VUqAOW54ofPlYLv/KhH+onteAb82OY4ZrE5sja7NH3HLhJpBFAMMN3v1rTBkyjU+qK8BYkLy+u8ewCS4hLZ/rslqnHP9F5xacD2jZOnJ37ZthgvRaYhNkFWAzMY8LJJsmXywTvJ9tD6HM+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778890223; c=relaxed/simple;
	bh=GMWkD5pnToqx68zRdTd13MEgZFXmQRNUerX1E4pixu4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KqZmL79PgHt76QIyHP8LhWQhKrjvxqs7fcS62P85Y/vigBFpDCJKINF9XcCLpktV6ssd4LhVxteAzx3b6OVtB9Y9NthLwLLrP0HlP7xYRPeLLcEsYFK3XcsFKbsS8v6GAIInrJ1nZeMzXeOLSH8j567ufJL+mizmaKE4LUt9PPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j07PlK/G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j07PlK/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6040C2BCB0;
	Sat, 16 May 2026 00:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778890223;
	bh=GMWkD5pnToqx68zRdTd13MEgZFXmQRNUerX1E4pixu4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=j07PlK/Gwnz5jRRFij0Mh9bSgrJzLvRkFA59HW/IqPpWm6TP2XGXhmwu4TIHauyUM
	 XH8iHEDLC0+ot6wY06xjMyyY62LEblKkUgf3Jx4nWGHZF15snoTdwQ1v/2yVphsNmx
	 jcCFrw8k1l1Y2FgQD7EZMi3lF1t4z9ZDvmYkp6qedGVhip1Nl99k11ZAtP+OjRSsBi
	 7z5o8TdNxS55tuCTLBSVFrY7fgksPWbMT0K/NF19tA5bLep8u82YSr7VVF3yWOgJWP
	 n1hksKniR23VATykx8wKgBdrLtB++EESBlvRCbk7fJaULp0X1d2OBwyle/2+gtj+au
	 E7DBUw26b/kZQ==
Date: Fri, 15 May 2026 17:10:21 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Byungchul Park <byungchul@sk.com>
Cc: akpm@linux-foundation.org, kernel_team@skhynix.com, ast@kernel.org,
 daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
 john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
 leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, horms@kernel.org,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 ilias.apalodimas@linaro.org, kas@kernel.org, willy@infradead.org,
 baolin.wang@linux.alibaba.com, asml.silence@gmail.com, toke@redhat.com,
 netdev@vger.kernel.org, bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] Revert "mm: introduce a new page type for page pool in
 page type"
Message-ID: <20260515171021.24a741d0@kernel.org>
In-Reply-To: <20260515034701.17027-1-byungchul@sk.com>
References: <20260515034701.17027-1-byungchul@sk.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 15 May 2026 12:47:01 +0900 Byungchul Park wrote:
> This reverts commit db359fccf212e7fa3136e6edbed6228475646fd7.
> 
> Netpp page_type'ed pages might be used in mapping so as to use
> @_mapcount.  However, since @page_type and @_mapcount are union'ed in
> struct page, these two can't be used at the same time.  Revert the
> commit introducing page_type for Netpp for now.
> 
> The patch will be retried once @page_type and @_mapcount get allowed to
> be used at the same time.
> 
> The revert also includes removal of @page_type initialization part
> introduced by commit 735a309b4bfb9e ("net: add net_iov_init() and use it
> to initialize ->page_type"), which will be restored on the retry.

Acked-by: Jakub Kicinski <kuba@kernel.org>
