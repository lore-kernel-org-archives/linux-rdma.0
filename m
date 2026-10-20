Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792503391;
	b=HJRgn1cbPZYf0VRYm2xyzn1kCFzGw173EP6pZkKQkpLlBv0bj65Q1QX3H1hoMCbGX1Eq
	 J2B7rO+bia+oQwXktjrzjvDMsu9AzZgf6CukrqlLv8FxkpMD03k1QrdneuN0KOaUKVW9t
	 7etIqku1oDvxPfy2Luue+0Y2bTcW3NKJjUqYT98R3AbxSRIImB+AlIOLsmt69QNq2Plc3
	 jkR/TnEdP+fIhfm+/c56yHttH16/ZhX72IPSnXbwN7HSADJnyJataECUBAAwFX0nX2oZ/
	 TQ3nGU6WBigYKE0hvSrzHZPG/TXeeGsNHP+fihkq3/nxDMqnNO24dTbilTCS2P3HBxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792503391;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=7jqSFBI+hkejNeRR/cQHY482qWcy5UbBBf92Mi07d98=;
	b=3IBVitXUqCda/C8L4BiFu2xZzO0s4yz7Nr8I2I2DumOLATXMTLnjOnGLSabyLmLZMGlO
	 Y86KuwkwUaPygh0wuaIzx/CxYwe71Qzlu2ITPeUtkXGAeP9DSa7AlrznnJLfLnXsv+r6c
	 Qx/HIsmGw0sxEzCf/hlhLI8ixFwxv2D0DGqaaa6/USl0ibv5v3o9hDcAAOfMxIooc2pX1
	 NIdCksflmKrjU5iCBbXn7tEltzb/EPPEdmIzcycatsmDzHiQM0Tn3PTxr0DfmN+r6r+DJ
	 zGK8C6tykOEelMSReCwkNs5D3oivSiYoCzBU/0RVjOEArQhue43HI8kwIh32/BiIjsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Xg9/+FlP";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D95660A262D;
	Tue, 20 Oct 2026 13:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xg9/+FlP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E5E1F000CD;
	Tue, 20 Oct 2026 13:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792503390;
	bh=7jqSFBI+hkejNeRR/cQHY482qWcy5UbBBf92Mi07d98=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Xg9/+FlPDSbIpNqcZT9UKF94nAjIczCTzECRcl9Zzaaq1pbdST0KBBKSEYwD+nfA8
	 mVHYrmuStcZ9x202Tu9teSQWDMUqMg7TrLdwSQhvsM6A1HH0/PSagQh6U2DzSvYg3q
	 BT4drjNQAGgXuOkPkyBy677fU8e0WWz9MRTXPWSaxdakalV23aphKgw0vpbr4NA1YJ
	 cXFosDc+hTEqmxm1Kp3018wGXAZQWpd1+IY0MQaKaXNAywSipJNH6/3A3IrGCBIddv
	 8Y8wsBlG64nv7UzD4/7xZvr+Je/J0uKRkAbevgxR9ovKu8bq0vycls6tV5G0di+6gT
	 uYyMCTlVNJzLQ==
Subject: Re: [PATCH net-next v8 1/4] net: mana: prepare HWC ownership for safe
 reinitialization
From: netdev-bot+sashiko@kernel.org
To: weh@linux.microsoft.com
Cc: longli@kernel.org, kotaranov@microsoft.com, kuba@kernel.org,
 davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 andrew+netdev@lunn.ch, jgg@ziepe.ca, leon@kernel.org, haiyangz@microsoft.com,
 wei.liu@kernel.org, decui@microsoft.com, shradhagupta@linux.microsoft.com,
 horms@kernel.org, ernis@linux.microsoft.com, stephen@networkplumber.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 gargaditya@linux.microsoft.com, kees+treewide@kernel.org, kees@kernel.org,
 mawasthi@linux.microsoft.com, weh@microsoft.com, edumazet@kernel.org
