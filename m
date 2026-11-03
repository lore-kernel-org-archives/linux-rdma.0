Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793693527;
	b=M/B11RMUlnOy1Q5n/QspPzH2qlOb6YcDizsqTHY9gPbtiXHSZ+bLdfituRiIINhM0Nlw
	 NfT0YCDZoNw8ZaYQUeLk4A+/rBQxwtpBSOTzI209Nn3C76PpnI+3A4yyKzXjEproBHCka
	 Q+8WkcciW/yikq3p2FIIBBiPUP8Xmu+9sWxM4DOkv/xdGPpBzT+Buf3jCI+pGTQ6T/DLP
	 cNHhMn2g5Z5PBb8b8mQClWgcG7jRAx466UH56e8Rk2rq+nDfP4q3oyjoOsl887VViJp8s
	 Ei5UMmAAYE2Fm5JroQi2P8w4rt6vkJW8aF/YbX8+yqAxlA9MF6FJXDVB6hzsKCSVhog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793693527;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=pdCQj6jg57QOmTW1054OXT4ykpV6txuNent/VW313/0=;
	b=hZakXtICaNK22/bdJwFT2YjuMyJaY/IaOPou7Zg1C8nsY1zs0mwkHsmKm4885pyD1PmJ
	 NbAMPaFjfN3X3WdUdNNIP3abaWedRvduqyK/K26+DY6YOPAhZFqj3k5N05G7CmTuWzOA0
	 wACf80TQN24zA/SgKx5wPihOOnv2/Cc3xHdzEco/0LzPUJ3OouX3HUR9MG60cVCCNrguH
	 0xe/ZyQJWl/08Tu/D9OSKaC+eFC6cFO6MYZmaIrv1UxpckRd9WpwqnHZlzVmG8U5Jz9W8
	 X0coDThoKRGI+0XJMnjazdT7PPMPVpT+9tkYyUK5/BoeZxF6ViiqECnQHvvaek5eqTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.81
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A02606A32C;
	Tue,  3 Nov 2026 08:12:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42A02606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowACXaZpUl+lqckc6AA--.63141S2;
	Tue, 03 Nov 2026 16:12:04 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: selvin.xavier@broadcom.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] RDMA/ocrdma: Release user memory when MR registration fails
Date: Tue,  3 Nov 2026 08:12:12 +0000
Message-Id: <20261103081212.1137625-1-vulab@iscas.ac.cn>
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
X-CM-TRANSID:rQCowACXaZpUl+lqckc6AA--.63141S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar1UXr4xZFW5Zw1xCrW5GFg_yoW8Ar4Upa
	15Jw4YkrWqqF47Z3W8J3WUuaySk3yrGrWUKF9Fkw1fuFs8Gr48Zrs5C3W0grWDAF97Gr4S
	qrn8K3Z8uF4fCaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Cr1j6rxdMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_
	Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUMGQ
	DUUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiDAEAA2rpWwrirgABsR

ocrdma_reg_user_mr() pins and maps user memory before preparing its page
buffer list and registering the MR. If any subsequent step fails, the
error paths free the MR and any allocated PBL tables, but never release
the user memory. The pages remain pinned and DMA mapped, and the locked
memory accounting is not restored.

Release the umem on these failures. Use a separate label for failure of
ib_umem_get_va() itself so its error pointer is never passed to the
release function.

Fixes: fe2caefcdf58 ("RDMA/ocrdma: Add driver for Emulex OneConnect IBoE RDMA adapter")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 97c2e18e67ad..94a61127fb39 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -868,7 +868,7 @@ struct ib_mr *ocrdma_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 len,
 	mr->umem = ib_umem_get_va(ibpd->device, start, len, acc);
 	if (IS_ERR(mr->umem)) {
 		status = -EFAULT;
-		goto umem_err;
+		goto err_free_mr;
 	}
 	status = ocrdma_get_pbl_info(
 		dev, mr, ib_umem_num_dma_blocks(mr->umem, PAGE_SIZE));
@@ -899,6 +899,8 @@ struct ib_mr *ocrdma_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 len,
 mbx_err:
 	ocrdma_free_mr_pbl_tbl(dev, &mr->hwmr);
 umem_err:
+	ib_umem_release(mr->umem);
+err_free_mr:
 	kfree(mr);
 	return ERR_PTR(status);
 }
-- 
2.34.1

