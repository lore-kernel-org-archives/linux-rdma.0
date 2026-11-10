Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794352407;
	b=Vp6kNlvzi5QPPgJ/BNuYfMI0NEnCmkntE04dZGwSsZXSHcELr2Q+wIIwHNxWXn9l9ya9
	 x7BMPCgMi1ZI3etyrhgYPIhqeEPRU+7CXpzFL0E/Ye2JCboyEcttIrWwP4X7UGO0+AThm
	 QDjaWSq4MyWGBEoTaCk7RUWjddLni7xHehqzSn2d13Wled1EtGeaFJzTI5y/XzhiKYrE6
	 2UWYb1k1Pga/N6RoScPV2dtYGJKZH6Ff2C51Ui5aBFiuTt5Iq73bXKJmnPMtnS7y7bPWH
	 ox5VrD7b+wKwVfrUGl0dwr0q0FHKk8Pf6hjy20NNpIxUAmc24l1YDhYAxZ0ZiG4pWHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794352407;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KPjjNdzNNe62t+wzBfTzcH4sAdNUBvRnqarPrYBxLuM=;
	b=KCqqx1IA6SSYzf09dCoV9UnC2cmUwjjNRQcxXOF9xO/20bb7H1P0Fm03WipeT+hVze8j
	 qLqUWXJ6wOztDCKkpLrtZQPEGygU3rvAydTbT2Zo+TegHteM7kxAU1YGmezLJjBqjnuFC
	 07iq8UbRi5sDUozPaxZSFtn0GFKc4z3jJDVbILASF3ALv/wlMYNx3nk2MLaPapNlmi5D2
	 QZxNsHAbBi7e+He022D/KUzdya6rRYxwfcXP8bL8Eecuoea0MIxGB4C/ZbDDTVqzFmd+c
	 8Yd12k6k1pEVlRMaBBTiWd3lFdmHAkj0dKFu9KXjMGV2hPZsTxE1RtXSZ1+hzTs7a6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dama.to;
	spf=none smtp.mailfrom=dama.to;
	dkim=pass header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=lOisifqB;
	arc=none smtp.remote-ip=209.85.214.180
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA75460A2602
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 23:13:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DA75460A2602
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dama.to
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=dama.to
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=lOisifqB
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2e9eb579c0eso14759615ad.3
        for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 15:13:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dama-to.20260707.gappssmtp.com; s=20260707; t=1794352406; x=1794957206; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KPjjNdzNNe62t+wzBfTzcH4sAdNUBvRnqarPrYBxLuM=;
        b=lOisifqBTO8ch8f+y85SanimyAgxf04DC8JmmHbuR4oySMJ7k67CQOulv4Pmz9hQDJ
         H+0kfYZIqUdc1VHGS0vheJs8VPLXkOhr88rM9RBPwAo3thVxFwhp3Q2SIz25PqeLMNb7
         BT6uEoDLYFlNTmnDNdLFcKtCfVCnabonrZxGnkea0sMLuVJ4WWggPHp8+4nNhHyV+VfN
         lVFJTYyAFWCnDrfz0BYTeVzBEVCT5AV85UrUMHCH8tT0FKY7QgFSC9kd3ecduNyrFJuk
         5wXjgiwKXIBx2XxCMebD3yCeArq8mgIOSlvvJ8FuXtMfZtWqQFZMR9/5SX3sp2obEyI3
         7Lzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794352406; x=1794957206;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KPjjNdzNNe62t+wzBfTzcH4sAdNUBvRnqarPrYBxLuM=;
        b=g1HoCw2YvHdqscjNDB2LsKQnDDT+3y5Tf2KulAY7Xs+tQWrG4m+O4/oyCjh3X3JnBE
         /QQ4MQfMbJEmS8617oYlY/fB4fijGcFjottg2BMNU7eh/f7NeFCvcwNKqsqSMt4Ya3Fj
         zXHhi2VfF0/mmBrlitoPjvoePEe1WogizmmvjwXG/vp17hCvCOiMyn+svWTL1m6ggWF1
         T7GhqElPX+rM2S9DYF3d6Y9/MXJyLuw4uT5A+DA67lwgUR1FNKn0epLJ6C84r/0Vysp1
         A/ttjJjpDYnx9mwYIg99SLKg7YpiHiCEYgFbZ9BMzGie4uzb9NRTHyVK+FS0JOx/b+4A
         zKWg==
X-Forwarded-Encrypted: i=1; AL+hErG7HxGr6MFkPMlBhlRg07Hy4Kd2O0ErKfY175fqxCbv4uqda0tbWdAAtVjk4g7ibh96d1Smy4806Rwd@vger.kernel.org
X-Gm-Message-State: APuU4Z/9MPwC0eH+IIoCMPdmQuMPUyLOLJ1GRyYRvsnc5s4tPKdSFsCs
	W3nISPR8QbqhwVeNmaRd6zsUp7qMtCJ1Equ4dIrFdrpsvN3pByZilHmINX19vKJO0D4=
