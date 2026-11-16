Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794845027;
	b=nvfZdaz4VBet+e6IJCrE9+3RUCP4uwCekPDe+0XIC/ookwLKKz5u9Q585ntq9xyeeLWU
	 ZzNXC92EqwwRpxIfrtvlrt8yDpGBtvsarHNdjbXxzxr+fAsqYyFI9v837KQpvwOmCfqok
	 89QLDesIqgf+vddlz1p5M7gd+y0Vbs7UPrOGf3DR0PGsPyhxE0vC5DZJrlXLH+n6RntPQ
	 pBWN+FAMKMzNuAF3T6cICvwW/0/9JMQNZgu9xKV4zvHxAdC8B53irg40stZ+XEd187h2r
	 j2egkHzkrJ7sl7ypoZ8vK1JKQVMrGKUZs4PDUCcaYiMqbGSgqN9Tt4jhMdXDjF4VKfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794845027;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=qlAA127R2oaYgttGLwgrOOAAhQ02iKpyezBNnMMVfD0=;
	b=xK2lLtSepbGg/9pcN77W7LGkQ8Kay6xQnmcqDMPpbjv9m78FCBW3s2e3+8XU4ogZbYMm
	 6Ymad/+AaqFgjyWlAl7j81bI9kjY2nG6JLXiYtVlPiinoiab9ZGnFUl7LKeQwx3UjdALH
	 pncMAkWJ/wYDPbZaRAYOfc8del+g/DYVWDzwRsPjji/bJ5ibO1+/+ZMEMwW0SvrcGkbCt
	 gL4duy4Mhgj6i95UTeFRVbzGBC/pn8GmQpEwLmAIfkH579wcFZ1+FjIC7c97Ejoh97Ga/
	 4Ee3eqk9y4vsYgmwUXwihXaDj64d9p2VgIQUeM0TqXppA3zgPlCK8aHU+BXX84D857Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=Yy+jDt7D;
	arc=none smtp.remote-ip=209.85.160.178
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F431606A331
	for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 16:03:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F431606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=Yy+jDt7D
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-55d2d380f6aso18355761cf.2
        for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 08:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1794845026; x=1795449826; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qlAA127R2oaYgttGLwgrOOAAhQ02iKpyezBNnMMVfD0=;
        b=Yy+jDt7DanMeBnfkd7YR2MwwpwCv8ZxB8S/AaqsRfCqNKzPPhWfyJ94WGUHYseDxU6
         6EbJJDSlPEO59GvUH4BOatmnKT3QzhSXwJ+hSKKSCM4FBDI4CbgiI43hrMOz6reW1WFO
         91bWhtr/j9+kzy9/FSnqmQFDHlzappuXiq2ULLVh7mKVgyefoP0bNVlPo1uLZb7dhiRD
         yGbwNkLfL0C4tDI4bNbHozbOMh92JTtiJQTmISM6bry5/aE8Cx6jpbRTf8wiuOg3oSm3
         iMMOeByurDRMj4dS5NmQXSeyDmS+8B7RcU3FLjcjJdhfTE3uiU/1zX8grhg3NRJ9ia63
         T+TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794845026; x=1795449826;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qlAA127R2oaYgttGLwgrOOAAhQ02iKpyezBNnMMVfD0=;
        b=GTbNLS47s5js6/mIzE6Pyawf/SNsEfK0FyPyRbRut89ZWQZlTymhV95I8fZpTtmCHv
         DW6AVqGX7X7P2WEAYP5RhgjxG7xX2tqjxqVeUh0Bvf3ynUErIrf2JOblvMQpNyEUBibg
         zVgfc233c1QggKdy/KFxsp9RiQoo6dkvyS13RxUYl5sdhdZNWMxuaKA5VoQYTEEElkZo
         qNfA2oG5HBlsJH1cCZv5ILHiz6TxSfi/d3UomKTzDvy4UyJYbaevTZtrTW3I/gvvjYNE
         p8Uth4sOjDuPhWj7cF34EepW0lKMTWI0K4EyZ1cEVDgHw2zdxYXn6vB9WalUz9/rkCML
         WmAA==
X-Forwarded-Encrypted: i=1; AL+hErHTvu7hNo/7FD9SRsxt0E2dUcyIaCYGGLJlrnq7JM9yu0k94UZkGGk2uiTGa8G6d8h7YmNk4DunRD3o@vger.kernel.org
X-Gm-Message-State: APuU4Z/g8oRTVQckdYHL83wiP9WIb3zx2xGG+a7hs+X/UJBNvTLF1hL6
	HTDjoc97rdIAxu+VJ7HzK31vvRzQg0bn+2yo0b+tlJYF2DdsSfKpGoVfAO9Sg1LqaDE=
