Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794187382;
	b=d5BVAeQ+X1MffJRJJGKVFYBqpUmkqI3cEafhrwHrtKRs4j2jyOzkVF4l2vXQyC4xNRYf
	 vtg1JdimJ7lMWZd15b6wKWf1JEDygHoX1LHEPkbw1NH6lWrEaB3fpiaWy1+7ghiDaORiy
	 vZkD3W87E9fnGuVoTnu/1NmNHoNyocTNJGZbDTEXa7PJF2xRccZMewZYp34ovRskmQQoP
	 1n4x0opvV5ZZeN/8mEdAsNhKK918NLXHKhVhkxxcSLWUj+piKW6R9ghu+YbpFLoTBQDBi
	 50D/scJ5hQp4c3P2KKt5m2TRka9lMNrKJjyybdENOMr8c01vG1FLn/4iNX6hycQK1wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794187382;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=L7Ie4rh+uYGxiq2YkIEoTSDrjYWbd6DHs/eMTJlEa9Q=;
	b=L4qn7c0ejwwNUhu9T1nQd1jFEZfz9S+rbjOb3cy/gw3IHxWYGQr0pwBueM1Hd49tbxok
	 j60qBwFFKq5Sa4IrMigm/WVyYqDZWxhYvgizxqV+EP9PyXyNCTWOW2Vi3GR2Rm1LCZ1h8
	 hwv8keE00wtS4jQXRTniabSNOWiku+lj5liM+S/c8AsfL2o1QPYe9Iu87Ps56744sjyb6
	 v7Q3mm5L0ZQzKA515Nk0cGbASfOmFa8OBspTRVDB//wjUcYer1sIyD+cUSFyRsVb5IuOs
	 9L0MxTAbk1cHQU+sTSBBaiR86AqQ6FPNj839CAvmcLTWzdIkCnaWjSGlh/DlJyE7BwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WtqNDTYG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E89608361C;
	Mon,  9 Nov 2026 01:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WtqNDTYG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D811F008A3;
	Mon,  9 Nov 2026 01:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794187381;
	bh=L7Ie4rh+uYGxiq2YkIEoTSDrjYWbd6DHs/eMTJlEa9Q=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=WtqNDTYGMKb1uwgxb3dvg8Tbu0JhIG5QgTYAcstBRvzVLdAHT6iFj1a14W3RdmqBZ
	 NyHNPWoTXkn8hirfreV9or1CBrFcQqNgboycfQb7tyDEbyb4s+3YJm7/2FFLW902bu
	 ia0uF/sDR1+052W50w95+mg6hNMhjtyijlX4Hr6DCEcAf/8ixUA9hUNe1tllof4n48
	 yFehCNNp39ouaAgwF7/8y7OT22nk5cbHhwVvQhHo8ZLJIuIEAhzit0Y/gR7r4HE3qc
	 sLSyxSfMjslU7mv3aWX2VCxExr3aytLZ2HjJMHhhq6J6ihRwkHChlEYFeS4nhSwRI1
	 POlwnWoM1gtrw==
Subject: Re: [PATCH net-next v3 5/9] bnxt_en: set the netmem TX frag size
 limit to 32KB
From: netdev-bot+sashiko@kernel.org
To: sdf.kernel@gmail.com
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, andrew+netdev@lunn.ch,
 edumazet@kernel.org, horms@kernel.org, corbet@lwn.net,
 skhan@linuxfoundation.org, rdunlap@infradead.org, michael.chan@broadcom.com,
 pavan.chebbi@broadcom.com, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, alexanderduyck@fb.com, kernel-team@meta.com,
 sdf@fomichev.me, dimitri.daskalakis1@gmail.com, almasrymina@google.com,
 dtatulea@nvidia.com, bobbyeshleman@meta.com, asml.silence@gmail.com,
 daniel@iogearbox.net, razor@blackwall.org, leitao@debian.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org, leon@kernel.org
Date: Mon, 09 Nov 2026 01:22:59 +0000
Message-ID: <179418737922.994134.6838913010792422653@kernel.org>
In-Reply-To: <20261105222058.944293-6-sdf@fomichev.me>
References: <20261105222058.944293-6-sdf@fomichev.me>
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

