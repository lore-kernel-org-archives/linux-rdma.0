Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794552404;
	b=YHKMuBKK7RJWOHrWsLbe/8NNhPX/E52BhUXj5DyLMCDafV1so5PBAF2uJK4VGgGxjndl
	 zmHVQKuNTksnyD+JQJ74Jy7uGyYJzXb+88ae88Vebv9m/0HLsQgrWRRh8pnjzkBq/WYp0
	 gBcxm4fxiCrpRfsC5y1F2XR56u+allGpKdgVi+J6cLeXmJiTUPfMomve2osVEj8n3Bzra
	 0kF3J7I49OouS14ORNcAJBi14mhx1BQ1g853yFoevamcFohpf4Z7v6E5nBaPPTckoX1mM
	 +d2RBV6zy5tlbFHf4wXeFs4Q6HWnU+byeAMPjBBrnXnmg/uTaR5ZK0qYrvGY2CAAC3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794552404;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=yAgAt0XLovdcBjoYisxQBS4FvH+YQnymMRd0TOGYu4k=;
	b=xB6ILeHrsErfO8QCFnEtLbGJkIPN+bokO7fW46iEHo2TVSiARxauACsWvqRwo21i/AnX
	 /eSkdnns+RK0kSk1dlOcvH3J2xllgyB81kgZmTYt72v898piVAKzkaTHT4jO08ytJ6x42
	 L+2Wsa8eZHSvnY0TBamBcSlTWExsB4kekriM7IaL+9/9QidTGMsd6p9ux5HIejRx0OET/
	 sgrQ92OGw5vN9jh0E2+tjlhnysFZr0ty7BpL997rcOHuf09B3HtiO8YZhxGEQ/vQ70wGe
	 QDGBoT4oE/0Cce1a4e4uT05IRMBLWgMGXAwnd84cIvkdExBbi5jUN3JcMPIjcPjt4+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="L/9HpUNN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29260606A8BB;
	Fri, 13 Nov 2026 06:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L/9HpUNN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A97681F000CD;
	Fri, 13 Nov 2026 06:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794552404;
	bh=yAgAt0XLovdcBjoYisxQBS4FvH+YQnymMRd0TOGYu4k=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=L/9HpUNNbJsQMGSFg1bqdiKxqTzduaVekYN/OyCFiuVef/ENZTPPF2dpDVYT5E/+C
	 Vd/tyo8LcYRo/ouxC8GKgU8NuFw5scO3oJu6P2tjab7yA2R8ZMj7hfVWpbGxkA1B23
	 slY8T0URBVjXVsCf4tCISaMKmrwKL3KZyH4LcWu6ie1dPyB7SkKRBkhjuf95TCelT1
	 bGsJQNsSv52gTaom2IOP9FGGaFH8V9UELPlvf2So8m4GBH667nqJhHMud56Er9tHuK
	 PRZ5DCdt6Bao9z7x3E3rCCXaUiNQtA82lCv63rmcMx9I8aKZ5IOE91rlSLPCfQiqvq
	 FDKxkyybAwybw==
Subject: Re: [PATCH net-next v10 4/4] net: mana: add dynamic HWC queue depth
 with reinit path
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
Date: Fri, 13 Nov 2026 06:46:42 +0000
Message-ID: <179455240227.2199510.2666165032389090040@kernel.org>
In-Reply-To: <aa4e08e8bc9a7139778b11875e41921d2d813712.1794208055.git.weh@linux.microsoft.com>
References: <aa4e08e8bc9a7139778b11875e41921d2d813712.1794208055.git.weh@linux.microsoft.com>
X-sashiko-severity: Medium
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

Thank you for your contribution! Sashiko AI review found 4 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 2 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The patch turns the PF-reported HWC_INIT_DATA_MAX_REQUEST /
  HWC_INIT_DATA_MAX_RESPONSE values into enforced per-direction limits.
- [Medium] The rebuild makes the HWC SQ, RQ and CQ rings larger, but
  nothing tells the PF the new ring sizes, and nothing checks that it…
- [Low] Before this patch the PF's QUEUE_DEPTH, MAX_REQUEST and
  MAX_RESPONSE init reports were read and ignored, so the channel always…
- [Low] The patch fixes an existing out-of-bounds MMIO bug inside a large
  feature patch, with no Fixes: tag.

--

net: mana: add dynamic HWC queue depth with reinit path

