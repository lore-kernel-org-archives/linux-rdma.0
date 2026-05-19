Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDB73B9DBA;
	Tue, 19 May 2026 22:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779231360; cv=none; b=ZNbPYJ7H3dbQGXPD4fayIXOWGxSKald1E8Uopa5VSRqgFKEpy3zK4H3WyK+X2AnNo+BLpX/1z/0K2slxW6RsJP0mPY9Kc9exQfEjb2seMCxTZrYRuV7sKZl+1OdceXoi+q4tWX/cB4j4s4VDSqjvTNH2Te50zZPkrxaot5DWabc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779231360; c=relaxed/simple;
	bh=gkNqQtPBBfKzigAv9GnQJnaep0TyIcROeO0JZFWcTU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJFLwsMwsb0p+FrSHrymIclBaaxGDWsp5Uxo31qKuGnqvLwTY5Aur/D732g/x1I1QXk16iMzGx5Il6LLPHkptyNfL8G4yRUNCVziJsyOcBjn+bzR5UX8wfWlRORwpx97ot9TRbjbjHZIuJaQnkhu87cwk50EWpCnaRW49UzB77w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CasF50+6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CasF50+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3171F000E9;
	Tue, 19 May 2026 22:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779231358;
	bh=ltITWYTpdR14mpIrT86JiPdAjkQfUB2LfX1W0DEFewE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CasF50+6728DUZsAs2JUV8duNXgCIYKDBtZYvHhY5JxRbZQFbFkvs2A59IR8r463h
	 oqJ4AoSDTG62xzl2ywsSWiHZBPLr3uDkTNldZkb+XmPAo+GGhp/06V3hX1xEOHvst7
	 NyPzZjvkjWWeGNHwZ3/iWm9BuBNVWPl2lKblAeAco0zPke4dk87/5hSQ+vv83qqI1l
	 ZjERkEIMeP51xelD7t+bgcGQfGWiKak/v/foovQPTW0rBId9jtX0PkKMRbly2MN6Mr
	 by8qZM3BDUHFj4v3Pv1a8YxXHphv52/ENosLHUYSkF5ImDOuDgm+N9YGJfRmF9j0JQ
	 emmHWTrkImlXA==
From: Jakub Kicinski <kuba@kernel.org>
To: dipayanroy@linux.microsoft.com
Cc: Jakub Kicinski <kuba@kernel.org>,
	kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	leon@kernel.org,
	longli@microsoft.com,
	kotaranov@microsoft.com,
	horms@kernel.org,
	shradhagupta@linux.microsoft.com,
	ssengar@linux.microsoft.com,
	ernis@linux.microsoft.com,
	shirazsaleem@microsoft.com,
	linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	stephen@networkplumber.org,
	jacob.e.keller@intel.com,
	dipayanroy@microsoft.com,
	leitao@debian.org,
	kees@kernel.org,
	john.fastabend@gmail.com,
	hawk@kernel.org,
	bpf@vger.kernel.org,
	daniel@iogearbox.net,
	ast@kernel.org,
	sdf@fomichev.me,
	yury.norov@gmail.com
Subject: Re: [PATCH net 1/2] net: mana: Add NULL guards in teardown path to prevent panic on attach failure
Date: Tue, 19 May 2026 15:55:56 -0700
Message-ID: <20260519225556.3939204-1-kuba@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260518194654.735580-2-dipayanroy@linux.microsoft.com>
References: <20260518194654.735580-2-dipayanroy@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
net: mana: Add NULL guards in teardown path to prevent panic on attach failure
    
