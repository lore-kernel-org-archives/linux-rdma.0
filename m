Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F9C3D9549;
	Thu, 23 Jul 2026 08:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.19.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784794742; cv=none; b=J8D1FG+EGi07d8jI1e+8vVhFvjO/vxh7iI12/Da9+SMHiV7Ly423V8NU2ePOTAzx2AfWAcHdO1gPKIsF6t9fL7gFcBCcxA7bh5dabyz2EKqRnDmxxvXR6yjewJ+n74RbbPLRXt6k44eJHoJWbKJsPX9IUYua5mulWLXXPI2T3jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784794742; c=relaxed/simple;
	bh=j7UuLT+m7lpVoUqvgF/KMPKiiHkbxvDKoqM02SnmvoY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YlGoyya4B6edYaNWTFj/IVnfEdq8N5WXCCgYC+4tSnfdSlMJbztJvYouKA4mXLP0Lg2RwoWKq57Jphm2jpyAS5oqIL2jWIwBUOf2R//iMbJZUG7QdOOwMkpKapd6/WvUGzV86y4ldjtakVXAFclmaaPmLhaijyuapQ5Q3SuJAZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=nNp/NEZR; arc=none smtp.client-ip=54.207.19.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="nNp/NEZR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784794715;
	bh=e6BVBwF2oSnNk0Jyon9PloP7eEkl7Bfr8eX/NbegyP0=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=nNp/NEZR5X6ncggg7nm9VMO3WY4vnp6IHAKka+R38b0YDRH6Lo+vOT3kK21P97X4q
	 TxkJt1T0jKc4xlZOtLu6NmUxObq0IWDqu0MsyS2tYAgKm4nbdTIaXIHsd+wCzPSzL0
	 5o3HC+ItoosD1nSXTXKx3toVhdjXWruDg/YKsbis=
X-QQ-mid: zesmtpip2t1784794697t42615382
X-QQ-Originating-IP: NWrmr4ibVq33NqKXMPStiRl7JDz4LdgCYIBewkjnVFM=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 23 Jul 2026 16:18:14 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 6575503778562141203
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
Subject: [PATCH 0/4] remove dead NULL checks after GFP_NOFAIL allocations
Date: Thu, 23 Jul 2026 16:18:09 +0800
Message-Id: <20260723081813.176792-1-gouhao@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: OKKvvo6f47/bsGdbbQ7qCRULADpehEr1yFBaub/83asEEjSmFYR6WX5v
	DAe30LUE/0HUXwZ5qsxgIg5UmnNnI7DmWsBAYagsuP/P2+zzrB9VfLTbtBjkcAhwScVWyDo
	spyEhWE7fEl87JAh9t2JOj1z7SwPhUMCI/g8jfqsqx1zwqtKm7z3xalbI2e8yFABwNqL/Ku
	NzKHp4fpQoeG+MF7ty42/md+WPJp64Q1H+CAS1HT+0fBhfG1vPmJmOwU0EC8HoXlNloX84I
	0EWVkETIZ20F4d4E1/veZDDWfxAiOVYrmyI0K20XNXTKZmDGvkD9oRaLdzXlwnCOqGB1CnA
	rpfRoV729rPpGbX7N5mUtsUpYHNP+d8AXmc+NeAv3ivgBGHpbx6DSTDdlPjBok27vvzFuE/
	+fNdB/r75YVY79ExbWGutqfaiwaSFT82GcqGhOhQDZC1dhHBLzDg842wd6PViqaVgMEprq1
	xc1II7QeM2NnH4ykt1gxiLG/2jGhqg5N1zkK1SN1qGQcIa4PbZUloPX3danccVH6KjOk8cZ
	S25gUs5+pWem5EeOkpzcaPdutdNO+1jCYqhr1jqdVckD9e3TJsTgTa6MKz5bT9KI7N4vuQo
	H/qlD2gchkN2dwFgBzmbaRsmMVrzncF+8Mk4d/v0eP9TC+Vj31qNcXLxNQnAXbn41gSdtM3
	AwvZTRKRtVFNuZHjX8HRNTPEGHcktc/57RuaOQ9GwGEGQy5K+gMtjBsnxxsdtdf8w6pxezM
	8LEvzA7oBqUipA+eOVsY0slq1WTsTmRK78NO3EbS6b9uG/zcjLNK3hHymLhGT8xT6UudJku
	vh/i7GsRaE56oz5ayhJpuvfln8hKgIjxEUoVn3BBK/o4gG+Q42kzvcSN3ZIAiMb7A7C8J1s
	74gKFBrJCszIY3klXY7Dd7cjwxFNsPEkOB8sr+3amRIm/PkwkekoIQeE4VRZcybx2jSGo38
	MQaNop1EFK7d+TW7WPtevwVET0Un19TCQQrUhgf3OKFhNMetuyT1rKgWbqkQT1BQ8o3eOvf
	z9IyEgpPOl4JFt0vyB
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
X-QQ-RECHKSPAM: 0

This is a code cleanup series that removes unreachable
NULL checks (and associated error handling) that follow allocations
using __GFP_NOFAIL, which guarantees non-NULL return.

Gou Hao (4):
  powerpc/xive: remove dead NULL check after GFP_NOFAIL allocation
  drm: remove dead WARN_ON NULL check after GFP_NOFAIL allocation
  lib/test_hmm: remove dead NULL checks after GFP_NOFAIL allocations
  RDMA/cxgb4: remove dead NULL checks after GFP_NOFAIL allocations

 arch/powerpc/sysdev/xive/common.c  |  3 ---
 drivers/gpu/drm/drm_modeset_lock.c |  4 ----
 drivers/infiniband/hw/cxgb4/mem.c  | 10 ++--------
 lib/test_hmm.c                     |  6 ------
 4 files changed, 2 insertions(+), 21 deletions(-)

-- 
2.20.1

