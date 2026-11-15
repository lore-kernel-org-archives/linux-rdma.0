Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794712706;
	b=EPXmDfNH8ZWCqwjjpaeYDLLIhvSE3hdUTIEO/xxzyHAwo+fTYW4AxBBwTzXDbHcHPw9M
	 U3LzJYvFgM/nBxL0a76skFpudEILdzKeiG5tD48cImbsEVkll7vGAlqzPYl6w/gVeSXdp
	 iaJUQgvqLkOyWUiAhxxf7eKf1WRBbHc4ag4daWOO1lDNIpNmX7r3nnJ78IPrI/2zYzU7O
	 4KdAEPT2yclZcBTyRF0W37GZa5nijSjNdFNEQSM99e4gTww20jqgbi88ZrN+yS8LjDhiv
	 lA6ZS6EcWPqwVksbXsVS/5adA5eh5xjZ8t8H8Ej3edMALPaJhwT+/VGTELLL8JKrPbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794712706;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=6OJItO86YHqK6IuVI+yOVo6RQNTPReeurz6DnFYn0M8=;
	b=wUQgbRshyMvatfklmh3vhUgKgJiokqN89M5uMsQMSAbLqiCsunB1mQktJamY8qFnvC4u
	 R2EyIbGPrqDbDW248+1xL/Qmie5tYM9zhCI6Qp4l8go+b++6sZQJG8Pimor7aP/GJ7UP8
	 /cZAkj1Kj/LYpIMYVfxO7A0N4xfV9N0aJaWT+2P6qww0+DwGBWSABT//+UOnZcfmvliiH
	 RJPmkS+vQYoS5aZq2nOwCSJQbiJeKyXPOP4P/jHKqS2/uzVR7e858dyuFVTfGd23ZTZiH
	 GYyWQoqNc37wvmrM8TV/Skshn/+/nICRZsWIVwU0slUw3w5ybvrGZDe4kP2F6Sb+0AA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="oti/1q4t";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D5B60A3828;
	Sun, 15 Nov 2026 03:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oti/1q4t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31DD1F000D0;
	Sun, 15 Nov 2026 03:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794712706;
	bh=6OJItO86YHqK6IuVI+yOVo6RQNTPReeurz6DnFYn0M8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=oti/1q4tTwhoDk4l7ss369GSpqDHEe/XD9M00RV6f6p56AmSVDy+FJiL98iB1k6NG
	 YiH8u/36qoO1XtSYrcWHjw3u864kjIbsYjSkrPzb4lZNq+mfK9gyIeR72bV0XhJQW2
	 RJ8ATr/xUeC8/ZXyza1PlnxjZ05MXbnzLFgmrv7KArYMz2gABT7gLiy4W/SOgGV2Xw
	 dZd/7zXZzdyTBDupC43daMpGZncDOPwjrleaQ4I7Xv8i+aaVV9uaI6FnEVRSQDEvey
	 EpKSrAWPxF0xHGfupvvXd7GRfZQnqxLKSD862dQe/uT/DbTt/SymElz4/G1DZ8NNZc
	 v0nCcxPaaFpbQ==
Subject:
 Re: [PATCH net-next v1 09/15] net/sched: add act_psp for psp transport mode
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
Date: Sun, 15 Nov 2026 03:18:24 +0000
Message-ID: <179471270451.2199510.14795764193886368841@kernel.org>
In-Reply-To: <20261111005533.6436-10-toddfreed@meta.com>
References: <20261111005533.6436-10-toddfreed@meta.com>
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

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] ENCAP in tcf_psp_act() relies on two marks staying together:
  the METADATA_PSP dst, which requests encryption, and skb->decrypted,…
