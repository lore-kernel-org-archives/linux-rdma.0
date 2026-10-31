Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793451029;
	b=MIEBY2IwOw7ypnsMdLxYJppJYf76qhx5/+h90Hjcc2WRN3CO48gn86Z5YAiAjly5FgMr
	 DyevTaTOr3tQ6Qev8wFDfZVr5YpdsLWLI/YjoAeOoH4GP+uopinDfKOWONdQI9JKZtj3u
	 jjm45vtuxl2xxye1weHTZka25/1wXloQblx77UuTN/bzxJsKR3gZKqd2gC6YF1IiaJjfN
	 2SiBwndYZJiv2993ErKOaK3N+jCs2iUfDpQT+QvF53IP8FoFpfBa1zawb6R7GEh/yg1Je
	 nKdXUghizG9mplkDeHAj0HoSD3ZlHnZSgHG7fKkC0UtsRIKy4bIFfiw9LHW4ay+1AxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793451029;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=855nSihgJxWPmK/GjrHlfXOpPZnhxUNNchV+utP1W5U=;
	b=PbG01IiaaqgK+0OQg2nt5QjD3t8Ismh7YjnosoJVktwvwlHKCFUazgQhpiM2lpUSgoPr
	 q239yMdiHPboal1PefqTmv5JBFz/2//eTvuEcUMvXoBAudPW/LTOGIzaOd663efIBAfPb
	 kj101Nov5LFivUyO6nG+pXxyxOkdmT5S+akfvq6FmjM7+v9eWWJTCebaP+kcYv6cn/qNQ
	 NFrxrod1bzwDD8DN2uwjEUQqdsFmGfpfGiC/Iftjtm9WeLRYMttvw+ITFIB/8cgdtKqXu
	 Uw/ZAtWS4vmqRkHpRoWsitiirGxv7FLRiWC3V6zHXwTZgQyTksjkIVOP4dGnv9S9p6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NHN+0jiR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653C6606A31C;
	Sat, 31 Oct 2026 12:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NHN+0jiR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C391F000C1;
	Sat, 31 Oct 2026 12:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793451028;
	bh=855nSihgJxWPmK/GjrHlfXOpPZnhxUNNchV+utP1W5U=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=NHN+0jiR/hvhURG6dSdCdv/WkC1d7eFQENt7ZIo06gKiGDK/BKsaRiCWs/qJq7Dxq
	 25m1y1s2gaGjXcPo5JN2wqKZ8Zu78p2sulEnbk5VKAxjn88QV3vEOSLscfmXwHhC7e
	 fq7kvmNowOarsuTKkxKwhIL+cJ5WWzQu5Ah1kHflkyG87u+NZ0UFZCO7m25FDEqYDX
	 wkxMJcLJ6UtgQOvpoKImIbJllFu+9is9zYOQDOcqBww1Mp7YrQYd1NknOvBfOufp6W
	 uE5QhvCAlwX7oeNxqzc5Ns3PAWLieL1/24E7gDRTAG7LklvcYiTsQ5BNK+Y36MVK8k
	 Mv8i0oAGkAYfg==
Message-ID: <sashiko-outbox-191945@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2] net: mana: Avoid waiting on dead HWC after
 device reset
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sahil Chandna" <sahilchandna@linux.microsoft.com>, linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261030125009.3758592-1-sahilchandna@linux.microsoft.com>
References: <20261030125009.3758592-1-sahilchandna@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 31 Oct 2026 12:50:28 +0000
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
- [High] net: mana: missing TX CQ poll after final sleep in mana_dealloc_qu=
eues()
- [Medium] net: mana: incomplete dead HWC checks in mana_dealloc_queues()
--

commit 4704079fb73cc77fdb1cc7581dd8e498b290c328
Author: Sahil Chandna <sahilchandna@linux.microsoft.com>

net: mana: Avoid waiting on dead HWC after device reset

This commit replaces the 120s sleep-based TX drain in mana_dealloc_queues()
with synchronous CQ polling and marks the hardware channel dead after a
device reset so subsequent HWC commands fail fast instead of waiting for a
timeout.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/=
ethernet/microsoft/mana/mana_en.c
> index 6b7c027e497ed..2bf17fdcfa2bd 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c

[ ... ]

