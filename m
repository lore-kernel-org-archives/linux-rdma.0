Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BFB4028EE;
	Fri,  4 Sep 2026 04:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788497223; cv=none; b=pE7ek7pIVvp7Z/w3LzbnSHPiV9x38BkEXFlSJmFisGMRu5j4dQ8LkfNSzDfUqEchl2atYZIxZOGjbCjrEH/+LCYImVqnjq8cc8FL1fl8u3qo3nsb2XYAbe3aEd48KbqyGklN4EkzTduVMRYd6JPIm56QyUZI/UeP1kgRChO4s9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788497223; c=relaxed/simple;
	bh=AwqOShEIJdBbQ699iE24FcsF3aS6M0VazuAXBEapsVw=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=U/YUpkPq3zylHukojy7BbMNHgZdkO6132PRRll15BYuOK9x/sI3GCZB7kpMjiT3jy4lHwny/bT1drB4xlRbXbXNtviN0ua+9f4z/QnVU2taC+/VYQ5tpwUCDKnCTUyYMQa2SePTGRTe9xrrOZ6sawvEOyc6CHRf8Jk+f7dVikm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R2D2XWFZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R2D2XWFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3666A1F00ACA;
	Fri,  4 Sep 2026 04:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788497220;
	bh=w4ryqUQLjRQpK++qeuJJrLUfbYhyB5v+st0yHndw1MA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=R2D2XWFZH1DR5/7gCVLAE0fBHJ8d5O9owxrNguHbK1/x2kyv9Bq2v4/F0lZhdzE54
	 z5uJ77oas9pu2mxKTBcd2GhmSCPpUSiw/Tewm2lGkTuL6OBGyf2CvbawRu65aY31gM
	 h83dWJaZ72Go5O27ETdrUDh4gIeQMGUa77AIM3eZe4/UcupLyrkq1fsuAvYdGDdQ/b
	 zi7MGLlMaKjD99uayi5NRufcwYy7uzdHdcLSnqRde7xI2g+FWzM70g1P2beZI4xc7w
	 k3x6NUA7rW1u+AMRXbTPA1BFUhnbxW1R7ehN40pWuDgyDr2f4arEE6g+gei794wfFT
	 bSAmeNG1egGOw==
Subject: Re: [PATCH net-next v3 13/13] net: mana: keep the existing queues
 when the channel count is raised
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
Date: Fri, 04 Sep 2026 04:46:58 +0000
Message-ID: <178849721880.4131868.8845620290538329303@kernel.org>
In-Reply-To: <20260901014442.2945689-14-longli@microsoft.com>
References: <20260901014442.2945689-14-longli@microsoft.com>
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

- [Low] Claim of latent double-free/use-after-free: the new helper
  mana_destroy_txq_from()…

--

net: mana: keep the existing queues when the channel count is raised

Growing the channel count now carries the running queues over and builds
only the [old, new) tail, instead of building a full second queue set and
discarding the old one. mana_alloc_qset() loses its num_queues argument
since a count change goes through mana_split_qset() or the new
mana_grow_qset(), and the self-recovery-on-resize-failure capability bit is
advertised to the firmware.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index ae7c664bf76ef..67bfea57e6ed2 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c

[ ... ]

