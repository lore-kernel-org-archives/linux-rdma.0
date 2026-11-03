Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793693848;
	b=z9Uh5wwMsDI9vNm04G12wBjQBIXJ+kwsBiHZp1yTq/k+nAAOSGsz56/EDci0+kPwWCUp
	 F1F3XF5CNiBYYljeK1DECB3BRMnZYYs94mk7nPwNJe+zMyIbAF4aT9FPtNaHlFIg1m2xa
	 bk90NIyIU8j91Fc7fRCjrX+B5Hfo+1BWut/L/CSWnWd9oTLbMfJHgNJ24rcaFQKK1Y6KI
	 tZ6XgFSCQFnByeDiXCjdIrQ1OqTVn5cmMpNTBgUK5g3Ff1cmhrLsPh6/mrNvU4DSH/xE8
	 gtoZYTseBHjsG4GwsS03JHC9yj+3Uss2j0IT+KgsDM3PSzfOTcuADNUrQRGbp0V3PYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793693848;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=ByCs/mZsFgrdq9mpwG3he7XLV2D3BV8wO7JHEOzQf9A=;
	b=v/3HQwx5j+4M1Kbbz3b2g7mKxuNEtOTGPFjCQep4wgtpCbS71wNpQDOj5bqlX+fkuT5U
	 iv6MqDI8ds9m7Y1iZ2Zf77Zlm1c9+BR4ofSyeV2zcEB4ptHP6Nn7Ky2GvuumPMlBJBiX1
	 C2PCx9LoKX9YowlNkCOJjwmUvBOv6i4+VCC7HPANjDOs2MoK0T5eW9CZJC1TPg7gxKcWW
	 TDDe9Q4X6ZopM7eA3xQkL2OGr6cJ5rSlXaWekdSUHYYf6NYhP7oqzAyNMwVmQD5sWecWz
	 jT5sirCr95y0VuBNal0QIVuQ2pyamRANh9fXWaAorCS/0j806Ht9/6ItRVD7QgGcq1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.81
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58C9606A324;
	Tue,  3 Nov 2026 08:17:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B58C9606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowAA3QZKTmOlqmVU6AA--.1291S2;
	Tue, 03 Nov 2026 16:17:23 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: mkalderon@marvell.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] RDMA/qedr: Unwind user queue setup if doorbell recovery setup fails
Date: Tue,  3 Nov 2026 08:17:32 +0000
Message-Id: <20261103081732.1144512-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
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
X-CM-TRANSID:rQCowAA3QZKTmOlqmVU6AA--.1291S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar4xWw1DGrW8uFykZFW3trb_yoW8WFWrpr
	ZxXrWYkryjgF47AanrJr1UtaySgaykCFWUKrZ29w1rZ3ZIkF129asIkF1UXFykAFs2qa1S
	yr4qyr45Crn7CFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE14v26F4UJVW0owAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v2
	6r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_
	Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUMGQ
	DUUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgkAA2rpWmXrlAAAsP

qedr_init_user_queue() pins user memory and allocates its PBL before
initializing the doorbell recovery record. If the last step fails, it
returns directly without releasing either resource. The CQ and QP
creation callers treat this as a failed queue initialization and do not
release that queue, leaving its user pages pinned and PBL storage leaked.

Free the PBL on doorbell recovery setup failure, then use the existing
umem cleanup. Match the PBL allocation mode: RoCE uses the populated PBL
allocator, while the other path allocates only the table descriptor.
Clear the freed pointer as well.

Fixes: 97f612509294 ("RDMA/qedr: Add doorbell overflow recovery support")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/infiniband/hw/qedr/verbs.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 3c777bfdef8f..f7a4b2bd7398 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -818,7 +818,15 @@ static inline int qedr_init_user_queue(struct ib_udata *udata,
 	}
 
 	/* mmap the user address used to store doorbell data for recovery */
-	return qedr_init_user_db_rec(udata, dev, q, requires_db_rec);
+	rc = qedr_init_user_db_rec(udata, dev, q, requires_db_rec);
+	if (!rc)
+		return 0;
+
+	if (alloc_and_init)
+		qedr_free_pbl(dev, &q->pbl_info, q->pbl_tbl);
+	else
+		kfree(q->pbl_tbl);
+	q->pbl_tbl = NULL;
 
 err0:
 	ib_umem_release(q->umem);
-- 
2.34.1

