Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C03346FDA
	for <linux-rdma@vger.kernel.org>; Tue,  5 May 2026 10:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777975641; cv=none; b=sXA7ynkK7BRPq08a9SPwz/jy5ADZIpMOJ3itxy1jeaab1uNza5hTryZtm47YDMDrDlRR5crEiG7z5p+diufaJSSK/Z8SEElMHW51m/0w0fjsdAfsg6YuktIayedKq0hjR/iZnDYi7i1mkMTjCULzWj2rGGcJq6ud4+3r5nWN8vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777975641; c=relaxed/simple;
	bh=iWmHogweennTcuTWgmokUu3NWKTTMJlIWqE9v+5r+Ag=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ggyp41tpzih4eDCcTHf/i9tkalDW54FPp9WRYFJd7FI0f7lhoRkpy7kSJJBPGe3mGMtsquxMDehKxJN1DIGH2SD8GZlaRs0Hjn/EkiNxS+nJrHzJTAFqZUz6CdVD7ieA8C2nPuumWi0dXg7BJhNqp61WOdreN/gIoCqv0EIGVAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mur7wdH4; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mur7wdH4"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-83659d38e38so935721b3a.1
        for <linux-rdma@vger.kernel.org>; Tue, 05 May 2026 03:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777975639; x=1778580439; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GvhUIShtfloLqOb4l8aV471APYOraXtBo+Xf7XkoDgA=;
        b=Mur7wdH4tQbHR3pXZxYG+0p9+CF4eKANz5EBUiwCA3LNg6Oh91ZOydlOjoCyZr/tyO
         aWobr4FaZKVUlBZ1qcI5RguhYcpKIA5MWWvgFhQWqJ6i/6LJDrK8K/tHFS8MdxY64CY/
         8O1k4WRMIetTW0J3mH5c060pYUaE8Ez/ZTqvj3x5/ib6QkNDcAIZtzfq/E//eR1eFWY/
         WXZBI1+YAm74FRp/uK6s5uqgyGC1qcRxo84dSayu1CINC2AjjixI/f3JFQCqzedxYVsc
         ORAbE945sCbIc5lDtll+56PuBJsO/1pqbIUVDjwJQTUz6xi41fF1l4YAsOJfZXlJj9ay
         d/Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777975639; x=1778580439;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GvhUIShtfloLqOb4l8aV471APYOraXtBo+Xf7XkoDgA=;
        b=A90mmwY2EJwGN2aRFKIlDOTi2Z8Ic7aezGGzML19nRzCeXGhx4tlqEbIIPOu/rOKA4
         7sJD32op1uu+kxlwdHBOQStuKfZxQLyqmcvhae9lS45UJgi6loppMLK8n6EsJRJC/sWJ
         FxUd3U89gNVPlmBirZvgWigHT3xJYWVWvZSrGSo4cUclqw+vfiTvxnrR4qPJBSE9gmCy
         oMSr1Fntj1o00n5WEcT7yzwB8LSAzvvXf1KEEPVbRhDGPOT5LandMglo4pkr9AqEYHvK
         rtJ21+c1qBfPhGDGy+n3PDD7uYMtMtBGwj36hVf4JrJXUUdwepZXo8fJ/Bj1SkoKxw9q
         7AGQ==
X-Forwarded-Encrypted: i=1; AFNElJ9TpSrotrgoSHnFJnheawW1qu0OxsG3t9ZblozND6DCJVOgAWBLaY16AlfrsihclSNIUwuiEoZj2+zi@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3xmKi/T+71UFQLMPEbB0L5a+bwlcdEwhibP3rYCuacj+tPMOE
	tjSOg75KvIbeGp7C5OTHHgYZX2SXfrhz3Su7uHqd7cuxuBW6JH6/JrGr
X-Gm-Gg: AeBDievzvTF/34b7vicBdeYXRtMAs6QWojPomHPd0QTpGBnoD51sHo9wv5nOeoqXvWb
	dlfoUHir0g4lT8SMTbEMOV/c3LgLOdBfIZRlXJdfKoNP/oV6amBamPvJiuVmDqhpKQWs14EESxk
	VuA+CZqNnFQF+V/aKJeQdpTRWBjFATIA1Wi0pEJYRfua+X8x3Bx1hLKMMPUn8CO9XluJlfg4pLE
	m7TSzqnyu9eWOMnX83KMFclwKe9kQkNIKowSGpBt7LQ23wMjb1xBK1XmOCdlthXCqbej5Fkns6F
	aem18LWWAHH7gv1WUdrVClHXP6EcDoLSTehu3fOyZBKEhlg8SM6dAvPPe6W1WicsDy4mRem9D4F
	dBEHpWut6wLpqWxCYqMOic2b8At30Y7abpIc52hHK+jkLx9LZkbQb9DSe868qwiNJTfnKR6LZYi
	9AMR2dDUq3t68+2q2MigwEmCQq
X-Received: by 2002:a05:6a00:2392:b0:836:bff4:fa5c with SMTP id d2e1a72fcca58-83924aba51bmr2472102b3a.45.1777975638935;
        Tue, 05 May 2026 03:07:18 -0700 (PDT)
Received: from dev.. ([129.41.58.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-839679c7ba9sm1712292b3a.35.2026.05.05.03.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 03:07:18 -0700 (PDT)
From: Rohit Chavan <roheetchavan@gmail.com>
To: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Rohit Chavan <roheetchavan@gmail.com>
Subject: [PATCH] RDMA/mlx5: Use max() macro for bfreg calculation
Date: Tue,  5 May 2026 15:35:49 +0530
Message-Id: <20260505100550.1810139-1-roheetchavan@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Simplify the calculation of medium blue flame registers by using the
max() macro instead of open-coded ternary logic. This improves
readability and aligns with the subsystem's preference for using
standard kernel helpers.

Signed-off-by: Rohit Chavan <roheetchavan@gmail.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 8f50e7342a76..44d88dc3e741 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -708,7 +708,7 @@ static int num_med_bfreg(struct mlx5_ib_dev *dev,
 	n = max_bfregs(dev, bfregi) - bfregi->num_low_latency_bfregs -
 	    NUM_NON_BLUE_FLAME_BFREGS;
 
-	return n >= 0 ? n : 0;
+	return max(n, 0);
 }
 
 static int first_med_bfreg(struct mlx5_ib_dev *dev,
-- 
2.34.1

