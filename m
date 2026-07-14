Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F82F368282
	for <linux-rdma@vger.kernel.org>; Tue, 14 Jul 2026 02:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783997087; cv=none; b=Mz3iexYxKc+hXI3+ryq0HaVx34+oUqHxff/mnhLfBF84Y6Rc8wZRn0Kvpq5aG/A3BHewn3ZnxXPgvGk9z7Q3ndlDvHbKUZ7hx0al0PV57CcDZbRmzsDQEbDDwYEWOUvQHZoMml5G+bYKmRXNxGtA/gHZT88Ec1YeUNGliLb26n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783997087; c=relaxed/simple;
	bh=VisbiVMpytM6fGS/+ibRnX0B0HTkMqnfVaB79KLUFEY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iDLE/X8QRvP/V2gqt67WOAEYFN2yxZ7sbDJuoNKmgE8AR+mZSBqxCy3+mxtEfEuIVUQb7Ha9Qmvde3ZKEVqxv6CqDRBPkVz7OAuxBk5euUt/vpTrS/HWo3nQPnA5evSYchAecbF3aQpnoGpJ0uYHn7vdto7nzrMIR61d5iQAHY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=UWpDE3wT; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="UWpDE3wT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=26
	/LL+5TjfW2v69y+/ZGXFOz5DhCHMWe7VfC3zGnLbw=; b=UWpDE3wTqpiLDyVot1
	aA/I9NyMrvcs4wTSBKvK1D7vmpMuF7/SRbDrMZT8RCFg/wFsfHD0AnzH4F6wRh12
	sEfMNZNIP4aU1ZVlDAM7/b6RUCkLdG1xkdnXYmd/kyowsZoRFWrheghVp+xS4PfG
	vhBiV/kuEKUykhNvisgdhpgW8=
Received: from xwm-TianYi510Pro-14IMB.. (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgCXBRWHolVq_paBHA--.8849S2;
	Tue, 14 Jul 2026 10:44:23 +0800 (CST)
From: weimin xiong <15927021679@163.com>
To: linux-rdma@vger.kernel.org
Cc: jgg@ziepe.ca,
	leon@kernel.org,
	xiongweimin <xiongweimin@kylinos.cn>
Subject: [PATCH] RDMA/cma: fix spelling of guarantees in comment
Date: Tue, 14 Jul 2026 10:44:23 +0800
Message-ID: <20260714024423.188238-1-15927021679@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgCXBRWHolVq_paBHA--.8849S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7JF4kJF1DZw1kKry7GFWxWFg_yoWDWFc_W3
	WFqrn7Grn5CFnavF1j9Fs3uFyY9ay09r15u392q3y7Xry3tF98W34Iyws8uw17Jr4jkasx
	Arsxtr1xAF48GjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU1GQ6tUUUUU==
X-CM-SenderInfo: jprvmjixqsilmxzbiqqrwthudrp/xtbC9Ai6Q2pVoojNFAAA3J

From: xiongweimin <xiongweimin@kylinos.cn>

Correct "guarentees" to "guarantees" when describing handler teardown.

Signed-off-by: xiongweimin <xiongweimin@kylinos.cn>
---
 drivers/infiniband/core/cma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index e88d3efb9..cc24fddf9 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2104,7 +2104,7 @@ static void destroy_id_handler_unlock(struct rdma_id_private *id_priv)
 	/*
 	 * Setting the state to destroyed under the handler mutex provides a
 	 * fence against calling handler callbacks. If this is invoked due to
-	 * the failure of a handler callback then it guarentees that no future
+	 * the failure of a handler callback then it guarantees that no future
 	 * handlers will be called.
 	 */
 	lockdep_assert_held(&id_priv->handler_mutex);
-- 
2.43.0


No virus found
		Checked by Hillstone Network AntiVirus

