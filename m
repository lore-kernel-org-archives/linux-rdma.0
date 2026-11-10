Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794352409;
	b=nTp/LBAbYdxdedJz7kFUMcktKNxMn0zR/L2aR85B4Wq3QWxSS8/dNOGEK+8BLJwpnIe7
	 2JD4Zj/UlnhzAHZS6CufM4t50WQzBMEUuwx4tZV0w+Gno9eSR/4mHbqvJ4gwfeSa+i/p7
	 bTfyZnd0wVa7wL+45OjsUJErIP0H2HfKwNELhVKATEuatFiE7yW5XSOE1fFkTEZWawFWh
	 Q20Hc/lgTNH5Gb4DAZPkBnDKTPEVHuOpOz3ZMl0Nrg9zp5BQjW6Y4fAB8GOUDZHwulK9u
	 2EicuEDT6g7woGF6bG4iVoN3a5BU/VH+HaEkI7deU9JcsuNrHnODDohwpCDz+Y/Mufw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794352409;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O1zdEmSlr6e17xANOXeUw7jgKI8hal4IZfaLSwVHO/Y=;
	b=rwUrFzikFvtfVQrllSpXIwJCCHGbUU4geqj5hPVRYhq5TqiTl4mBiNCGWQ22GL6aI/Ge
	 qeQZ1RR9/6MaVlhHjvQqSGESfuDGuzJg0Na7lwjVceV+DZV6/lOS9ym+bB2O4z+vSNeMc
	 kX2na50lLlBpU+4NRGmdN/JLNTNgS+s5iSj+uuTCT7eSL3fZbiPE7w2W6xWaUCZ87xT7t
	 Y3IYp57PqnzIxB3s5364w4SD3DLGKXu7MNyhLKntvi1TOgUPqyShmkpQXj6NVezAJshuw
	 Rm4l1dB/jJnHQNx224cJycNbkjCC1p+VqmjK1gQ6Zfhhy0ZE/41DOk3FQ2PXta8lPiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dama.to;
	spf=none smtp.mailfrom=dama.to;
	dkim=pass header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=WUrW97WJ;
	arc=none smtp.remote-ip=209.85.210.179
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A05E60A2611
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 23:13:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A05E60A2611
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dama.to
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=dama.to
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=WUrW97WJ
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-89d6bd67045so1445395b3a.0
        for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 15:13:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dama-to.20260707.gappssmtp.com; s=20260707; t=1794352408; x=1794957208; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O1zdEmSlr6e17xANOXeUw7jgKI8hal4IZfaLSwVHO/Y=;
        b=WUrW97WJPkkiDyaPWBt/Yf86zlfQv6juXMNpHIHZOhnwO4n4cNdZ+rK8h+FAesSqPe
         wRKPVqoPPK51UhGdI1UDJti3+62RmC8UhKVhGWrZabQ9YxO2gHglKNDgQE7fmzsXN03d
         VndWLWwHM09scELUwC2ghDDVqkUR3Futp6OVXvZaNTTqLtJ0Dq6VHMcaZRP0/fUhKmSw
         2kBVtF6qDId2RQqe5g7v5k+XNurLhy/dI4ynNKAIki0DjV0JxZ6jIZdZoJvMzC20kpvj
         8sFOEX85P/Gu7KtP9/mY1NQ2aXlSeg+8LFbsM0IakzpH+jQpc9vwc/zz5Hq2rp9+PoB2
         EscQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794352408; x=1794957208;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=O1zdEmSlr6e17xANOXeUw7jgKI8hal4IZfaLSwVHO/Y=;
        b=apE/ftCk3eexeyRr7sgwfARzAKhpznUorx35XUP+JXJ4tCCHE/n9gHIFvvKB13iywC
         /Vqxf/2wchP4OWvs9rizDy5E6Fl9T6aqub5iT5CMwMYkuzw5HvfsM7dtPr5t7e631/Zl
         r5z50FRbE2n+IUgUlSmdN6y/DphAHh1Y/meNX9j2qRwjYoDaEwz0Y/YJXrINPMXwfc6m
         mWtAHed8RB4EXHQrEu97+1oW1jkcnCztUytuMCnjKHu4e3Gorrp8S/zZxzMILySlkIiN
         aBvUoEBH31wZWurlAuUeFeHsowfOcmMOOhLoJG0Oxju66a1J43Bh4qeHJKdi8n9BtaZr
         QL7Q==
