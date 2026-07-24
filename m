Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCE631985D;
	Fri, 24 Jul 2026 02:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.169.211.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784860180; cv=none; b=nL96TUolTfo/LznUgfhQavVBJu2iQYXpEGvYcwGIqG2aXWC9MMDnegGXEVOCvTBePGeS1Yrn/+A9KBWV65nJnoGB3MxoxwMkLjRm0mjjJpbSt/xcbReMtBXBwj7fh650UIkEksAp10UCkIQL1P3Fx/YsLcF+mE7A1Umsf7RVzCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784860180; c=relaxed/simple;
	bh=4PnnGJ6+0v44DOxB1H5wpOo39BV7YOi1rtx2aSUDuWA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bl9e2O2y98yIt3YDWs4FXg0g3KAwF9RW3K+g/g+4lE2XFAedn4Fiw3xqiN1yUOVcmp2dmeAlqMnDOBetzy/beGc3TMzoqOC9DzPnXyc4FJDH1gxocHqMKAe0m9B32dq9WfZ4Ns39Az0EuDKbaurUenCd6xp1N3m5D93CppG8Zfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=ImOl3V+3; arc=none smtp.client-ip=18.169.211.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="ImOl3V+3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784860168;
	bh=OyqXJDBODKL4i9r4faSbxqKqbqbjK9rOASLwkWPXzB4=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=ImOl3V+3qmGjRisyVUVd9mh2AZ0NFSJDdEzDIqUpNvqoNTKhOzOi6KGDffGACMmtR
	 Ieie27rcygsxcHg/b5/K/9wRnsRHf46IlOy9eN5HlR7Vl9LPGQaDr1c7Xc6lm8x8IL
	 1q3YhVXJS2PN8fyIiZ8h9JL89x+DGRIhNn+dO7mU=
X-QQ-mid: zesmtpip4t1784860161t8fb1ed23
X-QQ-Originating-IP: aBJCglJ9q/YAKBS1d2e+RK0bytOzmdANKIZ+RTuS4uM=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 24 Jul 2026 10:29:19 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 645947347967007313
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
Subject: [PATCH v2 5/6] lib/test_hmm: remove dead NULL checks after GFP_NOFAIL allocations
Date: Fri, 24 Jul 2026 10:28:50 +0800
Message-Id: <20260724022851.466017-6-gouhao@uniontech.com>
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
X-QQ-XMAILINFO: MhQmneo+3OPbeQBuJJY9aHki43hwqRhTZA8RBTTsTVh6xygcqsJ5LM84
	51kCX/5nBUggAR5Q2KtqnFtaQFGbZwgpt1Bxp3zhwC2QFRUsB/CQLEVdX1cgGoF5y8hEGc3
	nJAWwUMupjREAV6EhTuCagftQRhJz9/eNPhqPlJ2GZBawTKyouKP4OsUKK6hjQqKHGC0nG2
	gxjfuD+m+W3xlV1hmpL4Ngfx3vjJH+LljEfOipBekInwM6A15YkTnkOPwjRAk0JO2ZpsrOT
	cEVbogtyNvUTx/+H/R83YnUk7X791NfttDwrSAyHEUhgm9ZxJn9H2PfrBVZpWmloVIjtpUQ
	5dBE2a4UKQy74DQAzoHmi9K0RnRKBTN2E17ofm02O00H+xX92mCUfxOlEXubxUCOmYf3sgl
	UaGJu8yY7U5JJ5Fk5N3Y9R2x1sQAlryg5M4owSs0uaWu9igsBEuWoIz4FtkfjxQLT3SmUCG
	gTrsFdYMkkalMUkGZFTdsiQWmz5U1WkJY7+wc4d3SnpsBnA/HSSkDeJgF27WIBFNaaC6Tu1
	lJRQtK0OuvBzTzaHgdWaJc+ebtjhK+utAjb8rCaI8DIk1j380k6HhRsSQDUKlEGkMX9ZDhC
	7UJWRaNoc0dHa44YFeTuUvJc5n/tjISyHkvw4ispyWGH1t/78f3/Vo/o0/cMWV4+AX1FE1z
	IqXDayP51VASxpf8VibmnPBTYw7qcaMWymgQfxBDJBd86kDya/c1hc2p4+5B6WYBit55b06
	U9pqsMK5hXhe9IjVnHKY4kwEianfI2/c+vWVDwoQlfsMaZlQtLuAFDBjrIc7efsS2LmLNZJ
	SGSh54oApiRAByxCv57JvkAYMwFMSDWG4MSRizPYr0I/2+XVoUaukzI3kamwuoe4cRu32B3
	yTaxrRU3pfikruafSgojo4G9lhqQcJgcDKwoQm9quVD4bCqMkjYnmjWdVBXz2QzYlQHhubS
	Rzhkw7lMSmTjJlOR5miHUVgmN6RG9K59g2S4C0ERw7Bx59dITwa9JRtz5TLKt2gD7xEFgJl
	I+CRuAJYlKEXq7ob2KvkJcmq4KGn5ABj/6SdlHwuIwoiYBx9QI0KKUVCVmhWE=
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
X-QQ-RECHKSPAM: 0

kvcalloc with the __GFP_NOFAIL flag will never return NULL, so the
subsequent NULL checks are unreachable dead code. Remove them.

Signed-off-by: Gou Hao <gouhao@uniontech.com>
---
 lib/test_hmm.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 9c59d1ceb5b57..d615e4e5fc447 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1209,16 +1209,10 @@ static int dmirror_migrate_to_device(struct dmirror *dmirror,
 	if (!mmget_not_zero(mm))
 		return -EINVAL;
 
-	ret = -ENOMEM;
 	src_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*src_pfns),
 			  GFP_KERNEL | __GFP_NOFAIL);
-	if (!src_pfns)
-		goto free_mem;
-
 	dst_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*dst_pfns),
 			  GFP_KERNEL | __GFP_NOFAIL);
-	if (!dst_pfns)
-		goto free_mem;
 
 	ret = 0;
 	mmap_read_lock(mm);
-- 
2.20.1

