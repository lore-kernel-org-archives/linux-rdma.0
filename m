Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4465433BCA;
	Wed, 12 Aug 2026 23:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786578427; cv=none; b=eEukOMC4MwHdrqGSh1ZHJfDmQ+D6p/DTs81dAmrsKhaCZ4rtnaxdA1lavmOMPgOy4uA+sAggK9pY+3d4myQdlRs0DQrx9wNE+EnCFD2TYKaX4UmpwrMGJfPEj+zmEekY2sjIkZjkeG25r/F+HjrBJhPfMisRXvBOPXVCSG4S2Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786578427; c=relaxed/simple;
	bh=IVw89NKRxORX6LLj4htWInXHM5FuiF3tTPkoXli25zY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AU4A9bVG8LloylCYryiqEWres3DLfT3ME79wBx4wyl16UCsAtQlwR63AUTfPQjzcrjMc8PNhkr5mJaS6yvyCx08gZjwVrTiZenuKSwBYoHpqM/0ORfY1eEDpDoe0zZeIQkWS6aIz1U2jUvBleRK0Oqly6knLcIseqhqF9BSrXO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I/e6qqZe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I/e6qqZe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1891F00A3A;
	Wed, 12 Aug 2026 23:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786578422;
	bh=pM4vwc3hfCsATNB4554r0jj8f2EjmXrGravP7Gi+dd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I/e6qqZeZeL4SebB6f02gnRKtQP3ElInWnah6ObINf09cMhJkgq3nNLAnkuoajUyy
	 qPa+iX+OU2gke948momRRrGOMYxLUvtEzd2GPtKOes5GkcghViJTre5WK+JBOfyNmY
	 iZhtvPduvNJL9z9/0lcbYAEs695sojyuXiQJIUyciniS/Oqu6klsfXTRoJwa3hhQrA
	 RKkgH8FkS5arboqEgmMSKfwVIKS2FhHt6HviG7PTJhZHXf6QOCjz2lQrJP8CT4PJk4
	 gy7aUUFYC4Aa/GCP9ERXh/a+3ZD1rIP0qKnDSMMl5l2a0y+v1kqH4Alu8T9hGDY099
	 DMjlGRlm2mfAQ==
From: Jakub Kicinski <kuba@kernel.org>
To: longli@microsoft.com
Cc: Jakub Kicinski <kuba@kernel.org>,
	kotaranov@microsoft.com,
	davem@davemloft.net,
	pabeni@redhat.com,
	edumazet@google.com,
	andrew+netdev@lunn.ch,
	jgg@ziepe.ca,
	leon@kernel.org,
	haiyangz@microsoft.com,
	kys@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	shradhagupta@linux.microsoft.com,
	horms@kernel.org,
	ernis@linux.microsoft.com,
	stephen@networkplumber.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v6 7/7] net: mana: keep max_num_cqs immutable once cq_table is allocated
Date: Wed, 12 Aug 2026 16:47:01 -0700
Message-ID: <20260812234701.2193632-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811023823.2391255-8-longli@microsoft.com>
References: <20260811023823.2391255-8-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
net: mana: keep max_num_cqs immutable once cq_table is allocated

The HWC init event handler no longer writes gc->max_num_cqs directly.  The
device-reported CQ count is staged in hwc->hwc_init_max_num_cqs and
mana_hwc_establish_channel() commits it to gc->max_num_cqs once, from the
same snapshot that sizes and indexes cq_table.

No Link: tags present in the commit header.

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index 759b65040a159..a29955e0473aa 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> @@ -262,7 +262,15 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
>  			break;
>  
>  		case HWC_INIT_DATA_MAX_NUM_CQS:
> -			gd->gdma_context->max_num_cqs = val;
> +			/* Store, don't apply: mana_hwc_establish_channel()
> +			 * commits this to gc->max_num_cqs once, together
> +			 * with sizing cq_table, so a spoofed post-init event
> +			 * cannot inflate the bound past the allocation.
> +			 * WRITE_ONCE() pairs with the READ_ONCE() there:
> +			 * this store runs in EQ interrupt context,
> +			 * concurrently with that process-context read.
> +			 */
> +			WRITE_ONCE(hwc->hwc_init_max_num_cqs, val);
>  			break;
>  
>  		case HWC_INIT_DATA_PDID:

