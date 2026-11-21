Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795278576;
	b=v84cYRTvc5EjUmc/MHr5e8fUgYSKWuNqcHqVcI7IvJrnehx5KyMEmAJKTtkVXW9tymck
	 ilxXPAsOsqUBoJ7JCcuv4DjnR/gB4NwUGg1EuSR3j9S3BbDjJIChh3FFvmbpPQMZCbBtK
	 AuV4RMTNPOBoLzRq6fZpQ5ubOFigWP81jlfEeW7wPQ6WdJbHuswkiKnkkK3G4My8jIURm
	 wYr35fcuwvc6vaMHPWu//DoGX7tLBBdmpWFMbAtApW1ULdhPdtBm3EwZ5nz8yx+H1o3RW
	 OkB4UQrCb4PGgDq4cDpqRK33QotOnVBDsiidb3jU12WCaCbOooolDV6ENTpwfn2G7Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795278576;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=7pTO9UUl+mG5YGWMBUjqicuNyqzAniAX0C4MOR49s3Y=;
	b=2+k1Gum4veZne8K4Krv1wGddqrtKldvjMcimvP82+Qa97HcksW+5SR+mFecJJGr6CKCf
	 e7Gt37EHz15H/tXLIxjrR2KAmmVDs5eryeEOPem7Mm3c2LeM480/YG2A8gbXQ+iLrZeuj
	 3ux7V9KrXxoql2FL3itw8r/2j0vjTwubZ5DyXg+WrVZxMc8iR/cMfHB7eHWzZ/cpWJvjn
	 6jZsdDM7F9WKxN5WubLt5dzgB6ihVtER9o89Cv4BLEFHrlKuAs86akbkANou/amQRkLZQ
	 635EZXl8SjK7koM+t1BSJ2soSpWmMPQbcobLuwwvIoNf8xJBS1quNW2D9kEefwdz4yA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iWgawBs3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241DD606A32A;
	Sat, 21 Nov 2026 16:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iWgawBs3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882A71F000C0;
	Sat, 21 Nov 2026 16:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795278575;
	bh=7pTO9UUl+mG5YGWMBUjqicuNyqzAniAX0C4MOR49s3Y=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=iWgawBs3/Zp2tbpI81pY2gW2dgpQE3uAw5/DC42GeRQvSR8GhWuWPi0L2Vs+JMuZ7
	 pYRzf6i1w8DF39/Px65tLsmlncfWdn/ZGfhaY0DS2JhIGQdQNj31lbYr0oCx1plyKY
	 MLBiVGTsTcEUqL26E6frohWQ9bWN5rtYDDwDBiu0C3krXwjawc5pUQTvg+MiC+OjSO
	 aKcyOipfVoaRQM9H6RawByV2fjZmAipgqURq79bO0tqe7dMlnbuKX3nF0MHtHGzgGu
	 DIuMHsaHjI5Xan7KWBnSZmJsI0FqIY2HCNAG3erk4Yz6NoG0DCLTXvyV/3l1M3mn0i
	 RqAFoOD4C8DSA==
Subject: Re: [PATCH net-next v11 4/4] net: mana: add dynamic HWC queue depth
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
 mawasthi@linux.microsoft.com, weh@microsoft.com, edumazet@kernel.org,
 shacharr@microsoft.com
Date: Sat, 21 Nov 2026 16:29:34 +0000
Message-ID: <179527857414.3135.3409829551491930106@kernel.org>
In-Reply-To: <100c6b7a71e86c8d7afd0c55f6b231f01db184d5.1794751992.git.weh@linux.microsoft.com>
References: <100c6b7a71e86c8d7afd0c55f6b231f01db184d5.1794751992.git.weh@linux.microsoft.com>
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

Critical: 0 · High: 0 · Medium: 3 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The only defect fix in this commit is the HWC doorbell
  validation and MMIO suppression: mana_gd_is_valid_doorbell(), the…
- [Medium] The rebuilt HWC gives the PF rings much larger than the
  bootstrap rings, but ESTABLISH_HWC carries no size information.
