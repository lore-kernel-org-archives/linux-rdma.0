Received: from smtp-usa1.onexmail.com (smtp-usa1.onexmail.com [52.205.10.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C7C35A3A4;
	Thu, 23 Jul 2026 08:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.205.10.60
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784794756; cv=none; b=hnx1UhCyQWLGsC5YFRJrtdMllnxLBglIo8U0d9bb/ldDWKbwmpxuqJNuFGR2EhkXHnsYkGDTNRMOStYF7rM7uBGgrvDsZx+0T0OYktFTpm7Z94gU+CtC+8yEGAmo1SAhzehrE2mAKmh2/vywu27uMdjG3O7o+AqNJDbLOwxX5Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784794756; c=relaxed/simple;
	bh=TobCvPf8XVkqctyJcCyzyti1Cqr1lyi63U5eX/CTM/E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q3NKwghz0GGbiJ4bo8llDo3xLzZ3Dk0Oe4S+QYhmAbEt29YwCylOo8N0zMgcu32P03HgCN1qgokNqX/Vmh1KdvO+3r+kx1/Ah1SpKE5lG+lXczOc3nOTxUVmnN2oiDCUMPkiCHaaEsowCIhGjvD6gQ1rzxL8H6nT/qgKpYri0R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=pPppjcNS; arc=none smtp.client-ip=52.205.10.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="pPppjcNS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784794720;
	bh=zyZoSgcSvPZa4Lztf92xnmwggXjnsZ8IVuTRvt3SQnI=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=pPppjcNSYvB5y80tohd8mEyZtiSOBZk5n1GSctM1vNoKi2OYFD1fQsi4VfMQ0KCBH
	 sP1RvN3//ac3sdWogNObeTEyhCCuWNAYJphtyezXTJdoVc9wZJWXnbh4H1aRc+9qPV
	 k8iZl3iBMFb4VeperViDTgYnief5OM6FBAwrz/CM=
X-QQ-mid: zesmtpip2t1784794708t1baceda8
X-QQ-Originating-IP: p0+WvO88PZWVCksv0PxY0bE07sYlxrtU4deG1JLaxR0=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 23 Jul 2026 16:18:25 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 8067794102828428792
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
Subject: [PATCH 2/4] drm: remove dead WARN_ON NULL check after GFP_NOFAIL allocation
Date: Thu, 23 Jul 2026 16:18:11 +0800
Message-Id: <20260723081813.176792-3-gouhao@uniontech.com>
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
X-QQ-XMAILINFO: MmpliBmRb3iC13xU5PAjuxpB7P4eH1mJRWxLd8qJ4fcdCKaY0os0jtpQ
	zzscv8ZDaIPlrLVN712BBimZ0dhJx4jgtDohAKWGi/PdTDOmshRcXmay6UYMNPIjZu/A149
	CJEbHxDgYtxcVORW69NaRKWBkDsDmL4S8l1yd/lu4Gq0aAdiAcuqYmTL4q3zTHZZSJZxTSV
	yrrs6oo5AyDTHMTJJBsme0/Ii0CotI3VSem2/cTF/0mKvEutu42T5m5cJKtvM+uIIe6BIMo
	+xx/5sIpNK0d4DO+e/BLK4ELWQ/drdqfq6C1qRfT5Mva97rwnCyH7UxhoUJDSiYEHytYdSc
	zNDt2zbOin9Ws4yrW94GWxO6u8G+g+7VQNz5OTpf3HWRqSg9fE0bmAAB3KYlrJSt9y3NabS
	Td3VqyAupEiws1oUqFhirjiSfNo3DsAZGCK7MoetANqsvSgdoFVfOv3gIu85CvaE6Ghn9aK
	k9UOaWi37Jyu//coqmMofLyIOmCE+YIo5vC80qi2YRKwRaixfEyf3dytycJk3DaSPdJfJQB
	3YS9wA/BomcYoc7K+M+F9zT88BkTlm9ILC+60ODlt7upzL98Z8PGWp+fCx1JMIa7SmASprf
	YKmodWq4tVEfzVL/RhHk5GM/65yvwCq9wOhwX+qrR6znLeeupzG9RyrXiQXUdfRW/J+rX51
	XX2MPe/i6+bLWcoU4s20+JUETjG+Z+2ZSl8QsU0/HfTv650j8SUMyCmaQXFGuIUSVLvUjZT
	a19Fa/r2Rg+dx1MnX7SeDcNd/VopvKYSfDku2MLgy4S8fKIhCBraX01B/IujLgFd+ekisFf
	e7z90B61lUu8Kxne31uJL8ta341PDm+bqWUcq0u+ZKrqCNuvUbRd4fDkzJq9NJV8RofFCVA
	cHi86IIF4JlkPxVuEc9uMQXbljUQIwIA4zirL8qem8NoEQ+LVtr2atEeohOPnogD4gFtVHG
	P+8JzqUwAiBsCF6UJiFUehQM4u+B6pDe4O+QEeZTx09cv9D9n9WXsnW6HhcB0WQ2ThaauFf
	rE153uVZ9drKP1SAvLdlqkjmKdsYu2NXC4lhM8z0FTcWSWhDXHcaPry3OchEbGdXBXuo7Ml
	A==
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
X-QQ-RECHKSPAM: 0

kzalloc_obj with the __GFP_NOFAIL flag will never return NULL, so the
subsequent WARN_ON(!ctx) is unreachable dead code. Remove it.

Signed-off-by: Gou Hao <gouhao@uniontech.com>
---
 drivers/gpu/drm/drm_modeset_lock.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_modeset_lock.c b/drivers/gpu/drm/drm_modeset_lock.c
index 2c806b0146d6..e14814c30d8c 100644
--- a/drivers/gpu/drm/drm_modeset_lock.c
+++ b/drivers/gpu/drm/drm_modeset_lock.c
@@ -149,11 +149,7 @@ void drm_modeset_lock_all(struct drm_device *dev)
 	int ret;
 
 	ctx = kzalloc_obj(*ctx, GFP_KERNEL | __GFP_NOFAIL);
-	if (WARN_ON(!ctx))
-		return;
-
 	mutex_lock(&config->mutex);
-
 	drm_modeset_acquire_init(ctx, 0);
 
 retry:
-- 
2.20.1

