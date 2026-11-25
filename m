Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795615717;
	b=zQqOy0ZgvWgSBsZFeehIa4YUx9qxwiAI0QuBFAFuWVDt7A81Bdi29GlaPjhAuaakSplG
	 wp/CeR3uJytc5NizTDtfGpQAGJ7WbOl1wEIFvdAAn98VOC70UPZhSUOLJcC2jBcA9ijx4
	 tWofHB1/RsEVMRJ8CuAdp1F+HI1/g4eR3LFmsAS0VZJFyLwVJIo0EsVyV45yTrDh9uGkl
	 VeQ5o/BlgpfHJhytvIhNs6nkFg3izHj9QLQVtYSxToh49ccen+SlKncuXW7BBprdeqh6p
	 lz+IbYVlIahQsE1wAXmixC6Aw/HVCWeViTLUQxoq3Y+wUsLxTyZRQHgFvjh/8sUsvIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795615717;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=I39b7JFx8pi0MXHhfr5fsGnfMyGgC5bhz7IYYZepHQo=;
	b=DPSGaTA4YUjk4F/9Hg1XCyg4XLlH+jhY4wWobCwWt22DL8zcrw36tIOwgnh0SH9zd2/S
	 OFERvsrC5yJyhmS9PdGjb4vfvpooB3L0Q5awMj5DYTLvA4IKY0cMYM9CNoDo1xheajOrN
	 EsG3MbHrkWaXY3Dw+NxZFZsMlFZ+iKU6/O28K34MJbuXeRKhqpgJMN/KN+J5GAgCkdGdS
	 VyegSExTT278gpX+hFkTuTSZ7dMLKMqqUd70taOzmV/aPsQ7ygsTHjzK27h1JVGkvT36z
	 QOrInzdICl7pggtS3b/kDx4ng6eOgwmC0BSbMB3tnZia69ZUHlt7kv2AP8oabrFrITQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L7nbBc1+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0889860A261C;
	Wed, 25 Nov 2026 14:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L7nbBc1+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6696E1F000C6;
	Wed, 25 Nov 2026 14:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795615716;
	bh=I39b7JFx8pi0MXHhfr5fsGnfMyGgC5bhz7IYYZepHQo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=L7nbBc1+MAm41DQ1m/YjFSp+YY4uo39FRpf0G4FOlrzFjMb183nE1ZgwI3R8bzkp4
	 dgqcbQUteER8nEALNvLNeW7Dtlr8n5r9cp5TCMOmvnXECqaiIumBR8BeqCMADi5U3Y
	 qDOFgpsuBe4kZ3sGbl031qv2yRjkoJWyqq8V4xvQbkcuD6tugX+TMLuVrX4GJLLwx4
	 SOwNPXqpYYpQ48wvOaFIx+7tT04oH+c+DhH93afz25ESbM5xEu9Ikn8atPjg7ehLEn
	 KhldTju47zQb4Cxdo9+6N4AoVnEfjRqLzRxvE/J7A3FAkBiF9hDGulu8uXFdQ4lNMT
	 ceX8kOlJIt93A==
Subject:
 Re: [PATCH net-next 13/15] eth: bnxt: Receive into XDP-only memory providers
From: netdev-bot+sashiko@kernel.org
To: bjorn@kernel.org
Cc: magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
 john.fastabend@gmail.com, andrii@kernel.org, eddyz87@gmail.com,
 memxor@gmail.com, ilias.apalodimas@linaro.org, alexanderduyck@fb.com,
 saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 michael.chan@broadcom.com, pavan.chebbi@broadcom.com, corbet@lwn.net,
 shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
 stuclar@meta.com, sdf@fomichev.me, horms@kernel.org, martin.lau@linux.dev,
 almasrymina@google.com, song@kernel.org, yonghong.song@linux.dev,
 jolsa@kernel.org, emil@etsalapatis.com, ihor.solodrai@linux.dev,
 rdunlap@infradead.org, kernel-team@meta.com, dimitri.daskalakis1@gmail.com,
 bobbyeshleman@meta.com, mohsin.bashr@gmail.com, kees@kernel.org,
 leitao@debian.org, maxime.chevallier@bootlin.com, cuitao@kylinos.cn,
 vadim.fedorenko@linux.dev, mike.marciniszyn@gmail.com, kuniyu@google.com,
 jiayuan.chen@linux.dev, mkarsten@uwaterloo.ca, razor@blackwall.org,
 dw@davidwei.uk, asml.silence@gmail.com, linux-rdma@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2026 14:08:32 +0000
Message-ID: <179561571294.3135.1261628874481958794@kernel.org>
In-Reply-To: <20261124125654.183091-13-bjorn@kernel.org>
References: <20261124125654.183091-13-bjorn@kernel.org>
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] eth: bnxt: permanent RX queue stall when XDP-only FILL ring is
  empty at setup

--

> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -3969,7 +3951,8 @@ static int bnxt_alloc_rx_page_pool(struct bnxt *bp,
>  	pp.dma_dir = bp->rx_dir;
>  	pp.max_len = PAGE_SIZE << pp.order;
>  	pp.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV |
> -		   PP_FLAG_ALLOW_UNREADABLE_NETMEM;
> +		   PP_FLAG_ALLOW_UNREADABLE_NETMEM |
> +		   PP_FLAG_ALLOW_XDP_ONLY_NETMEM;
>  	pp.queue_idx = rxr->bnapi->index;
>  
>  	pool = page_pool_create(&pp);

[Severity: Medium]
With PP_FLAG_ALLOW_XDP_ONLY_NETMEM, rxr->page_pool can now be backed
by the AF_XDP sink, and the sink takes its buffers from the userspace
FILL ring. What happens if that ring is empty when bnxt fills the RX
ring?

bnxt_alloc_one_rx_ring_skb() breaks out of its loop on the first
bnxt_alloc_rx_data() failure. With an empty FILL ring, rx_prod is
left at 0, and rx_agg_prod is left at 0 by
bnxt_alloc_one_rx_ring_netmem(). bnxt_queue_mem_alloc() still returns
success, and bnxt_queue_start() rings the doorbell with nothing
posted.

As far as I can tell, bnxt only refills RX buffers from bnxt_rx_pkt()
while it handles a completion. With no descriptors posted, the NIC
never produces a completion. When userspace later fills the ring and
xsk_sink_wakeup() schedules NAPI, __bnxt_poll_work() finds no work
and returns without allocating, so the queue stays wedged.

This is the normal AF_XDP order: bind first, then populate FILL.
xsk_sink_bind() expects it by setting need_wakeup, and
testapp_stats_fill_empty() in this series exercises it. It can also
happen on netdev_rx_queue_reconfig(). There, new_mem is allocated
before the old queue's buffers go back to the sink, so FILL can be
dry at that point even if userspace keeps it topped up.

Does bnxt need a refill pass at the end of NAPI poll when the RX ring
is short, like mlx5 and fbnic have? Or did you have another way in
mind to prime the ring for an XDP-only provider?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261124112707.118678-1-bjorn%40kernel.org
