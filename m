Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD92368D4A;
	Tue, 15 Sep 2026 08:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789459326; cv=none; b=SeS95LkdDW87pDEgfIKyRp6UdzaDT4RBvXql0znRWKnXV9vjzXqeoSv5zpLBLV4QqezIKkH5P0NGp63VJxhKeUX+uNFujq1Roc+/rSRa0yB+gwUR0Emqu2bvwtfLG8FH3EH2qLatsre6ccCcAjRvgax9anNAPdnvdhT1wIBn5tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789459326; c=relaxed/simple;
	bh=c2TLLGYkTdHrN4BganIpw/1ToEu1qncqqdcSmJFgNZ4=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=KL8Pwrg/8zyAi9nuZkyZPzZj6NyNkr++tm6xxNXByfzkZ/ArSR/MNTyZutj5xuU0ffo8888/VnMa/oruuYO9neRYRlfy1T3HQbWjC6IQp4W4pl9N/oxRaH8wfNOxYU6MUZIx4QCkZvktn2cZGd77cARbLccLp9iF0dtyMDNKfi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FqLX7kzp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FqLX7kzp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539161F000FF;
	Tue, 15 Sep 2026 08:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789459324;
	bh=Y9eAj1BnZ2Lu5u6t/9AXq0ht+dqGNvKcFOx7Vwo3T/o=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=FqLX7kzpO12ncmNaXRvmAYkRHHNNtAmqyFza/hJRVDKELsM9xAQx2YJrm11ifncoc
	 IC8fptO6uJH0XLEotw3xEC9u5kxbVl+EL7Q48k4Ln/afPDftjAIB/os8xXOa7BJkkd
	 7wSt86sN569b6k96uxKxLjGpOdw9ZHRJoJdntVmlp7ZhL8IsujddY0Ip/Th4HAueFY
	 OfbL2mHeHF4dHvgTDF8800rnCi+PBhbU3pSgMWJPUqFjlJIMZt0S+ik+E9iYOUUAMR
	 G6d0XZuKRmVwdIL+do10o2LGKj+FVF9oboe1C99DdEBhfuptadzrEYwS8CSDNKp7iG
	 axnxu1NrfCXbQ==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@mellanox.com>, 
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 lirongqing <lirongqing@baidu.com>
In-Reply-To: <20260907113918.2315-1-lirongqing@baidu.com>
References: <20260907113918.2315-1-lirongqing@baidu.com>
Subject: Re: [PATCH] RDMA/uverbs: Reject WQ creation without a completion
 queue
Message-Id: <178945932200.1076019.14168626850794165304.b4-ty@kernel.org>
Date: Tue, 15 Sep 2026 04:02:02 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 07 Sep 2026 19:39:18 +0800, lirongqing wrote:
> UVERBS_ATTR_CREATE_WQ_CQ_HANDLE is declared UA_OPTIONAL in the ioctl
> method definition, so the mandatory attribute bitmap does not enforce
> its presence.  When userspace omits it, uverbs_attr_get_obj() returns
> ERR_PTR(-ENOENT) and the handler stores that error pointer into
> wq_init_attr.cq without validation.
> 
> The bogus cq pointer is then passed to the driver's create_wq callback.
> In the mlx5 case, create_rq() calls to_mcq(init_attr->cq) which applies
> container_of to the ERR_PTR value, producing a near-NULL pointer.  The
> subsequent access in get_rq_ts_format() triggers a kernel NULL pointer
> dereference:
> 
> [...]

Applied, thanks!

[1/1] RDMA/uverbs: Reject WQ creation without a completion queue
      https://git.kernel.org/rdma/rdma/c/c55b7e155dd1f2

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

