Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795140963;
	b=AbbszMqBad/1NtCQ5KU0y/ShfNKsC2Dml3XNgbS2FlVwffGUYhdYmv9u8xyAAeWQzEuW
	 3CRfrYOymO4zkwxTGSJgtsEBSHMEM2CgIeKE4B4rDO/XhHHxGPGW6v/0OMr0BMoiMCuOK
	 WmSIDqVIP/d40IHdvMES+PNh56hP2i93PwKOdXufnjNRQO+9htvVhHvwwNA4ytPMrUMxH
	 Hnal6EX+IFDnU1Kiw7/AjpoBlwPYyiZBmawtrG9y6Nr8ysG1nC/JDdTpJX/+tDZ2TyLHy
	 l1TgzW/uO6JdIHQmkEMt4wBik90Uyq4QZ0qh2fen3I/wbrOzXV2hv3/PE/isIYOADcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795140963;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=wNFHaznprkYFxrl6N69NiI4gThn5TQVVfoHkGgTnqYU=;
	b=y7IP4Ryjle3tw+Q5p6424r+wHQ+SXafx73NFA7kC02DZYlksOmUKMQvjSXxdNDVij+kb
	 tlEyw/vNDlfj0xr54lqhegV1Fyok/7cELSWKhcFqth+zgQ5FchygtFnjxLZFoCjstFc46
	 Gry8g5RpHtgTi11PrHCaJYD8cEb8LRIEG61eO8Z1VNOjKT/AyjsmIJmDFG70E9CaiWZz4
	 ZdibRVAKhCapxqfj4fWLwNP08MlhJms8SyPk7lomIbMiasUR9b0bsTSBTww0YlYjcFAKx
	 DR5K9/wiPn5ymGHEIrfuygEkuJ7bIQcD/1YL3kqn5XQdt6u7fB5zYEhS6YIgBv9wMvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="Uuu1/tF0";
	arc=none smtp.remote-ip=209.85.222.170
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9DC606A32A
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 02:16:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD9DC606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Uuu1/tF0
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-9495d543b91so26275285a.0
        for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 18:16:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795140961; x=1795745761; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wNFHaznprkYFxrl6N69NiI4gThn5TQVVfoHkGgTnqYU=;
        b=Uuu1/tF0lfIbNcFFA5RelpnOOFHlqPgFEyge8uGAAcpVNHYb7VRu86qDPllD877b9H
         b9JCgahf7j9nr9Wk6YQR7CItht+a7kIhxujCe3BohcxwygPWFJZ2BLNQOlPk6Z9Sp6fG
         2f69HceylDSJmVPnPVb3gKoEUOjeQR/gqbHI4crJrVMh4s0FET4VBwA2pkyZDP9aBRph
         CKimzSVZH7kKCxujyQvrrNOBVYCipYLA3h4TrVcYRdX7pltjiL2jCFYhhSdyAqQlh5XK
         JJ9ZfEOb2S+rumA8JkDSIAnQFPcEuCbZTJ4QgokWnZUfWzABlTrNAdzdGY1C6ZJ/6gyr
         21nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795140961; x=1795745761;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wNFHaznprkYFxrl6N69NiI4gThn5TQVVfoHkGgTnqYU=;
        b=zHEPP0LLEPgU2asxwnJVt12JQTZ6TULzWvD2xyxQYYvgGa+w41Ffta23yVQlG/GYrH
         Fge+KwdNgziAti28amdi/Yt/La1B5S5viFtvcdYWP+gwTI+o5EaotsYnSW6e52/nV1Y7
         9UHlN4565FKDDNsnSNLP7GGgzmOPhYlb+J1sbXQslqfiU6C74Qp1HKETWZLoiZ6qEOfM
         fW8Cbu23oGxTgNXfymzYsOik46HANbDsMhMzMZGa1GzC9H0c8dLo2m0MOsb6zJqaD5ZI
         4l3PzgMD13ONECl7JmEMnP2M+rfdZYPWBaobo3z2xiyHYinDKzvLd4NrTKnU13aL/CDs
         FDXg==
X-Forwarded-Encrypted: i=1; AL+hErGsOKYVBM/sPCWfhPE1Co5nU8ZXVy7TSwcxS94iWrqqOINqf9at4IJpCD2gjHSy0QaWfhYiDuRHAqHt@vger.kernel.org
X-Gm-Message-State: APuU4Z9+s9/qUKMVopitoy0VzN5nCmMC1+BiXc0vxbRFVIt3Vs75zxi+
	XCANOCRJYO8MM6YIuMMh0vacRjsfGZCJStRyCHOqwapxy6ajN+bVAcB4
