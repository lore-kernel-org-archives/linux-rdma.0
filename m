Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B04B265623
	for <linux-rdma@vger.kernel.org>; Tue, 11 Aug 2026 16:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786465831; cv=none; b=Du6S31nUHorgNzLPT+MadmkE30Mrs41ckD7w1kXFqJVgDXuelrju6oEQeiMuU8rMxZG9ozgRzLfhvye6HeDr2Awnex15JP4yP9kPnxHwGjw5dbj+eIvrIhOuf3LKT1B4TV24OyoOQVCrndWQk9Udxz6QIyY5+Ze87wTdOlQ7j30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786465831; c=relaxed/simple;
	bh=SM6qLrDNeg9vFk8KqzmJ/DQe6oNlCHUaqP/o60YF8d0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dWrMk+P5O0xLsCzzBZkDK34WWWPz9rB3H5pjZ8+rjbtbwtEK6jKi+1OQI75jfysv7DdUg6TIPHJAsB4gGk0JfYBiboGcBVkptc6OUDMPB8TRT4Wo2r/ly5220Qe+wwSnA3BYo4EIoNK+4+rLTyBIi0G5R2A8Vt0VqxcMmwtvVrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=knLdXF3C; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="knLdXF3C"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-9061a795d76so179416d6.3
        for <linux-rdma@vger.kernel.org>; Tue, 11 Aug 2026 09:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1786465827; x=1787070627; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fd5GTS91/o1W5I/k7tggRvZ4xiPBkudvkWkOp9orKvI=;
        b=knLdXF3C8fjEEZzNk5yqADaLCSm6IvAi0vcf1UahmI6WcWmORGXuqyghjkpMJZpnOm
         xUVZMXMSr1bMD5Lurol3nHDNgZa2X+o0y0H2AvugRyfz+5eUHa4wiuYgL4v8DpNLsRBx
         GSfQsyQ+pbkhtwyhUK0hMvkT3Ryrsx7T2aUWswxxJPUds+KAQIkf+8vxyEaQueDjKJMm
         jAG1SjaN2eBOvhZd4CaB/knsPDZn9gZ7MNIXThn0r2l5VTrCp1ySxMkrJg20c4QgcJF9
         SXbbFenZX+Q2A1ToD4Lim5Q9gilJzhKnkSqkWv51c0Eys2DHnbDyxJUeJp34DebFP928
         zJcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786465827; x=1787070627;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fd5GTS91/o1W5I/k7tggRvZ4xiPBkudvkWkOp9orKvI=;
        b=dW9+NARc2jJkviUt4Otx6aJ6pC/rH2PAHjK+nXYOf9XsgKTecip8qjOGzYDk3qWk/v
         kPBY++3oGLrv4EbdDm8N4FOQQ/QxYahfYyB27hNBrcenEXj1G+EmPgJOiCnbm6/0Xrcc
         9jG2kINqxJIXxL79xHA1hnrqoYkoWMEfpZN00dIaN+YoPx4evMTS8lrQ6ailcC3Mq6O3
         9aXvblzD4LV7IVizyDVAwu0VevcwnqvSINOT3qyduY6dDRxlfkGkueO31NMa0gcHart0
         N8fLGCzVD+vaoSxM5m1KnJrIogw4Wc/FbMWHZrBkCGw5/lYtvAem9OLUaFbOrLqKjqXR
         duLw==
X-Forwarded-Encrypted: i=1; AHgh+Rql9hnDkJ7cDv20jTLruh8sKYQR/l1t5bZnZUxRi41+lVKHUvwduxTxLF1vKnKmFRplo+r9QABdW5Z5@vger.kernel.org
X-Gm-Message-State: AOJu0YwxK+3fw9CC3oYMis+c3JZq9HmYNrOC0xjRxk31+J7I79NZi+76
	PWb6SIAHILAFtqPBo6YD6VSN18B0U5d3WGVd4Y3ZJqpeyYXjwZF1KYUrvMNgnxqDf4A=
X-Gm-Gg: AR+sD13/KRFu37/pV1DdflOWJd9ooIsCO5IQz0Wu2K0jvLpYrFot6mFLIYwtfN922tf
	tu2yaBwMMaZek8lISASvgky/Z7Rwja2uiptKwEU2Fxn4mo2DjDuDulUF7Q5DCrROEHfmDidu8/f
	UfyTsYDP7URE+HmnsBs06A874OMpLPIsfIC3LGN7rJ7v+6ihDal7JUPnK80GNWgn1sHfLqpkapA
	ZhfJMuQe4r2zdBf8yefREvBrrDbW6RiAA8RVTBp+5cUJ+I+GkrV3sMiUH/Z1y6t/LAWlSPjVI3X
	dVfyQilXzGRgDgxxgB+YQtxxYlk66BMMhKd1TbuJqKC27+FdXr0Eam54qafO0fa2FQoPgh1imph
	hZOSyZKm0WXvlXDanzUNBKtFEW6GFZLUAXLrHf3H22yW+2IDumbGP5U5PU0r9xSTZRUUawbW0qk
	XjyK3fLptDmRTq1xDipD4wAW9BNjCpqIddxETS9w==
X-Received: by 2002:a05:6214:588f:b0:905:6e01:b9a3 with SMTP id 6a1803df08f44-90a66b6ea11mr44100186d6.31.1786465827094;
        Tue, 11 Aug 2026 09:30:27 -0700 (PDT)
Received: from ziepe.ca ([142.166.156.215])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90a6c3c0338sm2416026d6.40.2026.08.11.09.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 09:30:25 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wtpMv-00000002YJ3-0Ae6;
	Tue, 11 Aug 2026 13:30:25 -0300
Date: Tue, 11 Aug 2026 13:30:25 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Krystian Kaniewski <krystianmkaniewski@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org, Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	syzbot+5fe14f2ff4ccbace9a26@syzkaller.appspotmail.com
Subject: Re: [PATCH net v3] RDMA/core: Reject unregistering netdevs in
 ib_get_eth_speed
Message-ID: <20260811163025.GM544626@ziepe.ca>
References: <20260810133124.44513-1-krystianmkaniewski@gmail.com>
 <20260810113308.5db6937e@kernel.org>
 <20260810183902.GD507588@ziepe.ca>
 <de87c6a6-44c9-4b78-991b-ff858e21e806@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de87c6a6-44c9-4b78-991b-ff858e21e806@gmail.com>

On Tue, Aug 11, 2026 at 11:21:19AM +0200, Krystian Kaniewski wrote:
> Thanks for your comments. It's my first contribution really, so I'm still
> learning on how to do it properly.
> 
> I'll do the requested changes by both of you.
> 
> Should I rebase the v4 patch on top of any specific branches for rdma?
> 
> I found "for-rc" branch while looking at
> https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git, would it be a
> good target?

At this point the for-next branch is a better choice

Jason
