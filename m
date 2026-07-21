Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [52.237.72.81])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3AAF367B79;
	Tue, 21 Jul 2026 13:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.237.72.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784641130; cv=none; b=VnIMeSFDrPUqv6FM6bNtB61ohDky4WWRxWNwaxO6rO5e7vdnNH9JIeoN3jAHnhzonyBOiTK2IULT+KFahGAnLYSzo6Whh4Geev8OykoEWKN2H4CDGSC352gI7Ugwsn/XYNEzbwD6JZcQVZwDOHKXka7XK1d+sED0IphQsVvaNV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784641130; c=relaxed/simple;
	bh=D92ZYNQ5XRc6Yip6qoADmZLkgQf6mTkTscgFsRsE2OA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hBIOHrEex/N95sV3VCFKl9zbpLzLT36zoGpOG/rnmzxqrI4Vg1HYVMKUBjmcg9P1IHZ+JiNgGhUpoobnACCROQkjPpejnd/uNLckZp/N/Z8bs8113MXkUiXetqlcTyizdx+QzMHYZUQBPXchSu5d/4rrUYA7X8hzhHmHbhU2jpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=52.237.72.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [10.98.66.117])
	by mtasvr (Coremail) with SMTP id _____wCXZSlhdl9qQoMjAA--.26395S3;
	Tue, 21 Jul 2026 21:38:41 +0800 (CST)
Received: from localhost.localdomain (unknown [10.98.66.117])
	by mail-app4 (Coremail) with SMTP id zi_KCgDnGDBgdl9qx7J7Ag--.30264S2;
	Tue, 21 Jul 2026 21:38:40 +0800 (CST)
From: Fan Wu <fanwu01@zju.edu.cn>
To: chengyou@linux.alibaba.com
Cc: kaishen@linux.alibaba.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Fan Wu <fanwu01@zju.edu.cn>
Subject: [PATCH] RDMA/erdma: fix use-after-free in CEQ tasklet teardown
Date: Tue, 21 Jul 2026 13:37:45 +0000
Message-Id: <20260721133745.3197015-1-fanwu01@zju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zi_KCgDnGDBgdl9qx7J7Ag--.30264S2
X-CM-SenderInfo: qrstjiaswqq6lmxovvfxof0/
X-CM-DELIVERINFO: =?B?uy2jXgXKKxbFmtjJiESix3B1w3vZ3A9ovKVTomAyoQazvoRs/NHSP8GI2EvgeEEW7R
	sfnXz+g1OQfMo27QHy5TwQyZzgvRHOQsCUjDo8idFWYle1MvTmT6FpHCT9FRlb0WVskt/e
	ObfnZ14YDhW3GevYPmip9E6mavGmQbzmcFsnzP86
X-Coremail-Antispam: 1Uk129KBj93XoW7trykXw47Xr45uF4DAF45XFc_yoW8Xr1fpr
	ZxGw4jk34DtF1Yg3W3uws7AFy5Jas3W39rG3yUK39rXF9xZr15tF10kryqgFW5AFZrJF4I
	gF4Yqrs5Cw1rArcCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9Gb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AK
	xVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc804V
	CY07AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AK
	xVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48Icx
	kI7VAKI48JM4x0Y48IcxkI7VAKI48G6xCjnVAKz4kxMxAIw28IcxkI7VAKI48JMxC20s02
	6xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_Jr
	I_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v2
	6r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj4
	0_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8
	JrUvcSsGvfC2KfnxnUUI43ZEXa7IU818BUUUUUU==

The CEQ interrupt handler schedules a tasklet that accesses the CEQ
buffers. During teardown, erdma_free_ceq_irq() removes the interrupt
handler and waits for any in-flight handler invocation, but does not
wait for a tasklet that was already scheduled by that handler.

erdma_ceq_uninit_one() can then free the EQ qbuf and dbrec while the
tasklet is still accessing them.

Call tasklet_kill() after free_irq(). This prevents new tasklet
scheduling and waits for any already scheduled tasklet before the EQ
buffers are freed.

This issue was found by an in-house static analysis tool.

Fixes: f2a0a630b953 ("RDMA/erdma: Add event queue implementation")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
---
 drivers/infiniband/hw/erdma/erdma_eq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/erdma/erdma_eq.c b/drivers/infiniband/hw/erdma/erdma_eq.c
index 6486234a2360..78ebec6d48a3 100644
--- a/drivers/infiniband/hw/erdma/erdma_eq.c
+++ b/drivers/infiniband/hw/erdma/erdma_eq.c
@@ -219,6 +219,7 @@ static void erdma_free_ceq_irq(struct erdma_dev *dev, u16 ceqn)

 	irq_set_affinity_hint(eqc->irq.msix_vector, NULL);
 	free_irq(eqc->irq.msix_vector, eqc);
+	tasklet_kill(&dev->ceqs[ceqn].tasklet);
 }

 static int create_eq_cmd(struct erdma_dev *dev, u32 eqn, struct erdma_eq *eq)
--
2.34.1