- [Medium] mana_hwc_finish_channel() maps the PF's
  HWC_INIT_DATA_MAX_REQUEST report to the VF receive direction…
- [Low] mana_hwc_rebuild_channel() saves `timeout_ms =
  mana_hwc_timeout_read(hwc)` on entry.

--

net: mana: add dynamic HWC queue depth with reinit path

The HWC starts on depth-one bootstrap queues. This commit rebuilds it at
the depth the PF reports (2 through 128), falling back to fresh bootstrap
queues if the rebuild fails. It also applies the PF-reported message sizes
as admission limits shared with the GDMA and RDMA request builders. It
validates the device-supplied HWC doorbell index against BAR0 and skips
doorbell MMIO while the doorbell is invalid.

Link: https://lore.kernel.org/r/20260908035201.402424-5-longli@microsoft.com
Link: https://lore.kernel.org/r/179196575846.434549.7933818740976196422@kernel.org
Link: https://lore.kernel.org/r/179455240227.2199510.2666165032389090040@kernel.org

> and suppress MMIO while it is invalid. The original driver accepted an
> unchecked device-supplied index in its MMIO address calculation; this also
> fixes that existing out-of-bounds MMIO path. Backports need the complete
> ownership and validation dependencies, not the entire feature stack by
> default.

[ ... ]

> Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")

[Severity: Medium]
Should this be split into two patches?

As far as I can tell, the only defect fix here is the HWC doorbell
validation:

  - mana_gd_is_valid_doorbell()
  - the GDMA_EQE_HWC_INIT_EQ_ID_DB check in mana_hwc_init_event_handler()
  - the INVALID_DOORBELL early return in mana_gd_ring_doorbell()
  - invalidating gc->hwc.doorbell before every ESTABLISH_HWC

Everything else is new behaviour:

  - the depth rebuild in mana_hwc_prepare_channel() and
    mana_hwc_rebuild_channel()
  - the new -EMSGSIZE admission check in mana_hwc_get_msg_index()
  - the new request budget in mana_gd_create_dma_region() and
    mana_ib_gd_create_dma_region()
  - power-of-two rounding in mana_hwc_alloc_dma_buf()
  - new -EPROTO probe failures from mana_hwc_validate_report() when the
    QUEUE_DEPTH, MAX_REQUEST or MAX_RESPONSE report is zero or missing,
    even at depth one

Before this patch, mana_hwc_establish_channel() read those reported
values but nothing used them.

With the Fixes: tag on this commit, stable selection could pull the whole
feature into stable kernels, including the new probe failures. The commit
message says the feature stack should not be backported by default.
However, the fix can't be taken on its own while both are in one commit.

Could the doorbell validation go into its own patch with the Fixes: tag,
and the dynamic depth work be sent without one?

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index 8c2495ce5f526..cb73d0725206e 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c

[ ... ]

> @@ -1175,32 +1256,169 @@ void mana_hwc_free_retained_channel(struct gdma_context *gc)

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
Are these two limits applied in the right directions?

mana_hwc_get_max_req_size() returns:

	return min(hwc->tx_msg_size_limit, hwc->max_resp_msg_size);

So the PF's MAX_RESPONSE report caps outgoing VF-to-PF requests in
mana_hwc_get_msg_index(), mana_gd_create_dma_region() and
mana_ib_gd_create_dma_region(). MAX_REQUEST caps the response buffers.

Before this patch, mana_gd_create_dma_region() and
mana_ib_gd_create_dma_region() bounded outgoing requests by
hwc->max_req_msg_size.

The comment here seems to follow the stride naming in
mana_hwc_init_queues(), where the RQ is created with
HW_CHANNEL_MAX_REQUEST_SIZE. The old code never used the reported sizes,
so nothing in the tree shows which direction the PF means.

If the PF reports different sizes, the bootstrap channel is kept and
these limits are used:

  - MAX_REQUEST=2048 and MAX_RESPONSE=4096 would let the VF send
    4096-byte requests the PF said it can't accept.
  - MAX_REQUEST=4096 and MAX_RESPONSE=2048 would make CREATE_DMA_REGION
    for larger queues fail with -EINVAL, and would shrink the RDMA
    ADD_PAGES batches.