The HWC is rebuilt at the PF-reported queue depth when that depth is
between 2 and 128 and both reported message sizes equal the 4096-byte
bootstrap allocation. If the rebuild fails, the driver falls back to
fresh bootstrap queues. The reported request and response sizes become
per-direction limits shared with the GDMA and RDMA request builders, and
the device-supplied HWC doorbell index is now checked against BAR0.

Link: https://lore.kernel.org/r/20260908035201.402424-5-longli@microsoft.com
Link: https://lore.kernel.org/r/179196575846.434549.7933818740976196422@kernel.org

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index 8bc00001d20e5..867f8dd3ea547 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c

[ ... ]

> @@ -246,8 +264,18 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
>  	switch (event->type) {
>  	case GDMA_EQE_HWC_INIT_EQ_ID_DB:
>  		eq_db.as_uint32 = event->details[0];
> +		if (!mana_gd_is_valid_doorbell(gd->gdma_context,
> +					       eq_db.doorbell)) {
> +			dev_err(hwc->dev, "HWC: invalid doorbell %u\n",
> +				eq_db.doorbell);
> +			WRITE_ONCE(hwc->hwc_init_error, -EPROTO);
> +			complete(&hwc->hwc_init_eqe_comp);
> +			break;
> +		}
> +
>  		hwc->cq->gdma_eq->id = eq_db.eq_id;
>  		gd->doorbell = eq_db.doorbell;
> +		hwc->hwc_init_doorbell = true;
>  		break;

[Severity: Low]
This isn't a bug in the new code, but this check fixes an existing
out-of-bounds MMIO write, together with the INVALID_DOORBELL early return
added to mana_gd_ring_doorbell().

Before this patch, eq_db.doorbell came from the device and was stored
without any check. mana_gd_ring_doorbell() then wrote to:

    addr = gc->db_page_base + gc->db_page_size * db_index;

for any index the PF reported. If the INIT_EQ_ID_DB event never arrived,
db_index was INVALID_DOORBELL (UINT_MAX).

The commit message says this "hardens initial setup, which previously
accepted an unchecked device-supplied index". This fix does not depend on
the dynamic depth rebuild. Could it go in a separate patch with a Fixes:
tag, so older kernels can get the check? The doorbell bounds check in
mana_gd_register_device() covers the same kind of bug.

[ ... ]

> @@ -1175,32 +1256,169 @@ void mana_hwc_free_retained_channel(struct gdma_context *gc)
>  	gc->hwc.gdma_context = NULL;
>  }
>  
> -static int mana_hwc_create_bootstrap_channel(struct hw_channel_context *hwc)
> +static int
> +mana_hwc_validate_report(struct hw_channel_context *hwc,
> +			 const struct mana_hwc_init_report *report,
> +			 u32 expected_depth, bool check_depth,
> +			 bool require_exact_msg_sizes)
> +{
> +	if (!report->queue_depth || !report->max_req_msg_size ||
> +	    !report->max_resp_msg_size) {
> +		dev_err(hwc->dev,
> +			"HWC: invalid maxima depth=%u req=%u resp=%u\n",
> +			report->queue_depth, report->max_req_msg_size,
> +			report->max_resp_msg_size);
> +		return -EPROTO;
> +	}

[Severity: Low]
Before this patch, the QUEUE_DEPTH, MAX_REQUEST and MAX_RESPONSE init
reports were read and then ignored. The HWC always came up at depth 1
with 4096-byte limits.

mana_hwc_prepare_channel() now runs this check on the bootstrap report
before it decides whether to keep the bootstrap queues.
mana_hwc_restore_bootstrap() runs the same check on the fallback path.

Can a PF that leaves out any of these HWC_INIT_DATA types, or reports 0,
still bring up the HWC? It looks like HWC creation now fails with -EPROTO
even in the depth-1 setup that used to work, with no fallback.

The commit message does not mention this change. If it is intended, could
the commit message say so? Otherwise, should a missing report fall back
to the bootstrap values?

> +
> +	if (require_exact_msg_sizes &&

[ ... ]

> +static int mana_hwc_finish_channel(struct hw_channel_context *hwc,
> +				   const struct mana_hwc_init_report *report)
> +{
> +	int err;
> +
> +	/* MAX_REQUEST sizes the RQ; MAX_RESPONSE sizes the SQ. */
> +	hwc->rx_msg_size_limit = report->max_req_msg_size;
> +	hwc->tx_msg_size_limit = report->max_resp_msg_size;

[Severity: Medium]
Which direction does the PF mean by HWC_INIT_DATA_MAX_REQUEST?

Here MAX_REQUEST becomes the RX (response) limit and MAX_RESPONSE becomes
the TX (request) limit. The request budget in hw_channel.h then uses only
fields that come from the response side:

    /* Host-to-PF requests are bounded by the negotiated TX limit and SQ stride. */
    static inline u32
    mana_hwc_get_max_req_size(const struct hw_channel_context *hwc)
    {
    	return min(hwc->tx_msg_size_limit, hwc->max_resp_msg_size);
    }

So the PF's MAX_REQUEST report never limits host-to-PF requests.

This matches the existing queue sizing in mana_hwc_init_queues(), where
the RQ stride comes from max_req_msg_size and the SQ stride from
max_resp_msg_size. Before this patch, though, mana_gd_create_dma_region()
and mana_ib_gd_create_dma_region() used hwc->max_req_msg_size as the
request budget. Both constants are 4096 and the PF reports were ignored,
so the two conventions never disagreed in practice.

That changes now. mana_hwc_prepare_channel() keeps the bootstrap queues
for depth 1, or for depths above 128, even when MAX_REQUEST !=
MAX_RESPONSE. This function then installs those reported values as live
limits.

What if MAX_REQUEST means the largest request the PF accepts?
mana_hwc_get_msg_index() would then reject valid requests larger than
MAX_RESPONSE with -EMSGSIZE. Requests larger than the PF's real request
limit would still be sent. The RDMA CREATE and ADD_PAGES batch sizes
(max_pgs_create_cmd and max_pgs_add_cmd) would also come from the wrong
report.

The commit message talks about "directional maxima" and "the effective
host-to-PF request budget". It does not say that the request budget now
comes from MAX_RESPONSE. Could the direction be documented with a
reference to the device specification? Alternatively, could both
directions be limited by min(MAX_REQUEST, MAX_RESPONSE), with the fields
renamed to match?

[ ... ]

> +static int mana_hwc_rebuild_channel(struct hw_channel_context *hwc,
> +				    u16 q_depth,
> +				    struct mana_hwc_init_report *report)
> +{
> +	u32 timeout_ms = mana_hwc_timeout_read(hwc);
> +	int cleanup_err;
> +	int err;
> +
> +	err = mana_hwc_teardown_queues(hwc);
> +	if (err)
> +		return err;
> +
> +	err = mana_hwc_build_channel(hwc, q_depth, report);
> +	if (!err)
> +		err = mana_hwc_validate_report(hwc, report, q_depth,
> +					       true, true);
> +	if (!err)
> +		err = mana_hwc_finish_channel(hwc, report);
> +	if (!err)
> +		return 0;

[Severity: Medium]
How does the PF learn the ring sizes of the rebuilt channel?

At depth 1, mana_hwc_create_wq() and mana_hwc_create_cq() create 4 KiB
(MANA_MIN_QSIZE) rings. Above depth 8 the rings get larger:

mana_hwc_create_wq() {
    ...
	if (q_type == GDMA_RQ)
		queue_size = roundup_pow_of_two(GDMA_MAX_RQE_SIZE * q_depth);
	else
		queue_size = roundup_pow_of_two(GDMA_MAX_SQE_SIZE * q_depth);
    ...
}

At depth 128 the SQ is 64 KiB, the RQ 32 KiB and the CQ 16 KiB.

The HWC queues are only allocated locally; no GDMA_CREATE_QUEUE is sent.
The only message to the PF is ESTABLISH_HWC from
mana_smc_setup_hwc_locked(). It carries the four queue PFNs and the EQ
MSI-X vector, but no sizes.

Doorbells carry an offset that keeps increasing (queue->head *
GDMA_WQE_BU_SIZE in mana_gd_wq_ring_doorbell()). The device therefore
needs the same ring size to wrap at the same point as the driver.

The bootstrap channel already runs with 4 KiB rings while the PF reports a
larger depth. So the PF does not seem to size the rings from the depth it
reports.

The checks here also don't seem able to catch a mismatch. This
mana_hwc_validate_report() call only checks that the PF repeats the same
depth. mana_hwc_test_channel() sends one GENERATE_TEST_EQE request, which
never wraps a ring.

What happens if the PF keeps assuming 4 KiB rings? The SQ would first wrap
after about 8 WQEs, once the channel is already published. Could the driver
and device then disagree on ring positions, so that stale WQEs are run
again, CQEs are lost, or the device DMAs at the wrong ring offsets?

The fallback through mana_hwc_restore_bootstrap() sends a third
ESTABLISH_HWC with 4 KiB rings after one with larger rings. That depends
on the same undocumented rule.

Could the commit message or a comment describe how the PF learns the ring
geometry?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1794208055.git.weh%40linux.microsoft.com
