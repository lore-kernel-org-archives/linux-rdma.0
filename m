Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B144078E9;
	Fri,  4 Sep 2026 04:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788497217; cv=none; b=UycIOgrc8URXeUFiVpW0kZX2SYM2rIo/KV5Fc2boRXujLb2CqZs4nR4ZFvnYuDc/2q5MOhNnNTlDs6zRPcUEYntCDAvHVdJDCt9ZtrRdPJLq61rdAGOkZDgtZs6ex3Hb4vEHmMMGJ1VO0EDHmh8Y9nxBOde+FryaIeefezQQk/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788497217; c=relaxed/simple;
	bh=mrwkMv76ipxkle2wFg3ooQWmzwu38I0EWdmvFna7p1M=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ez2pc1ijrevTtq0hbTBdG+0Dz89dZK6ShoNant0jgl5MklORDRVy73D4X3wdUxUVz6CUabB8Q94WEQvp9aLjnmg8jX115OfkS7AAUx/m14gmSasaTPIg2zZOIOgJAXwf9RMOUNJUWgtsVayG3lXI6lSE/iSSR9lkPi3R6yU/QwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hTlLqmAk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hTlLqmAk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6651F00A3D;
	Fri,  4 Sep 2026 04:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788497210;
	bh=v1bVrfEOm8UTfaQGmsv6VhKXH9sLNH8eu1Wk0+4Sg3A=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=hTlLqmAkRmpuCdnNBxDvbaYihvspAG7IGSqH0JJhsFFbErOMF6KP/wFIn4V9EuYYN
	 VNsxIBjkQ72M0OrBizOZ9Fm2R54aS8B7ifXmKG4GIwbZc9B/kRDSHdafYq/Ibb5567
	 V6zlO7I6ZGT3PwNSJp438/xWaUm1hHOqsf0SGIKbL6ciWQ320MwroJFF1ltHS+SBaS
	 /+3FR3Ihmw9U6Nx95SZTSsxwzatuyNZTx8wQf+htwj/gQ4BMldi1Hz5uKBWzv9Ftml
	 WPl8hh6HEqy2MOzfgd93PblNOyf90tWTlaJzRlLWuNTmghA+G13x40iGFEyUGLbqBG
	 3zeUzCddOBz4g==
Subject:
 Re: [PATCH net-next v3 07/13] net: mana: swap queue sets in mana_xdp_set
From: netdev-bot+sashiko@kernel.org
To: longli@microsoft.com
Cc: kotaranov@microsoft.com, kuba@kernel.org, davem@davemloft.net,
 pabeni@redhat.com, edumazet@google.com, andrew+netdev@lunn.ch, jgg@ziepe.ca,
 leon@kernel.org, haiyangz@microsoft.com, kys@microsoft.com,
 wei.liu@kernel.org, decui@microsoft.com, shradhagupta@linux.microsoft.com,
 horms@kernel.org, ernis@linux.microsoft.com, stephen@networkplumber.org,
 shirazsaleem@microsoft.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Fri, 04 Sep 2026 04:46:48 +0000
Message-ID: <178849720830.4131868.15408619523737884191@kernel.org>
In-Reply-To: <20260901014442.2945689-8-longli@microsoft.com>
References: <20260901014442.2945689-8-longli@microsoft.com>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 0 · Low: 1

- [Low] The rewrite silently repairs a real, user-triggerable failure-
  path bug in the code it replaces, without documenting it or carrying a…

--

net: mana: swap queue sets in mana_xdp_set

The patch converts mana_xdp_set() from the detach/attach sequence to the
pre-allocate-and-swap scheme, so the RX queues are rebuilt for the new
buffer layout before anything live is touched. The XDP program becomes
part of struct mana_qset so it is installed and rolled back together with
the queues it was sized for.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
> index e16ce2a071583..d2093625956bb 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c

[ ... ]

> @@ -198,46 +205,46 @@ static int mana_xdp_set(struct net_device *ndev, struct bpf_prog *prog,
>  		return -EOPNOTSUPP;
>  	}
>  
> -	/* One refcnt of the prog is hold by the caller already, so
> -	 * don't increase refcnt for this one.
> -	 */
> -	apc->bpf_prog = prog;
> -
>  	if (apc->port_is_up) {
> -		/* Re-create rxq's after xdp prog was loaded or unloaded.
> -		 * Ex: re create rxq's to switch from full pages to smaller
> -		 * size page fragments when xdp prog is unloaded and
> -		 * vice-versa.
> -		 */
> -
> -		/* Pre-allocate buffers to prevent failure in mana_attach */
> -		err = mana_pre_alloc_rxbufs(apc, ndev->mtu, apc->num_queues);
> -		if (err) {
> +		scratch = mana_qset_scratch_alloc(apc);
> +		if (!scratch) {
>  			NL_SET_ERR_MSG_MOD(extack,
> -					   "XDP: Insufficient memory for tx/rx re-config");
> -			return err;
> +					   "XDP: Insufficient memory for re-config");
> +			return -ENOMEM;
>  		}
>  
> -		err = mana_detach(ndev, false);
> +		err = mana_alloc_qset(apc, scratch, apc->num_queues,
> +				      apc->rx_queue_size, apc->tx_queue_size,
> +				      apc->priv_flags, apc->configured_mtu,
> +				      prog, &newq);
>  		if (err) {
> -			netdev_err(ndev,
> -				   "mana_detach failed at xdp set: %d\n", err);
>  			NL_SET_ERR_MSG_MOD(extack,
> -					   "XDP: Re-config failed at detach");
> -			goto err_dealloc_rxbuffs;
> +					   "XDP: Re-config failed at alloc");
> +			mana_qset_scratch_free(scratch);
> +			return err;
>  		}

[Severity: Low]
Does this hunk quietly fix a failure-path bug in the code it replaces?

In the removed version, apc->bpf_prog was assigned before any allocation:

	apc->bpf_prog = prog;

	if (apc->port_is_up) {
		err = mana_pre_alloc_rxbufs(apc, ndev->mtu, apc->num_queues);
		if (err) {
			NL_SET_ERR_MSG_MOD(extack,
					   "XDP: Insufficient memory for tx/rx re-config");
			return err;
		}

That early return skips the err_dealloc_rxbuffs label, which is the only
place that restored the old pointer:

	err_dealloc_rxbuffs:
		apc->bpf_prog = old_prog;

So on -ENOMEM from mana_pre_alloc_rxbufs() the attach is reported as failed
to userspace, the BPF core drops the caller's reference, and apc->bpf_prog
keeps pointing at the released program. A later mana_xdp_get() consumer such
as mana_chn_setxdp() from mana_alloc_queues() (next ifup, or after a reset)
would then bpf_prog_add() on that pointer.

The new code leaves the live configuration alone until mana_alloc_qset() and
mana_publish_qset() succeed, so the stale pointer can no longer happen.

The commit message only mentions the queue swap and the window where queues
ran without a program:

    The program becomes part of the queue-set configuration, so it is
    swapped atomically with the queues it was built for and restored by the
    rollback path. Program references follow the same swap, so attaching no
    longer leaves the queues briefly running without one.

Could it also note the corrected failure behaviour? The defect appears to
date back to 730ff06d3f5c ("net: mana: Use page pool fragments for RX
buffers instead of full pages to improve memory efficiency."). Since this
refactor is not backportable, would a separate minimal fix for net, or a
Fixes tag, help stable triage here?

>  
> -		err = mana_attach(ndev);
> +		err = mana_publish_qset(apc, &newq, &oldq);
>  		if (err) {

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260901014442.2945689-1-longli%40microsoft.com
