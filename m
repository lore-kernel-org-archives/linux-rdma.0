Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795645182;
	b=ZeZylVImlz7RVcM3FA9hW8yMrEnzwEAYwcIwj7C97914pRGlXpPgnQU7cEqyDmC4xtTM
	 A62zd9t4BbOZ1R7tFij7DjObNf9ZJrkmwrGiN3zCNkfarckJpw7hKnBcXbeBKD6il2wqM
	 +iemuRmph+JB8S/fHbxfPjBsQYToiMs64V29aUpgXUUV9O7WoyfBp5KezkNRa8VJWgquL
	 xWv53XqaLKEyqnrXvL6VMFaRWcZX3PXSDYfcXNjMyQdRbLqsUKN4bUoqDp1Clt3X972n5
	 MF5uR5MVsAF1Ce0wQ5ebouPrbKBFFDmmukQzZ0VPxE2N6EnU2EROc1zvOoOupKfKPvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795645182;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ivsm1eBYLb471dcBskdb5pKBm+6ZflSWp/Zr7wSBNBI=;
	b=pvwv2Cm+VQ3xFOi8enKqcg65gDAiYw2UPhafQqKtPSFtZpBE74xifYFLG5bGSRCJtTfs
	 +TWBVLY6yLxfPM2Ph/lNLuq/OwQp/aYgn71vAwnAIk5vWW55KA8dV4GKGvcezavR0qKQb
	 2S1YhdG7dMPm2pkz0fZPRNyKPyKSkxZho7l1KLAOtEgYn6AJe7RIYF5qKVKX51vY5L2w+
	 J2L1VTE2AzP6lgBE1P/sSLHtOdF8Js0tNwEfYaLrviT0SW42O6YL4LN9FBmhgtoD+T/BF
	 IIgFPGZ7uB4Do7Ltf0jekTlJU0U/Dzzn+6/pZFWyDu2RYcEDdd5MrrQ3jSmh8CL0zsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oYSn5LXu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D52606A32D;
	Wed, 25 Nov 2026 22:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oYSn5LXu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF521F000C0;
	Wed, 25 Nov 2026 22:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795645181;
	bh=ivsm1eBYLb471dcBskdb5pKBm+6ZflSWp/Zr7wSBNBI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oYSn5LXuci+eEoAO+CG0kzcayVybdp6EX94u4mmS3Ax8rUquII3v7jNbgQfONVOAQ
	 CSBBMlLv3G49Ylgk+IpwzTzMvS3a3o3I6coxcVD6CDboXSpkhm/JrDR3+OQWOr2fsC
	 8QUi1Q/KAB1oaBaFCGQtf1w1hIoNv9EddaYeAbhSpmgxe4rH0lK2pFzQhmOfAL7m6S
	 rAirG8WNNSF/fhJ0a/Xc883tGMZuqfK+Tmh9RsEirec7uVm3s3KGf9N0gq+EZ1JtjO
	 Y1FH/9mDtJVDAVBHMMQjAurn70hjqOL4u7xqat7X1rA3gnMdLQoxQji+MZhxPlZvDr
	 o2hB8wPH0bAsg==
Message-ID: <sashiko-outbox-234241@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3 06/12] net/sched: add act_psp for psp
 transport mode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <20261124221758.3230929-7-toddfreed@meta.com>
References: <20261124221758.3230929-1-toddfreed@meta.com>
 <20261124221758.3230929-7-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 22:19:41 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] net/sched: act_psp: METADATA_PSP dst and skb->decrypted split
  on fragmentation
--

commit 8bbfc007284723c55c132cc556b51f47c5d07c71
Author: Todd Freed <toddfreed@meta.com>

net/sched: add act_psp for psp transport mode

This commit adds the act_psp traffic control action to attach a PSP Tx
association as a METADATA_PSP dst on egress (encap) or remove SKB_EXT_PSP
Rx state (decap).

> diff --git a/net/sched/act_psp.c b/net/sched/act_psp.c
> new file mode 100644
> index 0000000000000..757b15a812a20
> --- /dev/null
> +++ b/net/sched/act_psp.c
[ ... ]
> +static int tcf_psp_act(struct sk_buff *skb, const struct tc_action *a,
> +		       struct tcf_result *res)
> +{
> +	struct tcf_psp *p =3D to_psp(a);
> +	struct tcf_psp_params *params;
> +
> +	params =3D rcu_dereference_bh(p->params);
> +
> +	tcf_lastuse_update(&p->tcf_tm);
> +	tcf_action_update_bstats(&p->common, skb);
> +
> +	switch (params->psp_action) {
> +	case TCA_PSP_ACT_ENCAP:
[ ... ]
> +		/* Don't mix the association with another encryption
> +		 * offload: the packet is already marked decrypted, or its
> +		 * socket has an offload of its own
> +		 */
> +		if (unlikely(skb_is_decrypted(skb) || tcf_psp_sk_offload(skb)))
> +			return tcf_psp_drop(p, skb, SKB_DROP_REASON_PSP_OUTPUT);
> +		if (unlikely(!tcf_psp_set_transport_header(skb)))
> +			return tcf_psp_drop(p, skb, SKB_DROP_REASON_PSP_OUTPUT);
> +		skb_dst_drop(skb);
> +		skb_dst_set(skb, dst_clone(&params->md->dst));
> +		/* Must be encrypted: sk_validate_xmit_skb() drops it unless
> +		 * it still carries the association when it is transmitted
> +		 */
> +		skb->decrypted =3D 1;
> +		break;
> +	case TCA_PSP_ACT_DECAP:
> +		/* Only a packet the device decrypted: on transmit,
> +		 * skb->decrypted means "device, please encrypt", which decap
> +		 * must not undo.
> +		 */
> +		if (!skb_ext_find(skb, SKB_EXT_PSP))
> +			break;
> +		skb_ext_del(skb, SKB_EXT_PSP);
> +		skb->decrypted =3D 0;
> +		break;
> +	}

[Severity: Medium]
Can IP fragmentation split the METADATA_PSP dst from skb->decrypted and
bypass the cleartext drop check in sk_validate_xmit_skb()?

When a packet defragmented by act_ct is encapsulated by TCA_PSP_ACT_ENCAP
and redirected via act_mirred -> tcf_dev_queue_xmit() ->
sch_frag_xmit_hook() -> sch_fragment(), ip_copy_metadata() /
ip6_copy_metadata() and sch_frag_xmit() copy the METADATA_PSP dst onto each
new fragment without copying skb->decrypted:

net/sched/sch_frag.c:sch_frag_xmit() {
    ...
	__skb_dst_copy(skb, data->dst);
	*qdisc_skb_cb(skb) =3D data->cb;
    ...
}

If a subsequent TC action on the target device replaces or drops the dst,
sk_validate_xmit_skb() sees neither skb_psp_md(skb) nor
skb_is_decrypted(skb) and transmits the fragment in cleartext.

Similarly, ip_copy_metadata() and ip6_copy_metadata() copy SKB_EXT_PSP via
skb_ext_copy() without copying skb->decrypted, so an Rx PSP packet that is
fragmented and later reassembled can enter TCA_PSP_ACT_ENCAP with
SKB_EXT_PSP still attached and skb->decrypted =3D=3D 0; if TCA_PSP_ACT_DECAP
then runs, it finds SKB_EXT_PSP and clears skb->decrypted =3D 0 while leavi=
ng
the METADATA_PSP dst attached.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124221758.3230=
929-1-toddfreed@meta.com?part=3D6