X-Gm-Gg: AYBFou2NvC9stCyQA3+0ICu51KKtRlemRx0sFApxN72d9KGUa9Ww3E7qr1Ok5bUggEc
	ZXY/WLgvdDwWCnfeFozCYfl/qt4iQZeBGsNyhGUbPKIjI70xn9LVdkriJ2v1685fGG0X8oie8vt
	TQK515OkQxoOB3eqZaX73Ydofo2fxAKbS2EDqjMbxhwyzqJPDgDNqk4SUVAroVCLLbF+Pd8Quur
	8+Vln2W2zIXiZ/Ma/RPkEN/0ltBKvCYFGjpN6nytnRB9uLOmm97B7zFv+ZRVAQhs1NbeTTNB/G2
	w7Zmx/Usu/GT1Tz6seVerirylS8yEOpW+sLH+ldw3NsGXZOHzwtdiQrrTTPg1eUrNBX1JJ7KZBX
	7ScLJusaK1vcfGy15fOv+GIpe0hF4BHziML+fNe/TSD9trx0Y2XxG+AWS24cz87EDJjvHXqToH+
	Qk+rUmzaXAjZIQf/Msp748l/WjCDxUf45KEs2K9smSvQiyBFVXZUMjKA0l9pKiQ5sVZGGZs+GPg
	6D3CfjR5wkGiDXBRdV36muRHI+qLZwrx7vwp44KHTmgVIVV1AXau2SLBrQEYxdBzX7/H/QnB+Jm
	AVlwHlY=
X-Received: by 2002:a05:620a:2987:b0:93f:2a56:2772 with SMTP id af79cd13be357-9494bcbc465mr1773546485a.78.1794845025968;
        Mon, 16 Nov 2026 08:03:45 -0800 (PST)
Received: from ziepe.ca ([142.166.156.71])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9494c6025f5sm866869585a.5.2026.11.16.08.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 08:03:45 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xSzBI-00000009er1-1WxF;
	Mon, 16 Nov 2026 12:03:44 -0400
Date: Mon, 16 Nov 2026 12:03:44 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Michael Margolin <mrgolin@amazon.com>
Cc: Eric Davis <eric.davis@broadcom.com>, Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH rdma-next v3 00/13] RDMA/core: Ultra Ethernet transport
 verbs
Message-ID: <20261116160344.GB2299285@ziepe.ca>
References: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
 <20261116143656.GA34010@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
 <20261116144830.GN2532299@ziepe.ca>
 <20261116152652.GA8275@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116152652.GA8275@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>

On Mon, Nov 16, 2026 at 03:26:52PM +0000, Michael Margolin wrote:
> On Mon, Nov 16, 2026 at 10:48:30AM -0400, Jason Gunthorpe wrote:
> > On Mon, Nov 16, 2026 at 02:36:56PM +0000, Michael Margolin wrote:
> > > On Mon, Nov 09, 2026 at 08:00:33PM -0800, Eric Davis wrote:
> > > > Ultra Ethernet defines a reliable unconnected transport. A queue pair
> > > > sends to any peer in its job without a connection, incoming traffic is
> > > > demultiplexed on a JobID rather than on a connection, and what a device
> > > > orders is far weaker than IB or RoCE and varies between devices. None of
> > > > that has a home in the current uverbs ABI.
> > > > 
> > > > This series adds the generic half. The objects, methods, and attributes
> > > > any UET device implements. No driver is part of it, though two already
> > > > exist against this ABI. A reference device model that implements all of
> > > > it, and HPE's Slingshot driver implementing a large subset. That is the
> > > > argument for ib_core carrying this. What is device specific should come
> > > > from private interfaces per vendor.
> > > 
> > > Hey Eric,
> > > 
> > > Thanks for posting this. EFA's SRD is also a reliable unconnected
> > > transport (one QP reaches any peer, delivery isn't ordered), so we
> > > looked at the series as a possible second implementor of IB_QPT_RU
> > > that isn't a UET device. Other vendors might also want to support
> > > this interface in the future.
> > 
> > I'm not sure about this. If you have exactly UET programming
> > semantics, including the job, then sure.
> > 
> > But squeezing some EFA specific thing that doesn't follow the spec
> > isn't a good way to build the APIs.. Persumably EFA has its own
> > job-like mechanism for security that is different?
> > 
> 
> I see your point about trying to fit an API to a different use case it's
> not meant for, but I don't think this is the case here. EFA doesn't have
> a job-like mechanism, isolation is handled by the network, so jobs just
> don't apply there.

That sounds like you are saying you have a job for the entire
node. Which isn't the UET model at all.

I haven't looked at these patches, but I understood job should come
from outside verbs as it is something an external entitiy is creating
and then sharing across alot of processes.

If so then EFA could still have a singleton job object and that could
be the deviation. One job only, and the job doesn't actually do
anything to limit access.

Jason
