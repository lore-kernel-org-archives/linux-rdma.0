Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793135843;
	b=gD6wXE/yLFpcgdtZPzRuPz05CnhSJvQJpgrc9rQHySewTXE2B5oZ8W/M/JM7BqW99g39
	 wguNSXPGZ86kqg1heNozcK/HrdM0VMpHA6GmiRKeMRvNDKk37Lqbfr/9dYT/zxkYALomv
	 gNL2BdlK0GWv9dRaVOXi+h2Qexi3aIlmt8rBFhDzzAAcEC4aW+tRx0loiq/R2l0bKJkY1
	 MPbwqhbnbFHHSoX9x0ii8o2THtFJ/lDmCiMPGO/BK5WVXBi9h3pKxBevU2Ih24s41QuKk
	 yqPmkN31jLZlb4XTu6Xms5DnIf4LCJN8loyKwf62S28RZRqtAkZNTSR8hz/23i1CyXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793135843;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Zj22U27fdgZfpXBChZKoCg3JgtYeQCimM1Wx3cOZywk=;
	b=uGAOAjP5+jpgod2NOLBOloH1uX4VnbY7IFZGcN+KjRjy5HIaSgt6Yo8a91Qt8uWl1Hsy
	 Nc5XjxIJcXuKOi9KDumhyWmjfqihjHuZNgHGrSgaLVG8HnKDKfv2h+Uubsx5XbnqQ9Lb3
	 xlBUoU0zzQ+pGj+nTuzKkLMqUD9plEFMgaEyvvNNZ+kjEEuoeL8AVIlbxFg1ovlyIJIrO
	 QopX9Bmw2YTUMQbHxDKb6O6tom0H/hZvshvkgC8o1qsnJhF2Xr6td5y6PnfcpsD5JwFEs
	 7qGlT2eJM+6sLjWFOHYBxJlhTRLcvdhvazI9Hu42qL5/I4QsxqHLgOMTaCbhh3F9H2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lZeiPTlH;
	arc=none smtp.remote-ip=209.85.221.180
Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AC7606A323
	for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 21:17:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38AC7606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lZeiPTlH
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-5eafa528803so151888e0c.1
        for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 14:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793135842; x=1793740642; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Zj22U27fdgZfpXBChZKoCg3JgtYeQCimM1Wx3cOZywk=;
        b=lZeiPTlHAEZ5czFIkYojaFeXElGvf8EcvcnY79K2MwgRCYkV+ki2DF7LmnmkZhdqdD
         68LPGNEM4G77A5sWpApZxg/qdCt8R6RDF2nPbPZy7F45eoOPv1imvFR+V70dp28zmILX
         20izqh722ZZHyxHTOh8dSDlKoS8sbSy7RFWsWMq2bl/ZiHMaUU34KBAQ/3Q655PL7kWd
         BHScWxZ4AlfGSKwA2ep8SGYW1N3ax9p9xXgFjOZqf+PTIFym4FtS4Fquz473O4oJ9C1v
         LCuZEAHkxExZJ8m2Ny5hWjTh3bTNCROWYdkp66Gr12P8fYloGxuQkpdSanxzb8fipEhz
         FxJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793135842; x=1793740642;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Zj22U27fdgZfpXBChZKoCg3JgtYeQCimM1Wx3cOZywk=;
        b=iiwzzVsArlTdg2L1X4yeK1KlM975Amb6/FkgJkza98XAdn+L7jErocmuKnVpL0gUTx
         t+ovkUMI3vVwrzU1oMo1zDFn5IwqxkwQ6X3zkisKtiSt8oaGDUSzhAK2AKcgWCRrCZ5p
         JmvxcAoqF5NSl+IlFPN+UzEGy9cJKoqLehDJSNDle17UX+iwp33oycDab8eJGgu6vmZ7
         IL11mu/sA2ELhgaimXP/U1rtFq3xG6fpbjvk/Rbb9kEcZAl5U8fORy5buf/Dig9zA7Dt
         hCQj16Ew51ep4IufOIuXW5B1s0cwYijv9CIvimEH3wMXOmWHNzgJkJp0zEJ7/QOwG43f
         yIvQ==
X-Forwarded-Encrypted: i=1; AKwUvByETIV+QZ/YQxu9GJYDdQJ3UpJdL4G7IOA+fLdhpxBbT/CNSQOWQmFRLJsV4OXKAncNZwkoMwXkMbYQ@vger.kernel.org
X-Gm-Message-State: AFq9FYLY8QcZN5B2b+IpsZqR77oNCOH69g5NFUPiXRd4daECZstn2Y6D
	hnEpPM2LeaCRIxwNYmsu0gzK7phykRrFzOvTSXENFOPLKaolOLgk8Lcg
