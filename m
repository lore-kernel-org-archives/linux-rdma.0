Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795444646;
	b=O7F+nLxpzNwnN0RcsmyTXdRlt+IeuZ82ZkfeneMdS0qJEaTeCRtsWRLY9hCf9jJd2Z/L
	 P1W6LC6GD8e88mihoe/BI9HojWubykVkUXWQKdDFCMG2930PDGeOWl2lVu+Zi8jNdvfP6
	 u43MwZseNMrnWTG0+sLDuHZMu+0kzxw+IMFy5y9ooL1a3J8XuKZN3rnHKxOWhVYuB3Rmc
	 px4aaKysCCiOb5cRJZhM/htIQU9Po0HOmB8F8fdJ93SY7zr4ffO0h92cefDf+ESlnLGaz
	 maS4NfRMR9VUe4LN1yBJMpOcjuMXhN+wL/wUMdQccuKi7nkq8pyEogpFw/fz/b74N0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795444646;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=df24alR55Nr815JXMco+A7diZgMDRmfG71elU5OAFrw=;
	b=o1PFHXbt4Vxkz1ObHkAFQ1eHcm5aaEvkL/DTS1eYfBaySblBAyqIXILaw9bc/5kZnn6q
	 Psch6/TNuEoneVR8aeYjpA6lMYU93zLguil7s0pdjzXEEegzlln/6d7Yo48W8TQemqlrK
	 nTAq8wNVbUqIdxfqz7gCUXpAMd2HV/lZ/o555oyynBHcWZ3mecqAPRjkR7jCATFuxtsqh
	 utCNheVerCq+OIAewDnqI/wMEUSa83cI67byT/Vuf4wBsXVg5ZaPrT/5SvKJ/QX7qOu8h
	 Sq+dxFvcox4C2qfoEvQIohR99JQW7U4gx6jkhbllVJzOhxY348X3bWJIae9WA1m7v2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ionos.com;
	spf=pass smtp.mailfrom=ionos.com;
	dkim=pass header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=A6A3y81Q;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77544606A32D
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 14:37:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77544606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=A6A3y81Q
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so43306105e9.1
        for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 06:37:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1795444645; x=1796049445; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=df24alR55Nr815JXMco+A7diZgMDRmfG71elU5OAFrw=;
        b=A6A3y81QFZSfCrV9iQqIhoShhUwSkaYwKC/tRmva3DzNT7HlsvLhY/u0cjKCL7Q7q4
         vvhkUReg2lnpm2fQ5Uh7GZyQCQZwWSSk9wNawGFUa/9G3buZpDccIpSDrIiF5grmvv3E
         5DTG3VWZBIi1Yx61604DyUzMTazwPSA+Kn8xH2KobaQWAVW3XG30dDQ1qcHlXlDYx6YV
         V3cm1lcun96u8ywDgLyWLSjdAqsti+C1TWYX7eH10zZGUHUGZQy6gND8KiKQhn2/o+G8
         vlS79WNkySwLCeW/kmaT6GcSbtBRPvTkEILPLXvBDVGOGDwchb1iLCXCOhlVvOLyAhrD
         xhuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795444645; x=1796049445;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=df24alR55Nr815JXMco+A7diZgMDRmfG71elU5OAFrw=;
        b=xs6qrf12BcUpbSECVaLLT1lqiuRTSD8VxIaNRqds3VbtXTDOusG5rpAiXOjp6MnbyU
         u65cwxNQ7lyCtb4zVGh8ntNhZ5XDFsiE/gzv7QKPjuY8DxDbK8yXeppzfanBVanIwj7Y
         //xVunLSAxCttnj99MVlKu1TVzslPkInO48UEAYdXuLadQ5onx+LBt8R+OGKbtAuKhuh
         vcO7BF+tHTBzaZCxcpNWqblBNMxuKUSd1XH1svv/PjJEzR3sf3zJUrTiaF4BHx73ouNa
         Ox3SwJ8LACLxYxf9sJ5vNF/Rhlek3/M3xUDyj45meOmZ1FGTn2sySSVZO+2fnd6yifiE
         8J9g==
X-Gm-Message-State: APuU4Z+ldn7kuaQANeR3e1/1/K5c0awj21ora3CSxg4/E+3Y7y4FcTZ5
	pDkoSGUB6ik/XhFUDYSPb2z/S5GVX1lVvKzFb4FiCw8mGZ92xeDapbp8xQC2PVuWJUEheaKmR4n
	zP+8CiII=
