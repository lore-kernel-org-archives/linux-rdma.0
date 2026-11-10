Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794279692;
	b=x3b3W7p7NanEETJcTzvZD76gQhIEBZmuPCr5EPvyw5kRfB+Pbk1plkkppiujCsj7JL9/
	 w7TLNZ5Olr/KwrtV2n9WO2FwFrOlo1u1GQ20eUKeLX9pfusyPofDh9IICk6HgOQP2yLlh
	 2K6HwwKvmyVvtBR2fGcvlw75DlVQ4OX6KvsRvf4x72Jq3lwoTUCXCRQ6Z64yoymHu8dR0
	 ApLmZjkrnBOfRmQN+fj5tTNO0CJsgh3lwYMvk6mp7FU4YH4Pp3Niin/rmZArIlZ4trgu9
	 bjCEW4Fm0vX1kYHicXHyMnGVdTlalKtcHN9LUyZTHMx3AvtqWForD6Vo9lg17LZp1eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794279692;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=F1HHz5dSIb87AZ7sKkHMTpC6Y1HuMHDmRIPysLzaDsY=;
	b=I3BHfwz6E4ampozGKEWls1wFqxrXHB+kKdOiUsqBWz0ANxx2/a5bV4hHHUi/zCm0pthc
	 aWvUzZQKOeflRqPN235yihWnXKW1DQnyT2gk0oHY2fqtUAot5TANf2IyOGH8gWh6akFk+
	 iZbLa1AL2Bm+SQggEfbNO9wk7uh173IIC/iXWcZd6GL36xY3ePmfTQqKork6Cwh9vgQDb
	 mxSwgviGoc5MJGen1HgO/q+rgE+e5SHrzWDUhnbAcPfx0Oi1Tp9AaOBqLmqhC6Oy24wOt
	 ixazSlA2OcvcwIgqWjZKzHV/VGmaoxWEHDKXEuGxHoA0UbKSUBB/ztqr9AvQvDrhtFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e3HfpIh4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED3560A260A;
	Tue, 10 Nov 2026 03:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e3HfpIh4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015091F0089F;
	Tue, 10 Nov 2026 03:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794279691;
	bh=F1HHz5dSIb87AZ7sKkHMTpC6Y1HuMHDmRIPysLzaDsY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e3HfpIh4NPiN7Sa+Kja5/e/oyziWWl9kVzkwdSo/D2b5rfz2BNEcvBXv4wJPlLUEU
	 ZvYGSd5PmclrM7Qj9i2In9kIBTSDLGnIhkkrBwsrCt5+2FPbKZv8UFmbBsfzaDLdY9
	 p1DyJBlGhFckVxZ0GwOoNv0VNX1hFLTWlz99tdtU4ki8pPBTyVxb8c8VWn6uHfLw7q
	 aUKAgKZF37Mc0ObfRno59jpuPKmotYS/Ir29gYL7g/O5gw4m8goJxstFUnvh0sjyaR
	 R/w5zxCJTXwnb37/ZvcvMz+hw2aVdxyY09+CcLx/sU6Qke4xknDkhrYnoeVJ5ceWXJ
	 gKhP+8x3FTfnQ==
Message-ID: <sashiko-outbox-206083@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 10/14] netfilter: bridge: annotate data-races
 around br_netfilter and nf_log sysctls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Cc: linux-security-module@vger.kernel.org, mptcp@lists.linux.dev, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261109025425.328445-11-jiayuan.chen@linux.dev>
References: <20261109025425.328445-1-jiayuan.chen@linux.dev>
 <20261109025425.328445-11-jiayuan.chen@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 03:01:30 +0000
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
- [Medium] netfilter: bridge: TOCTOU VLAN header pull/push in
  br_nf_forward_arp()
- [Low] netfilter: bridge: unmarked read and double write in
  brnf_sysctl_call_tables()
--

commit 5e1289f99dadfbb891673725020b1b41b41b6df22c8
Author: Jiayuan Chen <jiayuan.chen@linux.dev>

netfilter: bridge: annotate data-races around br_netfilter and nf_log sysct=
ls

This commit annotates lockless reads of br_netfilter and nf_log sysctls in
the packet path with READ_ONCE() and uses WRITE_ONCE() when normalizing
values in brnf_sysctl_call_tables().

> diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_ho=
oks.c
> index e15355ff215a7..8a47fe4e8eb61 100644
> --- a/net/bridge/br_netfilter_hooks.c
> +++ b/net/bridge/br_netfilter_hooks.c
> @@ -103,14 +103,14 @@ static inline bool is_vlan_ipv6(const struct sk_buf=
f *skb,
>  	struct brnf_net *brnet =3D net_generic(net, brnf_net_id);
> =20
>  	return vlan_proto(skb) =3D=3D htons(ETH_P_IPV6) &&
> -	       brnet->filter_vlan_tagged;
> +	       READ_ONCE(brnet->filter_vlan_tagged);
>  }
> =20
>  static inline bool is_vlan_arp(const struct sk_buff *skb, const struct n=
et *net)
>  {
>  	struct brnf_net *brnet =3D net_generic(net, brnf_net_id);
> =20
> -	return vlan_proto(skb) =3D=3D htons(ETH_P_ARP) && brnet->filter_vlan_ta=
gged;
> +	return vlan_proto(skb) =3D=3D htons(ETH_P_ARP) && READ_ONCE(brnet->filt=
er_vlan_tagged);
>  }

[Severity: Medium]
Can forcing a fresh reload of brnet->filter_vlan_tagged on every
is_vlan_arp() call corrupt skb->data and skb->network_header when
bridge-nf-filter-vlan-tagged is toggled from 1 to 0 while an 802.1Q ARP
frame is being bridged?

Unlike br_nf_forward_ip(), the ARP forwarding path leaves skb->protocol as
htons(ETH_P_8021Q) and re-evaluates is_vlan_arp() at each step before
br_nf_forward_finish() unconditionally pushes the VLAN header back:

net/bridge/br_netfilter_hooks.c:br_nf_forward_arp() {
    ...
	if (is_vlan_arp(skb, state->net))
		nf_bridge_pull_encap_header(skb);

	if (unlikely(!pskb_may_pull(skb, sizeof(struct arphdr))))
		return NF_DROP_REASON(skb, SKB_DROP_REASON_PKT_TOO_SMALL, 0);

	if (arp_hdr(skb)->ar_pln !=3D 4) {
		if (is_vlan_arp(skb, state->net))
			nf_bridge_push_encap_header(skb);
		return NF_ACCEPT;
	}
	*d =3D state->in;
	NF_HOOK(NFPROTO_ARP, NF_ARP_FORWARD, state->net, state->sk, skb,
		state->in, state->out, br_nf_forward_finish);
    ...
}

net/bridge/br_netfilter_hooks.c:br_nf_forward_finish() {
    ...
	if (!IS_ARP(skb) && !is_vlan_arp(skb, net)) {
    ...
	} else {
		in =3D *((struct net_device **)(skb->cb));
	}
	nf_bridge_push_encap_header(skb);
    ...
}

If br_nf_forward() sees filter_vlan_tagged =3D=3D 1 and dispatches to
br_nf_forward_arp(), which then reads 0, nf_bridge_pull_encap_header() is
skipped while arp_hdr(skb) is read at the 802.1Q header offset, and
br_nf_forward_finish() still calls nf_bridge_push_encap_header(), pushing 4
bytes (VLAN_HLEN) that were never pulled.  Similarly, if filter_vlan_tagged
changes from 1 to 0 after nf_bridge_pull_encap_header() has pulled the VLAN
header, an ar_pln !=3D 4 frame returns NF_ACCEPT without pushing the header
back, or br_nf_forward_finish() takes the IP branch and drops the packet
because nf_bridge_get_physindev() finds no nf_bridge_info.

[ ... ]

> @@ -1178,7 +1178,7 @@ int brnf_sysctl_call_tables(const struct ctl_table =
*ctl, int write,
>  	ret =3D proc_dointvec(ctl, write, buffer, lenp, ppos);
> =20
>  	if (write && *(int *)(ctl->data))
> -		*(int *)(ctl->data) =3D 1;
> +		WRITE_ONCE(*(int *)(ctl->data), 1);
>  	return ret;
>  }

[Severity: Low]
Does *(int *)(ctl->data) in the if condition still perform an unmarked read
after proc_dointvec() has already written directly to ctl->data?

Because proc_dointvec() updates ctl->data in place before normalizing it in
a second step, concurrent sysctl writes still race with the plain read,
non-zero values other than 1 are transiently visible to packet-path
readers, and a concurrent write of 0 can be overwritten with 1.  Passing a
stack copy of struct ctl_table pointing to a local int variable and issuing
a single WRITE_ONCE() when write && !ret would avoid both the unmarked read
and the two-step write.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109025425.3284=
45-1-jiayuan.chen@linux.dev?part=3D10
