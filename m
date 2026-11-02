Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793600393;
	b=RgKjqnfVjihq0rPmX1wZYk/me7XIb0V4GuLqvaXV7nChg4+iaqTFblLBsnJRnX2N0iDv
	 FZ01LZNd/m+tsBkSNl9I5nEoP21GXXTyoQplLhOCHZp8eS7cCc+f9lE3HY+Gi6UcmgKp/
	 lc+xbxXvgUqsIjt0ApfY3uEBuAPnGOuNHSQF16xvJKZXlZM3nxBeNVNfnBKiC4zvs8Klt
	 nmttPqO4Qr6Y2Ae6y6HEYLZw5nY+dcfIqmfJ+JGacqObttqDxImwGrqz9Bitzo5Cm9WXK
	 mvUITNzESQxzlnXrOD1o7BKh6KSmvu8PNxkrW58mMVn1VUSZz0YAJgEsSiMpgvY9nkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793600393;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mElJe/DzwSK4Juni12Wq7XJkw3SOr9Pu1K+PozWddZs=;
	b=euBxfs3dS6FuwQE1D+fEZAg+2EnmggwdEcEaYRtSjBbH8YAyG2gbLFrEkFTS7hjZsqWW
	 bXRGt1pSPj1zlyk/rwrV+hWiCYHft2P4W9Tj4b4C3NzO2DjbGdJB/aEnXpFx9hDL3HtRN
	 W4Ttq5UQpYb1SDSBwyPvcz8XH42YBLotlqAc8bm0v9chuNnACOILtuJeFaoMd+Y2HytwA
	 APo3jayrmvAbTkUXdjXFB0Imaq8HY3sJxqPrDkjXIKhJO7eJqQz7kTb6ZNI4DH/TSfpL2
	 Iah2Ptbjo9xVkJqEww9x2GF5rAECPfbDibMJ9HhrNU/Xs4hfD9h1z1wzdyYyOn/ZC+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=iLdkvdVl;
	arc=none smtp.remote-ip=209.85.216.50
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A69606A336
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 06:19:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77A69606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=iLdkvdVl
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3ad787e0593so1175591a91.3
        for <linux-rdma@vger.kernel.org>; Sun, 01 Nov 2026 22:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793600392; x=1794205192; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mElJe/DzwSK4Juni12Wq7XJkw3SOr9Pu1K+PozWddZs=;
        b=iLdkvdVlivdnBEwdF4/PbU7RuQHrRTPKAvS/0RZAfYJPkd4Zz/n+kjh0RLKW7xXrdM
         /u1zi6YdXw0bUzOysZtLRTWe9+s7SWC/Jc0C7xwjMN4EzX9WL8D8CimQ4mNj79qUXTbA
         4NruuwiNtW0Ya+rA+sSvLHvG64WEUk9/pmglxT8AK1uqvt+kMgm8/mkiACHHb+bjjh8P
         8lE5PT3x8iXeDh+n/XIe/VgXPJ6yDygrbo1M2s7KwOdxRezkKhC0ey85XLThyFb+Kdk4
         zF1MrHXbSBkWCwSJsOoqrUNXvoJQPf+L4bhLLLvJmv2R5jmABe2+ug3X/OPAb8ia8BxF
         VSiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793600392; x=1794205192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mElJe/DzwSK4Juni12Wq7XJkw3SOr9Pu1K+PozWddZs=;
        b=nwrb5oyBHrYHMnUq13ESSMkbkWyWY8BDytECZizdiUsvh8T6bRrKmgEHrPAlUkIiw0
         JYRZ7r8kmTQ0z/tiXhep5WryHqVXJTvfF3CauTYJzyelCbdVRQSak0SQg5lU4JIbq4hS
         hV6AuIHhLReAPrFzmuH/H6SCkjVEJINe5JTggyN32lWQabtpg4oex735pfreU7dFQF3N
         Bhtkmuo4Ft29+IsA85sTc1rxUwVMLreCcKsY2kQBqXKfzmI0RWBwgfq/1/qiaH1VTfny
         vzSlkYS5hkoCPxPe670H1QNPPqKiVQO4LclqdsrZxpGcoiQHi/0gccPccLV6t6vw5JWO
         QTyg==
