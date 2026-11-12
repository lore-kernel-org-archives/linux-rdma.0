Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794445026;
	b=4rX2LBCA2jUEwaAKaWJObhajxYK0vnwHkZAjPsgJigpQpaql4YUBeeC16RE04Ww5tTKL
	 jAL9iX96jAKl2/n+uSyH3QQqDwuxsLDJTMnAVTawLc9z7LV3XmpSTIpF6MpbtDg30n9NJ
	 HH1ua0wG2gGV/RCzmQ/n+TSQhriYPxaunbhOc5syyP5EhVrFsOdJvkPjiBKj1ri4dOY2m
	 M28glA3GedhkgXSgjgTG/gfbSVmVIm4UcqUzI/b1oBICRI+kQ87g6WPkXgYZ087ZjMIU0
	 Sm4ONJs9wKY2qmbwLwRQajLaVtBf6TQ25n8U22K7ynVmRz3c981pH2DZ9msflj6vznQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794445026;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=dcPWv/+PQnB936jvHwtkjEhtJGcaaBra6pSkzx9VtmY=;
	b=H8+QjljV3qo4xRsSuy3o3wG+QCXMHZUfkQ7/esUKMdsF1JZe1R/vwPpHZ/So0dDuniG7
	 cL8D026sWd58j2JRtiXtJBQSSCzeVwIxKGlWrb6AC8fK9SKEOrBDVBH5AaIhW2P4IULg1
	 p8iykfV4PHvM+7LNSzOnDV030J0SfG3t311L9HKWaeuUx4pyFP+st32lZq5TEbfyeb+jh
	 K/118VWwTz83ZKwzWo6SEBbyb8fW5Fg1ObZM/KJ+eaQDusUoGKuv9UWegTByZTAj+XY9s
	 m+GwhLxE75Wn7ra9hYxVZ9xA7f3eYxtvcawc0sEEcx5SH+tAZlDFmGHf/qG+ajUvi7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nvufQqXk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376B0606A88D;
	Thu, 12 Nov 2026 00:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nvufQqXk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D562D1F00A05;
	Thu, 12 Nov 2026 00:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794445026;
	bh=dcPWv/+PQnB936jvHwtkjEhtJGcaaBra6pSkzx9VtmY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nvufQqXkDwH5v6bWirJ/XajojsltcpPqLgmEn60E68t0rnO/E8gc3Hpkt3FA7iTyi
	 Z4ni2NZm+g3zPTKJlEpWnIEQ+Nln1sbGhzxCgGns5qHgphCutklSvkz907tYHxJQms
	 cfpU6UUBs0+86dslZsbOqZisRcHYVPk6SmY0PEaoqeBZ2GHGcyXinBFthmxeLZidq9
	 JRnZ3+foJfOcubsWtwc0eg13dFFh4kyEYK/YCI6tfPkMnLQw82GF0yugWsfPVAf5bq
	 /9HEabBGH34AA0AakW2gOqQKjdmEpr/CShSgzn70U7MwN9orqE8kdefk59VGXQmrdY
	 ufwqguHWTcbOA==
Message-ID: <sashiko-outbox-210012@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v1 09/15] net/sched: add act_psp for psp
 transport mode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: bpf@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261111005533.6436-10-toddfreed@meta.com>
References: <20261111005533.6436-1-toddfreed@meta.com>
 <20261111005533.6436-10-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 00:57:05 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] net/sched: act_psp sets GSO transport_header without pulling L4
  header
- [Low] net/sched: act_psp: missing get_fill_size() callback in
  act_psp_ops
--

commit 53d19883448f901e4c3022f6ff521b64c7a129a7
Author: Todd Freed <toddfreed@meta.com>

net/sched: add act_psp for psp transport mode

This commit introduces the act_psp traffic control action to attach PSP Tx
associations via METADATA_PSP dsts on egress and strip PSP Rx extensions on
decap.

> diff --git a/net/sched/act_psp.c b/net/sched/act_psp.c
> new file mode 100644
> index 0000000000000..4ff54203c9f51
> --- /dev/null
> +++ b/net/sched/act_psp.c
> @@ -0,0 +1,439 @@

[ ... ]

