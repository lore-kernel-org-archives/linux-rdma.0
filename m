Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF0637AA9E;
	Sun, 11 Oct 2026 10:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791714879; cv=none; b=LLH+nh7VSipzsE3NjBRgUygN6lIbhHhOkoj+Cvq5yRcfNo6oFHP5oalMirMk/OjNkkC7aHZBhtlr+rkVE7B0hCoLZAH2326VzKvmBbkvpgj4AS0uiZriKgGj7xgSKWFQUWKVNVzVhZLi/dJn/uip6eEnzt0945VJO0aduR70+bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791714879; c=relaxed/simple;
	bh=NOo7j1H9AH366+ck3fSKrd/N/DCyKEjgWiSYfSjyQCo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UVFldvuZbOfLJBa0NmCGRiOCarULSXx9zzI9JQIVT4pXN4W1qhYtzrbvJVgAJ75nN8rtVsxOdK9+iFB0/xnBXnc5wHUl4iN72I0q8esTSp2R1MpNF1ApVaJYThM9lSEqdXHaNzVi7GLTaceVsdKNYJlZcAfODUh2i3ORVdVZEIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fpmdJURV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fpmdJURV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8041F0089B;
	Sun, 11 Oct 2026 10:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791714878;
	bh=icm2LtJfPODYQnA9wYSVo4ITb9OjHw/HtenDlAvctjQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fpmdJURVzA3Zyv9Rhdq88PScXzTS2sNAmco0YA2NUcK4peAFfF0QWppF0hC/4RcUs
	 pvsa4yDHEFHGSSNAPZwVm/GY58TK81rwv8Zvl6+XskUQ8HEjyxAXrUQqMePggJWh8o
	 +jrpjWHqvZRbO+qYwlVlkfPPLdlCH3Xo9lxgCXkK+6wcg6etk/FJZi0ZhlNb7CQOHR
	 pm13eqN8Voh5MV6GI9mFnzlw3b3E48HbtVXkkad/Ogmg0Ls5dp8nWR+d23DmB6Tvp9
	 vQCLoulU49E6ShODaogBy0gN548SZh/9eujZulIODgsd0rqTfwPWdwgX0DO2Kmdr+I
	 9QiVTjjeE8rNw==
Date: Sun, 11 Oct 2026 13:34:33 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Palla Raghunath <raghunathpalla.0209@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
	Brigham Campbell <me@brighamcampbell.com>,
	linux-kernel-mentees@lists.linux.dev,
	syzbot+ae549381b4daac2895b1@syzkaller.appspotmail.com
Subject: Re: [PATCH] RDMA/cma: wait for addr_handler() to finish in
 rdma_destroy_id()
Message-ID: <20261011103433.GB27033@unreal>
References: <20261004112613.18171-1-raghunathpalla.0209@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261004112613.18171-1-raghunathpalla.0209@gmail.com>

