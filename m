Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795444646;
	b=QKFtfp1T0SybKuZWU0mFKMhF62mRV1fLduIFl4WqetEvdhg/kfty8wdv7TDKN1stTVqB
	 ZtQa+oQc7veVYopUqE1E/AKwxBcKxgkcVR8bgElJw7cH+Y2B1aqSHY667VoOaao+vsQLV
	 tMPzfHHyO7r3L3ZTYwdGjBSZ99H2zyK3IvGWeMdOHnkreHHoBcTLJUsNTyEOsa3+1T+jb
	 X+CfoOzPujI5C1B6ss0grEFFnF2u/5dHT9+9K2uT4S+zrC/dFIk9gcgTazlFLTX6eE0lV
	 YWcKL3OpQSnN5Fha8jCjslhUfp84q+dXTjXArJuNp1tOpEWbECvn2eGsvpg/XGuntqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795444646;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=jV1kE22gjteZFLT1j9oodaWGB84P8DfL3IABfgB4BO8=;
	b=RiVziXZjr4nLLx4BI11pirVaf0RwA1iE61MbqsZkTMvJPHw3C2fsCTwH3prj9A51JtAG
	 i90B4HTOwDVk4fCA1RjOverK9y0lACZN/N30UqVM17aX9ho7+M7kmzYRERC3961Ul0XLP
	 LQxrgzmwok3MTIbZ3ocp+396Z4YwIEnUHFKPHvpITt2ys9LL/a+eUUGnuLGJY4G3Xdro5
	 oTLNvMyUPSeedQ/JLVxum6N4IRW+3ZgrVLza4nWpOeFGjn1XtZlYCir9kVgG82DOwNJG1
	 7myNJZe2AITJLApiRcOQT84eJoOLNeiDT7m28Zl7mlNsDm+Wrhxi5MCkjZN0GmPFEnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ionos.com;
	spf=pass smtp.mailfrom=ionos.com;
	dkim=pass header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=iCbzMmG4;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D69606A31F
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 14:37:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C5D69606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=iCbzMmG4
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a35ac4475dso25039335e9.2
        for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 06:37:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1795444644; x=1796049444; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jV1kE22gjteZFLT1j9oodaWGB84P8DfL3IABfgB4BO8=;
        b=iCbzMmG4PQCcetrIUObSTFll3tTAYL/oWrrU1Ml2dO72ZmAy9La0xlDvO8VUGiJF+6
         SucLhI/MMrkeSdSi3o+wx/nJCmEtNgtdraxZIyVcYV9mVdA+nBfn5UneU8XzS+tHVq0J
         PqDq3vh9sHa0POGJuHylsyjDOFDvnJRuwkRmdsdUKGY1VNjUNZHlb4msfnhxnZYpCsrY
         g2MTYgaXnewDLkRkmQYKTWldd42dBcanl3iQa6fZIiHYKmeYMStrKwMKcXaxh95XIHAX
         UJWx3lBzs6fE9K/8zyFNeTjDb61VEcKWANO+IPEE8Zd1DRHS8B5DJDBMHb6FP+YGnSbJ
         XjpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795444644; x=1796049444;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jV1kE22gjteZFLT1j9oodaWGB84P8DfL3IABfgB4BO8=;
        b=rrQZRbr5EJ6TNtX0bkw2NrNdxXesAdpWBr2KPtiUUZTATM4Qx8xAOlkBmXYKs68Ot3
         +mk8K88hFZRtFaVPZg2JTTWFYKAYJMwTq6zpMqnUeMzQxNSpuJon4c8etDrIFDDCJSLT
         Y8jwWwKWyl55t/RyO49T06wo8VxaH495FK28h46Ld+0Rkxhh5YqHvX9KURpYcVYY4P3n
         MYJRYtx+CStBT3Srm9TXbuV6DUTsssqBY0+6OrLDmoka0nEc++fVjjwp1bU3EzT6qY+4
         945F+I+IaBUhuyKY8GEFGqrflPigizcBfL5jyTOk3jp9D+dlxdTyfs/hBVsy5+9ufqel
         nNBQ==
X-Gm-Message-State: APuU4Z9+2Ra+jyZALg+3MpSWdg4ZW3S0AsgTekLwcug6XspNg0HxOPFs
	ciS014YMGDoZY7j8qqm7bEIB7ZSP39ulu/XHi/+6RgZYehexIwdiWjHBTYvSaW2JjyiSxu/luoc
	ly9G9yzk=
