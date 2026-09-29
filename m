Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427783CF21F;
	Tue, 29 Sep 2026 13:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790688547; cv=none; b=HTS880nRph9UgHA8Y8LDFuZU1986NJnP6084Gla/izVOQsinGi/+1elc2JBQ/DcLqBhYexcItheEm/P8oZqEYvyeKhzQ3qaipv5QvEZS84pHUp7QMI0ArNTjiLyqtEHj8OTK5HlJvG9gJaGd5cN8aXOyLjBMpbqqv7aFy5Ah20k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790688547; c=relaxed/simple;
	bh=aao0JTiU75T4tsQlnmu8s5Njc/tkbS/+VCTkdNv2YSo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=mtZpWVfXYNSPsQZmJ7voafeyG2Up9SKAj4aNQntJbgQR2b6Xf7pwifjgpzAPZMqBWQwTs6+Hs6F3QqoMt2Jeq7WaIyKVUeYuwZfCnn50J2z2enmqyagym6MTvIS2um0E5MmVv7vvOSvjn/emRYADa910t0yNkemfe2El77BV1nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dE2kvr3e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dE2kvr3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 406BB1F000FF;
	Tue, 29 Sep 2026 13:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790688544;
	bh=QrKBKk755b+t8Mt/64wXbCz4671JjGiAZGIRQHot+fQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=dE2kvr3eUaxUbN6rGw1kCnz1/acjRdQ45Nye/4YI4v1MCPem3+dVj6cQuwf+i/aiF
	 6XCJ0dEVkVnUNU65zhr0gwtlaDEQXnWCu6s5XmNMxi6Kr6xJx2036EuDwHIU5+DvY3
	 kM3WaNjSGhOxYhJhddUUj1Ql9AHTJK+MsbSbiZBUSp1//NcYP/uOaRKTh8GbvFnqNB
	 WYc0c23tiswCx0UBAB+BI8yLk4V4S7qGZysVzcpV/M1dtp0xA3ip102ARIz39flVg5
	 Z/KZW/6iPn6oGvNMws4BSvcm/tcXoX/NPFQe6WX05BmVNPorTzPMIHsuTkV7wUY6lZ
	 KSUzuEt9NErVA==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, Dairui Zhang <zhangdairui@gmail.com>
Cc: security@kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, 
 stable@vger.kernel.org
In-Reply-To: <20260922152342.1474845-1-zhangdairui@gmail.com>
References: <20260922152342.1474845-1-zhangdairui@gmail.com>
Subject: Re: [PATCH] IB/mad: fix UAF and double-free in RMPP receive
 reassembly
Message-Id: <179068854196.3965508.17242912342114946649.b4-ty@kernel.org>
Date: Tue, 29 Sep 2026 09:29:01 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 22 Sep 2026 23:23:42 +0800, Dairui Zhang wrote:
> mad_rmpp_recv.state is protected by two locks that do not exclude
> each other: recv_timeout_handler() (port workqueue) uses agent->lock,
> continue_rmpp() (CQ softirq) uses rmpp_recv->lock. Nothing serializes
> the check-then-set sequence on the state word:
> 
>   T1 (CQ softirq)              T2 (port workqueue)
>   continue_rmpp()
>     lock(rmpp_recv->lock)
>     state == ACTIVE  [passes]
>                                recv_timeout_handler()
>                                  lock(agent->lock)
>                                  state = TIMEOUT
>                                  list_del(&rmpp_recv->list)
>                                  unlock(agent->lock)
>                                  destroy_rmpp_recv()
>                                    wait_for_completion()
>                                    [blocks on T1's ref]
>     state = COMPLETE
>     unlock(rmpp_recv->lock)
>     complete_rmpp()
>       queue cleanup_work (+10s)
>     deref()
>                                [unblocks]
>                                kfree(rmpp_recv)
>                                ib_free_recv_mad(done_wc)
> 
> [...]

Applied, thanks!

[1/1] IB/mad: fix UAF and double-free in RMPP receive reassembly
      https://git.kernel.org/rdma/rdma/c/90e9b6357bec75

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

