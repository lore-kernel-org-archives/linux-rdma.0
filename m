Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E874A4AB3C0;
	Wed, 14 Oct 2026 08:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791965766; cv=none; b=p9wkhoarJUP6Fai7uQpXYUr8cgjkuQ7aP6pSlmfEfFo34K92UIOqA8nYENPdFKixOYO7Y5E0MndgkCDBGqdOEWoklriKCOamPeeaNyTgYUAFBmYzCoBJuWboJs9SA5PcW/Z6fzw9abN8QQA3NmriiHvf87BSee7+a10PBjy3J7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791965766; c=relaxed/simple;
	bh=iFgIwbDHoOhneqPJXGtyfKjcVFGZ9OCNWsFRuj5BR98=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RVwvoPOqjI48INXzJyVFaR85hX2dsVHQYszvmMAbW2x/aVseNjYyd9VtuB3e8YLCGiv2e42MgNR5ONs+RnhVHv1if3mvLAb+XvWX5Q1UnBdeUsCsOh/Eu/N3II5/UCN/vwlKoB6HvsBq93GEUasr2XSpveNse4FUqs6fp0Hmr5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hkV7w2kM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hkV7w2kM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7CDB1F00899;
	Wed, 14 Oct 2026 08:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791965760;
	bh=Y+qX62Z/0ddXg1hASU/3cEmdnsYRkrqoiWMhNj5xtr4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=hkV7w2kM1PocT9/NLDhPhd5jsT0fl6KOPtF/S0C09UfnDQzVLGaY2XffY3bgZSdPb
	 FP23I7cdiix6hsJ5G0jdD/fSijDfcgwy7J8gixGxpqoIcaDzZWL2pp4pk+TXmcUjFd
	 RbtQLKqMwCFovWwEMQgIc7dpGfhalY/p225NUuzR1uGJaEv22Hq7exZRTIoL1YfQWk
	 BL+xRH4S4fa30MYdvdP0sbsSPx5MyffZNW1cYRIVvhGebCBL2rsv6Fr2sUqyVhimZO
	 I52wKsM6Dm8AzuwglRpAhdJZeUzpHEEuU+ztNXzo0xaeyx3wBaUB7ipHLHsvDtq2F1
	 RULrL3+knQs6Q==
Subject: Re: [PATCH net-next v7 4/4] net: mana: add dynamic HWC queue depth
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
Date: Wed, 14 Oct 2026 08:15:58 +0000
Message-ID: <179196575846.434549.7933818740976196422@kernel.org>
In-Reply-To: =?utf-8?q?=3Cdf59976f0f5e51ea5766451f02878bd04a4907cc=2E1791561?=
 =?utf-8?q?995=2Egit=2Eweh=40linux=2Emicrosoft=2Ecom=3E?=
References: =?utf-8?q?=3Cdf59976f0f5e51ea5766451f02878bd04a4907cc=2E17915619?=
 =?utf-8?q?95=2Egit=2Eweh=40linux=2Emicrosoft=2Ecom=3E?=
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 7 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 2 · Low: 5

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The size limit that callers use and the limit that
  mana_hwc_send_request() now enforces can disagree.
- [Medium] If the rebuilt channel fails its test, setup aborts instead of
  falling back to bootstrap.
- [Low] This feature patch also fixes an older bug without saying so.
- [Low] The commit message contains revision-history text that won't make
  sense in git history: 'instead of the goto-heavy creation flow from…
- [Low] Two comments are now inaccurate.
- [Low] The new size gate in mana_hwc_send_request() runs before
  mana_hwc_get_msg_index() checks whether the channel is up.
- [Low] An invalid doorbell report produces a 60-second timeout instead
  of an immediate -EPROTO.

--

net: mana: add dynamic HWC queue depth with reinit path

