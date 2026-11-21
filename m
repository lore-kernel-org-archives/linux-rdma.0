Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795278569;
	b=fnq9M7FSUheep6osGmfpys72KN86U+3Un1uZlLqKXC9X2v0uWVe/W2g5aNpZwfQp2G6/
	 1bQoTKod2kOKIbugCjyjoEy49+lVc1WdfOVIyDbfMasm5GskqTLDhSF3qP+Pz9rDODy47
	 d2iCtw811P2dhP+SOgLYv8wFIkuITF0AGl7uX50uystBxWaDhFkAD6OjgI0VX23c13R6O
	 HWAe5EUkLRyUGT0K2G5hbPKJUzV+rbwNjvABjSX4i46kb30nidUgrEl0BremEZ4l7B9Gy
	 FOn16mzDoqGkxBpsc/wPR1TmzPunu5/vnXkkBNVQ3bJSkdzayY9vP+iKLBJl+ISnrag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795278569;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=M5xA6QGIByoSTDsPMlSDUlJT+zz0u0K41KRAMq/PgG8=;
	b=zKcAnb9p8PN7pl6OJ5Le/CUCU055wTEw6778nw/vcl/YvfgxTxjMpeiqfY4Q8dIoFP8v
	 mRG/DSNgmjJgf4f4XUxn4xP2PdKxtY7aEKahC7ZJdGwiM0HnXwSQ0+1eZUj+lncCsJpwD
	 CZ2HWtkmmRgb+JzLdAxn1yyo/haw8Lk5aqkybVQ9TBPIiB8+J8NWQfWnLP6mt5qnBJ1Mi
	 46E4lZXziVlL9/sE/G3b5H3c+0D8dZoW298iqAUvfOLD78XXAr92BOqMS3SB9eAjOCgp6
	 dF3Yz1vIB97lR+P3lDTdWql62t4wbOYn7BJMdmNKMsdjGg75mLXLL0jPqNhtb22AcZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LSZhSZha;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9CA606A320;
	Sat, 21 Nov 2026 16:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LSZhSZha
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C811F000C4;
	Sat, 21 Nov 2026 16:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795278569;
	bh=M5xA6QGIByoSTDsPMlSDUlJT+zz0u0K41KRAMq/PgG8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=LSZhSZhaRhXDhoI/Ly5RNxA9CyNgq61fv7dM6NzwgXdJD9MY/D7sJBIJblVE6WEZb
	 tQ17X2uYNNnx1kD4frt5j8D53rH4PZGIZZ8pFJQ0rZHbcZ+NjsHQNKQn3qp0GiDWvY
	 qahiR2S0MMEti+PI2AC33uspV7U92EdujCnUY9eYmYv/Y3dA4jACbbdGr5HGHn+a8A
	 tsCJ5/3chDBtjow9x7DIaKZCW5jy/qzxb+0Jbyhfl9lLv4ovkmO4waOUWnZ8YVkVZM
	 nU1FtxyPpd/TE6KUZXsIqlT+TplDmbl2ZtX2sXkLAyATXiuLkBd6oPXfEuEHlWkww6
	 50EHQ8wKY88wg==
Subject: Re: [PATCH net-next v11 1/4] net: mana: prepare HWC ownership for
 safe reinitialization
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
Date: Sat, 21 Nov 2026 16:29:27 +0000
Message-ID: <179527856753.3135.1812581824985082274@kernel.org>
In-Reply-To: <f94c7f71d4228c7c30838f9c901b429ec5b1428c.1794751992.git.weh@linux.microsoft.com>
References: <f94c7f71d4228c7c30838f9c901b429ec5b1428c.1794751992.git.weh@linux.microsoft.com>
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 (1) · Medium: 2 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The HWC DMA leak that the commit message describes as a one-
  time 'final disposal' cost can repeat without limit, because the…
- [Medium] mana_smc_setup_hwc_locked() sets *submitted
  (hwc->setup_active) to true just before the aperture writel() loop,…

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but the patch
  documents and relies on it being absent.

--

net: mana: prepare HWC ownership for safe reinitialization

This commit serializes the SMC ESTABLISH_HWC and DESTROY_HWC transactions.
It tracks whether the PF may own the HWC queues through setup_active, and
keeps the HWC queue memory when DESTROY_HWC is not acknowledged. It also
snapshots the PF-reported CQ count and CQ ID, publishes cq_table with
acquire/release ordering, and adds a final-disposal helper that frees only
software state when a gdma_context is discarded.