Date: Tue, 20 Oct 2026 13:36:28 +0000
Message-ID: <179250338816.3135.13276488357316939732@kernel.org>
In-Reply-To: =?utf-8?q?=3C64987f49ea13b5ccdc9ef95f4a9baf23a479edc3=2E1791998?=
 =?utf-8?q?462=2Egit=2Eweh=40linux=2Emicrosoft=2Ecom=3E?=
References: =?utf-8?q?=3C64987f49ea13b5ccdc9ef95f4a9baf23a479edc3=2E17919984?=
 =?utf-8?q?62=2Egit=2Eweh=40linux=2Emicrosoft=2Ecom=3E?=
X-sashiko-severity: Low
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

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit message presents this patch only as preparation for
  dynamic HWC queue sizing.

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but the patch
  documents mana_gd_process_eqe() as an RCU-protected lockless reader of…

--

net: mana: prepare HWC ownership for safe reinitialization

This commit serializes the shared-memory ESTABLISH_HWC and DESTROY_HWC
transactions. When DESTROY_HWC is not acknowledged, it keeps the
PF-visible HWC resources, and it adds a final-disposal helper for when
the gdma_context is discarded. It also snapshots the bootstrap CQ count
and ID, publishes cq_table with release/acquire ordering, and waits for
RCU readers before freeing the HWC queues.

Link: https://lore.kernel.org/r/20260908035201.402424-2-longli@microsoft.com
Link: https://lore.kernel.org/r/20260908035201.402424-5-longli@microsoft.com
Link: https://lore.kernel.org/r/178910960115.219967.13830871915506436112@kernel.org
Link: https://lore.kernel.org/r/179196575238.434549.10775387794024020898@kernel.org
Link: https://lore.kernel.org/r/sashiko-outbox-170992@kernel.org

> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> index ae0ed700b3b93..d11068f1dc05f 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c

[ ... ]

