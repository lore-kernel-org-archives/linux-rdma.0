Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795094307;
	b=gj4E6wmgbGLx3yDT+peZr2pLltLjntSQqrU/eQ4YwpOcRaDSNIuRPzzBg606qHXjn2G7
	 +gEbY3oc9S2qPcZUmG9j+VSbIyfFsPSN3EME6OvdIBD1iJ3TByg4x3HSdEI9e7eS03vQy
	 lST04dfHES4U5q/jjqjEzARtoIItqote/2M1hMH3VvRThSmU3/JoQuwV0mhFpidUkjG+n
	 BDF34eLQrtbZgjmbgUf1ORvYjRcZBk38UciYRkkhSB7SN69+elTfSkc2ZLWcoYPxWj93p
	 hcQ7YfxZooyrsSLYVCrjLHADkZmvyFkhAaTFfs8rpDp885eYbqJgfrvAJI7JSNhFHhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795094307;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=lW0rsTzAv8g0kMd3ojP3+GnYyed/cwVnxWGi5+Nic2w=;
	b=PV90D9r/6T1TG6TKMxhIrivguWZcA8GhkS2OakPGuPgqaxe+gpv/VQS587fCPhbrMRT7
	 zVkXh/c7HjyODXflQ2whuSnOaylMBY+clkPmNV4CvWSwNNdQtFrtI3nD6pifi1jHzp+ew
	 gQZWmC1uf1ANKjv60rnUoG0PHWuHNlMrZgw+cgKtSczwvdgkb63B0C5x9sq26k4NWWsR5
	 do5oYXAp6ByPjiIYvA7hf6AN2OwDSRxzLQIsQL+uaieeVgDm+qUP9kwL1ZlwPOHiIJMXZ
	 aCJW6jFRPYJ9508iDca6iuwx6hpftRd5wQufJG088Hked0Fji+4yc0O21E9+RxxUSIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=PnsugRTi;
	arc=none smtp.remote-ip=209.85.216.44
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8352606A326
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 13:18:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8352606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=PnsugRTi
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3ae6b4c669fso773565a91.0
        for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 05:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795094306; x=1795699106; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lW0rsTzAv8g0kMd3ojP3+GnYyed/cwVnxWGi5+Nic2w=;
        b=PnsugRTi43kd8Jc6wW0hk/YmUu0oNjvvRG1DQNje/m8SbD3TlSSeMEupfF4A15j0K0
         HHQbAEpzZbImTOgkUBPzUgfM2+34y+Z1Z3LIGfstav+IDG1RD4I2Cz0fIFwUVCFgap/W
         ko9db2jEwjEMacCCr6UIQxyv0rQFSJbLtRxjZVppSI41nq2x19GgjfGV/qPASE07OR6U
         1OppQBWCjSjSHcxZYnVd9Iq9hI1paPuJVUlegnwTpsZdlrGCng2ATgrKzd6hLmo89yy0
         gqeWEAFW62yKxK36qNil/zzi7Qh4eIVuAxFDAwaoe6Cy6S73PAL3j7f3kmooKXmhtUGi
         i2ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795094306; x=1795699106;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lW0rsTzAv8g0kMd3ojP3+GnYyed/cwVnxWGi5+Nic2w=;
        b=eMygI9SRYL2B86bUSnBgufzJQuoe3CptMMoGekznSRO5KqjDdq9buBk6p89Q53aRYx
         TBN0M8gv1Hx+ksqB0h5X3yunGkXwfjwcgINYcULLbFiLvnD+ri+us9UwivEuRefHEwVG
         /+TouDmxGHg7CFq5nYe3NkUhbgMnRqGcr8nmPsnEheWk1RddDQkM0uBkNvPsyPzlH8bs
         ZYwG5kEJWoCcdfkrjmYfAS1pHpjeoXeA9T0BdKohWnYVqNxhvWgXT1x3B3s1uR9bx7yA
         iSxmYgFooZOWXBXevfv3yLxUmCuxLovHv7PwACoZWEje+1IZ6Kd73AoLEmzd9BLnIVBF
         kmMQ==
X-Gm-Message-State: APuU4Z+0RoIqascoQxq/LkURsYo7VcrDPbA3NcbbIm9YfgOUIaYb9NGg
	o78P7J2yVSLJjL2aI85VtQaBQpq496GaAUcP97w7cxYyepp9Qe7P4T3VvDqQbLg/SVQ=
X-Gm-Gg: AZFdTZc0fAR6pDGcBZoA/nuAHWy0jVRe4cQuVUIx40zCEhCcQRKUbJBvvok3h17m9V5
	3RXwq/DLP4rfvhuOk53nMtVni2FGdQEbL5D9EJ4IEfhKmnp7lm22brAU5XIxTs3gySxlL0Ux+NI
	+x37UPdi8dIBTLs/OjW0UiHOSGESxB6NbxTj6gC0XQC7TvH2OjyuyPmvPGf5/b6yB8UleC3M4Ql
	Q/fHmBBy5SrkSoxK7k75sd8xhS1tUWtHEFEL8fXDHz/cP6IL754bSVkhu2RmYI7T5saBDnJbM5s
	suvkjmCQICUNjIGlz0Wqr6sVs/psnv73BS/YXq005/y6Bg4+ZzB7m3UgW4HKY8fDOe5W13A7t1/
	ceTSTqW2uRuTA21HjawtQKxWDKAUg5TgFbin+/NSr6Mxj8jcTMbSuHMGkNcvxlfnrs1khsa56o4
	tKQ5cGlZ1McSult01cC2hCuiSJtfa6pdKttfptUAk9gD8INlHvVEGuQNdVygi9bRBRUjcxRtsem
	yxWTG5fZK/wjXJjwVKShHskQQpgb68mmN89Lo51e2nWR3DsORapz1gXzcLlihOK+yp2z21j4fJt
	h3mzCJPHIm55uQTk0AReBl9x83YKXaAcPhitJ+1WmhYzmh0PPzJHpvfeaeHpzUV+3ziiw9S6NzC
	+WDgRE7PWbVVrwyJefNldiXmacn9U7G6clHWJKA==
X-Received: by 2002:a17:90b:2c90:b0:3b0:9bfa:72ac with SMTP id 98e67ed59e1d1-3b40a0e1cffmr734949a91.21.1795094306265;
        Thu, 19 Nov 2026 05:18:26 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:1076:1f1f:dde8:a816])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b40543eda7sm2794953a91.0.2026.11.19.05.18.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 05:18:25 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org,
	mkp@kernel.org
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] isert: the commands the target core allocates itself
Date: Thu, 19 Nov 2026 22:18:15 +0900
Message-ID: <20261119131815.2722343-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261118211503.2526705-1-yhlee@isslab.korea.ac.kr>
References: <20261118211503.2526705-1-yhlee@isslab.korea.ac.kr>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is superseded by v4:
  https://lore.kernel.org/all/20261119131700.2722108-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