[ ... ]

> @@ -868,6 +876,8 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
>  	struct gdma_queue *eq = hwc->cq->gdma_eq;
>  	struct gdma_queue *cq = hwc->cq->gdma_cq;
>  	struct gdma_queue __rcu **cq_table;
> +	u32 num_cqs;
> +	u32 cq_id;
>  	int err;
>  
>  	init_completion(&hwc->hwc_init_eqe_comp);
> @@ -902,15 +912,29 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
>  	*max_req_msg_size = hwc->hwc_init_max_req_msg_size;
>  	*max_resp_msg_size = hwc->hwc_init_max_resp_msg_size;
>  
> -	/* Both were set in mana_hwc_init_event_handler(). */
> -	if (WARN_ON(cq->id >= gc->max_num_cqs))
> +	/* Snapshot the device-reported CQ count and CQ id into locals and
> +	 * use only the locals below, so the same value that sizes cq_table
> +	 * also bounds and indexes it -- even across the sleeping vcalloc().
> +	 * Both fields are written by mana_hwc_init_event_handler() from EQ
> +	 * interrupt context: hwc_init_max_num_cqs under WRITE_ONCE() (paired
> +	 * here), and cq->id as an ordinary store.  READ_ONCE() keeps each
> +	 * read tear-free and, crucially, non-reloadable, so a spoofed
> +	 * post-init event cannot make the WARN_ON() pass against one value
> +	 * while the allocation or the index uses another.
> +	 */
> +	num_cqs = READ_ONCE(hwc->hwc_init_max_num_cqs);
> +	cq_id = READ_ONCE(cq->id);
> +
> +	if (WARN_ON(cq_id >= num_cqs))
>  		return -EPROTO;

[Severity: Medium]
This isn't a bug introduced by this patch, the equivalent
WARN_ON(cq->id >= gc->max_num_cqs) exists at baseline, but should this
WARN_ON() stay on a condition that is fully device-controlled?

Both operands come from untrusted HWC bootstrap events handled in
mana_hwc_init_event_handler(): cq_id from HWC_INIT_DATA_CQID and num_cqs
from HWC_INIT_DATA_MAX_NUM_CQS.

hwc is kzalloc'd in mana_hwc_create_channel(), so if the host simply never
sends HWC_INIT_DATA_MAX_NUM_CQS then hwc_init_max_num_cqs stays 0 and the
condition is unconditionally true.

On a guest booted with panic_on_warn=1, does that turn a malformed or
missing device response into a kernel panic instead of the intended -EPROTO
rejection?  Would a rate-limited dev_err() plus -EPROTO be preferable here?

>  
> -	cq_table = vcalloc(gc->max_num_cqs, sizeof(*cq_table));
> +	cq_table = vcalloc(num_cqs, sizeof(*cq_table));
>  	if (!cq_table)
>  		return -ENOMEM;

[Severity: Medium]
This isn't a bug introduced by this patch either, baseline already did
vcalloc(gc->max_num_cqs, ...) from the same device-reported value, but is
there a reason not to add an upper sanity bound on num_cqs while the value
is being snapshotted here?

The value field of the init event is 24 bits wide:

include/net/mana/hw_channel.h:
	struct {
		u32 value	: 24;
		u32 type	:  8;
	};

so a host can report up to 16,777,215 entries, which is roughly 128 MiB of
zeroed vmalloc memory held for the channel lifetime on a 64-bit guest.
A large count paired with a small, valid cq_id passes the cq_id >= num_cqs
check above.

vcalloc() uses array_size(), so there is no integer wrap, and an allocation
failure returns -ENOMEM cleanly; the concern is only the memory pressure on
a small confidential guest.

>  
> -	rcu_assign_pointer(cq_table[cq->id], cq);
> +	gc->max_num_cqs = num_cqs;
> +
> +	rcu_assign_pointer(cq_table[cq_id], cq);

[Severity: Medium]
This isn't a bug introduced by this patch, the pieces below all exist at
baseline f1b3416, but does the snapshot invariant documented above hold for
the index as well?

