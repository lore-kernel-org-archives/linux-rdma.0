Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795707959;
	b=jJdWHMkvUljmvtFTmJUP0x0DNpnCKzI7UuDdRAGTFwkjI1/54mYUYzcslCqEUxCzEssI
	 tp2lPur90wbYPPyMrFZzSKs6ANA7eCZuu0rc3+mTwqNbE4Sikqap4foj59df0obtFi/n7
	 ekUh97VoeYGi+sI0ywIXTd5Gmo8d7MTLjgzJCR4+pgdQjaOpgvOcBvUaVJhWEnSeuItPA
	 OOiQjTEsEfjnYgF9bRmsX1bs9gReU1y1G8lKf0q4JDshjWX5yNff4hRpkwRurURgWdOAz
	 zyCNmwkzooSnAAxwcdwbWJYiRCyTaPZ8pcqhQmfOgC/UW1VH8dxEgAgM5FwMpKLaDOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795707959;
	h=Received:DKIM-Signature:From:To:Cc:Subject:In-Reply-To:References:
	 Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=AlTkCdvZxwlRFxOm9+L2PEiwYGztHAFlTo7TXnt3Gs0=;
	b=P07+iP0eXCYdiNdAfLlU3l6MrCqutWPoQ/5PPLJfwSpD8F1D+N01zPxYDBfQJQUoCQ8p
	 IzqKmymGcmFMRlRQiscApEZo0esuUsRgD3+ScpDHDb9z+AC9vYdcdDkVJJrjgOvO65vD5
	 a6xzVistw8yj4yPClSJxpFL84MS/FH6FECMVsFRhyqnfriL6ZwGAjMv0ZBbVyjUfTTh3R
	 dVzS4A7tq7IFyerCT0bdI+hCOaVnVHNeOy6ruEhRo4b/Hz18a6aQamii6WfH2sW7/QAtm
	 44K5H8g1YjYb+zgFvdmANlgT/RyzXrJWQOdBMYIZr+s54HO+HMU+hsUi1QqMB098b5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RnVzj++6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B41606A31C;
	Thu, 26 Nov 2026 15:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RnVzj++6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47771F000D3;
	Thu, 26 Nov 2026 15:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795707958;
	bh=AlTkCdvZxwlRFxOm9+L2PEiwYGztHAFlTo7TXnt3Gs0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=RnVzj++6RzzZyV1zjJJwGqvBKqxcUgQ5bCAEs7cOdyx8FOJyTr3RZgA3M3DQjpble
	 yhjE10b9QPUyXaDetA2fgcg/8tRBRCNWJnyINqv9qxJE1oNsSYeB5uV92Sap/jBeT3
	 5GTZienki64DHpZfGNYsG/nq+DLKs7jIclWxUj5hWHyM+IEn6qcRL4gsclaG/fcXtj
	 beCZlRKgpSDuqhuzRzKDg4AB4ztohUNoWO8LAZKDTS3Sy/RQcFZKYNYJi6sn9EFKle
	 44sVNJKOlbpPHM+QmTzOkpXLGMjEobd8kOBKYS8Duqzih5iYhvj8IKoc1udqL1hktn
	 DzgcezFX0ar+g==
From: =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To: Todd Freed <toddfreed@meta.com>, netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Andrew Lunn
 <andrew+netdev@lunn.ch>, Boris Pismenny <borisp@nvidia.com>, Cosmin Ratiu
 <cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>, Donald Hunter
 <donald.hunter@gmail.com>, Dragos Tatulea <dtatulea@nvidia.com>, Eric
 Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Jamal
 Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>, Leon
 Romanovsky <leon@kernel.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>, Paolo Abeni
 <pabeni@redhat.com>, Pedro Tammela <pctammela@mojatatu.com>, Saeed
 Mahameed <saeedm@nvidia.com>, Simon Horman <horms@kernel.org>, Tariq
 Toukan <tariqt@nvidia.com>, Wei Wang <weiwan@google.com>, Willem de Bruijn
 <willemdebruijn.kernel@gmail.com>, Kuniyuki Iwashima <kuniyu@google.com>,
 bpf@vger.kernel.org, =?utf-8?Q?Asbj=C3=B8rn?= Sloth =?utf-8?Q?T=C3=B8nnes?=
 =?utf-8?Q?en?= <ast@fiberby.net>, Qingfang
 Deng <qingfang.deng@linux.dev>, Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgense?=
 =?utf-8?Q?n?= <toke@redhat.com>,
 Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Shuah
 Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
 Matthieu
 Baerts <matttbe@kernel.org>, David Ahern <dsahern@kernel.org>, Jonas
 =?utf-8?Q?K=C3=B6ppeler?= <j.koeppeler@tu-berlin.de>, Hangbin Liu
 <hangbin.liu@linux.dev>
