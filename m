Received: from sgoci-sdnproxy-4.icoremail.net (sgoci-sdnproxy-4.icoremail.net [129.150.39.64])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9340134DB57
	for <linux-rdma@vger.kernel.org>; Thu, 22 Jan 2026 14:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.150.39.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769092152; cv=none; b=dbdGb22DrlJmRTi37gvg/z482InQux4BXKNNAdA05V0iHNyk20zGENY3BqYaZxCB/qtyUUphvWo1OEuC3mjACB+Jhw6O5CORvaOTnU76btHUvGKSeLx3ZWYYdk6/BNiSTl/JdFL22ablTpb6CWWeWAupuJqNE90cDAU25S6fwRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769092152; c=relaxed/simple;
	bh=U3GgYtrVR2NiTVgSv2E0rQGLs50+AhRDpoHAejEbQa4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=USLW3Smuwg/8x+NEUfNY0aOtJOfI62siErx39i+4bgc5cgKRPEiSXiM0L6ho1Hfn5AhNF0Zb4G/MyuNstWMoqMseHDnuqj3fhfO1RCh5HaQjVzgv9h3tyRHYg2r0/XbB0fVu2qTLZkePOySGGr+aK5piYly51F0zXii8L6nV1KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mails.tsinghua.edu.cn; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn; dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b=BpvFbp4U; arc=none smtp.client-ip=129.150.39.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b="BpvFbp4U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=mails.tsinghua.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:
	Date:Message-Id:In-Reply-To:References:MIME-Version:
	Content-Transfer-Encoding; bh=DXUNrydkBRcAULeYqK8TBRhJ9QI0rb6kwn
	UcclfF3Tw=; b=BpvFbp4UZNRnl9wEl+JmoafaBDSNmGVeVdwOYR7tLL1K9mBtdW
	e3Ffo7/h/zaT2AxZxG4AYnCxGKlGWsgAn2gg31aAZ+N4vamyGgvIIFsod900SFqn
	7BCkIWQ72uPkcRU1frI+PEBLfb3esNZGXeuOxXhpWoXgmKH4YdwlpyPJk=
Received: from dell-PowerEdge-R760.. (unknown [101.6.30.120])
	by web4 (Coremail) with SMTP id ywQGZQAXeHIrNHJphh77AA--.36066S3;
	Thu, 22 Jan 2026 22:29:00 +0800 (CST)
From: Yi Liu <liuy22@mails.tsinghua.edu.cn>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	security@kernel.org,
	Yi Liu <liuy22@mails.tsinghua.edu.cn>
Subject: [PATCH 1/1] RDMA/uverbs: Validate wqe_size before using it in ib_uverbs_post_send
Date: Thu, 22 Jan 2026 22:29:00 +0800
Message-Id: <20260122142900.2356276-2-liuy22@mails.tsinghua.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260122142900.2356276-1-liuy22@mails.tsinghua.edu.cn>
References: <20260122142900.2356276-1-liuy22@mails.tsinghua.edu.cn>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ywQGZQAXeHIrNHJphh77AA--.36066S3
X-Coremail-Antispam: 1UD129KBjvJXoW7uw1fZFy8Zr1UWrWxAw4xZwb_yoW8Ww1rpr
	WUK3WjkrW7XF4fAF1DJw48u3yrA34kZFZrW3sa9asxZrn8Jryq9rZ0ya4YgrWrXr4kAr4Y
	qr4v9FnYgF4vvaUanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv21xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l8cAvFVAK
	0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4
	x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2
	z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4
	CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E74AGY7Cv6cx26r4r
	Kr1UJr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc
	8vx2IErcIFxwCY1x0262kKe7AKxVWUAVWUtwCY02Avz4vE14v_Xryl42xK82IYc2Ij64vI
	r41l42xK82IY6x8ErcxFaVAv8VW8Ww4UJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I
	0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWU
	AVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcV
	CY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAF
	wI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa
	7VU0xsqtUUUUU==
X-CM-SenderInfo: polx5j2s6ptxtovo32xlqjx3vdohv3gofq/1tbiAgMPAmlx-+5bcAAAsu

ib_uverbs_post_send() uses cmd.wqe_size from userspace without any
validation before passing it to kmalloc() and using the allocated
buffer as struct ib_uverbs_send_wr.

If a user provides a small wqe_size value (e.g., 1), kmalloc() will
succeed, but subsequent accesses to user_wr->opcode, user_wr->num_sge,
and other fields will read beyond the allocated buffer, resulting in
an out-of-bounds read from kernel heap memory. This could potentially
leak sensitive kernel information to userspace.

Additionally, providing an excessively large wqe_size can trigger a
WARNING in the memory allocation path, as reported by syzkaller.

This is inconsistent with ib_uverbs_unmarshall_recv() which properly
validates that wqe_size >= sizeof(struct ib_uverbs_recv_wr) before
proceeding.

Add the same validation for ib_uverbs_post_send() to ensure wqe_size
is at least sizeof(struct ib_uverbs_send_wr).

Fixes: 67cdb40ca444 ("[IB] uverbs: Implement more commands")
Signed-off-by: Yi Liu <liuy22@mails.tsinghua.edu.cn>
---
 drivers/infiniband/core/uverbs_cmd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index ce16404cd..a80b95948 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2049,6 +2049,9 @@ static int ib_uverbs_post_send(struct uverbs_attr_bundle *attrs)
 	if (ret)
 		return ret;
 
+	if (cmd.wqe_size < sizeof(struct ib_uverbs_send_wr))
+		return -EINVAL;
+
 	user_wr = kmalloc(cmd.wqe_size, GFP_KERNEL);
 	if (!user_wr)
 		return -ENOMEM;
-- 
2.34.1

