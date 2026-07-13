Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D243C13B5B3
	for <linux-rdma@vger.kernel.org>; Mon, 13 Jul 2026 01:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783904692; cv=none; b=cSxQTQ6QyPAQFr3Di546dZwzbtVdL67D/6pMcCQwcJOgnBvV16F1OqdS4puCPQ+rv26xPGb4tufT+eGkIf8RNX7hDbapiXk4Fw+1tjKdJfTNS89EShLwJbss8gy81iC4323I1QukW0lvg1ZPZBa8FNnHPmOtRDRyyMKds8nNTMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783904692; c=relaxed/simple;
	bh=MDXiqBvRi4XIPGtmJGD1yYGhmqoChWNW40l2edZOobQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kAJCdGTGwfuNRg1wUImUEyzDEfwkaxsk1Ihj4VJ6734jXlaYHQXLF5Cteo/8BEDGZr1QOJfdJShIQVt3jH4GuqD2h8UIZ+B9GARVwkI/8zCnxdn0F12+gnv+j1sQGngifYEXwtNn+xUjEo51yi2hg5UrbKR93YbXP68dJr76Dq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=TbY2aiP/; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="TbY2aiP/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=CX
	r5DYp/thVWx+Kvc82MzILJ96T0ylzvAl1fVOJlESA=; b=TbY2aiP/r0TSLoVDUL
	Onh58UjFLrGTwmSLN24i5noemiT/6FYVg75w9ucgrpfOOWpjeMe83pUqFv4l9tGh
	hDn+G8IQFMClcpYX5ikuB6/Bd5OkYRfXVcquzYbBul450/iwpimCLIKDzWafCXeh
	3wCSoFS6QWBoM8/Bu6qC6RVBY=
Received: from xwm-TianYi510Pro-14IMB.. (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wBnViWkOVRqdgbTJQ--.10381S2;
	Mon, 13 Jul 2026 09:04:37 +0800 (CST)
From: weimin xiong <15927021679@163.com>
To: linux-rdma@vger.kernel.org
Cc: jgg@nvidia.com,
	xiongweimin <xiongweimin@kylinos.cn>
Subject: [PATCH] RDMA/rxe: Reject unimplemented implicit ODP cleanly
Date: Mon, 13 Jul 2026 09:04:39 +0800
Message-ID: <20260713010439.331054-1-15927021679@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBnViWkOVRqdgbTJQ--.10381S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jr13Ww4fKr47trWkuw1fCrg_yoWDKrb_Kr
	18uF97GF4Yya9IkanrCF95Cr4YyF4293Z7Xwnrtry7Zr1xJrWFgayfJF9IvFyjgrn29as8
	C39I9w18XF15ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRRD73tUUUUU==
X-CM-SenderInfo: jprvmjixqsilmxzbiqqrwthudrp/xtbC0gUnr2pUOaUHCAAA3y

From: xiongweimin <xiongweimin@kylinos.cn>

rxe advertises ODP but not IB_ODP_SUPPORT_IMPLICIT. The reg_user_mr path
still contained a dead branch that checked the implicit capability and
could never succeed.

Return -EOPNOTSUPP for the implicit ODP address range up front so the
intent is obvious and the unreachable code is gone.

Signed-off-by: xiongweimin <xiongweimin@kylinos.cn>
Cc: linux-rdma@vger.kernel.org
Cc: Jason Gunthorpe <jgg@nvidia.com>
---

--- a/drivers/infiniband/sw/rxe/rxe_odp.c
+++ b/drivers/infiniband/sw/rxe/rxe_odp.c
@@ -87,14 +87,9 @@
 
 	rxe_mr_init(access_flags, mr);
 
-	if (!start && length == U64_MAX) {
-		if (iova != 0)
-			return -EINVAL;
-		if (!(rxe->attr.odp_caps.general_caps & IB_ODP_SUPPORT_IMPLICIT))
-			return -EINVAL;
-
-		/* Never reach here, for implicit ODP is not implemented. */
-	}
+	/* Implicit ODP (start=0, length=U64_MAX) is not implemented. */
+	if (!start && length == U64_MAX)
+		return -EOPNOTSUPP;
 
 	umem_odp = ib_umem_odp_get(&rxe->ib_dev, start, length, access_flags,
 				   &rxe_mn_ops);

