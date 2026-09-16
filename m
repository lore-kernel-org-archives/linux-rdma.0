Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FE34EBAD4;
	Wed, 16 Sep 2026 18:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789583802; cv=none; b=pOCE245olLVg1GLjkPxLwUsH3W3tMv0cqCkdnh73foWiojShLNh3lzy61UkxGYhemcyqxqVybZi4Xev4ODgHw5RlnLcS+h+hgw+b8NcO9ynI3MvXU81dad6lNRe5wILKKWYadn+WUnym3jPmXqcW78rHlQKwUGB1pICJsD8ZPPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789583802; c=relaxed/simple;
	bh=XPuTOMghW30lDvXu64EuUJRMaCy05g5c36w72VLxxbs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uMqKDuyRqAj+EM2WLYNddKOItyBeMwElMfLFFZaQjjMcpu9Z42QKxOefYIue8Zs4HaQ+XI6pwQFzkGb7/ERFzlF+yzWvAEWMGpmSmZIFPm4M1D3puiewKpHPSqWg5iOazYWKZZyTvcOQq+0t/szBLBX+Mnk7/tuPv26jV3Fv/Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowABXwz2O4apq+aZvCA--.24790S2;
	Thu, 17 Sep 2026 02:35:58 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: bharat@chelsio.com
Cc: jgg@ziepe.ca,
	leon@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	n.zhandarovich@fintech.ru,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH 3/5] RDMA/cxgb4: Fix neigh reference leak in rx_pkt()
Date: Wed, 16 Sep 2026 18:35:30 +0000
Message-Id: <20260916183530.2092534-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowABXwz2O4apq+aZvCA--.24790S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Jw4UtF4DAr4xWrW3Gr45ZFb_yoWDWrg_CF
	W8ZrZ3Xry5CFs0kF4qgFnxuryq9w1qq3yxXwn2qF15Ja4agFnFqa93ur98Ww4xXw45JFnx
	Gr98Jr48Grn3WjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
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
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCRMMA2qqozWHTQAAsJ

If ip_dev_find() fails on the loopback path the code jumps to
free_dst without releasing the neighbour reference taken by
dst_neigh_lookup_skb(), leaking one neigh reference.

Release the neighbour before jumping to free_dst.

Fixes: ef42520240aa ("RDMA/cxgb4: add null-ptr-check after ip_dev_find()")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/infiniband/hw/cxgb4/cm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index b3b45c49077d..f57a31cf4fc7 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -4156,6 +4156,7 @@ static int rx_pkt(struct c4iw_dev *dev, struct sk_buff *skb)
 		pdev = ip_dev_find(&init_net, iph->daddr);
 		if (!pdev) {
 			pr_err("%s - failed to find device!\n", __func__);
+			neigh_release(neigh);
 			goto free_dst;
 		}
 		e = cxgb4_l2t_get(dev->rdev.lldi.l2t, neigh,
-- 
2.34.1