> @@ -3774,42 +3784,104 @@ static int mana_dealloc_queues(struct net_device=
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
> +			struct napi_struct *napi;
> +			struct mana_cq *tx_cq;
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
> -			}
> -			if (atomic_read(&txq->pending_sends)) {
> -				err =3D mana_gd_dev_reset(gd->gdma_context);
> -				if (err) {
> -					netdev_err(ndev, "device reset failed %d with %d pkts pending in tx=
q %u\n",
> -						   err,
> -					    atomic_read(&txq->pending_sends),
> -					    txq->gdma_txq_id);
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
> +				 * For completion which have still not arrived
> +				 * allow time to settle.
> +				 * A zero budget frees skbs via the non-NAPI
> +				 * path, which is required outside softirq.
> +				 */
> +				tx_cq->budget =3D 0;
> +				for (retry =3D 0; retry < MANA_TX_DRAIN_RETRIES;
> +				     retry++) {
> +					do {
> +						tx_cq->work_done =3D 0;
> +						mana_poll_tx_cq(tx_cq);
> +					} while (tx_cq->work_done);
> +
> +					if (!atomic_read(&txq->pending_sends) ||
> +					    trigger_flr)
> +						break;
> +
> +					msleep(100);
>  				}
> -				break;
>  			}
> +
> +			pending =3D atomic_read(&txq->pending_sends);
> +
> +			if (!trigger_flr && pending > 0) {
> +				trigger_flr =3D true;
> +				flr_txq_id =3D txq->gdma_txq_id;
> +				flr_pending =3D pending;
> +			}
> +		}

[Severity: High]
In mana_dealloc_queues(), NAPI is disabled on tx_cq via napi_disable_locked=
()
before entering the MANA_TX_DRAIN_RETRIES loop, so only mana_poll_tx_cq()
inside this loop can reap CQEs and decrement txq->pending_sends.

On the last iteration (retry =3D=3D MANA_TX_DRAIN_RETRIES - 1), if
txq->pending_sends is still non-zero after polling, the loop calls
msleep(100) and then exits without calling mana_poll_tx_cq(tx_cq) again.

Because NAPI is disabled, any TX completions that arrive during that final
100 ms sleep remain unpolled in the CQ when pending =3D
atomic_read(&txq->pending_sends) is checked right after the loop. Can this
cause mana_dealloc_queues() to miss completions that arrived during the fin=
al
sleep and trigger an unnecessary mana_gd_dev_reset() and hwc->hwc_dead =3D =
true?

> +
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
>  		}
> =20
>  		for (i =3D 0; i < apc->num_queues; i++) {
> +			struct napi_struct *napi;
> +			struct mana_cq *tx_cq;
> +
> +			if (!apc->tx_qp[i])
> +				continue;
> +
> +			tx_cq =3D &apc->tx_qp[i]->tx_cq;
> +			napi =3D &tx_cq->napi;
> +
>  			txq =3D &apc->tx_qp[i]->txq;
>  			while ((skb =3D skb_dequeue(&txq->pending_skbs))) {
>  				mana_unmap_skb(skb, apc);
>  				dev_kfree_skb_any(skb);
>  			}
>  			atomic_set(&txq->pending_sends, 0);
> +
> +			if (txq->napi_initialized) {
> +				netif_napi_del_locked(napi);
> +				txq->napi_initialized =3D false;
> +			}
>  		}
>  	}
> =20
> @@ -3822,7 +3894,8 @@ static int mana_dealloc_queues(struct net_device *n=
dev)
>  	if (err && mana_en_need_log(apc, err))
>  		netdev_err(ndev, "Failed to disable vPort: %d\n", err);
> =20
> -	mana_fence_rqs(apc);
> +	if (!(hwc && hwc->hwc_dead))
> +		mana_fence_rqs(apc);

[Severity: Medium]
Should the dead-HWC checks in mana_dealloc_queues() also account for
hwc->hwc_timeout =3D=3D 0 (or mana_disable_vport_rx() timing out) and check
whether the HWC is already dead inside the TX drain retry loop?

Specifically:

1. In mana_serv_reset(), an unresponsive HWC is marked by setting
   WRITE_ONCE(hwc->hwc_timeout, 0) before calling
   mana_gd_suspend() -> mana_remove() -> mana_detach() ->
   mana_dealloc_queues():

   drivers/net/ethernet/microsoft/mana/gdma_pci.c:mana_serv_reset() {
       ...
       WRITE_ONCE(hwc->hwc_timeout, 0);
       dev_info(&pdev->dev, "MANA reset cycle start\n");
       mana_gd_suspend(pdev, PMSG_SUSPEND);
   }

   If no TX packets are pending (so trigger_flr is false and hwc->hwc_dead
   stays false), or if the HWC dies while TX is idle and
   mana_disable_vport_rx() fails with -ETIMEDOUT (reducing hwc->hwc_timeout
   to 1 without setting hwc->hwc_dead), checking only !(hwc && hwc->hwc_dea=
d)
   still calls mana_fence_rqs(apc), which logs an error and sleeps 100 ms p=
er
   RX queue while holding rtnl_lock.

2. In the TX drain retry loop above, the early break only checks the local
   variable trigger_flr:

       if (!atomic_read(&txq->pending_sends) ||
           trigger_flr)
           break;

   On a multi-port device during mana_remove(), after the first port resets
   the device and sets hwc->hwc_dead =3D true (or when hwc->hwc_timeout =3D=
=3D 0),
   subsequent calls to mana_dealloc_queues() start with trigger_flr =3D=3D =
false
   and will still sleep through MANA_TX_DRAIN_RETRIES on the first queue wi=
th
   pending sends.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030125009.3758=
592-1-sahilchandna@linux.microsoft.com?part=3D1
