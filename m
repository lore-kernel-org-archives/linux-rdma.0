Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [207.46.229.174])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C560523EA8E;
	Thu, 29 Jan 2026 09:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.46.229.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769680151; cv=none; b=YC3j45LZzMiHVXVqxLpuAjr6nqc67UGCB+lIz5+ylgvORFIuWcVPdwwtKHRxpVR5huYIY1JMeG8wPX0kMdbs55LtnD2fQ5gCpXvFB7UPLUnnfd9OpXEqUOwTSX1+/BTfG8d9yH6GsdKU31IfF2MtW07uQtePDvC9jZFyOCb7QyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769680151; c=relaxed/simple;
	bh=j23I5BMpt9wdiml7NxDJkAE3uCnfJXvk+YB5KnJcQgk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FuwlXNzd0VEs6gY38KhG6BiE4eWQngc2FTf2OR0YZm0UTGA89Br19PbekQ7sYmojRM5JnsTboUy7iYnZ/qQxWpibUCZDN+3AY6WSDPkWJMoTN1wSyyqwGB/mz1hKp2vdW3EB5+Xofun+fzCM11frd3MQSuEBinvIugdFehXN2dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mails.tsinghua.edu.cn; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn; dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b=rb6udHAW; arc=none smtp.client-ip=207.46.229.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b="rb6udHAW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=mails.tsinghua.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:
	Date:Message-Id:MIME-Version:Content-Transfer-Encoding; bh=al7qV
	6P3H8oFkxf8YHWTSu52vvj4wyLny+U+gUFbRZU=; b=rb6udHAWj6Xg7IQKIlAo6
	t7gM/ZnoMBTenJtxugVnGn7GnyP4x7PR+ncUuMT6Vvrobkc9esIM0kReGNZhVvtC
	nZNIcAEm2rovJ/RtOIZhInC1WTXoyv+AxwjqxYuz1n2BlwK7YhAbIojZEuWUhp1Y
	894KcJBicFAbn3OQPkHsiA=
Received: from dell-PowerEdge-R760.. (unknown [101.6.30.120])
	by web2 (Coremail) with SMTP id yQQGZQA3ljsNLXtpbQxOAg--.19177S2;
	Thu, 29 Jan 2026 17:49:01 +0800 (CST)
From: Yi Liu <liuy22@mails.tsinghua.edu.cn>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	Yi Liu <liuy22@mails.tsinghua.edu.cn>,
	stable@vger.kernel.org
Subject: [PATCH] RDMA/uverbs: Add __GFP_NOWARN to ib_uverbs_unmarshall_recv() kmalloc
Date: Thu, 29 Jan 2026 17:49:00 +0800
Message-Id: <20260129094900.3517706-1-liuy22@mails.tsinghua.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:yQQGZQA3ljsNLXtpbQxOAg--.19177S2
X-Coremail-Antispam: 1UD129KBjvdXoWrKr4UGFW3urWfXw47ZF4Utwb_yoWkCwc_Gr
	1UXrs7uFW5CF4Ykr1Uuw4S9F1a9w43C3Za9a4Fka43Ja45Jw13W34SvF93Wr4fWw47GFyD
	ArZ5J397Grs2gjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbxAFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kI
	II0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7
	xvwVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28E
	F7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzx
	vE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VCjz48v1sIEY20_GrWk
	Jr1UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5c
	I20VAGYxC7MxkF7I0En4kS14v26r126r1DMxkIecxEwVAFwVW8uwCF04k20xvY0x0EwIxG
	rwCF04k20xvE74AGY7Cv6cx26r4rKr1UJr1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxV
	Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r12
	6r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6x
	kF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AK
	xVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0J
	jzNtsUUUUU=
X-CM-SenderInfo: polx5j2s6ptxtovo32xlqjx3vdohv3gofq/1tbiAgECAml6jQ7xkAAAsy

Since wqe_size in ib_uverbs_unmarshall_recv() is user-provided and already
validated, but can still be large, add __GFP_NOWARN to suppress memory
allocation warnings for large sizes, consistent with the similar fix in
ib_uverbs_post_send().

Cc: stable@vger.kernel.org
Fixes: 67cdb40ca444 ("[IB] uverbs: Implement more commands")
Link: https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/commit/?id=1956f0a74ccf5d
Signed-off-by: Yi Liu <liuy22@mails.tsinghua.edu.cn>
---
 drivers/infiniband/core/uverbs_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index ce16404cdfb8c..c28681f6985f1 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2239,7 +2239,7 @@ ib_uverbs_unmarshall_recv(struct uverbs_req_iter *iter, u32 wr_count,
 	if (ret)
 		return ERR_PTR(ret);
 
-	user_wr = kmalloc(wqe_size, GFP_KERNEL);
+	user_wr = kmalloc(wqe_size, GFP_KERNEL | __GFP_NOWARN);
 	if (!user_wr)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.34.1

