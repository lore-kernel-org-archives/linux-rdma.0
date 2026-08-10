Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0063F2D7DEF
	for <linux-rdma@vger.kernel.org>; Mon, 10 Aug 2026 13:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786368694; cv=none; b=IhB5cgDJoYgi9fPQK4Kq0o5L76CYj+FnpKQqyy+OkjYBSK4kQUiqjBeqfm17sevvUFlyJaSOp5MIlQiv2OzwIKE0+et46udHcVE41kAoIHVPwD4xnrw/vo6aqp5U7b5LT+14ueobtQiqGrFqI/wwCxR1mYg3CQabwQFpSAQ20xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786368694; c=relaxed/simple;
	bh=RM/YxQY456kcmYEcHSeOs3p3taT/I9NV7N68DWW7lIg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Fe7r1+/Qy12tGU1fKu46Lhj8E7V17lbhcdR++pIq5fxSILMWKTp+3kSIlalMN+xByWZ3SQgbhd1vbuNtHoLmovuAt6yjKwRKv345AwEv3WAM1nZyUwOiiicQIzxVlwSE+tZV/WB0tIBY45fMaymT9T0ZLoz0jvq0h5cMIYCiy2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jGRvA1mL; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jGRvA1mL"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6a173ad7cf4so2756584a12.3
        for <linux-rdma@vger.kernel.org>; Mon, 10 Aug 2026 06:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786368691; x=1786973491; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TOePn93cV2ug+wSXgzsoigDXykI/2Vl/iaRlUy5tOD0=;
        b=jGRvA1mLer/yGp3RpNo8hRx3xE8blIsfLQlctahWprV30dKF8qPsvsqqfcbtieab6u
         Kb2lFp9/Z1E44mCvIhf9+Eh4YwKTmZmmP0hOe+OBO0+0EyK+4t9VH4pYbX7yDert7yfg
         I0Clh+q4x4ua8q0qgjFW4ykq7ob5P0+Vf4bGxoiYyeYNczwY/X0s38kMw8ZlfQEHtr+v
         oCNvVXr7MXBM5jhFIQfVQAMJpxKhK9T+O3QKsbu5ig4jZR+bBsomtVl0WJM6R3AzaoAR
         Ztfi9wRU57NmAgdj160mrJ9zLrDY06OqZ+mxh0mmglaBK9aU0usOXSxLyfxDMVNx2wd3
         aXbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786368691; x=1786973491;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TOePn93cV2ug+wSXgzsoigDXykI/2Vl/iaRlUy5tOD0=;
        b=VEjdv2TMnDqHQF9b6jvUZYYPYsJJrCBGMtyEPCXeHvwJCmNLe3R8MO8grYtUha1Ni4
         1EL6fG0lffgg9JQU+CciNO6Cm3cpL3Kbefkp3GCPT/WyCY2xPO4d7FV8MnzV10s708wN
         y4Mr52NnaoRoGQyggAELoBfxFnrxNozhN/Ip/96cQe2/IX9WVC7bK0Yxa6imv//vNzkM
         n7/6ToYTfW2ZWv/VCaYB5g7NHdoN3WI/35NLt0Kkct8S2/2F0AUNuucbTm9Tz9l2idti
         oavWqM9qLPHQeueyPxQr4fq5oyMSDqIZFl1Ll5ALWFlWFaSRQLIcICfpkRo2VkD+oX5c
         qN9g==
X-Forwarded-Encrypted: i=1; AHgh+Rr8jC/Dyri3T3VvqaLcj0A1IfbAjXCXZrvnluxEXrz3jV69BOmxA24Uz3U1tq9xoYjH4PWGYTSxb1d4@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1QNzBfZB68BSpsNdqCbCP14MGUod6vTEO6CtsrLsjJAsAC/Pg
	4oChAp9YY98XhwrQE35li1rSa+fDta9mIOM5Q2DBZ0NkAxw48noHG+5dvVdQJJzLNcQ=
