Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FC624A05D;
	Fri, 24 Jul 2026 02:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.194.254.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784860174; cv=none; b=FYaoAQG7Ln8tvljW7nUtbNwP+CG0IG7/tczGqN6NaGoZXP127sedVPhY8jj98GqCLoXzTjMHR3JG/6qTGYraYhdnuytvEyoCCM7EjSjZWLphd+sh8BPMOvmQ4F6CDgJ8RaRTELT5rw979VsL98E9bl+zY1wMbrc/FfNo5k1Dxds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784860174; c=relaxed/simple;
	bh=JT1pzcfQVM886uEGqMmj+hWRUWDWJTINjKd9EvxpzuY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=u8NVjNke89nqaUwA/a3lXVwFOnSqSytO9K7a03n1hJZawCFhiCrucdpstXyC1FYS6uPpzUdA66spPUkRNagFlb0jDEjcmJYaI50i70OUWI5M2jeT4o0+yjbtjhmfu4KrmoaxaJk6nprwpN3hJ/8h+vmHDCJwTJqD3ZztjoPO+wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=UKkOeSMj; arc=none smtp.client-ip=18.194.254.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="UKkOeSMj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784860167;
	bh=+ZvTI/fcAWs1dkQ4W9g4AT4WdA/up4PGQNqGKnn0rhc=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=UKkOeSMjc/734Eg4FD29Vaa0QPupow1mcYAPMdU0RYAmKUYyK2ylcBhHHNUhjlepu
	 mbxexVLc6DivY6nkDL6kc4X7wFL00xjZPf6n3cB+tp/B+WdfoksWWTL+anW4tXF7sd
	 WNkTTSCQWJF6KAo1LyQDU0SYez1fEa0bJoYSRBSw=
X-QQ-mid: zesmtpip4t1784860156t81fb8ef9
X-QQ-Originating-IP: uU8Dw1tobLbkmKcfvIpWRxgng5wGRpu3yzVVioqlHrE=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 24 Jul 2026 10:29:13 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 1489989829865237816
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
Subject: [PATCH v2 4/6] drm: remove dead WARN_ON NULL check after GFP_NOFAIL allocation
Date: Fri, 24 Jul 2026 10:28:49 +0800
Message-Id: <20260724022851.466017-5-gouhao@uniontech.com>
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
X-QQ-XMAILINFO: N0jQ/i/W/QNTxc/RtOd6E5z5X8iG4Xi7MqQlPDvw0XsBDLmShpd7mycT
	Xpv6qVp+4ijm3fmIl71zFj+aIYwRCnNJQyyR5AooAftoCKB3PrQqiqrnwEI3b13BwWo8v46
	i5VM6TOAep3cS1JT2Q1V11/cn42F8ZHkI4LCGpDObLaDi5pbOPmuFWTXJYDbAXqj1UnRZ9m
	pQhBOSq5LG3xhpmajaz6Ru4IyWqwNpMMi1KnzmxUBsZqbG8VNuhQAQV9b7M0i5NwGAsMCTB
	LYbaQrKuF1bVNDm63EaYvf7RN6e/OrJCwU0GfaQB3ROHS1S+uIQRcEv7zHK9hkH/0r0ciAz
	pm+kxbAmHhbOduLSCV5btEfD6BXlWLQxwrhiVNvGkGpBkzV+Fm0Vmgdhj2BY/5nQDSyU1gn
	WFcDvPe0tQh0FLZpHnuPtuOyhXDNdAF3lxnsh49+wB+20Ht5Gb+S5pJqqKoBCy5NhIe2u0h
	uGYJW2JMlvjI6VR4TEYBv6NwiyOzUDkFvasbIbxElR4Yn4T1hZEYt54uC2d58tjhFkJuhdB
	DftLyvprBOSKpAFqeRVIktYQHqr2vBYyyLm5HIk1d0CnWLTD1tBK/Bnqcfoym5McJeCm96u
	r/zotQyMwj/qrNDgyBDbGNRchpmOP1/KqJ6hvTnlGZtwHyIvtM6yib4/NRhSl403w71YbES
	pVjPpHMHiGAznigrLN0CfuIzHYgFs1IMlj3yHNN0HrUfRpgRuGgFug/Hc1tUv+PNNF2Q/6P
	hw2qkgvXXdkFApwk5wu/kjStmP9YkudYxY11bVpoP4aDckRgvVFohZCohUjLJ1uYyqVgr0U
	5Nn7h8EV+merpEbwqCd85yj4lTpl3k8jMgwCS4W6qtAPy0uaZMHPrSS1NyahcNCFs10ECbb
	TM+TSjQs5njAmxd1D678fdsOQZy3dyBjD/NhrV/AB4zC4xBO5TyeFUdFq+EyRWuMiXdJeg5
	jrrvuj7PcUYnIqSidc8Krylg8R5xZyCqb8Cs6fts44nLSQ2cMstY6G2YIQwR8kEgNfrIrzj
	nQP+j3uMRkDGQ3wdBji7nGcCcINOlYyIihPFePqMOVNMZGWEvX
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
X-QQ-RECHKSPAM: 0

kzalloc_obj with the __GFP_NOFAIL flag will never return NULL, so the
subsequent WARN_ON(!ctx) is unreachable dead code. Remove it.

Signed-off-by: Gou Hao <gouhao@uniontech.com>
---
 drivers/gpu/drm/drm_modeset_lock.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_modeset_lock.c b/drivers/gpu/drm/drm_modeset_lock.c
index 2c806b0146d67..e14814c30d8c0 100644
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

