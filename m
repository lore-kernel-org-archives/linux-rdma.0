Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793693770;
	b=M7n7dfa9/+oVXU+0zMRs3iZ28OCciN+thjG7q9a1Rr7Whi0A81ddN4yoUUpEICwxeypS
	 FDLAlpMw0scMFba6UQhm8fqenAdp+gtOvfYwD18p3+PyvK2pkSHhCdFFZ9mEgzV1I92Kg
	 M6yjSHpuutcBNhFTeVP4fm3OVcv7a2Xa1Deuh6QR0TuIrHI9nkKHOIYl5w6aoXwYGHw8x
	 vvfBnwgyOpz9GVmnNkeguxS5nLO/s/ND/QcWzvLfBGhPo0Ee2w4RTwCK8Y1a4TNpTQSZ+
	 CdmEtxF14lKA6Midttv8zZE0Gp6hJU8DmZuS3pJbwvcCM5sLmG4I0yghzssGs9Rsw6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793693770;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=7Qfv2RrlktjTn/mFNJau1qV3Ljc+Bg56TPja324C4EE=;
	b=tkMETNHRscZyfdIXK2Ql/jJhh5rd1VKUVNuZDRXhlLrIAe2yaHlLbNP91KXWqjLUmg2l
	 Fenec6hiul41B1skIc40ywk85cwP9TDZgcuyfhafYFnLc3g/VLAVpvdhonH0EL49P6IW5
	 zFUx8FLTCHk+EAdu1UanvGhbfs64tzZL9lddQ9SmYZLnYgPb6OnuOcRnoQJku42vFwwZT
	 AlnrQAk6KiPqLrD3cqMU/No1bR3ISceUJ4QISGzyBFDQvI7riD+enXzSo3LyqvBD/RpLQ
	 T91hwRl9MBBZBHClXE5grxU6YwTLgQMVkXV/IpVdSE0sZZOlxk/Qppx19F07M6knRDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.81
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94566606A32C;
	Tue,  3 Nov 2026 08:16:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94566606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowACHkpNGmOlqQVI6AA--.1655S2;
	Tue, 03 Nov 2026 16:16:06 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: mkalderon@marvell.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] RDMA/qedr: Release user memory on MR registration failure
Date: Tue,  3 Nov 2026 08:16:15 +0000
Message-Id: <20261103081615.1143267-1-vulab@iscas.ac.cn>
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
X-CM-TRANSID:rQCowACHkpNGmOlqQVI6AA--.1655S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Aw1rtFW3CrWruw4xXw17Awb_yoW8Jw4UpF
	4fWrZ0krWUtF4293WDAF10vFWSga4rAayjg3sIy34fZFsxZF109FnYka4UZryDGF95Xr4f
	Zr4Utws8uF1xCFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiDAEAA2rpWwroEgAAsm

qedr_reg_user_mr() acquires user memory before initializing the PBL and
allocating and registering a hardware TID. The error paths after that
acquisition release the MR storage and PBL resources, but skip
ib_umem_release(), leaving the user pages pinned and DMA mapped.

Release the umem at err1, which is reached after a successful acquisition.
The failure path of ib_umem_get_va() still jumps directly to err0 and
never passes its error pointer to ib_umem_release().

Fixes: e0290cce6ac0 ("qedr: Add support for memory registeration verbs")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/infiniband/hw/qedr/verbs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index acab3cb98caa..3c777bfdef8f 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -3006,6 +3006,7 @@ struct ib_mr *qedr_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 len,
 err2:
 	dev->ops->rdma_free_tid(dev->rdma_ctx, mr->hw_mr.itid);
 err1:
+	ib_umem_release(mr->umem);
 	qedr_free_pbl(dev, &mr->info.pbl_info, mr->info.pbl_table);
 err0:
 	kfree(mr);
-- 
2.34.1

