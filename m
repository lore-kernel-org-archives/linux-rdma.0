Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A3340F750;
	Sat, 26 Sep 2026 11:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790422017; cv=none; b=nSH+VMCqZ3gXtMOF3kRWL7hwI8ikuBg4MQEl85CrY1MAQLdCRcVK6x3Aif4yx6pgZj+QxMQYn5/KzIw8D1JcUH1GR+xjbl5nVgJ9BhZ9IvupxQDARlIHZzVSrAsJdERhCgPHgq4B7ag5QOsF51Yza7KxiJ6ogi+kE98hLrJZAxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790422017; c=relaxed/simple;
	bh=AKNYMBCBNHg5CT75u4KYgsvAeMcJmlsYCtiIVUjfecg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HLf19DkLTV3Luklk4yjHDvaa/yB7gchomo/sYJmFQ614rtrOUbGtysc7CMrx0k6Ze40yrNNmJEUdO1VXt6e9JKcbJH4KKTOjFw8BUnnzDW/0W7KRVQqOW7PR4zLDJkmsh8TWCrzXKiJE4raqIY3v82zQpU35H7HNuCEUEHngpt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=dvgL982u; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="dvgL982u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Lr
	dOerfazzeY+R2sJdlV/wqyAsV0SoA0l4FrqC0va9E=; b=dvgL982uLp/yVOvYdb
	wHEc5m+poMw26PaOIm6RztNYqOi+NFSnS/wx3kaSeGMCJLJ2LFBMinkABWL4QRqa
	DtwGw8VE4zv0xLXvYI6IJ84qmDTxlUnaQKR6eHsNAmOSRAl41DRU/3pnx9Fr7xqf
	pCleKvqM3stc0d3z3iYclL+pk=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wD3H_vVq7dqbTy_Aw--.52876S2;
	Sat, 26 Sep 2026 19:26:14 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Potnuri Bharat Teja <bharat@chelsio.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Steve Wise <larrystevenwise@gmail.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH] RDMA/cxgb4: Do not allow userspace to write the status page
Date: Sat, 26 Sep 2026 19:26:11 +0800
Message-Id: <20260926112611.3214382-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3H_vVq7dqbTy_Aw--.52876S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJrW7uF1rKr4fWw18ZF4fZrb_yoW8XFykpF
	Z3GF929rWUJF48uw1ktayIvryFgrykta4qka4Dt3s5uF9xZw17urn0kFWaqF1kZr48Gr1a
	vr45Xr18GF4jgrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pEqg47UUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8Bao4mq3q9ZnjQAA3m

The device status page is shared by all userspace contexts and contains
db_off, which the driver updates to control doorbell flow. The rdma-core
provider maps it with PROT_READ, but c4iw_mmap() passes the requested page
protection through when handling CXGB4_MMAP_CONTIG.

A process can therefore request PROT_WRITE directly or later upgrade a
read-only mapping with mprotect() because VM_MAYWRITE remains set. This
lets userspace alter device-wide flow-control state seen by the kernel and
other contexts.

Reject initially writable mappings and clear VM_MAYWRITE before mapping the
page. This preserves the existing read-only userspace ABI.

Fixes: 05eb23893c2c ("cxgb4/iw_cxgb4: Doorbell Drop Avoidance Bug Fixes")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/infiniband/hw/cxgb4/provider.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index ebe3170a641c..11c2a891f934 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -171,6 +171,11 @@ static int c4iw_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 					 len, t4_pgprot_wc(vma->vm_page_prot));
 		break;
 	case CXGB4_MMAP_CONTIG:
+		if (vma->vm_flags & VM_WRITE) {
+			ret = -EPERM;
+			break;
+		}
+		vm_flags_clear(vma, VM_MAYWRITE);
 		ret = io_remap_pfn_range(vma, vma->vm_start,
 					 addr >> PAGE_SHIFT,
 					 len, vma->vm_page_prot);
-- 
2.34.1