When queue allocation fails partway through, the error cleanup frees
and NULLs apc->tx_qp and apc->rxqs. The patch adds NULL guards for these
pointers in teardown paths such as mana_destroy_vport(), mana_fence_rqs(),
and mana_dealloc_queues() to prevent NULL pointer dereferences.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 9afc786b297a8..9e7e4bf526bf6 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
[ ... ]
> @@ -2858,13 +2861,16 @@ static void mana_destroy_vport(struct mana_port_context *apc)
>  	struct mana_rxq *rxq;
>  	u32 rxq_idx;
>  
> -	for (rxq_idx = 0; rxq_idx < apc->num_queues; rxq_idx++) {
> -		rxq = apc->rxqs[rxq_idx];
> -		if (!rxq)
> -			continue;
> +	if (apc->rxqs) {
>  
> -		mana_destroy_rxq(apc, rxq, true);
> -		apc->rxqs[rxq_idx] = NULL;
> +		for (rxq_idx = 0; rxq_idx < apc->num_queues; rxq_idx++) {
> +			rxq = apc->rxqs[rxq_idx];
> +			if (!rxq)
> +				continue;
> +
> +			mana_destroy_rxq(apc, rxq, true);
> +			apc->rxqs[rxq_idx] = NULL;
> +		}
>  	}

If the teardown path frees apc->rxqs and sets it to NULL on attach failure,
how does the interface recover if the user subsequently brings it back up?

When mana_open() is invoked, it directly calls mana_alloc_queues(). Inside
mana_alloc_queues() -> mana_add_rx_queues(), the code does:

    apc->rxqs[i] = rxq;

If apc->rxqs was left as NULL during the teardown, will this cause a NULL
pointer dereference on the next interface bring-up?

[ ... ]
> @@ -3287,33 +3294,38 @@ static int mana_dealloc_queues(struct net_device *ndev)
>  	 * number of queues.
>  	 */
>  
> -	for (i = 0; i < apc->num_queues; i++) {
> -		txq = &apc->tx_qp[i].txq;
> -		tsleep = 1000;
> -		while (atomic_read(&txq->pending_sends) > 0 &&
> -		       time_before(jiffies, timeout)) {
> -			usleep_range(tsleep, tsleep + 1000);
> -			tsleep <<= 1;
> -		}
> -		if (atomic_read(&txq->pending_sends)) {
> -			err = pcie_flr(to_pci_dev(gd->gdma_context->dev));
> -			if (err) {
> -				netdev_err(ndev, "flr failed %d with %d pkts pending in txq %u\n",
> -					   err, atomic_read(&txq->pending_sends),
> -					   txq->gdma_txq_id);
> +	if (apc->tx_qp) {

In the error path where queue creation fails partway through, will
mana_destroy_txq() be called?

If mana_destroy_txq() unconditionally iterates over all apc->num_queues:

    for (i = 0; i < apc->num_queues; i++) {
        ...
        mana_destroy_wq_obj(apc, GDMA_SQ, apc->tx_qp[i].tx_object);
        ...

Will it pass 0 or INVALID_MANA_HANDLE to mana_destroy_wq_obj() for queues
that were never fully initialized?

Does mana_destroy_wq_obj() send a MANA_DESTROY_WQ_OBJ command to the hardware
with these uninitialized handles, and could handle 0 corrupt the firmware
state?

> +		for (i = 0; i < apc->num_queues; i++) {
> +			txq = &apc->tx_qp[i].txq;
> +			tsleep = 1000;
> +			while (atomic_read(&txq->pending_sends) > 0 &&
> +			       time_before(jiffies, timeout)) {
> +				usleep_range(tsleep, tsleep + 1000);
> +				tsleep <<= 1;
> +			}
> +			if (atomic_read(&txq->pending_sends)) {
> +				err =
> +				    pcie_flr(to_pci_dev(gd->gdma_context->dev));

If pcie_flr() is triggered here, the PCI Function Level Reset wipes the
internal GDMA state.

Further down in this function, mana_disable_vport_rx(), mana_fence_rqs(),
and mana_destroy_vport() are called. Will these functions attempt to send
commands to the now-destroyed GDMA admin queue via mana_send_request() and
wait for completions?

Could this lead to cascading timeouts since the hardware was just reset and
cannot process admin commands?

> +				if (err) {
> +					netdev_err(ndev, "flr failed %d with %d pkts pending in txq %u\n",
> +						   err,
> +					    atomic_read(&txq->pending_sends),
> +					    txq->gdma_txq_id);
> +				}
> +				break;
>  			}
> -			break;
>  		}
-- 
pw-bot: cr
