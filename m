Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795083773;
	b=X/9hfXxTlck0u+E2a4DXKzG271MfCRaoQcGvXARk9SrOe/FBExTGarF8kJMT7QSI0yjq
	 Jg233C71aRMRN51dIkvcQFe5/wd2i6QHDF9P1K7UJ6wDiFRDeCVj4sgVMil1af3SR4wpJ
	 v3xbXQWaSbbg865wGkwxsAxJ/lYer1R01UiaNBNdOyMRy/s5u2IneN/3WIUYr5WshQCZb
	 epLZu5Q0MouOWG8wpEYnM8D0bkwaHoosUifUmvbMdzmVqYn1/d8wHzU5XgpiUfATybYzR
	 48XNNIk2uHqE8QhuqaFqFpGFn460pq42wMIgBdZkl7p4a/Zc7gyLbxvwJT1SB2XRITg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795083773;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:References:Content-Language:Cc:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=QtuF4irRcq+f4Cep2l8UlPHbVe56bOd4nkkHWmuNWxI=;
	b=rjf3O6y1AmGC3zGmy3NV5lKNfhY/tcMcuRrSH+cGItLxcK7urzofO6KFVDBvw2YSot4T
	 ycOpbwoR/YnoulVzGRXb5fIVhFCFfqtxh0JYRfZbLcxeZjTM+Vd6FVahbNsDeBx4kfXip
	 +r6RQ3GZMYiDVoqLv23W6D5kFIkSzhUXCV3uUtzgodkPXo3P5fIc8xSWbNhnfDJZvtAwj
	 gwPjpH+5qUNzAf/Fst2MuHxwzOBwviDoWtP3adx90dBgKscdPGenCluFXY91xIVxPNfOa
	 AZUn3YK55+RcMXPMQxYZjDdjNxwQUsdCPBJ2a9N+IhNy/oHK7bXUgZ7KB3A3MVQ0U6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=kTLgKIyq;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCB7660A2608;
	Thu, 19 Nov 2026 10:22:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CCB7660A2608
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=kTLgKIyq
Received: from [192.168.1.103] (unknown [106.222.233.21])
	by linux.microsoft.com (Postfix) with ESMTPSA id A260820B7169;
	Thu, 19 Nov 2026 02:22:43 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A260820B7169
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1795083770;
	bh=QtuF4irRcq+f4Cep2l8UlPHbVe56bOd4nkkHWmuNWxI=;
	h=Date:Subject:To:References:Cc:From:In-Reply-To:From;
	b=kTLgKIyqRkmxzyL1xZeGxjgldq4YAec44/jvFoWRq/Dcm8v9JEBy+HtIeiPD4cjC+
	 zYWMGyH5WPQAad2JqOl1X5Zy3Am+dv00loQF07bH8JES7K5fJseUGUMbboVLZXK9tt
	 IklFl2DBHz4898tohz/tDvoa6SybzFHhm/xZwJrA=
Message-ID: <cc705453-0794-494f-adb9-b6fb71254ba7@linux.microsoft.com>
Date: Thu, 19 Nov 2026 15:52:40 +0530
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
Subject: Re: [PATCH net] net: mana: Set 1 usec / 1 comp as default and minimum
 interrupt moderation
To: linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Wei Hu <weh@microsoft.com>, Konstantin Taranov <kotaranov@microsoft.com>,
 Simon Horman <horms@kernel.org>,
 Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
 Aditya Garg <gargaditya@linux.microsoft.com>,
 Manish Awasthi <mawasthi@linux.microsoft.com>,
 Breno Leitao <leitao@debian.org>, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org
