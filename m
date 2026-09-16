Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7924D596C;
	Wed, 16 Sep 2026 18:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789584290; cv=none; b=u8edSc6xiLIVMcxOYJkT3Nbo+C/jge/0xENt8YYlg0zjkCjg502Tp/0ZpTr5KUzCRn4rxBfmjYsw17kPc0IXLLSd7651UrLag2IGVw7tCaUoOaQcH99KPfGpfNxulwBkoVgrApcaKi07tDce2ACybNCbKh+HLEno9qskDiA5h/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789584290; c=relaxed/simple;
	bh=RD6L7JhVCcoVnIkfFWYQzWOIe2LqmYOEPA3xKPiqLM4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=I5FGTKwMlkjk1OfwAPQfGpN1oaRQYwPZIwojXXW3Hf/aNKWXxyReOeiTxXImWhypfuZicGPa8+dVFteIQioKKXGHgIrpKfAe2TGAhzdXfMQsuYSlfrf3jtgqN1bfm8GjMiS0QEAJXAxqZnQ0M2PekvYiVew9vcswLR6ukppWfZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowADH+EKL46pqlcZvCA--.24570S2;
	Thu, 17 Sep 2026 02:44:27 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: bernard.metzler@linux.dev
Cc: jgg@ziepe.ca,
	leon@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH 7/7] RDMA/siw: Fix qp use-after-free in siw_get_base_qp()
Date: Wed, 16 Sep 2026 18:44:00 +0000
Message-Id: <20260916184400.2093106-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowADH+EKL46pqlcZvCA--.24570S2
X-Coremail-Antispam: 1UD129KBjvdXoWrKr1fJw4DJw47KFW8Zw18Xwb_yoWkWrg_Kr
	1UWrn7Xw1DCF4vkr1jyw13u3sFva48tw1xWa42qw43J3yUGFnxJw13K3Z5uw47ZrWSkF1D
	AFWkW3s3CFykWjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbxxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE14v26F4j6r4UJwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v2
	6r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26F4j
	6r4UJwCI42IY6I8E87Iv6xkF7I0E14v26F4UJVW0obIYCTnIWIevJa73UjIFyTuYvjfUrF
	ApUUUUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBggMA2qqok+L8AAAsX

The reference taken by siw_qp_id2obj() is dropped before the address
of the embedded ib_qp is taken from the QP.  If that reference was
the last one the QP is freed and the pointer returned to the iwarp
core is dangling; the core only pins the QP with iw_add_ref() after
the call has returned.

Copy the pointer while the reference is still held.

Fixes: 6c52fdc244b5 ("rdma/siw: connection management")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/infiniband/sw/siw/siw_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_main.c b/drivers/infiniband/sw/siw/siw_main.c
index 9735b75ac933..c08796e4262a 100644
--- a/drivers/infiniband/sw/siw/siw_main.c
+++ b/drivers/infiniband/sw/siw/siw_main.c
@@ -217,8 +217,11 @@ static struct ib_qp *siw_get_base_qp(struct ib_device *base_dev, int id)
 		/*
 		 * siw_qp_id2obj() increments object reference count
 		 */
+		struct ib_qp *base_qp = &qp->base_qp;
+
 		siw_qp_put(qp);
-		return &qp->base_qp;
+
+		return base_qp;
 	}
 	return NULL;
 }
-- 
2.34.1

