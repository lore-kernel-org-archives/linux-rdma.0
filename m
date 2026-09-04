Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF3F3EF640;
	Fri,  4 Sep 2026 04:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788497208; cv=none; b=ikI1RfixhOAxF86JtXVW8zbbEP4721r68W5y/9F5jj0+fmAEwnQKoCbK+xxQfx8WhD8afPWOsEy/+acEZrZk2hKdYU4nqzcAq8+1Yku0UgCx+skD9I9mQPrlYrFwZ0jmcC3OgZRQxcJ0KPY4kNA0g16TjKj0Ch+ZR8s8eIGEjNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788497208; c=relaxed/simple;
	bh=PeJ9MQQ3/XiQZCe79kWYqmV4AjWMDibAzkfdeO/kszg=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ivlSxZv12E6UE0waPXyk/NS7u3rXVENCGpet34CQquBpfhRaJ1pzL0KXN+T4+JFX6embu1fmz7ilHekoGr8hxPfbwHC7RcR42oESWmRPuJ2erAPUwM7o5Ags+T8mFhU5G4FyRgKl+ZtCQRp48qI85jAfcZAOtXqVcZiz5jKMNfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jRA6WOru; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jRA6WOru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3162C1F00A3F;
	Fri,  4 Sep 2026 04:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788497206;
	bh=EVD33EPJ0lba6sumOJMm5i8lfYFjtvqAe3OIbYDG2Ow=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=jRA6WOrui5b0d8V9DREzOFr7yMsRsB/Cq1aXnS1V74+jDHMpUPVARZoXFJSOspAPq
	 Mnp2DKnTsGwKLJqarIGqHLbiGe/gwnVldUEpqJD8VCRp98GRLAoizK0l9j4wjRuOFK
	 lyTb/Zmpa+OS3NNA1WyYlxaF7fBj6eRlC86EfRPL1zKoo3cflek/6ilYv+GlxWfU0w
	 poHtGbX6l2UU99ZHfEvSibwgh12yZG2ma7JCIwzDkO5q/rESi8onnBkFCSxgruBnoo
	 3JAMS/qbR6+XX3ZITZo7apVUkSXC6HipwUYSGemPksjczfaUBlVai82d0HQ5ToYHSf
	 avpWM0qTNdWBA==
Subject: Re: [PATCH net-next v3 05/13] net: mana: swap queue sets in
 mana_set_priv_flags
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
Date: Fri, 04 Sep 2026 04:46:44 +0000
Message-ID: <178849720471.4131868.3760536310056862823@kernel.org>
In-Reply-To: <20260901014442.2945689-6-longli@microsoft.com>
References: <20260901014442.2945689-6-longli@microsoft.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 1 · Low: 1 (1)

- [Medium] Commit message describes a change the patch does not make:
  "Scheduling queue_reset_work() on failure goes with it, leaving the TX…
- [Low] Understated failure impact in the commit message: "a failure
  returns the error with both the queues and the flag word untouched"…

Pre-existing issues:
- [Low] Claimed comment-vs-code mismatch: the kernel-doc comment on
  struct mana_port_context::channel_changing states it is "Set by…

--

net: mana: swap queue sets in mana_set_priv_flags

This converts the MANA_PRIV_FLAG_USE_FULL_PAGE_RXBUF toggle from an
in-place detach/attach cycle into a pre-allocate-then-swap using
mana_qset_scratch_alloc(), mana_alloc_qset(), mana_publish_qset() and
mana_free_qset().  The flag value is passed into the new queue set instead
of being written to apc->priv_flags before the rebuild, and the existing
shortcuts (down port, jumbo MTU, attached XDP program) are folded into one
condition.

No Link: tags are present in the commit header.

A couple of questions about the commit message and one note on an existing
comment follow.

The commit message says:

    Scheduling queue_reset_work() on failure goes with it, leaving the TX
    timeout handler as its only user.

[Severity: Medium]
Is this description accurate for this tree?

The pre-patch mana_set_priv_flags() in mana_ethtool.c does not schedule
queue_reset_work() at all - the removed code only calls
mana_pre_alloc_rxbufs(), mana_detach(), mana_attach() and
mana_pre_dealloc_rxbufs().  A grep for queue_reset_work at the parent
revision matches only mana_en.c and mana.h, never mana_ethtool.c, so there
appears to be nothing of that kind to remove here.

After the patch, queue_reset_work() still has three queue_work() sites in
mana_en.c:

  mana_tx_timeout()
        queue_work(ac->per_port_queue_reset_wq, &apc->queue_reset_work);

  mana_dealloc_queues()
        netdev_err(ac->ports[i],
                   "queues reset by a sibling port, scheduling rebuild\n");
        queue_work(ac->per_port_queue_reset_wq,
                   &sib->queue_reset_work);

  mana_free_qset()
        netdev_err(scratch->ndev,
                   "device reset while retiring a queue set, scheduling port reset\n");
        queue_work(ac->per_port_queue_reset_wq,
                   &sib->queue_reset_work);

