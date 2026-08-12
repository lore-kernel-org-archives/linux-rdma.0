Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DEC346E74
	for <linux-rdma@vger.kernel.org>; Wed, 12 Aug 2026 08:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786522638; cv=none; b=Wi/OEKkac5ZpXR+Pu92F3fy+jxZ6AQ0XXZq3YlKRHC7h+JoS+TN7Bco3LRbs358QdqgS2SlkYtq1aUUXglihPnW0rm8xD6Ij8P2Rd1KFHef+Xm63IkAqUj0a0/0TAeWPFRn+l3NTFgttLpG9kb+SKX87aijKITO/nAhXY4Bs8z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786522638; c=relaxed/simple;
	bh=Y0uZGCzRn1YmiowHTnD0wM6/o+ZrqweK6Nz/sIWUVVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nIiQBUqv8QY7F+RPW2RfwJHtBOmQrinnMNe/kKDk8vLSrDlhqqeUlX61FjOfaaSdhTbrtapL0EOscRzBu9HdnrMOvDt9/yyo7ebltA4jdFivvnki6pp0v4NShsE66KmALXbOjlcWbt1nBXzxEisBDFAeIcJ8SxrGve12P/978oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j2x+M9gA; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j2x+M9gA"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6a1995ac437so1652119a12.0
        for <linux-rdma@vger.kernel.org>; Wed, 12 Aug 2026 01:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786522635; x=1787127435; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WpdgLehVURcj1cYaXkv5Z1ZvsLVBkUIn6mZBt+a5n+8=;
        b=j2x+M9gA1yQsRQYGBOjx2HXmN/nw1A4TEqKtRQshBU20mj+fX/3qJjx7qkDFwdAKiv
         vnM+/WOAMxZJ3630RRSzWfFiKMECDzv/fjxo3BTEwJRooQDwgiZj2m5kVLuNqtj3nv5E
         zsicN1CDiwxwezdfBJ4tuuK4g7QPjq60mgvG6qNdws9uEdRkZ4ThHJ+1TG0cB9OA98hh
         47kVOkASfiCErsRUyIevBNwCmPD5kUR3ZhktUjz4lkaDLc6zEFkdlqhUEqC+vj0s8MzX
         xJhinEucWGjTntJT9demgWPMH329R0aYJMlbl0JP3b1iKbp8PkIh5PpHfdBBeDnjHfr2
         mo3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786522635; x=1787127435;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WpdgLehVURcj1cYaXkv5Z1ZvsLVBkUIn6mZBt+a5n+8=;
        b=QgpuLmAtQviRXfwfdrF0dZNJTZEi0KN9soGd/uA6DzroCLpPce93sbJKP4u98eVLIf
         UroVgZvMdv83EWnGU5DzItLgU5uUfSKDPqpnXlBLYR0uLFZmRP2pWZRqMz/uuuHeCA56
         FvCLhaEF/JuopVdJvzTiHpMVzEb8q0JrUwUhZ/dh1DMeprBSXqSy6IMQ4eXMF4XzCDuO
         cELxPVHXUvCUm1QpAjKQoBU8alCN9Bn2tDGxx0jE9wc1QRGbjj6GJQAloDLnTAYfve52
         sMht+LlrUEhUbb7lHoua1FQOvcM8gGpEWIbEBILz0iVuhbPDXZUXJoYhX7cGxn6mz/B5
         6EhA==
X-Forwarded-Encrypted: i=1; AHgh+Ro7UrcUjUGSNWBuRkTF+NcqPcnFRGLQsO+UEpGJENm5RyUFg3af/D25pGilV17pfK8qkssKGUCqoU49@vger.kernel.org
X-Gm-Message-State: AOJu0Yxj/+ZuiP1T3a19FdGjRpLAg65ZkDBsP6A09O7rtBCWWLeKA7Vj
	IeuqRRkNlDYwidEfmV+HN3qJ7DNCHqk23E/TQTqSikW6ei4Ci+bJ2n08
