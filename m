Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793523500;
	b=U3fFkqnZJSkXN1H3yk+qLhORdc6A1iwiP6l2rdgSrB7TlWepx44FF0AXyWcddODTRBRx
	 /vK5zdmezHQpwWdZPj2grmjI2cTUaeMIKytjyadxcXZIBr/T3rFyU57kuxn0ewRlgfEwk
	 Bp6IQe7rMGWBcjSgB8O8/zxnR4zKd64HW7J4Wew8I4MdmOL/Y4JahpJaH7drl+P31tdbw
	 OOf7TIivEC+XvxM9rx4EMOYGLRFtitlF/7rO7Nfc8KIShfeQ7h1blpmVcD5jzW5L9hQuM
	 d8dm+KcL59fSiR2rDDOt3u/FfmFhQ/USCodPvb5RGhyfR5dCxrk6c7KJLPrtuK2mJ5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793523500;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=JzfMxPDvE/DIfgZOvqLJqehfO8uVrWrYGcmJs14Haks=;
	b=1iVchcHc59QjK7KP4WMPbV7ZP3B9vXWShDIFgCe9IdkNWqHgn8NoE1txHNx4U6LKFgb9
	 W5BuGGoFLj1p5AENI0uecrglRvMECVfK4I80J5vvLsD/YtsiCqVLuxd/G/h71BVUzwo6f
	 ZiD6U5ceo0YCLYVENfoR0OZKQkKvIkTSqReveqNAxtJ6LXOm5/aHImzzdUe3swktjGnHi
	 hZkPCYGiSmT4N2nfNbHifclYhoxGaDk4vbGlBN16cHLTFAWU9UnE0c+bLuKeuC3jyy1N2
	 fprCYrlQ/XiDnMvbF2bqKkqZRHQA8f4jwMnb7abTa9yz6pGtAvqK8e1uYNht3euwIJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aKMPRrqU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF49E606A326;
	Sun,  1 Nov 2026 08:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aKMPRrqU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8310D1F00919;
	Sun,  1 Nov 2026 08:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793523499;
	bh=JzfMxPDvE/DIfgZOvqLJqehfO8uVrWrYGcmJs14Haks=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=aKMPRrqUmhJt1IWZyFOV4k1FzZ8WraSrl/hCNeazZ6gTYhkCbp1COjUZ/GhlID1dl
	 U5e+jt5CTrvo0yJmj+6QZkhQcUVVLYhRk6y7g6VCkp/zwEtnMqrJXDcD7tT/ta9LM8
	 r6wQ1D+w6/8uuReoTfUm2lAJVcFCUn7hmcCNkWaiTM0rV7vJZ1b3ICFIPd8Erx8zOg
	 5wBR76d6OhjWdZReAOywjUGljHNDmShji+/KsKwOdD0ri8eT7Cxq0/cgL1Nr6jOoRO
	 CZId+FzNcJ/N/rIJpk/hDu7hn75gxWjdyC+JMGc+wya4EDIXQwvhssnB1LiTOh2ZsE
	 9bh78NKslQ6AA==
Subject: Re: [PATCH net v4] net: mana: Add support to process throttled EQEs
From: netdev-bot+sashiko@kernel.org
To: sahilchandna@linux.microsoft.com
Cc: haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, kotaranov@microsoft.com, horms@kernel.org,
 ernis@linux.microsoft.com, gargaditya@linux.microsoft.com,
 mawasthi@linux.microsoft.com, leitao@debian.org, linux-hyperv@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, stable@vger.kernel.org
Date: Sun, 01 Nov 2026 08:58:18 +0000
Message-ID: <179352349805.3131.9139142774275348324@kernel.org>
In-Reply-To: <20261028084020.2051254-1-sahilchandna@linux.microsoft.com>
References: <20261028084020.2051254-1-sahilchandna@linux.microsoft.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 (1) · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The patch tells firmware that every EQ on the function handles
  throttled EQEs.
- [Low] The patch marks only one side of the concurrent accesses.

Pre-existing issues:
- [High] mana_gd_destroy_cq() waits for a grace period
  (synchronize_net()) only when mana_gd_detach_cq() returns true,…

--

net: mana: Add support to process throttled EQEs

