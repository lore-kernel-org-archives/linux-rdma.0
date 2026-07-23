Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF113E0081;
	Thu, 23 Jul 2026 08:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.19.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784794743; cv=none; b=X0w7T4lSabCxvkVlsPsTjle88T/aLqH6zkAMHTcM0L4jh+w0dQX71XhaneBHyn2oGq7QKdvtRRbl4Xk3lrPw0Wh3nfXdbXZ4xX6ZH39R4TLIN49CPYbAUg+ZZXufAlmj/OAkumB2oxRL49LgiioausiAkvPlg+11/EDOeLLChbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784794743; c=relaxed/simple;
	bh=Fb92DpvmfVuvg9SelQzyDTxdgko02nMs4Gq/ahvxuTw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B/S0fSnEt2sjoBhld5wIxggOOsQISSEcu0B7IYIg4FE6b1MmKHgYEcW3h4Xk7Wys2+eB59YXTfwcART1aBbwJ2QPlFeCJipZQEvzYHSjRB4N2OYKtXoHHoU56bFDlYvp6jA/cUULTeBjHRpc466EWstnpuThzKs9yiinVpZ5DzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=WE8UgOHI; arc=none smtp.client-ip=54.207.19.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="WE8UgOHI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784794726;
	bh=5Ru4P6jK+Inu2P6W3ZLj3pcMa86MCoNiZGSUv0GMeE8=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=WE8UgOHIHxr7PngSacK5282ascowtMdhany98NPlOaw//B9WHbbbl5ysF9eQ161Wm
	 BzDHFW1UXmsOrKxumQ9ft3r/9k/AHXmunXV+b67i+SI1eND6re8em3ulFrcZ6kEnKC
	 KZB1rx3o53JtIF4Xie9jvT64SXxIwcWLi6DCe2fY=
X-QQ-mid: zesmtpip2t1784794713t01a6cdde
X-QQ-Originating-IP: HMKwZheqtj88lyEjppGtB8zm5VBw5QQ/hPZB97lqyKU=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 23 Jul 2026 16:18:30 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 15366830240286596552
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
Subject: [PATCH 3/4] lib/test_hmm: remove dead NULL checks after GFP_NOFAIL allocations
Date: Thu, 23 Jul 2026 16:18:12 +0800
Message-Id: <20260723081813.176792-4-gouhao@uniontech.com>
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
X-QQ-XMAILINFO: NQR8mRxMnur9Ed4UhG1I0ScMYJlq0NroyzKpr4NhVXJPNDpRdlKhuAkX
	Oy1eIkPWejBV+ajgYLbPsIOd6FtSJeIGjMP2EgLU3+9cENDsoY8YzuvMY6TyTbHobhcc9tM
	/uFeDH6LSi5m2Y+PMm9xpy6U/PQD+m5QoF/KnYjMx6R1i1kk0wwmAJZgdHP4yx1piMMf33J
	Z1ISZPHHWnQmCJDz4m0z1YMzeg/dkPu3YMKW6LqohrgjryhHciZ3GuPgC51lsUgE2bcoCbu
	3U/MY+GczfUtbmTczXEfWMK5+0JhAsHADCS4CScMmqoFRwIbz5yG7iIAYBd0weugruZF3GT
	y7ge2fzm5rFw+XD2nZrYILyBAMbGcTB1vr4IX499YGZ9rtdVwTziR4XBiLtqXnymgGyVcT4
	SDG1GLkiDcsAFFuYa/pZQkcnaH+7wEGQQ3VBAehTGu/C4k1HWWf53kd2vbrvaqLrPY4wvMg
	6HbL7x3TJnTIg9vSaKepFJMe1w/tvPXViRyFavPsK/bcnQ6D7Zla8f7TztdJenXQ87cVFPc
	cf8VicQ4XffovRGVniSL3ULD8hjDGTW8Pxps8tz90tS5nYj4BFoqL0U/2X0RgabY3re2YsT
	ymvrmgNRokSzn6eDD0Pj9lBAU7TBzd58KnI4XiGZO2KoGxo5IPOnzzaTGZ4TdF07VwQvS2j
	AGZgTkTkDSd2+mYWszwpuEJ0eJ+ElOHNOe7f2S+F4EnzkjIhvX/hccvy15FFLAgK6T7iJ9O
	dE6X3UXnpscvT2f2nM2/mjdFbQ2LZuxXDEh736QELQ1NF9jgsYQEYfiSVSXeamXTfzlpukY
	Sbrb5s4V2gr/C9cKSWDkt3epTIoWzPB+1M0LNZye9zTn7MwOCxsRPuddZtSmHchIguZKSTp
	NlBwSZKSh1YkAsBT+cg357I16bjfYBr5LgIiDCjtBIQVdtiO0fLbEykqjQKP2Z5KZA1pyV/
	8Cl817h3CFmIJFu3ZvqmSDAhquhGh1P1HfFtxGmQL+d5N8Rz2UnbsaWu9J7Wc9JpoqLFfbD
	QKU4fRSvwghvb8Jzifuc1fJihDz+SJDVqBjyHVHR3kKyg3Yu9M
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-QQ-RECHKSPAM: 0

kvcalloc with the __GFP_NOFAIL flag will never return NULL, so the
subsequent NULL checks are unreachable dead code. Remove them.

Signed-off-by: Gou Hao <gouhao@uniontech.com>
---
 lib/test_hmm.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 9c59d1ceb5b5..d615e4e5fc44 100644
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

