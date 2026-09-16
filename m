Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE86F3DA7E4;
	Wed, 16 Sep 2026 18:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789583648; cv=none; b=IIHyBtOUoTeA2TS9Sg6COHql7Bo7d5VT/TUFh2RUCJnj/HgqbA8xLRAf7nIEcAvK3S6UpS3NnSNu/XPlOab+v/vdSLnMJ7YJyl+ZWAmMLQnLlN9yGOGDqGcZS4xU4tvKhV0hhd8iPXEyg4NZQf2J9l+zSE1LLnFcXoeL0TKPsN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789583648; c=relaxed/simple;
	bh=wqGQJFxvZNp1iyyk6tqUxkLKafrnCV6iotPlpsp7Cz0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oJ8EZ9nnd3t53oC2xSaJXLNrlh7iS58yFnUcabM+vJw0QNAHEJvneFUKanmXyIImkHfy5iw0nfUJQzojScGJZ2/bjo4CltoMz4Lr9uU/PXhA8o2Q3v5w0ixyJT59dtAuHdcQtlWwYPO5nFMmGO6jIewwqcTCq92J9cUllXsUN8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowAA3oDr+4KpqWp1vCA--.24004S2;
	Thu, 17 Sep 2026 02:33:34 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: benve@cisco.com
Cc: dledford@redhat.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	monis@mellanox.com,
	selvin.xavier@broadcom.com,
	yuval.shaia@oracle.com,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH 2/5] RDMA/core: Fix netdev use-after-free in ib_get_eth_speed()
Date: Wed, 16 Sep 2026 18:33:06 +0000
Message-Id: <20260916183306.2092381-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAA3oDr+4KpqWp1vCA--.24004S2
X-Coremail-Antispam: 1UD129KBjvJXoW7uFWUXF4DJw17CF4DurWxWFg_yoW8Jw17pa
	18ta47KFy8GF43Aa18Xa1j9ryYg3s3GanrW397Gw1Uur15XFZaqFsYkrWagFy8ArWfA3Wr
	tF1jvFZ8u3y8CFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9q14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxV
	W0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Cr0_Gr1UMcvjeVCFs4IE7xkEbV
	WUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7Cj
	xVA2Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4I
	kC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWU
	WwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JF
	I_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG
	6r1j6r1xMIIF0xvEx4A2jsIE14v26F4j6r4UJwCI42IY6I8E87Iv6xkF7I0E14v26F4UJV
	W0obIYCTnIWIevJa73UjIFyTuYvjfUFhL0UUUUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiDAEMA2qqpO+AKwAAsi

The device reference is dropped before netdev->name is read in the
warning emitted when __ethtool_get_link_ksettings() fails.  If that was
the last reference the name is read from a freed netdev.

Move dev_put() below the last use of netdev.

Fixes: d41861942fc5 ("IB/core: Add generic function to extract IB speed from netdev")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/infiniband/core/verbs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index bac87de9cc67..f11ac039e085 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2055,8 +2055,6 @@ int ib_get_eth_speed(struct ib_device *dev, u32 port_num, u16 *speed, u8 *width)
 	rc = __ethtool_get_link_ksettings(netdev, &lksettings);
 	rtnl_unlock();
 
-	dev_put(netdev);
-
 	if (!rc && lksettings.base.speed != (u32)SPEED_UNKNOWN) {
 		netdev_speed = lksettings.base.speed;
 	} else {
@@ -2066,6 +2064,8 @@ int ib_get_eth_speed(struct ib_device *dev, u32 port_num, u16 *speed, u8 *width)
 				netdev->name, netdev_speed);
 	}
 
+	dev_put(netdev);
+
 	ib_get_width_and_speed(netdev_speed, lksettings.lanes,
 			       speed, width);
 
-- 
2.34.1

