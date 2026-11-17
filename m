Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794930856;
	b=QDhA0mqhyCDQdZSMXYoLpS5GOUbehOe8FFR+KI16gOUW6vA5RUCVpAFi4TZUuJ2zFMV/
	 7G+jKlggac8Nny4G/0iRs5eTGVUMPcZlYD+6TyM5MeQPSgcG4uH3jeQ9VrlWREkNlkFKf
	 AqnIbfKZjiQ4rTLOF1GyXFxwxFFIS6hr7RivOckQpPlH888EAP1wi86hbjSZHGqQ6hnBc
	 Sj1q+3O3H3zYQpT7Z6gjbc2vBSHs+clOYZigUo7wUY4y8XcFEaTeMTDq27JSbTzYpo/0U
	 zDx7JwFpu2Ri0dfptpW7hvT/9biUmuSPSf916q2tLBnLWybagIyj1cYmHPZACSn/1lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794930856;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+5dvy/hAScMAJsju1oorwW3+RHfVmuWNsVasJTGPYS8=;
	b=fvjyrifHNgl4LPajStePqK0myv7CA7Z+zQsqqOe6J0PCAT7gzU/MYdOaCPfZmE/YeuJ2
	 Hd0pGujgx6OjKna4KMHddV7vPuRmYJZEHfkaz6Dl9nE5jhmrD8ldUOSzb+HhwlNg0p9Dr
	 bGEzE9RaTLr/xxNoIYqJtG6QTRjPt62Ny8ho1oMFbPE+UbIRZLi0auVvM2j26CotLtEjA
	 lG2HRy2Ka9tG8kcuomexFWcV+w6NRUlx33zVbM0e033qtkR5EFBJyNqO+85ERIciMMxz7
	 fLJg7z9zeHIzlp4vzqCnE42gePCS3/u13tqZAZEdJ0d6AZ2vOez5Hqfbecl9QeAyhXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dama.to;
	spf=none smtp.mailfrom=dama.to;
	dkim=pass header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=pmrIdfuj;
	arc=none smtp.remote-ip=209.85.214.171
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4D6606A891
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 15:54:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC4D6606A891
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dama.to
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=dama.to
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=pmrIdfuj
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2efd824d492so6692315ad.1
        for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 07:54:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dama-to.20260707.gappssmtp.com; s=20260707; t=1794930855; x=1795535655; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+5dvy/hAScMAJsju1oorwW3+RHfVmuWNsVasJTGPYS8=;
        b=pmrIdfujPycQm+s7tQOqOFxlhHo+pwbKAtJ5JxxY2qRS+4l7e/cZ4QOcCIZXos85IV
         Y8ws+IrsuDgvjQeTct4VzZs49xxqyyAzumSE3x0RQAQi7UbRAQpIQv4f/Ij8+v+C5vk3
         lp5aMveOZudQunCgabz1/n9rEMI7OMy+75cya5hWWYmSkRBRu701yqtR2qbhsa+9BSov
         B7p7WTeMXrA1la4e/jxbsGjo2YpSydYedd0fnzhxF002FK0QYyPF3QQFRP9jTfsvH6vf
         T6MHOG+Slkq/2jZZH/9MrGP/aRdfrVddpi49BPd+UXYyQwW0pEP/U+bpuPXB3GePq49e
         w4dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794930855; x=1795535655;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+5dvy/hAScMAJsju1oorwW3+RHfVmuWNsVasJTGPYS8=;
        b=p9gM4+HEfH/07am6jlEBM0yLlKgeOwfH+DY2bhhGp/b1Y/or05um1hCgvhyZMYWHdr
         ZarTxrwgOHF+V7EOlCMjaGATHc2jpq9wtnIeoUJlL+TUcvl63fBUfqhgboZCVYOTtcWw
         fqBK4WZFW4g9oD8GkkfLyodS4Iq0FvQjfxOK+kGtt4oKP35DZuNm30QFWSknig1ORlxh
         b4VELlYBebjk7TWRGdk/oY6vizeDIZa09v3KD0P4Y3feSVdpEKKCgZh2p8ROJ3rDggHx
         kcC6HfYmjy1Uz4Tfvju0jV3uB5ClF6q0hMsdd8DS7WQGFsemTbuDjvqNHaHuyBmPF81d
         hEKQ==
X-Forwarded-Encrypted: i=1; AL+hErF87IP/iclx6PLqcZtiPZc+HlqpUq1Wr6IOPPPpzEdZuDp30ilcAJ9mdMilWHvqY6vAoGnhxJAzIG2A@vger.kernel.org
X-Gm-Message-State: APuU4Z+QQBJwhd4s9LsGmgLM/v/JOk+mMfNpp7wpyxSnt5ifp0eZ66Uw
	VxOvrjsD276/ID+4lXEY/feVOEDJsXEOqJG76tXf8mmk/MSaO6sulkBUszOVq148/3A=
X-Gm-Gg: AZFdTZcjZ5hpTqmBK5u1aC6PkLmJB1vjH/UcOc+dw3sG0hPcQ05p+3Q4JtKuawyE5RI
	7Ykt+SFa4aybUM8VW9U9Wld1rEywgGEFr+MXNbhFlZnWmDAvNVM0RnET230sJHzI+P8NynLQ9pz
	daX0zfemv7YuelG+3BxG+mqIXsXEBMP6LcllaHSB1h5hUoNgstBcI3mg1HNTzp9MHgR/C3AA516
	9VrKiiFrUXRTADZEqDorDS1tVn6S7ms10nPE3tRpCAZOf0fc5wU/g0anZvGz9aKtqUrLMJBqXp9
	1ljUJU8eWLQgmqVGQi+0V+KW/+uWmWLoX8cTrDXyiYPwYOIJiHLLlFdeoUzUZjmWpJPCaUIaPlk
	E4Vu3tYVbUfJmNbAPBPRHdPpjKvKrOCkmhSblsIpHhtrQnOjlV2m2ZIym9dGwebNomfvYT59ymm
	GaZ2s+YJrcGRuiZClHU5DYEMnxEhPqHthi4ooK7C5ZYel3Pasr4klhjfYkDwNowoy8lhUVDRSgb
	i+oxNcKPFdBZupNU+ksrayviQqYxNUnWKQ5lC35WL6xaBlPXnUqR8mMStW7hvh3vwkbtCvm+R4K
	xjuhrxCW8zSjt8D7m42e9iu+M7VaokB1x7r5GmNcl6g=
X-Received: by 2002:a17:903:1109:b0:2ef:dff3:47e7 with SMTP id d9443c01a7336-2efdff349edmr23311925ad.33.1794930855228;
        Tue, 17 Nov 2026 07:54:15 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:74::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2efd7a54576sm18951695ad.40.2026.11.17.07.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 07:54:14 -0800 (PST)
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
	daniel.machon@microchip.com,
	Joe Damato <joe@dama.to>,
	linux-rdma@vger.kernel.org
Subject: [PATCH net-next v2 5/5] net/mlx4: flush pending doorbell when dropping a TX skb
Date: Tue, 17 Nov 2026 07:53:50 -0800
Message-ID: <20261117155353.2250540-6-joe@dama.to>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261117155353.2250540-1-joe@dama.to>
References: <20261117155353.2250540-1-joe@dama.to>
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
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
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
2.53.1-Meta

