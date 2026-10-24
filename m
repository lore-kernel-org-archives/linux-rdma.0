Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792858894;
	b=NA2YEPIEKQ6TkOk8Pdupvp8CmZTAtb7B2FiUudhqE8BQOamjjqRV7pbWRsHu85h2nghW
	 FtP29HylKV+FeCGuT/h/nduCNWCQDxbTs+NPsBOBt33cTWsHOhu310v/V3MpjsoDqVl/t
	 Yozc67n7gSIu7PC+vP2Mmp/JeBKuT65DRwRYUtkQQtRq5VSZ1uPK0WXpxyGnGrbv8zUoj
	 dMnLFlL/kNBrMYPi+j1aOG7w/bRH0yhbOcB52dApcYBKDYiGDgbyYtq9JuzQyjClI1xlH
	 3MQ9CliXY6uozy/fxgAGxzDWm6tEj/Zu8rC3VKwmecnXn3whf3XyRaKj2PTfGWmVdLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792858894;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=F6yz0j17ZlA2N3jpWRgDpMHKo6hhIh1hOz7KuS7dRpI=;
	b=iGJYbo8Y7L8G8/Z/sAwA+29FU+qHx9bpzFLKQYDSddPS5qZipUkf4T/MovQndq3t3+B/
	 E5oX57G2QOtSkp0jXnNbl3UKLpYYSWRlP31UFGSgyoD/uECql5QNSXsWmeUUbtzb9odPY
	 bcCpJr53ictPss/SAQ0UVDKHjoU4Lck3EWgnvp/so5E8ZqQO8HTPlxkMFc1c0UaDSvz/+
	 0IeL8ZYadcREYcaWjpurBH6+7Lfe3oIfSzMc/L0lipaGB+wWRa1CzaWIugChF0kJ8E/Iu
	 ZLHzTUBzDzH0B4nq8g5xZBNLrqsYo3YpT7KnNw8/ixmalHt5flQ8TjlCq6StsyAXibw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=BXiZ4od0;
	arc=none smtp.remote-ip=74.125.82.177
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A7D606A31B
	for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2026 16:21:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7A7D606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=BXiZ4od0
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-35943f55c06so2303586eec.0
        for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2026 09:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792858893; x=1793463693; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=F6yz0j17ZlA2N3jpWRgDpMHKo6hhIh1hOz7KuS7dRpI=;
        b=BXiZ4od0QPRwbJ1HEHXEZYLtBvs7l27b1YDBlLvDljIyAU63OB2ocpUGaqbitr2UE8
         U9e0mn5TdgBq7v01NRToS0bUYeZ3PR3hro5KVsLTqXLkuMfKNDMLsfC5VCIXUVxpacZE
         9PzBO2uJItxIj8DK0OUoHfDnoCp6yABJB9gzY+MA0D+HUlLt1hHSk9AafZcJYU3oRQGo
         YMaDEe7nTEcdJ7kVLy6iwzRB5F/wq+tlPyySqeVVfjk3SK72yGCggtnuaG7vlqNCkwd2
         31YuO5ewL3hZuVXK8W+asKZG8KXhBVQETyfuXpXib73rIXukDf7u3E3lCfBWljhb6hfG
         kRBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792858893; x=1793463693;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=F6yz0j17ZlA2N3jpWRgDpMHKo6hhIh1hOz7KuS7dRpI=;
        b=YqgeCQw2JJ8hHfEqjkmwOdXg77naD+Iiw1oDjy97tmaW6+WGEc4IFhgwgs1TRzvJW+
         2EC5mbQNx2FIAeSigh9XVwymgyDDlS2ad4YNiDOTCveEdnmPN2FslF3al9Ya7ejjVyVZ
         jMakiDu4zq1pR6wh/8xxmWSIU2zlAqqiDQTYuPKo9Ay8ANs3WFKj8gXL3sJ8oODKShMm
         OKfS4a7IwY+QFkyepV2w11IQ7nVjbJSx4k07NY1O6VSUAlQVas/FdRWfkFOg0ZAjwh8f
         nyZ0rEkKA4y1mu8f9qtaIMX0/dbv5wWtEAKjtH/I0EbcFamcp2dS9l1ISOvuSNqdXmNV
         XXFg==
X-Forwarded-Encrypted: i=1; AKwUvBzvv5LCxGMc9DZjvT+Se+PMhibNFYJTcyk9rYecBP+v7IdoH62wYnhfc+qO9PsOjzhKtT1oJZSXS66k@vger.kernel.org
X-Gm-Message-State: AFq9FYJUIhie11yp5VjCXlaxl0ZWLFOGJN7YblcXNp7PTqnoCO7aO/wV
	ZruSdf27ShHc+QhZZUbfESuD3+GZjrJeaz1fvKgivaeZRqpXKim9G5ur
