Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD51F221723;
	Mon, 18 May 2026 09:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779097794; cv=none; b=k/h5ldYJYjEo8c7yFQe2BC1vc28FVUxUJ3KXdUHX/hisI4Y1UWo0cp0WogANcS4fiOVDj1I2v9JqcJ1A1h1UnEZ4qSRCU+Y4wFFLeyIX11mjCnWCc0FXb9aUAs89zhjfzz9+If0Xw9i/ZXTNP4+gCAEMwASChcR7nCHdpwTJ2Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779097794; c=relaxed/simple;
	bh=UNp7ecYVxpOGAW2Bt0FyxpEAXPsYSA4QEoORERoNuV0=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=GEvffyk5IOm55+qWEeKxyvgX3W8NozPtJxDGEYJ6cVVcEQJOcuoox7uZKSO07Qz+pInaegESnTWI/OEqSgvegpEBuEuaxCyhNxx4BHmY/h6nZksbgHxAEdP3w1qMjLiYenVnJ8ky+uDcNn81XUcYHHEHDpPQmvqyQmRWVSGdzHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b8gXKnxt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b8gXKnxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72607C2BCB7;
	Mon, 18 May 2026 09:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779097794;
	bh=UNp7ecYVxpOGAW2Bt0FyxpEAXPsYSA4QEoORERoNuV0=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=b8gXKnxtilovGoQt/RW1o8BSCQzuOk6OOsKogEbG5+X+5fsPrd13d3yWs33JrzPxE
	 Gj3vFj9z4/d79ItKHtTUfqkuOboknn/zrESvDETRZ9IKQ39gjg6LiWiylIqboU4qr3
	 weDU521lqSitaLkIecXl8igajFQiCgnH1yRMF7tlzjPTnWZPctELpDNrtqCcNTSMOq
	 2sYmLkzCslwP4Igx+HoDgkx391ulyU86BS1jEeY89KhFrRS7uk4s7QkyQ74xHfHeF7
	 6JUFEGMJLgtx12YfkXqcSYs0zqTkfkmC8ZB25HykE4fv9eGJ8JF0fNniD2rFB81jg1
	 JuWIaD2XAXffw==
Message-ID: <1fd5fc85-c918-4eb0-8b57-ed09479a9770@kernel.org>
Date: Mon, 18 May 2026 18:49:46 +0900
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Subject: Re: [PATCH] Revert "mm: introduce a new page type for page pool in
 page type"
To: Byungchul Park <byungchul@sk.com>, akpm@linux-foundation.org
Cc: kernel_team@skhynix.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
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
References: <20260515034701.17027-1-byungchul@sk.com>
Content-Language: en-US
In-Reply-To: <20260515034701.17027-1-byungchul@sk.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 5/15/26 12:47 PM, Byungchul Park wrote:
> This reverts commit db359fccf212e7fa3136e6edbed6228475646fd7.
> 
> Netpp page_type'ed pages might be used in mapping so as to use
> @_mapcount.  However, since @page_type and @_mapcount are union'ed in
> struct page, these two can't be used at the same time.  Revert the
> commit introducing page_type for Netpp for now.

Uh, didn't realize that those pages can be mapped to userspace...

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
> ---

Looks good to me, so:

Acked-by: Harry Yoo (Oracle) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon
