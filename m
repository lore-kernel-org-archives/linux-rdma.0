Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416E52DFA2F;
	Fri, 24 Jul 2026 02:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784860161; cv=none; b=jC6pesrqTpJtbO2GiwmwZS17FiVonuHEj+Mb7tnEkSSg9WQnLbtgsyH21j38XOaEXJKllQ6TFpIxHJxKQQv1wjIolmsqq2BC3+8TbqavficSSEN0PGvmO6m+gc64IDk77e4D8QIIt4jClPJbORZ50CrFWWyfUIw+52X8uv9OKNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784860161; c=relaxed/simple;
	bh=m96zxm1tlVq9oW7yYZBLEg7xTdMzMUccwEOKVWUnif8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jdW+1Pb0yzoQB/b22FGbMOl1fkZZxkxCADKefReO4Ybp1VDOvjzHHJVO3jQZxyuEFYX/2OKbdZL7eGxO3YQ4CqTpRqhZtAG9bkNN8vwA5SefTRyLPYOvRHaOwD5SpnHXkRSatig0hPISfFLghqZYbqfHtOWVF5Yi003gtujMrM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=Thpc9fD+; arc=none smtp.client-ip=54.204.34.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="Thpc9fD+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784860149;
	bh=XcvnlsC3HhT/It5VuOwr2y7sGHW1GiSiBgnaGk3guqk=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=Thpc9fD+snLZvia4IvIECJR4/9ngZ61H2O5O1Og1QqoADevADqPMz/Bq1/8BXRRWz
	 JCrXR8+gXkama1LSqp+3/GKFYENpvhaX29P6kuiuDXji9ZyCg63LOcE/Yq33QZNkGR
	 BEJyJj84Px6hBhmJtbdXUe181psxM+dEj5Zv63ag=
X-QQ-mid: zesmtpip4t1784860141tf7457151
X-QQ-Originating-IP: mFrNixuyb/9G3t9a9hZZYveY0Gmd34ZMyBS60EAtLAY=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 24 Jul 2026 10:28:58 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 9941543075585726979
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
	gouhao@uniontech.com,
	namcao@linutronix.de,
	ynorov@nvidia.com,
	sshegde@linux.ibm.com,
	nilay@linux.ibm.com,
	clg@kaod.org
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	linux-mm@kvack.org,
	gouhaojake@163.com,
	kernel@uniontech.com
Subject: [PATCH v2 1/6] powerpc/xive: remove dead NULL check after GFP_NOFAIL allocation
Date: Fri, 24 Jul 2026 10:28:46 +0800
Message-Id: <20260724022851.466017-2-gouhao@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260724022851.466017-1-gouhao@uniontech.com>
References: <20260724022851.466017-1-gouhao@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: MKbitA53r7aLciQUIs5N5Tp6Sxgcv1w+S7zBqk7n99csOTvy406dgMTT
	sOkgZ/hApPmf3bKG96PkPQXXAxqBoFy032u3JELorA5el5VbXUFO48WAQSd7HLbFz0WY5au
	RJOyxbSi/6iIHkn2Xi+6yfQ6XD9GM1BVHqR7LsYps5FZSPhMPpOehOFlDn766uJo8N0N062
	7RIKqwXW0GbV3ggW0syika0wVakN5jMKmg1en2o7zQg1J9C7iD2YGR0LQ7gZIwXlcV2/mMi
	TcfIeb0mIim9VBNK6vV4TEpYESu3cYTqfSddr1VpvFZnbjLz+nnJmflHgl394kpMeb1suYP
	jdeemvNIcTLVvsUJiIRJLo9kPfOkiYsc6itKN4eG1X6OScjRg+Z7aixxybDe/ACwO7f90fb
	8uxBmydEvHaboLANp1H3ozrpT0CcQTWb3S0tbsltGquaE6rgtkfatvM4QK7u/6b4VsOQAaF
	L0lDweit4ID6Rcu09PWdl36HLVpP/HDgEIrHV9471gZQdU4Br10CoDK4kWV/v6vcixuM9s1
	+jjVV+pZZQv7/vBSIExQT6Et2mX0uE0p6JjR9DxNZjf9bwo8s0WJK+81+xpGzqKX2u15Dd1
	VWk2DsXsc4p7XJfbRYYuNhyA5lGoZijiCmmKDXx5nykLEzGnnyOA5R9YMiLV8h0GXpLwmJy
	+gR9SO0qnSTlhPEfyqFT5hdhiS2twGQ2QyQmzEU/dbEd0n+oxp/29w47XgkGTlHonnMnfXv
	6cHoGb7wt3HrEOL+2d9IF13hFhh4blxEWutjyW5x4etjB6KM19S1fAMESkq6+cyT2frQd6R
	3LvOXcmR5Zaq8kXvi/8wf89atufvJPDTTu48VLXNYJxAsKzQ4SOcv55zfPJHucsEn1dlnr3
	7KO+I6yDPj6G1JWZSo1evCa0mq1hdDVyVXrs51k0NKz1NZiT1YXBblk97uhAKp60Igmj5NN
	fRQxcdy21Z02GDr83vZNnDfSN5n6YO3kjHX5/2f9cooFOCvOxKVXm68I14zwqPUfoaAINh4
	abHRQH0HbIhtCijWfcdOJivysz4H/LuQ1/Y5sySLwXzSENUP5y+q7lbOgIexhy6UfoK3OVn
	Pqu3XwNpby90rSSIuxhVoY=
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-QQ-RECHKSPAM: 0

kzalloc_objs with the __GFP_NOFAIL flag will never return NULL, so the
subsequent NULL check is unreachable dead code. Remove it.

Signed-off-by: Gou Hao <gouhao@uniontech.com>
Reviewed-by: Wentao Guan <guanwentao@uniontech.com>
Reviewed-by: jiazhenyuan <jiazhenyuan@uniontech.com>
---
 arch/powerpc/sysdev/xive/common.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
index dadd1f46ec939..f2904a5c2b7bf 100644
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
@@ -1158,7 +1155,7 @@ static int __init xive_init_ipis(void)
 
 out_free_xive_ipis:
 	kfree(xive_ipis);
-out_free_domain:
+	xive_ipis = NULL;
 	irq_domain_remove(ipi_domain);
 out_free_fwnode:
 	irq_domain_free_fwnode(fwnode);
-- 
2.20.1

