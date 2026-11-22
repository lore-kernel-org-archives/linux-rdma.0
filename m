Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795359771;
	b=B2wvHPDsv2NNgDMPx04qYcrz7K+ivXx/Xj+1JXNpft2yzVyneC+uZ69dvU38MCWwoGWo
	 0prZs7UQC4wh7DaT3ghNmcf8g+VQZhjlUnK0xUx1Z5Hq6mlv7QHlk5ETiJnATjb6sHmFW
	 N0GwoQuN172/q4LvvtH4OHfXSsds8I9gRAIqJMppxiJS4UqR0U5nCMqxqVGeM5F7jbTSX
	 NjAkhwiY9Ound/+d3dwW7C9uvNnWusr4Oy2NyDc4S6CX6TCYE3on2+YpJPl1NrJUBqFH4
	 bgRj3gfMYSfGiyEeQk3AZr9KgpigFfn3YNWE5Xi+hD0utYoTR+C7QeQq2J4nGicFLgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795359771;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=rX8FDIpri/LPGMMfN5gnKMnYoSwDyIz5A4qsnWX6RG0=;
	b=rub8JERQpB8GwwARLrL5S+p5QA8Zv8ZhfLmCfJ+3iPlFxdHtCBxxgVQapW4b5kpnO4Gm
	 g7JNgUQvGhch+KMHSPy/PhWeamcKwIA2TfV2ZoKAchuUwuQ9IW9lXODk3SNQGYi9mY4DG
	 QU5kkp0V2h5e9k5BmjUWWlL1S3YO/u+pNSS0fTA3kwxziNMOVtRdvqGsGqkXpaO7OHOnn
	 ojfq4dfhoXoL5ObWm/XyXJyvkqnp5pqxrw9eWgm7NTE4vPGFNUx22wVFZT4EM/gMWa3yV
	 vaIIhlRoF+64KIuuaVLIRgOWOfw9f/pTsoHKiZ6j7KD2n2QibUxNr0ZvCbo+cFhQ0Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZxT9ZB9M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5B1606A320;
	Sun, 22 Nov 2026 15:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZxT9ZB9M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013191F000C4;
	Sun, 22 Nov 2026 15:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795359770;
	bh=rX8FDIpri/LPGMMfN5gnKMnYoSwDyIz5A4qsnWX6RG0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZxT9ZB9M2+bKP+mYOYvy1GiY6uZ8z0QgpQwKc85CufPIWmGahzJGP40HsjktM3tAi
	 4jOhc4lNjrnKEphyoDs5uU+OPkE2N+WrgNeMj1zyrvRoNNu5olDHZ7N3gT2vXWPSwm
	 7rQ3xpRNrEpyP/LU0SU4j6PaKkB4dbKp0gbT32Tpv21vItOmuJaGcCmS1pm4pi4BUL
	 FSsghQi9kyR6qadOe/0eHPPCGYYDlxuOo0JP4KRU71JSzLeWXM24DMPcdl3yYaenST
	 KydV4YSu5r4Hxac2uruIC+LMavDH4DnXX9hR5BMBBwjxUE1b/2F/12b5mYl95oRzY1
	 yprtn9fi5wsng==
Date: Sun, 22 Nov 2026 17:02:46 +0200
From: Leon Romanovsky <leon@kernel.org>
To: =?utf-8?B?5p2O5bm/56GV?= <liguangshuo@mail.sdu.edu.cn>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH] IB/hfi1: Fix potential leaks in IPoIB TX queue
 initialization
Message-ID: <20261122150246.GF14811@unreal>
References: <20261111-e5624093d6-rdma-hfi1@mail.sdu.edu.cn>
 <20261115135524.GE42525@unreal>
 <APgA2ADdLAK4Fr01jTNuVqo3.3.1795092279897.Hmail.202321181@mail.sdu.edu.cn>
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
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <APgA2ADdLAK4Fr01jTNuVqo3.3.1795092279897.Hmail.202321181@mail.sdu.edu.cn>

