Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A859B371D1D
	for <linux-rdma@vger.kernel.org>; Mon,  3 Aug 2026 03:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785728484; cv=none; b=rmJlXprvnM28i4J22re9kkZfx6ezwwoO/B+FVstYvQtt9QdQv9vRZ8uAVjXOV/A+kisB6zgk8eX58knYAFG+Z0AomOlaVpF04SYqIoQSEXHSDrVLzbCDYHlGerPdXVDM8ko1daSZyxr75D3ZGX3i+6hTGWphgK386xuZHrfScpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785728484; c=relaxed/simple;
	bh=NCMW4kQRyBWSj2E3oOTBkzWRrKKMpt0eKzLDMpatx9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LHCJ1g/PhQwe3sdbMJ0fXcS7lxEGnASxNIdGnsAG8D3P8qgDRh/IGXtq2cdF82uuiKwAgOBOU4R+401KKAJ6ZC8gtqvTjphM7X7tp76e63GbXxklq9xTmMDhdFy6MCefoYQqBc0xDv3IZzVOtxG1HzgdVMU2DSu7fSWlUE/tJG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=xnK6PMTq; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="xnK6PMTq"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-38e071ed6aeso2226654a91.0
        for <linux-rdma@vger.kernel.org>; Sun, 02 Aug 2026 20:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1785728482; x=1786333282; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NCMW4kQRyBWSj2E3oOTBkzWRrKKMpt0eKzLDMpatx9c=;
        b=xnK6PMTqK146IzXA4PJD65/xzUYMlsQsTRsM3vQHESajUrVka74oq2zKaSAZHhWR6u
         Hi5tCIhz1hqbjkScLbKtyvYa8YPscLTwibI/tYHhhTMxMqgipa+xRdtVU9/yB0ThvIk3
         XP0HqvWIXZ1PWlAO3GsUkmaPQzBVGfnjFMc8FLDYmdmkuzYkcQD7wMzYgC1pt0018/P6
         SfRrtP5oP73JWVdYmVZp9/e004xJgJQWl3WKR2ft3FT2oBxuoN8kXV9SzpbWyu1nRmWv
         cJ+ZZlYmJOz6/GaCiJAoFphm8qQj5yV9NyLTp6UOa6XmiGrQen1Fg6YLV9marLubqsFY
         jEfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785728482; x=1786333282;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NCMW4kQRyBWSj2E3oOTBkzWRrKKMpt0eKzLDMpatx9c=;
        b=GZGG/PyJ3b6gHXEbQwno6pXstdnGqqrnRE15YUkoKjf3ldoZlqXU3o/pMNccwJiQGq
         4i82hZ+HqCj25Nr7B4/169WKix8QzcZLpvW7iPIBtsCVmHZ+4l7+sixUCYfscScihl6A
         X1EDiorBqJDStrXy/RhbeLKbHk+rD7teNgT4cuWqYm8QFwOoUJ5dbCZ8Wqhx/Dm4bKmQ
         aFei/bjzqikGeLrDuKopBYsyKQ/E9XsLYtUo0hdTDIQs8bNlSB2zntJdJhMI0F80BdBu
         sfBo1N/bCcGRUbv1Llt3yMtopBIEYQEceHWt6ALSUpBeUrPxIk+RAJJl5MPgqiwHWmXw
         F6Sw==
X-Forwarded-Encrypted: i=1; AHgh+RrvbEhcdGQ398o8C+zeKLdO5jWfxxOIm3ig56MY+HcaWEmOqJYSnBeZ2zIWW4zuZK1Yyps+jAUcsOxO@vger.kernel.org
X-Gm-Message-State: AOJu0Yxz1tA/Nau+UxW77l1GA+rw2vAWMqotUZUryexgVae56HgtP2aV
	ZjMtoLqMrhrv6W9QOXz7yPbZvJomKKItgcBCGdpd9AicD0ujqk74jjXZi5ZiTPF6tMk=
X-Gm-Gg: AR+sD10OegwAcTPQy8bkGo4jkvhAHJRRwh9eWTDw++ogqlqC1WPu60WDOsRobF69jQ3
	jCLYo4V7xuoFjxHWuztNnxWB3vc4G8+ZreGG/7ipG++dcB2GLhS9JpLG6l9N2pwRIvDvilMlrCR
	jvHYqN4EP/XTS7ta/j4Z9nE6vaW8AshS/81P31cFXBgh5oSOfnAr0GV6Pz4tznd1DsYn4bIOZHj
	2xa6a6Nx+Nk5tn3n6a+aui+N8zJIFxK7Apv/CJw6+T0wAiNxs9McvWlkr8n739Mt9Bs9j8RW+dN
	keSEVmVU7T1w6MvMr18XvoORw6BLj9/R9M/57xGWKIJ5vieAR4bB4BtcCXF2xmgs/+3Ainakv4C
	XyS40r2L6JyV+lr0TIMqBVMEI6WUbYsRebgz/BIlp3BLdV2Cq6H/bVRCPrbf+ZmX5Rv5dAuq6th
	7KqGoetl58ZKY+5ppTAPscDjC1qFUdS5QfKnAvTdWVuP51vQaUnzwLTesPsGoWCoWYlsq3
X-Received: by 2002:a17:90b:50c4:b0:38e:447c:9a15 with SMTP id 98e67ed59e1d1-38fbc516655mr7151775a91.36.1785728481711;
        Sun, 02 Aug 2026 20:41:21 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38fb2bac654sm3299609a91.10.2026.08.02.20.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 20:41:21 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: alibuda@linux.alibaba.com,
	dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com,
	wenjia@linux.ibm.com,
	kuba@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com
Cc: horms@kernel.org,
	mjambigi@linux.ibm.com,
	tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com,
	guangguan.wang@linux.alibaba.com,
	kees@kernel.org,
	gustavoars@kernel.org,
	sashiko-reviews@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: Re: [PATCH net v5 2/3] net/smc: bound the peer rkey counts in SMC-Rv2 LLC messages
Date: Mon,  3 Aug 2026 12:41:05 +0900
Message-ID: <20260803034105.2051552-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260801094208.1937951-3-yhlee@isslab.korea.ac.kr>
References: <20260801094208.1937951-3-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Does this bounds check allow processing of stale memory?

It does, and 3/3 of this series stops it. This patch bounds by the size
of the buffer the message landed in; 3/3 copies the tail of the message
into the queue entry and bounds by its length instead.

The bound in this patch never fires on a link with a shared v2 receive
buffer. It works out at 507 rkeys for ADD_LINK and 2046 for
DELETE_RKEY, and the min_t() above it has already capped both at 255.
I measured a 44-byte DELETE_RKEY_V2 declaring 255 rkeys: mainline and
this patch draw the same response, and in two of the four exchanges an
rkey read past the message was live and was deleted. With 3/3 applied
the response reports 9.

It does fire on a link without that buffer, where it becomes 9. That is
the out-of-bounds read this patch fixes, and why it carries Cc: stable
while 3/3 does not.

Best regards,
Yehyeong Lee