This commit handles GDMA_EQE_THROTTLE events. It records up to two child
CQs per EQ and calls their callbacks when a throttle EQE arrives. CQ
teardown now detaches the CQ from its parent EQ and from cq_table[]
before a grace period. The patch also advertises a new capability bit and
adds a per-EQ throttle counter to ethtool stats.

> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> index 8c915e0087846..ab942d5bfe058 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> @@ -757,6 +757,27 @@ void mana_gd_free_service_wq(struct gdma_context *gc)
>  	gc->service_wq = NULL;
>  }
>  
> +static void mana_gd_schedule_eq_cqs(struct gdma_queue *eq)
> +{
> +	struct gdma_context *gc = eq->gdma_dev->gdma_context;
> +	struct gdma_queue *cq;
> +	u8 i;
> +
> +	for (i = 0; i < GDMA_EQ_MAX_CHILD_CQ; i++) {
> +		cq = rcu_dereference(eq->eq.child_cq[i]);
> +
> +		if (!cq)
> +			continue;
> +
> +		if (cq->id >= READ_ONCE(gc->max_num_cqs) ||
> +		    !gc->cq_table || gc->cq_table[cq->id] != cq)
> +			continue;

[Severity: Low]
This patch marks only the write side. mana_gd_detach_cq() clears
gc->cq_table[id] with WRITE_ONCE(), and mana_hwc_destroy_channel() now
sets gc->max_num_cqs with WRITE_ONCE().

The readers still use plain loads. Here that means gc->cq_table and
gc->cq_table[cq->id]. The GDMA_EQE_COMPLETION branch of
mana_gd_process_eqe() also reads both fields without READ_ONCE():

	if (WARN_ON_ONCE(cq_id >= gc->max_num_cqs))
		break;

	cq = gc->cq_table[cq_id];

Could KCSAN report these as data races? Should the readers use
READ_ONCE() to pair with the marked writers?

This is mostly an annotation issue. The completion-path race was already
there before this patch, and the loads in mana_gd_schedule_eq_cqs() only
compare the pointer value.

> +
> +		if (cq->cq.callback)
> +			cq->cq.callback(cq->cq.context, cq);
> +	}
> +}

[ ... ]

> @@ -1073,25 +1104,66 @@ static void mana_gd_create_cq(const struct gdma_queue_spec *spec,
>  			      struct gdma_queue *queue)
>  {
>  	u32 log2_num_entries = ilog2(spec->queue_size / GDMA_CQE_SIZE);
> +	struct gdma_queue *parent;
> +	u8 i;
>  
>  	queue->head |= INITIALIZED_OWNER_BIT(log2_num_entries);
> -	queue->cq.parent = spec->cq.parent_eq;
> +	parent = spec->cq.parent_eq;
> +	queue->cq.parent = parent;
>  	queue->cq.context = spec->cq.context;
>  	queue->cq.callback = spec->cq.callback;
> +
> +	if (!parent)
> +		return;
> +
> +	/* For throttled EQE store the child CQ */
> +	for (i = 0; i < GDMA_EQ_MAX_CHILD_CQ; i++) {
> +		if (!rcu_access_pointer(parent->eq.child_cq[i])) {
> +			rcu_assign_pointer(parent->eq.child_cq[i], queue);
> +			return;
> +		}
> +	}
> +
> +	WARN_ONCE(1, "mana: EQ %u has no free child CQ slot\n", parent->id);
>  }

[Severity: High]
Do mana_ib CQs ever end up in child_cq[]?

This is the only place that writes child_cq[], and it returns early when
spec->cq.parent_eq is NULL. mana_ib_create_kernel_queue() uses a zeroed
spec:

drivers/infiniband/hw/mana/main.c:mana_ib_create_kernel_queue() {
	struct gdma_queue_spec spec = {};
	...
	err = mana_gd_create_mana_wq_cq(mdev->gdma_dev, &spec, &queue->kmem);
	...
}

mana_ib_gd_create_cq() then binds the RNIC CQ in hardware to an mana_ib
EQ:

	req.eq_id = mdev->eqs[cq->comp_vector]->id;

mana_ib_install_cq_cb() adds it only to gc->cq_table[].

mana_ib_create_qp_rss() and mana_ib_create_qp_raw() attach raw and RSS
QP CQs to the per-vPort mana_en EQs:

	eq = &mpc->eqs[cq->comp_vector % mpc->num_queues];
	cq_spec.attached_eq = eq->eq->id;