References: <20261113204427.1922848-1-haiyangz@linux.microsoft.com>
Content-Language: en-US
Cc: paulros@microsoft.com, stable@vger.kernel.org
From: Sahil Chandna <sahilchandna@linux.microsoft.com>
In-Reply-To: <20261113204427.1922848-1-haiyangz@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 14/11/2026 02:14, Haiyang Zhang wrote:
> From: Haiyang Zhang <haiyangz@microsoft.com>
> 
> The existing code sets interrupt moderation defaults to 0 usec and 0
> completions, which may cause CQ starvation of our NIC HW, and TX time
> out error like:
> mana 7870:00:00.0 ens1: NETDEV WATCHDOG: CPU: 14: transmit queue 4 timed out 63434 ms
> 
> To fix, change the default and minimal rx/tx usecs and frames to 1.
> When the HW supports interrupt moderation, reject ethtool rx/tx usecs
> and frames below 1.
> Also clamp the values written by mana_gd_ring_dim() to [1, max], so
> no caller, including the DIM work, programs a zero value.
> On the HW without interrupt moderation support, do not request CQ
> moderation, the usecs and frames stay at 0, and cannot be modified by
> ethtool.
> The PF capability is queried again when the device resumes from a
> reset or suspend, so re-initialize these settings before re-attaching
> the vPorts.
> 
> Advertise this change to the PF with the new driver capability flag
> GDMA_DRV_CAP_FLAG_1_SET_MIN_INTR_MOD_VALUE.
> 
> Cc: stable@vger.kernel.org
> Fixes: 433f482add31 ("net: mana: Add Interrupt Moderation support")
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>   .../net/ethernet/microsoft/mana/gdma_main.c   |  5 ++
>   drivers/net/ethernet/microsoft/mana/mana_en.c | 76 +++++++++++++------
>   .../ethernet/microsoft/mana/mana_ethtool.c    | 26 +++++--
>   include/net/mana/gdma.h                       |  6 +-
>   include/net/mana/mana.h                       |  9 ++-
>   5 files changed, 88 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> index ab942d5bfe05..10be69e97ceb 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> @@ -646,6 +646,11 @@ void mana_gd_ring_dim(struct gdma_queue *cq, u32 mod_usec, bool mod_usec_vld,
>   	struct gdma_context *gc = cq->gdma_dev->gdma_context;
>   	u32 dim_val;
>   
> +	mod_usec = clamp_t(u32, mod_usec, MANA_INTR_MODR_USEC_MIN,
> +			   MANA_INTR_MODR_USEC_MAX);
> +	mod_comps = clamp_t(u32, mod_comps, MANA_INTR_MODR_COMP_MIN,
> +			    MANA_INTR_MODR_COMP_MAX);
> +
>   	/* Convert the DIM values to doorbell parameters */
>   	dim_val = FIELD_PREP(MANA_INTR_MODR_USEC_MAX, mod_usec) |
>   		  FIELD_PREP(MANA_INTR_MODR_COMP_MASK, mod_comps);
> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 7e9223143fc7..95bf153c3e1a 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -2515,9 +2515,6 @@ static void mana_rx_dim_work(struct work_struct *work)
>   	cur_moder = net_dim_get_rx_moderation(dim->mode, dim->profile_ix);
>   	cq = container_of(dim, struct mana_cq, dim);
>   
> -	cur_moder.usec = min_t(u16, cur_moder.usec, MANA_INTR_MODR_USEC_MAX);
> -	cur_moder.pkts = min_t(u16, cur_moder.pkts, MANA_INTR_MODR_COMP_MAX);
> -
>   	mana_gd_ring_dim(cq->gdma_cq, cur_moder.usec, true,
>   			 cur_moder.pkts, true);
>   
> @@ -2533,9 +2530,6 @@ static void mana_tx_dim_work(struct work_struct *work)
>   	cur_moder = net_dim_get_tx_moderation(dim->mode, dim->profile_ix);
>   	cq = container_of(dim, struct mana_cq, dim);
>   
> -	cur_moder.usec = min_t(u16, cur_moder.usec, MANA_INTR_MODR_USEC_MAX);
> -	cur_moder.pkts = min_t(u16, cur_moder.pkts, MANA_INTR_MODR_COMP_MAX);
> -
>   	mana_gd_ring_dim(cq->gdma_cq, cur_moder.usec, true,
>   			 cur_moder.pkts, true);
>   
> @@ -2871,10 +2865,15 @@ static int mana_create_txq(struct mana_port_context *apc,
>   		cq_spec.modr_ctx_id = 0;
>   		cq_spec.attached_eq = cq->gdma_cq->cq.parent->id;
>   
> -		/* DIM setting can be changed at runtime */
> -		cq_spec.req_cq_moderation = true;
> -		cq_spec.cq_moderation_usec = apc->intr_modr_tx_usec;
> -		cq_spec.cq_moderation_comp = apc->intr_modr_tx_comp;
> +		/* Request CQ moderation only if HW supports it.
> +		 * DIM setting can be changed at runtime.
> +		 */
> +		if (gc->pf_cap_flags1 &
> +		    GDMA_PF_CAP_FLAG_1_DYN_INTERRUPT_MODERATION) {
> +			cq_spec.req_cq_moderation = true;
> +			cq_spec.cq_moderation_usec = apc->intr_modr_tx_usec;
> +			cq_spec.cq_moderation_comp = apc->intr_modr_tx_comp;
> +		}
>   
>   		err = mana_create_wq_obj(apc, apc->port_handle, GDMA_SQ,
>   					 &wq_spec, &cq_spec,
> @@ -3206,10 +3205,14 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
>   	cq_spec.modr_ctx_id = 0;
>   	cq_spec.attached_eq = cq->gdma_cq->cq.parent->id;
>   
> -	/* DIM setting can be changed at runtime */
> -	cq_spec.req_cq_moderation = true;
> -	cq_spec.cq_moderation_usec = apc->intr_modr_rx_usec;
> -	cq_spec.cq_moderation_comp = apc->intr_modr_rx_comp;
> +	/* Request CQ moderation only if HW supports it.
> +	 * DIM setting can be changed at runtime.
> +	 */
> +	if (gc->pf_cap_flags1 & GDMA_PF_CAP_FLAG_1_DYN_INTERRUPT_MODERATION) {
> +		cq_spec.req_cq_moderation = true;
> +		cq_spec.cq_moderation_usec = apc->intr_modr_rx_usec;
> +		cq_spec.cq_moderation_comp = apc->intr_modr_rx_comp;
> +	}
>   
>   	err = mana_create_wq_obj(apc, apc->port_handle, GDMA_RQ,
>   				 &wq_spec, &cq_spec, &rxq->rxobj);
> @@ -3894,6 +3897,40 @@ int mana_detach(struct net_device *ndev, bool from_close)
>   	return 0;
>   }
>   
> +/* Match the interrupt moderation settings to the PF capability, which is
> + * queried again when the device resumes from a reset or suspend. Must be
> + * called before the queues are created.
> + */
> +static void mana_init_intr_modr(struct mana_port_context *apc)
> +{
> +	struct gdma_context *gc = apc->ac->gdma_dev->gdma_context;
> +
> +	if (!(gc->pf_cap_flags1 &
> +	      GDMA_PF_CAP_FLAG_1_DYN_INTERRUPT_MODERATION)) {
> +		apc->intr_modr_rx_usec = 0;
> +		apc->intr_modr_rx_comp = 0;
> +		apc->intr_modr_tx_usec = 0;
> +		apc->intr_modr_tx_comp = 0;
> +		apc->rx_dim_enabled = false;
> +		apc->tx_dim_enabled = false;
> +		return;
> +	}
> +
> +	/* Keep the current settings, unless they were never initialized
> +	 * because the port was probed without the capability.
> +	 */
> +	if (apc->intr_modr_rx_usec && apc->intr_modr_rx_comp &&
> +	    apc->intr_modr_tx_usec && apc->intr_modr_tx_comp)
> +		return;
> +
> +	apc->intr_modr_rx_usec = MANA_INTR_MODR_USEC_DEF;
> +	apc->intr_modr_rx_comp = MANA_INTR_MODR_COMP_DEF;
> +	apc->intr_modr_tx_usec = MANA_INTR_MODR_USEC_DEF;
> +	apc->intr_modr_tx_comp = MANA_INTR_MODR_COMP_DEF;
> +	apc->rx_dim_enabled = MANA_ADAPTIVE_RX_DEF;
> +	apc->tx_dim_enabled = MANA_ADAPTIVE_TX_DEF;
> +}
> +
>   static int mana_probe_port(struct mana_context *ac, int port_idx,
>   			   struct net_device **ndev_storage)
>   {
> @@ -3924,15 +3961,7 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
>   	apc->cqe_coalescing_enable = 0;
>   	apc->cqe8_coalescing_enable = 0;
>   
> -	/* Initialize interrupt moderation settings if supported by HW */
> -	if (gc->pf_cap_flags1 & GDMA_PF_CAP_FLAG_1_DYN_INTERRUPT_MODERATION) {
> -		apc->intr_modr_rx_usec = MANA_INTR_MODR_USEC_DEF;
> -		apc->intr_modr_rx_comp = MANA_INTR_MODR_COMP_DEF;
> -		apc->intr_modr_tx_usec = MANA_INTR_MODR_USEC_DEF;
> -		apc->intr_modr_tx_comp = MANA_INTR_MODR_COMP_DEF;
> -		apc->rx_dim_enabled = MANA_ADAPTIVE_RX_DEF;
> -		apc->tx_dim_enabled = MANA_ADAPTIVE_TX_DEF;
> -	}
> +	mana_init_intr_modr(apc);
>   
>   	mutex_init(&apc->vport_mutex);
>   	apc->vport_use_count = 0;
> @@ -4256,6 +4285,7 @@ int mana_probe(struct gdma_dev *gd, bool resuming)
>   			enable_work(&apc->queue_reset_work);
>   			netdev_lock(ac->ports[i]);
>   			apc->link_cfg_error = 1;
> +			mana_init_intr_modr(apc);
>   			netdev_unlock(ac->ports[i]);
>   			err = mana_attach(ac->ports[i]);
>   			rtnl_unlock();
> diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
> index 4068e08acb16..96aabf7a8f08 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
> @@ -505,9 +505,12 @@ static int mana_set_coalesce(struct net_device *ndev,
>   	bool dim_changed = false;
>   	struct gdma_context *gc;
>   	u32 max_cqe_frames;
> +	bool modr_sup;
>   	int err;
>   
>   	gc = apc->ac->gdma_dev->gdma_context;
> +	modr_sup = gc->pf_cap_flags1 &
> +		   GDMA_PF_CAP_FLAG_1_DYN_INTERRUPT_MODERATION;
>   	max_cqe_frames = gc->cqe8_coalescing_sup ? MANA_CQE_COAL_PKTS_8 :
>   						   MANA_RXCOMP_OOB_NUM_PPI;
>   
> @@ -517,7 +520,7 @@ static int mana_set_coalesce(struct net_device *ndev,
>   	if ((ec->use_adaptive_rx_coalesce || ec->use_adaptive_tx_coalesce ||
>   	     ec->rx_coalesce_usecs || ec->tx_coalesce_usecs ||
>   	     ec->rx_max_coalesced_frames || ec->tx_max_coalesced_frames) &&
> -	    !(gc->pf_cap_flags1 & GDMA_PF_CAP_FLAG_1_DYN_INTERRUPT_MODERATION)) {
> +	    !modr_sup) {
>   		NL_SET_ERR_MSG(extack,
>   			       "Interrupt Moderation is not supported by HW");
>   		return -EOPNOTSUPP;
> @@ -534,18 +537,27 @@ static int mana_set_coalesce(struct net_device *ndev,
>   		return -EINVAL;
>   	}
>   
> -	if (ec->rx_coalesce_usecs > MANA_INTR_MODR_USEC_MAX ||
> -	    ec->tx_coalesce_usecs > MANA_INTR_MODR_USEC_MAX) {
> +	/* Without the HW capability, only zero values pass the check above */
> +	if (modr_sup &&
> +	    (ec->rx_coalesce_usecs < MANA_INTR_MODR_USEC_MIN ||
> +	     ec->tx_coalesce_usecs < MANA_INTR_MODR_USEC_MIN ||
> +	     ec->rx_coalesce_usecs > MANA_INTR_MODR_USEC_MAX ||
> +	     ec->tx_coalesce_usecs > MANA_INTR_MODR_USEC_MAX)) {
>   		NL_SET_ERR_MSG_FMT(extack,
> -				   "coalesce usecs must be <= %lu",
> +				   "coalesce usecs must be between %d and %lu",
> +				   MANA_INTR_MODR_USEC_MIN,
>   				   MANA_INTR_MODR_USEC_MAX);
>   		return -EINVAL;
>   	}
>   
> -	if (ec->rx_max_coalesced_frames > MANA_INTR_MODR_COMP_MAX ||
> -	    ec->tx_max_coalesced_frames > MANA_INTR_MODR_COMP_MAX) {
> +	if (modr_sup &&
> +	    (ec->rx_max_coalesced_frames < MANA_INTR_MODR_COMP_MIN ||
> +	     ec->tx_max_coalesced_frames < MANA_INTR_MODR_COMP_MIN ||
> +	     ec->rx_max_coalesced_frames > MANA_INTR_MODR_COMP_MAX ||
> +	     ec->tx_max_coalesced_frames > MANA_INTR_MODR_COMP_MAX)) {
>   		NL_SET_ERR_MSG_FMT(extack,
> -				   "coalesce frames must be <= %lu",
> +				   "coalesce frames must be between %d and %lu",
> +				   MANA_INTR_MODR_COMP_MIN,
>   				   MANA_INTR_MODR_COMP_MAX);
>   		return -EINVAL;
>   	}
> diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
> index 29d152e18596..6191ddddc27f 100644
> --- a/include/net/mana/gdma.h
> +++ b/include/net/mana/gdma.h
> @@ -776,6 +776,9 @@ enum {
>   /* Driver supports handling throttled EQEs */
>   #define GDMA_DRV_CAP_FLAG_1_THROTTLED_EVENT_QUEUE BIT_ULL(32)
>   
> +/* Enforce min 1 usec, 1 frames for Interrupt Moderation */
> +#define GDMA_DRV_CAP_FLAG_1_SET_MIN_INTR_MOD_VALUE BIT_ULL(33)
> +
>   /* Capabilities in the PCI-only group below rely on dynamic MSI-X allocation
>    * and on the servicing and reset paths reached through
>    * mana_schedule_serv_work(). Transports that provide neither leave
> @@ -801,7 +804,8 @@ enum {
>   	 GDMA_DRV_CAP_FLAG_1_EQ_MSI_UNSHARE_MULTI_VPORT | \
>   	 GDMA_DRV_CAP_FLAG_1_DYN_INTERRUPT_MODERATION | \
>   	 GDMA_DRV_CAP_FLAG_1_NON_CONTIGUOUS_BUFFERS | \
> -	 GDMA_DRV_CAP_FLAG_1_THROTTLED_EVENT_QUEUE)
> +	 GDMA_DRV_CAP_FLAG_1_THROTTLED_EVENT_QUEUE | \
> +	 GDMA_DRV_CAP_FLAG_1_SET_MIN_INTR_MOD_VALUE)
>   
>   #define GDMA_DRV_CAP_FLAGS2 0
>   
> diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
> index 218d540bc994..84afc4199e87 100644
> --- a/include/net/mana/mana.h
> +++ b/include/net/mana/mana.h
> @@ -74,9 +74,12 @@ enum mana_priv_flag_bits {
>   /* 8-pkt mode packs up to 2 packets per PPI entry */
>   #define MANA_CQE_COAL_PKTS_8 8
>   
> -/* Default/max interrupt moderation settings */
> -#define MANA_INTR_MODR_USEC_DEF 0
> -#define MANA_INTR_MODR_COMP_DEF 0
> +/* Default/min interrupt moderation settings */
> +#define MANA_INTR_MODR_USEC_DEF 1
> +#define MANA_INTR_MODR_COMP_DEF 1
> +
> +#define MANA_INTR_MODR_USEC_MIN 1
> +#define MANA_INTR_MODR_COMP_MIN 1
>   
>   #define MANA_ADAPTIVE_RX_DEF true
>   #define MANA_ADAPTIVE_TX_DEF true
LGTM, Reviewed-by: Sahil Chandna <sahilchandna@linux.microsoft.com>