X-Forwarded-Encrypted: i=1; AKwUvBzKJA1xU+FGyCkd8fwI1fJH9XLCHxaeA8DFvifQsjAQCBDq5yeNuqxTuiXU1ycvS/aVHsdd06loipcj@vger.kernel.org
X-Gm-Message-State: APuU4Z9bncztRaHhGXe5YVnIe2Jrwo1QCbQrsEOPk7VuelIgfHu9ybhS
	WyK2PukHCGIJPm/VhpfCXWQ5vHMSfTxmGDJWJxDLTXvXt94jZ8d3PecQg2dmKunPtg0=
X-Gm-Gg: AYBFou0qqH5owQmdB88QeEYiszInis5zfhs7QAYXJdh4zn9nFJpYtg37sb/Ye+36blP
	WQTD7NE9YSiS/p8ontRTQWZR1xyCAPpoRajiICmYvPtRpmJjNz6ujZYCxDAmSS73MWN1RV/L5Ah
	xqk0ECOHDgUq1G0y50yBDE5A5El+TmF58ccmgcAK35YA0xw7AwMecicmctXhuhyn0wb56iMgry9
	kXNl1WuNN1jGQ/q6Tdq93441mLZ9yr2ghjXMbDghzq2ZYyX8pbzcgpDHLvvsABliQTn/nk88jD3
	xfuWBCCSS68g8aMPEALOFgnOLFC2k7oGy7whHueK5u2mmqwh8u6ETfFH2e8kU/eknI23+iZAwxh
	YRP3GxGYtwVmJqBDYJ7Mk2/KR0BCK/AkUSZWDwndacE+ZPn85M/2hQSpDL7IWSrQlSm4hAk8U1C
	eRNmAU1fF4e5YJfXwYg1cowiXR32zB3wRP8YmE72I+bz7tx+uIorCIT60iG0em/u7cZRDl8nRJq
	mUlNSWaInJyWc2A2VBZKRGJbu6qZ78Xv5QIJcFin6IXjaVi7xlL5E33loQGY0KzWtp8ZDb3x8ax
	K2KgktBzvyNcZc3Zvqxc8BkkUCA5VwiE466MBTYdTpk0ngcAfU7OEjz2t2AEewvcY5KHFQ5vSoT
	v6PhJGZOUut0FP9yosZWjofT+zZ0m+BCZOEWuDw==
X-Received: by 2002:a17:90b:1e42:b0:3ab:5832:72af with SMTP id 98e67ed59e1d1-3ae897ce417mr7276437a91.32.1793600391928;
        Sun, 01 Nov 2026 22:19:51 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:d115:e4f4:23fd:61df])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae8441a5ecsm12927752a91.2.2026.11.01.22.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 22:19:51 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v3 2/2] RDMA/srp: do not DMA-sync a receive IU past its mapped length
Date: Mon,  2 Nov 2026 15:19:38 +0900
Message-ID: <20261102061938.617371-3-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261102061938.617371-1-yhlee@isslab.korea.ac.kr>
References: <20261102061938.617371-1-yhlee@isslab.korea.ac.kr>
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

srp_recv_done() syncs the receive IU with ch->max_ti_iu_len, but the IU
was mapped with iu->size.  Those are the same value only until the first
reconnect.  srp_cm_rep_handler() takes ch->max_ti_iu_len from every
SRP_LOGIN_RSP while it allocates the receive ring only when there is none,
and srp_rport_reconnect() keeps the ring across a reconnect, so a target
that reports a larger max_ti_iu_len the second time around makes both
ib_dma_sync_single_for_cpu() and ib_dma_sync_single_for_device() run past
the end of the mapping, which breaks the DMA API rules.

The HCA itself cannot overrun the buffer, because srp_post_recv() posts
iu->size, so sync the length that was actually mapped.

Suggested-by: Bart Van Assche <bvanassche@acm.org>
Fixes: aef9ec39c47f ("IB: Add SCSI RDMA Protocol (SRP) initiator")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index a85d28b95306a5..159d6b6aa93e3a 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2111,7 +2111,7 @@ static void srp_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		return;
 	}
 
-	ib_dma_sync_single_for_cpu(dev, iu->dma, ch->max_ti_iu_len,
+	ib_dma_sync_single_for_cpu(dev, iu->dma, iu->size,
 				   DMA_FROM_DEVICE);
 
 	opcode = *(u8 *) iu->buf;
@@ -2148,7 +2148,7 @@ static void srp_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		break;
 	}
 
-	ib_dma_sync_single_for_device(dev, iu->dma, ch->max_ti_iu_len,
+	ib_dma_sync_single_for_device(dev, iu->dma, iu->size,
 				      DMA_FROM_DEVICE);
 
 	res = srp_post_recv(ch, iu);
-- 
2.43.0

