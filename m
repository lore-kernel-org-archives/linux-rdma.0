Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.254.49.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794399805;
	b=NRLav60Ff0leSt8KAAItRuwaYXo65Fq+HapTAUqvoPIeDOfaXeVhmT5isp+uslO4H2KF
	 lKN5dtYBmfWJh+50jRs9qaiaw0+poP31UbOarjzv7TV6bGwSHZvr+wkUSRs2QlCloicDL
	 L5vTrCXeaWXlxr1dolbsCl1JpmsQ/5P3NpMr4/i59Tm0UUuP81TeRdk5s4rteZrHg0Zzt
	 JaYJXIUWpXuog3DyxiIlR2VyYo0nKgFLHGWUYNpWrixXIlweKYoPzOwqYV9sRgMI3+VUs
	 dWGSw2S2I9CG39uRaiaCnqR5wKwpYv3TJrxS0yC7Ep89H+VxPZiezWv6+c3PEFP1M0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794399805;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-HM-Tid:
	 X-HM-MType:X-HM-Spam-Status:DKIM-Signature;
	bh=PMryjBiDDLKvg+nq7ZTkgM43RGf9ry+Zo405EdxD3/8=;
	b=dsPWXelCbKRtFX26XDzSLaFoGHh+MgnKhuH/0w9kD1oIHuaNNpUHkdcDbatR4xUJ4C5T
	 dLlN1eYxSVdLvTTj5/yVaVusUgvUaZJEfND2k4m8vuQdacoHVcp282NW7hdmN1SQ8zqR5
	 hhxyER9m7EtKdat8VWd5mHBQVHJ785AFm8MRRmnHoQPrlwPEb6v42nB361wX4ClEJKXcz
	 iYBD8+grIljzUESzaFW3tB/5ea31PjcJSGQeL0inhlv9fRX2YEAmN13ybU12XofRrBGYx
	 1vN3FzSTJ9mvaUQN35aVFFqelpO1CmkNNKhvtxqPeLWMTxBb9jCP7UbtNPde8bSvpyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mail.sdu.edu.cn;
	spf=pass smtp.mailfrom=mail.sdu.edu.cn;
	dkim=pass header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=R8lIE8yl;
	arc=none smtp.remote-ip=45.254.49.198
Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615FA60A2624;
	Wed, 11 Nov 2026 12:23:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 615FA60A2624
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=R8lIE8yl
Received: from lgs.. (unknown [101.76.249.61])
	by smtp.qiye.163.com (Hmail) with ESMTP id 54502a178;
	Wed, 11 Nov 2026 20:23:20 +0800 (GMT+08:00)
From: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
To: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] IB/hfi1: Fix potential leaks in IPoIB TX queue initialization
Date: Wed, 11 Nov 2026 20:23:19 +0800
Message-ID: <20261111-e5624093d6-rdma-hfi1@mail.sdu.edu.cn>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa1ca900de503a1kunm646fcfa81b3682
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaSk4ZVh5IH0keGU8aHU9DS1YeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlKS0pVTE1VSU9CVU1KWVdZFhoPEhUdFFlBWU9LSFVKS0lCQ0
	NMVUpLS1VLWQY+
DKIM-Signature: a=rsa-sha256;
	b=R8lIE8yl09ZAudufZqzZk57YIH+rjhGZt3h8ACPG+6A9lK6xbtgQDVVwyhCBDMOhWYW1JIpyBLKCqBaDqDWtWXOY4xr7QmfNzlD+6ln+drnJjXOfglMWHwj9X3NbjqLwCD1NtG0Xh6d3zz+H4AgxzcJ/GJqHykt2VFCVszDytzc=; s=default; c=relaxed/relaxed; d=mail.sdu.edu.cn; v=1;
	bh=PMryjBiDDLKvg+nq7ZTkgM43RGf9ry+Zo405EdxD3/8=;
	h=date:mime-version:subject:message-id:from;

When an SDMA header allocation fails, rollback skips the current TX
queue. Its ring and already allocated headers are leaked. Free the
partially initialized ring before unwinding the completed queues.

This issue was found by our static analysis tool under development.

Fixes: c874ad879c2f ("IB/hifi1: add a null check of kzalloc_node in hfi1_ipoib_txreq_init")
Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
---
 drivers/infiniband/hw/hfi1/ipoib_tx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/ipoib_tx.c b/drivers/infiniband/hw/hfi1/ipoib_tx.c
index 8b9cc55db59d..2e9225b558b4 100644
--- a/drivers/infiniband/hw/hfi1/ipoib_tx.c
+++ b/drivers/infiniband/hw/hfi1/ipoib_tx.c
@@ -743,7 +743,7 @@ int hfi1_ipoib_txreq_init(struct hfi1_ipoib_dev_priv *priv)
 				kzalloc_node(sizeof(*tx->sdma_hdr),
 					     GFP_KERNEL, priv->dd->node);
 			if (!hfi1_txreq_from_idx(tx_ring, j)->sdma_hdr)
-				goto free_txqs;
+				goto free_tx_ring;
 		}
 
 		netif_napi_add_tx(dev, &txq->napi, hfi1_ipoib_poll_tx_ring);
@@ -751,6 +751,10 @@ int hfi1_ipoib_txreq_init(struct hfi1_ipoib_dev_priv *priv)
 
 	return 0;
 
+free_tx_ring:
+	while (j--)
+		kfree(hfi1_txreq_from_idx(tx_ring, j)->sdma_hdr);
+	kvfree(tx_ring->items);
 free_txqs:
 	for (i--; i >= 0; i--) {
 		struct hfi1_ipoib_txq *txq = &priv->txqs[i];

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