These CQs are also registered only through mana_ib_install_cq_cb().

The patch also adds GDMA_DRV_CAP_FLAG_1_THROTTLED_EVENT_QUEUE to
GDMA_DRV_CAP_FLAGS1, which mana_gd_verify_vf_version() sends for the
whole function.

Suppose hardware folds one of these CQs' completions into a
GDMA_EQE_THROTTLE. mana_gd_schedule_eq_cqs() walks child_cq[], which is
empty on mdev->eqs and holds only the mana_en TX and RX CQs on mpc->eqs.
mana_ib_cq_handler() never runs, and nothing polls or re-arms the CQ.

Wouldn't that stall the RDMA CQ the same way the commit message
describes for TX?

A fixed two-entry child_cq[] also cannot represent an EQ shared by many
RDMA CQs on the same comp_vector.

The commit message says:

  "A mana_en EQ serves one TX CQ and one RX CQ, and the HWC EQ serves
  the HWC CQ."

Is that still true once raw QPs attach CQs to mpc->eqs?

If advertising the bit is what turns on throttle EQEs, this patch adds a
new RDMA stall. If it is not, the RDMA case stays unfixed. Could the
commit message cover mana_ib in either case?

> -static void mana_gd_destroy_cq(struct gdma_context *gc,
> -			       struct gdma_queue *queue)
> +/* Unlink queue from its parent EQ's child_cq[] and from gc->cq_table[].
> + *
> + * Return: true if queue was in the parent EQ's child_cq[]. In that case the
> + * caller must wait for an RCU grace period before freeing queue, because
> + * mana_gd_intr() may still be handling a throttle EQE for it.
> + */
> +bool mana_gd_detach_cq(struct gdma_context *gc, struct gdma_queue *queue)
>  {

[ ... ]

> +	/* Check if CQ might have been detached already, only clear if
> +	 * it still points to same queue .
> +	 */
> +	if (id < gc->max_num_cqs && READ_ONCE(gc->cq_table[id]) == queue)
> +		WRITE_ONCE(gc->cq_table[id], NULL);
>  
> -	if (!gc->cq_table[id])
> -		return;
> +	return attached;
> +}
>  
> -	gc->cq_table[id] = NULL;
> +static void mana_gd_destroy_cq(struct gdma_context *gc,
> +			       struct gdma_queue *queue)
> +{
> +	/* Wait for irq reader holding the cq */
> +	if (mana_gd_detach_cq(gc, queue))
> +		synchronize_net();
>  }

[Severity: High]
This isn't a bug introduced by this patch, but mana_gd_detach_cq() also
clears gc->cq_table[id]. The GDMA_EQE_COMPLETION branch of
mana_gd_process_eqe() reads that table and calls the callback under the
rcu_read_lock() in mana_gd_intr():

	cq = gc->cq_table[cq_id];
	...
	if (cq->cq.callback)
		cq->cq.callback(cq->cq.context, cq);

mana_gd_destroy_cq() only waits when the CQ was in child_cq[]. An
mana_ib kernel (kmem) CQ has parent_eq NULL, so detach returns false and
no grace period runs:

mana_ib_destroy_cq()
  mana_ib_remove_cq_cb()       <- returns early for kmem
  mana_ib_gd_destroy_cq()
  mana_ib_destroy_queue()
    mana_gd_destroy_queue(kmem)
      mana_gd_destroy_cq()     <- clears cq_table[id], no wait

Suppose an IRQ on another CPU has already loaded the pointer from
cq_table[]. Can it then call mana_ib_cq_handler() on a freed gdma_queue
and mana_ib_cq?

The old mana_gd_destroy_cq() also cleared the slot without a grace
period, and drivers/infiniband/hw/mana has no synchronize_rcu() or
call_rcu(). However, the new kernel-doc and the "Wait for irq reader
holding the cq" comment now describe a rule that leaves out the
cq_table[] reader.

User CQs look similar. mana_ib_remove_cq_cb() frees the entry before it
clears the slot:

	kfree(gc->cq_table[cq->queue.id]);
	gc->cq_table[cq->queue.id] = NULL;

Should the grace period depend on removal from cq_table[] instead of
child_cq[] membership?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261028084020.2051254-1-sahilchandna%40linux.microsoft.com
