Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=101.71.155.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794491959;
	b=KiMtjC6woDzZP+EgEE4C9fOrwJ/LVlRZocLChyw40G/suDuurumCRvJBQSc55aSQBIUF
	 eAVG8qgQi2rZ1TuAAPYu0e+aLefhcewxRlVuFiF/J+tpvptGrNjqLejEuVz7rvO3lBsSb
	 EjzgKZdb1oCj10tGXrQ2R5drn323fXHYPjWh06tdJTry0oez7ReOIRo5Njqok+yMANPrn
	 TbVC+6g1uXvan0mH3JI0Be/Ef3y7UpSFa2Az+N5UmgETNIzc6Vb3g8Z17kNlT0KRBA6tO
	 7zXxJxhY9Wpn5BNFi3GhfssZhF801gwRJE5GWZPZmidY+VXCw4TjuFrLvkjfx2udZCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794491959;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-HM-Tid:
	 X-HM-MType:X-HM-Spam-Status:DKIM-Signature;
	bh=vGcLyL8lrNOPQ2ZGWKwpkCdewMCxLFT2ZLfgDjJYql4=;
	b=hAOWIu/RyiEJLoKnCDJ1nNtmbBqnduukHIc1XjjVqcMGVPL1BWirR8Zs04R34rnU+8d6
	 Va4XJZC8RNOKG99Rg8g5AVi6GfNDkrDVggTxhUhY3R5buqSSE/tr3AmQUNnvUlvv8JaIk
	 gZJVYQJIXtbwm+aOQdwt/zrQA6/1ZCX1vXK1p99JeGZncpsFdU5BiltlfOWCxJ+uMeaCq
	 BENXE71BuRgHQo5KM27FSJd42HsWxQAAyoZexl6oayinQGuDXspnCg2/guF/0XQ5V0Toi
	 oo5iw+OKesOmrtIpcOzP8CkbEsj9m4VL9soDs6uGo3h4fRkgItAufzmHlSN1k255Smg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mail.sdu.edu.cn;
	spf=pass smtp.mailfrom=mail.sdu.edu.cn;
	dkim=pass header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=ZNqdaQqm;
	arc=none smtp.remote-ip=101.71.155.101
Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2AF606A8A9;
	Thu, 12 Nov 2026 13:59:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB2AF606A8A9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=ZNqdaQqm
Received: from lgs.. (unknown [101.76.249.61])
	by smtp.qiye.163.com (Hmail) with ESMTP id 54773892d;
	Thu, 12 Nov 2026 21:59:13 +0800 (GMT+08:00)
From: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
To: Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] RDMA/ocrdma: Fix potential EQ table leak
Date: Thu, 12 Nov 2026 21:59:12 +0800
Message-ID: <20261112-88a3a7ff32-rdma-ocrdma@mail.sdu.edu.cn>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa1d00e303503a1kunm88a5a4792a00
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCSklIVktPSElOHk0YTk8dTFYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlKS0pVTE1VSU9CVU1KWVdZFhoPEhUdFFlBWU9LSFVKS0lCQ0
	NMVUpLS1VLWQY+
DKIM-Signature: a=rsa-sha256;
	b=ZNqdaQqmc8AOKUeP2zixKR9ECXB1KAlYcqHrZNZAQpOW8yyEHl/dgH15npMNEtryEgEtWHfpQ+vEknZdv42PjIGvCqbm66velBIjIutSQABmqum8J06hp9ZjEXhSatKeoUyt7fewXGw5Vav2mFh4mf9ndSs3yEV6gXys41N1UEs=; c=relaxed/relaxed; s=default; d=mail.sdu.edu.cn; v=1;
	bh=vGcLyL8lrNOPQ2ZGWKwpkCdewMCxLFT2ZLfgDjJYql4=;
	h=date:mime-version:subject:message-id:from;

EQ teardown destroys the individual queues but leaves their dynamically
allocated table behind. Free the table after all EQs have been destroyed
and reset its pointer and count.

This issue was found by our static analysis tool under development.

Fixes: fe2caefcdf58 ("RDMA/ocrdma: Add driver for Emulex OneConnect IBoE RDMA adapter")
Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 006ef2e6b5f3..4a977281a85b 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -518,6 +518,9 @@ static void ocrdma_destroy_eqs(struct ocrdma_dev *dev)
 
 	for (i = 0; i < dev->eq_cnt; i++)
 		ocrdma_destroy_eq(dev, &dev->eq_tbl[i]);
+	kfree(dev->eq_tbl);
+	dev->eq_tbl = NULL;
+	dev->eq_cnt = 0;
 }
 
 static int ocrdma_mbx_mq_cq_create(struct ocrdma_dev *dev,

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
