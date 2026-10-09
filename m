Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C704E4DA9D2;
	Fri,  9 Oct 2026 11:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791547041; cv=none; b=SUmfgkoLHcVZQTMna6nQAj0hPcW0fKMMZtupPA9GOiOzoIxnawF4SKhzZdPJeQtIiuBLpU6vpJ6DNONSLbAhGWCcwFGDbgjnA3BRTX0RwZYW2Q8F20S8KOy1iZyFI1UW3aKg1ZaZltvTh59NVLe+t80/XELKFqPgNo8a864/Tl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791547041; c=relaxed/simple;
	bh=v84WXKHBRkIPKMIRWCyBoGuMhQh2i5McFvIimU6RjvM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lkSKZ6W91RCdSGocJB4y+fE3QZHYfZzxsJYOs2Gm0KzpWBPeGiaF7exXgpfxCLqL5wDnaPpkBiqyKYzZ7fiKLjvvwwV5hdBnn/g+TyMfDK3JEbb17ZiKjWbgwUMdPbX/wOGYYHYGfCBf4l9SvqILRM3NN3taspyI1Nx4ezKBOkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=onxaaafG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="onxaaafG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113F81F000FF;
	Fri,  9 Oct 2026 11:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791547035;
	bh=mnj7YWVL8un/+HEREsby3Xeusast07rN6RHjgO1tuD4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=onxaaafGHlAm5rfwt/JyK38iBsLmQkPz8/pundpp99RN2mUwrhoEkVphijH3/xw5o
	 ZG3DxYO16UmshwveCQpopyUuRjNTyBu22rFfcpFnD9hSqfQRjVliFpr0dWLCE3nQqZ
	 rGL7kTJrFZiMAe2IJd+9OswXE1prDLgozBimJn2ZEOoi4IVGDBHjPEniLWc+gbB7hR
	 Y+/SjEzHeBNh3XHoiD7BCRSZcmKB2s112DFEHXs1hLVtitXHzB05I/fIpieYhvGVlD
	 eiEh/0U2+4GC7tygaF09qxFJDv7cftHVXBRuPyy20S0D87WJlLFoTo1hffpUXD9HHi
	 dUhncXHBIsPIg==
Date: Fri, 9 Oct 2026 12:57:11 +0100
From: Simon Horman <horms@kernel.org>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
	edumazet@google.com, kuba@kernel.org
Subject: Re: [PATCH net v4 1/2] net/rds: keep the connected peer's scope id
 apart from the bound one
Message-ID: <20261009115711.GZ83879@horms.kernel.org>
References: <20261008031426.1142344-1-achender@kernel.org>
 <20261008031426.1142344-2-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008031426.1142344-2-achender@kernel.org>

On Wed, Oct 07, 2026 at 08:14:25PM -0700, Allison Henderson wrote:
> rds_connect() has nowhere to keep the scope of a link-local peer, so
> it stores it in rs_bound_scope_id, the scope of the socket's own
> bound address, for rds_bind() to check a later link-local bind
> against.  That field is then also what a send without a destination
> uses as the request's scope, what getpeername() and recvmsg() report
> as the peer's scope, and what a later bind() overwrites:
> rds_add_bound() stores the bound address's scope unconditionally,
> which for a non-link-local address is 0.
> 
> So after connect(fe80::x%ifA) followed by bind(global), a send() with
> no destination asks for fe80::x with scope 0.  rds_conn_lookup() keys
> on the interface, so that finds or creates a connection with c_dev_if
> 0, which the TCP transport then tries to connect through
> sin6_scope_id 0 and tcp_v6_connect() rejects for a link-local peer:
> the connected socket's data is queued on a connection that can never
> come up.  In the other order, bind(global) then connect(fe80::x%ifB),
> the connect leaves a global-bound socket with rs_bound_scope_id ifB,
> so sends to other link-local peers are refused as off-link and sends
> to global peers inherit a meaningless interface.
> 
> Give the connected peer its own rs_conn_scope_id.  rds_connect()
> records it there and leaves the bound scope alone, rds_bind()'s
> connected-socket check compares against it, and the destination-less
> send takes its scope from it - falling back to the bound scope for a
> non-link-local peer, so that send() and sendto() to the connected
> peer compute the same scope, and so the same connection.
> getpeername() reports the connected peer with its own scope, and
> recvmsg() reports a sender with the connected peer's scope when there
> is one and the bound scope otherwise, as before.
> 
> Found by inspection while reworking the sendmsg connection cache; not
> observed in the field.
> 
> Fixes: 1e2b44e78eea ("rds: Enable RDS IPv6 support")
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Reviewed-by: Simon Horman <horms@kernel.org>

