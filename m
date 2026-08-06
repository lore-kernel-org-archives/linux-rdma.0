Received: from mail-wr2-f0.google.com (mail-wr2-f0.google.com [74.125.225.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41638494823
	for <linux-rdma@vger.kernel.org>; Thu,  6 Aug 2026 20:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786047283; cv=none; b=JEduZDXOMnbUUgzNTaNMddW0jvk2EqO/R0QR71GvEgcULauvil+8ELjK5FmE+02LAb33Fiz8IgnocjaVUjxGPvVXf/ZeQv2vxs+uPcMFdWpnNhHipSZmvj3diWffIOY1SDuunl2GqxEBS25BDK5De/7bKO6pYRHhJldwnXcpryo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786047283; c=relaxed/simple;
	bh=o2btizAO+Ks/0UvqaH7GZKydxvAy1OgOWVYRpiO6bo0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nTRWeGH548pCLjinAUIgzRqqfw92Objh4Fd1m6X/SguGBGHvFkauENUvgjVLvD10u4ArTIIFHrGLVCCoKLFuYYQfskjQlGe5rOkNijMq3RsgjCv5xf4JtsvPFnGowyQIiMTF5XuLKGTVWG3wYtt6dLrpq7NPif4sNnaUj14vVnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i7UQ7gm1; arc=none smtp.client-ip=74.125.225.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i7UQ7gm1"
Received: by mail-wr2-f0.google.com with SMTP id ffacd0b85a97d-4784b41f3aeso624582f8f.1
        for <linux-rdma@vger.kernel.org>; Thu, 06 Aug 2026 13:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786047269; x=1786652069; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KptR6YR3bhzGgXjfr9mIisFou0Y2tXrBhy7YKqZAMeo=;
        b=i7UQ7gm1y43GxtfulJeQUPvx85Q+lFILxtnFI6x0DuMPKcB54Lasc3CcfX9Jyd97ps
         FyjOxHPgwLQhhuwpu10/9qHGmae6xH3T/2I6N8MCKXFqUvfrrOgMK+y291db/dWGonCB
         qo9cBU13FQHBi9PmEfA2dfhfZi7gudOtQ62wWESj1K1rcin0SERmdL8I+lkmQ+EgGvjU
         mH3H2yJDzMPXYbvrHJNcRq0ssqaQpA+fI5Lp0Zf6ZRldoG/O9xp/EEvMNMJADtqVVDOo
         daVAf6BZLreQ2+cz/eymLvnSi20pNoNNx6ICe3I/J2ZDGF80DwB22LW+sLAcdyKWB0+h
         xzmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786047269; x=1786652069;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KptR6YR3bhzGgXjfr9mIisFou0Y2tXrBhy7YKqZAMeo=;
        b=fOUz+q5QXpsc738Is3AWL0e+Qr1lEIH3gbi8ZgTZ5I7iy8vKSTmAr6mcimOASyHRPB
         NWq5SNPSfpOC9nSXbefx/ElxvJ6W2+2UMYPlMC2OV2X+QkKMzO/llQEmkGITjOByEla2
         5JL5tEbK60L7MsNdsFJv0uMPYFffZ5fZZlhiQGmDQOSftRt02Is6/uBbm8sQKT5VrhEZ
         VjC9SE2DSnjzgNFoMEAT7IIz0R68vBn4o0kKKfxFK8Sd57m1df7VTbkcrilVYNyT3+Zo
         uqR2D85nbwR/1JIovFz5TKzjNkqgmhqe6Di1BEz5Uy3Hnu/gZRvIyJ4KkRbg+slqXiP8
         PLKA==
X-Forwarded-Encrypted: i=1; AHgh+RoPNg8DLWOFO9zaWxy/8abgA74elGP1gCUNqk4saDpcGGP5lOT35jkZr41fmLM52MSg2+fCuHtFvTfX@vger.kernel.org
X-Gm-Message-State: AOJu0Ywnm1HbH3XeRR5C2ObunXVk4+NLSdZTbRjNIiPLYdmfIPr1FBSS
	rpN/Sa/C8qByNrc0WwKKwQAzOFnKzFFTUitT/+ijhMte7KeTImsNpJcM
X-Gm-Gg: AR+sD11bVeYPhpZRaO5G5jOcXo3sIEUxvNldnUfJ0dUZRD5JPAXMzYEXK+5wRd5yDgJ
	RyS0XESiVGFecsUxC0wNawI2BtSx5AcVDMVWBUF0V8Hc4PDVEjim3afaGXMMrC0cTbheS3qg3d+
	DpCxFmFEw8rP+020j4p7FpY4Qy68GWUohQXc7jCTDBRTFuZEepjwOlzkI4JQlCEaVusa++lCUYl
	39hXP/tKNe8N1qRIHAtvsW60ZyTUC60LOobad+fy5TUTjgmLTsHNnPdD4qhSvl1nBRSo5mAuXse
	dhSIK52oJ2NfG7kC4o+qhsSfc7tUznKPTfs8WiA9pAKmZS2MxvCAZnoUlrwllrnClOAWtehZzp0
	JGFzYwZAraMLmE02CAQjg3Rai/KeE947Nybp2XL0h0xGcLa9+gV45pFO5r71a7reXAiiXksPeBm
	BtsqCor+Ow2csaxD/sxNLgSRRs69bEpoumoe6CfYoOBJOGC3vV/QxshzHURsHr
X-Received: by 2002:a05:600c:8b55:b0:495:3de8:33a6 with SMTP id 5b1f17b1804b1-4994e7cdd39mr266039855e9.16.1786047268974;
        Thu, 06 Aug 2026 13:14:28 -0700 (PDT)
Received: from fedora ([212.253.220.176])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4995422016fsm70069855e9.8.2026.08.06.13.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 13:14:28 -0700 (PDT)
From: Serhat Kumral <serhatkumral1@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: Sean Hefty <shefty@nvidia.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Serhat Kumral <serhatkumral1@gmail.com>
Subject: [PATCH] RDMA/ucma: Allow path records to exactly fit the output buffer
Date: Thu,  6 Aug 2026 23:13:58 +0300
Message-ID: <20260806201358.147478-1-serhatkumral1@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ucma_query_path() emits a path record only when the remaining output
buffer is strictly larger than struct ib_path_rec_data. A buffer sized
exactly for the response header and N complete records therefore gets
only N - 1 records, while resp->num_paths still advertises N. A caller
sizing its buffer for a single record gets a header claiming one path
and no path data at all.

ucma_query_ib_service() in the same file computes the record count with
a plain division and so accepts an exact fit; make ucma_query_path()
behave the same way.

Current librdmacm is unaffected because it always sizes the response for
six records while the kernel currently reports at most two paths. Other
users of the UAPI that provide an exactly sized buffer can observe the
truncated response.

Fixes: ac53b264b2f3 ("RDMA/ucma: Support querying when IB paths are not reversible")
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
---
Reproduced with soft-RoCE (rxe) under qemu, on two 7.2.0-rc3 kernels that
differ only in this patch; the kernel config, the test program and the VM
were identical across both runs.  The test program drives
/dev/infiniband/rdma_cm directly so that hdr.out can be set to exactly

	sizeof(struct rdma_ucm_query_path_resp) +
	sizeof(struct ib_path_rec_data)		= 8 + 72 = 80

and poisons the response buffer first, so a record slot the kernel never
wrote stays recognisable afterwards.

Before:

	requesting room for 1 record(s): hdr.out = 80
	resp->num_paths (advertised by kernel) = 1
	record slot 0: UNTOUCHED (still poison)
	records that fit in the buffer and should have been copied: 1
	records actually copied:                                   0

After:

	requesting room for 1 record(s): hdr.out = 80
	resp->num_paths (advertised by kernel) = 1
	record slot 0: written by kernel   flags=0x0000002b
	records that fit in the buffer and should have been copied: 1
	records actually copied:                                   1

flags 0x2b is IB_PATH_GMP | IB_PATH_PRIMARY | IB_PATH_BIDIRECTIONAL, i.e.
exactly what ucma_query_path() writes into the record.

 drivers/infiniband/core/ucma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 878561fa1cb5..cfd202325458 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -951,7 +951,7 @@ static ssize_t ucma_query_path(struct ucma_context *ctx,
 
 	resp->num_paths = ctx->cm_id->route.num_pri_alt_paths;
 	for (i = 0, out_len -= sizeof(*resp);
-	     i < resp->num_paths && out_len > sizeof(struct ib_path_rec_data);
+	     i < resp->num_paths && out_len >= sizeof(struct ib_path_rec_data);
 	     i++, out_len -= sizeof(struct ib_path_rec_data)) {
 		struct sa_path_rec *rec = &ctx->cm_id->route.path_rec[i];
 
-- 
2.55.0

