Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6944947F786;
	Wed,  2 Sep 2026 16:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788366324; cv=none; b=FoSaQzaePD4ZVQNB/+7scRZZ7CXK1Abi80YDYCjyLW+0Qr034ikG+1IwIioG6jMyGtzp1bS+ZUKtjviZ2y57u+KFixhh0BfeDA3ABCAYW+3JEDTQquN48wzyrW+9lulb5yZ8UBBhBAg8tutpOJ2sIjEOSZSEHRJEZeM7RFCUDlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788366324; c=relaxed/simple;
	bh=KDKpe6Y4BCIj2Xf1eHlfuIgA2PuxH4SIBbrea/Gbolc=;
	h=Date:From:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HpI8I+OjQuSnT/QFGbBZVWBo2mWHa+RXiQ7hJPhO5ov8vAcVmuqBhjC5wOCAKPlR9B58DQY5ja4j46OmfiCA3akhE4SCwEuuNRDsp/xZMEpOXfMT8zZFNfRLD/Aa8LzuWHXMLqcaR4YWVtQ/dmAwRoIgUoCPOpQLnmBTKXrPBbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iCU5qOSh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iCU5qOSh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E7C1F000E9;
	Wed,  2 Sep 2026 16:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788366323;
	bh=nqZFIDkozsKcZSvdTahuya/znCYPECS2HhaWl5wvB6E=;
	h=Date:From:Cc:Subject:References:In-Reply-To;
	b=iCU5qOShsqJxNR0mAGmPcC5TV5dhYb8uugL+TmUGT4iuYHzFzbCzpxfesQ3RDMS0q
	 m+Sv+eQvzAhLJCC6X22M0m5/GgpFJVmoWYOgiKWL+K8W+GgmT+OKzHE1oj3tJ6oUQj
	 vSJpMTsNFfLYz+/KdAEDZgcfSgi8sxDJpSQONdIVYxnEtTu1sZ+53bDJiJ5eCrNcfp
	 +Nxpt8dCge1qe8VyPmSvbMjmw+ZAaySp7xZYuKG8mEYcO3lzF6cYMR2gFC7katb5jr
	 s6ovNeVfg11n5ZzxkmYhDyLHadXU02rxWU5944gUmtvvK8oiovCzcuYVvWVIOcQXdQ
	 lJGnt53e6GHgg==
Date: Wed, 2 Sep 2026 19:25:18 +0300
From: Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Jack Wang <jinpu.wang@cloud.ionos.com>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzbot+d396918a29afb8543e1c@syzkaller.appspotmail.com
Subject: Re: [PATCH] RDMA/rtrs-clt: Fix CQ pool leak when connect is
 interrupted
Message-ID: <20260902162518.GW24140@unreal>
References: <20260830-rdma-rtrs-clt-cq-pool-leak-v1-1-b169434fd3df@proton.me>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260830-rdma-rtrs-clt-cq-pool-leak-v1-1-b169434fd3df@proton.me>

On Sun, Aug 30, 2026 at 03:09:55PM +0800, Quanye Yang via B4 Relay wrote:
> From: Quanye Yang <quanyeyang@proton.me>
> 
> The client borrows shared CQ credits in the ADDR_RESOLVED handler via
> ib_cq_pool_get(), before the peer is connected. create_cm() can return
> -ERESTARTSYS from wait_event_interruptible_timeout() without destroying
> the CM ID. The init_conns() and stop-and-destroy paths then call
> destroy_con_cq_qp() while cq is still NULL (no PUT) and only afterwards
> rdma_destroy_id().
> 
> CMA serializes the handler against rdma_destroy_id() with handler_mutex,
> but that does not order the GET against destroy_con_cq_qp(). If
> ADDR_RESOLVED has already passed the DESTROYING check, it can take
> con_mutex, GET credits, and then lose the con to kfree. Device
> unregister later hits WARN_ON(cq->cqe_used) in ib_cq_pool_cleanup().
> 
> Set a per-connection flag under con_mutex before CQ/QP teardown so a
> racing ADDR_RESOLVED cannot borrow credits after teardown has begun.
> 
> Reported-by: syzbot+d396918a29afb8543e1c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=d396918a29afb8543e1c
> Fixes: 3b89e92c2a95 ("RDMA/rtrs: Use new shared CQ mechanism")
> Signed-off-by: Quanye Yang <quanyeyang@proton.me>
> ---
> Fix a syzbot WARNING in ib_cq_pool_cleanup(): an ADDR_RESOLVED handler
> can ib_cq_pool_get() after connection teardown has already skipped the
> matching PUT.
> 
> Reproduced on rxe with rnbd-client only (no rtrs server): write
> map_device with path=ip:127.0.0.1, interrupt create_cm() with a signal,
> then rdma link delete. Device unregister no longer reports leftover
> cqe_used after this change.
> ---
>  drivers/infiniband/ulp/rtrs/rtrs-clt.c | 8 ++++++++
>  drivers/infiniband/ulp/rtrs/rtrs-clt.h | 2 ++
>  2 files changed, 10 insertions(+)

Haris, Jack?

Thanks
