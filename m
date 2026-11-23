Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795444645;
	b=ucqWt+Y8sjx5nDFvECEWgR/UdGj42QxGjI5FnggQzAzOwuvScD11kw4xCFXBPhYF+swh
	 cQ+zRhZLnIpoEet5/QoUaTtd3aaRFXGUoocz0yC8NrGVz+a9A2wUYEZmoUuqdWo9humN3
	 Q58ehf/BgIdBGPudehtSUx9wF2uTNFkKaZmCFHYYdwoz3zxnxpkNpFFTGiRcHP4LofpJC
	 ZWJf4V1zd4E1194rhX5Ykb92IihBxweRb1BAME3LCCimwZJD145nDUaPBk64z7MDR207Q
	 8es8457AVlqoxj4ZiN3A65Se/Su9TtV3THqklT7bUBeXc7ROAt5VVeMdiDjqCdHAcXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795444645;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=T0GcjTvPxNhj2FA0VfGvpiGoz2Qu+Yy/ffPkRhkK/NI=;
	b=Mbcyzb8AokqSw9Uaq2EzDZvGfLKYPEhSHG1Jm3SW/QsefKQZYLKrpmzYUiHEpBxZIXiZ
	 RE5nFnrm3LHSBrzwRpiS0AoqD2RXNw+0uyyezD0Si7/QjEh/RkDVpWJ/Ugy1dyy3425sf
	 shnrVxP7bvZH92sCubmcaZB/fbK53gH+Meobw4bAIBE2sxA4xH7j3i6AvNw8p1xtSXDjd
	 /suA6MZhocPHG9xU6WiF3Rx3DzRlI5/yB4FQShi5eLSqFVyZ/hV1CrNCtWFYo6wiaLTPZ
	 T+Kzcfx7rsf332WOCLRjSGIlVEMl9bKkx0fqRhO0S1eEzKQ1y+8t5sj0+1lK+hjs2Bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ionos.com;
	spf=pass smtp.mailfrom=ionos.com;
	dkim=pass header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=Y7WrGR1v;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1262F606A33B
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 14:37:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1262F606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=Y7WrGR1v
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a35d5d4a20so32895315e9.2
        for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 06:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1795444643; x=1796049443; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T0GcjTvPxNhj2FA0VfGvpiGoz2Qu+Yy/ffPkRhkK/NI=;
        b=Y7WrGR1vf1OmIxdaPFjfF08peUtik8GW+zDTrUIZRLaqSfyW6iu898mKzvQVHwsXI4
         mszvQRs6RMNXhfcI7h/Ow/kWv2fZ28+E0OHvtiKWrtHg4IESGbC3frA+YLYT3gSA+rXR
         FowiV0fkEWsIN2PKUwzo/l9mZ8z6FeLF96R2T5ikSyoEzz4jrIjpA+yc9eV0K4eJ6HB6
         QPbT0s1T19f5RK3+rLLj314377SVBXO+nP9RAu42OiGRpt+bR6Ev2Pb9pweUsArQT4UQ
         7XC6PWMIwcAOg06wZ2pAVJ/u5ZAPGY3Rfdwzv6lujlhp3cJy7oRUsI+LqX/8rn/GvzWJ
         WhGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795444643; x=1796049443;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=T0GcjTvPxNhj2FA0VfGvpiGoz2Qu+Yy/ffPkRhkK/NI=;
        b=uo87UFokTHv7GsMk4yuqJzzhRljpV7U2yvoePjuOM703f0z9k56zXmdsRGAR81ZVWL
         PP8WmwhfXb/ZgEus7nCV37VSPAVI8JS5m7NoEqz3yAs7oZkPQzHeBIgH2nDYEvnqpsFt
         iBKU8ZrwGMSAsduQsDEUwoRAxkjdTfNv/BvKy57MOQac2TsBqkyoeNE/gJEZXo+NeLS4
         E1SuOa+9fXlpZN9UTQqJqHh4eIxT3fJkgZcT7oYFrG5BU4BGVCTMLA+qXvgWAOk+xexE
         /WEVCoAwdesUqfmN8nQcYKynO+HI9y8sV5OaGLY2dTnEdocGIcFXwSdBvW9oAL8uvJ10
         20vg==
X-Gm-Message-State: APuU4Z/IiJxCjXfm1xchoxa2ztQGh1rV4zxWzRp24mEcjPMqnDfiK8Ar
	/5ehNPC7uQB+g6KOGAOVaSVRHExnC0KX7neY3WxTn79rAUEEHMIkhwxFvB4LGGbEG/Tl3YeTXVO
	H7sp/1G8=
