Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794712714;
	b=x4FzrZDlUB18ykOXeJueQrdSpdaZLcG2474Z7Y/tNSEhrAZFX55uohD5nzbdWFpNZNT1
	 X6051KtnHRXqKW4Wll3+469o4dy/GAdrdbkclxGIsgf2dGQa7MpzGoeeVvtMQPi8cFYpD
	 9U2Nz+hqlBFAanS9zAuiKDguOv9InWt//EGeAs3u2CKOKY5EkAFdFdAN6v93KiTxmlj5e
	 14TLZHdGUr5QijFxBPv4pjqriQUKKTAwcFezn1pav7AuJAghdgUSbMErrVxecVJSyfzlv
	 j7xLQ00VCBpKrPVFju5jT3r2buuyD1E/CWqRDsb3H3a4XdhzpJWM9cDZHzXEnxsVUxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794712714;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=+59FBjeC7oJeIISLvvUpOT2DqbU3vKBMYCLmewoC1RI=;
	b=DqgkJXKyq+rKsY4NfWZVnUzmG0JF0sHm1oPUqbqtZfx/DLCmx0qysU0sHQTJN06mAiAG
	 HoTq8S6Et/Z0wPxw4qIfiTsgpoUyJRcXQKkNFRt/6s/c7UnmuDYtaxVncCFVJrjwTuVf9
	 MSiu+MbMtMphSZ43UWJ1qDqw/7+khglhv6N4QDWknRCJzc2DjUXZ/0p0p3GBY5TSRLJRZ
	 e7bWXCsRC9a6Io2M0cTVcaIs+Qz7EiNfvq4BAQxkgx9WkH8mNKid5iWDbu8OxfXLb0SWO
	 NmZGHLCS3gtOE8c0pSW9MFVYcjidfu9nXptT25hFkiBlzQ70fhyjeaDumtaUAJFUWhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UPuqxtZc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8E2606A32D;
	Sun, 15 Nov 2026 03:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UPuqxtZc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2740E1F000C5;
	Sun, 15 Nov 2026 03:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794712713;
	bh=+59FBjeC7oJeIISLvvUpOT2DqbU3vKBMYCLmewoC1RI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=UPuqxtZcJdwdzUfuxpVQNuzKP4twGxU2Z6Sz2Z1qo2d6Y0jUrWfOZ6MRuuSsKd2RL
	 LVkV/zUaQnwK91FoulDf967oMn5AXcJ0zWjEUqT+9oOJV5DjRSYIfoANw/RLLv1gSX
	 FmZEuAhVI8dNRT2E3vCZnqvA8TXP2IqLmsynZL/1nNLiCtRkbSu+eDg/WM4zwi08TH
	 Xg8S8g9y/bKIFxMdroqgPEvVvHJoS5EkpdCG5Eizn4ld0QfR6L6vtvo6NuqK0NRZsN
	 eItDKT458CZMdP6tPF/w6y69DGGCHbJqsDFMz7ED2OqOT/a4GVXJz54H7Vx0/DQtx7
	 DCY8x+syaNojQ==
Subject: Re: [PATCH net-next v1 15/15] Documentation: networking: psp:
 document socket-less associations
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
Date: Sun, 15 Nov 2026 03:18:31 +0000
Message-ID: <179471271167.2199510.6222235735319435450@kernel.org>
In-Reply-To: <20261111005533.6436-16-toddfreed@meta.com>
References: <20261111005533.6436-16-toddfreed@meta.com>
X-sashiko-severity: Low
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

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The new psp.rst text says, in the `psp encap assoc ID` bullet,
  "Encap on ingress is hardware offload only." The header comment of…
- [Low] In psp.rst, the `psp encap assoc ID` bullet says: "If the
  association is removed before transmit, or if the packet is…
- [Low] In the flower paragraph, psp.rst says the `psp_spi`, `psp_ver`
  and `psp_dev` matches together "tie a decap rule to one Rx…

--

Documentation: networking: psp: document socket-less associations

This commit reorganizes the PSP documentation around associations. It
documents the new netlink commands for socket-less associations, the psp
tc action and the flower psp_spi, psp_ver and psp_dev matches. It also
adds sections on fragments and on PSP device statistics.

> diff --git a/Documentation/networking/psp.rst b/Documentation/networking/psp.rst
> index 0f9b6b73f2447..79b101db5dfc4 100644
> --- a/Documentation/networking/psp.rst
> +++ b/Documentation/networking/psp.rst

[ ... ]

> @@ -140,6 +162,55 @@ The PSP assoc state of a socket is not reset when the connection is
>  torn down. ``connect()`` on a socket that has PSP assoc state will
>  return ``-EINVAL``.
>  
> +Socket-less associations
> +~~~~~~~~~~~~~~~~~~~~~~~~
> +

[ ... ]

> +- ``assoc-del`` deletes an association. tc actions and packets which still
> +  reference it keep it alive. The device keeps decrypting the SPI of a
> +  deleted Rx association until its device key is rotated out: remove the
> +  decap rule to stop taking its packets.

[ ... ]

