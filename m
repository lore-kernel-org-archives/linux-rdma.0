Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793759290;
	b=vR7BStFBfBgh0J9Zgv7E5I1OY04heoEbOhNTrtuToE/vtz4gjbZcOaNTWCHN48/QRY4c
	 XaefpXHXpEpwv9JL0m+/9RApTiSg1Wc43gQEn6RD9fy7D8hkUXiCA5B880zEdeC1+lSuP
	 Mj7Deld0+jkyZjWECxKnl25Mc8dxBQ6u5UwxZbZ+KEmzedtrZeCuag5R1jkQbcyPVAIqD
	 D+2Nwu2skSIM+bS5muY/GlHuFAlUNvmi9Ll3+vP6ryJiLlWccXXKYaBZItr+73n2l1F2U
	 Zw9BB2mtrjwA3ZiqXFp1QNIwJZuYC5vbfcKcctTL4PMmmrXDk0J2eAu7k/6EqGhFwNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793759290;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=8m/85dTdab30JxAtsrqJ1e7fyoBdtqigVZE8stCtUrQ=;
	b=G6zBjxcYQGarIvI9KUBY3Kpe7LK9p0HdB1+cHSFot8hV1B0qCCFWKTofGBC7GK9rL9LX
	 r4oE7mhnlFUbFwG6e3GkT3ab2AAYcpUWE4sMh7Lj/3+jamVak/mp0HyD52e2DBuOQSPsH
	 ogg65XQmTsi1xMRdNa4+8PucKGQFOH8f5vrQie8gM7irYerOs1zLw7/NXIXM22bEGhGyu
	 HpEqUtGkbD1q+n4CEM6P/FOKZXnT5+Xw5CtPJBUgen5HgC3P/zNAC18iNa0RXIrhkCAva
	 1dDZsVSaHJo1OFGy185oL+27wYtN3MfLsPc6+m2l34LILUwwIExCv7/aqqxyO06rraA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.21
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB869606D807;
	Wed,  4 Nov 2026 02:28:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB869606D807
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowAB3Zf8xmOpqn5s+AA--.9902S2;
	Wed, 04 Nov 2026 10:28:01 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Allison Henderson <achender@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com
Subject: [PATCH] net/rds: drop the device reference for ODP memory regions
Date: Wed,  4 Nov 2026 02:28:10 +0000
Message-Id: <20261104022810.1484182-1-vulab@iscas.ac.cn>
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
X-CM-TRANSID:qwCowAB3Zf8xmOpqn5s+AA--.9902S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tr17tF43JrW3XF1xCw4Durg_yoW8XrWxp3
	yYgay5trWDGrW0yw47XF1j9ayY9wsaka15C34kA34vgws5tryava4Y93WUWFWUJrZ5uF1j
	yFy7t39293yDAF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvlb7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14
	v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xf
	McIj6xIIjxv20xvE14v26rWY6Fy7McIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0E
	wIxGrwCF04k20xvE74AGY7Cv6cx26r48ZrWUJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI
	8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AK
	xVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26F1j6w1UMIIF0xvE2Ix0cI
	8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E
	87Iv67AKxVWxJVW8Jr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvj
	DU0xZFpf9x07bzhL5UUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwcBA2rqZFjHrwAAsW

rds_ib_get_mr() takes a reference on the rds_ib_device with
rds_ib_get_device().  The FRMR path stores it in ibmr->device and
rds_ib_free_mr() drops it when the MR is freed.

The ODP path allocates the ibmr with kzalloc_obj() and returns it
without recording the device.  rds_ib_odp_mr_worker() only deregisters
the MR and frees the ibmr, so the reference taken for every ODP MR is
never dropped and the rds_ib_device can no longer be released.

Store the reference in ibmr->device and drop it in the worker after
the MR has been deregistered, which also keeps the device and its PD
alive for as long as the MR exists.

Fixes: 2eafa1746f17 ("net/rds: Handle ODP mr registration/unregistration")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 net/rds/ib_rdma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
index db7e92e7bd29..8cd8295f66a3 100644
--- a/net/rds/ib_rdma.c
+++ b/net/rds/ib_rdma.c
@@ -591,6 +591,7 @@ void *rds_ib_get_mr(struct scatterlist *sg, unsigned long nents,
 		}
 		ibmr->u.mr = ib_mr;
 		ibmr->odp = 1;
+		ibmr->device = rds_ibdev;
 
 		sge.addr = virt_addr;
 		sge.length = length;
@@ -697,5 +698,6 @@ static void rds_ib_odp_mr_worker(struct work_struct  *work)
 
 	ibmr = container_of(work, struct rds_ib_mr, work.work);
 	ib_dereg_mr(ibmr->u.mr);
+	rds_ib_dev_put(ibmr->device);
 	kfree(ibmr);
 }
-- 
2.34.1

