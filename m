Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792503397;
	b=Z1af0pGWlP8vsTgCcPeCIfLeLNiHbbOah+LCQwh2oqggea6W4bEelSyeuM7kMfU6gmQE
	 HV/9ZvH5fvrdZfUjeJOtNQQYq7UQNzSz5YZbD0E7An8BdmZeV+1yg9041sBvm0lp1a6Nk
	 qO/tnR9rwlUVZxbRRWNzyIKp2Qu37F+KWh3iSOaHMFMsd/UNOxw+e0RXjuJC2r+3kuITZ
	 mcc3hwGZICIW0b2KkBq3gb0e1saxoOgu60MiUcQ8Yhqnq3OdqMkEnjVH1gdAaCN52a9u0
	 XqWG0CA/fZ4D4cGvG7DJ7uB8QOqid/Yka7z2Y44CELvlrv7XonN/lkShwk8zrR5mD0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792503397;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=MTcLZ13M8wQqh5NfAuT+FDOrmigvvwT1NksmdqftjC8=;
	b=mUgNeGnlruB1poOPHR23tViNRlpXmtvhMIkOpZ6Tn/6+aL9pkKQKDPkUC9dItt1DLBgf
	 R3SSopozXpjjfL8JOpjERZL15Aqs6rsTVNRkyMytGAuSPVJw1RxRgr2wmsWtu98d0B46h
	 uooPbn1nBJZ1mnvyKgYfiWPybHU3bm2fOvYMinVXGz6zzrKorbNnwVvB9zWR7nKKKXA10
	 sVgitGmOCqF7emwVdl5mooR+I0WRSgRcla2F0LXcYqw+cLT3pKxNqKCE4ngaMN7ZeE0tD
	 NHxHgfGMOpO8b4uoiLC9CSY2y2d7Zq5eeq1e/ySJyDYOFZSxEiTsoB1NvIpy0UAIUSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yd1KJ+oQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3719B60A4AE1;
	Tue, 20 Oct 2026 13:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yd1KJ+oQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354DB1F000C7;
	Tue, 20 Oct 2026 13:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792503396;
	bh=MTcLZ13M8wQqh5NfAuT+FDOrmigvvwT1NksmdqftjC8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Yd1KJ+oQ+3H4EFsXkBHw1APCdwWCw6IB2ZncTYDYsaQApOL4yIcyn4MeHJH3ljIum
	 yKlIklv8ARIzhhYigJ++D4MWVC+BDJiJUIGOLAKTp/Q3PI6aiVdcFspmNzN/kPlbMD
	 Ocnkn8KrfUgc9MTyER1V+qssriXvAWknZ3lv5YUNUjFvRvZMhuXuu8M8ZJijlUnGHD
	 n0wBa3KUxdkWr/WaWInoRU0b+beLLFChtyFaL8NAR2FBW25sQRfBwwATRbZ05mJpp7
	 +AF+ew03KP4gWjb61y9sw6rGok18++RxNpBuosO2HhfRurdj12XIqXkFc80zmJBmJg
	 X9A+zrWR8gW4g==
Subject: Re: [PATCH net-next v8 4/4] net: mana: add dynamic HWC queue depth
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
Date: Tue, 20 Oct 2026 13:36:34 +0000
Message-ID: <179250339474.3135.8335532818248262678@kernel.org>
In-Reply-To: =?utf-8?q?=3C877e674c0255820b0517f863e535615b4028a48a=2E1791998?=
 =?utf-8?q?462=2Egit=2Eweh=40linux=2Emicrosoft=2Ecom=3E?=
References: =?utf-8?q?=3C877e674c0255820b0517f863e535615b4028a48a=2E17919984?=
 =?utf-8?q?62=2Egit=2Eweh=40linux=2Emicrosoft=2Ecom=3E?=
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

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] Rebuilt HWC rings change size with depth, but the PF is never
  told the new size.
- [Low] The fix for the unchecked HWC init doorbell index ships inside a
  large feature patch, and the patch has no Fixes: tag.
- [Low] mana_hwc_rebuild_channel() saves hwc_timeout into timeout_ms on
  entry.

--

net: mana: add dynamic HWC queue depth with reinit path

The HWC now starts with depth-one bootstrap queues. When the PF reports a
depth from 2 to 128 with 4096-byte maxima, the channel is torn down and
rebuilt at that depth. If the rebuild fails, the driver falls back to
fresh bootstrap queues. Request sizes are bounded by the negotiated limits
in the GDMA and RDMA builders, and the HWC init doorbell index is now
validated against BAR0 before use.

