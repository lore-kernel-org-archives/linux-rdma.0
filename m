Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711063;
	b=08RvBzpLW4ERYE62e+GEAjEVhke0/PijWq/evmzMks7FSk0uuKp+q2oF0d+04QhZLCHq
	 Rc/lZBjdyMFV4f7diexxFGHZxcPDXGh6N9Mqormd2cVOI5oseJAPCNrKFR3nfupAkE5MU
	 GynEk7OeKIF8XAvKLWJ495Tmr1PXZ51yPEVhx8Tjl5BSf4G/3XtFKdslMSt/P/4Etko2K
	 X6UH3vnYW+2fIwcCbwXxKH/5AOYh+n9svZlLf2c2VMhlsfPjcivh0Rt+qEuQyutyB0LyO
	 KMKgB73+2L3f01m3sbsYe3SIHc2NUrkw+N+mE4E/l5sX+Zl/aSHRuhZl1UwvsN7R49Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711063;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hrz0HS4K+HZzYid2snb5+IR7NFz1RNPakoEoaqHrluY=;
	b=G4X4161zvSPFInefp8M+b9CkHOb6hGxxLaZPVO8VDeMBRw6tZkE8V1ZeaZeIRU5CWUAm
	 AJ+nO52R/bWsv8q9A4p3c1XhzF/VVmS47MykZt49IJjG2HjuAWd4KBtuXBbAipmJOD+RS
	 /0zZpZaj7Hb3T1YhXilDdHPewcHllnv6xWfpuAiWgNZW6fCrwvc7ThsSl86aoQ2DVbQ++
	 grWV0R984OPe9sJnlZDlxxIXR3JYB1wmWPJ0iuxVq5R5H0pWOIbsVS8xMQYxJZkD9Iw3s
	 wvUHs4Yd/9CBBFxABTHaCHzB9laQ0VH/attUpWjUDR/+fKw9Wb60+FKlIQYMiVvKAdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=jfTU9IJ5;
	arc=none smtp.remote-ip=209.85.215.172
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B010E606A324
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 13:04:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B010E606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=jfTU9IJ5
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cc4dbda1e5dso1437359a12.2
        for <linux-rdma@vger.kernel.org>; Tue, 03 Nov 2026 05:04:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793711062; x=1794315862; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hrz0HS4K+HZzYid2snb5+IR7NFz1RNPakoEoaqHrluY=;
        b=jfTU9IJ535MeUG8o1iDTqc4DK8Z+RI6JLIR91BZ6dNkfDjOEsh7Yn2H5gw2hAtNGnO
         LjYDgB4JN9AKz1vM/Djlmqjj1aCSXQ9p5+1nTv5AHMlcEiOVkAkj2WrOdztnCeJv5jL4
         psh0Jq2Y3d6WFJWMqYsfYBxWC6RLVxLjAje4n8Z9FurJ79WxOyAaqUpLJeey0OcNK536
         OMvOmOBKpjrz3QrWzEokuX0VzYZiAUoPa997R1esVqRRdGxFmhp/cK2QVkHWd98Ke6jZ
         1ElEeY4tYKq47GH7Zl6+DJ4Ogs9YpiS4Y1ARqR2Kb81fhNPY2nRczTVkwO1el8E3CkMD
         Fg1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793711062; x=1794315862;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hrz0HS4K+HZzYid2snb5+IR7NFz1RNPakoEoaqHrluY=;
        b=S5yPrNcbgdGimabiQCYdOGE+QlX1+rkZcaIhBm2wp0k03FJ5q4krX+tjsW0NrRvTTf
         PPdb3NrGsSvngLQn6tOLBX1pbzSuYxPyCbbuMaLcldsn6WKzb6KDPX0smtD1K2UyzMNx
         ArZMHIznfW+SHK+Gtz/i3Tm40lcHq5AXddW32EhUKf/rYTMm3klMNkEaImhyAnVzg/Am
         spICY7uIyb/ahlkd3DpL2cF6YpSWPiN+1SWwqS4bxmEAPH36pBbyCBirwxzx88XDfpNj
         LiE0f+wqWnDnE5T94aGhUdeai0/GINu95wy2XambFGd+yusaDswuFq80Of6agYLiLVM4
         OyEA==
X-Forwarded-Encrypted: i=1; AKwUvByBpLAC81ce+yS3P/3tUyHGWKSR/Ifra9LiTrTeSbfRDo2VDW9OgRYOe6AZAqIh0BbTMxXBjq2F0raH@vger.kernel.org
X-Gm-Message-State: APuU4Z8W6y0vi+vWX4KJV+QV8aL0CqRC3ut6frCzWM4G8oxqo6YX8RFi
	/VVh2ACJR4lwC7d0e/G/WmOGm8OH06tDueae8rVTqXi2EFwrryltTMQaH3Jf0KYhPNk=
X-Gm-Gg: AYBFou2xIt2UtRYKygKuoLprkuQne9DzUX2CnshKFIw0VordXgdcNpX70y98SXzUTTC
	DBIeMqd28p7VNHKLYIEMWZZBgzZFGR61ZarnpMN2G5kLFf64XiREkqJcgzoyL0ubfuySFpugI+I
	2jD7cc+k0L8uNpXJTS9GgYK8ghQ44RYL16asWPRVP/Mg2k/6hOO/N1lVoq3QSyQAP39pxIitnx2
	ujBe/N3Uf0ZHJTl992l7WqUcboOPt4AUcCBAyHWDoF32n5atoXAUKUzWsVe7OWflBVQcLWZuLRG
	umdqQtHlTUrLCN/B3b4nclgy3tO/WgNrlKSdgKsXUbyil+CEbmsMhvhgBqWDC5JRiszNeMNpRmZ
	16c4n1eIPzsg+d160E0dGyU6Oi4H21cUqzRLMEJNMcUHAzB3PxdxXrjbvDTg5uPErmCEa7fGBng
	2VAYBqLjzdiW/cYptEKNWe9A7zYoHJ0Rir+ajvQy5pahouWvVWKJuowny2CIgR1ouYq3vWeDACp
	VUw447nRme0na5IH7SqiqVd5SgKVjwxc+7O6ZXyxOj+p+0I+udOrV0UJZGSBYrqZm+5OAY9Av1q
	MJ+vPQqA4fpjsSrrGGZyiIIE2U/PO4v4fV2jiK9dNDQYaRP+kcLhqeSdKk50mSpbQzpqWkpfJz6
	zuzydBwgZ8RDc8NuElmRsZT6QEC2DN2IIKe40lQ==
X-Received: by 2002:a17:90b:3d8a:b0:3ab:9f89:e1b3 with SMTP id 98e67ed59e1d1-3ae89764eb6mr10599503a91.40.1793711062055;
        Tue, 03 Nov 2026 05:04:22 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:2da3:4696:4c5e:89c1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b08759344dsm2265061a91.13.2026.11.03.05.04.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:04:21 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Sagi Grimberg <sagi@grimberg.me>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: Re: [PATCH v4 0/3] IB/isert: fix the device removal use-after-free
Date: Tue,  3 Nov 2026 22:04:12 +0900
Message-ID: <20261103130412.1530793-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261103032924.1073138-1-yhlee@isslab.korea.ac.kr>
References: <20261103032924.1073138-1-yhlee@isslab.korea.ac.kr>
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

This series is superseded by v5:

  https://lore.kernel.org/r/20261103125955.1530355-1-yhlee@isslab.korea.ac.kr
