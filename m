Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793175755;
	b=0NUSWyZnpxsbw0d/wvf3pBaAJqJLGZBhwI7kGHM3or9csk6HcqNgAAUVNWvWONL4i23C
	 a2Pf2UgY0L9DP6MB3H5kGNNInjVbb35gez4yF14WYLUSkEi8Cne/t/O4oPhB2fB+iEvGI
	 KfHzUi7Eno77uElxuLs7LiL0VLATeLE6Mqz/m8Olg8W4+pDuo+WZBROS6xTXBHBFdd/Mb
	 FoGSV2TQHLgzOajHrRfZynKZevT4g7QHxkNkkBVE8mDu8F6w0PtEJxna4eYSodgr74s8q
	 SaU0a3EQ3BNAtHvsA55rRL+ISsmdvgrn/oiLVexKZGFdg3SSEacIXylQGzG5VC0Pj3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793175755;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=YoAgbK2Q/JRmEpt1KAMdH640OlevY4bds1IeJAqZsYI=;
	b=0TVeSUwIdd19YkWp3dWrUjRElJfk/NRuexUH9fi4k2NobLe67DNImR7c11l7o7h8fKQk
	 9nJysgzaGuXkJwJAxsL7b0UGnJf/BcxkoErR8cKQpEf71DUUcmK/ZGPznicCO7H/pnd3h
	 dZgOFkL9INTLAOlG/2YQSIZKpr7jwnfQyUrYJrW1hp6wusCv90qKdLPOUZT99zZPZTV+y
	 /Cp1/cCB0qmYXKS+7cUuHF6e1alfcUlU0Ort6AMx/oG7gvG/mDywVFTWubrE+mJkpKNxT
	 VQzD4y+ty/qOECKqaCXBrHWBzrx8L94M2ctsrpmTo+ZpcuE4+mjPomuFER+c4m0BdJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=OxcjeZhZ;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AFB0606A31E;
	Wed, 28 Oct 2026 08:22:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1AFB0606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=OxcjeZhZ
Received: from [10.26.7.43] (unknown [4.213.232.18])
	by linux.microsoft.com (Postfix) with ESMTPSA id A133220B7166;
	Wed, 28 Oct 2026 01:22:17 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A133220B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1793175742;
	bh=YoAgbK2Q/JRmEpt1KAMdH640OlevY4bds1IeJAqZsYI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OxcjeZhZvnFIL4uAYqLYvlHcb5vLxMyrDf9Rtp220tIV3ZpzOhEtr4bUPoJ5hCLkn
	 48u9zsTDCqgZK9dFzsmwmDIjr76H7zoOsGzG97HKXJXWrNk+maWpQF0Zvhlh0Fr8jX
	 A1U+R5vhZRcs/4FZdR6VxG/WGLZv019VfuUy48Ms=
Message-ID: <59685bcc-b9bb-4c50-bbf8-db52b9580ad8@linux.microsoft.com>
Date: Wed, 28 Oct 2026 13:52:26 +0530
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net: mana: Avoid waiting on dead HWC after device
 reset
To: netdev-bot+sashiko@kernel.org
Cc: haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, weh@microsoft.com,
 kotaranov@microsoft.com, horms@kernel.org, ernis@linux.microsoft.com,
 gargaditya@linux.microsoft.com, mawasthi@linux.microsoft.com,
 kees+treewide@kernel.org, schakrabarti@linux.microsoft.com,
 linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 stable@vger.kernel.org
References: <20261025072838.1991785-1-sahilchandna@linux.microsoft.com>
 <179300287088.3134.14257201772829101717@kernel.org>