The comment says "the same value that sizes cq_table also bounds and
indexes it", yet only hwc_init_max_num_cqs is staged.  The sibling case in
the same switch still applies a device-supplied CQ id straight to the live
queue object:

		case HWC_INIT_DATA_CQID:
			hwc->cq->gdma_cq->id = val;
			break;

That handler stays registered for the whole channel lifetime, so after
cq_table[cq_id] is published, a later HWC_INIT_DATA_CQID event can make
cq->id differ from the index the CQ was installed at.

Once that happens, does mana_gd_process_eqe() drop every HWC completion for
the published index?

drivers/net/ethernet/microsoft/mana/gdma_main.c:mana_gd_process_eqe() {
	...
	if (WARN_ON_ONCE(cq->type != GDMA_CQ || cq->id != cq_id))
		break;
	...
}

If so, all HWC commands would time out and latch hwc_timed_out, leaving the
control channel disabled after a single spoofed event.

The teardown side recomputes the slot from the live queue->id rather than
from the index used at publish time:

drivers/net/ethernet/microsoft/mana/gdma_main.c:mana_gd_unpublish_cq() {
	u32 id = queue->id;
	...
	if (!cq_table || id >= gc->max_num_cqs)
		return false;
	if (rcu_access_pointer(cq_table[id]) != queue)
		return false;
	...
}

mana_gd_destroy_cq() treats false as "already unpublished" and returns
without synchronize_rcu(), and mana_gd_destroy_queue() then kfree()s the
queue.  Can a mutated cq->id therefore leave a freed pointer in the still
published cq_table?

Teardown ordering appears to keep that stale slot unreachable today:
mana_hwc_destroy_cq() destroys the HWC EQ before the CQ, and every caller of
mana_hwc_destroy_channel() runs mana_rdma_remove()/mana_remove() first, so
no live EQ dispatches into the slot before rcu_replace_pointer(gc->cq_table,
NULL) + synchronize_rcu() + vfree().  So the observable effect looks like
the stalled control channel plus a WARN_ON_ONCE splat, with the freed
pointer surviving only by that ordering.

Would it make sense to stage HWC_INIT_DATA_CQID the same way, or to key
unpublish off the index the CQ was published at?

>  	/* Publish the fully-initialised table last; pairs with the
>  	 * rcu_dereference(gc->cq_table) in mana_gd_process_eqe().
>  	 */
> diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
> index 23bf83e2a3ec6..c275150baf490 100644
> --- a/include/net/mana/hw_channel.h
> +++ b/include/net/mana/hw_channel.h
> @@ -203,6 +203,7 @@ struct hw_channel_context {
>  	u16 hwc_init_q_depth_max;
>  	u32 hwc_init_max_req_msg_size;
>  	u32 hwc_init_max_resp_msg_size;
> +	u32 hwc_init_max_num_cqs;

[Severity: Low]
Unrelated to the new field, but a few lines further down in the same struct
the setup_active comment added by the earlier teardown-safety patch in this
series does not match the code in three places:

include/net/mana/hw_channel.h:
	/* Set after mana_smc_setup_hwc() succeeds (hardware has active
	 * MST entries).  Cleared only after mana_smc_teardown_hwc()
	 * succeeds, on both the recoverable establish_channel path and the
	 * terminal destroy_channel path.  If teardown fails it stays set:
	 * establish_channel() skips its retry and destroy_channel() leaks
	 * the HWC rather than free buffers the device may still DMA into.
	 */
	bool setup_active;

mana_hwc_establish_channel() sets the flag before the setup call, not after
it succeeds, and its own inline comment says that is deliberate:

	hwc->setup_active = true;

	err = mana_smc_setup_hwc(&gc->shm_channel, false, ...);

mana_smc_teardown_hwc() has a single caller in the driver,
mana_hwc_destroy_channel(), which is also the only place setup_active is
cleared; establish_channel() explicitly does not tear down ("Do not also
tear down here").

There is no retry in establish_channel(); the teardown retry lives in
mana_hwc_create_channel():

	if (gd->driver_data) {
		mana_hwc_destroy_channel(gc);
		if (gd->driver_data)
			return -ETIMEDOUT;
	}

Could the comment be updated to describe the actual set point, the single
clear site, and where the retry lives?
