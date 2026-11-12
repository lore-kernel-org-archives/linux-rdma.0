Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=68.232.153.233
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794491032;
	b=M3yzK4EMTj3yIxAEIRy7h7d4j6kNv2nkhAnjhuMZP2WJcFM3J5orztYv/x43YRswcb5L
	 LOEbL8ndXUgx8g2wcuId8vQ4cUzXpc9SM1dakukzC+xPnOGqFMouiFP5Uq6cpM/shQuud
	 dq8TbuBlxoaEdePclUM8VfZnZOcj4Xltzr7sU5yN1UCw2LoyfRhaDtozwmzC9ZAIj4J/D
	 jqKdZULsqyX4DTywy9Zd9ps2ZmEXldUED9IslNnriYr2oQyinm468vzYEJgp+lJMPuo9n
	 3+f21FYCxeHUAjxLtLiWgekCK5PkyKvU9aObYuGkGhXGjf1hROMDjWLsf0N4EX9fCLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794491032;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-Amp-Result:Received:Received:Received:Date:From:To:CC:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=VxOpdanBTNNue1alsU1irSoWxQrGWAWPxOQ3iRVu+z8=;
	b=J2CJQUwB6JUSdzZ89dT9P9518VN+mRxgM0gYpdnMnbHXIjNxsaItQk7s91hviLV5SkOC
	 4f/YIwqhNQGLgGwofuLHyJVmHmamcKFWaz5sFnqpxQhczoKrAQ1R9PHhZ8tGj2+8dlKNE
	 KMUOJCU5eJZsFGHOonZjcpfcFyRM9/cr3AgcuDAu9AVvlPfeLFIbB+xXgUUJsVDJQPrc4
	 isp2iTI1foXlCofw2Jb0xru2iD3m4QS6UnbQX6SCbj5/VrFGPARFFwCsJwUAaicYrSHPN
	 cVNmRsb4hpfxRd2Pn98TzMLkFpDEKP3Je+vlRmPvDCUZakhcyEDQSLmNUpwdRQIPxbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=microchip.com;
	spf=pass smtp.mailfrom=microchip.com;
	dkim=pass header.d=microchip.com header.i=@microchip.com header.a=rsa-sha256 header.s=mchp header.b=HiEsg05j;
	arc=none smtp.remote-ip=68.232.153.233
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC219606A31C;
	Thu, 12 Nov 2026 13:43:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC219606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.a=rsa-sha256 header.s=mchp header.b=HiEsg05j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1794491031; x=1826027031;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LoKVXxBlF6G5G7uhLeP+QLHXu/VsSMcYJ+6Nn7/f51k=;
  b=HiEsg05j6CAKZhmTN+1BtvB2Rs/ivtWVO3lQVNFABLjfYdgXay+pO4tH
   v8i9JJ14YvJWNpAX6eECrbZzmank9idS2gKADRHbykhZxZYhuh/GjnqEg
   ZOE72pXSnb0fMWYwV1jBw9clBE1FvuVaI65jCvHFBz71a8kPgVW8l5RPn
   4Ju6Sk7hR7IikBIKQdjX3hR++vSC3nh4icQtzJvUDyF3HHGSWSyrdOWQz
   QWP+S7Wtmz/wjOEtOIt+GO6GwFsWHbecM3bmbnWZJuo+/QxTlfo/J22ZN
   2kPHAw/t02jVu0kVbzfxj8ifw1RoO6OaJHy8w3Fx2TlQgiymvhLBay4re
   Q==;
X-CSE-ConnectionGUID: AkdiOhkuQuO+skhyaRgHVA==
X-CSE-MsgGUID: Zxbb6DEXR6G8pGhS+ZKjaA==
X-IronPort-AV: E=Sophos;i="6.27,209,1787036400"; 
   d="scan'208";a="297833517"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 06:43:50 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.87.151) by
 chn-vm-ex1.mchp-main.com (10.10.87.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.56; Thu, 12 Nov 2026 06:43:50 -0700
Received: from DEN-DL-M70577 (10.10.85.11) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.58 via Frontend
 Transport; Thu, 12 Nov 2026 06:43:47 -0700
Date: Thu, 12 Nov 2026 14:43:46 +0100
From: Daniel Machon <daniel.machon@microchip.com>
To: Joe Damato <joe@dama.to>
CC: <netdev@vger.kernel.org>, Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn
	<andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <edumazet@google.com>, <horms@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next 5/5] net/mlx4: flush pending doorbell when
 dropping a TX skb
Message-ID: <20261112134346.zvctvknj4mc5s2pm@DEN-DL-M70577>
References: <20261110231304.1859217-1-joe@dama.to>
 <20261110231304.1859217-6-joe@dama.to>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261110231304.1859217-6-joe@dama.to>

> If mlx4_en_xmit drops an skb (for example because DMA mapping fails) and
> that skb happens to be the last one in the batch, the doorbell for the
> WQEs posted earlier in the batch isn't written.
> 
> The queue stays awake, though, so those WQEs are eventually announced to
> the HW after the next TX, but that depends on traffic and could induce
> latency.
> 
> Avoid all of that by writing the pending doorbell in the drop path.
> 
> Signed-off-by: Joe Damato <joe@dama.to>
> ---
>  drivers/net/ethernet/mellanox/mlx4/en_tx.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> index 123071a47bed..3166837711be 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> @@ -1135,6 +1135,9 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
>  
>  tx_drop_count:
>  	ring->tx_dropped++;
> +	/* an earlier skb in this batch may have deferred the doorbell */
> +	if (ring->doorbell_pending)

I think checking !netdev_xmit_more() here would let you ditch the new ring
state, but it seems bnxt does it the same way, so fine by me.

> +		mlx4_en_xmit_doorbell(ring);
>  tx_drop:
>  	dev_kfree_skb_any(skb);
>  	return NETDEV_TX_OK;
> -- 
> 2.53.0-Meta
>

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
