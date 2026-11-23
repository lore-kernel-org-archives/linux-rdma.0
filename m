Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795444647;
	b=Rgfe9hSOU85vFk8fjMybv6fKANVwid/PTpO3tT8rNYlxiWoqwH19TSFmTgxD0iIykaGa
	 Jhc25dDc3L9qHggrCr2Vg+FHBSyd6ENjCGCpUB4P4MhsWsm9uyZorXrs1c7NjIMzI38Ll
	 UmZjiYhN4SLT3IKkt3Iz0Tq40DT8a/lG/qojgCfR01gs+DhLnH9BmmP0Y/5cQTC2knVpr
	 /Kz1h1fh+bnQveMv0OD8RBOACTu9hFdxv0hdFpPckAs/el5sM93L8ewa+qkuBuRITEjEs
	 76AJRYlwHrPwMlzH19eCAGXlAeSN0Lab/WkfQgLLC46ag0v/Q6Di107uOyrzzMD9h0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795444647;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=+/URcS/PgRWRcHLsYi0d3E1Tt2H5uOxLYR7uFYNaFco=;
	b=NIm7uJqR80+wtDxq1Yw5MbCLd+M8b6ZX9lgpUrK5uR8ti/DnYBdFAK08+l88D2F/FSd+
	 BR5hTqdxz1/Cr5y9k4ScSQYNkyIKYNtrOTqNqXoco7Mf1Kh9JkVopaoWrdQhxLfHGvQFx
	 i9egYoRvblgF2IcIi6YShZV31gXe5NGR/ASCXmQ3+zOLWKN0QoMtp0979RVlkQqwKjEfn
	 RqMVHTcKuFVyUYqYz9Ic0EZjYToCc8FqeMDJ4QpU4z6gbEpJaTFsmuEimi+SvaO259sn5
	 wvc7oY2duret8MS54QurLTwxHK044h3mxWqQag6UMQn9CDinqQRB/waK6bzOoe3ooww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ionos.com;
	spf=pass smtp.mailfrom=ionos.com;
	dkim=pass header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=WnDdQT6M;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF1C606A32C
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 14:37:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2DF1C606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=WnDdQT6M
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4bb72b44a97so28567345e9.0
        for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 06:37:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1795444645; x=1796049445; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+/URcS/PgRWRcHLsYi0d3E1Tt2H5uOxLYR7uFYNaFco=;
        b=WnDdQT6MF8R3aLvx7XhWkqEZlB3JmK7dPMid56pMXcMqf1t82TFARl1M2hMf7QoBIV
         Kaj9z0rFZaSgjNr8QBLH1oLerIU/T5KaEr5KSMLloewwdCR1MPzDFr/SvvELhTIDUHO2
         NbbX6KrcYZnloaPd0JDUJ70ltWRMT/MWmB2knIDgporcvzlVzBV5CR6HqZgt0G71xfSd
         EeqdzbMLMIbseNTaP/Xg8K/M/HGTE2RsxbjuOgHMnDC5SM4vmstQyv+ZBW7zPza5/M0Q
         Np4jxRnecJwQ2Ej5nO95m4mZ6sXsaVt/zGzhveDT3vbAPEm4i81gveTrNSM7P1p3aS93
         UJrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795444645; x=1796049445;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+/URcS/PgRWRcHLsYi0d3E1Tt2H5uOxLYR7uFYNaFco=;
        b=vIqFNc68t+h9hhnYuY/8EX8kfPCx0cSCw2uljwQ8BFHDrMyMM8ea2tSHgVrPl8VqfO
         DvsSPtT/4F+8C+Y3SvK9qWUfUKDNWZsycotMfzhRfNiL+SjuW6gbp+gvJT2bFBvAHYLR
         mOH1qX7v2Qm3IVk776mmC5BPadXt4xPHYkb31EGqR0jmsb3s5IutauSwBduyZ7ijwP+8
         qFI1qf4e/70k2gYjf2btcXFt1W9b+RFiY9W++adoaUyx4mbKLUj5HrwK5rXvuF911EH9
         RZSbwrnk7shUVZL3Ms+cfkdurnVXPrS4Yxaw6OVcHbRh0uDjA4Zn3dd+j5E7ZcfErldZ
         AcuA==
X-Gm-Message-State: APuU4Z/rYAhroUgXvKAez0fqaeAea+gqU0AWGuZ0W+Tw+u7xLE7FdxKq
	GA5lm9stPlqg58HI7NhNJGVSYLNg44Tl/JPSNIQFKn25eW0g/hBDxJyQxLRz5g0WhHYzbLj3l6S
	sCDQX8SA=
