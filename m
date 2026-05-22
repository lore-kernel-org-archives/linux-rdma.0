Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5F131F9B0;
	Fri, 22 May 2026 07:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779435912; cv=none; b=iKxxNvG/oQrn+Jeavw+LJKzqRLVCwNl9pX4LyhxIYnDUr21FtEhWMTHJ9qC1MwAPpxI8EeVjG/d+xTxMtQej5UHKC6Gk1Q9s5Wd6QeqYTvx/7VAHlReAzY0ThwPvgOPIete6KfhmEnVrCrpD1ywyGBqZzPxwe5Mgs/wh034kMAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779435912; c=relaxed/simple;
	bh=Ib8axZjinxhozfhntpIXucBCGVl4CALrcaU9TbtnFyc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EZT+EwZytmYwOcZGCCPBkbAE282C9EtBjOwgs149l4SzaTWMYVSpiR/O7nYAkrv/f4cGj3QaiosdG/7pncf2pUzAnaIDM5fb34BJC9q/056TH2FbP1xL3LlNAJxqTI+pGcRyFAHeD4N4a64zXCmjupB8M2bbMzV9K78dvEzGB04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ENLrYjDI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ENLrYjDI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D525D1F000E9;
	Fri, 22 May 2026 07:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779435910;
	bh=72bkGf8TpFe7R7yMNosUxkxRGjLquylKLDOkA3b7X0o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ENLrYjDII187/GnAQyg9/9GEbmnQHyUDrfHVlxPS1r+9N1XUrnCRiVJajy/KEk+k4
	 mziLakPQkRE5n1+HizkVqkZ9qYX9TZxmCcuJuTxO0O94S5HG0MK46sFnRYAvkh7GXU
	 groMkIJPE/luoxAxjZf6VEuI0c7TvkWMxVj+3Ar2Y+IXtXwPHcwYDKtNWjDhkTUOk+
	 DJhafpe64hzzoEDowEiu1osDYYmyWo6w9i0hfmWCWytBqMTQIJ78Oq5enrW0GLYkdR
	 dPBJdnh0cCoyMZOl8F9cYTq6y5TCB2v0H+XQsUE4VLcRNP4+0FWkqD1LMZVmwE4EUy
	 Yg3TlLabpy82A==
Message-ID: <d9c882ae-3ac2-4466-847c-07823a22f257@kernel.org>
Date: Fri, 22 May 2026 09:45:02 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "mm: introduce a new page type for page pool in
 page type"
Content-Language: en-US
To: Byungchul Park <byungchul@sk.com>, akpm@linux-foundation.org
Cc: kernel_team@skhynix.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
 john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
 leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, horms@kernel.org, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, ilias.apalodimas@linaro.org,
 kas@kernel.org, willy@infradead.org, baolin.wang@linux.alibaba.com,
 asml.silence@gmail.com, toke@redhat.com, netdev@vger.kernel.org,
 bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260515034701.17027-1-byungchul@sk.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260515034701.17027-1-byungchul@sk.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/15/26 05:47, Byungchul Park wrote:
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
> 
> Reported-by: Dragos Tatulea <dtatulea@nvidia.com>
> Closes: https://lore.kernel.org/all/982b9bc1-0a0a-4fc5-8e3a-3672db2b29a1@nvidia.com
> Signed-off-by: Byungchul Park <byungchul@sk.com>

Unfortunate that it didn't work out yet.

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks!