X-Gm-Gg: AYBFou31SyujPyb7X/kxGVjNJ15pJNozrxzsYv5yVFd6f+sGivro33HYV5vmVC5jLtM
	9WlT1FkzSatrgzFIqioTwwAb1sqaQhvVXFcFcpRk+r6mNiCYUBX5lHL2AQhjisTJ84qR7Ha6FRC
	AF4/jwOHzs3cCUdyVvK5R2nFlw2/i1Q0M9MxM796wtsyhdb5hsyHmO7mjEi2P7rcsVwXQBQowJ2
	SSQQTGqF0qQcqf4EdgtkS1hw3pNNykoGhn1MpmXRVGof9oheT5gVDos5usFD5nRT97K4oSmDfcg
	D6NGyWp3vGJsUbkiSf8ZZjMkAwg+cxKg/4h0lfPer94KqDU7cWxs5dEIaDyV8HVCrUvVTT+WpXq
	aCl0IPJqDBt0TatksZe5NyY/YT83p/ByAtI6ncZSR8+UPmskMHfCdFcKgfHfZDGMri51H9LNEuL
	H4REn8L795SD/05IS+FVYSxze/OzCD/MovV7LmbObz3LAny8g0EBujURYAyGZZSjtEFLqiu027G
	+YqWXitdQEELNfii/ZFtQkgf2BI+I1oXKyFxPIF1/wF8bvasy9p3w/ZEfCj8YQnuudJp/mmilSc
	B8+fK34sD3NthacVnmIuDhdDtFhDjy+0kWFmgS1Kob/xHCB2qM4mNTHkDPn2E++GltZ4
X-Received: by 2002:a05:6122:179f:b0:5d0:e3b7:334f with SMTP id 71dfb90a1353d-5ec4ccbc8b9mr239071e0c.18.1793135842062;
        Tue, 27 Oct 2026 14:17:22 -0700 (PDT)
Received: from 16.15.168.192.in-addr.arpa ([187.74.25.171])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec2349ebd8sm12639658e0c.14.2026.10.27.14.17.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:17:21 -0700 (PDT)
From: Joas Antonio dos Santos <joasantonio108@gmail.com>
To: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Mark Bloch <mbloch@nvidia.com>
Cc: Cosmin Ratiu <cratiu@nvidia.com>, Boris Pismenny <borisp@nvidia.com>,
 Sabrina Dubroca <sd@queasysnail.net>, Andrew Lunn <andrew+netdev@lunn.ch>,
 David S. Miller <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2] net/mlx5: macsec: free struct mlx5_fs_id after an RCU
 grace period
Date: Tue, 27 Oct 2026 18:17:06 -0300
Message-ID: <179313582625.87630.11382992904624255106@gmail.com>
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

macsec_fs_id_del() removes a struct mlx5_fs_id from its rhashtable with
rhashtable_remove_fast() and then frees it with kfree() right away.

The TX (SCI) table is read locklessly from the transmit path:
mlx5e_macsec_handle_tx_skb() and mlx5e_macsec_tx_build_eseg() call
mlx5_macsec_fs_get_fs_id_from_hashtable(), which does
rhashtable_lookup() under rcu_read_lock() and then reads
mlx5_fs_id->id. A transmit that looked the entry up just before it was
removed reads freed memory.

Before commit d4ece08f4b1d ("net/mlx5: Maintain fs_id xarray per MACsec
device inside macsec steering") the SCI table held struct
mlx5e_macsec_sa directly, and mlx5e_macsec_del_txsa() freed it with
kfree_rcu_mightsleep(). That commit moved the table into macsec_fs.c
with the new struct mlx5_fs_id, but frees it with a plain kfree().

Add an rcu_head to struct mlx5_fs_id and free it with kfree_rcu().

The same issue was flagged by the Sashiko AI review as a pre-existing
problem while reviewing the HW-GRO for PSP series.

Fixes: d4ece08f4b1d ("net/mlx5: Maintain fs_id xarray per MACsec device inside macsec steering")
Link: https://lore.kernel.org/all/20260909065542.4B80D1F00ACA@smtp.kernel.org/
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Assisted-by: Yaga Agent HackerSec Claude:claude-opus-5-5
---
v2:
- Drop the macsec.c hunk: the sc_xarray_element free was already fixed
  by ad17ad50b8dc ("net: mlx5e: Fix use-after-free of the MACsec xarray
  entry on RX SC deletion"). (Simon)
- Embed an rcu_head and use kfree_rcu() instead of
  kvfree_rcu_mightsleep(). (Simon)
- Fixes: now points at the commit that introduced the kfree().
- v1: https://lore.kernel.org/all/179285888829.90275.17386097105525068016@gmail.com/

Testing: compile-tested only (arm64, W=1, CONFIG_MLX5_MACSEC=y, no new
warnings). I do not have
MACsec-capable ConnectX hardware, so this was not run on a device.

 drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
@@ -94,6 +94,7 @@ struct mlx5_fs_id {
 	refcount_t refcnt;
 	sci_t sci;
 	struct rhash_head hash;
+	struct rcu_head rcu;
 };

 struct mlx5_macsec_device {
@@ -684,7 +685,7 @@ static void macsec_fs_id_del(struct list_head *macsec_devices_list, u32 fs_id,

 	xa_erase(fs_id_xa, fs_id);

-	kfree(fs_id_found);
+	kfree_rcu(fs_id_found, rcu);

 	if (macsec_fs_is_macsec_device_empty(macsec_device)) {
 		list_del(&macsec_device->macsec_devices_list_entry);
--
2.39.5
