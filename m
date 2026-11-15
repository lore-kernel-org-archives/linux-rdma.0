Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794712699;
	b=cAfgNWq5h8G8+Npp/BKcNgahV2d4Og6ONcjmXLhxVz9o4P022a4FiO+I7aUykmMNYAUU
	 QG/826GxCSuvKFbKoKY1vTX9tgf/UwING00gllnjh5OG0NaUJHtyhE+aQFpeAXk0CKJWQ
	 c61L9gFfNAE4nwUyi9unXwSe0JiWxRG0Gptx6Ux9rvvr1t+ZBi4ZMML7A/KbHdYrGVOtQ
	 vGMhIHX3vu+8qy/RkPQS+jD4MfPuaSzP2DWtIXEavXoQ6do99M0LVdhWk8pRl6x8DePQ6
	 MlXtEJGMvbgiMk+Mf0/yUkC7+VdXSGZwTDtz2/68+Hv3pypV4wMKhIClP870KhT1yEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794712699;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=EQmiMwQ3u6k3uyujpSWR+O2asGp9W/secTZ73M9GPzQ=;
	b=kCNESYIx4ISWmaV7YBiZx0oYfKTScSmq3ls0o5D0IVdFn0PGzSoIVSpl4pCu+66slra8
	 KX+sd/VijYdcoIA0ZwxkoTU52WLIoBJnLIeQ0TRmTzinG0lfqfK2ND7WHVEYZ2JYvA7Id
	 dg0+b8URVUjUNbOPx585TXBw3S4k1uoYZ1y/cxGHZ0arCIfDwY41glrhfVyOSkYPnS/ka
	 BmUOIH9lMnU2S4r1Zp9K/0TUx9cwfoZ/Y8YX8myTK1j/cRrzY533tnjDDwRj0GlxvjANw
	 1MP3O+v4DH/n32eUD0TBmITo2cKXPHXQBYPzmKX1lC/T+Uv3Qy/BRsWHv8g9cmDs4hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S4O5UKcm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A813606A8B5;
	Sun, 15 Nov 2026 03:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S4O5UKcm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D781F000D0;
	Sun, 15 Nov 2026 03:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794712698;
	bh=EQmiMwQ3u6k3uyujpSWR+O2asGp9W/secTZ73M9GPzQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=S4O5UKcm+XXFbVBqaNQsjEllJ9mWIy8sHKKM6B/25bfQQLWnQxWIM6raMEzUG9C24
	 VUt88pk7Z9LWIexHcGLTMkEANAFiLP6p7qQAGVVl84I4VMyxGO/5Tgl/cgnretyEDE
	 DYN0YOZIAj8ktOaK66oZ6weaRPIVWZsoc2iR+wvkYIw1QmYaec7uKX8UZhSTCUMHK7
	 qWP4ZeSrxLPJ6Lb09v4vMmeX8QZMQsRlO8GQVOna2NeYUVKFtpzPDfnSlcxHBmXKtA
	 uylQwvYL2kYgj8/fP+N5zRFxucgXrzXXOTEF7Fguy/rvbWBlSVomzs2ZJQZ1vmzkYy
	 MqvRB4C7+ne3g==
Subject: Re: [PATCH net-next v1 05/15] net: add METADATA_PSP dst to carry a
 psp association on an skb
From: netdev-bot+sashiko@kernel.org
To: toddfreed@meta.com
Cc: netdev@vger.kernel.org, davem@davemloft.net, andrew+netdev@lunn.ch,
 bjorn@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
 daniel.zahka@gmail.com, donald.hunter@gmail.com, edumazet@kernel.org,
 kuba@kernel.org, jhs@mojatatu.com, jiri@resnulli.us, john.fastabend@gmail.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org,
 martin.lau@linux.dev, pabeni@redhat.com, saeedm@nvidia.com, horms@kernel.org,
 tariqt@nvidia.com, weiwan@google.com, willemdebruijn.kernel@gmail.com
