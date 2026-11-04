Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793803750;
	b=GsmExjWDTQ1xqj350Az/ZxqSVPNaO67bPr2rnryze2HyT7tVoy9YvktfSxEAp+Ez0uvo
	 QNzfT0lUeX0DiiAlVgM+0MBPpXRb1/3lwgv43wNhUR8ksPGHdhVmMN11pBDySekt4RKTg
	 8qzDqvl7L1/kKEt+PKKaqUUAak39zwrFnFVlaF/TJE/mAndt5xNI85DCPgi0NuqYkRRHM
	 v+WhJquLtumYANY5VUwfnQBmBYmWMY2nuxljutYTQ0+/xqHCTxLRebfxU5w4FfSDHkdrw
	 F2/cHDI85ij/VTih+FT1tEFSu9IXcM5flzm1dPGJ65q5dbl4Fc+JMghqCkOpiAg4y0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793803750;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=I7YY+8AyksHgU0ph9C1sWhfXPsM5mf8hu3raDMmkxI0=;
	b=K9hs7QglSvV1HMwZp0oZeTXLInhmJTrZJAt5fVRvDOxBmnChYttNXe5CLC6tVcR1LQxj
	 tr6CIhL69GBERnM+wgy//iiYNT7jjBC/C5jjsIvRb+nxR2JIQ4yekODHj0NA+3cX6hap6
	 /X0eptqB1xuI3X/AUAFdCvvOoQMlrtvOMZCsQYHROfzq8J7cOWf1qX/aK30vX1mQ+L+RW
	 H8Y2iO8n+D7bk405xq+sgt97BwbXqumMWkYMnmzFTesrT/o1u6V4LxPYRBoA6AaAuhabO
	 uxmN1wyB+8zt/QgvmuLnTmRYYXBq20vxTjKf553HQxdGm+2qyw8pAmvL3Aellf5cdtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GbLnpAqO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2205606A336;
	Wed,  4 Nov 2026 14:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GbLnpAqO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF471F000C1;
	Wed,  4 Nov 2026 14:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793803749;
	bh=I7YY+8AyksHgU0ph9C1sWhfXPsM5mf8hu3raDMmkxI0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GbLnpAqO9gMNr/L160s1hh+GbOrziU7YUpYqArhTgyEJtzW77MOBuglTeAzx/JO8/
	 eI82vjaIkWlIqFS31JHGHN8kpJkEmQ9SKYIwcv9XL3Myquom6WUULmuXx9X7yn/O2t
	 SzL6pKKH1EkUma9WKzXrh6LYTN5UkEhL6r4/3j7HmVOaEiHioCu36Nw7jyeACa01ns
	 LK/15SO7Ja2szH43hmYSb/KegLqAgmeuxSGN6F2rJKYAcXUZ7W8IbK9E0zFsFYiAbr
	 xKQc1KZRLHGLzh33QqIUynpnSiJ+tcPAZg1nO8Kn+ykiN5yLZduvw/taMpdF2mXfZ8
	 lbO1p9ZAKOMig==
Date: Wed, 4 Nov 2026 16:49:05 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jaeyeong Lee <lee@jaeyeong.cc>
Cc: Bernard Metzler <bernard.metzler@linux.dev>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/siw: Ignore peer close events on listening endpoints
Message-ID: <20261104144905.GH478286@unreal>
References: <179378222423.73361.5194383282780549988@jaeyeong.cc>
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
In-Reply-To: <179378222423.73361.5194383282780549988@jaeyeong.cc>

On Wed, Nov 04, 2026 at 08:50:40AM +0000, Jaeyeong Lee wrote:
> A TCP child socket inherits the listener callbacks and sk_user_data before
> kernel_accept() associates it with a new connection endpoint. If the peer
> closes during this window, siw_cm_llp_state_change() queues a PEER_CLOSE
> work item against the listening endpoint.
> 
> The worker releases that endpoint without removing it from the listener
> list. A later listener teardown then walks the dangling entry, causing a
> use-after-free in siw_destroy_listen().
> 
> With a listener backlog of at least two, an unauthenticated TCP peer can
> reach this path by resetting a new connection before the accept worker
> runs.
> 
> Ignore close notifications while the endpoint is still listening. Once
> the child is accepted, its sk_user_data points to the new endpoint and
> close notifications continue through the normal path.
> 
> Static analysis identified the issue. It reproduced twice on Linux
> 7.4-rc1 with SIW over loopback in QEMU. KASAN reported the endpoint
> allocated by siw_create_listen(), freed by siw_cm_work_handler(), and
> reused by siw_destroy_listen(). The same reproducer completed without
> KASAN or lockdep reports after this change on one- and two-CPU guests.

Please add full dmesg stack trace to the commit message and resubmit.

Thanks

> 
> Fixes: 6c52fdc244b5 ("rdma/siw: connection management")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jaeyeong Lee <lee@jaeyeong.cc>
> ---
>  drivers/infiniband/sw/siw/siw_cm.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
> index ed49818793dde..518f09a2d37cf 100644
> --- a/drivers/infiniband/sw/siw/siw_cm.c
> +++ b/drivers/infiniband/sw/siw/siw_cm.c
> @@ -1361,6 +1361,8 @@ static void siw_cm_llp_state_change(struct sock *sk)
>  
>  	case TCP_CLOSE:
>  	case TCP_CLOSE_WAIT:
> +		if (cep->state == SIW_EPSTATE_LISTENING)
> +			break;
>  		if (cep->qp)
>  			cep->qp->tx_ctx.tx_suspend = 1;
>  		siw_cm_queue_work(cep, SIW_CM_WORK_PEER_CLOSE);
> -- 
> 2.43.0
> 
> 
