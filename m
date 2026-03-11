Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FA2429405;
	Wed, 11 Mar 2026 18:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773255144; cv=none; b=ophJk+jIYeuRqLham2WZrzr0XIddr0ixBccu+KNqZueaWVKVGrregLUyKAXT4z5OOl2JqUgu3uaY1QhFHV/aZ9sxYBO6R0AN6WlmF4sEz5Ng77BQLPJkARD71SUPoigbDPLE/yKi3xBsEcP8E8RPOFbezvowfEG2oNlxxRj0WGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773255144; c=relaxed/simple;
	bh=ULIUto0qRjCbTIuOnsOoG21FLhirAyCxdGtxAeqVlYU=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SELQn4SoZgwtO5TU0tTGFj8QtCR/In7CwM+Diys87nAG0wpz9T4gDymKfD3ODpvOLu5llLeNH2lolMezUWeGvCeU15l0IrkGOyE+DrJybCJixS3uiFMogQK8SJQBWdgQw2if1NbU5ksE0Djc35TVI71WHTMOWKFy2w6t+hJMj5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=JX/uUg2H; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="JX/uUg2H"
Received: by linux.microsoft.com (Postfix, from userid 1204)
	id 7136C20B710C; Wed, 11 Mar 2026 11:52:23 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7136C20B710C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1773255143;
	bh=D8p+7eCyWUtiW18+m8UO3XA9k0HZTG3gUHVfVFyNdY8=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=JX/uUg2HzIF+FIhywqxsEgm8lL354Du+9hPI5bJGo1K4nd66BS05TzL0AC2/R7OTx
	 ppO88IwatIE9/ElDlJeQNkgH+ptkiBsFct6KMeOIfK3XaGiLKcyEQBHzwnb6+94PhT
	 B8YiYk/nVBkFrJnF/gMQdCUVX9dlQaxCdQ27AmoY=
Date: Wed, 11 Mar 2026 11:52:23 -0700
From: Dipayaan Roy <dipayanroy@linux.microsoft.com>
To: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
	decui@microsoft.com, andrew+netdev@lunn.ch, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	leon@kernel.org, longli@microsoft.com, kotaranov@microsoft.com,
	horms@kernel.org, shradhagupta@linux.microsoft.com,
	ssengar@linux.microsoft.com, ernis@linux.microsoft.com,
	shirazsaleem@microsoft.com, linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH net] net: mana: Fix use-after-free in
 mana_hwc_destroy_channel() by re-ordering teardown
Message-ID: <abG555Qgh/1zX+Kk@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <aa8PshvNRfuRYO/p@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa8PshvNRfuRYO/p@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>

On Mon, Mar 09, 2026 at 11:21:38AM -0700, Dipayaan Roy wrote:
> A potential race condition exists in mana_hwc_destroy_channel() where
> hwc->caller_ctx is freed before the HWC's Completion Queue (CQ) and
> Event Queue (EQ) are destroyed. This allows an in-flight CQ interrupt
> handler to dereference freed memory, leading to a use-after-free or
> NULL pointer dereference in mana_hwc_handle_resp().
> 
> mana_smc_teardown_hwc() signals the hardware to stop but does not
> synchronize against IRQ handlers already executing on other CPUs. The
> IRQ synchronization only happens in mana_hwc_destroy_cq() via
> mana_gd_destroy_eq() -> mana_gd_deregister_irq(). Since this runs
> after kfree(hwc->caller_ctx), a concurrent mana_hwc_rx_event_handler()
> can dereference freed caller_ctx (and rxq->msg_buf) in
> mana_hwc_handle_resp().
> 
> Fix this by reordering teardown to reverse-of-creation order: destroy
> the TX/RX work queues and CQ/EQ before freeing hwc->caller_ctx. This
> ensures all in-flight interrupt handlers complete before the memory they
> access is freed.
> 
> Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
> ---
>  drivers/net/ethernet/microsoft/mana/hw_channel.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index 91975bdb5686..dbbde0fa57e7 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> @@ -814,9 +814,6 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
>  		gc->max_num_cqs = 0;
>  	}
>  
> -	kfree(hwc->caller_ctx);
> -	hwc->caller_ctx = NULL;
> -
>  	if (hwc->txq)
>  		mana_hwc_destroy_wq(hwc, hwc->txq);
>  
> @@ -826,6 +823,9 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
>  	if (hwc->cq)
>  		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
>  
> +	kfree(hwc->caller_ctx);
> +	hwc->caller_ctx = NULL;
> +
>  	mana_gd_free_res_map(&hwc->inflight_msg_res);
>  
>  	hwc->num_inflight_msg = 0;
> -- 
> 2.43.0
>
Hi,
I am sending a v2 as I missed adding Stephen.

Thank you.  
