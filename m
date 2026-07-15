Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3532D3CC323;
	Wed, 15 Jul 2026 08:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784103450; cv=none; b=CbcJntNdVbwvS0hLS0rm19im0/sjWsH4fcrbhHwGlNVf/mLpPq0qkBoo3Hlq7wmfbKkLIFw58qqlKHj6aPi/Tm77vd7OwRVsXU79JH3U8UdLGtRYvwzm3afGm2OXopb+DLVIEPDHGwQPH6knUGrAw+rzBj/eV9e0qayxIxTYLT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784103450; c=relaxed/simple;
	bh=NDnPn99tSJ3fOAU8i9bC6ai56R6tBZ0VQ0+3MhpM2hM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AaqsiOM6zffD2tbodUVntcc3cUKpp7wp8VYF3pvvXmia1NflBumxKtERgjRon+lSujURrAv40ZJHqFBtW3kmOGbKy/bU0qZ6YZe3sY3xhW4PwrrOJRTlc7wAB6uRU6YTZ0Xg0UdJba6tt8MU/v/1Wh40WsNLd6SF8b3COnw4rlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A8xsPKCV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A8xsPKCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E321F000E9;
	Wed, 15 Jul 2026 08:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784103444;
	bh=WxrklDYz43bMAYc9ZNHOm86E82qiHdCRkcvKARYWkfM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=A8xsPKCV7MWR0K7pCkoc7KyMepF+irG7H3TGQD0Xl+VFDoCOVXqbyhS+HDhXyvOoE
	 Tpv0K8HrsNf4oxspj0BBsHZ0M++u2n5TDagNdyF/7UfTF6z+Yg9Z5NUQg6Daaah0ZQ
	 8IwRXeCf5IQmyab2zrufK2Yo1cd8ktjXvrhiSxQe3tbxYfcyjIS2vlLr8t19ypCYUz
	 FPKy5Zot3jm5SH3uL4P9aBnQI7AvCuYfwkmy/+lqtKzN7Nwj0WDVh0F6wueZX0WBoI
	 4n+8S2aD9KvRR8YtsF3SycRO9/SuNCLVFvaGesu2/aTrHbi5hiNMX+vK4zJXptx+9Z
	 32TtVRDqrQ6ag==
Date: Wed, 15 Jul 2026 11:17:20 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Gioh Kim <gi-oh.kim@cloud.ionos.com>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/rtrs-clt: Fix double free on path sysfs failure
Message-ID: <20260715081720.GD21348@unreal>
References: <20260714142838.1723076-1-lgs201920130244@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714142838.1723076-1-lgs201920130244@gmail.com>

On Tue, Jul 14, 2026 at 10:28:38PM +0800, Guangshuo Li wrote:
> alloc_path() allocates clt_path before rtrs_clt_create_path_files()
> initializes its embedded kobject.
> 
> If path sysfs creation fails, rtrs_clt_create_path_files() calls
> kobject_put(). The final reference invokes rtrs_clt_path_release(),
> which calls free_path() and frees clt_path for the first time.
> 
> After the helper returns, both rtrs_clt_open() and
> rtrs_clt_create_path_from_sysfs() continue to access clt_path and call
> free_path() again, resulting in a use-after-free and double free.
> 
> Let the sysfs helper undo the sysfs and stats setup while retaining the
> path kobject reference. After removing the path and closing its
> connections, release that reference with kobject_put() so
> rtrs_clt_path_release() remains the sole owner of the final free.
> 
> This issue was found by a static analysis tool I am developing.
> 
> Fixes: 7ecd7e290bee ("RDMA/rtrs-clt: Fix memory leak of not-freed sess->stats and stats->pcpu_stats")
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> ---
>  drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c | 20 +++++++++++++++-----
>  drivers/infiniband/ulp/rtrs/rtrs-clt.c       | 12 +++++++++---
>  2 files changed, 24 insertions(+), 8 deletions(-)


We have already discussed this multiple times. What is still
missing?
https://lore.kernel.org/linux-rdma/20260428105515.362051-1-lgs201920130244@gmail.com/
https://lore.kernel.org/linux-rdma/20260511130804.773204-1-lgs201920130244@gmail.com/
https://lore.kernel.org/linux-rdma/20260514113834.865530-1-lgs201920130244@gmail.com/

Thanks
