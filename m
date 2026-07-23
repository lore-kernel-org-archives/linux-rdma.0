Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2227353A6C;
	Thu, 23 Jul 2026 08:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.243.244.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784794734; cv=none; b=J+z/xTGRlSZEtz1zTPJaDHkE4Oo0IkNPZhDlWXbqzN0NnntwDsoBEy8WR8QYOCxPf+8BC4DppEfhz/BGlJ6E/UIoGecVmqR7KgG3NBU+Lpd9LkAZ+xJytS1lhu6+kXdhtN0FkEpbV5pD5cX7/4/tOVd6R61DMFJPi/AFASB/xzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784794734; c=relaxed/simple;
	bh=og+AKdNvuLvumDLvy8hUl5Gqx4Tj/sfpbCbE3hrKeLQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=drguM1IxEEPljglr4CSFKm6ekObDWxJ5hy9y50H1qatmowOZPOUW5MIJlFEK6SM/RV+zgZQdlhy4GOeu3prkGj4aGl8+jd3vncav5zcf7xjeNb4eke6KgXfwelDWZ8ixhQw0iUuIdRBaKhsnpUhvFhfd6dVhZta/cNu2/zmsr/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=JCuRTG9k; arc=none smtp.client-ip=54.243.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="JCuRTG9k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784794717;
	bh=M/ih3PE8BMb0rsQpbXEWQtv8rMoC5z+b1JH5VZrcmKA=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=JCuRTG9kRDEyCPYkLzzu45fjlMfMD8m+UVjr6WYeQrwPoulqIRR3nZC1TpCELKi6b
	 BAFJJCBRSwFvJwh25rId4FlrrqtI6nx29ZK8CXKbs991B8R5CUDJdb7qgwB+X9OZv0
	 PDNWmejewtnG/MzE34tuwg0HGYewkhh+BryoU6QA=
X-QQ-mid: zesmtpip2t1784794703tfaa1232e
X-QQ-Originating-IP: Vy8SA80zHSIgO+PkAaA5Jfe2lJklerHx6qvJlapt3Sk=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 23 Jul 2026 16:18:20 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 6715730035353289087
EX-QQ-RecipientCnt: 26
From: Gou Hao <gouhao@uniontech.com>
To: maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	bharat@chelsio.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	akpm@linux-foundation.org,
	ynorov@nvidia.com,
	namcao@linutronix.de,
	mkchauras@gmail.com,
	sshegde@linux.ibm.com,
	nilay@linux.ibm.com,
	kees@kernel.org
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	linux-mm@kvack.org,
	gouhaojake@163.com,
	kernel@uniontech.com
Subject: [PATCH 1/4] powerpc/xive: remove dead NULL check after GFP_NOFAIL allocation
Date: Thu, 23 Jul 2026 16:18:10 +0800
Message-Id: <20260723081813.176792-2-gouhao@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260723081813.176792-1-gouhao@uniontech.com>
References: <20260723081813.176792-1-gouhao@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: ORuEwgb9eurk0uhs0KAQNjISW6COScqN7JZORk8blbXgvJC2KMBclqao
	Fof6IUnoPytghJZmn/zO5pt3odFiU9lf2373qoMZbX5rA6CyGHGJ4EXoeyrfBI1SOG/AvyM
	gsH/M6tVnAVUOZWeGeWl40fN2lywWlFVhc9NrJwl7tnzwVGug/YmKuF2Xjd9RmuufuZNaTJ
	S5FIgF/fUYvtnjC0iug+nJOB+ffPmMPj4zL/teEe0Tv2b3MQO2EVwnreFRLtmuGHJl0uqEG
	kwsDeTLcouZ/ewsyL2zvSiIFLpOkkZ1RAP/YOB4rcAyqJPSjl+OBk5RoJrrsOs1YlUKONiM
	zFyixbe+jCRzlmuwJrbclYH/XG1ikX3xURQYcVkNropBmVVc/DGwvaIoffUkcr8bn97/HNi
	461tK3scqKH3YyEbSEb1xQ3S5I/g8qmmpGgmKCf98CYNG5gFP0Es/i0NuIPWhJbodVkIwLK
	2h/jjQC0mIPebRPDsf3zn7Ajk8rA87/yx5xajYGte+QcNGhtU784cQtuYHksLTgVjpw9L7b
	uV0Uonhg7i/gvVKP4e41FKgqIlAr7OjjvLgMJTVFXijjrIPcPDtNc71ER1RY2qSL8eKLmIl
	NL41DSnSm/VmI/dDPOXMPDn9MWOcwQYWrqMIHg7mLbJMwWUe6To3PTQHUh0UnEzyu3Cg3C5
	TGIHs89GLXjlKXK0QQp9pg4O+1PMqPFspP0eTYBl+BUdk6NoEyGUGRZBRLzRC0f6tJG7mIz
	mjmLnqg2bBhQzj/I4UNGilqw7Acc/+4ZMBQbkXc1KEx+r0JIMpNDC5et+0x8qcAunwhezL/
	AIST5PZ8jKGYyJ9d6cO7wQ3doVQKy6y5WMQtP45rjrYrt4wSEopfNDwyl59hNIUKigyzQDh
	ahFwbHys8hl5Tr3QRzjJUAJVph77yhy05qcrf+PrIqLeuxiVIKwt06WEVqJ7nlvpxnoCHzw
	HMoZWB/lxSU3bqnc1jxFsCHwCGyFaugFLSTFnb3J6IZKtoxljeV/O+fCBRQZx1nkX8I8SHV
	YcEdu+7hZJoLFrXZcTecamAzhtYQSlSDoSLgOQ3Q2G+JRrDzXC
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-QQ-RECHKSPAM: 0

kzalloc_objs with the __GFP_NOFAIL flag will never return NULL, so the
subsequent NULL check is unreachable dead code. Remove it.

Signed-off-by: Gou Hao <gouhao@uniontech.com>
---
 arch/powerpc/sysdev/xive/common.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
index dadd1f46ec93..79d7854259cb 100644
--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -1134,9 +1134,6 @@ static int __init xive_init_ipis(void)
 
 	xive_ipis = kzalloc_objs(*xive_ipis, nr_node_ids,
 				 GFP_KERNEL | __GFP_NOFAIL);
-	if (!xive_ipis)
-		goto out_free_domain;
-
 	for_each_node(node) {
 		struct xive_ipi_desc *xid = &xive_ipis[node];
 		struct xive_ipi_alloc_info info = { node };
-- 
2.20.1

