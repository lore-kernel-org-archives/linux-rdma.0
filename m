Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.161.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793334074;
	b=ACRa97HpR9UtU93l/fGpZT6pTrn6JUyEAKRhN905GAKmXZUciZfuq7T5KgOeTZicr6aP
	 wIRteiYliZYv+qpOnSasJ0P8h3OS0aD4OdbRm0vIyHoxE9/BalBXfp9UrUh4xdtJ6YGv/
	 s7K4w3gbai8GSKJ3DszHYrGPBZlWmj+UKg3OW3qLNA4kLo5wegxesL684wWxlJXh5QtBq
	 ivXueDOuJVJjYkXPfp00J81O0J0uf2hYtmuNH+lVYN3a9gff5BQGS0/5UMTVQ+V+hlucm
	 iiN72RisEi2776Q0QgOTsKApqEzry8HzUU3O/x/ybzf3EcU/uAo5beIPaT8ufWi1tsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793334074;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=NZFxhxetntJ4eJV30GVWChY5vhsarJj0j6bepxHT7hE=;
	b=KuPJ8JclNVaDO5qzTxylnrdxaFFRsoJNhQTH3dTjpexkhzV7W6Z8iCzll790W7iARzkT
	 Xl2awJgXs8b+l3colR/Xz3W+nsuimSl6+5pJbQKtngiP6P6uyj/INhij1rys0I6AaSELc
	 Zo0X//Sdu8M+Ggwh77D2CfD9uhFvLPxW4AF6SN28qfIr35Dyvlx5abbXe/kaLzCIMraG8
	 kyo11BBIk1THudo4NuhCODf21Arty/lSRkmchK1WNhh6mWAsuzklxV83v25Wepvdaa+je
	 qyan+r3mzIDMZDyXnbT4JikX9VZ/s/64u9wE3Y8vWzNjiTQ21ZJx4fpWL4sz3qZfp+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=openai.com;
	spf=pass smtp.mailfrom=openai.com;
	dkim=pass header.d=openai.com header.i=@openai.com header.a=rsa-sha256 header.s=google header.b=Cib7M9RO;
	arc=none smtp.remote-ip=209.85.161.50
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93AA0606A31D
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:21:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93AA0606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=openai.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openai.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=openai.com header.i=@openai.com header.a=rsa-sha256 header.s=google header.b=Cib7M9RO
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-703be215729so119913eaf.1
        for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 21:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openai.com; s=google; t=1793334072; x=1793938872; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NZFxhxetntJ4eJV30GVWChY5vhsarJj0j6bepxHT7hE=;
        b=Cib7M9ROjjLXZ3Um+4q0PaXIHuP48lDm8G9SQnQIStFIb7n0L7DduWd5JL7qHKgguB
         LwvOyZ0U9h4+3/gcSqnTmJ6uEGbU/HDoMG0tC2dlYBTxljc41dljju0e0MSR4dH9coFT
         FRY0+RTE1CC2znYpjXqKuxpSgTvZ3hi8iacGc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793334072; x=1793938872;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NZFxhxetntJ4eJV30GVWChY5vhsarJj0j6bepxHT7hE=;
        b=EWYm2u2oL4tD+k1eUZVh9qwb83m3XwxU+3wtoMRMcItHcaaAd/EI4/viSNI3tld7Ep
         bZsNsRph07lKV+8u46/biEdB2pDw2jBUwwepnkLLzr+B2DBAlAzyDreQp1mcWBhN+864
         TtAWuaMAiA5tSX1IelT8oLbO0LxyylY1aMvQ8NSw7VkxNi7nXEmDDl7rf4Yo1AfvjIIW
         bqHsrec6tMDlHfoE1JRASFpZKImD2Od0xfrZWoJ2qTzkACe+nbsSreGbFrw7hIZ+EzSN
         UMMPtfFY7CUHUcy6uGCC0b/Pl/ZzhpCpKgmVhx1dXuukkoVgBOgtbf0XrcdiJ4ReyCn4
         Zdtg==
X-Forwarded-Encrypted: i=1; AKwUvBzGPMG5V9PrX3Y+iYUqX5+wJRJogrz54Xaq8LHagkiOlgNajidyvK3JD5lrAHYfM+C2XdkUFjVlQD/7@vger.kernel.org
X-Gm-Message-State: AFq9FYIW0lc/g8d7aEZKXBsAdvIwdGr7Obb4z+FWCY8X1giFXD6Gxwks
	v8LyauPyV+Tq8Z7CHJp6Dqs3kQJGmtZTzWiY7L6yis3wGNVxOFfEoH3ApMid/0Mr2mI=