X-Gm-Gg: AZFdTZfm/YesqzoXyX35BorvoQoV0W/G+oL6E0iMSDRz4fN7s2WP+Qfaf1wP0JcNMZW
	TjUVcjFWuL5YY++METcgvfoF7nDtHBbw3C7udJ7yrjgzHlWmbg/D8lwWwq0ZMrhpSGbKGiauyVK
	94JfEggjd4XHQWIYBLHoK2O1Wu0Ip3ewkOpB/wwxTZ2wowBeLJhP8f+fdnbe912pkuRYmBzFGPa
	LSC7qnGu22u0z1F1Y3jkmiLYPRKOFhR46pRzZ7gb+Lv1ctooOv3VwKxGqBemOFtpvzOQ2hFry0w
	HcnK1QdfLQSJjoa0sx0fBvGTzkR1FS1XuFlfUm45ZrcJPfCW6Lx+5qQKg1ZEqOMFswhQy1xGZcJ
	QxgLGrEQrofgJQtQpdST6t6iD4H8p0tPc8N5aGe5O6kp0vMUwcHxA3r9cz2ZkhkI7uDHX1MwWH+
	D8LMspls0jLDn+1A87XE40Us0eWMx5vb5AD3vrc0OFDXWZaHRag5EIzobAmB0KtkRJzRhZbLcys
	QvGRu/4ItzXth677vQ13f/xqP16thp83mKaDiVLWC/SZQqrTJ7mSMm3ezBUgPitWMD+mz30KvrG
	EDxlWGEDMDWs4iLOInr1cbS44W5ClDCPchU6YhkReAGi5WA0bOsjzfRch9uMY7rtS5Aoxyz+Oft
	Q0cc5I07qBqesqwH8s+q+VI9gLPzsVj3inCpm8GS3tVqGxSyb/IyyOTUAGEsh4bDwZ8DmAWgixi
	KVGV62nAl5ZMhTkwvqeeFh0ALyzd4/1o/Aql0=
X-Received: by 2002:a05:600c:3f0a:b0:4a5:75d2:c104 with SMTP id 5b1f17b1804b1-4bb8880cde7mr228687155e9.22.1795444643443;
        Mon, 23 Nov 2026 06:37:23 -0800 (PST)
Received: from lb03189.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906d6a13sm172562325e9.3.2026.11.23.06.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 06:37:23 -0800 (PST)
From: Md Haris Iqbal <haris.iqbal@ionos.com>
To: linux-rdma@vger.kernel.org,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: Jack Wang <jinpu.wang@ionos.com>,
	Roman Penyaev <roman.penyaev@ionos.com>,
	Md Haris Iqbal <haris.iqbal@ionos.com>
Subject: [PATCH 3/9] RDMA/rtrs-clt: Trigger error recovery when posting LOCAL_INV fails
Date: Mon, 23 Nov 2026 15:37:13 +0100
Message-ID: <20261123143719.938876-4-haris.iqbal@ionos.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261123143719.938876-1-haris.iqbal@ionos.com>
References: <20261123143719.938876-1-haris.iqbal@ionos.com>
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

From: Jack Wang <jinpu.wang@ionos.com>

When ib_post_send() rejects the LOCAL_INV WR synchronously
(e.g. -ENOMEM on a full SQ), no completion will ever fire, but
complete_rdma_req() previously just logged the error and returned
early via refcount_dec_and_test() (count goes 2->1, returns false).
That left the request with need_inval=true forever, the rkey live
on the HCA, the DMA mapping pinned, and req->conf never invoked.

A subsequent reuse of the same permit/req would call
rtrs_clt_init_req() which blindly resets need_inval=false; combined
with the still-live rkey on the HCA this is the kind of state
mismatch that has previously surfaced as LOCAL_PROT_ERR.

On synchronous post failure: clear need_inval (we genuinely cannot
invalidate from this context) and call rtrs_rdma_error_recovery() so
the path goes to RECONNECTING, fail_all_outstanding_reqs() runs, and
complete_rdma_req(can_wait=true) reaps the request cleanly with DMA
unmap + failover.  The refcount path is unchanged on success and now
matches the success-path early-return shape on failure.

Fixes: 2ece9ec62e5b ("RDMA/rtrs-clt: Write path fast memory registration")
Reviewed-by: Roman Penyaev <roman.penyaev@ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index de226e6ba124..5ef912a472cd 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -436,6 +436,19 @@ static void complete_rdma_req(struct rtrs_clt_io_req *req, int errno,
 			if (err) {
 				rtrs_err_rl(con->c.path, "Send INV WR key=%#x: %pe\n",
 					    req->mr->rkey, ERR_PTR(err));
+				/*
+				 * No LOCAL_INV completion will fire, so the
+				 * rkey is still live on the HCA but we cannot
+				 * invalidate it from this context.  Clear
+				 * need_inval so subsequent reapers don't
+				 * wait on an invalidate that will never
+				 * happen, and kick off error recovery so the
+				 * QP (and MR) is torn down cleanly via
+				 * fail_all_outstanding_reqs() ->
+				 * complete_rdma_req(can_wait=true).
+				 */
+				req->mr->need_inval = false;
+				rtrs_rdma_error_recovery(con);
 			} else if (can_wait) {
 				wait_for_completion(&req->inv_comp);
 			}
-- 
2.43.0

