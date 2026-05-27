Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CEF3E9287
	for <linux-rdma@vger.kernel.org>; Wed, 27 May 2026 10:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779878812; cv=none; b=YX6uVfDUq5euKeGaht91eaHI63qvkukBlZGii6bVgqF+08V+L0EHh4J+CbVA997U5x22dxgwNfJVHe6aD5AFgMB+3AaE5V/KOrMSEh8DmvffmCiebHQElLkemLzdGt76yyLrDVdDB2s4SEguz37R3OOLpzHukZ9AwGd7Eo5rSb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779878812; c=relaxed/simple;
	bh=Ohs6vZrBMosBHdV+4TdaK6MdGveAFbNgH2YfMCwV+7k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q6VGRmJsh8+lf5QXQxGMR00tmAofBCDBCYjBMrFlxgoSmiX5rtgckZPdq18EysGwmh9kdF/XliwszwXX9zhrJEiLuWXl5lr/Knjbgw3GF/0I6Vr1CdaWgJiWauPTpQBEMxIwZgwk/4ZlibYbZOQlDA1VW0mfGF72jj+yAxFMbF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ntLCJGhW; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ntLCJGhW"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7e612d0693eso3816413a34.3
        for <linux-rdma@vger.kernel.org>; Wed, 27 May 2026 03:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779878810; x=1780483610; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3yaKFNluctXzeKSAK0bCyGmo+HOgAfiP5YCmXSKHb/0=;
        b=ntLCJGhWeeAjT1r053rZxDlayfu/Ti3+P1spM6VCxiFs8neiJzRVgGHidAZ1y87S1j
         bbxJr+84ZV8asM0AngnXZp1drg2MxV2co09Q8+RjIKbJY4UhZ4/Y/SfcPf2fri0fGrEj
         a0waOnq3iglY25V6JbahtOEKwrXOyXQ+Vdp62uxsRS+tEvirEapy3YsrbCAiRffiqMtA
         VYnf0G8RxfSR6ReMoBqQw1o96e2AbNoR66TbY0TWnyMG+XCtKpiqXQcCU95dPBtMBJ6b
         nNt2tXNJm+te06cZuCACvAQHW3UN3r2b4HEJOtUGK8QjPPH8L1F5HFty/PAt3WA+uQDt
         SP6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779878810; x=1780483610;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3yaKFNluctXzeKSAK0bCyGmo+HOgAfiP5YCmXSKHb/0=;
        b=PqQmeVS2fTdbmcMiy91NexQxVORhDs/8QR5Kx9DrwfaciHvZDKpI4asbrPCOb0CXRQ
         JLVtHQPGYCmjzs9Bx6jN4bcuvzsDRM6Sg9IRc4Ls5GK1WVZuGQzyv7+3Gvql7LeQEgjR
         C8031hogfa8ROrJ5OrCGGdXKpz6Kze7+C8oQSr0ZKXmLLBHwNQgG5aG3J14Z80n0I3/R
         /P+8ptc0+Y9o8NwH+AcHTKvvgc+ANgqOCHUpdupUZ0R7uEs2feqmRgyGKd5dH1QCLpBu
         jXiZ6yQaAWzX7/WY+xOdnVVzUd/m8PtlzvHhhY4c/hzA88G5ljGrmBCYIeB0bAeLWaPH
         MqcA==
X-Forwarded-Encrypted: i=1; AFNElJ+7qvGJ4jO/99Ex12rqW8eSkDayg2tWaGBSopKW1Xs/GK+ut/7He4FvqeubvVfsDBT5g9OkIC7d7QGR@vger.kernel.org
X-Gm-Message-State: AOJu0YwK1/m5KBP7yO8Rl1nsqO6BkZ056Pa7bltoXQXRNIkGApE74kOl
	e7OfknYF3E+YLpiETTtl8feZPqxkxHFBdHWZVooSIRw6dcu2JJYVsDmy
