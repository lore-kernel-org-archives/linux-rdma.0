Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0707837DE87;
	Thu, 10 Sep 2026 22:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789079124; cv=none; b=BcGk+yhRIOHCjBNYt8XfpAtwkvWlfnWstm/3I114luUEoTTaJ3dfVDHrfE90dB7EFMH8/VZkd0CgMVUAED/7yzRL3Pc/DHBSP+gPxzaxYDlKUUer3V04/EwcF7gQ+lTUsVUsjQoBcf+Nc8xWFbDDzMKty/5k1XdtvsfnZHfombs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789079124; c=relaxed/simple;
	bh=bCDvU6k0UQB4HZA38twy5uM9TwHPt1eL6ovwoh9T6xk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IKisxLfqQhp20tS4TxolqsxaUECQCaqT3hgqN+UnF6AqwertPYpEICPqkucYsuqFI6Q7F1L2RSKfOdSb7jpX6wyIamg371k4EuhJCws2f5OUjSrdOiwvwcG7pFmhIPTOEfPPnPOAigCvsk7py9/MGUYJgpCYEp5i7uHOhruQoqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D41IcFic; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D41IcFic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53AAB1F00893;
	Thu, 10 Sep 2026 22:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789079119;
	bh=k+8vI9eOiydSGYvJI6hXwfTHWF56pl4lnl96BaED+VU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D41IcFiciJTkLljALxku+S++ooj2BtbLRPMeCx6HDlzp1JFWpptdDC55CFLoXq8hp
	 O/bnuvWHASLJam8pJpAHFodazY01c0uSXdmJuwWW7W3pP3sIOjDUiQJnwRRdwxbrJE
	 QO7SWUNMh2NgVYCHB5sZe1A3bYpUtT3EAiU0KwESLclGXyN4oEYPEIaWnYJw0ezvu4
	 KhUuLfDPrSP/INrqvRR4MHg2olSGfy2ICWOt1fXTgoa4I13gp/xu98gk47XHynd+eb
	 XB2HKHFhc4ag3Y1ro2aJpIXlbE0/JfGJCcVwtTHhlDqtfAoAe+bujQj6b59yLnvTMJ
	 /4ge7yzJNYxag==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v5 08/13] net: mana: do not bail out of
 mana_detach on dealloc failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <20260909222416.884246-9-longli@microsoft.com>
References: <20260909222416.884246-1-longli@microsoft.com>
 <20260909222416.884246-9-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 22:25:18 +0000
Message-Id: <20260910222519.53AAB1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Dereferencing IP and IPv6 headers without ensuring they are in the=
 linear region of the socket buffer.
- [Medium] Concurrent writers to `tx_stats->syncp` without mutual exclusion=
 in `mana_xdp_xmit`.
--

commit 2b1d4ae0b77c96383014b2acf0502fef542484c7
Author: Dipayaan Roy <dipayanroy@linux.microsoft.com>

net: mana: do not bail out of mana_detach on dealloc failure

Remove the early return after mana_dealloc_queues() so detach continues
its device and port-context cleanup. The return is currently unreachable:
mana_dealloc_queues() only rejects an up port, and mana_detach() clears
port_is_up before calling it. This is a robustness cleanup, not a fix for
a reachable reset failure.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/=
ethernet/microsoft/mana/mana_en.c
> index 62c11af2fc422..5752e3745ccc6 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -4340,10 +4340,8 @@ int mana_detach(struct net_device *ndev, bool from=
_close)
> =20
>  	if (apc->port_st_save) {
>  		err =3D mana_dealloc_queues(ndev);
> -		if (err) {
> +		if (err)
>  			netdev_err(ndev, "%s failed to deallocate queues: %d\n", __func__, er=
r);
> -			return err;
> -		}
>  	}
> =20
>  	if (!from_close) {

[ ... ]

> --- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
> @@ -76,9 +76,9 @@ int mana_xdp_xmit(struct net_device *ndev, int n, struc=
t xdp_frame **frames,
>  	}
> =20
>  	tx_stats =3D &apc->tx_qp[q_idx]->txq.stats;
> =20
>  	u64_stats_update_begin(&tx_stats->syncp);
>  	tx_stats->xdp_xmit +=3D count;
>  	u64_stats_update_end(&tx_stats->syncp);

[Severity: Medium]
This is a pre-existing issue, but does mana_xdp_xmit() safely update
the stats sync seqcount without mutual exclusion?

The u64_stats_sync API requires writers to be mutually exclusive per syncp
instance. Here, q_idx is calculated as
smp_processor_id() % ndev->real_num_tx_queues, and tx_stats->syncp is
updated without holding __netif_tx_lock.

Because q_idx can be targeted by normal stack TX via
skb_get_queue_mapping(skb), could another CPU concurrently execute
mana_start_xmit() for the same queue (which correctly holds
__netif_tx_lock and updates tx_stats->syncp)?

Also, if there are more online CPUs than configured TX queues, could
multiple CPUs running mana_xdp_xmit() map to the same q_idx and execute
u64_stats_update_begin() simultaneously?

This concurrent write access violates the u64_stats_sync writer rules,
which can corrupt the sequence counter and cause lost or torn updates.

[ ... ]

> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -167,7 +167,7 @@ static unsigned int mana_checksum_info(struct sk_buff=
 *skb)
>  {
>  	if (skb->protocol =3D=3D htons(ETH_P_IP)) {
>  		struct iphdr *ip =3D ip_hdr(skb);
> =20
>  		if (ip->protocol =3D=3D IPPROTO_TCP)

[Severity: High]
This isn't a bug introduced by this patch, but does this code safely
dereference the IP and IPv6 headers without ensuring they are in the linear
region of the socket buffer?

In mana_start_xmit(), if skb->ip_summed =3D=3D CHECKSUM_PARTIAL, it calls
mana_checksum_info(skb). This function directly calls ip_hdr(skb) and
ipv6_hdr(skb), and immediately dereferences ip->protocol and ip6->nexthdr
without calling pskb_may_pull() or using skb_header_pointer().

Since packet headers injected from userspace (e.g. via AF_PACKET/tun with
virtio_net_hdr) can place the IP header entirely in paged fragments rather
than the linear data area (skb->data), couldn't failing to linearize the
header before dereferencing risk reading garbage data or causing
out-of-bounds page faults?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909222416.8842=
46-1-longli@microsoft.com?part=3D8