X-Gm-Gg: AR+sD13ywh09KIFnVkt/K78Vk1oJGEZUQ6A3ep1dJ5lYdu08NstE3CCT5OJcbUpF118
	4ZFSquap0JgiMzmYYCckK42PJyDlqNuFKVOvn+MCDpEcmk0cNW/AsRX5JtstCkG8meih5epYMlO
	cIf8v98d4iLgZrqY3ov6OzFbPhuvNgclFXJMJaTaTAmIUyS4QokcyfUxhrLniQceFkb2mc2mHYi
	rjbSEc69/Epj/VGASx8WnDTlXliZ+l7bSbC7nzSAIg2HCu5lUFC8rNrsItHPV5Y5Y77AmOfd8Ue
	vLmXSFs2mRH7o6royy710MZj4qkmhU5BhIP9VUtZWUp1/WRQuTBEzwdFEqIIHfLbm4ndHO28vGe
	Mroju1gwrEKarsxB0QHbOarfsiig27ONbi78ej+JTdVnHHZ+25F+M3zpEeSjkk/IhYK5u0/JChC
	85V1I9K41j3NqnCe1Jmz0sfPD61Dp0MN1afBKlw0V9GJktPCWDZvGVqKpgY9y6s+8MgBpCdocBt
	WeJWBzrwSOwyoOit0QRxurtCcLia/AA8/tLAtkL5P1E6ihWrkyK7Y6Ud+V5ZZ+XG0xS30j8AYdq
	tVqpjsahSD+28Pq4HGq1UlgFtOut6bw2bAbCuQ==
X-Received: by 2002:a05:6402:350b:b0:698:e595:a5c with SMTP id 4fb4d7f45d1cf-6a355d8abb9mr1045288a12.6.1786368690814;
        Mon, 10 Aug 2026 06:31:30 -0700 (PDT)
Received: from Ubuntu.ts.net (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a1e7d48f8dsm4198679a12.17.2026.08.10.06.31.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 06:31:29 -0700 (PDT)
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	syzbot+5fe14f2ff4ccbace9a26@syzkaller.appspotmail.com
Subject: [PATCH net v3] RDMA/core: Reject unregistering netdevs in ib_get_eth_speed
Date: Mon, 10 Aug 2026 15:31:20 +0200
Message-ID: <20260810133124.44513-1-krystianmkaniewski@gmail.com>
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

Also copy the device name before dropping the reference, since the warning
path currently dereferences netdev after dev_put().

Fixes: d41861942fc5 ("IB/core: Add generic function to extract IB speed from netdev")
Reported-by: syzbot+5fe14f2ff4ccbace9a26@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5fe14f2ff4ccbace9a26
Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>
---
v3:
  - Reworked the fix following Jakub Kicinski's review: a netdev
    reference protects the allocation, not the operational lifetime.
  - Moved the fix from ipvlan to the operational RDMA caller.
  - Check NETREG_REGISTERED under RTNL before invoking ethtool.
  - Avoid dereferencing netdev after dev_put() in the warning path.
  - Added the RDMA maintainers and mailing list.
v2: https://lore.kernel.org/all/20260803121140.261329-1-krystianmkaniewski@gmail.com/

 drivers/infiniband/core/verbs.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 86811d31092c..d50e761be4c8 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2040,6 +2040,7 @@ int ib_get_eth_speed(struct ib_device *dev, u32 port_num, u16 *speed, u8 *width)
 	u32 netdev_speed;
 	struct net_device *netdev;
 	struct ethtool_link_ksettings lksettings = {};
+	char name[IFNAMSIZ];
 
 	if (rdma_port_get_link_layer(dev, port_num) != IB_LINK_LAYER_ETHERNET)
 		return -EINVAL;
@@ -2049,7 +2050,15 @@ int ib_get_eth_speed(struct ib_device *dev, u32 port_num, u16 *speed, u8 *width)
 		return -ENODEV;
 
 	rtnl_lock();
+	if (READ_ONCE(netdev->reg_state) != NETREG_REGISTERED) {
+		dev_put(netdev);
+		rtnl_unlock();
+		return -ENODEV;
+	}
+
 	rc = __ethtool_get_link_ksettings(netdev, &lksettings);
+	if (rc)
+		strscpy(name, netdev->name, sizeof(name));
 	rtnl_unlock();
 
 	dev_put(netdev);
@@ -2060,7 +2069,7 @@ int ib_get_eth_speed(struct ib_device *dev, u32 port_num, u16 *speed, u8 *width)
 		netdev_speed = SPEED_1000;
 		if (rc)
 			pr_warn("%s speed is unknown, defaulting to %u\n",
-				netdev->name, netdev_speed);
+				name, netdev_speed);
 	}
 
 	ib_get_width_and_speed(netdev_speed, lksettings.lanes,
-- 
2.53.0