X-Gm-Gg: Acq92OHPRTqZTY7UK7MEj91buCZSxJ15y1G/MpSMuLdr5gkuExBImAvQsTB7dNYbpLG
	QVLgmjU7ByIEUVNCFlIyHho99gKepsUuKIBWyG/ONg/nCSTw/XabuadwBIlx6SsBrj7xmPPNRqL
	rkU3QkRCcLip2Us35zUWRToYbtLcCSoV7GU94TN2BT7KrjlK/epknnxWOll1YJ7rn0YYR2Ow47g
	PiYgzYJAWZpGh88SnDIxb0TB8TU1zVriHd3tfOcG+EYUYjqLzm6hdWrdMvx0AkAwlYZLrwkxlEZ
	3rejA5qtyRcVkJZeklwzdiYNivrDmhP3Y2o9F5yzXT0vDslwxKjVQBKPiSk7rnMCPJ/pLUX+WmI
	++wnmLBoUvjxnIWz+3ItlNDISlSDyr2tDYy/QVWWqMoD5GWUDpyhqYVrG4flGHrpKTBaX2PRyEo
	mlXOgzOp0elXSmyErJMnIV6FusPIZPKG3JsVPDiBqas4N766re5EjNIwI4PVmEdfID1d7vpRwLx
	n04VMJCIPThlbDtQu0rog/8Pu/qrHVFZqOZHYjruqJ2Ui60+S50m/ILr+LRAnfWDv7aohCYrTpr
	sktNgLwKOKxVfA==
X-Received: by 2002:a05:6830:6a88:b0:7d9:d2b6:1568 with SMTP id 46e09a7af769-7e5fee82afamr13922659a34.17.1779878809635;
        Wed, 27 May 2026 03:46:49 -0700 (PDT)
Received: from instance-20260526-181250.us-central1-a.c.kernel-lab-497518.internal (103.249.223.35.bc.googleusercontent.com. [35.223.249.103])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e606459f67sm11197198a34.3.2026.05.27.03.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 03:46:49 -0700 (PDT)
From: Purushothaman Ramalingam <purush.ramalingam@gmail.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org (open list:SOFT-ROCE DRIVER (rxe)),
	linux-kernel@vger.kernel.org (open list)
Cc: Purushothaman Ramalingam <purush.ramalingam@gmail.com>
Subject: [PATCH] RDMA/rxe: fix typos in comments
Date: Wed, 27 May 2026 10:45:26 +0000
Message-ID: <20260527104527.3222-1-purush.ramalingam@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix typos found by codespell in driver comments:

  rxe.c:       s/mangagement/management/
  rxe_param.h: s/interations/iterations/
  rxe_resp.c:  s/recive/receive/

No functional change.

Signed-off-by: Purushothaman Ramalingam <purush.ramalingam@gmail.com>
---
 drivers/infiniband/sw/rxe/rxe.c       | 2 +-
 drivers/infiniband/sw/rxe/rxe_param.h | 2 +-
 drivers/infiniband/sw/rxe/rxe_resp.c  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
index b0714f9ab..af39209d0 100644
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -81,7 +81,7 @@ static void rxe_init_device_param(struct rxe_dev *rxe, struct net_device *ndev)
 	} else {
 		/*
 		 * This device does not have a HW address, but
-		 * connection mangagement requires a unique gid.
+		 * connection management requires a unique gid.
 		 */
 		eth_random_addr(rxe->raw_gid);
 	}
diff --git a/drivers/infiniband/sw/rxe/rxe_param.h b/drivers/infiniband/sw/rxe/rxe_param.h
index 767870568..1cc77c46b 100644
--- a/drivers/infiniband/sw/rxe/rxe_param.h
+++ b/drivers/infiniband/sw/rxe/rxe_param.h
@@ -109,7 +109,7 @@ enum rxe_device_param {
 	RXE_INFLIGHT_SKBS_PER_QP_HIGH	= 64,
 	RXE_INFLIGHT_SKBS_PER_QP_LOW	= 16,
 
-	/* Max number of interations of each work item
+	/* Max number of iterations of each work item
 	 * before yielding the cpu to let other
 	 * work make progress
 	 */
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 9cb2f6fbf..d8d1b7f2f 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -1505,7 +1505,7 @@ static int flush_recv_wqe(struct rxe_qp *qp, struct rxe_recv_wqe *wqe)
 	return err;
 }
 
-/* drain and optionally complete the recive queue
+/* drain and optionally complete the receive queue
  * if unable to complete a wqe stop completing and
  * just flush the remaining wqes
  */
-- 
2.53.0