On Thu, Nov 19, 2026 at 08:44:39PM +0800, 李广硕 wrote:
> 
> Hi Leon,
> 
> Thanks for the review.
> 
> From: Leon Romanovsky <leon@kernel.org>
> Date: 2026-11-15 21:55:24
> To:  Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
> Cc:  Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,Jason Gunthorpe <jgg@ziepe.ca>,linux-rdma@vger.kernel.org,linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] IB/hfi1: Fix potential leaks in IPoIB TX queue initialization>On Wed, Nov 11, 2026 at 08:23:19PM +0800, Guangshuo Li wrote:
> >> When an SDMA header allocation fails, rollback skips the current TX
> >> queue. Its ring and already allocated headers are leaked. Free the
> >> partially initialized ring before unwinding the completed queues.
> >
> >free_tx_ring already performs that, see "for (j = 0; j < tx_ring_size; j++)"
> >loop.
> >
> >Thanks
> >
> >> 
> >> This issue was found by our static analysis tool under development.
> >> 
> >> Fixes: c874ad879c2f ("IB/hifi1: add a null check of kzalloc_node in hfi1_ipoib_txreq_init")
> >> Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
> >> ---
> >>  drivers/infiniband/hw/hfi1/ipoib_tx.c | 6 +++++-
> >>  1 file changed, 5 insertions(+), 1 deletion(-)
> >> 
> >> diff --git a/drivers/infiniband/hw/hfi1/ipoib_tx.c b/drivers/infiniband/hw/hfi1/ipoib_tx.c
> >> index 8b9cc55db59d..2e9225b558b4 100644
> >> --- a/drivers/infiniband/hw/hfi1/ipoib_tx.c
> >> +++ b/drivers/infiniband/hw/hfi1/ipoib_tx.c
> >> @@ -743,7 +743,7 @@ int hfi1_ipoib_txreq_init(struct hfi1_ipoib_dev_priv *priv)
> >>  				kzalloc_node(sizeof(*tx->sdma_hdr),
> >>  					     GFP_KERNEL, priv->dd->node);
> >>  			if (!hfi1_txreq_from_idx(tx_ring, j)->sdma_hdr)
> >> -				goto free_txqs;
> >> +				goto free_tx_ring;
> >>  		}
> >>  
> >>  		netif_napi_add_tx(dev, &txq->napi, hfi1_ipoib_poll_tx_ring);
> >> @@ -751,6 +751,10 @@ int hfi1_ipoib_txreq_init(struct hfi1_ipoib_dev_priv *priv)
> >>  
> >>  	return 0;
> >>  
> >> +free_tx_ring:
> >> +	while (j--)
> >> +		kfree(hfi1_txreq_from_idx(tx_ring, j)->sdma_hdr);
> >> +	kvfree(tx_ring->items);
> >>  free_txqs:
> >>  	for (i--; i >= 0; i--) {
> >>  		struct hfi1_ipoib_txq *txq = &priv->txqs[i];
> >> 
> >> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
> >> 
> >
> 
> The j loop frees all the headers in each ring it visits. As I read
> free_txqs, the outer loop starts with i--, so it skips the queue where
> the header allocation failed. If that happens on queue 0, the loop
> never runs.
> 
> Would it make sense to reuse the ring cleanup for the partial queue
> and keep netif_napi_del() only for queues where NAPI was added? If so,
> I'll send a v2 that does that.

I think that this will fix it.

diff --git a/drivers/infiniband/hw/hfi1/ipoib_tx.c b/drivers/infiniband/hw/hfi1/ipoib_tx.c
index 8b9cc55db59d8..23c06d86b2921 100644
--- a/drivers/infiniband/hw/hfi1/ipoib_tx.c
+++ b/drivers/infiniband/hw/hfi1/ipoib_tx.c
@@ -752,7 +752,7 @@ int hfi1_ipoib_txreq_init(struct hfi1_ipoib_dev_priv *priv)
        return 0;

 free_txqs:
-       for (i--; i >= 0; i--) {
+       for (i; i >= 0; i--) {
                struct hfi1_ipoib_txq *txq = &priv->txqs[i];

                netif_napi_del(&txq->napi);
~


> 
> Thanks,
> Guangshuo
