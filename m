Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4DA37474E;
	Fri, 26 Jun 2026 15:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782486255; cv=none; b=EkLBT93QJDnoL3y68v2w5O/qD0sE9qRO3SMhwSZ24YCkfIxOOMeG3jWWZ5aXEI+QK499ZKiOxL5iDFr996jkSga0ZWVL9G+NiKNtPmpshTB3YKJudoOeK8RGSQjF3yMyit9xkmca2WXB576MR0efmNGXGlfKKgz1kfzFtbUGYZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782486255; c=relaxed/simple;
	bh=LmsT+8W4InIru9/wUAJmAaqAkEVIU0R5bwNc23vjHm0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LVnW15w+kqK26BP1LOTbtfIaJcPJnJKOXTJc9f2zzlM3Yc2iE8uXlROl8PIusnI3ReuzX6zr6031whJVUk5xZxnHoVIdVtLg9MPQ8k2KTQdrFUp8zgm/qksTiuRgojKBMA8F9eQZttJmmgF7VjW799BJFBdXC4dVOcttH/UmbDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [117.182.75.66])
	by APP-01 (Coremail) with SMTP id qwCowAAnzNTolD5qGV1rAw--.16670S2;
	Fri, 26 Jun 2026 23:04:09 +0800 (CST)
From: WenTao Liang <vulab@iscas.ac.cn>
To: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	linux-rdma@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	WenTao Liang <vulab@iscas.ac.cn>
Subject: [PATCH] fix: infiniband/hfi1: __sdma_process_event: fix refcount underflow on   s00_hw_down + e40_sw_cleaned event path
Date: Fri, 26 Jun 2026 23:04:08 +0800
Message-Id: <20260626150408.49976-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAAnzNTolD5qGV1rAw--.16670S2
X-Coremail-Antispam: 1UD129KBjvdXoW7XFW5Aw13Ww43Kr45WF4DArb_yoWkuFg_ZF
	y5Jr97Wr1qyF9YyF98Gr1fZ3ZrtayFqw1kWrn2gw1fA343XFZ8AayvvrW5Xw47XrW8JF4v
	krn8GrWIyr4YvjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb4AFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWU
	AVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWx
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUjZNVP
	UUUUU==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgIKA2o+h0EnlAAAss

When the SDMA engine is in the s00_hw_down state and receives the
  e40_sw_cleaned event, the code directly calls sdma_sw_tear_down which
  unconditionally performs a kref_put via sdma_put. However, no matching
  sdma_get was ever executed on this path (sdma_get is only called in the
  e10/e30 event paths). This causes a refcount underflow.

Skip the sdma_sw_tear_down call in the s00_hw_down + e40_sw_cleaned path
  since no reference was acquired.

Cc: stable@vger.kernel.org
Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Signed-off-by: WenTao Liang <vulab@iscas.ac.cn>
---
 drivers/infiniband/hw/hfi1/sdma.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index cfd9dd0f7e81..bf35deb8aa6f 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -2539,7 +2539,6 @@ static void __sdma_process_event(struct sdma_engine *sde,
 		case sdma_event_e25_hw_clean_up_done:
 			break;
 		case sdma_event_e40_sw_cleaned:
-			sdma_sw_tear_down(sde);
 			break;
 		case sdma_event_e50_hw_cleaned:
 			break;
-- 
2.39.5 (Apple Git-154)