X-Forwarded-Encrypted: i=1; AL+hErGiHA/qxgHiWdsHpvyryo0McccDHsRcXJwRwszIzhHcnUkxihEakp88C3g87oBuJ+rKimYxxqibqW4q@vger.kernel.org
X-Gm-Message-State: APuU4Z8o5/LbcnK2dCLVBT134vY/dHefmtVWthsFJvxDrv2hKe5jDH6R
	moI4biDzVt43yO0k1ZupeLCpUX+4G97dAQo8xIWuluR+OfnBcoZIH3Tcmio9V9QGSWg=
X-Gm-Gg: AYBFou1/2aOkH6ujiCK5gaJ7zR/RrauZTeT6Ukw1dpnUy0OJEHNyWRRr/DV+JPbR0Fw
	AKUk6RyR6hWPI/uUqPx3WgylRpLiaY5YW1Vgb9w7WcYqlxdkTcT2LebdSFAeqdSNqVlGKWLsJ3t
	d+SR0YZhONXmEmGIZLh3KQ6fCOq91GLqOeHOYaYpZjhvTs0p1ZgzNOTd/jDSe6GRjbonl82MNVE
	MihhFFABohdRXZJvT2cDSuOOfdqSsBDSe+AXKy6MaHadbCRxBxRDRWcZ1IXgpXtsK/Ns/MYaV8k
	LmSWdDJjf/3KOUpfGxQ2MYvalzKGAC9eCrlw5eTosEQ7ZjUUClLKd+1PCGBhLDaeay0a7ZzM5QS
	7G2BB/hjeSnnd0/kObJkF3VBjgdDfFC2x1GWR6dsVXfHgQeGoV15ITZnaXT5hHOMPA7vIDm3MAw
	5SwCEJnICvgrOR3TDfV2rd6y0kKfw0SgqhCA1+dgByonqU6FCgMtsMOFnjRnN+p/5ylDj0p9ekr
	jF5XXgxKXeNwpqypMiSxiP+frITsh4r/9efzvl0s29seqpw0h0OKjN36V7CaUyxKjvh5/6gGlSG
	T9401bYZo/iQB48Yep/kZFaKUw4hkg23mI8a+4OmDp4=
X-Received: by 2002:a05:6a00:4605:b0:89b:6041:2348 with SMTP id d2e1a72fcca58-8bc1c2a9089mr440796b3a.7.1794352408016;
        Tue, 10 Nov 2026 15:13:28 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:70::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baaa1b2887sm1432058b3a.20.2026.11.10.15.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 15:13:27 -0800 (PST)
From: Joe Damato <joe@dama.to>
To: netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: edumazet@google.com,
	horms@kernel.org,
	linux-kernel@vger.kernel.org,
	Joe Damato <joe@dama.to>,
	linux-rdma@vger.kernel.org
Subject: [PATCH net-next 5/5] net/mlx4: flush pending doorbell when dropping a TX skb
Date: Tue, 10 Nov 2026 15:12:59 -0800
Message-ID: <20261110231304.1859217-6-joe@dama.to>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261110231304.1859217-1-joe@dama.to>
References: <20261110231304.1859217-1-joe@dama.to>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If mlx4_en_xmit drops an skb (for example because DMA mapping fails) and
that skb happens to be the last one in the batch, the doorbell for the
WQEs posted earlier in the batch isn't written.

The queue stays awake, though, so those WQEs are eventually announced to
the HW after the next TX, but that depends on traffic and could induce
latency.

Avoid all of that by writing the pending doorbell in the drop path.

Signed-off-by: Joe Damato <joe@dama.to>
---
 drivers/net/ethernet/mellanox/mlx4/en_tx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index 123071a47bed..3166837711be 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -1135,6 +1135,9 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 
 tx_drop_count:
 	ring->tx_dropped++;
+	/* an earlier skb in this batch may have deferred the doorbell */
+	if (ring->doorbell_pending)
+		mlx4_en_xmit_doorbell(ring);
 tx_drop:
 	dev_kfree_skb_any(skb);
 	return NETDEV_TX_OK;
-- 
2.53.0-Meta

