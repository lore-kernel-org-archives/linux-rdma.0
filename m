Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793779250;
	b=TMNNYG1Xw8NnR+u8f4gRLyjlYl4KLh5P6iPctM2NbXgWC2s8xCXU9LV4s23LrJGhF2TX
	 lT2U941QuVEhhmOCa1XMjpJ4l2HtOjU+KXqfC4HTbIYy8icFSzZGaL31vkSa/oqxWAqSk
	 /zbB4eP9BOZkA2E9QtND+7Pd01wc5+pM4Tse6Tkrlx25cUGkXqH+yXVQuFHjAOjYkyqcJ
	 uNPzTPqtqV2YbA8YO1sofyCX7ilB2LHsxGIZtAvsbXfe2Fh3pk/GF4bTdCluZ8WesMoD5
	 9aoEP6nMEaLpvbBGg3ZYDXwwyxn+kQVhFyb/N2bXmLpU321PP6hGuAJCFMhTA8uErJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793779250;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=In4z4+Js6PJ5Im8vPPoRP4f2dKYPIb0IHpEUKBmDhbw=;
	b=vUuRJ5BhBuRoNvp+Mh7jmlph0MIDNeRmKwfzR6Lx3CIHoxg7wGYqi4VQ+pysRIOCwUHq
	 SD2jvW1LYx1loqlySDDi9B8WgdtleL6a2KqVoBCK80QuHTMyUfsvMfe6dR84USrjGhu8b
	 /mCfm8MojXpczsrN5JdFT+3falZPQzOxl9NIkTgRc2Mos8S35UgJoT4SZKbrGl1JGzxds
	 NpjITNf/o0aB9S9nKMNQtMOew3KfP+5ZZnyYG+fjRisp1JOTOPI2QyYAkamCCIpMV7ePs
	 FqkxSRctROIgX/e4BF3ZBpagfVl8NeM+/FyKVjhYC/cQhyQY6rqQYCcQiiWg3cvQgAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hg+lYTkE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714BF606A31B;
	Wed,  4 Nov 2026 08:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hg+lYTkE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7338B1F000C1;
	Wed,  4 Nov 2026 08:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793779250;
	bh=In4z4+Js6PJ5Im8vPPoRP4f2dKYPIb0IHpEUKBmDhbw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hg+lYTkE8xQnp4pFtLYJUzu4krurZY5zInCALlUsL4ly8+wjkuMu5v7bcVfnlciiG
	 H4eNUDWB7UvErAufuB1t/90KWD43/xnPsB3Wu/c21lxZzQD+kyORejMbRjwMCtKuuC
	 eTRnA3MKhvkYngmFAm1SvZm1OkOmPK0ZiLeG6cskpyOxw0Fd0xMQ8PhDlbMsB7XtSY
	 YezKrUxNyypGRKqPiJ3o+tguE45u7XtJjMICMfBQ1YPAB10Enu0dM00kZ+wBHNlj32
	 /hie4tFhTyPbPTKbDRYrMNYbmIZ6Hnsl4i2HXPMrdQxhZkiKEgZgIGIzNG/CAPGZFv
	 EML3rY7DTWvOQ==
Date: Wed, 4 Nov 2026 10:00:45 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: jgg@ziepe.ca, metze@samba.org, stfrench@microsoft.com,
	xiongweimin@kylinos.cn, yanjun.zhu@linux.dev, ammrat13@gmail.com,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzbot+6699995b421c8ec7d2fe@syzkaller.appspotmail.com
Subject: Re: [PATCH] RDMA/cma: Don't warn when device removal races with
 rdma_resolve_addr()
Message-ID: <20261104080045.GM264423@unreal>
References: <20261101105615.20253-1-kartikey406@gmail.com>
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
In-Reply-To: <20261101105615.20253-1-kartikey406@gmail.com>

On Sun, Nov 01, 2026 at 04:26:15PM +0530, Deepanshu Kartikey wrote:
> rdma_resolve_addr() on an unbound ID (RDMA_CM_IDLE) first binds it with
> cma_bind_addr() and then moves it from RDMA_CM_ADDR_BOUND to
> RDMA_CM_ADDR_QUERY with a second cma_comp_exch(). These are two
> separate steps. Once the ID is bound it is attached to the device, so
> cma_send_device_removal_put() can find it and set RDMA_CM_DEVICE_REMOVAL
> before the second step runs. The exchange then fails and hits the
> WARN_ON() added by the commit below.
> 
> syzbot triggers this with RDS over rxe, where rds_connect_worker()
> calls rdma_resolve_addr() while the rxe device is being deleted:
> 
>   WARNING: drivers/infiniband/core/cma.c:4120 at resolve_prepare_src
>   Call Trace:
>    rdma_resolve_addr
>    rds_ib_conn_path_connect
>    rds_connect_worker

Please never trim kernel dump stack and add full splat.

> 
> This is a valid race and not a kernel bug. If removal wins before the
> bind, cma_bind_addr() already fails and the error is returned to the
> caller, and err_state in the same function already ignores a failed
> state exchange. The caller gets -EINVAL, and RDS destroys the ID on any
> error from rdma_resolve_addr(), so nothing is leaked.

Why is this a valid race? The expectation is that when a device is removed,
the ib_client is notified first and then deleted. RDS should stop all
communication with the underlying device so it can be unregistered cleanly.

> 
> Drop the WARN_ON() and keep returning -EINVAL, and document in a comment
> that the state may change because of device removal.

I think that it is not correct and the issue is in RDS.

Thanks

> 
> Reported-by: syzbot+6699995b421c8ec7d2fe@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=6699995b421c8ec7d2fe
> Fixes: 732d41c545bb ("RDMA/cma: Make the locking for automatic state transition more clear")
> Tested-by: syzbot+6699995b421c8ec7d2fe@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
>  drivers/infiniband/core/cma.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 337a49d1acf7..46741c1fd34b 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -4117,8 +4117,8 @@ static int resolve_prepare_src(struct rdma_id_private *id_priv,
>  		ret = cma_bind_addr(&id_priv->id, src_addr, dst_addr);
>  		if (ret)
>  			return ret;
> -		if (WARN_ON(!cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND,
> -					   RDMA_CM_ADDR_QUERY)))
> +		if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND,
> +				   RDMA_CM_ADDR_QUERY))
>  			return -EINVAL;
>  
>  	} else {
> -- 
> 2.43.0
> 