Link: https://lore.kernel.org/r/20260908035201.402424-5-longli@microsoft.com
Link: https://lore.kernel.org/r/179196575846.434549.7933818740976196422@kernel.org

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index 9ea67c076ebda..c4cae1baaef4d 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c

[ ... ]

> @@ -247,8 +263,18 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
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
This isn't a bug, but the unchecked HWC init doorbell index fixed here
dates back to ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure
Network Adapter (MANA)").

Before this patch, mana_hwc_init_event_handler() did:

	gd->doorbell = eq_db.doorbell;

with no bounds check. mana_gd_ring_doorbell() then used that index to
compute the MMIO address.

The fix looks self-contained: mana_gd_is_valid_doorbell(), the
INVALID_DOORBELL check in mana_gd_ring_doorbell() and the hwc_init_error
completion. Would it be easier to review and backport as a separate patch
ahead of the dynamic depth rebuild?

The similar hardening commit 89fe91c65992 ("net: mana: hardening: Validate
doorbell ID from GDMA_REGISTER_DEVICE response") was merged without a
Fixes: tag, so leaving the tag off here may be intentional.

[ ... ]

> @@ -1179,32 +1258,168 @@ void mana_hwc_free_retained_channel(struct gdma_context *gc)

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
How does the PF learn the size of the rebuilt rings?

mana_hwc_create_cq() and mana_hwc_create_wq() size the rings from the
depth:

	eq_size = roundup_pow_of_two(GDMA_EQE_SIZE * q_depth);
	cq_size = roundup_pow_of_two(GDMA_CQE_SIZE * q_depth);
	queue_size = roundup_pow_of_two(GDMA_MAX_RQE_SIZE * q_depth);
	queue_size = roundup_pow_of_two(GDMA_MAX_SQE_SIZE * q_depth);

At depth 128 the CQ is 16 KiB, the RQ 32 KiB and the SQ 64 KiB. At depth
1 every ring is 4 KiB.

The ESTABLISH_HWC message built by mana_smc_setup_hwc_locked() carries
only the four frame addresses, their high 4 bits and the EQ MSI-X index:

	hdr->msg_type = SMC_MSG_TYPE_ESTABLISH_HWC;
	hdr->msg_version = SMC_MSG_TYPE_ESTABLISH_HWC_VERSION;

It has no size or depth field, and the message version is unchanged.

mana_hwc_rebuild_channel() sends this message for the depth-N rings. If
that fails, mana_hwc_restore_bootstrap() sends the same message for 4 KiB
rings, after the PF has already accepted a depth-N establish. A later
driver reload does the same, because mana_hwc_create_channel() always
starts with a bootstrap establish.

If the PF sizes the rings from the depth it advertised, could it write
EQEs or CQEs past the end of the 4 KiB bootstrap rings? If it assumes
4 KiB instead, would the owner-bit phase diverge after the first wrap of
a rebuilt ring and stall the HWC?

The check_depth test in mana_hwc_validate_report() confirms the depth the
PF reports, not the ring size it actually uses. Is there a firmware
contract that covers this? If so, could it be documented here?

> +	if (!err)
> +		err = mana_hwc_validate_report(hwc, report, q_depth, true, true);
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
Can this restore overwrite a timeout that firmware set during the
rebuild?

timeout_ms is read once at the top of mana_hwc_rebuild_channel(). While
the depth-N channel is being built, its EQ is live with
mana_hwc_init_event_handler(), which can run this from IRQ context:

	case HWC_DATA_CFG_HWC_TIMEOUT:
		mana_hwc_timeout_update(hwc, val);

mana_hwc_timeout_update() replaces any nonzero value. If the rebuild then
fails, this call writes the stale snapshot over the firmware-supplied
value, not just over the value of 1 left by mana_hwc_timeout_reduce().

The commit message says the restore is there so that "a failed test's
fail-fast reduction does not poison the retry". Would a cmpxchg from 1 to
timeout_ms match that intent and keep concurrent firmware updates?

The effect looks temporary. Once mana_hwc_create_channel() succeeds,
mana_gd_verify_vf_version() queries the PF timeout again through
mana_gd_query_hwc_timeout() when GDMA_DRV_CAP_FLAG_1_HWC_TIMEOUT_RECONFIG
is advertised.

> +
> +	return mana_hwc_restore_bootstrap(hwc, report);
> +}

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1791998462.git.weh%40linux.microsoft.com
