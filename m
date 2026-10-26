Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792999747;
	b=UIlBIuDbIw8xVABcds0aVexDp6pqNJ3iiIZB5TUf1KKPrX+jOk7B+rRq9KW5D6XhZLzP
	 y9mKkehD+KXYe55EXZTLWm2oRciowfrY4X/qicrRDH2c69g9uPVEEJHtaDdqrKMg7yMdY
	 EMUN40QrsWpaNDmwBJamC0+JrGVu6LZhC8aUqhN+IIyb3yv4xiB2VbHknBkqNd4asj0rO
	 KMES1leg34TQQiSVnVMhB/PAy43OpX6/z1Nts2HuxFSRfEVowT/IjMqx+ta8547jiPWbl
	 PhSElD+w6fZaqyT9ecKkhCy5Y81cY+pa9MqTQ0PoBuvfIGk0GZzm1FC/5sApmKrcSAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792999747;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xYuf+f4ph8gY4VLaYVoyuneCQX+wrWHgQJ4vO+pSJ60=;
	b=zkoaeAjo9kCIecr21gQGC5K1rotxX8uGXbMLRfDwyjp5xO3YgqL2RIHmR2/krXDzZBj2
	 kcaQ4ndslGhAsh0ahY2WtIicnGcHdGTM6Tn5J8B2iPQRPhrE2a5m6sbDM8CG+KG8As0y/
	 HUA3wN/aWBqFbPftOMDK5ha/pKNiOmC5CU8AdSLYoztnUG1EmdrnNB7n6vk+kBPdRgIff
	 GyRkIL/m+NXvHTzksWxSz2dnlKr4gVOZCvZM2+mR6WHew3mGOJB5ZCLLCmIqB54NOhm9E
	 y/SzHH92MEMcNtL6qznr2VdBZexHboBPPpME7iHMnpKkGub1ygcI1rdg1sxmjMcsgrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FJrcjRCO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE7D606A31F;
	Mon, 26 Oct 2026 07:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FJrcjRCO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1CF91F01828;
	Mon, 26 Oct 2026 07:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792999746;
	bh=xYuf+f4ph8gY4VLaYVoyuneCQX+wrWHgQJ4vO+pSJ60=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=FJrcjRCOUIzdotwCUjpfAnW6sAMtpY5SXW4yqnwxfGKmO8QPmqdUk5eftRH5AVuJd
	 2xjM5jb/ld6w3GiOjGpgEq0xhKwFvMHvV9TjgvOk25g+gz6v+DRFAht22AWu9Do9LS
	 RcBPFCRxmqoaUybaQLhFz1MIkfF8x10vkG1i4fL4sZpm3wVVj669C8MlgXFG2dx1ui
	 QMt+QDALU3KbyJF89WdDeYzdPhNm8P3RuL0I246XkLb1bdYeCb88hZ0p3RF2jCyeLb
	 wJSAPFajyB172auax58O+IrKYkjnmtzJUAXxXkD8qbPy4b59JEg3s06cY1dXO4pVv3
	 H28cvUrf/Juyg==
Message-ID: <sashiko-outbox-184659@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net: mana: Avoid waiting on dead HWC after device
 reset
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sahil Chandna" <sahilchandna@linux.microsoft.com>, linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261025072838.1991785-1-sahilchandna@linux.microsoft.com>
References: <20261025072838.1991785-1-sahilchandna@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 07:29:06 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] net: mana: non-waiting CQ poll in mana_dealloc_queues() triggers f=
alse FLR
- [Medium] net: mana: mana_hwc_send_request() blocks on hwc->sema before ch=
ecking hwc_dead
--

commit 7823c203253d16c1fb640cce922ae30200b9f486
Author: Sahil Chandna <sahilchandna@linux.microsoft.com>

net: mana: Avoid waiting on dead HWC after device reset

This commit replaces the sleep-based TX queue drain in mana_dealloc_queues()
with synchronous CQE polling and marks the hardware channel dead via hwc_de=
ad
after a device reset so subsequent HWC commands fail fast with -ETIMEDOUT.

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/n=
et/ethernet/microsoft/mana/hw_channel.c
> index 3bca4b683134b..c9337f49fbe15 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c

[ ... ]