The last one is reached from the new success and publish-failure paths added
by this patch, so is the TX timeout handler really the only user now?
Could this paragraph be dropped or reworded?

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
> index 24353dfddde3c..eab7df3fb888b 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c

[ ... ]

> @@ -882,54 +886,53 @@ static int mana_set_priv_flags(struct net_device *ndev, u32 priv_flags)

[ ... ]

> -		/* Block RDMA from grabbing the vport during detach/attach */
> -		mutex_lock(&apc->vport_mutex);
> -		apc->channel_changing = true;
> +	/* Block RDMA from acquiring the vport for the duration. */
> +	mutex_lock(&apc->vport_mutex);
> +	if (apc->channel_changing) {
>  		mutex_unlock(&apc->vport_mutex);
> +		return -EBUSY;
> +	}
> +	apc->channel_changing = true;
> +	mutex_unlock(&apc->vport_mutex);

[Severity: Low]
This isn't a bug introduced by this patch, but the kernel-doc comment on
channel_changing in struct mana_port_context (include/net/mana/mana.h) is
getting further out of date:

        /* Set by mana_set_channels() under vport_mutex to block RDMA
         * from grabbing the vport during the detach/attach window.
         * Checked by mana_cfg_vport() when called from the RDMA path.
         */
        bool channel_changing;

It already named only mana_set_channels() at the baseline while
mana_set_priv_flags() and mana_per_port_queue_reset_work_handler() also set
the flag, and the region guarded here is now a pre-allocate/swap rather than
a detach/attach window.  Would it make sense to refresh that comment along
with this conversion?

> -		err = mana_pre_alloc_rxbufs(apc, ndev->mtu, apc->num_queues);
> -		if (err) {
> -			netdev_err(ndev,
> -				   "Insufficient memory for new allocations\n");
> -			apc->priv_flags = old_priv_flags;
> -			goto clear_flag;
> -		}
> +	scratch = mana_qset_scratch_alloc(apc);
> +	if (!scratch) {
> +		err = -ENOMEM;
> +		goto clear_flag;
> +	}
>  
> -		err = mana_detach(ndev, false);
> -		if (err) {
> -			netdev_err(ndev, "mana_detach failed: %d\n", err);
> -			apc->priv_flags = old_priv_flags;
> -			goto out;
> -		}
> +	err = mana_alloc_qset(apc, scratch, apc->num_queues, apc->rx_queue_size,
> +			      apc->tx_queue_size, priv_flags, &newq);
> +	if (err)
> +		goto free_scratch; /* current qset and priv_flags untouched */
>  
> -		err = mana_attach(ndev);
> -		if (err) {
> -			netdev_err(ndev, "mana_attach failed: %d\n", err);
> -			apc->priv_flags = old_priv_flags;
> -		}
> +	err = mana_publish_qset(apc, &newq, &oldq);
> +	if (err) {
> +		mana_free_qset(scratch, &newq);
> +		goto free_scratch;
>  	}
>  
> -out:
> -	mana_pre_dealloc_rxbufs(apc);
> +	mana_free_qset(scratch, &oldq);
> +
> +free_scratch:
> +	mana_publish_close_if_needed(apc);
> +	mana_qset_scratch_free(scratch);

[Severity: Low]
The commit message states:

    a failure returns the error with both the queues and the flag word
    untouched

Does that hold for a failure inside mana_publish_qset()?

mana_publish_qset() can fail on mana_config_rss(), which is an HWC command
and can fail on an unhealthy device.  Its rollback re-runs
mana_config_rss(), and if that fails too it calls mana_publish_give_up():

        apc->carrier_forced_off = netif_carrier_ok(apc->ndev);
        netif_carrier_off(apc->ndev);
        apc->publish_dead_end = true;

mana_set_priv_flags() then reaches free_scratch and calls
mana_publish_close_if_needed(apc) unconditionally, which does:

        if (mana_dealloc_queues(apc->ndev))
                netdev_err(apc->ndev,
                           "failed to close the port after a failed rollback\n");

So ethtool --set-priv-flags can return an error while the port is left
closed with the carrier down until a manual down/up.  The flag word does
look preserved (mana_qset_install() restores qset->priv_flags), so only the
queues half of the claim seems affected.  Could the guarantee in the commit
message be qualified for the dead-end rollback case?

> clear_flag:
>  	mutex_lock(&apc->vport_mutex);
>  	apc->channel_changing = false;
>  	mutex_unlock(&apc->vport_mutex);
> -
>  	return err;
>  }

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260901014442.2945689-1-longli%40microsoft.com