> @@ -2958,7 +2958,11 @@ static void mana_deinit_txq(struct mana_port_context *apc, struct mana_txq *txq)
>  	mana_gd_destroy_queue(gd->gdma_context, txq->gdma_sq);
>  }
>  
> -static void mana_destroy_txq(struct mana_port_context *apc)
> +/* The array itself is left in place: the grow path tears down only a range,
> + * and the queues below @first are still live and still referenced by it.
> + */
> +static void mana_destroy_txq_from(struct mana_port_context *apc,
> +				  unsigned int first)
>  {
>  	struct napi_struct *napi;
>  	int i;
> @@ -2966,7 +2970,7 @@ static void mana_destroy_txq(struct mana_port_context *apc)
>  	if (!apc->tx_qp)
>  		return;
>  
> -	for (i = 0; i < apc->num_queues; i++) {
> +	for (i = first; i < apc->num_queues; i++) {
>  		if (!apc->tx_qp[i])
>  			continue;
>  
> @@ -2991,6 +2995,14 @@ static void mana_destroy_txq(struct mana_port_context *apc)
>  
>  		kvfree(apc->tx_qp[i]);
>  	}
> +}

[Severity: Low]
This isn't a bug today, but should this loop clear the slot after the
kvfree(), the way the RX sibling added in this same patch does?

The comment above mana_destroy_txq_from() says the array is deliberately
left in place, and the loop guard is:

	if (!apc->tx_qp[i])
		continue;

but nothing sets apc->tx_qp[i] = NULL after kvfree(), so for the
[first, num_queues) range that guard can no longer tell "already
destroyed" from "live".

mana_destroy_rxqs_from() does clear its slot:

	mana_destroy_rxq(apc, rxq, true);
	apc->rxqs[rxq_idx] = NULL;

I traced the three call sites and none of them re-reads a stale slot at the
moment:

  mana_destroy_txq()                 -> first == 0, immediately followed by
                                        kfree(apc->tx_qp); apc->tx_qp = NULL;
  mana_create_txq() out: (first != 0) -> caller mana_grow_qset() jumps to
                                        cleanup_rss, skipping cleanup_rxq
  mana_grow_qset() cleanup_rxq       -> falls into free_arrays, which just
                                        kfree()s new_tx without walking it

So the only thing keeping the tail from being torn down twice is the label
choice in mana_grow_qset() below. Would a single store keep the two helpers
symmetric and make that independent of the caller?

>  
> +static void mana_destroy_txq(struct mana_port_context *apc)
> +{
> +	if (!apc->tx_qp)
> +		return;
> +
> +	mana_destroy_txq_from(apc, 0);
>  
>  	kfree(apc->tx_qp);
>  	apc->tx_qp = NULL;

[ ... ]

> @@ -3164,7 +3185,10 @@ static int mana_create_txq(struct mana_port_context *apc,
>  out:
>  	netdev_err(net, "Failed to create %d TX queues, %d\n",
>  		   apc->num_queues, err);
> -	mana_destroy_txq(apc);
> +	if (first)
> +		mana_destroy_txq_from(apc, first);
> +	else
> +		mana_destroy_txq(apc);
>  	return err;
>  }

[Severity: Low]
This is the first standalone caller of mana_destroy_txq_from(): it tears
down [first, num_queues) and returns without freeing the container, so the
freed-but-non-NULL pointers survive back into mana_grow_qset().

[ ... ]

> @@ -3569,6 +3599,11 @@ static void mana_destroy_rxqs(struct mana_port_context *apc)
>  	}
>  }
>  
> +static void mana_destroy_rxqs(struct mana_port_context *apc)
> +{
> +	mana_destroy_rxqs_from(apc, 0);
> +}
> +

[ ... ]

> @@ -4454,13 +4489,161 @@ void mana_discard_split(struct mana_qset *newq, struct mana_qset *tailq)

[ ... ]

> +	err = mana_create_txq(scratch, ndev, old_count);
> +	if (err)
> +		goto cleanup_rss; /* create_txq already undid its own work */
> +
> +	err = mana_add_rx_queues(scratch, ndev, old_count);
> +	if (err)
> +		goto cleanup_rxq;

[Severity: Low]
Related to the comment on mana_destroy_txq_from(): correctness here rests
entirely on this goto targeting cleanup_rss rather than cleanup_rxq.

If a later change routed the mana_create_txq() failure to cleanup_rxq
instead, mana_destroy_txq_from(scratch, old_count) would run a second time
over the tail slots that mana_create_txq()'s out: path already kvfree()d,
re-running napi_disable_locked() / cancel_work_sync() on freed memory.

Is that invariant worth making explicit, either with the NULL store in the
helper or a note at this label?

[ ... ]

> +cleanup_rxq:
> +	mana_destroy_rxqs_from(scratch, old_count);
> +	mana_destroy_txq_from(scratch, old_count);
> +cleanup_rss:
> +	mana_cleanup_indir_table(scratch);
> +free_arrays:
> +	/* Only the containers: every queue they name is still live on @apc. */
> +	scratch->tx_qp = NULL;
> +	scratch->rxqs = NULL;
> +	kfree(new_tx);
> +	kfree(new_rx);
> +	kfree(fresh_tx);
> +	kfree(fresh_rx);

[ ... ]

> @@ -4861,7 +5037,7 @@ int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
>   * Idempotent: a carried-over queue keeps its node; suppressed creation leaves
>   * an error pointer, not NULL, so both read as "no node". Under RTNL.
>   */
> -static void mana_qset_debugfs_publish(struct mana_port_context *apc)
> +void mana_qset_debugfs_publish(struct mana_port_context *apc)
>  {
>  	unsigned int i;
>  

[Severity: Low]
One more consumer of the same convention, now that this is no longer
static:

	if (apc->tx_qp && apc->tx_qp[i] &&
	    IS_ERR_OR_NULL(apc->tx_qp[i]->mana_tx_debugfs))

It treats any non-NULL tx_qp[i] as live and dereferences it. I confirmed it
cannot be reached with a stale array today, because every grow-failure path
frees the container without publishing it, and after a failed
mana_publish_qset() the rollback reinstalls the original apc->tx_qp.

Does relying on that reachability argument, rather than on the slot being
cleared, seem like the right long-term contract for the helper?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260901014442.2945689-1-longli%40microsoft.com
