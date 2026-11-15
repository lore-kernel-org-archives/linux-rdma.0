Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794750928;
	b=Xsd8cDxY3N2yIoCh0PPZttYIeBAjqVQuX8rUsGYofUjROpBJPf8EMgKNm2CawCfjIOEU
	 PF1aGqocVTBgq5DTiE4llkR6ChckUUpTIfU0dYQRPEXtrSlHO9y+hsaCC+zhmkAPvwOhF
	 IqqI4ApZj35ZkbH4+/qkaZAgi3PxXuFRJqq0R6KyI5H7t6urbdd5dh02G43KDSwP0IBfG
	 buAexEB2E3Hvfn7OgiP3YEPIREEP8k9HDkU0ggbZfpBpjUPRHWNnzVE/y3pOD1ZZOkDlp
	 bdX/4cxRnTh8dYEqP4JEiJUX/4bPHtNvjeNpFYXMuO4oWl+sHgVUheBOHQaRsA+pYvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794750928;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=gTdXHNZ4m9+z2N/yHS6M3KqqT5Mkw+ISeKzUL028u7E=;
	b=hZ341wPp+Zep5YUQze1+OQwj6hb7OIF2o3IeIt8nlF7AFw4/9K+sEHyijCSqTevPHq0/
	 tL24ItVsA3eESF7bfE6f5O1sHBnGgXZpY2CR9hL/U4+KWSgFTJZED9/JrLKiocRZP73Zq
	 xgGIbhvLZTJhqRT5bBi1CEkmidYIYEXIu/iyBKhUKvWzJgG98MDTm8UGq0o76ulihkoBU
	 JxJ7dsHBQ67sKwvnOI+leXjGiXp/Gx47jHfITw523QVDtY5WfXyWcfAGD9F09zQjm+Q9f
	 BFzbGzuQYtuxaapbCQeMTfnFu/jPbY2xmw8SUIgYLhl8zHdxR6gJ1U6j2dl5oodxrNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="gb/lKqh2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8380606A31D;
	Sun, 15 Nov 2026 13:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gb/lKqh2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A031F000C4;
	Sun, 15 Nov 2026 13:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794750928;
	bh=gTdXHNZ4m9+z2N/yHS6M3KqqT5Mkw+ISeKzUL028u7E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gb/lKqh2L35xsor89doADEe3ugsBZ7/24E8ckzBkiPRLI6QlxOGihR9ftj1DNFMVU
	 2o5D2GonamWzibAEiKXY6OxNs8F3/iCwGMGrFLGCk8jZqq82rUXEkuh46+x2RP0r2d
	 fbBQ3d/7hYZZsvxbw1/0Xn7zgbzK17QiMgrLBecHDh7D5Pife/whBW3tZ/aomEsVcu
	 Xg9BpsFm4j/rl4EFw7SbtRHSCQtQYaUwlVoQLbQaC8AFpsVWNs1ZtGkzJs711pFpmB
	 f+6mzp+yKeBMdlFlddDD9y9HuT9wJRX9NqMJqSN6hkgcKTYOBgNO6n/npqyvbozV+K
	 wcbuU/o9nvfkA==
Date: Sun, 15 Nov 2026 15:55:24 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IB/hfi1: Fix potential leaks in IPoIB TX queue
 initialization
Message-ID: <20261115135524.GE42525@unreal>
References: <20261111-e5624093d6-rdma-hfi1@mail.sdu.edu.cn>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-e5624093d6-rdma-hfi1@mail.sdu.edu.cn>

On Wed, Nov 11, 2026 at 08:23:19PM +0800, Guangshuo Li wrote:
> When an SDMA header allocation fails, rollback skips the current TX
> queue. Its ring and already allocated headers are leaked. Free the
> partially initialized ring before unwinding the completed queues.

free_tx_ring already performs that, see "for (j = 0; j < tx_ring_size; j++)"
loop.

Thanks

> 
> This issue was found by our static analysis tool under development.
> 
> Fixes: c874ad879c2f ("IB/hifi1: add a null check of kzalloc_node in hfi1_ipoib_txreq_init")
> Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
> ---
>  drivers/infiniband/hw/hfi1/ipoib_tx.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/hfi1/ipoib_tx.c b/drivers/infiniband/hw/hfi1/ipoib_tx.c
> index 8b9cc55db59d..2e9225b558b4 100644
> --- a/drivers/infiniband/hw/hfi1/ipoib_tx.c
> +++ b/drivers/infiniband/hw/hfi1/ipoib_tx.c
> @@ -743,7 +743,7 @@ int hfi1_ipoib_txreq_init(struct hfi1_ipoib_dev_priv *priv)
>  				kzalloc_node(sizeof(*tx->sdma_hdr),
>  					     GFP_KERNEL, priv->dd->node);
>  			if (!hfi1_txreq_from_idx(tx_ring, j)->sdma_hdr)
> -				goto free_txqs;
> +				goto free_tx_ring;
>  		}
>  
>  		netif_napi_add_tx(dev, &txq->napi, hfi1_ipoib_poll_tx_ring);
> @@ -751,6 +751,10 @@ int hfi1_ipoib_txreq_init(struct hfi1_ipoib_dev_priv *priv)
>  
>  	return 0;
>  
> +free_tx_ring:
> +	while (j--)
> +		kfree(hfi1_txreq_from_idx(tx_ring, j)->sdma_hdr);
> +	kvfree(tx_ring->items);
>  free_txqs:
>  	for (i--; i >= 0; i--) {
>  		struct hfi1_ipoib_txq *txq = &priv->txqs[i];
> 
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
> 
