Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.254.49.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794399801;
	b=enzPYhOfDvisXAgZgQ3ZSOgcX8WU9jrAFLcyulzqIRas+wYJzfUVgtrEIzXeVKTdG995
	 bv+4XIoicO10GYWDPqQ1zkftwe3zvJH2pRKtuyT0aq4U0fO8qllnVyCm2I3VfcGIafiNG
	 MYbeYscuSG+/j/LAQHLsQ5OEKQxiOHplv4In5SzBGJrumDbq1nlKZNJ7J0gw5pgGoQ3vi
	 wetli16y+sKNJ4XSPgfP1bjQOn88v8p1FCtGIvPGqvMPehZmqC1Ch7YgaGCIQIpP9pv0j
	 hRDOSRwBFcjCgQjpbU8xdvspAAbDL8Ygj1lArE+nGR8JSm5CLzWv6+mn+BpI3nJ8kJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794399801;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-HM-Tid:
	 X-HM-MType:X-HM-Spam-Status:DKIM-Signature;
	bh=WXshdJqSb+edAWMTGD9R6SzvNB+QpXRPR15W3Kt4cvA=;
	b=lgsfXIu0CxPotft0E0sfr0ldT876gVeHbGzLHM3arVQGzxV/AdElEuzBFEqkj87L/D2C
	 jxS0xO95lgHZy2iwlWWMj7+82Y8IySoU6y9h9Fe4NcpJslvp8FMCgiWh6XNLNqe0q9XG4
	 UytfvPZbP4K8Vk+QbSA6hVKuKG9eaT4J8IFkpkH+Nn5OF44OamakZKkXF70/FUC/0FQBr
	 mdH9DKNsfi84gWtzj0f9CT+U6j8h5MWuRgXRrLUPDGppNsFeJ89HWtDoShdokf8vKH28L
	 x2hyjzfX0HBRsP6uve1At2Ez4PQLhjFMVAcuSejPIGGfkX0Xgj5iz4no7R1STcpFrGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mail.sdu.edu.cn;
	spf=pass smtp.mailfrom=mail.sdu.edu.cn;
	dkim=pass header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=EHeqL3gG;
	arc=none smtp.remote-ip=45.254.49.197
Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52C260A2616;
	Wed, 11 Nov 2026 12:23:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D52C260A2616
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=EHeqL3gG
Received: from lgs.. (unknown [101.76.249.61])
	by smtp.qiye.163.com (Hmail) with ESMTP id 54502a176;
	Wed, 11 Nov 2026 20:23:15 +0800 (GMT+08:00)
From: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
To: Bart Van Assche <bvanassche@acm.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] RDMA/srp: Fix potential fast registration list leak
Date: Wed, 11 Nov 2026 20:23:14 +0800
Message-ID: <20261111-e5624093d6-rdma-srp@mail.sdu.edu.cn>
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
X-HM-Tid: 0aa1ca8ffa5303a1kunme998f16f1b366e
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCTRhPVkJDT0JNHRofHUhPTVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlKS0pVTE1VSU9CVU1KWVdZFhoPEhUdFFlBWU9LSFVKS0lCQ0
	NMVUpLS1VLWQY+
DKIM-Signature: a=rsa-sha256;
	b=EHeqL3gGcIkw/hC06qer8BoTyN9awHtlP1xgd79JscnZeJuG9HdjHND4lGwRrsA1kqay3D8fCTt8jdzeN7az6kHBKAhdzinbkPE1PPsxDxMElQWgD3Nw5fdRdODSvgVe6abLNb/5nS0GdgH/+AKzdTXx791rsQlHgwM0p61uS3A=; s=default; c=relaxed/relaxed; d=mail.sdu.edu.cn; v=1;
	bh=WXshdJqSb+edAWMTGD9R6SzvNB+QpXRPR15W3Kt4cvA=;
	h=date:mime-version:subject:message-id:from;

If the indirect descriptor allocation fails, srp_init_cmd_priv() returns
without freeing the fast registration list. The failed request does not
receive an exit_cmd_priv callback. Release the list on this error path.

This issue was found by our static analysis tool under development.

Fixes: ad215aaea4f9 ("RDMA/srp: Make struct scsi_cmnd and struct srp_request adjacent")
Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 5811f02df980..1cea1896d162 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -996,8 +996,10 @@ static int srp_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 			goto out;
 	}
 	req->indirect_desc = kmalloc(target->indirect_size, GFP_KERNEL);
-	if (!req->indirect_desc)
+	if (!req->indirect_desc) {
+		kfree(req->fr_list);
 		goto out;
+	}
 
 	dma_addr = ib_dma_map_single(ibdev, req->indirect_desc,
 				     target->indirect_size,

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