X-Gm-Gg: AYBFou2NGEOCF7VCOqFVDsdYUGN1hpDoGqCa4nwPhHiFYt29Lrt+87K3bDh+RRreFAm
	/0wc0S61mF1oPoHh0D/Jm8OiI2s8LXOq6db/9yM48SCbG6alNoxDiQ9JR9RlxL+GY6TJnzLfBGu
	PIPfPmBMFoE0VcllWd2VQ5460j6oxjoFyVCDslWxcoO2ctZGPIC5gnnW6JMY5ayf7IVyJCiFLUb
	2/rO74Y/dsJRdJhH4uPa85H+Dq+xs+R7wHvRIVUe3LWqwW+BeOTih/dShsVrfQ0v2lHvYVuFz/w
	XQWuR8OyJuFscborrxeppeYaarfLfY5+/xtW82JKnbF+HEz7KcZzxU9z+oEPKOr9rOtKKz3uUM3
	WhBWHGgAcrRYCXkiYEAtaQ1UpZ5CeWVPQuT2PhbrCzMmJPMu96EIcTp/qHYDUaF23bfwhGoWx8D
	XzRYbRimccMyWOfGPaVYj8dqfRePjyeUudhUNtajU7TLU7VhOxnZxYpF+AXHJbybIRf7PngwU9o
	TJuBRsDpXgd9RJsGmizkGp4sCRAYdiwEj/OGloCPpIH6rV26y1H3P0hhK/mPpLbJPWuneuXC6NZ
	WnAG6AAMx4U4NVsIrlSshpdc5q3rBWlVnDqD+AjcUtI8HHCDCL1UsYUx4na6AT7r0FuLEIugn3p
	ElYll8ty1WcXY6l+dxwBjXDM6I1hkatgNyKVPEhHvcw==
X-Received: by 2002:a05:693c:6395:10b0:359:3991:ce1a with SMTP id 5a478bee46e88-369e84dd2demr3177495eec.16.1792858892703;
        Sat, 24 Oct 2026 09:21:32 -0700 (PDT)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa ([2804:7f0:b101:277b:c08d:c9f9:7c08:79c4])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8ec4d73sm11664942eec.22.2026.10.24.09.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 09:21:32 -0700 (PDT)
From: Joas Antonio dos Santos <joasantonio108@gmail.com>
To: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Mark Bloch <mbloch@nvidia.com>
Cc: Boris Pismenny <borisp@nvidia.com>, Sabrina Dubroca <sd@queasysnail.net>,
 Andrew Lunn <andrew+netdev@lunn.ch>, David S. Miller <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] net/mlx5e: macsec: free SC lookup entries after an RCU
 grace period
Date: Sat, 24 Oct 2026 13:21:28 -0300
Message-ID: <179285888829.90275.17386097105525068016@gmail.com>
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

macsec_del_rxsc_ctx() removes rx_sc->sc_xarray_element from
macsec->sc_xarray with xa_erase() and frees it with kfree() right away.
mlx5e_macsec_offload_handle_rx_skb() looks the element up with
xa_load() under rcu_read_lock() and then dereferences ->rx_sc, so an RX
completion that loaded the element just before xa_erase() reads freed
memory. rx_sc itself is already freed with kfree_rcu_mightsleep(); only
the element pointing to it was missed.

macsec_fs_id_del() has the same problem on the TX side: it removes
fs_id_found from the SCI rhashtable and frees it with kfree(), while
mlx5e_macsec_handle_tx_skb() and mlx5e_macsec_tx_build_eseg() read it
through mlx5_macsec_fs_get_fs_id_from_hashtable(), which uses
rhashtable_lookup() under rcu_read_lock().

Free both with kvfree_rcu_mightsleep(). Both run in process context
from the macsec offload ops, outside any spinlock, so sleeping is fine.

The sc_xarray_element issue was pointed out during review of
"net/mlx5e: macsec: fix use-after-free of metadata_dst on RX SC delete"
and left for a follow-up; this is that follow-up.

Fixes: b7c9400cbc48 ("net/mlx5e: Implement MACsec Rx data path using MACsec skb_metadata_dst")
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Assisted-by: Yaga Agent HackerSec Claude:claude-opus-5-5
---
Testing: compile-tested only (arm64, W=1, CONFIG_MLX5_MACSEC=y, no new
warnings). I do not have MACsec-capable ConnectX hardware, so this was
not run on a real device and I have no reproducer against the driver
itself. The free-while-reader-holds-RCU pattern was reproduced with a
standalone test module under KASAN (slab-use-after-free on kmalloc-16),
and the same module showed no reports after switching to
kvfree_rcu_mightsleep().

 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 38a3415ac..fb9126f6b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -839,7 +839,7 @@ static void macsec_del_rxsc_ctx(struct mlx5e_macsec *macsec, struct mlx5e_macsec
 	list_del_rcu(&rx_sc->rx_sc_list_element);
 	xa_erase(&macsec->sc_xarray, rx_sc->sc_xarray_element->fs_id);
 	dst_release(&rx_sc->md_dst->dst);
-	kfree(rx_sc->sc_xarray_element);
+	kvfree_rcu_mightsleep(rx_sc->sc_xarray_element);
 	kfree_rcu_mightsleep(rx_sc);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
index efc516749..910fafe40 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
@@ -684,7 +684,7 @@ static void macsec_fs_id_del(struct list_head *macsec_devices_list, u32 fs_id,
 
 	xa_erase(fs_id_xa, fs_id);
 
-	kfree(fs_id_found);
+	kvfree_rcu_mightsleep(fs_id_found);
 
 	if (macsec_fs_is_macsec_device_empty(macsec_device)) {
 		list_del(&macsec_device->macsec_devices_list_entry);