On Sun, Oct 04, 2026 at 12:26:13PM +0100, Palla Raghunath wrote:
> syzbot hit a use-after-free of id_priv in addr_handler(). The bad read
> is in debug_mutex_unlock(), from the last mutex_unlock() of
> handler_mutex, and the memory was freed by ucma_close() ->
> rdma_destroy_id().
> 
> addr_handler() moves the state from RDMA_CM_ADDR_QUERY to
> RDMA_CM_ADDR_RESOLVED (or RDMA_CM_ADDR_BOUND on error) under
> handler_mutex. If rdma_destroy_id() runs at that point, it waits on
> handler_mutex. When addr_handler() unlocks, the destroying task can take
> the mutex before mutex_unlock() has returned. It then sees a state other
> than RDMA_CM_ADDR_QUERY, so cma_cancel_operation() skips
> rdma_addr_cancel(), and _destroy_id() frees id_priv. mutex_unlock() in
> the work then touches the freed lock:
> 
>   ib_addr work                         close()
>   addr_handler()
>     mutex_lock(handler_mutex)
>     ADDR_QUERY -> ADDR_RESOLVED
>     ...                                rdma_destroy_id()
>                                          mutex_lock(handler_mutex)
>     mutex_unlock(handler_mutex)
>       owner cleared                      gets the mutex
>                                          state != ADDR_QUERY, no cancel
>                                          kfree(id_priv)
>       debug_mutex_unlock(lock)  <- use-after-free
> 
> Documentation/locking/mutex-design.rst says mutex_unlock() may still
> touch the mutex after another task has acquired it, so handler_mutex
> can't be what keeps id_priv alive here. The comment in
> cma_cancel_operation() assumes it can. Before commit 722c7b2bfead
> ("RDMA/{cma, core}: Avoid callback on rdma_addr_cancel()"),
> addr_handler() held a reference on id_priv until after mutex_unlock(),
> which covered this.
> 
> So in rdma_destroy_id(), call rdma_addr_cancel() before taking
> handler_mutex if a resolve was ever started on this id. The req stays on
> req_list until the callback returns, so rdma_addr_cancel() finds it and
> cancel_delayed_work_sync() waits until addr_handler() is really done.
> This doesn't deadlock with the work itself. When addr_handler() destroys
> the id because the event handler returned non-zero, it uses
> destroy_id_handler_unlock(), not rdma_destroy_id(). Event handlers also
> run with handler_mutex held, so they can't call rdma_destroy_id() on
> their own id anyway.
> 
> There's no reproducer from syzbot, so I made the window bigger with a
> debug-only mdelay(1000) after the mutex_unlock() in addr_handler(),
> followed by a read of handler_mutex.magic. A small test program creates
> an id, resolves an address on an rxe device and closes the fd while the
> work sits in that delay. Without this patch KASAN reports the same
> slab-use-after-free as syzbot (1048 bytes into a kmalloc-2k object,
> freed by ucma_close()). With it the test runs clean, and close() just
> waits for the work to finish.
> 
> Fixes: 722c7b2bfead ("RDMA/{cma, core}: Avoid callback on rdma_addr_cancel()")
> Reported-by: syzbot+ae549381b4daac2895b1@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=ae549381b4daac2895b1
> Signed-off-by: Palla Raghunath <raghunathpalla.0209@gmail.com>
> ---
>  drivers/infiniband/core/cma.c | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 337a49d1acf7..24235eb0c49b 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -1968,10 +1968,10 @@ static void cma_cancel_operation(struct rdma_id_private *id_priv,
>  		/*
>  		 * We can avoid doing the rdma_addr_cancel() based on state,
>  		 * only RDMA_CM_ADDR_QUERY has a work that could still execute.
> -		 * Notice that the addr_handler work could still be exiting
> -		 * outside this state, however due to the interaction with the
> -		 * handler_mutex the work is guaranteed not to touch id_priv
> -		 * during exit.
> +		 * The addr_handler work can still be finishing its
> +		 * mutex_unlock() after it has left this state.
> +		 * rdma_destroy_id() waits for that before it takes
> +		 * handler_mutex.
>  		 */
>  		rdma_addr_cancel(&id_priv->id.route.addr.dev_addr);
>  		break;
> @@ -2121,6 +2121,17 @@ void rdma_destroy_id(struct rdma_cm_id *id)
>  	struct rdma_id_private *id_priv =
>  		container_of(id, struct rdma_id_private, id);
>  
> +	/*
> +	 * addr_handler() can still be in mutex_unlock(&handler_mutex) after
> +	 * it has moved the state on from RDMA_CM_ADDR_QUERY, and
> +	 * mutex_unlock() may touch the mutex even after we have taken it.
> +	 * Wait for the work to finish before we free id_priv. The req stays
> +	 * on req_list until the callback returns, so rdma_addr_cancel() will
> +	 * find it.
> +	 */
> +	if (id_priv->used_resolve_ip)
> +		rdma_addr_cancel(&id->route.addr.dev_addr);
> +

It may call `rdma_addr_cancel()` twice. This is probably harmless, but still
undesirable.

Thanks

>  	mutex_lock(&id_priv->handler_mutex);
>  	destroy_id_handler_unlock(id_priv);
>  }
> -- 
> 2.34.1
> 