- [Low] This patch fixes a real bug in released kernels but has no Fixes:
  tag, and it does not say that it depends on the earlier patch in this…

Pre-existing issues:
- [High] bnxt_start_xmit() still writes non-netmem page frag lengths
  straight into the 16-bit TX BD length field (TX_BD_LEN = 0xffff << 16).

--

bnxt_en: set the netmem TX frag size limit to 32KB

This patch sets dev->netmem_tx_max_frag_size to SZ_32K in bnxt_init_one().
That caps netmem TX frags at the largest power of 2 that fits in the 16-bit
TX BD length field. With 64K pages this lowers the PAGE_SIZE default, so
64KB devmem frags no longer wrap the BD length to 0 with BIG TCP.

> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> index f20b61180ab2d..4bcf84faf18f1 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -17471,6 +17471,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	if (BNXT_SUPPORTS_QUEUE_API(bp))
>  		dev->queue_mgmt_ops = &bnxt_queue_mgmt_ops;
>  	dev->netmem_tx = NETMEM_TX_DMA;
> +	dev->netmem_tx_max_frag_size = SZ_32K;

[Severity: Low]
The commit message says:

  With 64K pages it lowers it, 64KB frags would otherwise wrap the BD
  length to 0 with BIG TCP.

Isn't this a bug that already exists on 64K-page kernels, rather than a
side effect of the new limit?

Before this series, net_devmem_get_niov_at() returns size = PAGE_SIZE - off,
and zerocopy_fill_skb_from_devmem() applies no other cap. With BIG TCP, an
aligned devmem send can produce a 65536-byte frag. bnxt_start_xmit() then
does:

    flags = len << TX_BD_LEN_SHIFT;

which leaves 0 in the 16-bit length field.

Should this patch carry a Fixes: tag for commit 4922ca773d9d ("eth: bnxt:
add netmem TX support")?

This change also only works together with "net: devmem: add a per-device
netmem TX frag size limit". That patch adds dev->netmem_tx_max_frag_size and
binding->tx_max_frag_size, and it has no Fixes: tag either.

Without the tags and a note about the dependency, stable kernels on 64K-page
systems (arm64 64K, ppc64) would keep the wrap. Would a separate minimal fix
for the net tree work better?

[Severity: High]
This isn't a bug introduced by this patch, but the same 16-bit wrap still
looks reachable for frags that are not netmem. bnxt_start_xmit() writes
every frag length straight into the TX BD:

    len = skb_frag_size(frag);
    ...
    flags = len << TX_BD_LEN_SHIFT;
    txbd->tx_bd_len_flags_type = cpu_to_le32(flags);

TX_BD_LEN is defined as (0xffff << 16), and the length is not clamped or
split. Meanwhile the DMA mapping and dma_unmap_len cover the full frag.

The new limit is only applied in zerocopy_fill_skb_from_devmem(), through
binding->tx_max_frag_size. bnxt enables BIG TCP via
netif_set_tso_max_size(dev, GSO_MAX_SIZE) in bnxt_init_one(). That means
ordinary page frags can reach 64K or more.

On 64K-PAGE_SIZE kernels, SKB_FRAG_PAGE_ORDER is 0, so
skb_page_frag_refill() hands out 64K pages. tcp_sendmsg_locked() can then
coalesce data into one frag of a full 65536 bytes. Sendfile or splice of a
full 64K page-cache page gives the same result.

On any page size, MSG_ZEROCOPY on a THP or hugetlb buffer goes through
zerocopy_fill_skb_from_iter(). That function merges contiguous subpages of
the same compound head:

    if (head == skb_frag_page(last) &&
        start == skb_frag_off(last) + skb_frag_size(last)) {
        skb_frag_size_add(last, size);

so a single frag can be larger than 64K.

In these cases, can the NIC get a BD whose length (len mod 64K, or 0) does
not match the mapped buffer? That could produce malformed TSO segments or a
TX timeout.

The RX side already handles this limit. bnxt.h has the comment "The RXBD
length is 16-bit so we can only support page sizes < 64K". There doesn't
seem to be an equivalent check on TX, for example in bnxt_features_check()
or bnxt_start_xmit().

BIG TCP has been enabled in bnxt since commit b6488b161ab2.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261105222058.944293-1-sdf%40fomichev.me