> @@ -862,6 +867,7 @@ int mana_hwc_send_request(struct hw_channel_context *=
hwc, u32 req_len,
>  	u32 dest_vrcq;
>  	u32 dest_vrq;
>  	u32 command;
> +	u32 timeout =3D 0;
>  	u16 msg_id;
>  	int err;
> =20
> @@ -897,6 +903,17 @@ int mana_hwc_send_request(struct hw_channel_context =
*hwc, u32 req_len,
>  	dest_vrq =3D hwc->dest_vrq_id;
>  	dest_vrcq =3D hwc->dest_vrcq_id;
> =20
> +	/* If the HWC is unavailable (e.g. hwc_timeout was set to 0 or
> +	 * hwc_dead set after device reset), do not post the WQE: the
> +	 * hardware cannot respond, so fail fast instead of waiting out
> +	 * the full timeout.
> +	 */
> +	timeout =3D READ_ONCE(hwc->hwc_timeout);
> +	if (timeout =3D=3D 0 || READ_ONCE(hwc->hwc_dead)) {
> +		err =3D -ETIMEDOUT;
> +		goto out;
> +	}

[Severity: Medium]
Can mana_hwc_send_request() still block for the full hwc_timeout on
hwc->sema before reaching this hwc_dead check?

At the start of mana_hwc_send_request(), mana_hwc_get_msg_index() is called:

    mana_hwc_send_request()
      -> mana_hwc_get_msg_index()
           -> down(&hwc->sema);

Because hwc->sema is initialized to 1 (HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH),
only one HWC command can be in flight at a time.

While the device is active, periodic work such as
mana_gf_stats_work_handler() (running every 2 seconds without holding
rtnl_lock) or auxiliary RDMA (mana_ib) callers can enter
mana_hwc_send_request(), acquire hwc->sema, and sleep in
wait_for_completion_timeout(&ctx->comp_event, ...) for the full 60s
hwc_timeout when the hardware stops responding.

When mana_dealloc_queues() resets the device and sets hwc->hwc_dead =3D tru=
e,
it does not complete any in-flight ctx->comp_event, so the subsequent
mana_disable_vport_rx() -> mana_hwc_send_request() call in
mana_dealloc_queues() will still block in down(&hwc->sema) while holding
rtnl_lock until the concurrent caller's timeout expires.

Should hwc_timeout =3D=3D 0 || hwc_dead also be checked before acquiring
hwc->sema (or should in-flight waiters be completed when marking HWC dead)?

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/=
ethernet/microsoft/mana/mana_en.c
> index 6b7c027e497ed..00885d21a9af0 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -3753,16 +3753,19 @@ int mana_attach(struct net_device *ndev)
>  static int mana_dealloc_queues(struct net_device *ndev)
>  {
>  	struct mana_port_context *apc =3D netdev_priv(ndev);
> -	unsigned long timeout =3D jiffies + 120 * HZ;
>  	struct gdma_dev *gd =3D apc->ac->gdma_dev;
> +	struct hw_channel_context *hwc;
> +	bool trigger_flr =3D false;
> +	int flr_pending, i, err;
>  	struct mana_txq *txq;
>  	struct sk_buff *skb;
> -	int i, err;
> -	u32 tsleep;
> +	u32 flr_txq_id =3D 0;
> =20
>  	if (apc->port_is_up)
>  		return -EINVAL;
> =20
> +	hwc =3D gd->gdma_context->hwc.driver_data;
> +
>  	if (apc->rxqs)
>  		mana_chn_setxdp(apc, NULL);
> =20
> @@ -3774,42 +3777,92 @@ static int mana_dealloc_queues(struct net_device =
*ndev)
>  	 * a txq because it may not timely see apc->port_is_up being cleared
>  	 * to false, but it doesn't matter since mana_start_xmit() drops any
>  	 * new packets due to apc->port_is_up being false.
> -	 *
> -	 * Drain all the in-flight TX packets.
> -	 * A timeout of 120 seconds for all the queues is used.
> -	 * This will break the while loop when h/w is not responding.
> -	 * This value of 120 has been decided here considering max
> -	 * number of queues.
> +	 * Drain the in-flight TX completions for each queue. TX is already
> +	 * stopped, so pending_sends can no longer grow. For each queue,
> +	 * disable NAPI so it cannot run at the same time as this drain,
> +	 * then process all completions still in the CQ. If some are still
> +	 * missing after that, the hardware is not responding: reset device
> +	 * and stop waiting on the now-unavailable HWC.
>  	 */
> =20
>  	if (apc->tx_qp) {
>  		for (i =3D 0; i < apc->num_queues; i++) {
> +			struct mana_cq *tx_cq;
> +			struct napi_struct *napi;
> +			int pending;
> +
> +			if (!apc->tx_qp[i])
> +				continue;
> +
> +			tx_cq =3D &apc->tx_qp[i]->tx_cq;
>  			txq =3D &apc->tx_qp[i]->txq;
> -			tsleep =3D 1000;
> -			while (atomic_read(&txq->pending_sends) > 0 &&
> -			       time_before(jiffies, timeout)) {
> -				usleep_range(tsleep, tsleep + 1000);
> -				tsleep <<=3D 1;
> +			napi =3D &tx_cq->napi;
> +
> +			if (txq->napi_initialized) {
> +				/* Stop the NAPI poll so it cannot run
> +				 * concurrently with the synchronous drain.
> +				 */
> +				napi_synchronize(napi);
> +				napi_disable_locked(napi);
> +				cancel_work_sync(&tx_cq->dim.work);
> +
> +				/* Reap all TX completions currently in the CQ.
> +				 * A zero budget frees skbs via the non-NAPI
> +				 * path, which is required outside softirq.
> +				 */
> +				tx_cq->budget =3D 0;
> +				do {
> +					tx_cq->work_done =3D 0;
> +					mana_poll_tx_cq(tx_cq);
> +				} while (tx_cq->work_done);
>  			}
> -			if (atomic_read(&txq->pending_sends)) {
> -				err =3D mana_gd_dev_reset(gd->gdma_context);
> -				if (err) {
> -					netdev_err(ndev, "device reset failed %d with %d pkts pending in tx=
q %u\n",
> -						   err,
> -					    atomic_read(&txq->pending_sends),
> -					    txq->gdma_txq_id);
> -				}
> -				break;
> +
> +			pending =3D atomic_read(&txq->pending_sends);
> +			if (!trigger_flr && pending > 0) {
> +				trigger_flr =3D true;
> +				flr_txq_id =3D txq->gdma_txq_id;
> +				flr_pending =3D pending;
>  			}
>  		}
> =20
> +		if (trigger_flr && !(hwc && hwc->hwc_dead)) {
> +			/* Completions never arrived: the device is
> +			 * unresponsive. Issue device reset and
> +			 * mark the HWC dead so subsequent HWC commands
> +			 * fail fast instead of each waiting the full
> +			 * hwc_timeout.
> +			 */
> +			err =3D mana_gd_dev_reset(gd->gdma_context);
> +			if (err)
> +				netdev_err(ndev, "device reset failed %d with %d pkts pending in txq=
 %u\n",
> +					   err,
> +					   flr_pending,
> +					   flr_txq_id);
> +			else if (hwc)
> +				WRITE_ONCE(hwc->hwc_dead, true);
> +		}

[Severity: High]
Won't this non-waiting CQ poll trigger a premature Function Level Reset and
permanently mark the HWC dead whenever TX packets are still in flight in the
hardware during a normal detach or per-port queue reset?

In mana_detach(), setting apc->port_is_up =3D false and calling
netif_tx_disable(ndev) prevents new packets from being queued in software,
but packets posted to txq->gdma_sq right before netif_tx_disable() are still
asynchronously in flight in the NIC hardware (DMA read, shaping, wire
transmission, and CQE DMA write-back).

mana_poll_tx_cq() is non-blocking:

    mana_poll_tx_cq()
      comp_read =3D mana_gd_poll_cq(cq->gdma_cq, completions, ...);
      if (comp_read < 1)
              return;

As soon as mana_gd_poll_cq() reaches a CQE slot that the hardware has not
yet written back to host memory, it returns 0, mana_poll_tx_cq() returns
early with tx_cq->work_done =3D=3D 0, and the do-while loop exits immediate=
ly
without waiting for the in-flight SQ entries to complete.

If any packet is still in flight on the NIC when the loop exits,
atomic_read(&txq->pending_sends) > 0 sets trigger_flr =3D true, which calls
mana_gd_dev_reset() and sets hwc->hwc_dead =3D true on healthy hardware.

Because hwc->hwc_dead is never cleared without destroying and recreating the
HWC channel, any operation that detaches and reattaches queues under traffic
(such as mana_close() followed by mana_open(), mana_change_mtu(),
mana_set_channels(), mana_set_ringparam(), mana_set_priv_flags(), or
mana_xdp_set()) will cause subsequent mana_attach() or mana_open() calls and
any other vPorts or RDMA instances on the function to fail permanently with
-ETIMEDOUT.

Similarly, single-port TX timeout recovery in
mana_per_port_queue_reset_work_handler() runs when a TX queue is stalled
(so pending_sends > 0 holds by definition):

    mana_per_port_queue_reset_work_handler()
      -> mana_detach(ndev, false)
           -> mana_dealloc_queues(ndev)
      -> mana_attach(ndev)

Because mana_dealloc_queues() now resets the entire PCIe function and sets
hwc->hwc_dead =3D true, the recovery call to mana_attach(ndev) immediately
fails with -ETIMEDOUT instead of recovering the port.

Furthermore, if mana_gd_dev_reset() fails or is skipped because hwc_dead was
already set, the cleanup loop immediately below unmaps and frees the
in-flight TX SKBs via mana_unmap_skb() and dev_kfree_skb_any() without
having waited for DMA completion or reset the device.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261025072838.1991=
785-1-sahilchandna@linux.microsoft.com?part=3D1