The patch treats the depth the PF reports for the HWC as a maximum. It
rebuilds the depth-one bootstrap channel when the report is 2 through 128.
If a rebuild fails, it falls back to fresh bootstrap queues. It also
enforces the reported request/response maxima on every HWC request and
validates the doorbell the PF reports during ESTABLISH_HWC.

Link: https://lore.kernel.org/r/20260908035201.402424-5-longli@microsoft.com

> Do not advertise the proposed dynamic-depth capability bit. Driver-version
> advertisement occurs after HWC establishment and cannot negotiate behavior
> needed while the channel is being created.
>
> Use focused build, validation, rebuild and fallback helpers instead of the
> goto-heavy creation flow from v5.

[Severity: Low]
This isn't a bug, but these two paragraphs read like revision-history notes.

No dynamic-depth capability bit exists in the tree. The only DYNAMIC flag in
include/net/mana/gdma.h is GDMA_DRV_CAP_FLAG_1_DYNAMIC_IRQ_ALLOC_SUPPORT.
Also, "from v5" won't mean anything once this is in git history.

Could these notes move below the --- line?

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index 9fdd84ccba653..c9f7db5a76a58 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> @@ -227,8 +227,16 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
>  	switch (event->type) {
>  	case GDMA_EQE_HWC_INIT_EQ_ID_DB:
>  		eq_db.as_uint32 = event->details[0];
> +		if (!mana_gd_is_valid_doorbell(gd->gdma_context,
> +					       eq_db.doorbell)) {
> +			dev_err(hwc->dev, "HWC: invalid doorbell %u\n",
> +				eq_db.doorbell);
> +			break;
> +		}
> +
>  		hwc->cq->gdma_eq->id = eq_db.eq_id;
>  		gd->doorbell = eq_db.doorbell;
> +		hwc->hwc_init_doorbell = true;
>  		break;

[Severity: Low]
Before this patch, gd->doorbell was taken from GDMA_EQE_HWC_INIT_EQ_ID_DB
with no range check. mana_gd_ring_doorbell() turns it directly into an MMIO
address:

    addr = gc->db_page_base + gc->db_page_size * db_index;
    ...
    writeq(e.as_uint64, addr);

So an out-of-range index from the PF could already trigger a writeq()
outside BAR0 on every boot, not only on re-establish.
mana_gd_register_device() already applied the same BAR0 check to
resp.db_id.

This closes an existing hole. Could it be split into a separate fix with a
Fixes: tag, so stable trees pick it up?

[ ... ]

> @@ -838,6 +853,18 @@ static int mana_hwc_establish_channel(struct hw_channel_context *hwc,
>  	u32 cq_id;
>  	int err;
>  
> +	hwc->hwc_init_q_depth_max = 0;

[ ... ]

> +	gc->hwc.pdid = INVALID_PDID;
> +	/* Re-establish must not rearm through the previous channel's doorbell. */
> +	gc->hwc.doorbell = INVALID_DOORBELL;

[ ... ]

> @@ -852,9 +879,14 @@ static int mana_hwc_establish_channel(struct hw_channel_context *hwc,
>  	if (!wait_for_completion_timeout(&hwc->hwc_init_eqe_comp, 60 * HZ))
>  		return -ETIMEDOUT;
>  
> -	*q_depth = hwc->hwc_init_q_depth_max;
> -	*max_req_msg_size = hwc->hwc_init_max_req_msg_size;
> -	*max_resp_msg_size = hwc->hwc_init_max_resp_msg_size;
> +	if (!hwc->hwc_init_doorbell) {
> +		dev_err(hwc->dev, "HWC: missing valid doorbell in init data\n");
> +		return -EPROTO;
> +	}

[Severity: Low]
Can this -EPROTO check be reached when the PF reports a bad doorbell?

gc->hwc.doorbell is set to INVALID_DOORBELL above. If
mana_hwc_init_event_handler() rejects GDMA_EQE_HWC_INIT_EQ_ID_DB, the
doorbell stays invalid.

mana_gd_process_eq_events() handles at most 5 EQEs per interrupt and then
re-arms the EQ:

    mana_gd_ring_doorbell(gc, eq->gdma_dev->doorbell, eq->type, eq->id,
                          head, SET_ARM_BIT);

With this patch, mana_gd_ring_doorbell() returns early for
INVALID_DOORBELL, so the EQ is never re-armed. The rest of the init
sequence, including GDMA_EQE_HWC_INIT_DONE, would then not raise another
interrupt.

Wouldn't wait_for_completion_timeout() run the full 60 seconds and return
-ETIMEDOUT, instead of failing fast with -EPROTO? On the rebuild path this
can happen at each establish stage.

[ ... ]

> @@ -943,6 +979,44 @@ static int mana_hwc_init_queues(struct hw_channel_context *hwc, u16 q_depth,

[ ... ]

> +/* Setup owns an unpublished HWC and has no runtime senders here. */
> +static void mana_hwc_destroy_queues(struct hw_channel_context *hwc)

[Severity: Low]
This isn't a bug, but is this comment accurate? mana_hwc_destroy_queues()
is also reached during runtime teardown:

mana_hwc_destroy_channel()
  mana_hwc_release_channel()
    mana_hwc_teardown_queues()
      mana_hwc_destroy_queues()

On that path it is safe because of the unpublish plus
mana_hwc_stop_channel(), not because setup owns the channel.

The existing comment on the error path in mana_hwc_init_queues() also no
longer holds:

    out:
        /* mana_hwc_create_channel() will do the cleanup.*/
        return err;

On the rebuild path, mana_hwc_rebuild_channel() cleans up the failed
candidate itself with mana_hwc_teardown_queues().

[ ... ]

> @@ -1110,36 +1173,150 @@ static bool mana_hwc_release_channel(struct hw_channel_context *hwc)

[ ... ]

> +static int mana_hwc_rebuild_channel(struct hw_channel_context *hwc,
> +				    u16 q_depth,
> +				    struct mana_hwc_init_report *report)
> +{
> +	int cleanup_err;
> +	int err;
> +
> +	err = mana_hwc_teardown_queues(hwc);
> +	if (err)
> +		return err;
> +
> +	err = mana_hwc_build_channel(hwc, q_depth, report);
> +	if (!err)
> +		err = mana_hwc_validate_report(hwc, report, q_depth, true, true);
> +	if (!err)
> +		return 0;
> +
> +	dev_warn(hwc->dev,
> +		 "HWC depth %u rebuild failed, restoring bootstrap: %d\n",
> +		 q_depth, err);
> +
> +	cleanup_err = mana_hwc_teardown_queues(hwc);
> +	if (cleanup_err)
> +		return cleanup_err;
> +
> +	return mana_hwc_restore_bootstrap(hwc, report);
> +}

[ ... ]

> +	} else if (report.queue_depth >
> +		   HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH) {
> +		rebuild_depth = report.queue_depth;
> +		err = mana_hwc_rebuild_channel(hwc, rebuild_depth, &report);
> +		if (err)
> +			return err;
>  	}
>  
> +	/* MAX_REQUEST sizes the RQ; MAX_RESPONSE sizes the SQ. */
> +	hwc->rx_msg_size_limit = report.max_req_msg_size;
> +	hwc->tx_msg_size_limit = report.max_resp_msg_size;
> +
>  	err = mana_hwc_test_channel(hwc);
>  	if (err)
>  		dev_err(hwc->dev, "Failed to test HWC: %d\n", err);

[Severity: Medium]
What happens if mana_hwc_test_channel() fails on a rebuilt channel?

mana_hwc_rebuild_channel() returns 0 as soon as the candidate is
established and its report validates. The bootstrap restore therefore only
covers build and validation failures.

A failure here goes straight back to mana_hwc_create_channel(), which
releases the channel and fails probe. Examples are an EQ test timeout, an
error status, or mana_hwc_post_rx_wqe() failing at the larger depth.

The commit message says:

    Keep each candidate channel private through queue creation,
    establishment and the direct EQ test. Publish only the final tested
    channel. If a rebuild fails after acknowledged teardown, destroy that
    candidate and establish fresh bootstrap queues

Should the EQ test be part of the rebuild, so a failure there also falls
back to bootstrap? With the parent commit, the same PF would have run on a
tested depth-one channel. Recovery retries would also go through the same
rebuild again.

[ ... ]

> @@ -1329,8 +1506,19 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
>  	struct gdma_req_hdr *req_msg;
>  	struct hwc_caller_ctx *ctx;
>  	u32 command;
> +	u32 req_limit;
> +	u32 resp_limit;
>  	int err;
>  
> +	req_limit = min(hwc->tx_msg_size_limit, hwc->max_resp_msg_size);
> +	resp_limit = min(hwc->rx_msg_size_limit, hwc->max_req_msg_size);
> +	if (req_len > req_limit || resp_len > resp_limit) {
> +		dev_err(hwc->dev,
> +			"HWC: message sizes req=%u/%u resp=%u/%u exceed channel maxima\n",
> +			req_len, req_limit, resp_len, resp_limit);
> +		return -EMSGSIZE;
> +	}
> +

[Severity: Medium]
Can this gate reject requests that callers have already sized correctly?

Callers size their requests from hwc->max_req_msg_size. That field stays at
HW_CHANNEL_MAX_REQUEST_SIZE and is never lowered to the effective limit.
For example, mana_gd_create_dma_region() does:

    if (req_msg_size > hwc->max_req_msg_size)
        return -EINVAL;

and mana_ib_gd_create_dma_region() in drivers/infiniband/hw/mana/main.c
does:

    max_pgs_create_cmd =
        (hwc->max_req_msg_size - sizeof(*create_req)) / sizeof(u64);
    ...
    max_pgs_add_cmd = (hwc->max_req_msg_size -
                       sizeof(*add_req)) / sizeof(u64);

This gate instead bounds req_len by tx_msg_size_limit.
mana_hwc_prepare_channel() takes that value from report.max_resp_msg_size.

The kept-bootstrap paths accept any non-zero report: depth one, depth above
128, or maxima other than 4096. Suppose the PF reports MAX_RESPONSE below
4096. Wouldn't queue DMA region creation and large RDMA MR registration
then fail with -EMSGSIZE, instead of being split into smaller chunks?

The reverse case also applies: a smaller MAX_REQUEST is never shown to
request producers.

The direction also looks inverted from the producers' side.
max_req_msg_size is the RQ stride used in mana_hwc_rx_event_handler():

    rx_req_idx = (sge->address - rq_base_addr) / hwc->max_req_msg_size;

while this gate bounds requests by the SQ size (max_resp_msg_size).

The commit message says the effective limit is enforced on every request.
Should the in-tree producers be switched to that same limit?

[Severity: Low]
Should this check come after the channel_up test in
mana_hwc_get_msg_index()?

If mana_hwc_prepare_channel() fails before it assigns rx_msg_size_limit and
tx_msg_size_limit, both stay at zero from kzalloc. If
mana_smc_teardown_hwc() then also fails, mana_hwc_release_channel() stores
this hwc in gc->hwc.driver_data through mana_hwc_retain_channel():

    err = mana_hwc_teardown_queues(hwc);
    if (err) {
        mana_hwc_retain_channel(hwc);
        return false;
    }

A later mana_gd_send_request() on that retained channel would compute
req_limit = min(0, ...) = 0 here. It would then return -EMSGSIZE and log
an unratelimited dev_err() on every attempt. Before this patch it returned
-ENODEV, because channel_up is false.

>  	err = mana_hwc_get_msg_index(hwc, resp, resp_len, &ctx);
>  	if (err)
>  		return err;

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1791561995.git.weh%40linux.microsoft.com
