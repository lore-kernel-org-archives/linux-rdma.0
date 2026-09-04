Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE023F58E9;
	Fri,  4 Sep 2026 04:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788497216; cv=none; b=RpcYrINBpNZA5ZA8U9kOUwtes7y9/HHGhqdMZrl7bEdB0PSu96RJJt8iD1Jwe89tDFAwxWWisoC572FYgXktI7t4C9o5aAoaLLy2bqkeyctf6Tj1oOKRB6HrOJcJi4B1J56jNGInMdO4vnMNO+UuV75XEneAOf3q1mbAdFja6xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788497216; c=relaxed/simple;
	bh=W56N4t6I4HjGQK1hogyVA+hHqypn6jpORLJu/xGKvZM=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VP1puGAzFpmlFbwt+7ykatOucJjLVmnhrGfBkC4GfD5yZsbQXK6JkICaD2l0A4MwTTAmcouYX99faDzcPc77DgFTFb3O8HTtJL5fevv4WSWTkhgWsEqi4kDip6vthFppvRbOQaMGW7RtXzugAlrJl5WeQ9voSRgPRUaSeCpx/F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MolYAJF5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MolYAJF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD431F00ACA;
	Fri,  4 Sep 2026 04:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788497215;
	bh=2kmFX9vwJvTT0sA2enn+IbDETQYPV/ns2zKHt9VF4pg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=MolYAJF5kt5TxOu/gjrWrdozBoL6apBuUQAo1rygqDX6zdhHd5XRX/nb169sfhkLA
	 4A2BKnFRcxAL6AgAfGM/7k5PjuUQEugLcd6Ox87MupsdWTiFhOu2uCnA5uOpVoWA7Q
	 3z/DnAPZYQtIRYXk3PemHKISuL54WCsSMxJufnCFtUkQUzOtfpEQ3I947bIGMChfno
	 myqP7vnP4UXhbsVAbJOxx9zw1sDNFMgEOiW24mHXh3B0J6E5dzmui0O2RjtB8iZ0jk
	 8YfKhymDkwO1OKNJ6tG6w4ZSa1agKC9NQ4gF/G6IPGZs6HOTPKmbt3CQQXRtH/tURT
	 aZI6mFXpht98w==
Subject: Re: [PATCH net-next v3 10/13] net: mana: release EQs left idle by a
 channel-count reduction
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
Date: Fri, 04 Sep 2026 04:46:53 +0000
Message-ID: <178849721360.4131868.16488957686392708957@kernel.org>
In-Reply-To: <20260901014442.2945689-11-longli@microsoft.com>
References: <20260901014442.2945689-11-longli@microsoft.com>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 0 · Low: 3

- [Low] Three comments (and the commit message) state a shrink
  precondition that this patch itself violates, and one pre-existing…
- [Low] mana_free_qset() gains a leading `struct mana_port_context *apc`
  parameter (exported prototype in include/net/mana/mana.h plus eight…
- [Low] Concern (assessed as a false positive): the commit lacks a Fixes:
  trailer for the commit that made the grow-only EQ pool reachable.

--

net: mana: release EQs left idle by a channel-count reduction

The shared EQ pool previously only grew, so a port kept the high-water mark
of every channel count it had ever used. This adds mana_shrink_eqs() to
release the EQs above the live queue count once a retiring set is gone, and
fixes mana_create_eq_debugfs() to record the dentry in apc->eqs[i] so a
single EQ's debugfs directory can be removed.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 69e34fab8fe8e..2295769da0306 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c

[ ... ]

> @@ -2084,6 +2085,37 @@ static int mana_grow_eqs(struct mana_port_context *apc, unsigned int need)
>  	return err;
>  }
>  
> +/* Release EQs above @keep, returning the MSI-X vectors freed. Only safe once
> + * no set references them, i.e. after mana_free_qset(), or a live CQ would
> + * point at a destroyed EQ.
> + */

[Severity: Low]

This comment says a shrink is only safe after mana_free_qset(), and the
commit message says the same:

  "Release the EQs above the live queue count once a retiring set has been
  torn down. That is the only safe point"

The same patch also calls mana_shrink_eqs() from mana_alloc_qset()'s
out_err path, which is not after mana_free_qset().  Can the two be
reconciled?

The rule that appears to hold at both sites is "no CQ of any set
references eqs[keep..num_eqs-1]": mana_alloc_qset()'s out_err is reached
either before any queue was built, or after mana_destroy_rxqs(scratch) and
mana_destroy_txq(scratch) destroyed the CQs that attempt created.  Would
stating that condition instead be more accurate, here and in
mana_free_qset()'s "Safe here and only here" comment below?

Separately, the error exit of mana_grow_eqs() just above this new helper
still reads:

	out:
		/* Keep whatever was created: the running queue set still needs its
		 * own EQs, and the extras are reused by the next attempt.
		 */
		return err;

Since its only caller, mana_alloc_qset(), now runs
mana_shrink_eqs(apc, apc->num_queues) on that same error return, is
anything still kept for the next attempt?

