Received: from smtp.smtpout.orange.fr (smtp-78.smtpout.orange.fr [80.12.242.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45742877C3;
	Sun, 19 Jul 2026 21:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784495812; cv=none; b=R429LUG2sTjULvUsqIaBs8R3ZYZPSJHAd6ZeKy+yvEIhuqLLvDC6PkERSzcFU2OO8IVv0URbMZqeGQQYttCvVXBG+2NowVu1T6RA63P8ooPB6tXV2qOJpLdDBqiShAVsu6B8E6klucFq2VfHcLb5A0EGZEnZHQ/dnODDaWlBs0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784495812; c=relaxed/simple;
	bh=YferrjMMlu46uylPLbH6mc5prL+bWea549FJeGtC4M8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=htLWC6qWrRWwYfu9JKtVbqO2+ruoaiEFWmhbN8S6T/NkjTpL4Tn88VgmC4hqhgkxUkra/EoNkbXWwtdeLMgRcIiCjcyNq0+8bsQqcqp1Vv9tFGuh8TmLAFm5DS+hpuJRmfxCCKpBVY4SdMfAQtzK9HSmmscqBRuOmTulmmxTd3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=U27PjtIq; arc=none smtp.client-ip=80.12.242.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="U27PjtIq"
Received: from device-101.home ([IPv6:2a01:cb10:785:b00:6128:9b8c:c203:905])
	by smtp.orange.fr with ESMTPSA
	id lYsKw9zNM0fLilYsKwZzWG; Sun, 19 Jul 2026 23:16:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1784495801;
	bh=lrSeE3LoG1AjaSglnDSROQCnQYQUOlZgkdyPCgBE454=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=U27PjtIqYpB1CgJWxVnzL00QRGoqs+1SunJUU0A4p9LHYWh3cFE30qgbnCndsrsL1
	 g/qZm7qxqGYIe1w4fOrbMKCWVAroeYwC/caia8lFjFR62qpkdanWUwnqSo83LwB61j
	 pI9mkk1jfG26WypkqvSQZWJVtsHZvaIL4CvToxoR67bqaTL0Zr3qxqCE9IqGiMYS43
	 /QsWCpkmaYeN2YKl/AL8tFub3XQF3swpZ74IycxymYJJjoz08KKRE9dlA4YjO0KQhr
	 jezznE9Ms44dOKCVficr3JPlP7CwFBCsz9Fszx6tjUZj6KdSSf78aRGHLc6pwXSfTK
	 8RVrhabjl5PqA==
X-ME-Helo: device-101.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 19 Jul 2026 23:16:41 +0200
X-ME-IP: 2a01:cb10:785:b00:6128:9b8c:c203:905
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-rdma@vger.kernel.org
Subject: [PATCH] RDMA/umem: Fix the ib_umem_dmabuf_get() prototype
Date: Sun, 19 Jul 2026 23:16:17 +0200
Message-ID: <f450b272eff7c0f0d3c1a5f08d27ebc042704f76.1784495762.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If CONFIG_INFINIBAND_USER_MEM is not defined, then the last parameter of
ib_umem_dmabuf_get() is missing a const qualifier in order to match its
prototype.

This is an issue since commit dcae56cfecc6 ("RDMA/mlx5: Constify struct
ib_frmr_pool_ops and dma_buf_attach_ops") because now a "const struct
dma_buf_attach_ops *o" can really be passed to the function.

Fixes: dcae56cfecc6 ("RDMA/mlx5: Constify struct ib_frmr_pool_ops and dma_buf_attach_ops")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 include/rdma/ib_umem.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index 31b3a86fe73a..1fe87fd1d769 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -250,7 +250,7 @@ struct ib_umem_dmabuf *ib_umem_dmabuf_get(struct ib_device *device,
 					  unsigned long offset,
 					  size_t size, int fd,
 					  int access,
-					  struct dma_buf_attach_ops *ops)
+					  const struct dma_buf_attach_ops *ops)
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }
-- 
2.55.0

