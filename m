Received: from mail-wr2-f7.google.com (mail-wr2-f7.google.com [74.125.225.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C80545D923
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 10:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792059961; cv=none; b=BilZs+Y94R6Y5ffsOuf+wbQB8nU2ImAQO0jdEFYBZ/TuozNVKMOf/RfRpfVrhCzeFWEibuE+7ktInSwyXra9bt/SxpOImDnjAqw8NX2i1gjz5ceidr2jcUwI7coZuS8LWC03/4vtj6eyjwwgukt7NPpPA93e2CcfvPZ3s67OQQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792059961; c=relaxed/simple;
	bh=joXwYCLDFBRvtST9liA7y5l07Dl0QlRsfc0qKdtSK8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L6yyAv93ZLg1t2B3lZW+p38mGCArfHvJOgAwnjbYzmCgBV9RQj9ri4xxpJOHWKGZbRq1ZPRCayY7WjG30hlR5U7a4uXUkMJHPYWKOs7Wc9qincI9u+CkpxnMay3fuOw/DC9ocOD5zP3u1SZsPnsdJ5LBOIhjL4xmqjL0joJBkqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=q+dWSwe2; arc=none smtp.client-ip=74.125.225.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q+dWSwe2"
Received: by mail-wr2-f7.google.com with SMTP id ffacd0b85a97d-48af3d6f47fso1686123f8f.1
        for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 03:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792059958; x=1792664758; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AAVLJelNLtLTgKVSCHdzfg2BmtJf7plaW7j80dNRMSk=;
        b=q+dWSwe2eO1L87Rr1awwzL8Q5/9hthKyIigVLWdyMXPkIC7Ca7Sw+GqthB7x6p6FjJ
         a6mezH7+4DTzWUmADw/r+Jp/xh4a/hDfN1TFGrUCLDxYag08Td1kiZnfIEXFgmastFXQ
         YfcVe6Ptpp3JOTqBb7wsGC+oJj/WE+DGFZ0u7/uxdc53WAivHcXg4gUDH8+8cESCtliR
         8wREf7tY6vbQ+VL/haVpP8TbE6wYBa+kXuc5+Mt13WaLfoHbIIBoTByEm6H84n57TV5X
         Wi/phZm9V9p3YuhQS5YFatX6tb3M5zmHCNdkwi3X1LqbVtl0RpmqiQzbyBXzASKIU7sQ
         E8Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792059958; x=1792664758;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AAVLJelNLtLTgKVSCHdzfg2BmtJf7plaW7j80dNRMSk=;
        b=k8qedOqhGU/LZnGYefmqX6PAhyKZCAmCDft8yTwX0IGi1elCsuqEn+LxD92SiSHQZu
         OikbH42NBTcqdH270yERqmFIlRIm8ZqMR8EiKpecQ0egINf1nSErkQsPs8kcSTea/vWz
         OadYA7Xc+8MIAwkPc5fUx41G04dDVieGPHiJH5V9d1JP1J1jCq5ohabPvFpavcdmvuO7
         A8Ow6crBGPWFalP9rC7STu0zAFdo/mzLHh6SkulzQcFQwRDUQRHgU/s5V6yBoRIQmKBq
         IMA2UD+reVWMEn/8CyCAqD6ITFiZ1Z5DHkR6ndXI9hiRybrmJGyHSDfcSEeKXz8Dl0Cg
         v7uA==
X-Forwarded-Encrypted: i=1; AKwUvBzCqGOfoHRJVqvORWUJAv3LLClGQMyfIqs1+9tjUqPOH+lokF+2r4ORDOyrSkuwsRTRNdEzYxhMQbcy@vger.kernel.org
X-Gm-Message-State: AFq9FYJNEw2/TvTiNxja1oWND8yBEs00XszXdVIuP1pCnndYvFUBQtkG
	q63phoxEPy8dFhtdcVhnTmegsmOUTCDXq8xjgMuLfKRX4J4CkdEJ6siI
X-Gm-Gg: AYBFou2KErxGfg3x08O/sZNrc7k4D2Al+cLHrUv29HraUADv3HW2K9hGboYcvgvR5dP
	lMQfaiq1NivxCRZlP2chv2eyiKzZ/++MWGyfdVgEbEB7i36r/TS53Jlw5zlutcq+LdKQsftiI4i
	MFyha3gg2wuQKQXflrn3f53Qr53kIIZzBIkj5thyKuYqT7tcEGD72N7c7Uy6SR5CMp5AD18JThk
	ykIGIyEP1kT7YH90/DguE2lT+2bNqaG2Z3qLeE5tTSEeZwgDm66QX33Y/dLU3Y9w8SXJxNZF8lY
	lIKI4jvXL0vg1g7zqwMU54YvzP6ikhN6L7XSo7yky1KcCjb5I/GQJxSSHJ/1Mlt9ZTbAJZ2f0jp
	3N5bu2mU8GjLebrPlGB5y9wcMbzJfB8BbvIrkVY5vJPIlE7aMkUg3d/FLHLU/WBqv4D76zTYQ3r
	ghuhJGsyccHRTMVTq14Rep4/7jrfF4Qv4GBJomnlp+COVadrQKlbGT95WZT9YwDIr195dJUSDT+
	xwGFo0UsXMfWg==
X-Received: by 2002:a05:6000:298d:20b0:48c:43e1:a332 with SMTP id ffacd0b85a97d-48dba7828c9mr28324592f8f.7.1792059958315;
        Thu, 15 Oct 2026 03:25:58 -0700 (PDT)
Received: from serhat-ubuntu.home ([212.253.205.12])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0bc6b82sm18387264f8f.51.2026.10.15.03.25.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 03:25:57 -0700 (PDT)
From: Serhat Kumral <serhatkumral1@gmail.com>
To: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org
Cc: Kaike Wan <kaike.wan@intel.com>,
	Mike Marciniszyn <mike.marciniszyn@intel.com>,
	linux-kernel@vger.kernel.org,
	Serhat Kumral <serhatkumral1@gmail.com>
Subject: [PATCH] IB/rdmavt: Fix error unwind path for qp_priv_init() in rvt_create_qp()
Date: Thu, 15 Oct 2026 13:25:18 +0300
Message-ID: <20261015102518.15780-1-serhatkumral1@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If driver_f.qp_priv_init() fails, execution jumps to bail_rq_wq, which
bypasses bail_qpn. Because alloc_qpn() has already succeeded at this point,
the allocated QP number is left unreleased.

Jump to bail_qpn instead to ensure the QPN is properly freed via
rvt_free_qpn().

Fixes: 5190f052a3654 ("IB/hfi1: Allow the driver to initialize QP priv struct")
Assisted-by: LLM
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
---
found while investigating smatch warning:
- drivers/infiniband/sw/rdmavt/qp.c:1182 rvt_create_qp() warn: missing unwind goto? 

 drivers/infiniband/sw/rdmavt/qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index d8ee485c49a6..3602b9ff2196 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -1173,7 +1173,7 @@ int rvt_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *init_attr,
 		if (rdi->driver_f.qp_priv_init) {
 			ret = rdi->driver_f.qp_priv_init(rdi, qp, init_attr);
 			if (ret)
-				goto bail_rq_wq;
+				goto bail_qpn;
 		}
 		break;
 
-- 
2.53.0

