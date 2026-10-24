Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792859355;
	b=5QIzKhvtLRHorKwnnQyaUjjARxBnSEdHLJAK8BMUGbJxoFOfxl6pe6Dz64HOA9UHK8zl
	 BFT6tt84MLCdFJeQfPGAH97BP6dTt1BO9jfoYBj0SLwneoODCJ4bTcjO63xetDR0EI8DF
	 eYA10fEJNy3Drj+cA1cm4FV0FwfpNrvjA9Bq8UDcLepVh5npfUaBUp6HkvQPXLCl2a/wn
	 zqXlgbUxleDuy31dwzL7k04KVFic7LGGdYLTWxT5+799oyqplqm+ypGgoWqAejqgm1NS7
	 t7CtQn675OL8U+tBbsHNVuiXeQejExB+wwC/6C2uIU1vWoNYIHOv/ltLKoynnOMwNWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792859355;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3Zr+9PKhsHKitydNq+F1H4SskHdpJTPHa4hy7WVcL7w=;
	b=TCLyEWqVMV34SIDroV5/F+PzWuNCLUaxP6ha+cnEl4YmQjj6PP3ON2Bdm9f5Lg8vCnRJ
	 axZcrbDMfEgzdC7WFpE5DNVK0ZDBu84vOlFxeasZ3wEt+tr/EFNGHOzbBPCqxyM3NTupK
	 OcB87Dmk+BxHQYIO2VPwBA+6won+gI1EydX96L7f1Ind4cd8CYIU275wGelSUALQsvgrR
	 AouIelMZ37cpFyU0z5ozeVI8nhvykOSaJgJHvOyD2XuMMucECzY4RjT0YXGOPjx++vUtG
	 1+xqZ/TvrtEUttfqFBbf5u0rUnY7ycQ2D0JC6qyvjYsX7AXc0Dqcd9sREE12C10LRNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b="LH36/ts3";
	arc=none smtp.remote-ip=74.125.82.52
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C2E606A321
	for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2026 16:29:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3C2E606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=LH36/ts3
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-15ea896ddc8so2973752c88.0
        for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2026 09:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792859354; x=1793464154; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3Zr+9PKhsHKitydNq+F1H4SskHdpJTPHa4hy7WVcL7w=;
        b=LH36/ts36VlL5kZOCkNevpeH7jEyoxgAu8xvN/bAgfRdim+a2kdIfL1nWOf/dFJ1ZZ
         1hLqzHMtWIAZMKvHs1gvc6kfz7ThZNY3lkvtPthr/PURraZcwhjQvZWIpe1fLnqzQIF+
         vJ5FWwUNyxGyxGksDwlU0+YpQYHsn7DV8XCB434XPNWO77QF976M2e7Ti7ck/+k0w3ve
         4L/yq8bW/w8tqGbPYgpjhC2km+tedrMJAxuXmileVgCXpg1NmVL4Sl2P6f33n6DWrAJb
         CmKy6Fva4Fd4cMWf1FPNaKusD+r4PdJW73bycrt3bLM0MyyrbNsL7QvrEoPMOMruP/A5
         r21g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792859354; x=1793464154;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3Zr+9PKhsHKitydNq+F1H4SskHdpJTPHa4hy7WVcL7w=;
        b=kEjJF4yTf7iPQvDutHvwdVOzOClhINC0OhPevsN9NoqysiNYGLtgNv3wSzSNOTAwTv
         k41upp8BeraXd4bpms14oP57TieHbw+3wK1Ud8rOk2QGE3TxMqFPUDkign7EvvP4KjaF
         2ZnPzba1SXHwG3SlBIcn53G9G+2elZXu+X2WXHIlURkI66H1D9+qxWa+eqfh54F1ucxd
         hdwI+U+C2uaAH+zRqS6vbRvWnktko3ThB8aS8VQc6fSdi26hfvGsaBnEe2h1xalAQymn
         nF8rWASw7cW3gA5YZCOilrKO6FNgztnrRZPDk20NMymoiwHvNdVWVKWnL2jq+/D7N2Dr
         MNsA==
X-Forwarded-Encrypted: i=1; AKwUvBxnyBOX2TqpmyI/GIelgJLsJHqvqFiuHfEuyj+nGevhX7KOkYeMaLDTrd6+HuuWBnAF31s5Lz9RGBk7@vger.kernel.org
X-Gm-Message-State: AFq9FYIUR4QFn/Ay73ZiWoVGy5NBDw5XUf1gFnfFSOF7wA6rSkzQ63qa
	SoH6oKNP5ZP8IDVdhSlTztbxtEzqzkLATvC+Tr8gEaQBXolKc8eStkCQyEUWXFqi2rk=
