Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793542569;
	b=GLEJoL6FVgRKfH9xbzMJyyESRhhwwgkcxHYqmnz4uoJMDMI6NnVSBfIcE8WYVyfg4tKH
	 5+VCqbn32J66s+GZJW9MX3MT3My9HY58ovof6jY46UAiItuO5GWn/qaIGkl9Ja5VUurY/
	 IGtjpkTS9obSAxUnmcd+0Fvc08yWRBBg7sRB4SMmHYINs6WbM8kCgTG7fcV43TTiVwg7x
	 jCToLotYisSx/27k4Wj0Q92yIIf+N6jbNzwGVVDuWiMJxlCCO2FIb3eZT5UskhcT2v5tu
	 FKgPPoV0gc+01QakdIbwkFf36z2KuUPq4lH8nU1zvstjKmFfTE/uCawVTrPgtNHAnRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793542569;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=kJDRHLeeryDL/JAowlA6LBcclqmYPY1Hmf3DUa5+FvA=;
	b=QY38DZDx93eIaJ7WXTJUpNH6WYvMeHwbxWjJibbVaFd4TCyYKzFQWDiDdBTLLMJEyif/
	 JV9kYyryKwj5wW1nsBMt1eAxMxc1GcX9iDInjQo09JW9fCRQmVD2nsnx8sOPqxocadPsD
	 lvrypUkzlkGqKdqNPKcPn/R6K76jCy5E5in+kMsuMLMPeD2FeP7MudkRoVmEb+smCvpwB
	 GBddjvpcludBnhyhDmbWt94KkmuNWbaYRtJaR2HHF14YwFNDtmRbfz5BA1K/kHVLqgdKx
	 6gP56RrYudv4tDLzhvWr/nJbLYD5+UF3y6GlKHBSUZQtZ35afOOc/Tb6pSe/s7dnLVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=No27rDrG;
	arc=none smtp.remote-ip=209.85.208.179
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F2F606A324
	for <linux-rdma@vger.kernel.org>; Sun,  1 Nov 2026 14:16:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93F2F606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=No27rDrG
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-3ab4891fc73so21528111fa.0
        for <linux-rdma@vger.kernel.org>; Sun, 01 Nov 2026 06:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793542568; x=1794147368; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kJDRHLeeryDL/JAowlA6LBcclqmYPY1Hmf3DUa5+FvA=;
        b=No27rDrGl6FkBaFuJG9j3JIWnbF7+04YSI3B7KBs0N/sM7a3Z3j2X5HUYnMyvS5cTH
         95CdP+jzQPgfU5h8SBUk+iWA69s9eYMgj8pqIVVAAn4y2Or18a10L6+5g8dvlyqSGmL9
         cdH29xqHMVwvZJX3Z97i4DSN1vPsSVVTMK3zIkjlTHj6cjZmW/7UV4wB3tyAqnN9KNnE
         bPVfiwMxDHm8/yZnoWbpSiT3dA/N8qzokGylv+985CPgnwRTOFPSohXO+0UTRYlDFHbr
         jbnLg2DV66MM6vvJ8O+Sd7nD0Zvj/utemv15USU2TgrPXf65wm23COfoezetMJIixYfF
         azww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793542568; x=1794147368;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kJDRHLeeryDL/JAowlA6LBcclqmYPY1Hmf3DUa5+FvA=;
        b=jgAgrv0osxGDQ4YeCBmxa/bO9WWDuYmyeOELzRK1xPeapN0XW9VjAcBYChKQXKB2KM
         GDEKimNoyztRHUQMmXe4IhuPVsntNwrMy3eN2JDLZu3xAV7h3O80lMB9E6fIpYqJ/Wuq
         PoYUmaGyht7GQOMC+ZKQC0uFJTVVUhYonoeEEDuDc5rHVdeTViHvvpta+4sp3TuuVSDa
         2HxXhZftldNcoeXuhiCqshqcu4zRLmVk7L9ACTI5MjbAqhzJTVmS9699EUvKEzd9Emgx
         455bsVZKguo65PCmxlomRrqUUfd0JTTbmdtGhLJ8/EdQmbB9TiNHSAFDQIqbQe8aEBLp
         cUfg==
