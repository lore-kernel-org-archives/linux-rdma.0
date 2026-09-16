Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D794CEE4E;
	Wed, 16 Sep 2026 18:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789583519; cv=none; b=Prg3TOvdfKR7x1MnJ+6Vs578LXZhfvFlTWDEs7UXmdBbaM1TKwa1fHo3qsCSzhx71THJCYLljuc//vDjgOnBc/dj3XFBiTfwhSADXIBqfR/bzP0fvXSlf579tpCEZgCVA1BwVGko/besyzM4PcS+N56EScnu4DUyXlpCKGJ561w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789583519; c=relaxed/simple;
	bh=gjxokh6OHwc7UZ3LW9PeRfmpfzV+NRArtIASdIXkxAE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EcppxZXTm97BS/mQ/F9OUZGsgkqV+Q+uKcsA2H+aA5RsTBSCzX/PCQ9exaNp+dgbF8pq18/nsjWblEgbZs7YgbdsjeOhJ/S0pe1lOO91r3Z0aL4Mgu1pmhDR61j/gYCIvbpCYuUJl1+Ua4BtluTz7UgrI7jiAgJltJNSY34kkFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowAAHcz2B4Kpq+5RvCA--.24255S2;
	Thu, 17 Sep 2026 02:31:29 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: dsahern@kernel.org
Cc: jgg@ziepe.ca,
	leon@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	yanjun.zhu@linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] RDMA/nldev: Fix ib_device reference leak in nldev_dellink()
Date: Wed, 16 Sep 2026 18:31:01 +0000
Message-Id: <20260916183101.2092246-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAAHcz2B4Kpq+5RvCA--.24255S2
X-Coremail-Antispam: 1UD129KBjvdXoWrtrW3XF4fKw1fZr1UKw4rXwb_yoWkZFg_Wr
	ykZr97XF1xCFnayrnrCrn3AFn2vr12gF4fWF4vqF1fAryjqrWDX3sIqF9Yyr4Igay0kr17
	JFnrJrs3Ww17WjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbxAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r
	xl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r1q6rW5McIj6I8E87Iv67AKxVWxJVW8Jr1lOx8S6xCaFVCjc4AY6r
	1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AK
	xVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFyl
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Cr0_Gr1UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Cr1j6rxdYxBIdaVFxhVjvjDU0xZFpf9x0J
	UJuc_UUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwUMA2qqpVh9AQABsN

nldev_dellink() takes a reference on the ib_device with
ib_device_get_by_index().  When the driver's dellink callback fails,
the function returns the error directly without dropping that
reference, leaking it.  Call ib_device_put() on the dellink error
path before returning, matching the handling of the other error
exits in this function.

Fixes: a60e3f3d6fba ("RDMA/nldev: Add dellink function pointer")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/infiniband/core/nldev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 5aaba2b9746b..e4a9562313fa 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1850,8 +1850,10 @@ static int nldev_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		mutex_lock(&nldev_dellink_mutex);
 		err = device->link_ops->dellink(device);
 		mutex_unlock(&nldev_dellink_mutex);
-		if (err)
+		if (err) {
+			ib_device_put(device);
 			return err;
+		}
 	}
 
 	ib_unregister_device_and_put(device);
-- 
2.34.1