X-Gm-Gg: AYBFou3ItLrX7OVQ2idbGvFiKT7q4MlrlrGSD/h1aTwClweoFdM4ATkPhzVUJ50V1x+
	7TeMURML5rQbd0i5256DznJYMjufEqYRzE6wRFk8bE9olCqPreve2fufg0as2fMvJaEoXXQvwLT
	v4ulhKnUEyU4eKnq3wyvgfssrWGDztPKQ2FePPzOA2uDsb94EV5F8hn3TWABZkDA4lwm+BwEVR6
	XkMl7Yt3Z7fM9E3K8LeA7o5TeEyQkX8krXSlVXFLuzCTdGpxnWMYw7hkXyvTrS30DXcfJklejun
	jZHgfRJekA/KoZS8JuWzcQDEVDBsNog+m+ZWkAQZ2nbIxDdg1r/MKGD6GkeG5/D3HqwjuHaYE9H
	WBfvf4eIYooUkBfJjb0yYkI09EWzRpctDxflC4ntOBxDity6kc7Auey/hZOLWJF7LqvcV/L3zWK
	6jr4zfHTRcJrxm3caLnZsXG3ZFxx89/2uj+uuLqrWlacsm0Josm03mr6RRLnyPFzJEOy6G938Mq
	GCvHA6THgitb5ul+rkEb8lcRCM5ZEofGwOQPkkqsk6E/WNh1+zuwHc2NmpVsj3YYP58wJRZ4d3Z
	kmVOnxLV8QHCiT9UxMVdsOcUwBCKv7qEdvZ5H+w/NKx4ps7f0Hxc/ddJa4AbfLkf
X-Received: by 2002:a05:7022:7f14:b0:150:c9c5:1ce4 with SMTP id a92af1059eb24-19928f1541dmr3135285c88.6.1792859353934;
        Sat, 24 Oct 2026 09:29:13 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:dba3:be57:a674:a67f])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-19a3736d16fsm7192350c88.12.2026.10.24.09.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 09:29:13 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v4 2/2] RDMA/srpt: widen the indirect RDMA context counters
Date: Sun, 25 Oct 2026 01:28:52 +0900
Message-ID: <20261024162852.3528224-3-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261024162852.3528224-1-yhlee@isslab.korea.ac.kr>
References: <20261024162852.3528224-1-yhlee@isslab.korea.ac.kr>
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

srpt_send_ioctx::n_rdma and ::n_rw_ctx are u8, and neither of the values
stored in them is bounded by 255.

n_rw_ctx counts the INDIRECT descriptors a command carries, and the count
guard in srpt_get_desc_tbl() admits data_out_desc_cnt plus
data_in_desc_cnt, so up to 510. At 256 descriptors n_rw_ctx wraps to
zero, and srpt_release_cmd() frees the contexts only when it is non-zero,
so every scatterlist and RDMA context the command allocated leaks.

n_rdma is not a descriptor count at all. It is the sum of the
rdma_rw_ctx_init() return values, which is the number of work requests
each context needs, accumulated by ioctx->n_rdma += ret. A handful of
descriptors for large transfers can pass 255 on their own, with no
unusual descriptor count involved. A wrapped n_rdma is then handed to
atomic_sub_return(ioctx->n_rdma, &ch->sq_wr_avail) and tested by
WARN_ON(ioctx->n_rdma <= 0), so the send queue work request accounting
drifts too.

Make both counters int, the type the values they accumulate already have.

Fixes: b99f8e4d7bcd ("IB/srpt: convert to the generic RDMA READ/WRITE API")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 21264264356a2..17d77818c2bc3 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -959,7 +959,7 @@ static int srpt_alloc_rw_ctxs(struct srpt_send_ioctx *ioctx,
 	struct srpt_rdma_ch *ch = ioctx->ch;
 	struct scatterlist *prev = NULL;
 	unsigned prev_nents;
-	u8 n_rdma, n_rw_ctx;
+	int n_rdma, n_rw_ctx;
 	int ret, i;
 
 	if (nbufs == 1) {
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 506c11b843593..d9061aa65c1a8 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -223,8 +223,8 @@ struct srpt_send_ioctx {
 	struct ib_cqe		rdma_cqe;
 	enum srpt_command_state	state;
 	struct se_cmd		cmd;
-	u8			n_rdma;
-	u8			n_rw_ctx;
+	int			n_rdma;
+	int			n_rw_ctx;
 	bool			queue_status_only;
 	u8			sense_data[TRANSPORT_SENSE_BUFFER];
 };
-- 
2.43.0

