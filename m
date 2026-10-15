Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6770D4FDA60;
	Thu, 15 Oct 2026 15:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792076798; cv=none; b=LngeJsd7YZPnon3PTRQ/pudVYOBk9WMNsdB+P3Vp+ln1IH9+1TYeyDPUE4KKnCoWtWGCyq0KY+anWvtWI6v36oaBjyq+RFTSyIE8QvA+DyV7GpvfqSO3BevZldipJ+XZgpvEWaNv5XimQb0HdNyovGzPctQBi8O6IyFASGKuv+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792076798; c=relaxed/simple;
	bh=Qy3XlC7H1RX5gRzf+kTtG4AQLQfNz26R9LxgVU51t6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uaUByNfHLqB+e5vE7LAIqw5uPZTIz1P6ldveZ0DU+wRI/hI8+9WubVPgdgVO7hqYyF9nQHee8x6Cjy+Yfz0+EZrUW1nAiIGINMneywBuR2+RAKISHZDT3A5RZN865L/dZOioNlxYPnwxRf4A3JWqQHoJY8nOL3KU2t0dqFHlPNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=YR9oiabI; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="YR9oiabI"
Received: by linux.microsoft.com (Postfix, from userid 1216)
	id E98F520B7168; Thu, 15 Oct 2026 08:06:26 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E98F520B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792076786;
	bh=t9yJuPZYOp7kfNBAAUzqrGwuy5HDp7aYaQvrx20rA4E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YR9oiabIeBdQcgeISYzdhDrRZePemIBoXr1xdjINFrY5SqwpGZ0xtKHkYJiWL4poy
	 zqfxhjvBUdDu70gaxQBdD0HQmB4kTDWe5oKV75MWjUWO2nwqTWETOqgla22xq2pFqF
	 Vjw2nZ+/qsJ5eTOI4MNvEV9TqyLxMsHEjyCSdLcM=
Date: Thu, 15 Oct 2026 11:06:26 -0400
From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [PATCH net-next v3] net: mana: add BQL support
Message-ID: <atDr8rbZuz97xCTo@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20261013214937.145312-1-hamzamahfooz@linux.microsoft.com>
 <sashiko-outbox-171939@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-171939@kernel.org>

On Wed, Oct 14, 2026 at 09:49:54PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] mana: unratelimited netdev_warn in __mana_start_xmit causes log spam under XDP load
> --
> 
> commit a6a9466a25f553494605c439f140071b9b0b7068
> Author: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
> 
> net: mana: add BQL support
> 
> MANA doesn't support byte queue limits, so each TX queue can hold 256
> WQEs by default, and up to 16384, of up to 64 KB TSO packets, before the
> qdisc layer sees any backpressure. This adds latency to all the flows
> sharing a queue, and defeats AQM qdiscs such as fq_codel. This patch
> adds BQL support by reporting the bytes queued and completed to BQL,
> except for XDP_TX and XDP_REDIRECT frames.
> 
> > diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
> > index 484f061bc75e4..7c55f8724441d 100644
> > --- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
> > +++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
> > @@ -21,7 +21,7 @@ void mana_xdp_tx(struct sk_buff *skb, struct net_device *ndev)
> >  	ndevtxq = netdev_get_tx_queue(ndev, txq_idx);
> >  	__netif_tx_lock(ndevtxq, smp_processor_id());
> >  
> > -	rc = mana_start_xmit(skb, ndev);
> > +	rc = __mana_start_xmit(skb, ndev, true);
> 
> [Severity: High]
> Does this allow unratelimited log spam under heavy XDP load?
> 
> XDP traffic directly calls the transmit path here without checking or
> honoring the stopped queue state. If the Send Queue fills up,
> __mana_start_xmit() unconditionally calls mana_gd_post_work_request(),
> which can return -ENOSPC.
> 
> When it fails, __mana_start_xmit() prints an unratelimited warning:
> 
> 	if (err) {
> 		(void)skb_dequeue_tail(&txq->pending_skbs);
> 		mana_unmap_skb(skb, apc);
> 		netdev_warn(ndev, "Failed to post TX OOB: %d\n", err);
> 		goto free_sgl_ptr;
> 	}
> 
> If XDP blasts packets into a full queue, could this print for every dropped
> packet and cause severe log spew?
> 

This issue predates this patch (it was actually introduced when XDP
support was first added with commit ed5356b53f07 ("net: mana: Add XDP
support")), so it should be fixed as a seperate patch directed at the
net tree.

> >  	__netif_tx_unlock(ndevtxq);
> 
> [ ... ]
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261013214937.145312-1-hamzamahfooz@linux.microsoft.com?part=1
