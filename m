Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795611618;
	b=QYfu7/FxxJXBZdTRSeTelSEwFOrgLJW9TnzF2yeKmTNPkirSVkbHwxrWVYdZPALAz91J
	 COV0oXJdAGwWtrMFWG84ST+ISxVG1vSXLcFgouIfHBpISUTD5MZmNlGwBIfcK8pVjAtoF
	 CzxwTOJ+9yjQNrED+pzMHgLHgdNrF7jzg8YZNxyjfZbDcnnmD75D1Gw+crQUauX3gKR2/
	 y85U52tkKlLVU+I2wL3pQrJ9/62TFgEDBnKw2l4Y+qXoWpde96HezApl2bg8po/P8s6o6
	 6UL3+KBUsxwLtipnrIIaQfc0MBpJPHCfpaJS63tmXtALTaZbERTJy4CH+B+ZaH/EX4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795611618;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=oG5Z94jgPYm5ci2WRiQkCVsocHDva4LGd0PPItvyP88=;
	b=rDDW8HpaWp8t6UnIdqo7stN4R5fM51ueG+CSeY1IzX7Z2N29qwkj2oKVTouhxvGEQNWq
	 s2KORvfwtEP3UeIxLxiuvS6xnQ8OvUpNXm+o1W7wTO72cF3oPiV2Vxl8dUu2+TfE9fHgR
	 1ay62aOBmP+e1dcf91mE/+/fQVcXe30mO3QFj3t5gx5myDR78stxf2Bd9AFKSITjuSQEu
	 0vRRv4RssXbl7Jh1n8ugWLmIcgu3NpXs6slMp2IsoxNDywMcj0puKXakiTvft+5L4+5B2
	 0qtlUvmHmXBlcaPNH+5/Q2eKraP+1MidGiuRJcEBqWSn0eGvBHRVaxbfIqD6z5hZwqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N9FlAu5M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085DE606A696;
	Wed, 25 Nov 2026 13:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N9FlAu5M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EE7C1F000F2;
	Wed, 25 Nov 2026 13:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795611617;
	bh=oG5Z94jgPYm5ci2WRiQkCVsocHDva4LGd0PPItvyP88=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=N9FlAu5MJkmV6qFKhmU/XIkI8Lp1FtZp/OtMjBGhNax7LyYpaJ8YZWoBWUxmGum+o
	 uz3g3606+lSbIxP6v0hZZd5toF+ZKrQgGVyNJ41DHc1R1mAdUb7d8L92khjyoz95sy
	 b9QT+eG0VT32LWlg8+tWUavNP9q2N4uibEH1SOAng6ywEE+3hu89Cup7t8Lojz7nJF
	 JfKRJ0d574B+8UDIJIRkxf0MVgmaXHFW1pwtOkgexlgjgIdvmLw41syoFi2gvq2cC+
	 z5OYqkRM7yerr6bUmR+fEPNhSNnlYwQSjjhsmKtzPErDROOZJ5M+sg1yiR2E4ZWk2C
	 wcILjf5lyDzKA==
Message-ID: <sashiko-outbox-233423@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 13/15] eth: bnxt: Receive into XDP-only memory
 providers
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>, bpf@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261124125654.183091-13-bjorn@kernel.org>
References: <20261124112707.118678-1-bjorn@kernel.org>
 <20261124125654.183091-13-bjorn@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 13:00:17 +0000
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
- [Medium] eth: bnxt: permanent RX queue stall when XDP-only FILL ring
  is empty at setup
--

commit 216a70ae81e1efc56a16448ea5bf41a5bbbd9619
Author: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>

eth: bnxt: Receive into XDP-only memory providers

This commit converts RX page-mode heads and XDP fragments in bnxt to use
netmem and enables PP_FLAG_ALLOW_XDP_ONLY_NETMEM on the RX page pool.

> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethe=
rnet/broadcom/bnxt/bnxt.c
> index 5c6c2219a481c..465465db53ba4 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
[ ... ]
> @@ -3969,7 +3951,8 @@ static int bnxt_alloc_rx_page_pool(struct bnxt *bp,
>  	pp.dma_dir =3D bp->rx_dir;
>  	pp.max_len =3D PAGE_SIZE << pp.order;
>  	pp.flags =3D PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV |
> -		   PP_FLAG_ALLOW_UNREADABLE_NETMEM;
> +		   PP_FLAG_ALLOW_UNREADABLE_NETMEM |
> +		   PP_FLAG_ALLOW_XDP_ONLY_NETMEM;
>  	pp.queue_idx =3D rxr->bnapi->index;
> =20
>  	pool =3D page_pool_create(&pp);

[Severity: Medium]
Can an RX queue stall permanently if the AF_XDP FILL ring is empty when the
queue is allocated or reconfigured with an XDP-only memory provider?

When userspace binds an AF_XDP sink before populating the FILL ring (or
reconfigures the queue while all UMEM chunks are in use),
bnxt_queue_mem_alloc() -> bnxt_alloc_one_rx_ring_skb() fails on the first
descriptor and starts the ring with rxr->rx_prod =3D=3D 0:

drivers/net/ethernet/broadcom/bnxt/bnxt.c:bnxt_alloc_one_rx_ring_skb() {
    ...
	for (i =3D 0; i < bp->rx_ring_size; i++) {
		if (bnxt_alloc_rx_data(bp, rxr, prod, GFP_KERNEL)) {
			netdev_warn(bp->dev, "init'ed rx ring %d with %d/%d skbs only\n",
				    ring_nr, i, bp->rx_ring_size);
			break;
		}
		prod =3D NEXT_RX(prod);
	}
	rxr->rx_prod =3D prod;
    ...
}

Because bnxt only refills RX buffers inside bnxt_rx_pkt() when processing an
RX completion, waking NAPI via xsk_sink_wakeup() after populating the FILL
ring returns from __bnxt_poll_work() without allocating any descriptors,
leaving the RX queue wedged with zero posted buffers.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124112707.1186=
78-1-bjorn@kernel.org?part=3D13
