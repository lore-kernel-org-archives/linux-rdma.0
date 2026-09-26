Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A483E410E;
	Sat, 26 Sep 2026 11:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790421140; cv=none; b=tTT5GVX4ohOTQ+fofpkKj8W0voxpHc2jOzQnfHAkTEFRD1AjvCquXwlofjoxhMTfAWH9Ruazrdf2z8Moa2koW2KZCNz8m/AkVlKzhmD1M+rCvM0ha+EEgSpFl8p05Fl9MTnQQZZVkFJRjuSgKYppe3+usWGuWoO18jb4LwrCBuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790421140; c=relaxed/simple;
	bh=KukZKOUgt3F74QYiUEJQJe5cImuZhuD+kSiP0+r01zI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lbLM0zW030ux/mdS1Rz9ZK/BtruMnWbDzuBBATxI1dqENrSOHEK6RdEzh1Q4kjm/4SGrkLxmftR0rFMNzTnKs80GDtmIP4uQrfTkTXRt4a2C1/NVoXNZVK9Wm3dqaZBuooIBvDrSfFkW0XcXHTXu1yvaYVrTJoOBKjwVS/LN7Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=c5owg6KC; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="c5owg6KC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=hw
	J7VI0+ujbD9P/j/7w2KrdyKk1Y8GuLKpf5LntyMDg=; b=c5owg6KCY+ARPOBwh+
	J6AOsUIow1/JhC8TcX5/buvNFeC7wuIXFk0mXbArGMZ8F8RXQT4MiKvs1TtTjYHg
	5PY7STkHKoOrzqXzFn0Rztn8aiP1L+AEQ9Ps3y3P7gE/qhrmeAzpjpEIVc9P/9rm
	E9C85p0Q/IXrAdQKt0qmNK7fQ=
Received: from pc.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgD3v9x4qLdqiWj_BQ--.21688S2;
	Sat, 26 Sep 2026 19:11:53 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Yishai Hadas <yishaih@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Matan Barak <matanb@mellanox.com>,
	Or Gerlitz <ogerlitz@mellanox.com>,
	Doug Ledford <dledford@redhat.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH] RDMA/mlx4: Do not allow the user to write to the clock page
Date: Sat, 26 Sep 2026 19:11:50 +0800
Message-Id: <20260926111150.3197004-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgD3v9x4qLdqiWj_BQ--.21688S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7KryUtry7Zw4UGrykKr1fXrb_yoW8Jw47pr
	s7KF43tr4UJF1F9w4DGFWUAryFka4rG3srCr1qywn0vrn0qF42yFs0kayqgr4kJry5ZFsI
	qF4UZayDC3ZFgrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piLF4tUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8BnQC2q3qHkv3gAA3P

mlx4_ib_mmap() maps the internal clock page to userspace through
rdma_user_mmap_io(), which does not restrict write access. Userspace can
request PROT_WRITE directly, or upgrade a read-only mapping later with
mprotect() because VM_MAYWRITE remains set.

Reject VM_WRITE and clear VM_MAYWRITE, applying the same read-only policy
as commit c660133c339f ("RDMA/mlx5: Do not allow the user to write to the
clock page"). The rdma-core mlx4 provider requests this mapping with
PROT_READ, so its existing behavior is unchanged.

Fixes: 52033cfb5aab ("IB/mlx4: Add mmap call to map the hardware clock")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/infiniband/hw/mlx4/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 7266a6141944..6646a2633511 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1169,6 +1169,10 @@ static int mlx4_ib_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 		struct mlx4_clock_params params;
 		int ret;
 
+		if (vma->vm_flags & VM_WRITE)
+			return -EPERM;
+		vm_flags_clear(vma, VM_MAYWRITE);
+
 		ret = mlx4_get_internal_clock_params(dev->dev, &params);
 		if (ret)
 			return ret;
-- 
2.34.1