X-Gm-Gg: AYBFou065Z1wTWsw2Fx2TFSIBKvSF2j9gx6UnULNr+LnhjsFsWDsjWBt745fFwtJnpR
	TQbESe04F+ak9DK+MsKT/o5/UFpigbnHGsq8I/gXSUgSSefhh9Nu4OCn0cYdeOxl+UC5biZUMfd
	XFB21/ZtVtZZ3N1Qm17QP/E5HDQf9xedbXrGSrtIaVxUv70t3oSEcWGoK6ySoRh/C2tgBTwDRMx
	XOUFypuAaoMz5ddb6SvDhk4bBsjMP4G0/WT38JcckLUtkGr+EH96b/tHlU8/0upGuvqScaJtl7z
	xwiOmK11hJwZgvpX1TWPFQmmWJkAMvb6c54FXoPDqlWcTzs9ExOwMaWON3Kxg8jUsgsWt/EGpLO
	+2KYyNkGn9dQsfzgkW2aPxl8MObxfIwGETyr9jPK9PP6g5jOXvNREuhswcyv+sznl+5QY2OwOVh
	jxYeJfb2708pgb9g/1GnUELjGai77TTIlTbm4zNEiIrV4a9RWhFS66yUr0mG+LjCLKNeTS0AmoK
	GBitFnZFYzAGZmUuVIeunJjJeqpPgF/mx3TDCt7T+hVw26dUq8OEUcA1UT1B9ZwCq41zaNbXihd
	2fhiQ1th4qad3Uze+C3gy/+dJeO/SUpbNNkdC5rRw75TlYDEFPK34ucFiTwvFXvOsIubkff7kbx
	t9Sizxy30zPxvFdQVSfTTzfisZxcm4w==
X-Received: by 2002:a05:6820:7093:20b0:708:d862:7b6f with SMTP id 006d021491bc7-714f24ea1a3mr577516eaf.6.1793334072102;
        Thu, 29 Oct 2026 21:21:12 -0700 (PDT)
Received: from com-75606.corp.openai.org ([199.47.143.5])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4a90af650a1sm768615fac.15.2026.10.29.21.21.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 29 Oct 2026 21:21:11 -0700 (PDT)
From: Kyle Zeng <kylebot@openai.com>
To: rds-devel@oss.oracle.com
Cc: Allison Henderson <achender@kernel.org>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	outbounddisclosures@openai.com
Subject: [PATCH] net/rds: Do not unpin a page after a failed atomic pin
Date: Thu, 29 Oct 2026 21:21:10 -0700
Message-ID: <20261030042110.73571-1-kylebot@openai.com>
X-Mailer: git-send-email 2.55.0
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

rds_cmsg_atomic() assumes that a non-NULL output from rds_pin_pages()
represents a pin that it owns. However, pin_user_pages_fast() can roll
back a fast-GUP pin after racing fork() and then fail in the slow path,
for example after a concurrent mprotect(PROT_NONE). The output slot can
still contain the already-unpinned page.

The common error path calls unpin_user_page() on that stale pointer.
This can consume another subsystem's pin and allow the page to be
freed while it is still in use.

Clear page when rds_pin_pages() does not return one. The error path
continues to release the page on errors after a successful pin, and
successful requests retain their existing ownership and behavior. All
four RDS atomic ancillary operations share this path.

Signed-off-by: Kyle Zeng <kylebot@openai.com>
---
I have a reproducer for this issue and can share via DM

 net/rds/rdma.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index 078090d292fa..71b57abb96c4 100644
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -957,8 +957,11 @@ int rds_cmsg_atomic(struct rds_sock *rs, struct rds_message *rm,
 	}
 
 	ret = rds_pin_pages(args->local_addr, 1, &page, 1);
-	if (ret != 1)
+	if (ret != 1) {
+		/* A failed pin can leave a stale page pointer. */
+		page = NULL;
 		goto err;
+	}
 	ret = 0;
 
 	sg_set_page(rm->atomic.op_sg, page, 8, offset_in_page(args->local_addr));

base-commit: d89e1d186ec9271bf78e62771779e9fc03bf0fc3
-- 
2.56.0