> @@ -765,11 +767,16 @@ static void mana_gd_process_eqe(struct gdma_queue *eq)
>  	switch (type) {
>  	case GDMA_EQE_COMPLETION:
>  		cq_id = eqe->details[0] & 0xFFFFFF;
> -		if (WARN_ON_ONCE(cq_id >= gc->max_num_cqs))
> +		/* The IRQ handler's RCU read-side section protects the table
> +		 * until HWC teardown has fenced its EQ and waited for readers.
> +		 */
> +		cq_table = smp_load_acquire(&gc->cq_table);
> +		if (!cq_table || cq_id >= READ_ONCE(gc->max_num_cqs))
>  			break;
>  
> -		cq = gc->cq_table[cq_id];
> -		if (WARN_ON_ONCE(!cq || cq->type != GDMA_CQ || cq->id != cq_id))
> +		cq = READ_ONCE(cq_table[cq_id]);
> +		if (!cq || WARN_ON_ONCE(cq->type != GDMA_CQ ||
> +					cq->id != cq_id))
>  			break;
>  
>  		if (cq->cq.callback)

[Severity: High]
This is a pre-existing issue and was not introduced by this patch. This
hunk now documents mana_gd_process_eqe() as an RCU-protected lockless
reader of gc->cq_table, though. Do the Ethernet and RDMA writers of the
same slots follow that model?

The reader loads cq from the slot, dereferences cq->type and cq->id,
and then calls cq->cq.callback(cq->cq.context, cq).

In drivers/infiniband/hw/mana/cq.c, mana_ib_remove_cq_cb() frees the
queue before it clears the slot, and it never waits for a grace period:

drivers/infiniband/hw/mana/cq.c:mana_ib_remove_cq_cb() {
    ...
	kfree(gc->cq_table[cq->queue.id]);
	gc->cq_table[cq->queue.id] = NULL;
}

mana_ib_destroy_cq() calls this before mana_ib_gd_destroy_cq(), so the
hardware CQ is still live at that point.

Ethernet CQs have a similar problem. In mana_gd_destroy_queue(),
mana_gd_destroy_cq() does WRITE_ONCE(gc->cq_table[id], NULL), and then
kfree(queue) runs straight away with no synchronize_rcu() in between.

Could an IRQ on another CPU that has already loaded the slot in
mana_gd_process_eqe() then read freed memory and call through a freed
cq->cq.callback?

The publish side looks similar. mana_ib_install_cq_cb() initializes
gdma_cq and then publishes it with a plain store:

	gdma_cq->id = cq->queue.id;
	gc->cq_table[cq->queue.id] = gdma_cq;

The txq and rxq creation paths in mana_en.c do the same:

	gc->cq_table[cq->gdma_id] = cq->gdma_cq;

Neither store has release ordering. Could a reader on a weakly ordered
CPU such as arm64 see a partly initialized CQ?

The commit message says "Individual Ethernet and RDMA CQ lifetime
handling remains separate". drivers/infiniband/hw/mana/cq.c is still
unchanged at the end of the series.

[ ... ]

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index 3bca4b683134b..a1c1c6f32cafa 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c

[ ... ]

> @@ -382,16 +386,49 @@ static void mana_hwc_comp_event(void *ctx, struct gdma_queue *q_self)
>  	mana_gd_ring_cq(q_self, SET_ARM_BIT);
>  }
>  
> -static void mana_hwc_destroy_cq(struct gdma_context *gc, struct hwc_cq *hwc_cq)
> +static int mana_hwc_publish_cq(struct gdma_context *gc,
> +			       struct gdma_queue *cq)
>  {
> -	kfree(hwc_cq->comp_buf);
> +	struct gdma_queue **cq_table = READ_ONCE(gc->cq_table);
> +	u32 id = READ_ONCE(cq->id);
>  
> -	if (hwc_cq->gdma_cq)
> -		mana_gd_destroy_queue(gc, hwc_cq->gdma_cq);

[ ... ]

> +static void mana_hwc_destroy_cq(struct gdma_context *gc, struct hwc_cq *hwc_cq)
> +{
> +	/* Destroy the EQ first: it deregisters the IRQ and drains in-flight
> +	 * handlers, so none can touch the CQ after it is freed.
> +	 */
>  	if (hwc_cq->gdma_eq)
>  		mana_gd_destroy_queue(gc, hwc_cq->gdma_eq);
>  
> +	/* Safe to free now that the EQ handler is fenced. */
> +	if (hwc_cq->gdma_cq)
> +		mana_gd_destroy_queue(gc, hwc_cq->gdma_cq);
> +
> +	kfree(hwc_cq->comp_buf);
>  	kfree(hwc_cq);
>  }

[Severity: Low]
This isn't a bug in the code, but the commit message describes the
patch only as preparation for dynamic HWC queue sizing. Several of the
changes appear to fix problems in the existing driver. There is no
Fixes: tag and no stable Cc, so stable kernels will not pick these
fixes up.

The baseline mana_hwc_destroy_cq() freed comp_buf and destroyed the CQ
before destroying the EQ, and destroying the EQ is what deregisters the
IRQ and runs synchronize_rcu(). The baseline mana_hwc_destroy_channel()
also destroyed txq and rxq before the CQ and EQ. A concurrent
mana_hwc_comp_event() or rx handler could therefore touch freed memory.

The baseline mana_hwc_destroy_channel() ignored the return value of
mana_smc_teardown_hwc(). It freed the HWC DMA memory even when
DESTROY_HWC was not acknowledged.

The baseline mana_hwc_init_event_handler() did:

	case HWC_INIT_DATA_MAX_NUM_CQS:
		gd->gdma_context->max_num_cqs = val;

on any such event. That handler stays installed for the life of the
channel. A later event could raise the bound above the vcalloc() size,
and mana_gd_process_eqe() would then read gc->cq_table out of bounds
in hardirq context.

The baseline also vfree()d gc->cq_table without waiting a grace period
for IRQ-side readers on other EQs.

Would it make sense to send these fixes separately, with Fixes: tags,
so they can be backported?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1791998462.git.weh%40linux.microsoft.com
