Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794187384;
	b=g/Pw4i4TMOTfGO31t/As8Mz0ZskajtOlSaxe9+BzTZh20AQK1AllhHrzvtq2+0Lpa54t
	 UjzC2T9toZIhh1n2JuPasFfISI4M5jxGMLa8ZRg7UeLZ0N3fn8x6aRinkI0RizznjBlgZ
	 e0JMM4QZdslI0Nj8N4FPNpII+htIxYlUwDOOfKZ/+gtWt1LoEi6KcjcjImGYeD7IP6eaX
	 nGdpGzPbOvgJ4PTewntolmYydFzwkSF3w9JBKN23AF9rC3WLhA7ubbBW6CeZYSlO9+xGC
	 8qIkSBQV7nDZVX8NZPBWhFbbaZoRu7BxIUl5k+V6RpsPZPPWemE56UnyDs2lWxwNLRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794187384;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=s1zfZI8JUKbwHpOBFW8jIWnPvQkeTTvTBB5i5S2oBVk=;
	b=YQIJzXnhwe83axsOvxHVQwa6cc8UgfldHKszUe30RY/QZluvflNgDHNg2D+NxksQ65fK
	 0g+79P7VbWgwuMfoNoNCaNK3OuQtuhKtSLi2i2IhbIzi3CQMhcL2jQxjr0kOyaRm1zwzg
	 vN5fqk3eZ5NF8hZ0IohUMvjtQzL2vnHj/9FcoZNabWAwYj476KYUbhpQOvGul+5m3W39X
	 eIhWWe0j/96ILCskeud/qmp1V4Pwppidq6zCR8DVNcpJ2DQ2VmTP3FHsHal6S+WOW2pyn
	 M1eSy7bWqSYKBtIF7o2anjMiS2rL4pGBW9vuEImal3Kl5BUlrhGSbvhk2i28O2VW64w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eFgOmI1g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4301960A261F;
	Mon,  9 Nov 2026 01:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eFgOmI1g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BF71F008A4;
	Mon,  9 Nov 2026 01:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794187383;
	bh=s1zfZI8JUKbwHpOBFW8jIWnPvQkeTTvTBB5i5S2oBVk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=eFgOmI1gXbfWdehEgTIKPRe6pmpqRDxvFxrUbb8Em0Pdf8rwV/zuX5KxwfD/Ad8UQ
	 gVPA2kPimxvV3Xx3Q7ld8ewYT9GgXZpyLR13ydQJw5nvJbvY1dQKstvSFPf09ZZn0M
	 +81pCmKApQ4tkM4QpnZwMaYNaEm+jpm4xPMYnL5ZvZsgNLy5vSPcE/7YPdle095wpp
	 jGNPzflJK6aLnYEAEf8PKPjbaOAK76vqk6wL7gTme295OQhfLaC+goDUe9GMu/sTQ0
	 SoHWyED4V0oEL8i34DH9yQJimUD/i4sk+KtfhARI5mNTt6cBFnCQh7EL1/QYhrMBR/
	 pRAWXx/TTweCw==
Subject:
 Re: [PATCH net-next v3 7/9] net/mlx5e: lift the netmem TX frag size limit
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
Date: Mon, 09 Nov 2026 01:23:01 +0000
Message-ID: <179418738174.994134.464817117967884735@kernel.org>
In-Reply-To: <20261105222058.944293-8-sdf@fomichev.me>
References: <20261105222058.944293-8-sdf@fomichev.me>
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

- [Low] This patch sets `netdev->netmem_tx_max_frag_size = U32_MAX` in
  `mlx5e_build_nic_netdev()`…

--

net/mlx5e: lift the netmem TX frag size limit

This commit sets netmem_tx_max_frag_size to U32_MAX for mlx5e NIC netdevs.
The commit message says mlx5 TX data segments have a 32-bit byte count,
so devmem TX frags don't need a size limit.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index c3c2c5720c6f3..28ba04bd5f4a4 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -5967,6 +5967,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
>  	netdev->priv_flags       |= IFF_UNICAST_FLT;
>
>  	netdev->netmem_tx = NETMEM_TX_DMA;
> +	netdev->netmem_tx_max_frag_size = U32_MAX;

[Severity: Low]
Is U32_MAX really the largest length an mlx5 data segment can describe?
The commit message says:

  TX data segments have a 32-bit byte count, so devmem TX frags don't
  need a size limit.

Bit 31 of byte_count looks like it is the inline segment marker rather
than part of the length:

include/linux/mlx5/device.h:
	MLX5_INLINE_SEG = 0x80000000,

The mlx5 IB ODP WQE parser reads it the same way:

drivers/infiniband/hw/mlx5/odp.c:
	inline_segment = !!(byte_count &  MLX5_INLINE_SEG);
	bcnt	       = byte_count & ~MLX5_INLINE_SEG;

The mlx5e XDP, IPsec and PSP TX paths also OR this bit in to mark inline
segments. That leaves 31 bits for the length of a pointer segment.

mlx5e_txwqe_build_dsegs() stores the frag size in a signed int and writes
it to byte_count without masking:

drivers/net/ethernet/mellanox/mlx5/core/en_tx.c:mlx5e_txwqe_build_dsegs() {
    ...
		int fsz = skb_frag_size(frag);
    ...
		dseg->byte_count = cpu_to_be32(fsz);
    ...
}

If a frag of 2^31 bytes or more ever got here, fsz would be negative.
The pointer segment would also have the inline bit set, so the WQE would
be malformed.

Today nothing can trigger this. net_devmem_bind_dmabuf() is called with
niov_shift=0 for TX, so the net_iov size is at most SZ_2M. Each frag in
zerocopy_fill_skb_from_devmem() is limited by that size.

The documented contract in Documentation/networking/netmem.rst still
says:

   Drivers which can describe larger TX buffers
   may raise it, up to the largest buffer a single TX descriptor can
   describe.

zerocopy_fill_skb_from_devmem() also relies on this value as the
per-device bound:

	size = min_t(size_t, size, binding->tx_max_frag_size);

Would a value that matches the hardware, such as (1U << 31) - 1 or SZ_1G,
work better here? The commit message would need updating to match.

>
>  	netif_set_tso_max_size(netdev, GSO_MAX_SIZE);
>  	mlx5e_set_xdp_feature(priv);

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261105222058.944293-1-sdf%40fomichev.me
