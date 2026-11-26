Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795675893;
	b=dFcKDphHTVvlD29t+lUHhRh2ue1xN+V4EM1odbnkRaWYSAmxrikLqnjwsCPbEqQlSLUA
	 ryqMfZ9rL06rrbcvBiQeKwA202qLgrOUlv0pILoReRX2gHdjSHvpfS5D34gvuie+yBjwm
	 HdHytYTGPHEy+eW3AYA7SN2Z7dleOAZ3rWCN6mGQASIj0+0Hku9V/ZN2A3Z1/TMLYHXYe
	 bgj0bosUXj9ZW/vexBTV0LKwx4jjULI9fcM9u4d8QPPsDjdqcU4YS5AXNq6kEReJv2VWr
	 Anb+vo+ZvRJdF92AdNu8lybq2SuVg/rg1niZaXIUafT8XOzkd9vloEx2Hlw/C/prEpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795675893;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=DHCozN9JrY6MiRB97cSuDVSXqa+xnjEHMUFjC66r4DU=;
	b=xDd80WWcKF3sSyRGEtFb+jcIBSHUWWClTTxytpFxsrKX42Yz6TC+AIK3xpi5YLHHSlXh
	 +jip/inN/lbkRF9eZ/g9x7A4lUf7khD8dau9cLLlEwqgsbl0vqjECJQ5ImskM9LHyPvYQ
	 okK/esFFkRorqPj/TB141V+bud52kgUVwkhOLWWTXIOKDef4kJJrokFX38yW7X9YNz+3M
	 90WRKZo/3SktMFbUrrMq+Ig92mzciQWzhYRtQLjCyvWdIma0VDPN4sNRIrITn9wKW+5VZ
	 3e8FjfXWV0aXIoxcw7oQT3HMGpJkIUoFAeGgfDFHYvoh3Mce2fJTFIDRYrTNuMtSD3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Xsz0lj54;
	arc=none smtp.remote-ip=209.85.215.178
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82702606A31C
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 06:51:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82702606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Xsz0lj54
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cde5a7d7849so2951776a12.0
        for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 22:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795675893; x=1796280693; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DHCozN9JrY6MiRB97cSuDVSXqa+xnjEHMUFjC66r4DU=;
        b=Xsz0lj54hemFxEugLEh4i+luJJOrVzu1WT1KQ7zX28IPjRlTmpQTc1sRaOy09bpVnT
         isdNYUH8QgxR0p/qLUpgP9VvPAKj4wEY9AKT2RXPKwSr1tzwFvHcT+df5kN74UvHp/5Q
         PvAtHlVRMkg5dwyKLafWdjEhaBCwx1xsOjL53M1dCzfIBk2xVqyUZEkguQVEG+lzzIp6
         4oVkp+Yv861irG6y3YgBpW4+MCHYV69Cv/a1bj9rHnbAX+0DxW6cCXxqHBAnxCuGUDet
         c+ZnPqLcOWNh6V16F8Q8546KVOWKvfBCTdv+tQ8xgxYmn35nSVNAq3lOrwrMesxMEYdY
         YPQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795675893; x=1796280693;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DHCozN9JrY6MiRB97cSuDVSXqa+xnjEHMUFjC66r4DU=;
        b=Io9lIbbylI3LhuNauujMzSvNS0RGcUt3WG+BxPgte5wBu0c6AXgNCRFhbiiYnPdRH5
         pI4C7DVLozWrw5Ru7cU2fF7XLuU8LV2OmTw4xtWHvhUcFfkUu8Z6QfAtSl6fRo4Mpsj7
         kn+XLgiyaKr7H0FJAtqteLN5BZzG2fvQtBIMxMl4sIfdraCqw3RI7kD5mwE0GntjIZeB
         llJ0H9gH638DLjbPOHK5hWeNSbS10sDVz+s+wAFfkuSjPZi3PItBQcynPya0hvNgxlLr
         /XLlZtdc631Np3zCofMTFWf1QyI0DrmYTdznjHhI2NWHevFORKBZYaYh8BtLaFi33DP5
         ch1Q==
X-Gm-Message-State: APuU4Z/mwjMHWseeo5Sp8ijE2dKwXqutjE+Fxu/ZZBZ1GLrwgOlieOq9
	h2XcTy92TRW4mnMeGlrSSeHooBbgYZ9r+iP923Zu4qq9jqhz4sG2VbXm