Link: https://lore.kernel.org/r/20260908035201.402424-2-longli@microsoft.com
Link: https://lore.kernel.org/r/20260908035201.402424-5-longli@microsoft.com
Link: https://lore.kernel.org/r/178910960115.219967.13830871915506436112@kernel.org
Link: https://lore.kernel.org/r/179196575238.434549.10775387794024020898@kernel.org
Link: https://lore.kernel.org/r/sashiko-outbox-170992@kernel.org
Link: https://lore.kernel.org/r/179455239601.2199510.13335902064048081755@kernel.org

> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> index d6ae89c2ccddc..fc460d83fb800 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c

[ ... ]

> @@ -796,11 +804,16 @@ static void mana_gd_process_eqe(struct gdma_queue *eq)
>  	switch (type) {
>  	case GDMA_EQE_COMPLETION:
>  		cq_id = eqe->details[0] & 0xFFFFFF;
> -		if (WARN_ON_ONCE(cq_id >= gc->max_num_cqs))
> +		/* HWC teardown unpublishes this table and waits for these
> +		 * RCU readers before freeing it, then fences its own EQ.
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

This isn't a bug introduced by this patch, but the new comment describes
a rule for cq_table (unpublish the slot, wait for RCU readers, then free)
that mana_ib does not follow. Can this IRQ path dereference a gdma_queue
that mana_ib has already freed?

drivers/infiniband/hw/mana/cq.c:mana_ib_remove_cq_cb() {
    ...
	kfree(gc->cq_table[cq->queue.id]);
	gc->cq_table[cq->queue.id] = NULL;
}

The entry is freed while it is still published. The slot is then cleared
with a plain store, and there is no grace period before or after.

A possible interleaving:

CPU0 (mana_gd_intr, under rcu_read_lock)
mana_gd_process_eqe()
    cq = READ_ONCE(cq_table[cq_id]);

CPU1
mana_ib_destroy_cq()
    mana_ib_remove_cq_cb()
        kfree(gc->cq_table[cq->queue.id]);

CPU0
    cq->type / cq->id checks
    cq->cq.callback(cq->cq.context, cq);

CPU0 then calls through a function pointer read from freed memory.
mana_ib_cq_handler() also dereferences the mana_ib_cq, which the IB core
frees after destroy_cq returns.

mana_ib_destroy_cq() calls mana_ib_remove_cq_cb() before
mana_ib_gd_destroy_cq(), so the device can still generate completions for
that CQ. The error path in mana_ib_create_qp_rss() has the same ordering:
it calls mana_ib_remove_cq_cb() before mana_ib_destroy_wq_obj().

mana_ib_install_cq_cb() also publishes the new gdma_cq with a plain store.
Nothing orders it against these READ_ONCE() readers:

	gc->cq_table[cq->queue.id] = gdma_cq;

Should mana_ib unpublish the slot, wait for a grace period, and only then
free the object, as the HWC teardown path in this patch does?

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index fb9f38f65911c..9e0964072af9a 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c

[ ... ]

> @@ -852,9 +960,44 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
>  	kfree(hwc);
>  	gc->hwc.driver_data = NULL;
>  	gc->hwc.gdma_context = NULL;
> +}
>  
> -	vfree(gc->cq_table);
> -	gc->cq_table = NULL;
> +static void mana_hwc_free_retained_wq(struct hwc_wq *wq)
> +{
> +	if (!wq)
> +		return;
> +
> +	kfree(wq->msg_buf);
> +	kfree(wq->gdma_wq);
> +	kfree(wq);
> +}
> +
> +/* Final disposal after IRQ and service-work teardown, not a retry path.
> + * Free only software state: unacknowledged HWC DMA allocations stay live.
> + */
> +void mana_hwc_free_retained_channel(struct gdma_context *gc)
> +{
> +	struct hw_channel_context *hwc = gc->hwc.driver_data;
> +
> +	if (!hwc)
> +		return;
> +
> +	gc->hwc.driver_data = NULL;
> +	mana_hwc_clear_cq_table(gc);
> +
> +	if (hwc->cq) {
> +		kfree(hwc->cq->gdma_eq);
> +		kfree(hwc->cq->gdma_cq);
> +		kfree(hwc->cq->comp_buf);
> +		kfree(hwc->cq);
> +	}
> +
> +	mana_hwc_free_retained_wq(hwc->txq);
> +	mana_hwc_free_retained_wq(hwc->rxq);

[Severity: Medium]

Can this leak repeat without limit through the existing PCI recovery loop?

When DESTROY_HWC is not acknowledged, mana_hwc_destroy_channel() leaves
the hwc in gc->hwc.driver_data. On probe failure or remove,
mana_gd_free_context() calls this function.

This function kfree()s gdma_eq, gdma_cq, and each wq's gdma_wq and
msg_buf. Those structures hold the only copies of the mem_info for the
EQ/CQ/RQ/SQ rings and both message buffers. mana_gd_free_memory() is
never called, so nothing can reach those coherent allocations afterwards.

After freeing the context, the probe error path schedules recovery:

mana_gd_probe() {
    ...
free_gc:
	pci_set_drvdata(pdev, NULL);
	mana_gd_free_context(gc);
    ...
	if (err == -ETIMEDOUT || err == -ENOTCONN || err == -EPROTO) {
		...
		schedule_delayed_work(&mana_dev_recovery_work.work,
				      secs_to_jiffies(MANA_SERVICE_PERIOD));

mana_serv_reset() then runs with gc == NULL and calls mana_serv_rescan(),
which probes the device again.

Consider a PF that keeps accepting ESTABLISH_HWC but never acknowledges
DESTROY_HWC, for example when INIT_DONE never arrives and DESTROY then
times out. Each cycle would leak another full HWC DMA footprint, and
nothing limits the number of retries.

The in-place reset path also behaves differently now. Before this patch,
mana_serv_reset() -> suspend/resume re-established the HWC in place,
because the teardown error was ignored. With a retained context,
mana_hwc_create_channel() returns a fixed -ETIMEDOUT and the real teardown
error is lost:

	if (gd->driver_data) {
		mana_hwc_destroy_channel(gc);
		if (gd->driver_data)
			return -ETIMEDOUT;
	}

mana_serv_reset() turns that error into a full remove/rescan:

	ret = mana_gd_resume(pdev);
	if (ret == -ETIMEDOUT || ret == -ENOTCONN || ret == -EPROTO) {
		/* Perform PCI rescan on device if we failed on HWC */
		dev_err(&pdev->dev, "MANA service: resume failed, rescanning\n");
		mana_serv_rescan(pdev);

The rescan then reaches the leaking path above.

The commit message describes this as a one-time final disposal. Should
recovery attempts be limited once HWC DMA has been retained? If not,
could the changelog at least describe this interaction?

[ ... ]

> diff --git a/drivers/net/ethernet/microsoft/mana/shm_channel.c b/drivers/net/ethernet/microsoft/mana/shm_channel.c
> index d21b5db06e509..df9d05062dd57 100644
> --- a/drivers/net/ethernet/microsoft/mana/shm_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/shm_channel.c

[ ... ]

> @@ -229,6 +243,7 @@ int mana_smc_setup_hwc(struct shm_channel *sc, bool reset_vf, u64 eq_addr,
>  	/* Write 256-message buffer to shared memory (final 32-bit write
>  	 * triggers HW to set possession bit to PF).
>  	 */
> +	*submitted = true;
>  	dword = (u32 *)shm_buf;
>  	for (i = 0; i < SMC_APERTURE_DWORDS; i++)
>  		writel(*dword++, sc->base + i * SMC_BASIC_UNIT);

[Severity: Medium]

What happens to setup_active when the PF returns possession with a
well-formed ESTABLISH_HWC response that carries a non-zero status?

In that case mana_smc_read_response() returns -EPROTO:

	if (hdr.status != 0) {
		dev_err(sc->dev, "SMC operation failed: 0x%x\n", hdr.status);
		return -EPROTO;
	}

smc_proto_hdr defines status as the operation result on a response
(success = 0, failure = 1 or greater), so this is an explicit rejection.
Even so, *submitted stays true, and hwc->setup_active still records that
the PF owns the HWC queues.

Only mana_smc_teardown_hwc_locked() clears the flag, and only after a
DESTROY_HWC sent with reset_vf=false is acknowledged. As a result, the
create failure path in mana_hwc_create_channel() sends DESTROY_HWC for a
channel the PF reported it never established.

If the PF rejects or ignores that DESTROY, the hwc is retained. Every
later mana_hwc_create_channel() on that gc then returns -ETIMEDOUT, and
mana_hwc_free_retained_channel() leaks all of the HWC coherent DMA memory.

The baseline sent DESTROY only after init events had arrived
(max_num_cqs > 0).

Could an explicit non-zero status in the ESTABLISH_HWC response clear
*submitted? Alternatively, could a DESTROY with reset_vf set be tried as a
fallback before the context is retained?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1794751992.git.weh%40linux.microsoft.com