Content-Language: en-US
From: Sahil Chandna <sahilchandna@linux.microsoft.com>
In-Reply-To: <179300287088.3134.14257201772829101717@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 26-10-2026 13:51, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 6 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 1 · Medium: 3 · Low: 2 (1)
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [High] mana_dealloc_queues()
>   (drivers/net/ethernet/microsoft/mana/mana_en.c) no longer waits for TX…
> - [Medium] If mana_gd_dev_reset() fails without quiescing the device,
>   mana_dealloc_queues() only logs the error.
> - [Medium] The new fail-fast check in mana_hwc_send_request() comes after
>   mana_hwc_get_msg_index(), which calls down(&hwc->sema) unconditionally.
> - [Medium] mana_dealloc_queues() sets hwc_dead only when
>   mana_gd_dev_reset() returns 0.
> - [Low] Several comments still say the DIM counters cq->tx_dim_pkts and
>   cq->tx_dim_bytes are touched only in NAPI context, which the patch…
> - [Low] The comment in mana_destroy_txq() (mana_en.c, about line 2728)
>   says 'Forget the SKBs freed without being completed after a drain…
> 
> Pre-existing issues:
> - [Low] This problem wasn't introduced by this patch, but the timeout
>   path in mana_hwc_send_request() does a non-atomic check-then-write:…
> 
> --
> 
> net: mana: Avoid waiting on dead HWC after device reset
> 
> This commit replaces the 120 second sleep-based TX drain in
> mana_dealloc_queues() with a single synchronous CQ sweep done while NAPI
> is disabled. If sends are still pending after the sweep, it resets the
> device. A successful reset sets a new hwc_dead flag, which makes
> mana_hwc_send_request() fail fast with -ETIMEDOUT and skips
> mana_fence_rqs() and the SHM teardown handshake.
> 
>> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
>> index 3bca4b683134b..c9337f49fbe15 100644
>> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
>> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> 
> [ ... ]
> 
>> @@ -897,6 +903,17 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
>>  	dest_vrq = hwc->dest_vrq_id;
>>  	dest_vrcq = hwc->dest_vrcq_id;
>>  
>> +	/* If the HWC is unavailable (e.g. hwc_timeout was set to 0 or
>> +	 * hwc_dead set after device reset), do not post the WQE: the
>> +	 * hardware cannot respond, so fail fast instead of waiting out
>> +	 * the full timeout.
>> +	 */
>> +	timeout = READ_ONCE(hwc->hwc_timeout);
>> +	if (timeout == 0 || READ_ONCE(hwc->hwc_dead)) {
>> +		err = -ETIMEDOUT;
>> +		goto out;
>> +	}
> 
> [Severity: Medium]
> Is this check reached early enough to avoid the RTNL stall after a reset?
> 
> Before getting here, mana_hwc_send_request() calls mana_hwc_get_msg_index(),
> which does an unconditional down(&hwc->sema). The HWC has a single request
> slot (HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH = 1).
> 
> Some HWC users run without RTNL, for example
> mana_gf_stats_work_handler()->mana_query_gf_stats() every 2 seconds, and
> mana_ib verbs. Suppose one of them has already taken the slot, passed this
> check, and is sitting in wait_for_completion_timeout() with the full
> timeout (60s on the tested system). The reset in mana_dealloc_queues()
> then guarantees that request never completes.
> 
> The teardown thread then does:
> 
> mana_dealloc_queues()
>   mana_disable_vport_rx()
>     ...
>       mana_hwc_send_request()
>         mana_hwc_get_msg_index()
>           down(&hwc->sema);    <-- waits out the other request's timeout
> 
> Setting hwc_dead does not wake the waiter that is already in flight. Can
> RTNL still be held here for the full hwc_timeout, which is the symptom the
> commit message says is fixed?
> 
Ack, will fix the hwc->sema based wait in v2.>> +
>>  	err = mana_hwc_post_tx_wqe(txq, tx_wr, dest_vrq, dest_vrcq, false);
>>  	if (err) {
>>  		dev_err(hwc->dev, "HWC: Failed to post send WQE: %d\n", err);
>> @@ -904,14 +921,13 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
>>  	}
>>  
>>  	if (!wait_for_completion_timeout(&ctx->comp_event,
>> -					 (msecs_to_jiffies(hwc->hwc_timeout)))) {
>> -		if (hwc->hwc_timeout != 0)
>> -			dev_err(hwc->dev, "Command 0x%x timed out: %u ms\n",
>> -				command, hwc->hwc_timeout);
>> +					 (msecs_to_jiffies(timeout)))) {
>> +		dev_err(hwc->dev, "Command 0x%x timed out: %u ms\n",
>> +			command, timeout);
>>  
>>  		/* Reduce further waiting if HWC no response */
>> -		if (hwc->hwc_timeout > 1)
>> -			hwc->hwc_timeout = 1;
>> +		if (READ_ONCE(hwc->hwc_timeout) > 1)
>> +			WRITE_ONCE(hwc->hwc_timeout, 1);
> 
> [Severity: Low]
> This isn't a bug introduced by this patch, but this read-then-write is not
> atomic. If mana_serv_reset() runs WRITE_ONCE(hwc->hwc_timeout, 0) between
> the READ_ONCE() and the WRITE_ONCE() here, the 0 is overwritten with 1.
> An HWC_DATA_CFG_HWC_TIMEOUT update from mana_hwc_init_event_handler() can
> be lost the same way.
> 
> The new fail-fast check depends on timeout == 0. With the 0 lost, later
> commands would post WQEs and wait about a jiffy each instead of failing
> immediately. Now that 0 means fail fast, would a cmpxchg() be worth using
> here?
> 
> [ ... ]
> 
>> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
>> index 6b7c027e497ed..00885d21a9af0 100644
>> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
>> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> 
> [ ... ]
> 
>> @@ -3774,42 +3777,92 @@ static int mana_dealloc_queues(struct net_device *ndev)
> 
> [ ... ]
> 
>>  	if (apc->tx_qp) {
>>  		for (i = 0; i < apc->num_queues; i++) {
> 
> [ ... ]
> 
>>  			txq = &apc->tx_qp[i]->txq;
>> -			tsleep = 1000;
>> -			while (atomic_read(&txq->pending_sends) > 0 &&
>> -			       time_before(jiffies, timeout)) {
>> -				usleep_range(tsleep, tsleep + 1000);
>> -				tsleep <<= 1;
>> +			napi = &tx_cq->napi;
>> +
>> +			if (txq->napi_initialized) {
>> +				/* Stop the NAPI poll so it cannot run
>> +				 * concurrently with the synchronous drain.
>> +				 */
>> +				napi_synchronize(napi);
>> +				napi_disable_locked(napi);
>> +				cancel_work_sync(&tx_cq->dim.work);
>> +
>> +				/* Reap all TX completions currently in the CQ.
>> +				 * A zero budget frees skbs via the non-NAPI
>> +				 * path, which is required outside softirq.
>> +				 */
>> +				tx_cq->budget = 0;
>> +				do {
>> +					tx_cq->work_done = 0;
>> +					mana_poll_tx_cq(tx_cq);
>> +				} while (tx_cq->work_done);
>>  			}
> 
> [Severity: Low]
> This isn't a bug, but this adds a process context caller of
> mana_poll_tx_cq(), which still updates cq->tx_dim_pkts and
> cq->tx_dim_bytes. The struct mana_cq comment in include/net/mana/mana.h
> says:
> 
> 	/* Cumulative TX completions fed to DIM. Updated and read only in
> 	 * NAPI context (mana_poll_tx_cq() / mana_update_tx_dim()), so they
> 	 * measure the hardware completion rate and need no u64_stats_sync.
> 	 */
> 
> mana_poll_tx_cq() and mana_update_tx_dim() have similar comments. NAPI is
> disabled and dim.work is cancelled before this loop runs. Should those
> comments be updated to mention this drain path?
> 
>> -			if (atomic_read(&txq->pending_sends)) {
>> -				err = mana_gd_dev_reset(gd->gdma_context);
>> -				if (err) {
>> -					netdev_err(ndev, "device reset failed %d with %d pkts pending in txq %u\n",
>> -						   err,
>> -					    atomic_read(&txq->pending_sends),
>> -					    txq->gdma_txq_id);
>> -				}
>> -				break;
>> +
>> +			pending = atomic_read(&txq->pending_sends);
>> +			if (!trigger_flr && pending > 0) {
>> +				trigger_flr = true;
>> +				flr_txq_id = txq->gdma_txq_id;
>> +				flr_pending = pending;
>>  			}
>>  		}
> 
> [Severity: High]
> Can this reset a healthy device during routine reconfiguration?
> 
> The do/while loop above stops as soon as mana_gd_poll_cq() finds no CQE
> already written. NAPI is disabled by then, so a completion that arrives
> later is never reaped. Before this patch the driver waited with NAPI
> enabled, for up to 120s, before treating pending_sends as a hardware
> failure.
> 
> mana_detach() calls this right after stopping TX:
> 
> mana_detach()
> 	netif_tx_disable(ndev);
> 
> 	if (apc->port_st_save) {
> 		err = mana_dealloc_queues(ndev);
> 
> The SQ can hold up to tx_queue_size WQEs (default 256, max 16384), and
> each can be a 64KB TSO frame. Under TX load, pending_sends > 0 after one
> sweep looks likely on a working device, which leads to:
> 
> mana_change_mtu() / mana_close() / mana_set_channels() / mana_xdp_set() ...
>   mana_detach()
>     mana_dealloc_queues()
>       mana_gd_dev_reset()      <-- pcie_flr() on PCI, cdx_dev_reset() on CDX
>       WRITE_ONCE(hwc->hwc_dead, true);
>   mana_attach()
>     ...
>       mana_hwc_send_request()  <-- -ETIMEDOUT since hwc_dead is set
> 
> The FLR also takes down the HWC, the EQs, the vPorts of every port on the
> function and the mana_ib device. None of them is notified.
> 
> On PCI, recovery only comes indirectly: the gf_stats worker sees
> -ETIMEDOUT and schedules mana_serv_reset(), which sleeps for
> MANA_SERVICE_PERIOD seconds. CDX has no service reset path, so the port
> stays down until reprobe.
> 
> The commit message says the device is reset "only if sends remain
> unacknowledged". After this change, that means "not yet completed at the
> instant of the sweep". Should there be a bounded wait for pending_sends
> before deciding the hardware is unresponsive, for example polling the CQ
> with a timeout?
> 
>> +		if (trigger_flr && !(hwc && hwc->hwc_dead)) {
>> +			/* Completions never arrived: the device is
>> +			 * unresponsive. Issue device reset and
>> +			 * mark the HWC dead so subsequent HWC commands
>> +			 * fail fast instead of each waiting the full
>> +			 * hwc_timeout.
>> +			 */
>> +			err = mana_gd_dev_reset(gd->gdma_context);
>> +			if (err)
>> +				netdev_err(ndev, "device reset failed %d with %d pkts pending in txq %u\n",
>> +					   err,
>> +					   flr_pending,
>> +					   flr_txq_id);
>> +			else if (hwc)
>> +				WRITE_ONCE(hwc->hwc_dead, true);
>> +		}
> 
Ack, will add bounded wait in v2.> [Severity: Medium]
> Is it safe to leave hwc_dead clear whenever mana_gd_dev_reset() returns an
> error?
> 
> On PCI the reset is mana_pci_dev_reset()->pcie_flr(). Once pcie_flr() gets
> past its early checks, it always issues the reset and then waits for the
> device:
> 
> 	pcie_capability_set_word(dev, PCI_EXP_DEVCTL, PCI_EXP_DEVCTL_BCR_FLR);
> 	...
> 	msleep(100);
> 
> 	ret = pci_dev_wait(dev, "FLR", PCIE_RESET_READY_POLL_MS);
> 
> If the device is not ready within about 60s, pci_dev_wait() fails. The
> function has been reset, but hwc_dead stays false and hwc_timeout keeps
> the firmware value.
> 
> The next command, MANA_CONFIG_VPORT_RX from mana_disable_vport_rx(), then
> passes the new check in mana_hwc_send_request(). It posts to the reset
> function and waits the full timeout with RTNL held. mana_fence_rqs() and
> the SHM teardown handshake also still run.
> 
> A device that has stopped producing TX completions seems the most likely
> one to also come back late. Could this path keep the stall the commit
> message describes, on top of the pci_dev_wait() time?
> 
>>  		for (i = 0; i < apc->num_queues; i++) {
> 
> [ ... ]
> 
>>  			txq = &apc->tx_qp[i]->txq;
>>  			while ((skb = skb_dequeue(&txq->pending_skbs))) {
>>  				mana_unmap_skb(skb, apc);
>>  				dev_kfree_skb_any(skb);
>>  			}
>>  			atomic_set(&txq->pending_sends, 0);
> 
> [Severity: Medium]
> What happens here if mana_gd_dev_reset() failed without quiescing the
> device?
> 
> In that case the error is only logged. These SKBs are then unmapped and
> freed while the SQ is still live in hardware; the SQ is only destroyed
> later, in mana_destroy_txq()->mana_destroy_wq_obj().
> 
> pcie_flr() can return before issuing the FLR:
> 
> 	ret = pci_dev_reset_iommu_prepare(dev);
> 	if (ret) {
> 		pci_err(dev, "failed to stop IOMMU for a PCI reset: %d\n", ret);
> 		return ret;
> 	}
> 
> On CDX, cdx_dev_reset() can likewise fail in dev_configure().
> 
> Before this patch, this sequence only ran after up to 120s of waiting, by
> which point a working device had finished. With the single sweep,
> outstanding WQEs on a healthy device are normal.
> 
> Can the device then DMA from unmapped or freed TX buffers? Under an IOMMU
> that would fault. Without strict IOMMU, it could send the new contents of
> reused pages.
> 
>> +
>> +			if (txq->napi_initialized) {
>> +				netif_napi_del_locked(napi);
>> +				txq->napi_initialized = false;
>> +			}
>>  		}
>>  	}
>
Ack, I will check above two comments and see if these can be fixed in v2.
> [Severity: Low]
> This isn't a bug, but since NAPI is now deleted here and napi_initialized
> is cleared, the NAPI teardown block in mana_destroy_txq() no longer runs
> on this path. Its comment also refers to the drain timeout that this patch
> removes:
> 
> 		/* Forget the SKBs freed without being completed after a drain
> 		 * timeout, now that NAPI can't complete any. Doing it here also
> 		 * covers the queues that a lower channel count won't recreate,
> 		 * which could otherwise stay stopped.
> 		 */
> 		netdev_tx_reset_queue(apc->tx_qp[i]->txq.net_txq);
> 
> Should this comment be updated to match the new drain?
> 
> [ ... ]
> 
pw-bot: cr