X-Gm-Gg: AZFdTZe/zpyFJH0py22HGcdvoqeQZLc3qAk0Q3YcFv7jSvNYaKL9N6EAi7ZHTgF4fic
	wQByD5jD0Poy/MkqpXpoUAKLVvz5jcpWklUvneqz+mQqy8FZXZmH6lpvXQKQr581TO+YU8NfJbM
	tA4IHhrw1tWdBco1xK54UxWi6MrU+wCT1WwINzXbSF48XMYS8HAYH4bXhyrAePJ7aeVZjWESN0u
	XJ0My3k+rOkQweKhcWyq0+tdBXbbszf85/9w3/wNP9H4DxW3DNkBu2dG0ThpUZbhQjk1tySVA2u
	fKX4Cs1PzphA8jeR3Tvf2PIOXJ/4WfWiWsKYGPaFfElR6PjdlnONxNqMMyU8sSSWTqaUCm0qcZb
	HezYTb/RgY8W93w0or8/ZafsBxcYeJXFgBSVfleJhN/hQ5YOnDE09gJTLJByrIaKG8fHYnHuPZZ
	RHKdaQB1qSjZpVPBRENfgolhdIQB3VqRhHrOB0Nc4cmTcTyztKHNOMZ1i5mdwRp+OW57pC5jpBJ
	HgC/LnGGjnbzMPA98V9spiCBaWs2pofwiQQ2APXdI/hX5sqyysEadnTksM1y/FM7uDbAW2aJiII
	/tJyQCr/yv77Nwu8tVUZCa9jDqxG0VdBj+c8kZuMOixPQ8nWAPe/jb07RdTNfZJZjvq+LSF5WgT
	MMaqvnWsptDVqmL+TaKZeoVPQlxJtObxGAZAYRc/dGVR9wZeMyHpo1GmFAoX88FB1MsM4GF4pk5
	U7NASg4gt9V8mOOejMX8i/nGOLyNKFa0PMp1o=
X-Received: by 2002:a05:600c:64c6:b0:4bb:6fd3:5aaa with SMTP id 5b1f17b1804b1-4bb887c30fbmr212168515e9.3.1795444645483;
        Mon, 23 Nov 2026 06:37:25 -0800 (PST)
Received: from lb03189.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906d6a13sm172562325e9.3.2026.11.23.06.37.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 06:37:25 -0800 (PST)
From: Md Haris Iqbal <haris.iqbal@ionos.com>
To: linux-rdma@vger.kernel.org,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: Md Haris Iqbal <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>
Subject: [PATCH 6/9] RDMA/rtrs-clt: Fix reconnect jitter being applied in milliseconds
Date: Mon, 23 Nov 2026 15:37:16 +0100
Message-ID: <20261123143719.938876-7-haris.iqbal@ionos.com>
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

RTRS_RECONNECT_SEED was introduced to spread reconnect attempts of
different clients over an 8 second window, so that a major network
outage does not make all of them hammer the server at the same moment.

The random value is however added to delay_ms, which is already in
milliseconds, before the sum is converted with msecs_to_jiffies():

	delay_ms = clt->reconnect_delay_sec * 1000;
	queue_delayed_work(rtrs_wq, &clt_path->reconnect_dwork,
			   msecs_to_jiffies(delay_ms +
					    get_random_u32_below(RTRS_RECONNECT_SEED)));

With the seed defined as 8, the jitter is therefore 0 to 7
milliseconds instead of the intended 0 to 8 seconds, which is far too
small to stagger reconnects and leaves the thundering herd it was
meant to prevent.

Define the seed in milliseconds, matching RTRS_RECONNECT_BACKOFF and
the unit of the expression it is added to, and reword the comment to
state the resulting half open range.

Fixes: 09e0dbbeed82 ("RDMA/rtrs-clt: add an additional random 8 seconds before reconnecting")
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index c059d69c3e5a..54d72fa52cb1 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -26,11 +26,13 @@
  */
 #define RTRS_RECONNECT_BACKOFF 1000
 /*
- * Wait for additional random time between 0 and 8 seconds
+ * Wait for additional random time in the range [0, 8) seconds
  * before starting to reconnect to avoid clients reconnecting
- * all at once in case of a major network outage
+ * all at once in case of a major network outage.
+ * Expressed in milliseconds, like RTRS_RECONNECT_BACKOFF, since
+ * it is added to a millisecond delay before conversion to jiffies.
  */
-#define RTRS_RECONNECT_SEED 8
+#define RTRS_RECONNECT_SEED 8000
 
 #define FIRST_CONN 0x01
 /* limit to 128 * 4k = 512k max IO */
-- 
2.43.0

