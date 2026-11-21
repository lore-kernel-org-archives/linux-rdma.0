Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795255178;
	b=NxF5lVQV7e9QYiOVJLqK8aDfcUUbtzqtwDONQ1OqhivFAn/lHGKNyOqXq58WPHvGsyDy
	 tVHigXF58KAMGsfoERHI8VQ6iCwTWONRS66pC+NmFDOjn8ZOPZZfKdjlAW069VSVV2ZCh
	 xWSWyV1kX6uHXGz2S5uxcbwjrIRfSqxn1l6B263ji/0CCtSLS1RbJMbaE0elGJvuK6iPJ
	 6C5f9uVmnw1RhPRApMQo8AQwukW11t2paDY6hFwl9LWRvlmb6b43UAfOxIYlMtellKGWQ
	 lTQWmVT/hgYKBaqKEY+QBo+/2MSrnaQ9mYZTLW5bKnSnPZel3G+0we1czoW+3iyi4eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795255178;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=gCvZo/0sDZOipYo+1oQX2isowKSyfEi5pEhuRbqcGDs=;
	b=0qwOhjEQJJ4f1tCtHkzqTd9k3kgPoz2Ep8ELbIKorGKizOCPmPIV2NfD20Z/zN47DvHH
	 CwRx46ziX8u2zMHn0sbZSzhSQCVqQpVxFMwV3tLHQvDQUhCYi79q8LpWPRC7QXK8YwLdE
	 fSHKx1P92VdsNJSY1+8YudjIYLg/1WDQ4fiDMGMMLVofaWWZSYZpcwfzXxh1aehwx7gwM
	 2evC2mL0pc5fmWHSiu/gquApiWtQf1XjCvAyPbMt9mTn6nDL/vQkY62mYHGpru0Jhh9io
	 eJGLkO346FaMUc3f6qOC6KKWmNkqR1e+FA/Rprnv/d1yHJEhS6k+EM5SX51785NdFZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=n9YpHunu;
	arc=none smtp.remote-ip=117.135.210.4
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF905606A320
	for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 09:59:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF905606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=n9YpHunu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=gC
	vZo/0sDZOipYo+1oQX2isowKSyfEi5pEhuRbqcGDs=; b=n9YpHunu8nBic8yMVn
	z+OU/IIp0ljD3cpfIj9s60rqPNanErLS9C9j7lcxvW+83vCTmiPPh0b+YjdtfLYN
	3RIN+y+8MFowOCbk1LfgSt+H+uUqRP6MPHZ7qW0gfXel5ORMztHShCrqz9O00r57
	8OkucogM1+OhyV9SZLlb/O0kc=
Received: from localhost.localdomain (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgBn8YdtawFrUgkfHQ--.5873S2;
	Sat, 21 Nov 2026 17:59:11 +0800 (CST)
From: Wanhui Fu <fuwh1120@163.com>
To: leon@kernel.org,
	jgg@ziepe.ca,
	haggaie@mellanox.com,
	dledford@redhat.com
Cc: linux-rdma@vger.kernel.org,
	Wanhui Fu <fuwh1120@163.com>
Subject: [PATCH] IB/mlx5: Fix a potential memory leak in setup_qp()
Date: Sat, 21 Nov 2026 17:59:02 +0800
Message-Id: <20261121095902.442960-1-fuwh1120@163.com>
X-Mailer: git-send-email 2.25.1
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgBn8YdtawFrUgkfHQ--.5873S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7XFyUKry3AF1fWFWrur4kJFb_yoW3Krb_WF
	48trn7Z398AF1Skr13C34a9Fy0krWjga1xWa9Iq343A3sxAFW5A392qrn5Zw47Xry8Ja43
	AryDC348JFWrWjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUU_Ma3UUUUU==
X-CM-SenderInfo: xixzxiqrsqqiywtou0bp/xtbC7g8RsGsBa29pfwAA34

create_gsi_ud_qp() creates a QP but the QP is not
released if modify_to_rts() fails. Free the QP by
calling ib_destroy_qp().

Fixes: ebab41cff4db ("IB/mlx5: Create multiple transmission GSI QPs")
Signed-off-by: Wanhui Fu <fuwh1120@163.com>
---
 drivers/infiniband/hw/mlx5/gsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/gsi.c b/drivers/infiniband/hw/mlx5/gsi.c
index b2e2a219639d..535a9f45fb33 100644
--- a/drivers/infiniband/hw/mlx5/gsi.c
+++ b/drivers/infiniband/hw/mlx5/gsi.c
@@ -316,7 +316,7 @@ static void setup_qp(struct mlx5_ib_gsi_qp *gsi, u16 qp_index)
 	return;
 
 err_destroy_qp:
-	WARN_ON_ONCE(qp);
+	WARN_ON_ONCE(ib_destroy_qp(qp));
 }
 
 int mlx5_ib_gsi_modify_qp(struct ib_qp *qp, struct ib_qp_attr *attr,
-- 
2.25.1