- [Low] The act_psp.c file header ("In software, egress only: like tunnel
  mode, encap on ingress is hardware offload only"), the comment in the…
- [Low] The block comment above sk_validate_xmit_skb() in net/core/dev.c
  still says "If the skb belongs to an HW offloaded socket, apply the…

--

net/sched: add act_psp for psp transport mode

This adds a tc action, act_psp. Its encap mode attaches a PSP Tx
association to egress packets as a METADATA_PSP dst and sets
skb->decrypted, so the PSP device encrypts them on transmit. Its decap
mode removes the PSP Rx state from packets the device decrypted, and
sk_validate_xmit_skb() now drops METADATA_PSP packets whose socket has its
own validator.

> diff --git a/net/core/dev.c b/net/core/dev.c
> index 2cca5f0d302f8..353c0409b3c03 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4154,13 +4154,22 @@ static struct sk_buff *sk_validate_xmit_skb(struct sk_buff *skb,

[ ... ]

>  	if (sk_validate) {
> -		skb = sk_validate(sk, dev, skb);
> +		/* act_psp doesn't give an association to the packets of a
> +		 * socket with its own offload, but the socket can gain one
> +		 * while such a packet is queued
> +		 */
> +		if (unlikely(skb_psp_md(skb))) {
> +			kfree_skb_reason(skb, SKB_DROP_REASON_PSP_OUTPUT);
> +			skb = NULL;
> +		} else {
> +			skb = sk_validate(sk, dev, skb);
> +		}

[Severity: Low]
This isn't a bug, but the block comment above sk_validate_xmit_skb()
still says:

  /* Validate an skb for device encryption offload. If the skb belongs to an HW
   * offloaded socket, apply the socket's callback. Otherwise, an skb which
   * carries a PSP association is checked again against dev: ...

With this new branch, an skb whose socket has a validator and which also
carries a METADATA_PSP dst is freed with SKB_DROP_REASON_PSP_OUTPUT. The
socket's callback never runs for it.

Should the function comment be updated to cover this case?

[ ... ]

> diff --git a/net/sched/act_psp.c b/net/sched/act_psp.c
> new file mode 100644
> index 0000000000000..4ff54203c9f51
> --- /dev/null
> +++ b/net/sched/act_psp.c

[ ... ]

> +static int tcf_psp_act(struct sk_buff *skb, const struct tc_action *a,
> +		       struct tcf_result *res)
> +{

[ ... ]

> +	switch (params->psp_action) {
> +	case TCA_PSP_ACT_ENCAP:
> +		/* Encap on ingress is hardware offload only, like tunnel
> +		 * mode: the packet would go through the stack with nothing
> +		 * but its dst, which routing, netfilter or a redirect may
> +		 * replace, to keep it from leaving in clear text
> +		 */
> +		if (unlikely(skb_at_tc_ingress(skb)))
> +			return tcf_psp_drop(p, skb, SKB_DROP_REASON_PSP_OUTPUT);

[Severity: Low]
Is there a hardware offload path for this action?

This comment, the file header ("In software, egress only: like tunnel
mode, encap on ingress is hardware offload only"), the commit message and
Documentation/networking/psp.rst all say ingress encap is available through
hardware offload.

act_psp_ops doesn't set .offload_act_setup, so tc_setup_offload_act()
rejects the action:

net/sched/cls_api.c:tc_setup_offload_act() {
	if (act->ops->offload_act_setup) {
		return act->ops->offload_act_setup(act, entry, index_inc, true,
						   extack);
	} else {
		NL_SET_ERR_MSG(extack, "Action does not support offload");
		return -EOPNOTSUPP;
	}
}

include/net/flow_offload.h has no PSP flow_action_id either. The PSP
tunnel mode that "like tunnel mode" refers to isn't in the tree yet; the
commit message says a later series adds it.

So skip_sw rules are rejected. Software rules install without error,
because tcf_psp_init() has no direction check, and then every matching
ingress packet is dropped with SKB_DROP_REASON_PSP_OUTPUT.

Could the comments, commit message and psp.rst say that ingress encap is
not supported, rather than hardware offload only?

> +		/* PSP on a tunnel isn't supported: the encap would overwrite
> +		 * the inner headers which the device's tunnel offloads use
> +		 */

[ ... ]

> +		skb_dst_drop(skb);
> +		skb_dst_set(skb, dst_clone(&params->md->dst));
> +		/* Must be encrypted: sk_validate_xmit_skb() drops it unless
> +		 * it still carries the association when it is transmitted
> +		 */
> +		skb->decrypted = 1;

[Severity: Medium]
Can the METADATA_PSP dst and skb->decrypted get separated after this
point?

The commit message relies on skb->decrypted as the backstop: "on egress,
encap sets skb->decrypted, so that sk_validate_xmit_skb() drops the packet
if it loses the METADATA_PSP dst on the way". The egress to ingress guards
in mirred and bpf also check only the decrypted bit:

net/sched/act_mirred.c:tcf_mirred_to_dev() {
	if (unlikely(want_ingress && !at_ingress && skb_is_decrypted(skb)))
		goto err_cant_do;
}

ip_copy_metadata() copies the dst but not the decrypted bit, so fragments
built by ip_do_fragment() end up with decrypted == 0:

net/ipv4/ip_output.c:ip_copy_metadata() {
	...
	skb_dst_drop(to);
	skb_dst_copy(to, from);
	...
	skb_ext_copy(to, from);
	...
}

One path where this happens, on a non-PSP netdev's clsact egress:

  act_ct (defrag, sets tc_skb_cb(skb)->mru)
  -> psp encap (the reassembled packet is not a fragment, so it is accepted)
  -> mirred egress redirect to the PSP netdev

tcf_dev_queue_xmit()
  sch_frag_xmit_hook()
    sch_fragment()
      ip_do_fragment(net, skb->sk, skb, sch_frag_xmit)

sch_frag_xmit() then puts the original dst back on each fragment:

	__skb_dst_copy(skb, data->dst);

As a result, every fragment carries the association but has
decrypted == 0.

In the direct case the PSP driver drops the fragments. Suppose a later step
on the target's egress replaces the dst, for example tunnel_key set plus a
redirect to a tunnel device. sk_validate_xmit_skb() then sees neither the
md dst nor the decrypted mark, and the packet goes out in clear text. A
redirect to ingress would also pass the skb_is_decrypted() check above.

The TCA_PSP_ACT_DECAP branch below can split the two marks as well. It
clears skb->decrypted whenever SKB_EXT_PSP is present, without checking for
an attached METADATA_PSP dst.

Would it make sense to do one or more of the following?

- also test skb_psp_md() in the mirred/bpf guards and in the cleartext
  backstop
- propagate decrypted in ip_copy_metadata() and ip6_copy_metadata()
- have decap refuse packets that carry a METADATA_PSP dst

> +		break;
> +	case TCA_PSP_ACT_DECAP:
> +		/* Only a packet the device decrypted: on transmit,
> +		 * skb->decrypted means "device, please encrypt", which decap
> +		 * must not undo.
> +		 */
> +		if (!skb_ext_find(skb, SKB_EXT_PSP))
> +			break;
> +		skb_ext_del(skb, SKB_EXT_PSP);
> +		skb->decrypted = 0;
> +		break;
> +	}

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261111005533.6436-1-toddfreed%40meta.com
