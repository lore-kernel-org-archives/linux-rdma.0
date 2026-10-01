Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21396359A6D;
	Thu,  1 Oct 2026 12:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790857947; cv=none; b=Og6c4QdC7+Ogi3lYXJtg6Mm2sMUE9MH3o0/LJqf708ndMm4PzHiKEpuxmqVb4fncNq2MfBDY59tAjLrxwub7mAU3OKWO0UPT9ODQyy/zAGHwWx6Qi50jFm6jS5C/Wr2NE5Z6VtAzo+5eBlQMDMQnM9JKWM2pRy48rp3TQXwsIS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790857947; c=relaxed/simple;
	bh=lRMU1L/q7QbD+XnG9tbA3ehiaHk0b0z6U4SlG0Pimug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HUzZWspciHcB+Dqbnow1HsyjtV2EAxGpE0iybLhLyKO9tMMpxHrULlct7JHwQtjio2FDPiWV2QxxULUTDZSP/NPi+AvyO+Y75QbqohGSOUztHUgbf/v8qfHcHOR/Ga79e+7q6yuRcHBjJlGMwVqcD55tDBBYVLxoIToB+gG0oz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sl+crvXf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sl+crvXf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3A61F000FF;
	Thu,  1 Oct 2026 12:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790857945;
	bh=31Y7O8+rEHHGrWTqwpWZQ90jgUOL6HCwEeVW/nO8kdg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Sl+crvXfKXW9/BR6YeaTcdrypfQJMvsUwcnFOqAkS4p75St3o/2v1vImAAbU3Dzog
	 kj5rHFLSi0W5o3UFm/XHg16apni2JO5yW9+KnQEsu/jGXMg+KBDWcoF9L2z8rGFjag
	 IXpgUuLZYg98KRTkgbIJn4daBoQQEYCf4w0kv6dF60uS5PTYME+x8x1L5mSw/S/G5g
	 MGjFQv6wWndXuAggxerfozU70//GtxvTvXA3598JhCW6f2liXT8Zk7gVMZu7CTOV1X
	 mKHhnohaZWhVMPKZbRRtQGrAClvXOWvoO0g0PMGWMwfZGu+gKy2kTQ4CfDgwU+h3OQ
	 MRjZ6HnkuNwTw==
Date: Thu, 1 Oct 2026 13:32:22 +0100
From: Simon Horman <horms@kernel.org>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
	edumazet@google.com, kuba@kernel.org
Subject: Re: [PATCH net-next v4 1/2] net/rds: restrict the rdma_cm ids to IB
 devices
Message-ID: <20261001123222.GB13925@horms.kernel.org>
References: <20260927063058.170273-1-achender@kernel.org>
 <20260927063058.170273-2-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260927063058.170273-2-achender@kernel.org>

On Sat, Sep 26, 2026 at 11:30:57PM -0700, Allison Henderson wrote:
> RDS only has an IB transport, but it never tells the rdma_cm so.  The
> listener created in rds_rdma_listen_init() is therefore installed on
> every RDMA device in the system, including iWARP RNICs, and the id an
> outgoing connection resolves through in rds_ib_conn_path_connect()
> may be bound to whichever device the address resolution picks:
> rds_ib_laddr_check() only vouched for the local address being served
> by one of RDS's IB devices, while cma_acquire_dev_by_src_ip() walks
> every RDMA device for the same address, so a software iWARP device
> attached to the same netdev can win.  The event handler then runs
> the IB transport's callbacks against a device that is not one.
> 
> The rdma_cm has an API for exactly this since commit a760e80e90f5
> ("RDMA/core: introduce rdma_restrict_node_type()").  Restrict all
> three ids RDS creates - the listener, the per-connection id and the
> probe id in rds_ib_laddr_check_cm() - to RDMA_NODE_IB_CA before they
> are bound, so that the listener is only installed on IB devices, an
> outgoing connection can only bind one, and the address check's bind
> fails outright on anything else - which makes its explicit node_type
> test dead, so it goes; the check that the bind produced a device at
> all stays.
> 
> With that, no rdma_cm event reaches RDS's handler from a device it
> has no transport for.  The handler itself still assumes IB: it assigns
> its transport pointer only for RDMA_NODE_IB_CA and dereferences it
> regardless, which is the crash that first surfaced this.  The fix for
> that is a separate net patch, Aohan Mei's "net: rds: fix uninitialized
> trans dereference in CM event handler", and is what stable kernels
> without rdma_restrict_node_type() - which arrived in commit
> a760e80e90f5 ("RDMA/core: introduce rdma_restrict_node_type()") - have
> to take: this patch depends on that API, so stable trees need that
> separate, minimal fix rather than a backport of this one.  The two
> patches are independent and apply in either order.  The
> listener has been on every RDMA device since the iWARP transport was
> removed and left the ids unrestricted, hence the Fixes tag.
> 
> Fixes: dcdede0406d3 ("RDS: Drop stale iWARP RDMA transport")
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Reviewed-by: Simon Horman <horms@kernel.org>