X-Gm-Gg: AYBFou3ze+5ft75Cgo09P6dCe6BLZYLVpGNHf9CZM37Q0WT/8EekvQ6d0EJMW0WRizI
	3qzCyHOPfigqdsyg4DkPyYH/cJeKnF79Q5p8Qq/N0VI5DixxMcdIplJgnEJkMUfHCh0ClIwuq+3
	E8y6cCd3/hyAZGPoMt25f2RqfPvxksLbOkxXyPZkZB+4LVx9FHaJFnDG8FWqBToy920wRbOnOdS
	LMF/DXlPyIP+bYiQG7psj4hJqboxJxf7rVQH4lEGQO5bcMOx8ndGlyQMKPWBY+K4V391NA+jWZc
	U6GG1tSlchotYvWLFhOR6JdMY58lCq8TSQDUUTcPf9myuBoHO04/xwaEqnJAvSDe6pHAx8TZ1O9
	8aIj80aAk0XhX5UOdl5c/FGrXjV0OJ2b3C+x/8SLWhS82RabhLxx7CX60V12UsViCwqYqcApgjK
	Qa0t+a8klPg00w2+EF3vbtI73S525JLI19xYPtpy8iK7KPrteJ3Fp84Lwm6YtgrvGJjG0bJYIh9
	6Vse/WWgyLdkUcM4ZFjZqju1L/xYUYjDVEof57vWmTKtAKktw9bAmG0Aobowr/MouDcPhRwK9eF
	xZPLINLOg6Y6BhsCvOGE+gRYbZoSSpav0EeBV0JCTthmUJ8GhFDT2liTq/clkSiAo2R59N9KDUI
	=
X-Received: by 2002:a05:620a:2b9a:b0:93c:62c4:e2e2 with SMTP id af79cd13be357-949ba8246e2mr284773685a.12.1795140961426;
        Thu, 19 Nov 2026 18:16:01 -0800 (PST)
Received: from linux.. ([8.34.174.240])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb3bec3dsm91755285a.23.2026.11.19.18.16.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 18:16:00 -0800 (PST)
From: Changyul Lee <lcy8047@gmail.com>
To: Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Gal Pressman <gal@nvidia.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Changyul Lee <lcy8047@gmail.com>
Subject: [PATCH net v2] net/mlx5e: Skip hairpin entries not ready in debugfs dump
Date: Thu, 19 Nov 2026 21:15:57 -0500
Message-ID: <20261120021557.1630138-1-lcy8047@gmail.com>
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
Content-Transfer-Encoding: 8bit

mlx5e_hairpin_flow_add() adds a new hairpin entry to hairpin_tbl and
drops hairpin_tbl_lock before creating the hairpin, and sets hpe->hp
only after mlx5e_hairpin_create() returns. Other users of the entry wait
for res_ready, but debugfs_hairpin_table_dump_show() does not, so
reading hairpin_table_dump in that window dereferences a NULL hpe->hp,
or an ERR_PTR when the creation fails.

Skip entries whose res_ready is not completed or whose hp is an error.

Fixes: 8a0594c09610 ("net/mlx5e: Add more information to hairpin table dump")
Signed-off-by: Changyul Lee <lcy8047@gmail.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
Changes in v2:
 - Point the Fixes: tag to 8a0594c09610, which added the hpe->hp
   dereference to the dump (Tariq)
 - Add Reviewed-by from Tariq

v1: https://lore.kernel.org/all/20261119012707.555494-1-lcy8047@gmail.com/

Found with a static analysis tool we are developing.

Compile-tested only, with x86_64_defconfig plus MLX5_CORE_EN,
MLX5_ESWITCH, MLX5_CLS_ACT and W=1.

 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 1d35c97aea0b..c6623f13261b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1067,12 +1067,15 @@ static int debugfs_hairpin_table_dump_show(struct seq_file *file, void *priv)
 	u32 bkt;
 
 	mutex_lock(&tc->hairpin_tbl_lock);
-	hash_for_each(tc->hairpin_tbl, bkt, hpe, hairpin_hlist)
+	hash_for_each(tc->hairpin_tbl, bkt, hpe, hairpin_hlist) {
+		if (!completion_done(&hpe->res_ready) || IS_ERR(hpe->hp))
+			continue;
 		seq_printf(file,
 			   "Hairpin peer_vhca_id %u prio %u refcnt %u num_channels %u num_packets %lu\n",
 			   hpe->peer_vhca_id, hpe->prio,
 			   refcount_read(&hpe->refcnt), hpe->hp->num_channels,
 			   BIT(hpe->hp->log_num_packets));
+	}
 	mutex_unlock(&tc->hairpin_tbl_lock);
 
 	return 0;

base-commit: 342e62fd34c2674e82bffc89cb5c7091924986d9
-- 
2.43.0

