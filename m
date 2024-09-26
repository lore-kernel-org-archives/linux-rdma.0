Received: from stargate.chelsio.com (stargate.chelsio.com [12.32.117.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4408C33C9
	for <linux-rdma@vger.kernel.org>; Thu, 26 Sep 2024 06:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=12.32.117.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727330663; cv=none; b=qC7JjqWEu2BUgA76EXuWbe+CNcqNy78nf0FXfoTLUpdaZ8x25CXd9ZIQTwcFN7STp+OxKonxaYzC9pYxnmAnnIwf+6NIxLUVdbN9pfZWt5MqoTnSms48LDiqdwJDQ/VqZZ//5q1Yeic93XTgBL196QOYUPKDOOWXuiZdI+0JEKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727330663; c=relaxed/simple;
	bh=DS8GnTRaRSIfUazxAGfUcF7uUvZdb8vIxl2EL63Udy4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=i+H0+XKaicOZVGg9vi5svtnPtL+F6ZMTIKmDJGKd+EwYe5V1cW6IIutiQGQKaM7D/m22EyJpLVlwzHY+Ze4B5eFN82ptwKplrr/ySB9KG9iPBiJaWwwXHKXDKxAYRE3uk74p5QEwphTjGkLZcnfrcmZXcKzzLc6sTUi5hSLIPTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chelsio.com; spf=pass smtp.mailfrom=chelsio.com; arc=none smtp.client-ip=12.32.117.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chelsio.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chelsio.com
Received: from beagle5.blr.asicdesigners.com (beagle5.blr.asicdesigners.com [10.193.80.119])
	by stargate.chelsio.com (8.14.7/8.14.7) with ESMTP id 48Q64FTq025845;
	Wed, 25 Sep 2024 23:04:16 -0700
From: Anumula Murali Mohan Reddy <anumula@chelsio.com>
To: jgg@nvidia.com, leonro@nvidia.com
Cc: linux-rdma@vger.kernel.org,
        Anumula Murali Mohan Reddy <anumula@chelsio.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>
Subject: [PATCH for-next] RDMA/core: fix ENODEV error for iwarp test over vlan
Date: Thu, 26 Sep 2024 11:37:08 +0530
Message-Id: <20240926060708.82018-1-anumula@chelsio.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If traffic is over vlan, cma_validate_port() fails to match vlan
net_device ifindex with bound_if_index and results in ENODEV error.
It is because rdma_copy_src_l2_addr() always assigns bound_if_index with
real net_device ifindex.
This patch fixes the issue by assigning bound_if_index with vlan
net_device index if traffic is over vlan.

Signed-off-by: Anumula Murali Mohan Reddy <anumula@chelsio.com>
Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
---
 drivers/infiniband/core/addr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index be0743dac3ff..4e02d5a2b35f 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -269,6 +269,8 @@ rdma_find_ndev_for_src_ip_rcu(struct net *net, const struct sockaddr *src_in)
 		break;
 #endif
 	}
+	if (is_vlan_dev(dev))
+		dev = vlan_dev_real_dev(dev);
 	return ret ? ERR_PTR(ret) : dev;
 }
 
-- 
2.39.3

