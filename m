Received: from mail-pj2-f1.google.com (mail-pj2-f1.google.com [74.125.227.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C9647FB01
	for <linux-rdma@vger.kernel.org>; Tue, 18 Aug 2026 17:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787072637; cv=none; b=IYayk6ixyRvkVsUOtmlyaU/TUfjIP0jHtjUgfFhjRpb09sbd43VCcEiSnD3Il286BKeTILM5mh4aKqeA6m3lED9MpoHaQF6wIWmNwxxVS4ZC14UBd84sfvrLAs+UEkHYsIbJ9AkDGqcYh4iJAhTCWxLqK4RvexV5o6B925Cl3iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787072637; c=relaxed/simple;
	bh=+NtjBczxEraDYPUktGMOfDvSdqIm87V/zl/KlbsnxXQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rBcEbcNZeXKUeJLhnnAp49Y5wHsWMTWz4pDXEfgeVWMgg53URCir3zIB6FyAC6AH5K+skpXbmvy24nXyp5eROas6r1GkZW2NteFn2iR30GrzekodfOrMaKTzW6LEJliNpqGmp5/vUuuiyvYw8Jc8mEFwHWq4fUXCSCOIxzcYQeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lYn8sxjX; arc=none smtp.client-ip=74.125.227.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lYn8sxjX"
Received: by mail-pj2-f1.google.com with SMTP id d9443c01a7336-2cb3f5bb19aso240435ad.1
        for <linux-rdma@vger.kernel.org>; Tue, 18 Aug 2026 10:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787072634; x=1787677434; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Q80BWnEZK8DYTRP4qPFCamRkQ8PTkFuflTPG4q2POi4=;
        b=lYn8sxjX9036r6auB1CDBYvkLJI43+KtySxmbeyJXpZCY5JxsLpBPd1CsfuoiuZRUn
         D0ZtV42OYnydKT0Tll1J3KLGobtdqGq8SOCoakEeUYrLhmF8BC9UmnPclmLU6NQzjDEo
         muSiTR/cZWcRywtKs6wH1e7ar5aw+AwzYRYjlOrKoShCIfCtNdeJyUgwc5qLYeiMkz6E
         7FeaPyi2UBgk1ls07wIKpa3PgCrgf/hVTtD/dQvJ8ix6gyrK1l20AxJsA3V54WN18kUU
         xz4QFxZOtI1SM56O2y/ncLryDBOiaQbBmdnBwEZV7v5D11o1B7gzrIveU2iJw1BpOIG5
         lOsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787072634; x=1787677434;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q80BWnEZK8DYTRP4qPFCamRkQ8PTkFuflTPG4q2POi4=;
        b=K1Ay9ADd8ZSBjIVnKBsbzfEEecsmhJtT5gfE7g/PuW8RV6mGpE0K092GI5GkX4oAEU
         PKb/y3p/vJ4CNXNTLqGPGrAm9JPAB9c7DROM/YG1Gs0Nmro83SsTFN0vYyUJIiENYVi6
         HmbIZ0FsHL4NJBEOXiRHi8wCTfUKT5MJ78usyCZumQ7J8ftj3/dP+pn+T7rlqKRV4a22
         CafAeTxpqs+TKMJ29wFt+K4e0deb2rmpq2FKKYxpQt+Fw/B7cV8ySJRghsiN4KH3EZ/W
         4FyJfPqXBoAtpI1Wvm1T4by30MHopWsc3lDKEdrHsqzL7bbKYRdgqqFNhOp2KPPnQjjD
         Aj+w==
X-Forwarded-Encrypted: i=1; AHgh+RpeoZL9Id5X4G/YBJWKINSXk//NkSz3iu7Grvs1vsGYW86k106PXo2aYXACoX2X5PqmG38x45QSi7WJ@vger.kernel.org
X-Gm-Message-State: AOJu0YyxRrvtzsljvk3xzedNLkSE7dj91jsngSWdV2qQ4owuhyU4DYPa
	7HViWCUg/QFYVAvkon5h9nhftf0XNhXYBn5t8YvXLyyrS/wN3Na/7e0j
X-Gm-Gg: AR+sD1398ZEKuxux9PAVNofDQ+COU2eyY7So9phq7PGx/Me/f7cxURO9SX7fUieKgjL
	EHKwmdlcvO6i72SYFS0dLvIeUkhKjqRDGx5nejazQvgkobWZCof/nHLwmWbKxvHZSRcj2Jmg3GM
	GADQx/J6s0d6qwu1p3fuSfePJM0NMJUKx42SVLyZ6aI6Ov2bu74Dbg98T9NPv3f4L1ajjMezKt7
	AqKIwyTTlhTUTDIyuqnTewXm8DoCOnGohYzqzK2QxTKCVSWfgLx3oJEs/pzekRaH+jjfx4uafyr
	i+dw26JFM1LhpzEf3vxUw9CBsxEWow0SpyRBvCZs6tb4dutYMkwr9dPZzFj3KehptBq/hsU5L7H
	ZSIwLJYIVV4uRzSJ96PLI3ALvU9KGp0UV0cqF1C1PLNIRrwi2zIrABPySvvB2EXxO+t8uJkfAw/
	+8OTywIw04rEfycMzGuNCTPYiXAVICU9jlfP+7Yc01Nq01C3LcXJZ2
X-Received: by 2002:a17:902:d4cf:b0:2ca:660:b1d with SMTP id d9443c01a7336-2d3b0d5eccfmr373846305ad.11.1787072634166;
        Tue, 18 Aug 2026 10:03:54 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:7::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d5bb499d7bsm20728245ad.3.2026.08.18.10.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 10:03:53 -0700 (PDT)
Date: Tue, 18 Aug 2026 10:03:16 -0700
From: Stanislav Fomichev <sdf.kernel@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com, 
	pabeni@redhat.com, anthony.l.nguyen@intel.com, przemyslaw.kitszel@intel.com, 
	andrew+netdev@lunn.ch, saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com, 
	maxime.chevallier@bootlin.com, mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com, 
	aleksander.lobakin@intel.com, horms@kernel.org, magnus.karlsson@intel.com, 
	maciej.fijalkowski@intel.com, sdf@fomichev.me, ast@kernel.org, daniel@iogearbox.net, 
	hawk@kernel.org, john.fastabend@gmail.com, witu@nvidia.com, martin.lau@kernel.org, 
	yoong.siang.song@intel.com, rohan.g.thomas@intel.com, intel-wired-lan@lists.osuosl.org, 
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
	linux-stm32@st-md-mailman.stormreply.com, linux-arm-kernel@lists.infradead.org, bpf@vger.kernel.org, 
	leon@kernel.org
Subject: Re: [Intel-wired-lan] [PATCH net v2 3/3] net: stmmac: skip
 queueMaxSDU check for AF_XDP
Message-ID: <aoSOau3NuHTLLxnL@devvm7509.cco0.facebook.com>
References: <20260813190800.222527-4-sdf@fomichev.me>
 <20260818162442.3980697-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260818162442.3980697-1-kuba@kernel.org>

On 08/18, Jakub Kicinski wrote:
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> ---
> net: stmmac: skip queueMaxSDU check for AF_XDP
> 
> This drops the per-queue max SDU length check from the stmmac AF_XDP
> zero-copy transmit path, on the grounds that xsk_tx_peek_desc() has
> already reserved a completion ring entry and the old "continue" skipped
> both queuing and completion. The change is tagged for stable via a Fixes:
> tag on c5c3e1bfc9e0.
> 
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > index 62de03e65a90c..4a82f4351303a 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > @@ -2710,13 +2710,6 @@ static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
> >  		if (!xsk_tx_peek_desc(pool, &xdp_desc))
> >  			break;
> >  
> > -		if (priv->est && priv->est->enable &&
> > -		    priv->est->max_sdu[queue] &&
> > -		    xdp_desc.len > priv->est->max_sdu[queue]) {
> > -			priv->xstats.max_sdu_txq_drop[queue]++;
> > -			continue;
> > -		}
> > -
> 
> [Severity: Medium]
> The completion ring imbalance described in the commit message looks real:
> xsk_tx_peek_desc() reserves the cq slot with xskq_prod_reserve_addr() and
> only xsk_tx_completed() submits it, so the old "continue" left the cq
> producer permanently offset.
> 
> Was completing the reserved descriptor considered instead of removing the
> check, i.e. keeping the length test and doing:
> 
> 	if (priv->est && priv->est->enable &&
> 	    priv->est->max_sdu[queue] &&
> 	    xdp_desc.len > priv->est->max_sdu[queue]) {
> 		priv->xstats.max_sdu_txq_drop[queue]++;
> 		xsk_tx_completed(pool, 1);
> 		continue;
> 	}
> 
> That would fix the ring accounting without dropping the enforcement.

Don't think this suggestion would work. xsk_tx_completed(1) will complete
the first queued entry, no the current rejected one (completions are in order).

If it's not convincing, I can repost only patches 1 and 2. Or if it sounds
reasonable, can try to explain that part in the description.

> On stmmac, queueMaxSDU has no hardware table. priv->est->max_sdu[] is
> written only by tc_taprio_map_maxsdu_txq() in stmmac_tc.c:
> 
> 		for (j = offset; j < offset + count; j++)
> 			priv->est->max_sdu[j] = qopt->max_sdu[i] + ETH_HLEN - ETH_TLEN;
> 
> and read only by the length checks in stmmac_main.c. With this hunk gone,
> does an AF_XDP zero-copy socket now transmit frames above the configured
> per-queue limit while tc_query_caps() still reports:
> 
> 		caps->gate_mask_per_txq = true;
> 		caps->supports_queue_max_sdu = true;
> 
> That capability is what taprio uses to accept a queueMaxSDU configuration
> in the first place, and sch_taprio comments in
> taprio_skb_exceeds_queue_max_sdu() that "Devices with full offload are
> expected to honor this in hardware".
> 
> The "bypasses the qdisc" rationale also applies to stmmac_xdp_xmit_xdpf(),
> which serves XDP_TX and ndo_xdp_xmit and does not traverse the qdisc
> either, yet still enforces the same limit:
> 
> 	if (priv->est && priv->est->enable &&
> 	    priv->est->max_sdu[queue] &&
> 	    xdpf->len > priv->est->max_sdu[queue]) {
> 		priv->xstats.max_sdu_txq_drop[queue]++;
> 		return STMMAC_XDP_CONSUMED;
> 	}
> 
> Should that check be removed as well so the XDP paths agree? The cited igc
> precedent checks only in igc_xmit_frame_ring() and in neither of its XDP
> paths, so matching igc would mean touching stmmac_xdp_xmit_xdpf() too.

xdp_tx does not expose xsk-like descriptor rings, so it doesn't apply.