Date: Sun, 15 Nov 2026 03:18:16 +0000
Message-ID: <179471269695.2199510.18062590833471363525@kernel.org>
In-Reply-To: <20261111005533.6436-6-toddfreed@meta.com>
References: <20261111005533.6436-6-toddfreed@meta.com>
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

- [Medium] The commit message says the second psp_xmit_md() check at
  dequeue, in sk_validate_xmit_skb() (net/core/dev.c:4164-4172), handles…

--

net: add METADATA_PSP dst to carry a psp association on an skb

This adds a METADATA_PSP metadata_dst type, which holds a reference on a
psp association so that socket-less skbs (for example, ones marked by a tc
rule) can be PSP-encrypted by existing driver tx paths. __dev_queue_xmit()
now validates the metadata dst against the device and MTU and keeps the dst
for the driver. sk_validate_xmit_skb() checks it again at dequeue in case
the psp device was unregistered while the packet was queued.

> diff --git a/net/core/dev.c b/net/core/dev.c
> index 9665f3b2f5cb2..2cca5f0d302f8 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c

[ ... ]

> @@ -4156,6 +4161,15 @@ static struct sk_buff *sk_validate_xmit_skb(struct sk_buff *skb,
>  
>  	if (sk_validate) {
>  		skb = sk_validate(sk, dev, skb);
> +	} else if (unlikely(skb_psp_md(skb))) {
> +		int psp = psp_xmit_md(skb, dev);
> +
> +		if (psp <= 0) {
> +			kfree_skb_reason(skb, psp == -EMSGSIZE ?
> +					 SKB_DROP_REASON_PKT_TOO_BIG :
> +					 SKB_DROP_REASON_PSP_OUTPUT);
> +			skb = NULL;
> +		}

[Severity: Medium]

The commit message says this re-check handles the case where "the psp
device may have been unregistered while the packet was queued, and its
keys deleted". Does that still hold for skbs that get requeued?

This check runs once, from validate_xmit_skb(), before the tx lock is
taken. If the txq is stopped by then, sch_direct_xmit() requeues the skb
into q->gso_skb. dequeue_skb() then sends it out again without validating
it a second time:

net/sched/sch_generic.c:dequeue_skb() {
    ...
		/* skb in gso_skb were already validated */
		*validate = false;
		if (xfrm_offload(skb))
			*validate = true;
    ...
}

On mlx5, one possible sequence is:

CPU0
sch_direct_xmit()
  validate_xmit_skb()
    sk_validate_xmit_skb()
      psp_xmit_md() returns 1

CPU1
mlx5e_nic_disable()
  mlx5e_close()
    ...
      netif_tx_disable()

CPU0
  HARD_TX_LOCK() finds the txq stopped
  dev_requeue_skb() puts the skb on q->gso_skb

CPU1
  mlx5e_psp_unregister()
    psp_dev_unregister()
      psp_dev_tx_key_del(psd, pas)
        mlx5e_psp_assoc_del()
          mlx5_destroy_encryption_key(priv->mdev, nkey->id);

Later, mlx5e_nic_enable() registers a new psd, and netif_device_attach()
wakes the queues. The qdisc is not reset at any point. The stale skb then
comes off gso_skb with validate set to false and reaches mlx5e_xmit(), where
mlx5e_psp_set_state() still reads from the old association:

	psp_st->spi = pas->tx.spi;
	psp_st->ver = pas->version;
	psp_st->keyid = *(u32 *)pas->drv_data;

Can this hand the NIC the id of a DEK that has already been destroyed, and
that may have been reused for another association? psp_xmit_md() would
catch the psd mismatch, but it never runs again for this skb.

On mlx5, the plain check-then-xmit race is blocked because
netif_tx_disable() runs before psp_dev_unregister(). That leaves only the
requeue window.

The socket path through psp_validate_xmit() was already exposed in the same
way before this patch. The new METADATA_PSP path, however, depends on this
re-check to handle the unregister case.

>  	} else if (unlikely(skb_is_decrypted(skb))) {
>  		pr_warn_ratelimited("unencrypted skb with no associated socket - dropping\n");
>  		kfree_skb(skb);

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261111005533.6436-1-toddfreed%40meta.com
