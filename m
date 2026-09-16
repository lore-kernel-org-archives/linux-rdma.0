Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AA65AEC7A;
	Wed, 16 Sep 2026 18:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789584019; cv=none; b=GYaOIpvhtAd6VAePUmVl9TsPYhjv2bos4IhXIyKUzm4LQIFxekUKQngDfD6hqQH7WpyfDxa5SX6RbKKG6LJrnNQKSArhKlBVp2jBYRNSmXKYqHe2eLC1f3hsLMnACRwrzZSK8Q/HNrMaZIaUpravHsL5b7zrHvzm3lKp81cC6tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789584019; c=relaxed/simple;
	bh=KpcKAbl0ygBhAwEMEOParviLhTRazHOe+hp9cwdQKMo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=l2tjxuwb+Op+kl7mfkJInvWYL2J8YqsrS05MbjOPakGLeg/GJE3O7P4gd+sKLw4pnJLFfj/byL/SqUid5b7LtmbBQe5kLh9l0CHFvbGgPMyapoew4u/JsGkhXTdcZ0Ze8bNOF+clFV46fk63ZAZJJrJJy/2iLI95H9CNUObkQjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowAD3J0J14qpqV7RvCA--.24643S2;
	Thu, 17 Sep 2026 02:39:49 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: jgg@ziepe.ca
Cc: leon@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	markzhang@nvidia.com,
	phaddad@nvidia.com,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH 5/5] RDMA/mlx5: Fix RQ resource reference leak in mlx5_ib_wq_event()
Date: Wed, 16 Sep 2026 18:39:21 +0000
Message-Id: <20260916183921.2092821-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAD3J0J14qpqV7RvCA--.24643S2
X-Coremail-Antispam: 1UD129KBjvJXoW7uryfZw1rtr18GF17JFW8Zwb_yoW8Jw1xpr
	W7G34YkryDJFWa9F4Yyw4FvFWaywn7t39093yvywnYvws8XwnrW3WSk34aqry8AryFgrWa
	vw15JFs8CFy5ZrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvY14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxV
	W0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Cr0_Gr1UMcvjeVCFs4IE7xkEbV
	WUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AF
	wI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Cr0_Gr1UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Cr1j6rxdYxBIdaVFxhVjvjDU0xZFpf9x0J
	UJuc_UUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCRUMA2qqozWIeAABs0

Since commit 312b8f79eb05 ("RDMA/mlx: Calling qp event handler in
workqueue context") rsc_event_notifier() expects the event handler to
drop the resource reference taken by mlx5_get_rsc().  mlx5_ib_wq_event()
was missed by that conversion, so every RQ event leaks one reference,
which keeps destroy_resource_common() waiting on the completion.

Put the resource reference on all exits of the handler.

Fixes: 312b8f79eb05 ("RDMA/mlx: Calling qp event handler in workqueue context")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/infiniband/hw/mlx5/qp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 8fd05532c09c..e8d03cc60a00 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -5200,11 +5200,14 @@ static void mlx5_ib_wq_event(struct mlx5_core_qp *core_qp, int type)
 			break;
 		default:
 			mlx5_ib_warn(dev, "Unexpected event type %d on WQ %06x\n", type, core_qp->qpn);
-			return;
+			goto out;
 		}
 
 		rwq->ibwq.event_handler(&event, rwq->ibwq.wq_context);
 	}
+
+out:
+	mlx5_core_res_put(&core_qp->common);
 }
 
 static int set_delay_drop(struct mlx5_ib_dev *dev)
-- 
2.34.1