> +- ``psp encap assoc ID`` attaches a Tx association. The packet must then
> +  be transmitted on the main netdev of the association's PSP device, which
> +  encrypts it (``mirred egress redirect``). If the association is removed
> +  before transmit, or if the packet is transmitted on any other device,
> +  it will be dropped, rather than sent in the clear. Encap on ingress is
> +  hardware offload only.

[Severity: Low]
Is the part that says "If the association is removed before transmit ...
it will be dropped" accurate? It conflicts with the assoc-del bullet above
and with the assoc-del doc in Documentation/netlink/specs/psp.yaml:

    Packets and tc actions which still reference it keep it alive.

In the code, psp_nl_assoc_del_doit() only calls psp_assoc_unpublish().
That removes the ID from the registry and drops the registry's reference:

net/psp/psp_assoc.c:psp_assoc_unpublish() {
    ...
	if (xa_cmpxchg(&psp_assocs, pas->id, pas, NULL, 0) == pas)
		psp_assoc_put(pas);
    ...
}

The METADATA_PSP dst created by tcf_psp_md_create() keeps its own
reference. tcf_psp_act() also keeps attaching dst_clone(&params->md->dst)
to every packet.

On transmit, psp_xmit_md() checks only the device and the MTU. It never
checks whether the association was deleted:

include/net/psp/functions.h:psp_xmit_md() {
    ...
	if (rcu_access_pointer(dev->psp_dev) != pas->psd ||
	    dev != pas->psd->main_netdev)
		return -EINVAL;
    ...
}

So after assoc-del, packets are still encrypted and sent with the deleted
association's key until the tc action is removed. A drop seems to happen
only when the packet loses its METADATA_PSP dst, or when the PSP device
does not match or has been unregistered.

Would "if the packet loses its association on the way (e.g. its dst is
replaced)" describe this more accurately?

[Severity: Low]
Is "Encap on ingress is hardware offload only" accurate for this series?
act_psp_ops in net/sched/act_psp.c does not set .offload_act_setup:

static struct tc_action_ops act_psp_ops = {
	.kind		=	"psp",
	.id		=	TCA_ID_PSP,
	.owner		=	THIS_MODULE,
	.act		=	tcf_psp_act,
	.dump		=	tcf_psp_dump,
	.init		=	tcf_psp_init,
	.cleanup	=	tcf_psp_cleanup,
	.size		=	sizeof(struct tcf_psp),
};

Because of that, tc_setup_offload_act() in net/sched/cls_api.c rejects the
action:

	} else {
		NL_SET_ERR_MSG(extack, "Action does not support offload");
		return -EOPNOTSUPP;
	}

In software, tcf_psp_act() always drops encap at ingress:

		if (unlikely(skb_at_tc_ingress(skb)))
			return tcf_psp_drop(p, skb, SKB_DROP_REASON_PSP_OUTPUT);

So ingress encap cannot work in any configuration today. The flower commit
in this series says offload will come in a follow-up series.

Should this say that ingress encap is not supported (the packet is always
dropped) and that hardware offload is future work? The header comment in
net/sched/act_psp.c makes the same claim.

[ ... ]

> +The flower classifier matches what a packet was decrypted with:
> +``psp_spi SPI[/MASK]``, ``psp_ver VERSION`` and ``psp_dev DEV_ID``, the
> +ID of the PSP device which decrypted it. These never match a clear text
> +packet, so ``psp_spi 0/0`` matches any packet decrypted with PSP.
> +Together they tie a decap rule to one Rx association.
> +
> +Once the device key an SPI was created from has been rotated twice, that
> +association is considered stale. Unlike sockets, tc does not handle key
> +rotation. userspace should replace such rules before two rotations.

[Severity: Low]
Does "Together they tie a decap rule to one Rx association" overstate what
the match guarantees? The flow key built by skb_flow_dissect_psp() carries
only these fields:

	key->spi = pse->spi;
	key->dev_id = pse->dev_id;
	key->version = pse->version;
	key->present = 1;

It has no key generation and no association identity. SPI values get
reused after key rotation. For example, nsim_key_rotate() in netdevsim
resets the SPI counter:

	if (ns->psp.spi & PSP_SPI_KEY_PHASE)
		ns->psp.spi = 0;
	else
		ns->psp.spi = PSP_SPI_KEY_PHASE;

After two rotations, the same SPI can be given to a different peer or to a
socket association under a new key. If the old decap rule is still in
place, it would strip SKB_EXT_PSP and skb->decrypted from that other
association's packets and forward them.

PSP device IDs are also allocated cyclically in a 16-bit space in
psp_dev_create():

	err = xa_alloc_cyclic(&psp_devs, &psd->id, psd, xa_limit_16b,
			      &last_id, GFP_KERNEL);

After enough unregister/register cycles, a stale psp_dev match could end
up matching a different device.

The next paragraph says userspace should replace rules before two
rotations. It does not say that a stale rule will match other
associations' traffic, and it does not mention device ID reuse.

The flower commit in this series says "the generation of the device key is
not checked". Could the doc include the same qualification here?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261111005533.6436-1-toddfreed%40meta.com