> +static void mana_shrink_eqs(struct mana_port_context *apc, unsigned int keep)
> +{
> +	struct gdma_context *gc = apc->ac->gdma_dev->gdma_context;
> +	struct gdma_queue *eq;
> +	unsigned int msi;
> +	unsigned int i;
> +
> +	if (!apc->eqs || keep >= apc->num_eqs)
> +		return;
> +
> +	for (i = keep; i < apc->num_eqs; i++) {
> +		eq = apc->eqs[i].eq;
> +		if (!eq)
> +			continue;
> +
> +		debugfs_remove_recursive(apc->eqs[i].mana_eq_debugfs);
> +		apc->eqs[i].mana_eq_debugfs = NULL;
> +
> +		msi = eq->eq.msix_index;
> +		mana_gd_destroy_queue(gc, eq);
> +		mana_gd_put_gic(gc, !gc->msi_sharing, msi);
> +		apc->eqs[i].eq = NULL;
> +	}
> +
> +	apc->num_eqs = keep;
> +}
> +
>  static int mana_fence_rq(struct mana_port_context *apc, struct mana_rxq *rxq)
>  {
>  	struct mana_fence_rq_resp resp = {};

> @@ -4319,6 +4351,13 @@ int mana_alloc_qset(struct mana_port_context *apc,
>  	kfree(scratch->rxqs);
>  	scratch->rxqs = NULL;
>  out_err:
> +	/* Give back any EQ this attempt added to the shared pool rather than
> +	 * holding its MSI-X vectors until some later teardown: the live set
> +	 * still needs only apc->num_queues of them. Safe here because this
> +	 * set's CQs have already been destroyed above.
> +	 */
> +	mana_shrink_eqs(apc, apc->num_queues);
> +
>  	netdev_err(ndev, "%s(num_queues=%u) failed: %d\n", __func__,
>  		   num_queues, err);
>  	return err;

> @@ -4649,7 +4688,8 @@ static void mana_qset_debugfs_publish(struct mana_port_context *apc)
>  /* Tear down @qset, no longer installed on @apc, against @scratch so the live
>   * context never points at queues being freed.
>   */
> -void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
> +void mana_free_qset(struct mana_port_context *apc,
> +		    struct mana_port_context *scratch, struct mana_qset *qset)
>  {
>  	struct bpf_prog *retiring_prog;
>  	unsigned int retiring_queues;

[Severity: Low]

Does the new apc parameter carry anything the function cannot already
derive?  mana_qset_scratch_alloc() does *scratch = *apc, so
netdev_priv(scratch->ndev) == apc for every one of the eight call sites,
which is exactly what this patch relies on when it replaces
mana_qset_debugfs_publish(netdev_priv(scratch->ndev)) with
mana_qset_debugfs_publish(apc).

The TX-drain-failure block inside the same function still has:

	if (mana_drain_txqs(scratch)) {
		...
		struct mana_port_context *apc = netdev_priv(scratch->ndev);

so that local now shadows the new parameter, which -Wshadow / W=2 builds
will flag.

Nothing verifies that a caller passes a matching (apc, scratch) pair, and a
mismatched pair would let the mana_shrink_eqs() call below destroy another
port's EQs.  Would dropping either the parameter or the inner declaration
be preferable?

The exported prototype in include/net/mana/mana.h changes with it - is that
signature change worth a line in the commit message?

> @@ -4745,12 +4785,19 @@ void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
>  
>  	memset(qset, 0, sizeof(*qset));
>  
> +	/* This set is gone, so any EQ above the live queue count is now
> +	 * unreferenced. Release those vectors instead of holding them at the
> +	 * high-water mark. Safe here and only here: the retiring set's CQs
> +	 * have just been destroyed.
> +	 */
> +	mana_shrink_eqs(apc, apc->num_queues);
> +
>  	/* Queues built through a scratch context carry no debugfs nodes,
>  	 * because both sets are alive during the swap and would collide on
>  	 * the same names. The retiring set's nodes are gone now, so the
>  	 * published queues can finally take those names.
>  	 */
> -	mana_qset_debugfs_publish(netdev_priv(scratch->ndev));
> +	mana_qset_debugfs_publish(apc);
>  }
>  
>  /* --- end of pre-allocate + swap reconfiguration path ---------------------- */
> diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
> index 9a43856760776..140948b2b45d5 100644
> --- a/include/net/mana/mana.h
> +++ b/include/net/mana/mana.h
> @@ -797,7 +797,8 @@ int mana_alloc_qset(struct mana_port_context *apc,
>  int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
>  		      struct mana_qset *out_old);
>  void mana_publish_close_if_needed(struct mana_port_context *apc);
> -void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset);
> +void mana_free_qset(struct mana_port_context *apc,
> +		    struct mana_port_context *scratch, struct mana_qset *qset);

Both observations above are documentation and readability points; I did not
find a path where either shrink call site touches an EQ that a live CQ
still references.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260901014442.2945689-1-longli%40microsoft.com
