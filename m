Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795444648;
	b=oyeKmFpI9rP24Jbzph9wEupEel/pQd48qCRmLApuWtvMkBfmJ6ECOVnn8/ieAVJf96cj
	 lraK4m3qoxYGNBCqxsyXLaP8fwgGq3e0tTx8DRVd2W6pH21z/gNhIZt658ytCbqs8r2ro
	 kIViyz2RjfOSGQvqDvybgNGYxgciXMLBXiTFKkOh8iq8JHhjVp6HhvVa9J0mAIvHu0giY
	 3sqclmk5okL72mEYZp/F4VX3JgQ5092UYPBJICRMLr+BIW6fxf9E/dbJUmKx2t1Bmro13
	 696xhxqdYDgNgNyF+lAPBl8XANzU9oTzkOHSpXVWoKidD8id96vsYHR0E8nAAyVuXcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795444648;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=HWeuMGR6wrGVpKqnn1AiZ9rjvdrQbQeBx/a490ofF9c=;
	b=cjFxmAqZlSNIKSEuJeRPAbzjwIglOZXguKGXNWD+oguqJBjfbEvuywr/qFJpdOPyDnr2
	 ckI4v49RMhuzQVSQPryCUJ3VwWZQBR2c652kpFM5btyU2xXbRV90p/HXqwTeIRuZ8hFJO
	 He+kYihKMoqDCHvHhc37IHCjlruzVH33/q8u2XtEJC19+DrWOOgWqYA6ad2xkiHK07A43
	 RQxU8aH/TENKvWaxbC2kSYKhETksjqA1QHE6/RMw7CHUEsoPLw9imeaFqRoX9oCHHCk6f
	 mTZKfmxeAFbhRTXKo9mUkQiop0Zq3eI6PN9dzd6HI6tmzOP9CohVSNg801wOEvExtjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ionos.com;
	spf=pass smtp.mailfrom=ionos.com;
	dkim=pass header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=UaF9JZAf;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C664A606A339
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 14:37:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C664A606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=UaF9JZAf
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a207b02a2cso24084225e9.1
        for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 06:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1795444646; x=1796049446; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HWeuMGR6wrGVpKqnn1AiZ9rjvdrQbQeBx/a490ofF9c=;
        b=UaF9JZAfalh7iwfoAfTdvv099j51WmVhpInXaXpvHAxx0uKRdKmgG2GRhxNwRcpDGQ
         YmeQ+vA4+b7eD5f+hifxBtWUEt5xOM8Q+USusEU+5pjTea4lZlD2qCAq3PnEoVNbcxd4
         xl8jIryvMVVD4pewQJ4qGQwSxCqEmNk6YEb9pz1JuV4+DWODmPoihdLw9hUYtf0Ng1Pl
         PETRjq/3CoiWqZxD4wRSpoD4UUEr9IrSCmHPEDRHRwAUm1l8TbAzdNzj14T0d/vdVpCH
         uqODhAJTv0wTuDOdwqzoZ9y4cA13eff05PQskVBaq1M1DA+iDAr56KR1kVyUKEsQLgLR
         h4zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795444646; x=1796049446;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HWeuMGR6wrGVpKqnn1AiZ9rjvdrQbQeBx/a490ofF9c=;
        b=BQjJS99zzyB4WaZ1Kx8ZCk2W2Ep2DHpnen1XrPOTOzIZuBY8WfZ7FQqw89uZFDyqj3
         3XWCiRqjhzHdDUEtmX3IkmEeha9Oqs9+AidczcS+BCbNn60lmFtT+YvTP3+rgfXw/BuY
         ZDXp26XtXMdPgNl2XGciKVrW53jAmQPVmBU42/eZgSCFM6AI94fE9v+NuQJ+VymIW9Ks
         vI6N6iSDbSiXsc9hkQaPxCc7rB160iIRPstwg8WsXd1vHZ2+Le6BGgxvnbB7dTZ3CCXT
         XsuNJkvDeHrYmaPWMRzHxEjAt7Lp/eMt5Kq3Mo9Hr4TWJ2PdZJATB7nq+R7iEWxaIulq
         J6cA==
X-Gm-Message-State: APuU4Z9AVaz+etuUJM5pJLLbTs/odEt8fq0nA5Vk8iCnawibpWzmSfj9
	7enuzTI8ZzFpRCvKBf7qPhjxEYj50U50fpXDRrF0rrkpDskQv0dfHNMaT0c1zNYoTXN3ISwH1MU
	BAADvNfU=
X-Gm-Gg: AZFdTZeWVw0ne17/8R8xjDeVPIgvTm5XE/+Bu/uR67ySImiEHh44FLhLmNKadAFwWKw
	Y6Nfsq7JXd/WgOHMU92NVmcWHol3Cjgo+w/kpUZjXLTI3D238GJTIWKNTfeVR/AxKRvBVLYsdDm
	voZywkgeX64KcNArh/I9KqA39KwPjh1mQr7eyYl5OwacWATPD8n5J/BUci6jWO595n3HadbdEks
	WftZidERhACBgDLE9/6FydjaUwh8Ie0iQq0xSCvqyThenHX1gbR23PdmTY8C7P1PQb8vwbe9Xmc
	slLhqgWJ8MqNBp4JA4796Mn55t5xknye3/DYOdQGkH4OoK1suHoy6tLPUIVUV53bDEXGIUl5d4u
	NW5RYmW/AjprhqpsdvVJMLE8kYAVtggVXRUbfypnXvk+awqU/o3uVBlCJhRz4b9SFMFBV/VHzZv
	sKVDQhpn+FFtU0DFelicso2QSb8mPkyjR3Sw4r5zsEtIAXaDrpTzV1ielB8DJgUopp2LOK7DvoZ
	IEMbWCBkZnCYRUTEdQ6RS8GZta4eR953VtjfkAy08qFZte137CZ4151kscUrgNyqRmJjqwFBuL9
	6VDkHRirbID2g1zdBV6VOslP+JQH8jmpi9ZYDYufGmnJGsozJIoR0EUTDzH18M53V4q3R1q9Xt7
	/rM9kU22JZsbyed4yEnT1vJc6UDOyygiAN7n3EATHSpl5DIAcN6nHqe/ATsKEWVtTCFmjUKH83O
	TkznsAWQjbPVFoRBVic78dPYTblT4Lim12snQ=
