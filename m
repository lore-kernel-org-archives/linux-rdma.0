Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792994088;
	b=rMKqAHOWTvCrbVlVvSMTxhhvoHjbuuyiTaxPRt5ZH89o/laqk3MAoAyHtIiYMLs5dq11
	 yRwLH3Qw1VnjBq878S1oflk7ivExjmdGjMFal9uSnNJpYMb0O184QOFRA+1KVzs5hDcWp
	 HmUAt9LaP0NBubc/u2jvvp8/oo2oWEflHK0yGVyJLOlUZ0ZXDEwmSdrfVyiNAqPUensal
	 71I8BXnROs9ylKblyQcdu8GYBd1blyaVSMWsjsuN/BmAkExk2hQlKsqWUn//fsOyXarvT
	 k2wGp5+Jjat99hoqqbULUrdMeB5Xoc4aAvu95VCEkAqvOT6m4i5i5+1J1TfYMnHKj5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792994088;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q9T0zMsyFxP6+f5YwGyxdVkCFKS+Sl9bRWYPaN9yuOM=;
	b=ikyAOIkGUXfi2Q6duSS06QBWsqjPj0ptaDJ4tbPrxYNDEPYCQMr2UWTE0MLZm469dOxX
	 tFox/XVMIxfVJylJb4yJu4uBEw2bpB46DLR+auoTqYyB2qrBpL4qkfQ9Tsjgh9naR7vwx
	 oIpHn1LTS11/4hQfc78opFxGbU1GLIAcwxMXUP9CyID611MXG/BaulVGwdXlVBWqOEvyQ
	 u71yOO8rbXy7Y7ft6ElVqkGA2vN2KwFkIZeKHzo5nR85D9mYiFuCPO96npyUXUjBcB0O/
	 OrS/ChKHRWJT1t0oMowJJl25v9tK824Rt+k8475sflZmqkSuP4+QyryCK+M6Di7Tb/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=Az9xVXNs;
	arc=none smtp.remote-ip=74.125.82.177
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58957606A320
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 05:54:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 58957606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=Az9xVXNs
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-36681e85e87so699787eec.1
        for <linux-rdma@vger.kernel.org>; Sun, 25 Oct 2026 22:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792994087; x=1793598887; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q9T0zMsyFxP6+f5YwGyxdVkCFKS+Sl9bRWYPaN9yuOM=;
        b=Az9xVXNscG3Ck2w9ynNUu0tuCGQR/ioLw6wLRtkWnJEfRtSPq4Ywm/Ips1yXdNN0AI
         Xjj9khi9Cg3v44tlvQl6np9xYQJPO8G9yusr7MdnHgF3e0IdaEKYZaaRxUT/coaeloiy
         5s1hAVBSp2BVOJBNTH91zhkz6RVQGNWU22geHRs6MbrgwzkqzizIWwKLfycyxB1b+gWF
         buMSIpnizvyc4F/xb1+iIKSc2YoQhGVjHzhsuu9IWY7pn3dc7ElmuGhvoij+NyZesvtj
         gQGHfjCxfc98lu0hxwZH62DzogMvLSsa6Uxzv3pOzvSmdCvBznHL7qsrYNAaZo32PiEs
         lqpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792994087; x=1793598887;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=q9T0zMsyFxP6+f5YwGyxdVkCFKS+Sl9bRWYPaN9yuOM=;
        b=dawsWFVLK8vuu6XmQVuwQyp+VoXmtbN88GvWrxVyhdkWenOZbQ3a2KT9k3jX4MdtVF
         yNs0BpHzp6rPbKcQdLC+mbjEKECwJ7MX85tZpm3UJqui0ZIXEK0DvCL+CNdstbsedZ9i
         EWKmFQOcgqzhIvRZR1djCS2LJnI1/H9w3Q2emxnmGwwWX6xprZwkmdRrXW6kRMsflaon
         UPfIm+ake4sAHBBfnnqHNerSuHIL7pkkD5ExKhwIE5G4JYcuvcdk7krOEhP9IICsUbNo
         8pT9WVbtXPtyWLLifYgs18lc6CVBygdoJH8A2iNucT+rOO/F5cJXQ8lwp8EECDtmxCn6
         kUmA==
X-Forwarded-Encrypted: i=1; AKwUvBwCeaj2hmQUyaz8MQTbv5AK4e8mILplKiRqTtJKnD8wH5HxVJ9nO1ol4FmmhqrR7qjX+w2q49U9arKG@vger.kernel.org
X-Gm-Message-State: AFq9FYI0SJIFDf/4dIyJeg9u6Bm2sqrZajNpneO4ExVR25Q+ZU5n77KX
	TB+MOiv+hLnLgZ964iq8cquIVzr0qPXM2stI4N+ODbbX36Gi6NG0KAPw3cD976soyi4=
X-Gm-Gg: AYBFou2jMOtg+VkNQkQviXoJ8ifOMdyBG8j78lO5aeP5UZ/YN3zLa4kJWI5NoX1Tm6s
	j+ts9v56QTPtD6KM06/WzVLUzYPnxntgkYPITc5ruazcC0d6S+BDowXVPQjUkSjxgLGf3WWhjcV
	Rr/OPwTyzKeRes2JMbBbfy2ukRCc50CjWP+Fuwd4iFcZ2eDk26riIP/pKoKhfxb8mxBaKTyfX0T
	TlwlGBrSVBqNrwARn8PstbM4dnYcUlkWDGulUc+TzbijWJpkOmweoiweSak2P4209x1xpCRWInV
	mmZYI8SU9vY88DDuOCEHbsE5LO2l3h4WWi0B3lP5R+yRtUTyrW/PeiCZysxbyH+QTyWuQjqUhZi
	nGNAze/cW5Mc8kQLILXk5xBWivB774NmGkmZOK6DgPFy7RWDa8SH4VEgG9KXNvftakTqZ8LYIyi
	OcwXoU36ViTwjQkJAAmTPaRyu3qz7OSdbSGgTGMtGNdcXI7Nwdoq3ytPKAVgGdsL21aV7Dx/dwQ
	szlr53cNWdfobAFn2VIcEzEPFWHMNts6xnlb9l7YwoWcE0x/4YbWZeOvTQjMIom7/uJa58vVabc
	mGix+H9h0wjswvwT2CjtIVPuFW3oyWEmLJUVUAFZ9qX6fW+s
X-Received: by 2002:a05:7300:599d:b0:351:2958:1740 with SMTP id 5a478bee46e88-369e84e5603mr9189061eec.37.1792994087240;
        Sun, 25 Oct 2026 22:54:47 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8d845ddsm22290613eec.11.2026.10.25.22.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 22:54:47 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v2 RESEND 2/2] RDMA/srp: do not DMA-sync a receive IU past its mapped length
Date: Mon, 26 Oct 2026 14:54:30 +0900
Message-ID: <20261026055430.406487-3-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261026055430.406487-1-yhlee@isslab.korea.ac.kr>
References: <20261026055430.406487-1-yhlee@isslab.korea.ac.kr>
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
index a85d28b95306a..159d6b6aa93e3 100644
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
