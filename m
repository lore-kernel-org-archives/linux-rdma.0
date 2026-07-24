Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9CF2E7365;
	Fri, 24 Jul 2026 02:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784860160; cv=none; b=hsEulwG8h1ABfbpHkygG/WpPjBIJ3Oay4Q+FsHHmsl4+MxECSErWJkcg+yB4KWzz3U8ev58MBdiKvvk1775td4ZUwbkRSx5A85ubFwIfQioG0xp3oUalFtALIOnSP7FQHy7ui4Cqf6SNOJUkvxT8D+lsoYPS7ezdWbE2Ijl2tbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784860160; c=relaxed/simple;
	bh=ivpLlw7HYbov7fvBvirRCkJ2FYbIU2myJ54Nz/Y2iKo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=F6HcB43w2wQk3evFYdYr/PZIlFHwwBzp6r6y2rfTzjpYDrl5+nY7MICi9oiCiR8pYbLyEG9E9xFsDjcWGd9l9d33PobiZ+5n/7PgA9Kzbes/KQy6HFnPzXK2kYz1sTU001amgZpPOolBTQ2fZwI/gXAHr/n71ga1a0hjkl/tZ8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=CxzBdgea; arc=none smtp.client-ip=54.254.200.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="CxzBdgea"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784860142;
	bh=COw6l4tZGKI2EtZCsRNwhO9S4qZRY68UndjXev8R1FQ=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=CxzBdgeaIW6FbkCf1QuWJCZSzv2a//grT9wGIQ+LXIeku71jFflzg/hXhRSnhy/rd
	 tbRUi+A2ZgXms4p2iivaBqOcnBydoT47Ax9QyMjp6Mm2WD1NBXxXkztHQFJn0f0I5+
	 iNgovUMNIC8e1YT1b8IoVti3uEhBcB24ABMlQVWc=
X-QQ-mid: zesmtpip4t1784860135t56239e5a
X-QQ-Originating-IP: uxNb/JIeTaYaqS/plW1kaXfiKOf+TwmtfXaiPsha900=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 24 Jul 2026 10:28:51 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 5628155496822218120
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
Subject: [PATCH v2 0/6] remove dead NULL checks after GFP_NOFAIL allocations and fix xive use-after-free
Date: Fri, 24 Jul 2026 10:28:45 +0800
Message-Id: <20260724022851.466017-1-gouhao@uniontech.com>
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
X-QQ-XMAILINFO: MnWNx+I81Iu2Fz6e9ISujN5P/UrODP192vFbMUOpNCYFwp4Jy7lPAjz1
	FQ4LPpG1v5v+ebYQNz8a0/f9Kvg+LkcwjPBLU2/vJhrGpJJh+MQ5TJ/Z+/C/aKvsuC446i1
	g4DKKrckjJBJWKCGw7z+Yj9HBXpGQjzZeeNCZnAYnu57I1lYLujYy/DO4VDakXkUi3oytrc
	5uBqzRS32TJhnGkjtKjKRReDUxPWIReDlc7I+s0z0k7VFmJt3JwAt93O50T11p6IchYyu4U
	pmseWu/dMeQCL7n4lD7rsn7NWx1X94DvRBPurUJdwdFDt/N91cX+YjK6nK1Wfe/uSAJuKpg
	ETjkUJDHVTs62y4/vRYyMilIEvRgU6wGFjXY0kk3MXrlHl2CcWKGw/6LcI+56n2lBNksQvW
	d/Av2xJWJMPyFsX0/1NRCO9xsKr1ROUUtbyb9NLVr+qrYue2s98xgmhzsRYza7W1CmWbxn5
	nNg2c6gWwNuNW4EN0Qld6Q+EtmzdgU8m8qCoGh27x2uHxpIIfkq06tM3ZOo0TfsWqpFm7Kb
	fyQ7O25c62/Av4ghd5HkPa3UiaLDbq5YiJ37cW6sca9ETxfLMfXLcGFu/tuMFhaYDMeCWhS
	F+AV6xK668Bij/ThkY4TE6VS6KpATeO3Yjg9KeIkbHpIPQzaG9/i0o7PHjGjwHxAXZDHE3G
	hXDdY244jDfRxOxqe/HGk/5urXges5xV3IJ+mQZBu2kSQXBugaeiiHLOk+oFVtmwXXPdTzg
	Np30wImdiz6tg2hg5MpU+Skr37NjEkZcUIcxaxtVp0V7aycyODdbBpwqNDZsWMKxn+82FPy
	g//kgb0OgzLbAy7iX9B7k7taVmtoxDmrsEx+Q5shFQbLMrHGfll1NpxIA8c7fE+cuHnAlL0
	/iQhORbsV+K0+ofEol+avk/XFKfurD96l/aR6a0n6bhQc/9XE723wVTGAOuZ6m8pmBEHzAu
	9eyYqYMlQSp/jQ98v8/WM+7aewP4n+/YyCxYpoVtY/sk53NhHnu67NwdoIDmtmSsc2zeWQS
	vgEJXOTwbS4F06MlnpqsrUa3e9ONJwFhMZ0MHd0Q==
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-QQ-RECHKSPAM: 0

Changes in v2:
- Remove the now-unused out_free_domain error label in the xive
  patch after deleting the unreachable NULL check goto.
- Fix a use-after-free of xive_ipis: when xive_init_ipis() fails,
  the error path frees xive_ipis but xive_smp_probe() ignores the
  error and proceeds to dereference it in xive_setup_cpu_ipi().
  Propagate the error return through xive_smp_probe() and check
  it in both pnv_smp_probe() and pSeries_smp_probe().

This is a code cleanup series that removes unreachable
NULL checks (and associated error handling) that follow allocations
using __GFP_NOFAIL, which guarantees non-NULL return.

Gou Hao (6):
  powerpc/xive: remove dead NULL check after GFP_NOFAIL allocation
  powerpc/xive: add error return value to xive_smp_probe()
  powerpc/xive: fix use-after-free of xive_ipis
  drm: remove dead WARN_ON NULL check after GFP_NOFAIL allocation
  lib/test_hmm: remove dead NULL checks after GFP_NOFAIL allocations
  RDMA/cxgb4: remove dead NULL checks after GFP_NOFAIL allocations

 arch/powerpc/include/asm/xive.h      |  4 ++--
 arch/powerpc/platforms/powernv/smp.c |  8 +++++---
 arch/powerpc/platforms/pseries/smp.c |  8 +++++---
 arch/powerpc/sysdev/xive/common.c    | 15 +++++++++------
 drivers/gpu/drm/drm_modeset_lock.c   |  4 ----
 drivers/infiniband/hw/cxgb4/mem.c    | 10 ++--------
 lib/test_hmm.c                       |  6 ------
 7 files changed, 23 insertions(+), 32 deletions(-)

-- 
2.20.1