X-Gm-Gg: AZFdTZeELv4Z9m2lfp6zXys2387c7JtDy6kMO0srvwATkL/BlFVbJc0RWGEpiqeBFQc
	XyhX/KvH3v1N8ASo/0fcEMIGHvbPKSn6Rf2Sd8pkd6gaz9VNrGNzbvUTAHNTZK9QM0YgIq7pkqk
	I2Fs0KwC2VXykUHhBhqmgpl2VGT9pTu1kXBhYpQTZGXtAUkuoYsVmIIQkijHm0dgE2X9xbOTMgr
	ACkwQYOR7+uwYQQzCRt/MNEtTuALrUyepMipjp+5dliPRnLpwPgEAg2m0rTkHZ5LleoAztQKIzb
	jKp45pqjyXilxxAmxqTJoBRh/i+IoyBIBnLk3Fo1sNf2zUbxxiYObuFNS2WnibvvXsHDe8H+8KR
	ZSvl8xFETQ5JClXfjfefBEd27pR22a/EPVYs8o4vPTUZTnKcQtgzlC7uumsMlw+bTkuJzGZCyEb
	3cPKP4PC8aS6zIcuUdUUVO+BjLEIvCQGZ4rsbpXhK1Q/APDU1kIT4uvvf4i1diLbGGf259DhKHd
	u6QQd0BPv100ZNueMHgzwcsjdJuP4F5dxGLssGMPYyDqH3mRRInzXpmHU4QkQ/+Dm09bkfJwe6u
	+05Q8J5q1GKJvdw+0mAHSF1Cf+HlWefNTok0w32oOjuXF15W2V8ZDFBYzmcRFhRjJtVC8WhyMVu
	SmJ5cXq6nBkjFuxkiZnv77krCW3hjYf5a8Ry/pbbt8AK59KAsON95qFCiW3XWPYvKn3CcWG4fuo
	6hOJ50mSFcCzsvKQTQcBtUeif0Rj3UMFUbU18=
X-Received: by 2002:a05:600c:5303:b0:4ba:4928:8aec with SMTP id 5b1f17b1804b1-4bb88807d7cmr230514695e9.9.1795444644753;
        Mon, 23 Nov 2026 06:37:24 -0800 (PST)
Received: from lb03189.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906d6a13sm172562325e9.3.2026.11.23.06.37.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 06:37:24 -0800 (PST)
From: Md Haris Iqbal <haris.iqbal@ionos.com>
To: linux-rdma@vger.kernel.org,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: Danil Kipnis <danil.kipnis1@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Md Haris Iqbal <haris.iqbal@ionos.com>
Subject: [PATCH 5/9] RDMA/rtrs-clt: rename pathname parameter to sessname in rtrs_clt_open()
Date: Mon, 23 Nov 2026 15:37:15 +0100
Message-ID: <20261123143719.938876-6-haris.iqbal@ionos.com>
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

The parameter has always referred to the RTRS session name, not a
filesystem path. Rename it to sessname throughout the API declaration
in rtrs.h and the implementation in rtrs-clt.c for clarity.

Signed-off-by: Danil Kipnis <danil.kipnis1@ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 10 +++++-----
 drivers/infiniband/ulp/rtrs/rtrs.h     |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 5ef912a472cd..c059d69c3e5a 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -2832,7 +2832,7 @@ static void free_clt(struct rtrs_clt_sess *clt)
 /**
  * rtrs_clt_open() - Open a path to an RTRS server
  * @ops: holds the link event callback and the private pointer.
- * @pathname: name of the path to an RTRS server
+ * @sessname: name of the RTRS session
  * @paths: Paths to be established defined by their src and dst addresses
  * @paths_num: Number of elements in the @paths array
  * @port: port to be used by the RTRS session
@@ -2848,7 +2848,7 @@ static void free_clt(struct rtrs_clt_sess *clt)
  * Return a valid pointer on success otherwise PTR_ERR.
  */
 struct rtrs_clt_sess *rtrs_clt_open(struct rtrs_clt_ops *ops,
-				 const char *pathname,
+				 const char *sessname,
 				 const struct rtrs_addr *paths,
 				 size_t paths_num, u16 port,
 				 size_t pdu_sz, u8 reconnect_delay_sec,
@@ -2858,13 +2858,13 @@ struct rtrs_clt_sess *rtrs_clt_open(struct rtrs_clt_ops *ops,
 	struct rtrs_clt_sess *clt;
 	int err, i;
 
-	if (strchr(pathname, '/') || strchr(pathname, '.')) {
-		pr_err("pathname cannot contain / and .\n");
+	if (strchr(sessname, '/') || strchr(sessname, '.')) {
+		pr_err("sessname cannot contain / and .\n");
 		err = -EINVAL;
 		goto out;
 	}
 
-	clt = alloc_clt(pathname, paths_num, port, pdu_sz, ops->priv,
+	clt = alloc_clt(sessname, paths_num, port, pdu_sz, ops->priv,
 			ops->link_ev,
 			reconnect_delay_sec,
 			max_reconnect_attempts);
diff --git a/drivers/infiniband/ulp/rtrs/rtrs.h b/drivers/infiniband/ulp/rtrs/rtrs.h
index b5bd35712de0..0ae78b28986e 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs.h
+++ b/drivers/infiniband/ulp/rtrs/rtrs.h
@@ -55,7 +55,7 @@ struct rtrs_clt_ops {
 };
 
 struct rtrs_clt_sess *rtrs_clt_open(struct rtrs_clt_ops *ops,
-				 const char *pathname,
+				 const char *sessname,
 				 const struct rtrs_addr *paths,
 				 size_t path_cnt, u16 port,
 				 size_t pdu_sz, u8 reconnect_delay_sec,
-- 
2.43.0

