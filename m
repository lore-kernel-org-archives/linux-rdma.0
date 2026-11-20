Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795138319;
	b=dtiMDXVMybwTuOEtpKeCZptJI4Ff0A7pJtUK24+a7yp7WkRCAR2UoqAOE7fZzaoQlKUy
	 hA6/IMt3Y5djjigCOrc6oB5KtHqAdTkb2zXrf86stfnDMCJhM2UlsiTFE+yQDqWNx1bbu
	 6Jdje5rPiyy3nPKCjheRYOjT8h2xAByE+b5NcUvA9Tds3qn0zwOPt+tHIoTBk7lxqvfMD
	 EyaemWCFP7bt06W2bCMjG3b55F10Lu1qi9GigKYaAB6fM+gJTvQp3l/Wh4HHGAwxk2jVH
	 JzzKAyaxDA/DtpnlS/0VFp9TXmCpzsyGAaCXh/sA2Wffmx2LbIPnQlil32eRNqFo6xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795138319;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=c7qzuLHXoXkOGtz8roMGna4dsmi2XqzLaMB70yxtEzU=;
	b=LcS1sn13TEbZDEjztF6WK/0L927t6t7+lDdz/3334CNMyI/9EF4/3U6QXBZIPX7W5aBc
	 NFlohsiglK9NizQ0F1oB6ndMp1aYJa/HFIlirNMoNg8ky0e+uWio1d9mHHoxYbd+marLc
	 z28fKT+8M8h3OkZy0FoZrrxU7VHyprx6pbs0sGjTxrp1fM9yXTlGsnh/hb8/9lOVC3se4
	 CVYRdbmvY78Q6KfGIWHiKrm5s4oIJPoeU8a9pOPd48aoRwOjvQX+IdxvYPmLaISJmk4dp
	 lvhUoyCuSYqmteRH9Zxj2uZdxjy+jCVWtHOA1T1m+RpCoKDcplZ28tJwnH405YUoTiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WRkm0uZL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B9C606A333
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 01:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WRkm0uZL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343601F000C4;
	Fri, 20 Nov 2026 01:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795138319;
	bh=c7qzuLHXoXkOGtz8roMGna4dsmi2XqzLaMB70yxtEzU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WRkm0uZLtoeDXqIccY1s9+VLkWyA/4jNMXRvZZzOR1sSsfVB0gv+uYXeHfs/4hmup
	 rQ5Ra/Kb2On28xA+b7S8TGll/usefm3+z0cojHqBQmspVWH+gEgyskmTZWzLLqhqm2
	 bMf58zi9rnDSAckp3QA8mlHvzvYbKbvnGVychW+Q59dbkim3x9MGRXT6HsF9WyLbwO
	 OKh5qztfLa7XwOO6wb+w3l8OZPYhCkY2oq3f5EwEJRHmLByeIUYRLclLSeCd58XmYu
	 N7AhKz0faz8E8skvrp8E+qD5Tj+VEs8jg1LEKsuyaD1iIlTmMqG2hiO2iDprK8TbHs
	 4z7TYGmx/sIZQ==
Message-ID: <sashiko-outbox-224313@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 06/12] net/sched: add act_psp for psp
 transport mode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261119013103.1092559-7-toddfreed@meta.com>
References: <20261119013103.1092559-1-toddfreed@meta.com>
 <20261119013103.1092559-7-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 01:31:58 +0000
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
- [High] net/sched: act_psp sets GSO transport_header without pulling L4
  header
--

commit 8cc19eccde3250f6beb0d3d37c3541f580815f9f
Author: Todd Freed <toddfreed@meta.com>

net/sched: add act_psp for psp transport mode

This commit adds the act_psp traffic control action to attach a PSP Tx
association via a METADATA_PSP dst on egress (encap) or drop decrypted
SKB_EXT_PSP state (decap).

> diff --git a/net/sched/act_psp.c b/net/sched/act_psp.c
> new file mode 100644
> index 0000000000000..9056ba2582c2c
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
Can setting transport_header to off + hlen on a GSO skb cause out-of-bounds
L4 header accesses down the transmit path?

At the start of __dev_queue_xmit(), qdisc_pkt_len_segs_init() returns early
without pulling the L4 header if skb_transport_header_was_set(skb) is false
(for instance, after gro_cells_receive() unsets transport_header on a
bridged GSO packet), or pulls the L4 header at the old transport offset if
it differed from off + hlen.

tcf_psp_set_transport_header() only pulls off + hlen bytes before setting
transport_header to off + hlen.  Right after sch_handle_egress(),
psp_xmit_md() -> skb_gso_validate_network_len() -> skb_gso_network_seglen()
-> skb_gso_transport_seglen() reads tcp_hdr(skb)->doff at the new
transport_header past skb->tail, and mlx5e_psp_handle_tx_skb() writes
inner_tcp_hdr(skb)->check out of bounds.

Overwriting transport_header on GSO packets also bypasses the
skb_network_header_len(skb) check in psp_dev_encap_ok().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119013103.1092=
559-1-toddfreed@meta.com?part=3D6