X-Gm-Message-State: AFq9FYID3ttMfF8FeeurPFzhXLdZxp8MrnJUNNnUoEp5T48WRYzc9lup
	kAKjP5dGNtOjspxrTeVZnv9+UcgImvH7S1c29Qcm8Nxab5JPTbAz2HM5
X-Gm-Gg: AYBFou3MpfH3td0MbNtJJN71U+FlIKRNAHnu0r8qNT2+NyiPt7dr/HIkO3OiSCoYCOI
	KaFsK9qGR+2965G4PBRHWTWKORzhfl/ewfusF/e2u/VVFvJNd/imXcRTUbXqz2VSxOpaphJH5ka
	GSKDfiWhL8ZBoDza/LDyF77Kb448dxe/J4FgxRzLGJsZAkGqZdxXycyetQsjrnP70gpyAPW/o1D
	6bP/KiG5LGe8+L80CBOo/Nr5rKGBHT8BSCABUc1HINqQ4AApHx3VIb8tVPlQipGMxYZ2/y2aAJn
	yoHV+7FlJPFzfW/YFITifzpZVB4Q0F6zVGdQnwckmfPnTYdoPEg/cPKtrRCfJjcvo2+tDST2cOT
	KVBQ39du6808cypJCQTGJeVtU6TaZVD70QP8zINeet7n1h1+WnnsYAqAxagxifJGB8dbusv5/cH
	+RORPim7eJwTobWIdvftjKTtr8+4aiPXdVhc28PFrRGVg+01m2C7H3TmEp4LHu3vG+FX+IPbc/2
	aPxh7nlYJAK0HQ4+O+MpKFDoxmA/PrAELriuqhurHapnoDpFGDoCFXOCqGVMrdIVsyBNh7Tf5V4
	IiFXK1wNHQHhOtZwCYLrDaCwpMJOuc8YTrSWPj8Kn8Mb8eW5YH1hCjRPnl/i/cqXn3xiCH65hhb
	PTfssDFtGo+1/nbWCCS64uj56kVSiDl0lxF9vHCjzjnrCEQ2QSjS7dSpI5i21gPqTPSEExY8Lq4
	A5wA==
X-Received: by 2002:a05:6512:31cd:b0:5bf:d653:ff1f with SMTP id 2adb3069b0e04-5bfd951d123mr2074859e87.7.1793542567746;
        Sun, 01 Nov 2026 06:16:07 -0800 (PST)
Received: from xps.taila9902.ts.net ([2001:464e:6820:0:f43c:bf8:ce8f:65e6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfe1791832sm1043672e87.23.2026.11.01.06.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 06:16:06 -0800 (PST)
From: Nikolaos Gkarlis <nickgarlis@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Nikolaos Gkarlis <nickgarlis@gmail.com>
Subject: [PATCH 2/2] RDMA/nldev: Reply to RDMA_NLDEV_CMD_STAT_DEL with its own command
Date: Sun,  1 Nov 2026 15:15:21 +0100
Message-ID: <20261101141521.2426198-3-nickgarlis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261101141521.2426198-1-nickgarlis@gmail.com>
References: <20261101141521.2426198-1-nickgarlis@gmail.com>
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

nldev_stat_del_doit() replies with RDMA_NLDEV_CMD_STAT_SET. Use
RDMA_NLDEV_CMD_STAT_DEL.

Fixes: b389327df905 ("RDMA/nldev: Allow counter manual mode configration through RDMA netlink")
Assisted-by: LLM
Signed-off-by: Nikolaos Gkarlis <nickgarlis@gmail.com>
---
 drivers/infiniband/core/nldev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 0602e4d38aa5..953406531cd5 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -2316,7 +2316,7 @@ static int nldev_stat_del_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	}
 	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
 			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV,
-					 RDMA_NLDEV_CMD_STAT_SET),
+					 RDMA_NLDEV_CMD_STAT_DEL),
 			0, 0);
 	if (!nlh) {
 		ret = -EMSGSIZE;
-- 
2.55.0

