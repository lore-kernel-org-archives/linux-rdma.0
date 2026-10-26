Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792992047;
	b=JFtLKbP6wckErxqICbqAHSmIt/KBRVcPymA2zh+X1XGxfnAUlhqArZy0b04szhp88aUx
	 46GwfG1hZcnlRMv70KMZJIntiEpANOVbaiUCcEYHoWKLSVscoFg4VycelCnyrGNhFop7q
	 gyLtnD+HmiHiE2O5YCZt3bmdNRE4ucTnidXCFIsVKmoWdulB4t8FRuxe30f07vz4mEe+V
	 tvTv+VpsIvf7zA2c0E+L8eE4Z8udOBhovynMoX+qsx85rnd+iA5JW3tkXg/UC8LzwOv4l
	 1+KWOzBjmLYNQnI9oHwNGHRXk0JJ+n8U7VdrjavGaQjCDVoIHwg2175Wh0oty4WtDrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792992047;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q9T0zMsyFxP6+f5YwGyxdVkCFKS+Sl9bRWYPaN9yuOM=;
	b=qMp6Nr6r6FUL/RqNZspCshff5u46RjgYn3fupSLoSduX/te6K/d9nXAN53wTTwZTgeQz
	 qJTXTnsh5k1RpQK6/GXR0+WK7HufA89SLHKe2dfGUO0nB51HcPOZcjMxmBnekgkx/Wo9o
	 v/fuEZM6kKEB1M/Ln2HCuqc+y46UgQYyzGV/s2im5KjP+8QTRlVHYo4tZw4fMB9G8FUju
	 uTX7AXZ2ZEkD4s61ssh2uLJCdRYbZebAipM/TM8URr3XjQ52zH+Q+UrEru6Ms9xm6vEPD
	 4n2fh7RrQsp8/hCds5AOSilcgC0I2BBCTIr7WlhUj5tUNW95d1CIXpxJxjfmrLNvHjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=Q10QsAWm;
	arc=none smtp.remote-ip=74.125.82.171
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDDF60A2600
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 05:20:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4CDDF60A2600
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=Q10QsAWm
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-3535a54bed9so4142170eec.1
        for <linux-rdma@vger.kernel.org>; Sun, 25 Oct 2026 22:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792992046; x=1793596846; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q9T0zMsyFxP6+f5YwGyxdVkCFKS+Sl9bRWYPaN9yuOM=;
        b=Q10QsAWm0srF5Q4r1QBLb0Bzd9FxZQkHstgbsLD66/+S7a9K/1k3l2feX6J9KttYE6
         b/yBLxELzCRKYUCnTvkotE9pJZ5EVhOjCETTqV0lObDHdupmFFayQ2Fydwqyb6NOneAD
         pVhMjOA5TrCF8R301PrTqCX7XJfEWYD6C0+GHsMYbNGQpuzKHszwgyp4D/Qup5sGq+zB
         Q+gsVBy4iGqvF86HoaXLm5r2LTlWqZUNhB2JJFP8uF2gWHYkc5GT05A0f7v9WI9dQnsu
         UZwiW6dNfPlt12iTHYCiIWLxiPXm5sU1UywuzNhYyAEm4BiR0AmUxlZ3xQVqLaKqD9a+
         wcVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792992046; x=1793596846;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=q9T0zMsyFxP6+f5YwGyxdVkCFKS+Sl9bRWYPaN9yuOM=;
        b=v3TAhTO8fIVRJWEeyzrgVq2F70im38N8ES/6cD+aIQNp0XVp5LlQxMafMaGvX5Le7X
         kGEjHoZ2T4fPl+0vHMGI/8LdaECWk1rtn41mOGfE5fHlxrhUhfM7GZQ5Nrq1mNb9HX8S
         Dxc9y3gpQcxe1nsdugbBNLmVkeQaFqR0D3ZhLn/06goHuNr4YtZMzUFrmYV1RGwo0Pb3
         qp+N6Cly9crY4lwD+Ea7/MoeGvjLgFD1fJXRzW+vT/UHmOwqRZh47CXllA+jSgFXLaA4
         SViEyMU+54RIDBGRnOnlx/gbWkAky1nWujPdv0Q84IobT/WEm2TYkdRXFRyQZHcoBzdT
         T6+g==
X-Forwarded-Encrypted: i=1; AKwUvByIGDx9qZc0sb4dtqfNh2Hp4nOl3P/hEv/I8xUI3EK6Xe1zRL26aXpWhPwVBgXomNW5a300ZXhV+49w@vger.kernel.org
X-Gm-Message-State: AFq9FYK+KNh9mGaDKm2QFapvT/y9XewIKJPFZpwlhGue14QqD/VIRhhw
	Oh/m0JV6eNx+sn4no8kQQpa9DR9qzG7KtL7eZB0x/Qxc2ZZiIOwwNuqTkq1rjhlgMjA=
X-Gm-Gg: AYBFou2KLD8L/bTAnPC0m+BPdkgvb9fyGnyOOF/PE64PY8u7uaJSuRyNK2qqYL/80Im
	Msjj/sJXjVAHbgjQEFzHe8Djx+SLxQuH+eMAaKyRLysm6FITSBgWazM1pk1nkPxDF29e6vPaqDj
	hvnndvNyG/3C3Qw6VxqHwX6pKrQmO3WledUm4qRB3Koi7WN/JiHEWT2t11Wv5Uevzm+2Yi4TNCv
	OTd5gYcVADEwaQ6owGBbWuuT5ayXezmNXixPi95UUFQb10sLEiF1Mn28CaRfwcrYOOmMHLzXbJM
	Cz2F3ul/pjLDEDwZO1UL8cgymSMGQ3oc3atSAtmSCJr6QhiRrFynJPmh3UxkNJArTmGcpFtR0zJ
	+TXmCRe9w7TxjKlx9zbefcvBVsuCZ/agpTOzExhfjhg8vB4sFlsgYrZUHXgDVPD/A74EyXZ1pAA
	B3ltLeybTtK5dNPIRc1urXnv2HtOCZ7FdxsSQTJYLcxYIK4pKdfXdSwuEsgnIZRHTfMk4Kshbu0
	cGGJyaFi3lCRCiJEICQJ0Oq+Fukzgh2JnX/987MFIqxbUJGjDHenyty7f6ZZ2KZ6KBHtp9j3zRe
	+4EkYqyhcMdzco1x3i9yeWedY0GFRDeM5urk0oHJtQAieLf5
X-Received: by 2002:a05:7023:b83:b0:14f:8e70:fad0 with SMTP id a92af1059eb24-19935905e61mr10191002c88.33.1792992046172;
        Sun, 25 Oct 2026 22:20:46 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-198a0f83cedsm26765774c88.13.2026.10.25.22.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 22:20:45 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v2 2/2] RDMA/srp: do not DMA-sync a receive IU past its mapped length
Date: Mon, 26 Oct 2026 14:20:29 +0900
Message-ID: <20261026052030.296361-3-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261026052030.296361-1-yhlee@isslab.korea.ac.kr>
References: <20261025114155.4007867-1-yhlee@isslab.korea.ac.kr>
 <20261026052030.296361-1-yhlee@isslab.korea.ac.kr>
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