> +static bool tcf_psp_set_transport_header(struct sk_buff *skb)
> +{
> +	unsigned int off =3D skb_network_offset(skb);
> +	const struct iphdr *iph;
> +	unsigned int hlen, len;
> +
> +	switch (skb->protocol) {
> +	case htons(ETH_P_IP):
> +		if (!pskb_may_pull(skb, off + sizeof(*iph)))
> +			return false;
> +		iph =3D ip_hdr(skb);
> +		if (iph->version !=3D 4 || iph->ihl < 5 || ip_is_fragment(iph))
> +			return false;
> +		hlen =3D iph->ihl * 4;
> +		len =3D ntohs(iph->tot_len);
> +		if (!pskb_may_pull(skb, off + hlen))
> +			return false;
> +		break;
> +	case htons(ETH_P_IPV6):
> +		if (!pskb_may_pull(skb, off + sizeof(struct ipv6hdr)))
> +			return false;
> +		if (ipv6_hdr(skb)->version !=3D 6 ||
> +		    ipv6_ext_hdr(ipv6_hdr(skb)->nexthdr))
> +			return false;
> +		hlen =3D sizeof(struct ipv6hdr);
> +		len =3D hlen + ntohs(ipv6_hdr(skb)->payload_len);
> +		break;
> +	default:
> +		return false;
> +	}
> +
> +	/* The device takes the length of the payload from the packet: it must
> +	 * hold the IP length, and L2 padding, e.g. of a minimum size frame,
> +	 * must not be encrypted as payload. A GSO skb's header doesn't always
> +	 * carry its length (BIG TCP).
> +	 */
> +	if (!skb_is_gso(skb)) {
> +		if (len < hlen || skb->len - off < len)
> +			return false;
> +		if (pskb_trim_rcsum(skb, off + len))
> +			return false;
> +	}
> +
> +	skb_set_transport_header(skb, off + hlen);
> +	return true;
> +}

[Severity: High]
Can tcf_psp_set_transport_header() set skb->transport_header on a GSO packet
without pulling the L4 header into linear data?

tcf_psp_set_transport_header() only pulls off + hlen bytes before updating
skb->transport_header to off + hlen.  If a GSO packet enters egress with an
unset transport_header (for example, a decapsulated GSO packet bridged after
gro_cells_receive() calls skb_unset_transport_header()) or with a smaller
initial transport_header offset from virtio_net_hdr_to_skb(),
qdisc_pkt_len_segs_init() does not pull the L4 header at off + hlen.

Immediately after sch_handle_egress() in __dev_queue_xmit(), psp_xmit_md() =
->
skb_gso_validate_network_len() -> skb_gso_network_seglen() ->
skb_gso_transport_seglen() calls tcp_hdrlen(skb), reading tcp_hdr(skb)->doff
past skb->tail, and mlx5e_psp_handle_tx_skb() writes to
inner_tcp_hdr(skb)->check out of bounds.  In addition, unconditionally
overwriting skb->transport_header to off + hlen defeats the
skb_network_header_len(skb) check in psp_dev_encap_ok().

[ ... ]

> +static int tcf_psp_dump(struct sk_buff *skb, struct tc_action *a,
> +			int bind, int ref)
> +{
> +	unsigned char *b =3D skb_tail_pointer(skb);
> +	struct tcf_psp *p =3D to_psp(a);
> +	struct tcf_psp_params *params;
> +	struct tc_psp opt =3D {
> +		.index    =3D p->tcf_index,
> +		.refcnt   =3D refcount_read(&p->tcf_refcnt) - ref,
> +		.bindcnt  =3D atomic_read(&p->tcf_bindcnt) - bind,
> +	};
> +	struct tcf_t t;
> +
> +	rcu_read_lock();
> +	params =3D rcu_dereference(p->params);
> +	opt.action =3D params->action;
> +
> +	if (nla_put(skb, TCA_PSP_PARMS, sizeof(opt), &opt) ||
> +	    nla_put_u32(skb, TCA_PSP_ACTION, params->psp_action))
> +		goto nla_put_failure;
> +
> +	if (params->md &&
> +	    nla_put_u32(skb, TCA_PSP_ASSOC_ID, params->md->u.psp_info.pas->id))
> +		goto nla_put_failure;
> +
> +	tcf_tm_dump(&t, &p->tcf_tm);
> +	if (nla_put_64bit(skb, TCA_PSP_TM, sizeof(t), &t, TCA_PSP_PAD))
> +		goto nla_put_failure;
> +	rcu_read_unlock();
> +
> +	return skb->len;
> +
> +nla_put_failure:
> +	rcu_read_unlock();
> +	nlmsg_trim(skb, b);
> +	return -1;
> +}
> +
> +static struct tc_action_ops act_psp_ops =3D {
> +	.kind		=3D	"psp",
> +	.id		=3D	TCA_ID_PSP,
> +	.owner		=3D	THIS_MODULE,
> +	.act		=3D	tcf_psp_act,
> +	.dump		=3D	tcf_psp_dump,
> +	.init		=3D	tcf_psp_init,
> +	.cleanup	=3D	tcf_psp_cleanup,
> +	.size		=3D	sizeof(struct tcf_psp),
> +};

[Severity: Low]
Should act_psp_ops implement .get_fill_size?

Without .get_fill_size, tcf_action_fill_size() only budgets
tcf_action_shared_attrs_size() and does not account for TCA_PSP_PARMS,
TCA_PSP_ACTION, and TCA_PSP_ASSOC_ID (up to 40 bytes) emitted by
tcf_psp_dump(), which can under-size the notification skb allocated in
tcf_add_notify_msg(), tcf_del_notify_msg(), and tcf_get_notify() when shared
attributes such as rate estimators and 64-bit stats are present.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111005533.6436=
-1-toddfreed@meta.com?part=3D9