X-Gm-Gg: AYBFou0JUDV7ucWaNQVMl7f4btnPn7XMMbRZ19t+vB0x4uxf63ZAp4IdUVlMQcZI9yu
	M/pzPwZVWMdEJhW1abMMskBqcXGT9NbxZnaezCLWe94c/BzFG4z2ht4Ag3EnZ1gXVucVGvbsCUT
	n+B2mxxCwdj2iwPS/KgkLkLYYHzby0fI+SlRoyrIwVsJ3Mh8P8V0DDEhNJSXARHO55B/k8mCqdz
	9fCMfE5TIwXTJESnVVmZI5QQMw/HrRGFiO7ArqsAjz2p5w7G16jaqwaF/uhob+9eKEVEC6w+mSV
	PgdNB2lWGXyXk4CDErqAQJVkWbzdHleBWFAdl8+5odL+7PKZ/4PNUeAtbGWCPtelwx8OCERcmXN
	tH/ghSufHDSZgoDLRaaQv8c66dvnEtfUvFW7UzYvkqkI5aeYB+6dJr0RqNQ1EHXdaylyO0XFNZJ
	lFyLcIeATENc8QhW7DOwHnpDT4flEQ1CxAZu8iXmnpqcPabHRXIXMTCbQzM0XY8nOYnglWIF533
	DiLjQJSB8eDWc19KUTGp25ZDkmblNYUnj/62lcqaOQnlmt0WnuMqrTQTy5ZdJJWJOYcN9PlTL7s
	pU/CT0rM7LnCEreoCs5AApjrSMt04V/0LUOJba9s7Asv1JymYjLKnwNJxDZabRgE
X-Received: by 2002:a17:903:1b27:b0:2e9:7dda:bfce with SMTP id d9443c01a7336-2edd7b85ea9mr5458855ad.74.1794352406223;
        Tue, 10 Nov 2026 15:13:26 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:53::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edbc1b81f3sm11989765ad.26.2026.11.10.15.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 15:13:24 -0800 (PST)
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
Subject: [PATCH net-next 4/5] net/mlx4: track whether a TX doorbell is pending
Date: Tue, 10 Nov 2026 15:12:58 -0800
Message-ID: <20261110231304.1859217-5-joe@dama.to>
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

When the stack sets xmit_more, mlx4_en_xmit() skips the doorbell and
relies on a later call in the same batch to write it. Nothing records
that a doorbell is owed, so a path that ends the batch without writing
the doorbell leaves the WQEs posted before it unannounced to HW.

Add ring->doorbell_pending, set when the doorbell is deferred and
cleared whenever a doorbell or a BlueFlame write is issued, so such a
path can flush the deferred doorbell.

Signed-off-by: Joe Damato <joe@dama.to>
---
 drivers/net/ethernet/mellanox/mlx4/en_tx.c   | 9 +++++++--
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h | 1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index 97f27e005810..123071a47bed 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -194,6 +194,7 @@ int mlx4_en_activate_tx_ring(struct mlx4_en_priv *priv,
 	ring->prod = 0;
 	ring->cons = 0xffffffff;
 	ring->last_nr_txbb = 1;
+	ring->doorbell_pending = false;
 	memset(ring->tx_info, 0, ring->size * sizeof(struct mlx4_en_tx_info));
 	memset(ring->buf, 0, ring->buf_size);
 	ring->free_tx_desc = mlx4_en_free_tx_desc;
@@ -757,6 +758,7 @@ void mlx4_en_xmit_doorbell(struct mlx4_en_tx_ring *ring)
 	iowrite32be(
 #endif
 		  (__force u32)ring->doorbell_qpn, ring->doorbell_address);
+	ring->doorbell_pending = false;
 }
 
 static void mlx4_en_tx_write_desc(struct mlx4_en_tx_ring *ring,
@@ -784,16 +786,19 @@ static void mlx4_en_tx_write_desc(struct mlx4_en_tx_ring *ring,
 		wmb();
 
 		ring->bf.offset ^= ring->bf.buf_size;
+		ring->doorbell_pending = false;
 	} else {
 		/* Ensure new descriptor hits memory
 		 * before setting ownership of this descriptor to HW
 		 */
 		dma_wmb();
 		tx_desc->ctrl.owner_opcode = op_own;
-		if (send_doorbell)
+		if (send_doorbell) {
 			mlx4_en_xmit_doorbell(ring);
-		else
+		} else {
 			ring->xmit_more++;
+			ring->doorbell_pending = true;
+		}
 	}
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index aab97694f86b..601c09020f38 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -281,6 +281,7 @@ struct mlx4_en_tx_ring {
 	unsigned long		tso_packets;
 	unsigned long		xmit_more;
 	struct mlx4_bf		bf;
+	bool			doorbell_pending;
 
 	/* Following part should be mostly read */
 	void __iomem		*doorbell_address;
-- 
2.53.0-Meta