X-Gm-Gg: AZFdTZdaM2d1YnATACgV/4/UsEBMi/0laLIM8FgrSURlTeppHsytXYPLZ//pL0WFPJF
	9PdXiLJga23KCN0EDB+HLjjo/9typc91D0deJAi/HZ37Mill7+WmFXIXFIldEIbtCyoUvKRCeGR
	lC+J2W3+TPrGWcOHWOO3tVqLCrtPbtYfM4spqEMdOg/HtPCWQ9hiqJajTocW9wBuVEJ9p1TKimo
	bm5ya+QGPZS4M4arYbzNMXAgdQSXW/vbz0z5x8VEOoBTX8FUEZIRYsV8uVSvGBcoBlz4Mjvb+/N
	rqOZvu68u8Cpqivsw6Ad3Zoz7+09TW8gydOhMxm4/EMJux+Grt+oqaS4zJzHX69tZ2r5Ai+iKeL
	GXh/NUNasrMGXFNWqQouqeKryZz2MmKUnab5jNLCDUCFOtKdTIAD36teD1ob5JY0vwx1gWfhxqL
	qYyPrgbt8whCaNMxyCKPSbMIHFgmMWJ/h95zSb9K1PeTNhAc2PHI0tW69mBWca+ckppGxmZif1m
	LPjYQ1/X+TNrNGINb8ukKdbjTLQwciA+5ftscnm7brRYMXy8lI3ueOMR4jOd6xcKrwAWDgAxZj4
	posHJUZ+X2b17/CIXCfNrrk5mpyEfWncUo/9N1G1/B9rmViJVpENsbGNYvJ0TEH4t4HZHaUCJQ0
	ZcgfmR8896oiz1mnP+Mr4TwSXVpN2CKKbEZH9w//2U9TCrwIyEM+HHEwC60EZEs1Foz4Rpa7I3u
	PCXEWBRNdAVRkowNPYgEaP+rowV1dSwhaN55Q=
X-Received: by 2002:a05:600c:6749:b0:4a2:d99:3171 with SMTP id 5b1f17b1804b1-4bb8881b52dmr234127635e9.23.1795444644176;
        Mon, 23 Nov 2026 06:37:24 -0800 (PST)
Received: from lb03189.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906d6a13sm172562325e9.3.2026.11.23.06.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 06:37:23 -0800 (PST)
From: Md Haris Iqbal <haris.iqbal@ionos.com>
To: linux-rdma@vger.kernel.org,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: Grzegorz Prajsner <grzegorz.prajsner@ionos.com>,
	Md Haris Iqbal <haris.iqbal@ionos.com>
Subject: [PATCH 4/9] RDMA/rtrs-srv: Fix processing messages for Big-Endian archs
Date: Mon, 23 Nov 2026 15:37:14 +0100
Message-ID: <20261123143719.938876-5-haris.iqbal@ionos.com>
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

From: Grzegorz Prajsner <grzegorz.prajsner@ionos.com>

Convert msg->sg_cnt from le16 to cpu endianness before processing
it. This fixes bug processing messages on Big-Endian architectures.

Fixes: 9cb837480424 ("RDMA/rtrs: server: main functionality")
Signed-off-by: Grzegorz Prajsner <grzegorz.prajsner@ionos.com>
Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index 5314599d29fe..7a47b90e8539 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1045,7 +1045,7 @@ static void process_read(struct rtrs_srv_con *con,
 	struct rtrs_srv_ctx *ctx = srv->ctx;
 	struct rtrs_srv_op *id;
 
-	size_t usr_len, data_len;
+	size_t usr_len, data_len, sg_cnt;
 	void *data;
 	int ret;
 
@@ -1055,7 +1055,8 @@ static void process_read(struct rtrs_srv_con *con,
 			     rtrs_srv_state_str(srv_path->state));
 		return;
 	}
-	if (msg->sg_cnt != 1 && msg->sg_cnt != 0) {
+	sg_cnt = le16_to_cpu(msg->sg_cnt);
+	if (sg_cnt != 1 && sg_cnt != 0) {
 		rtrs_err_rl(s,
 			    "Processing read request failed, invalid message\n");
 		return;
-- 
2.43.0