X-Received: by 2002:a05:600c:4f4c:b0:4bb:8503:69f4 with SMTP id 5b1f17b1804b1-4bb888097a2mr297665295e9.5.1795444646126;
        Mon, 23 Nov 2026 06:37:26 -0800 (PST)
Received: from lb03189.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906d6a13sm172562325e9.3.2026.11.23.06.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 06:37:25 -0800 (PST)
From: Md Haris Iqbal <haris.iqbal@ionos.com>
To: linux-rdma@vger.kernel.org,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: Danil Kipnis <danil.kipnis1@ionos.com>,
	Md Haris Iqbal <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>
Subject: [PATCH 7/9] RDMA/rtrs-clt: Back off the reconnect delay exponentially
Date: Mon, 23 Nov 2026 15:37:17 +0100
Message-ID: <20261123143719.938876-8-haris.iqbal@ionos.com>
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

From: Danil Kipnis <danil.kipnis1@ionos.com>

A path that loses its link waits out the full, flat reconnect_delay_sec
(30s on rnbd, + 0-8s jitter) before its first retry, and every retry
after that, no matter how quickly the far end actually comes back.
Nothing about that delay depends on how the path went down:
rtrs_clt_err_recovery_work() runs the same way whether the trigger was a
CM disconnect, a heartbeat timeout, or a port error, so a transient blip
pays the same price as a genuinely dead fabric.

Start the delay at RTRS_RECONNECT_BACKOFF_INIT_MS (1s) after the first
failure and double it on each further consecutive failure, capped at the
configured reconnect_delay_sec, which becomes the steady-state ceiling
rather than a constant. reconnect_attempts already counts consecutive
failures since the path last came up and already resets to 0 in
rtrs_clt_path_up() on success, so it doubles as the backoff step with no
new per-path state. The existing anti-herd jitter (RTRS_RECONNECT_SEED)
is kept as-is on top of every step. RTRS_RECONNECT_BACKOFF_MAX_SHIFT (8)
only bounds the shift below reconnect_delay_sec's u8 range (max 255s);
it is a safety margin, not a behavior knob.

Signed-off-by: Danil Kipnis <danil.kipnis1@ionos.com>
Reviewed-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 35 ++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 54d72fa52cb1..7930039dcd32 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -34,6 +34,26 @@
  */
 #define RTRS_RECONNECT_SEED 8000
 
+/*
+ * Delay before the first reconnect attempt after a failure, doubled on each
+ * further consecutive failure and capped at reconnect_delay_sec. Lets a path
+ * that recovers quickly (a transient CM error, a brief port flap) start
+ * retrying off this short initial delay instead of the full configured
+ * delay, while a path facing a genuinely dead fabric still settles at the
+ * same steady state as before. RTRS_RECONNECT_SEED jitter is added on top
+ * of every attempt as before, so the actual first retry lands anywhere in
+ * [RTRS_RECONNECT_BACKOFF_INIT_MS, RTRS_RECONNECT_BACKOFF_INIT_MS +
+ * RTRS_RECONNECT_SEED).
+ */
+/* Matches RTRS_RECONNECT_BACKOFF's value by coincidence, not by shared purpose. */
+#define RTRS_RECONNECT_BACKOFF_INIT_MS 1000
+/*
+ * Shifting RTRS_RECONNECT_BACKOFF_INIT_MS by more than this always exceeds
+ * reconnect_delay_sec's range (u8, so at most 255000 ms); capping the shift
+ * avoids relying on shift-by-large-amount being well defined.
+ */
+#define RTRS_RECONNECT_BACKOFF_MAX_SHIFT 8
+
 #define FIRST_CONN 0x01
 /* limit to 128 * 4k = 512k max IO */
 #define RTRS_MAX_SEGMENTS          128
@@ -1537,11 +1557,22 @@ static void rtrs_clt_err_recovery_work(struct work_struct *work)
 {
 	struct rtrs_clt_path *clt_path;
 	struct rtrs_clt_sess *clt;
-	int delay_ms;
+	unsigned int shift;
+	u32 delay_ms;
 
 	clt_path = container_of(work, struct rtrs_clt_path, err_recovery_work);
 	clt = clt_path->clt;
-	delay_ms = clt->reconnect_delay_sec * 1000;
+	/*
+	 * reconnect_attempts counts consecutive failures since the path last
+	 * came up (rtrs_clt_path_up() resets it to 0), so it doubles as the
+	 * backoff step: 0 failures so far -> the initial delay, each further
+	 * failure doubles it, capped once it reaches the configured steady
+	 * state delay.
+	 */
+	shift = min_t(unsigned int, clt_path->reconnect_attempts,
+		      RTRS_RECONNECT_BACKOFF_MAX_SHIFT);
+	delay_ms = min_t(u32, clt->reconnect_delay_sec * 1000,
+			 RTRS_RECONNECT_BACKOFF_INIT_MS << shift);
 	rtrs_clt_stop_and_destroy_conns(clt_path);
 	queue_delayed_work(rtrs_wq, &clt_path->reconnect_dwork,
 			   msecs_to_jiffies(delay_ms +
-- 
2.43.0

