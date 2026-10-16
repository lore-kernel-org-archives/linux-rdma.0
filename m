Received: from mail-wr2-f10.google.com (mail-wr2-f10.google.com [74.125.225.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BA535C6AE
	for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 21:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792185336; cv=none; b=uGQn0DaKVMu7qVkt9g7qHQLSTZWv8AGn7arrJs2Ur0oObGSqL8ETARbdcGi4Jybvfupjbt3oKwkV6jqmFSaHvskA+BOQUFZuezhuKinYXJxY4+sSy+LLhYWlMwdaOLll7QlZL++bE7AYHzHhkba6g5bhgY++0Od22/UL7pGPwbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792185336; c=relaxed/simple;
	bh=VDhoRC8pTDDxagB5+GaxGajkPzB08MIxYPYh76G6PGs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PXJSmIsWUqXC6rQHA+L0XKvbRWQfqZObBijTqSShf/IOOkMz5g3mZlnP2bh1dIBiJK1d7wj3NXVSx/nciEOyaTV/oJwzly5zYtHwZrRqUfpIy3g+pLfYqKSKuPj9Uq9YrUGlcSaixmq/7cFRFkGBDXVIAcueCuMgPgYXWgi/1DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dVJeVWnq; arc=none smtp.client-ip=74.125.225.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dVJeVWnq"
Received: by mail-wr2-f10.google.com with SMTP id ffacd0b85a97d-48df160d369so70738f8f.0
        for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 14:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792185333; x=1792790133; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=W2AfFv0+pkUutze//OvmWv+PrVpNHb3Li7gq4EBtbHs=;
        b=dVJeVWnqNTi8jo6oCJP9rDF9gKyVs8ayD/61KFN8EGsQTtLunuTOAFdVm4QP+debYE
         HCGSI3ThznGImZX82J0+c4cpaHMDr6NspRRPrlyTAmBSMYOepVfP0y/Fp2OitvGmeTcy
         WEN/QbhInKSDty303dTPUU/oGBrjvWTquWlNQgwFkpjNfIDXYMEZ0Eibh4f+Zy6Ok7/f
         sRSX7ciPg4zh+73boWRuXnKAW+1HLusyVeyHj6asU5uGPK2pOaT7kcsvNCg/quA1d52r
         iRgBDyJQazcLtmFcE4mVm1d2Z7Dsf3CLulSxooVqOyiVJL6fEvd23J3DMgCX/D4ozi0l
         fwAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792185333; x=1792790133;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W2AfFv0+pkUutze//OvmWv+PrVpNHb3Li7gq4EBtbHs=;
        b=PkfoUQTHovyezfW5p7cIJsPyEtPPts9PwNRmSSvtZfVO/j08XGQMNSWJPp3r/yNu8i
         tNh1ECNotrEJHi9zKrHl7FlwPqcd3WIGjy/MnWy6bz3FOe2BsJKxLe/W8EzdsPcLmGN9
         xgTXZgKX9Gfz14LEEU+kZkw4YzfhwrfFRB7vx+eZBx0MIlwdacspDji2RIFPvpEPQWny
         g+5i3aOYuVkdA9+9aAR1Ys5yDyVZdGHPHFOn9ALXTYpdgYNrabmmVCfJnoZLwCLk5gmJ
         9G2PQRHs1ssdiMAcsZmxbbaLUh1wf7ikWTDtzx64jVZdoIPLz9uIT1fsGZxB2JG25+/a
         hHlQ==
X-Gm-Message-State: AFq9FYJySDuvKBe4gWIdi74YpTeQbbj8FpqsNE9UaCbLWcEhhu6sLv7+
	SMTeNNmL3M022MCJtaysl9ItpV3zMyrU+1ao3nmcC3g6JPsqba6Dgu73
X-Gm-Gg: AYBFou3BTcbGCDOTWMSd0IC+xPbwbIwnBwrzvh2mL4kf4EbyQpbCZHIwWDK89Eei+Ld
	CQzGxaYKSs3Y09uCyhqhF+KaXEPTK6bQMPuoaXANiKba4JSBn/iqRM+K/vmJ6OTXSwAl+i1CGNa
	IxcQzkaPPDJ2dRssjXfFOhLgd+t6nadR+UAvor3ZoLP+5dWaPvgt01MCQLON+ruAJogYnq2/dIW
	E0IXZ4iy50jA8A55T/EKPFCXRILju0DPupRlfMcRFr0P0ibiwuKLDu23ZZtMG2egQi4SIh20BbY
	JcsEbRr/pHmJx30+6DBPaExhGxxZsyrYFNHFJ0cJfofifQCvXyCz0zlwH0W9o6yFOc3i9VWn91G
	k3yO9O/Bno82AIOk3Da4MZlL2iAFqfEkjUyhG6ZT37Yyf98d+4CjOHbZsv9FKmyCEMw9aD6M5Dn
	W7N72QM50leeMPRpkZLsdkT0bkv9dWYlMq/rWMoxtn7NQgOEzRE3IAqVFSW/aAs/y8+deMy5Ayy
	hDaCPhosRTsVA==
X-Received: by 2002:a05:6000:29d2:b0:48c:7386:af18 with SMTP id ffacd0b85a97d-48e079803d2mr1032038f8f.8.1792185332701;
        Fri, 16 Oct 2026 14:15:32 -0700 (PDT)
Received: from serhat-ubuntu.home ([212.253.205.12])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd4e7ff1sm7864622f8f.25.2026.10.16.14.15.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 14:15:32 -0700 (PDT)
From: Serhat Kumral <serhatkumral1@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Serhat Kumral <serhatkumral1@gmail.com>
Subject: [PATCH] RDMA/srp: Avoid reading uninitialized has_port on srp_parse_in() failure
Date: Sat, 17 Oct 2026 00:15:09 +0300
Message-ID: <20261016211509.12973-1-serhatkumral1@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

srp_parse_in() returns -ENOMEM without initializing *has_port if
kstrdup() fails. Only check has_port when srp_parse_in() succeeds.

Fixes: bcef5b721568 ("RDMA/srp: Accept again source addresses that do not have a port number")
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
---
found by smatch:
- drivers/infiniband/ulp/srp/ib_srp.c:3502 srp_parse_options() error: uninitialized symbol 'has_port'.

 drivers/infiniband/ulp/srp/ib_srp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 955f36efeebd..5811f02df980 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3499,7 +3499,7 @@ static int srp_parse_options(struct net *net, const char *buf,
 			}
 			ret = srp_parse_in(net, &target->rdma_cm.dst.ss, p,
 					   &has_port);
-			if (!has_port)
+			if (ret == 0 && !has_port)
 				ret = -EINVAL;
 			if (ret < 0) {
 				pr_warn("bad dest parameter '%s'\n", p);
-- 
2.53.0