Can the PF meaning of MAX_REQUEST and MAX_RESPONSE be confirmed here?

> +
> +	err = mana_hwc_test_channel(hwc);

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

[Severity: Medium]
Does the PF know that the rebuilt rings are larger than the bootstrap
rings?

mana_smc_setup_hwc_locked() packs only these into the 256-bit aperture,
with no size fields:

  - four page frame numbers (EQ, CQ, RQ, SQ)
  - the EQ MSI-X index
  - the protocol header

The ring sizes grow with q_depth (mana_hwc_init_queues() passes
q_depth * 2 for the CQ):

mana_hwc_create_cq():
	cq_size = roundup_pow_of_two(GDMA_CQE_SIZE * q_depth);

mana_hwc_create_wq():
	if (q_type == GDMA_RQ)
		queue_size = roundup_pow_of_two(GDMA_MAX_RQE_SIZE * q_depth);
	else
		queue_size = roundup_pow_of_two(GDMA_MAX_SQE_SIZE * q_depth);

At depth 128 that gives a 16 KiB CQ, a 32 KiB RQ and a 64 KiB SQ. Every
bootstrap ring is 4 KiB.

The same ESTABLISH_HWC message, with no sizes, is used three times: for
the bootstrap, the rebuild, and the restored bootstrap.

Existing kernels have run long-lived traffic on 4 KiB bootstrap rings
while the PF reported a larger QUEUE_DEPTH. So the PF must already work
with 4 KiB rings.

If the PF keeps that geometry, would it disagree with the rebuilt rings
after the first wrap?

If the PF does change geometry on the rebuild, could the restore path in
mana_hwc_restore_bootstrap() let the device write EQEs or CQEs past the
4 KiB coherent allocations?

mana_hwc_test_channel() posts N RX WQEs and raises one EQ test event. No
ring wraps before the channel is published, so the test would not catch
a mismatch.

The commit message says:

  the absence of VF size fields in ESTABLISH_HWC does not require
  keeping the bootstrap geometry.

Is there a documented PF or firmware contract, or a capability bit, that
backs this up?

> +	if (!err)
> +		err = mana_hwc_validate_report(hwc, report, q_depth,
> +					       true, true);
> +	if (!err)
> +		err = mana_hwc_finish_channel(hwc, report);
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
> +	/* Do not carry the failed test's reduced wait into the retry. */
> +	mana_hwc_timeout_update(hwc, timeout_ms);

[Severity: Low]
Can this overwrite a timeout that the PF set during the rebuild?

timeout_ms is saved on entry to mana_hwc_rebuild_channel(). Once the
rebuilt channel is established, its EQ is live with
mana_hwc_init_event_handler() as the callback. A HWC_DATA_CFG_HWC_TIMEOUT
reconfig event arriving then would do:

	case HWC_DATA_CFG_HWC_TIMEOUT:
		mana_hwc_timeout_update(hwc, val);

If the establish validation or mana_hwc_test_channel() then fails, this
unconditional update writes the old saved value over the firmware value.

mana_hwc_timeout_update() only refuses to revive 0. It can't tell the
fail-fast value of 1 set by mana_hwc_timeout_reduce() apart from a
firmware update.

The comment on hwc_timeout in struct hw_channel_context also says:

	/* Zero permanently cancels waits for this channel instance. Firmware
	 * and query updates may replace a live nonzero value; fail-fast may
	 * only reduce a live value to one millisecond.
	 */

A driver-internal restore of an older value isn't one of the writers
listed there.

The effect looks limited, because mana_gd_verify_vf_version() queries
the timeout again later when GDMA_DRV_CAP_FLAG_1_HWC_TIMEOUT_RECONFIG is
set.

> +
> +	return mana_hwc_restore_bootstrap(hwc, report);
> +}

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1794751992.git.weh%40linux.microsoft.com
