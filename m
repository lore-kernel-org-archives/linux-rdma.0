Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794712708;
	b=Rue/wZyvjVb4KeeDT6IOgeDrYCxtG8oAY77z1lCynCbK2jg555lmg35Sm+reI6FsPejX
	 OA+biqQa/G4CXb3BfnpLBBVTkVUE1x+HUiq7dB4xG6fhCRuSPRtk/gKLJyp3KbCdU+zbe
	 z6RJ5U5cccnAU5346CJV2dPcf9AEYD7HIcKQ18fllpyYpBNqI2jXslRqoU/7rQjrMyUa2
	 qkBoJlbYeIB/lpdcRMHKoVQPgAJADIfZHxuzbjee5R9+NBtJAD4GE+0tq59r3/3ZN6MVj
	 MdB+YQKOKIQGMztlgXj5hOV6uLIiiMUBOMS2C7drYo1iEFAv0pS5cn1hqMtyD5Wt/JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794712708;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=6xELBp+yLa1rDoNGymklB/N3IouGpSartu+yBIKoLYM=;
	b=VBhcc3ZBMqPMBysPDzOryOwO5buF4EFs/S2k8cdodpgAtifZR0/1gqPXgUXXEiExyy0R
	 NwVW41XRL/hm98R6ZzrAgHh48DF8XJL0x6ZF0HPOkXXyP4F6ixT4xOVz7bDhrcbVDLCN+
	 WHHkj2Mty628V/kKO3iuszuYbXJLoaO466IrWOBG0z+hZvOwC6l+tn1WH4S5829tErJ/g
	 ZKHot0JX/SP0LV7hlyAtiBZo5sNkGe9RXVpzi/o+ZlCX+B/BJLkl7O49O/eAUiZzHJq34
	 hMsSe2p/ysQTPDZUb1aweV7s1XCGshkj5ExU3MWrhlCgmaFv5DiYBT13kEnZArJllAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XE+TbmoL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A6660A5BCA;
	Sun, 15 Nov 2026 03:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XE+TbmoL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC411F00925;
	Sun, 15 Nov 2026 03:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794712707;
	bh=6xELBp+yLa1rDoNGymklB/N3IouGpSartu+yBIKoLYM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=XE+TbmoLDF9UzbfJoVAvGRVHMKoZ+DrsTGtNSz6uXvziuagHeJEKFqg4bAJNQ7zSW
	 iJaIpBsWtgEVlRpGLnJ6aMJd9uE+A6Vlff74BcEwIuxUrWrEaypz1JtaByQiqC0Kn4
	 GVHuN5PgL/pW7Aw5E9WIHzE8C5pShtsKnhHUumSZHuV6Rh6TSAHc3HjnQQg4f55wQB
	 ykLOsgCxq6lrS4aDUJYkuv0Ka4iDj5x0iGMya6CDArD0NSp7D6qpyOumiUnJB1KAJu
	 oSDQCYIQQ+7Jv0KVwr4N+o57kNmnyWhCOg/jR93mzO7Co/2ysBSfn7wDdCJUoPAyHp
	 auJUiVAT7v5lg==
Subject: Re: [PATCH net-next v1 10/15] net/sched: flower: add psp_spi,
 psp_ver, and psp_dev matches
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
Date: Sun, 15 Nov 2026 03:18:26 +0000
Message-ID: <179471270629.2199510.9480561958902023552@kernel.org>
In-Reply-To: <20261111005533.6436-11-toddfreed@meta.com>
References: <20261111005533.6436-11-toddfreed@meta.com>
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

- [Medium] The commit message misstates what a PSP flower rule matches
  once two key rotations have passed, and it overstates its claim that…

--

net/sched: flower: add psp_spi, psp_ver, and psp_dev matches

This adds a flow dissector key that is filled from the SKB_EXT_PSP Rx
state of decrypted packets. It also adds flower matches on the SPI (with
a mask), the PSP version and the PSP device ID. The goal is to let a tc
rule select the packets of a single Rx association, for example to apply
psp decap.

> diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> index 1be6c739e3c71..95d3fa3b1568e 100644
> --- a/net/core/flow_dissector.c
> +++ b/net/core/flow_dissector.c

[ ... ]

> @@ -511,6 +512,32 @@ void skb_flow_dissect_hash(const struct sk_buff *skb,
>  }
>  EXPORT_SYMBOL(skb_flow_dissect_hash);
>  
> +void skb_flow_dissect_psp(const struct sk_buff *skb,
> +			  struct flow_dissector *flow_dissector,
> +			  void *target_container)
> +{
> +#if IS_ENABLED(CONFIG_INET_PSP)
> +	struct flow_dissector_key_psp *key;
> +	struct psp_skb_ext *pse;
> +
> +	if (!dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_PSP))
> +		return;
> +
> +	pse = skb_ext_find(skb, SKB_EXT_PSP);
> +	if (!pse)
> +		return;
> +
> +	key = skb_flow_dissector_target(flow_dissector,
> +					FLOW_DISSECTOR_KEY_PSP,
> +					target_container);
> +	key->spi = pse->spi;
> +	key->dev_id = pse->dev_id;
> +	key->version = pse->version;
> +	key->present = 1;

[Severity: Medium]
Does the commit message describe the right failure mode for rules that
are still installed after two key rotations?

The commit message says:

  Together these matches tie a rule to one association, ...

and:

  this means that a rule matching packets that correspond to an rx
  association which is stale (two rotations have passed), can still match.

After two rotations the device key for the original association is gone.
Its packets then fail to decrypt and never get SKB_EXT_PSP, so the stale
association itself can no longer match.

The SPI value can be handed out again, though. In netdevsim, for example:

drivers/net/netdevsim/psp.c:nsim_key_rotate() {
    ...
	if (ns->psp.spi & PSP_SPI_KEY_PHASE)
		ns->psp.spi = 0;
	else
		ns->psp.spi = PSP_SPI_KEY_PHASE;
    ...
}

and nsim_rx_spi_alloc() then does:

	assoc->spi = cpu_to_be32(++ns->psp.spi);

So a new rx-spi-alloc, possibly for a different peer, can get 0x80000001
again. skb_flow_dissect_psp() only copies spi, dev_id and version. Given
that, wouldn't the example rule from the commit message:

  psp_spi 0x80000001 psp_ver 0 psp_dev 1 action psp decap

strip PSP state from the traffic of a different, live association? With
a mirred action instead of decap, it would forward that traffic.

The socket path avoids this because psp_pse_matches_pas() also compares
the generation:

	return pse && pas->rx.spi == pse->spi &&
	       pas->generation == pse->generation &&
	       pas->version == pse->version &&
	       pas->dev_id == pse->dev_id;

Adding generation to the key would not fully fix this either. The mlx5
Rx path always passes generation = 0 to psp_dev_rcv(). So it looks like
(spi, version, dev) cannot identify a single association beyond two
rotations on any driver.

The "Socket-less associations" text that a later patch in this series
adds to Documentation/networking/psp.rst has the same gap. It only says
userspace should replace such rules before two rotations, and it repeats
that the matches tie a decap rule to one Rx association. No later patch
in the series adds a generation match or any enforcement.

Could the commit message and the documentation say that a stale rule can
end up matching a different association that reused the SPI, rather
than the stale association itself?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261111005533.6436-1-toddfreed%40meta.com