X-Gm-Gg: AR+sD137KouWn6w3qoaChp4pBarQCbDGsTJPp2ABxdMaPz5oceTyj71YdQNLt+bGwF9
	OEkGUjRUAndnta9rI91flMPDQt6mpAPgZ/aoqMaCoH4x+I5WDYM+MZLo6L1LNxS0JJNga/BOi2M
	VXTR8gxfccRl37HDWXLldklso1x4RBa+AYGq0O7QsKe7NHHQbQFxXNdSsK4nMGfeEX25BBgCr5a
	n6u0qyNqHojNtmyktykGJOKFZQXtxrqtbjj+i6K7aPF773RZFk6MC0d/1/OazZhF15bM6uJ+hMN
	YaUBaXBIeWTa0wZ+wC3p9zlY/WBnvAm0oqIJJyRKYMh4QTzfNmoK7rAO3XBsmtk2rwpSmIewHu9
	8FQ/eN/Gs/3yZWoyyukqxDL7EmvbwZN2ADBq0I62oEz2FSqrP8yB30ZOKd08y0hCe+J+H4P3mkT
	EMxqiYoQnjvENSqX+iZKD2vmZUbveaDto0CfEbp9CPSrLdu/GT+JFQ0Qp8nu4IVImRg/UsgIkDz
	+1d6oOl0JMtl6Tn1Rne4Cjj1RCrsoYaHP1OnTUvpif8rugeBiUrGJxlb4Wc+hp4yeqdx9vYILlL
	QsjulOlJDcJQ0O+3ARVo91NAtDSw1hJavm5Sbw==
X-Received: by 2002:a05:6402:2789:b0:6a0:de1e:c4c4 with SMTP id 4fb4d7f45d1cf-6a375ec0f50mr1270353a12.10.1786522634330;
        Wed, 12 Aug 2026 01:17:14 -0700 (PDT)
Received: from Ubuntu.ts.net (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a3769d97b7sm365276a12.20.2026.08.12.01.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 01:17:13 -0700 (PDT)
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Or Har-Toov <ohartoov@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	syzbot+5fe14f2ff4ccbace9a26@syzkaller.appspotmail.com
Subject: [PATCH v4] RDMA/core: Reject unregistering netdevs in ib_get_eth_speed
Date: Wed, 12 Aug 2026 10:16:41 +0200
Message-ID: <20260812081708.32468-1-krystianmkaniewski@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ib_device_get_netdev() intentionally returns a referenced net_device even
when it is unregistering, so matching and cleanup callers can still find
the association. The reference keeps struct net_device allocated, but does
not guarantee that the device remains operational.

ib_get_eth_speed() uses the returned device operationally by invoking its
ethtool callback. Although that call is made under RTNL, the function does
not verify the registration state first. An asynchronous RDMA port query
can therefore call into a netdev after NETDEV_UNREGISTER and ndo_uninit
have completed.

Check for NETREG_REGISTERED while holding RTNL and return -ENODEV for a
device which is being unregistered. Keeping RTNL across the check and the
ethtool operation prevents unregister from starting between them.

Keep the speed fallback and warning under RTNL as well, so the warning can
safely read netdev->name. Drop the netdev reference before releasing RTNL
once all accesses to the device are complete.

Fixes: d41861942fc5 ("IB/core: Add generic function to extract IB speed from netdev")
Reported-by: syzbot+5fe14f2ff4ccbace9a26@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5fe14f2ff4ccbace9a26
Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>
---
v4:
  - Keep the speed fallback and warning under RTNL and use netdev->name
    directly, as suggested by Jason Gunthorpe.
  - Release the netdev reference before rtnl_unlock() on both paths.
  - Drop the [PATCH net] subject prefix because the patch targets RDMA.
  - Rebase onto the RDMA for-next branch.
v3: https://lore.kernel.org/all/20260810133124.44513-1-krystianmkaniewski@gmail.com/
v2: https://lore.kernel.org/all/20260803121140.261329-1-krystianmkaniewski@gmail.com/

 drivers/infiniband/core/verbs.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 367822efff36..b31d61513335 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2058,11 +2058,13 @@ int ib_get_eth_speed(struct ib_device *dev, u32 port_num, u16 *speed, u8 *width)
 		return -ENODEV;
 
 	rtnl_lock();
-	rc = __ethtool_get_link_ksettings(netdev, &lksettings);
-	rtnl_unlock();
-
-	dev_put(netdev);
+	if (READ_ONCE(netdev->reg_state) != NETREG_REGISTERED) {
+		dev_put(netdev);
+		rtnl_unlock();
+		return -ENODEV;
+	}
 
+	rc = __ethtool_get_link_ksettings(netdev, &lksettings);
 	if (!rc && lksettings.base.speed != (u32)SPEED_UNKNOWN) {
 		netdev_speed = lksettings.base.speed;
 	} else {
@@ -2071,6 +2073,8 @@ int ib_get_eth_speed(struct ib_device *dev, u32 port_num, u16 *speed, u8 *width)
 			pr_warn("%s speed is unknown, defaulting to %u\n",
 				netdev->name, netdev_speed);
 	}
+	dev_put(netdev);
+	rtnl_unlock();
 
 	ib_get_width_and_speed(netdev_speed, lksettings.lanes,
 			       speed, width);
-- 
2.53.0