X-Gm-Gg: AZFdTZeJUw+VN00hqYRv5pgeIUn5xKO22yg1AcKsocOTgbDhHUriV3XFkyn3hvNccTT
	RhGMxrTH8xb2wZ3AHefX56/8FQ3ET9cJ0lFX4SYQzOZZKflP5Cok1AKDa+Xp32qn26kyeosuMVY
	cM/egqAXg6Udyusr5t/GC4oBZ2UK1iZUCYUPM2qZTHDoYhcywF2HspVlvvWDVOTeoiXLxgcry/9
	oVeW+hRllHg4HwXbiEuL8gJrsvHc1fHWSr6lPCPd0iQtzaiVdONf4C/XH+4amPm2OvVDX20w21h
	I4kKfSM3Ps86ccnRVgEtowAghif6oIgGSuLi68CKtMGNVlWw0ALH3m6yPdK5nUy63p1Hy2EFe8b
	HbotYDSY5J+XmtHpKUVfxdapxkdpISGNjDzHh7CC7X1IbJ7RmG6/hV1lUBvjJUtgu4nXXHv3Iqz
	X4hr6RXEs21YksYoMA9NOC3617PDRk3dr1QkwH9xEugx5YHHF+AmleFg+/IKiGwYNM+ScooDZKT
	B6fvhyMpYjLlFhe7BY7WhtEpRH2IlDHFIQi89nIpRXSgomCZCtpJe9/NB3mKAjFiCkdY1p9TDy7
	h6vWVcPmEmj5r/FfHQr3eTuYotQWr7RJzUL4gei7Zlp4p0KDkJj4eF1/CNIJF8S3QVH5nJ5JtHw
	+162NNEJJ5MN2APOsrTTy0ZQlqnzsTHOPitR8LlzL7arSFFE13LZmJAuVJ/KoBPp7yrVKImIetQ
	y5UTsqTK7434cPpYyME/vJtH58mHElng/o5NiMKM95
X-Received: by 2002:a17:90b:5907:b0:3b5:29e:11b4 with SMTP id 98e67ed59e1d1-3b5029e1464mr2945413a91.44.1795675892739;
        Wed, 25 Nov 2026 22:51:32 -0800 (PST)
Received: from LAPTOP-3B99V33A (ec2-3-38-183-164.ap-northeast-2.compute.amazonaws.com. [3.38.183.164])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b4afeaaa84sm15377795a91.10.2026.11.25.22.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 22:51:32 -0800 (PST)
From: "Bin Luo (University of Electronic Science and Technology of China)" <luob87709@gmail.com>
To: jgg@nvidia.com,
	leonro@nvidia.com
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] IB/ipoib: re-lookup mcast and pin ah across lock drop in ipoib_mcast_send()
Date: Thu, 26 Nov 2026 14:51:25 +0800
Message-ID: <20261126065125.1082-1-luob87709@gmail.com>
X-Mailer: git-send-email 2.51.0.windows.1
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

In ipoib_mcast_send(), priv->lock is dropped around ipoib_neigh_get()
and reacquired without re-validating mcast. During that window,
ipoib_mcast_dev_flush() can unlink mcast from priv->multicast_list and
priv->multicast_tree, and ipoib_mcast_free() can run
ipoib_del_neighs_by_gid() and ipoib_put_ah(mcast->ah) before blocking
on netif_tx_lock_bh().

When ipoib_mcast_send() reacquires priv->lock, it can attach a newly
allocated neigh onto the dying mcast->neigh_list (leaving a dangling
list pointer once ipoib_mcast_free() calls kfree(mcast)) and access
mcast->ah after its reference was dropped. Furthermore, mcast->ah is
dereferenced after priv->lock is released without holding a dedicated
reference when neigh allocation fails.

Re-lookup mcast with __ipoib_mcast_find() after reacquiring priv->lock,
drop the skb if mcast or mcast->ah is gone, and take a reference on ah
under priv->lock across rn->send().

Fixes: b63b70d87741 ("IPoIB: Use a private hash table for path lookup in xmit path")
Signed-off-by: Bin Luo (University of Electronic Science and Technology of China) <luob87709@gmail.com>
---
Found by code inspection. Compile-tested on x86_64 with W=1 and KASAN (drivers/infiniband/ulp/ipoib/ipoib_multicast.o); not runtime-tested on InfiniBand hardware.

 .../infiniband/ulp/ipoib/ipoib_multicast.c    | 21 +++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 379b783..81393a2 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -792,25 +792,38 @@ void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct sk_buff *skb)
 		}
 	} else {
 		struct ipoib_neigh *neigh;
+		struct ipoib_ah *ah;
 
 		spin_unlock_irqrestore(&priv->lock, flags);
 		neigh = ipoib_neigh_get(dev, daddr);
 		spin_lock_irqsave(&priv->lock, flags);
+		mcast = __ipoib_mcast_find(dev, mgid);
+		if (!mcast || !mcast->ah) {
+			++dev->stats.tx_dropped;
+			dev_kfree_skb_any(skb);
+			spin_unlock_irqrestore(&priv->lock, flags);
+			if (neigh)
+				ipoib_neigh_put(neigh);
+			return;
+		}
+		ah = mcast->ah;
+		kref_get(&ah->ref);
 		if (!neigh) {
 			neigh = ipoib_neigh_alloc(daddr, dev);
 			/* Make sure that the neigh will be added only
 			 * once to mcast list.
 			 */
 			if (neigh && list_empty(&neigh->list)) {
-				kref_get(&mcast->ah->ref);
-				neigh->ah	= mcast->ah;
+				kref_get(&ah->ref);
+				neigh->ah	= ah;
 				neigh->ah->valid = 1;
 				list_add_tail(&neigh->list, &mcast->neigh_list);
 			}
 		}
 		spin_unlock_irqrestore(&priv->lock, flags);
-		mcast->ah->last_send = rn->send(dev, skb, mcast->ah->ah,
-						IB_MULTICAST_QPN);
+		ah->last_send = rn->send(dev, skb, ah->ah,
+					 IB_MULTICAST_QPN);
+		ipoib_put_ah(ah);
 		if (neigh)
 			ipoib_neigh_put(neigh);
 		return;
-- 
2.43.0

