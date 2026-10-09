Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688D14D0CE7;
	Fri,  9 Oct 2026 11:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791547051; cv=none; b=mEqHoK7uYnXr6s5cx0W+rTJANMNNU9U4XyXjaxvtjsxatuHQ5qxGuEVZRJw+f27myA+5mnkXZPqKDU/FRB8Ga2lFUxAwYq7Fxnj0uzQl5Ls4qljODldyWNXIwXbD0sVyx5e53qWjZJzUifEa48Bc6b6CjUUHxOkgOK8UF0STm/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791547051; c=relaxed/simple;
	bh=eooPg2n9iPNRFhAxuYdKaVw7vSM3NMRtcUG2y2oMiSs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CsIxes52ZNmjp3QbuBUD8zHOqQZY/3gItZvmclQwu8BA8cNINGjSzX4zzN8FqM3KzvpxJLgq3JKU5AEF7NeFWolCNYuNZOMT24E4pwsYPbYmpQL2NZV+kqgz7dhJcZeqUqmAK4ylXtfUFOHi5kC3Qz4kA2Yzu1XzisXLgoc+anM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KGH4/92a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KGH4/92a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19CD1F000FF;
	Fri,  9 Oct 2026 11:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791547048;
	bh=etuxrB8opkdzHU19eF0XxZGDl52Q6+ijG3fwOHg1lvc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KGH4/92akH+Y3jBUkiae09npPb6Z4SCqt6OREllfcMj/5x0xHMGCDjv/dzolIoC+s
	 VWojNvFh0taJ3SO9ZMNFpFt9rSyy3bTb7tJ6V7d13n6f58NhT59Ot27XpUTxDCzoa1
	 rQvKvs5XZR7LNa09St5mD0m+B3+7dvINuHQfNL+hg2b9zj9b2f0yDzrp8OIjrI1I5U
	 0cGqFxnRtpHXYmLL85+FysyPf3Kgjzh8lOAopXyjfL2kY6vOx2SrVhbRBnQn+aKPdo
	 PiivoPK3gVaBJJypTDH77TrT2yKBkcoVo0Mk6mrb+Tj0puvFEj2Ba+YL84gsPSZoUm
	 lVfcNYmbCI7Ig==
Date: Fri, 9 Oct 2026 12:57:24 +0100
From: Simon Horman <horms@kernel.org>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
	edumazet@google.com, kuba@kernel.org
Subject: Re: [PATCH net v4 2/2] net/rds: include the scope id in the sendmsg
 connection cache check
Message-ID: <20261009115724.GA83879@horms.kernel.org>
References: <20261008031426.1142344-1-achender@kernel.org>
 <20261008031426.1142344-3-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008031426.1142344-3-achender@kernel.org>

On Wed, Oct 07, 2026 at 08:14:26PM -0700, Allison Henderson wrote:
> rds_sendmsg() reuses the connection cached in rs->rs_conn when its
> peer address and ToS match the request.  The interface index is part
> of a connection's identity as well: rds_conn_create_outgoing() passes
> the request's scope_id down as dev_if, and rds_conn_lookup() compares
> c_dev_if, so sends to the same link-local address through two
> interfaces are two different connections.  The cache-hit test never
> looked at it.
> 
> A socket bound to a non-link-local address has rs_bound_scope_id 0,
> and the scope check at the top of rds_sendmsg() accepts any non-zero
> destination scope for such a socket.  So after a send to fe80::x%ifA,
> a send to fe80::x%ifB hits the cached ifA connection and the datagram
> leaves through ifA, to whichever peer answers to that address there.
> 
> Compare c_dev_if with the request's scope_id in the cache test, so
> that such a send takes the lookup path and finds, or creates, the ifB
> connection - the same key the lookup uses.  With the previous patch a
> send without a destination carries the connected peer's scope, or the
> bound scope for a non-link-local peer, which is what an explicit send
> to that peer computes, so the comparison is exact for it too.
> 
> Found by inspection while reworking this cache for the connection
> lifetime series on net-next; not observed in the field.
> 
> Fixes: 1e2b44e78eea ("rds: Enable RDS IPv6 support")
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Reviewed-by: Simon Horman <horms@kernel.org>