Subject: Re: [PATCH net-next v3 06/12] net/sched: add act_psp for psp
 transport mode
In-Reply-To: <20261124221758.3230929-7-toddfreed@meta.com>
References: <20261124221758.3230929-1-toddfreed@meta.com>
 <20261124221758.3230929-7-toddfreed@meta.com>
Date: Thu, 26 Nov 2026 16:45:55 +0100
Message-ID: <871p87iojw.fsf@all.your.base.are.belong.to.us>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Todd Freed <toddfreed@meta.com> writes:

> Add the tc action act_psp, for PSP transport mode encapsulation and
> encryption.
>
> encap attaches a PSP Tx association to the skb as a METADATA_PSP dst.
> The packet must then be transmitted on the main netdev of the
> association's PSP device, which encrypts it: encap on that netdev's
> egress, or a redirect there from another netdev's egress. Any other
> device drops it.
>
> Encap on ingress isn't supported. Routing replaces the dst of a packet
> entering the stack, so the packet would lose its association before it
> reaches the PSP device.
> A later series will add support for encap on ingress, in hardware
> offload only.
>
> On egress, encap sets skb->decrypted, so that sk_validate_xmit_skb()
> drops the packet if it loses the METADATA_PSP dst on the way.
>
> Some kinds of packets are not supported and are dropped:
>
>  - IPv4 and IPv6 fragments. Encap inserts UDP + PSP between the L3 and
>    L4 headers, and non-initial fragments don't have L4 headers, so
>    transport mode can't support fragments. Tunnel mode PSP, which a later
>    series adds, does support them.
>  - IPv6 packets with extension headers. Some extension headers could be
>    supported in the future.
>  - Packets already encapsulated for a tunnel (skb->encapsulation). Some
>    tunnel types could be supported in the future.
>  - Packets which are too large. On transmit, packets which won't fit the
>    device's MTU once encapsulated are dropped (see the METADATA_PSP
>    patch). The traffic's MTU needs to leave room for the PSP encap.
>  - Packets with another encryption offload. Packets of a PSP or kTLS
>    offload socket, for which sk_validate_xmit_skb() would apply the
>    socket's validator instead of checking the association.
>
> Decap removes the PSP Rx state of a packet the device decrypted. To
> take the packets of only one Rx SPI, a rule matches the PSP header
> fields it was decrypted with: psp_spi, psp_ver and psp_dev. Those
> flower matches are added in a subsequent patch.
>
> Signed-off-by: Todd Freed <toddfreed@meta.com>
> ---
>  MAINTAINERS                        |   3 +
>  include/net/tc_act/tc_psp.h        |  23 ++
>  include/uapi/linux/pkt_cls.h       |   1 +
>  include/uapi/linux/tc_act/tc_psp.h |  28 ++
>  net/sched/Kconfig                  |  13 +
>  net/sched/Makefile                 |   1 +
>  net/sched/act_psp.c                | 437 +++++++++++++++++++++++++++++
>  7 files changed, 506 insertions(+)
>  create mode 100644 include/net/tc_act/tc_psp.h
>  create mode 100644 include/uapi/linux/tc_act/tc_psp.h
>  create mode 100644 net/sched/act_psp.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 97308edec53d..63c5c4c084dd 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22573,8 +22573,11 @@ F:	Documentation/netlink/specs/psp.yaml
>  F:	Documentation/networking/psp.rst
>  F:	include/net/psp/
>  F:	include/net/psp.h
> +F:	include/net/tc_act/tc_psp.h
>  F:	include/uapi/linux/psp.h
> +F:	include/uapi/linux/tc_act/tc_psp.h
>  F:	net/psp/
> +F:	net/sched/act_psp.c
>  K:	struct\ psp(_assoc|_dev|hdr)\b
>=20=20
>  PSTORE FILESYSTEM
> diff --git a/include/net/tc_act/tc_psp.h b/include/net/tc_act/tc_psp.h
> new file mode 100644
> index 000000000000..8640d7685475
> --- /dev/null
> +++ b/include/net/tc_act/tc_psp.h
> @@ -0,0 +1,23 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __NET_TC_PSP_H
> +#define __NET_TC_PSP_H
> +
> +#include <net/act_api.h>
> +#include <net/dst_metadata.h>
> +#include <linux/tc_act/tc_psp.h>
> +
> +struct tcf_psp_params {
> +	struct rcu_head		rcu;
> +	int			action;
> +	int			psp_action;
> +	struct metadata_dst	*md;
> +};
> +
> +struct tcf_psp {
> +	struct tc_action		common;
> +	struct tcf_psp_params __rcu	*params;
> +};
> +
> +#define to_psp(a) ((struct tcf_psp *)a)
> +
> +#endif /* __NET_TC_PSP_H */
> diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
> index 28d94b11d1aa..14cff8f5da74 100644
> --- a/include/uapi/linux/pkt_cls.h
> +++ b/include/uapi/linux/pkt_cls.h
> @@ -139,6 +139,7 @@ enum tca_id {
>  	TCA_ID_MPLS,
>  	TCA_ID_CT,
>  	TCA_ID_GATE,
> +	TCA_ID_PSP,
>  	/* other actions go here */
>  	__TCA_ID_MAX =3D 255
>  };
> diff --git a/include/uapi/linux/tc_act/tc_psp.h b/include/uapi/linux/tc_a=
ct/tc_psp.h
> new file mode 100644
> index 000000000000..e58ebcae77be
> --- /dev/null
> +++ b/include/uapi/linux/tc_act/tc_psp.h
> @@ -0,0 +1,28 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +#ifndef __LINUX_TC_PSP_H
> +#define __LINUX_TC_PSP_H
> +
> +#include <linux/pkt_cls.h>
> +
> +#define TCA_PSP_ACT_ENCAP	1	/* attach a PSP association */
> +#define TCA_PSP_ACT_DECAP	2	/* drop PSP Rx state */
> +
> +struct tc_psp {
> +	tc_gen;
> +};
> +
> +enum {
> +	TCA_PSP_UNSPEC,
> +	TCA_PSP_TM,
> +	TCA_PSP_PARMS,
> +	TCA_PSP_PAD,
> +	TCA_PSP_ACTION,		/* u32, TCA_PSP_ACT_* */
> +	TCA_PSP_ASSOC_ID,	/* u32, encap only: Tx association ID from
> +				 * the PSP netlink family (assoc-add)
> +				 */
> +	__TCA_PSP_MAX,
> +};
> +
> +#define TCA_PSP_MAX (__TCA_PSP_MAX - 1)
> +
> +#endif
> diff --git a/net/sched/Kconfig b/net/sched/Kconfig
> index 6ddff028b81a..35f9d76c4cae 100644
> --- a/net/sched/Kconfig
> +++ b/net/sched/Kconfig
> @@ -939,6 +939,19 @@ config NET_ACT_GATE
>  	  To compile this code as a module, choose M here: the
>  	  module will be called act_gate.
>=20=20
> +config NET_ACT_PSP
> +	tristate "PSP encryption tc action"
> +	depends on NET_CLS_ACT && INET_PSP
> +	help
> +	  Say Y here to allow PSP associations, created through the PSP
> +	  netlink family, to be attached to packets. PSP capable devices can
> +	  then encrypt them on transmit. Enables transparent psp tunnels for
> +	  forwarded traffic.
> +
> +	  If unsure, say N.
> +	  To compile this code as a module, choose M here: the
> +	  module will be called act_psp.
> +
>  config NET_IFE_SKBMARK
>  	tristate "Support to encoding decoding skb mark on IFE action"
>  	depends on NET_ACT_IFE
> diff --git a/net/sched/Makefile b/net/sched/Makefile
> index 5078ea84e6ad..9fe8cc0abfdf 100644
> --- a/net/sched/Makefile
> +++ b/net/sched/Makefile
> @@ -31,6 +31,7 @@ obj-$(CONFIG_NET_IFE_SKBTCINDEX)	+=3D act_meta_skbtcind=
ex.o
>  obj-$(CONFIG_NET_ACT_TUNNEL_KEY)+=3D act_tunnel_key.o
>  obj-$(CONFIG_NET_ACT_CT)	+=3D act_ct.o
>  obj-$(CONFIG_NET_ACT_GATE)	+=3D act_gate.o
> +obj-$(CONFIG_NET_ACT_PSP)	+=3D act_psp.o
>  obj-$(CONFIG_NET_SCH_FIFO)	+=3D sch_fifo.o
>  obj-$(CONFIG_NET_SCH_HTB)	+=3D sch_htb.o
>  obj-$(CONFIG_NET_SCH_HFSC)	+=3D sch_hfsc.o
> diff --git a/net/sched/act_psp.c b/net/sched/act_psp.c
> new file mode 100644
> index 000000000000..757b15a812a2
> --- /dev/null
> +++ b/net/sched/act_psp.c
> @@ -0,0 +1,437 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * tc action that attaches a PSP association to packets.
> + *
> + * encap: attach a Tx association referenced by its ID, as a METADATA_PS=
P dst.
> + *        The PSP device's netdev encrypts the packet on transmit. Egress
> + *        only: encap on ingress isn't supported, and drops the packet.
> + * decap: drop the PSP Rx state (SKB_EXT_PSP) of a decrypted packet. It
> + *        takes no association. A rule which should only take the packets
> + *        of one Rx SPI matches what they were decrypted with (flower
> + *        psp_spi / psp_ver / psp_dev).
> + */
> +
> +#include <linux/ip.h>
> +#include <linux/ipv6.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/skbuff.h>
> +#include <net/dst.h>
> +#include <net/inet_timewait_sock.h>
> +#include <net/ip.h>
> +#include <net/netlink.h>
> +#include <net/pkt_cls.h>
> +#include <net/pkt_sched.h>
> +#include <net/psp/functions.h>
> +#include <net/tc_act/tc_psp.h>
> +
> +static struct tc_action_ops act_psp_ops;
> +
> +/* The device inserts UDP + PSP between the IP header and the transport
> + * header, so the transport header must be right by the time the packet
> + * gets there. On a forwarded packet it may not be. Transport mode doesn=
't
> + * support IP fragments or IPv6 extension headers.
> + */
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
> +
> +/* The socket of the packet has its own encryption offload, kTLS or PSP:
> + * sk_validate_xmit_skb() then applies the socket's validator instead of
> + * checking the association.
> + */
> +static bool tcf_psp_sk_offload(const struct sk_buff *skb)
> +{
> +#ifdef CONFIG_SOCK_VALIDATE_XMIT
> +	struct sock *sk =3D skb->sk;
> +
> +	if (!sk)
> +		return false;
> +	if (sk_fullsock(sk))
> +		return !!READ_ONCE(sk->sk_validate_xmit_skb);
> +	return sk_is_inet(sk) && sk->sk_state =3D=3D TCP_TIME_WAIT &&
> +	       inet_twsk(sk)->tw_validate_xmit_skb;
> +#else
> +	return false;
> +#endif
> +}
> +
> +static int tcf_psp_drop(struct tcf_psp *p, struct sk_buff *skb,
> +			enum skb_drop_reason reason)
> +{
> +	tcf_action_inc_drop_qstats(&p->common);
> +	tcf_set_drop_reason(skb, reason);
> +	return TC_ACT_SHOT;
> +}
> +
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
> +		/* Encap on ingress isn't supported: routing replaces the
> +		 * dst of a packet entering the stack, so it would lose its
> +		 * association before it reaches the PSP device
> +		 */
> +		if (unlikely(skb_at_tc_ingress(skb)))
> +			return tcf_psp_drop(p, skb, SKB_DROP_REASON_PSP_OUTPUT);
> +		/* PSP on a tunnel isn't supported: the encap would overwrite
> +		 * the inner headers which the device's tunnel offloads use
> +		 */
> +		if (unlikely(skb->encapsulation))
> +			return tcf_psp_drop(p, skb, SKB_DROP_REASON_PSP_OUTPUT);
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

I'll continue my perf questions! dst_clone() -- potential contention
point/cacheline ping-pong for multiple cores sharing the assoc?

> +		/* Must be encrypted: sk_validate_xmit_skb() drops it unless
> +		 * it still carries the association when it is transmitted
> +		 */
> +		skb->decrypted =3D 1;

My Q on the previous patch -- can this flag be used as a cheaper check?


Bj=C3=B6rn
