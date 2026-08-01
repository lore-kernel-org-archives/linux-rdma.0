Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840E133F585
	for <linux-rdma@vger.kernel.org>; Sat,  1 Aug 2026 09:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785575560; cv=none; b=dk7Q8svy5GNg6oYtkOGtbDCRpziKUVt5ekjwyix1Ksfng7d5zL5UFG1f5sGXd6m6nSmz5A1pdsL+xhIn5YtARwyqhCg4DPUZPtRHQXYK7qvA8X/uDaKNsN4WFP6WBRuTuqqnZlrg7D/IWfdDhXTthV1RGyxbLZLybR/OP/dV2MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785575560; c=relaxed/simple;
	bh=WtKwboX1I6TACBp1mPchjcTdLWsllHrSvbiZnJsT49c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RSdf0ug+rx5Vb1c5G/gU4iD9JuVgYV4T3wEoy/GocP4/mTBnoYTl76VcWCjjY45BgI4S04nqXkMexSzianjvS+4pcRSvcf4n4qqLocpHQnfLx1qLyI960WM0jTU8AxevI0jyPmnleAQK2nEto2YscvVKWzAaPbWIcs1G9S80R/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=kSvakdbn; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="kSvakdbn"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2d049069377so12676895ad.0
        for <linux-rdma@vger.kernel.org>; Sat, 01 Aug 2026 02:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1785575558; x=1786180358; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=diW7eq1K5OgM1EddS3mEle0ywoNtUEUmAHB/nUoYXXI=;
        b=kSvakdbnTPxX13Fpn/tWdUQm/L1zgBFHeQP+9rBJ/Z+5GVEdk6SEZ9AUkVzTCLt50v
         oC2Kaf1hsHNNfuGi0CfdOAWueL2qUo8A+NAVW4PZaMfAQ2tnU1/OR9zkbkfh9eawkpu9
         KHEe7kU0bhSP7msuvbpaIwbvLt/fITbGxzFrft+07FVLADbJ3gQBsyJBDbHT/ipDRqmB
         OMkuU2kES6d00ESeMVUwO2lxvoHpj05ERSql8jhl4EpRCoTEBesPBhNTeATpryL2d7cM
         IrJ6XY1vLztQ3Zeg2uyTV8ZjnD/nwZBaQbjT4xQnSjzTeQ3RXawZATKQXMyCytRJBk43
         TbRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785575558; x=1786180358;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=diW7eq1K5OgM1EddS3mEle0ywoNtUEUmAHB/nUoYXXI=;
        b=MefgL285LiXMeQa+/OZEUFJt1EoAkEWCpLOB5GJC1RmxRYYcq1OTTpLxuWTE+B8FVf
         tPcOljO/XxzdhuT3WvlMBGvvEuZK3NgAM90bXB07tbSzp4Q9fXe9CiQ2VjMBFrl33kBE
         OF30Di0e+Sa4EBJcm89m25gvtxgU74laX65NAlv14JjvZFnBMXZMqwCB3yBv9vNp9LLH
         zuUpg/kp+c4hTPaR3LkFg4PXlJrUaY+h2JRs6UDRFjtSVyanHReedqj1rwAPW4xGTrzJ
         /eh5GM3ptOm4sx12sPN0o3Dh5q+EkfZ7s1iAq72uAPVTzmZxIyDhzN8k5zU+rUvVBJgj
         ydrA==
X-Forwarded-Encrypted: i=1; AHgh+Rpadh5woxW81yVxBZm5dO34T4LoKOihJzlt1sgOKnaGHBEdImCI0rq9h3OCjXAjX3rqIUqCr9RNMTSA@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1NyiJqPUvWS1idvqdsTBoCsCS3Wtwy3eZkaPxQby1izoEzoX8
	V2peJWTSFmBJNlyiEV1RjhJZM/7b/Cc0mcnTvH+a09NS4oMd2UB8co5faXy1hQVYYpU=
X-Gm-Gg: AR+sD12/4u/wWtyefqL0fJvFeJzBKHoV3D/5WI5cqS5sCL1WSi6FYOTFSeHsUUyB30F
	1HVRIaBMDCpUcSKysqUBtnGp/QqLAmJAuqf5+1Icz+nx43sIdijUDetff0Q+/iG+e5DpONhvAJB
	QeJpmXaJhpmRKfPFJFcRIFqV1GT6SFZ+u3DdXVDxJ6ZN6JU8s6q4uSmDIeqtRNAeMS8yJKJH7Vi
	iU8FvochvQ6o4WjPk0Gu/vRkBwkefUB9Fvtrsc6rR99ZJBLvmWv4aMNHiTKRPV1qvQ337PTJAZi
	f8xKADRT2D4Dt1r7CXF+vjl048ukw0brrRoFXOu2egHQL6jhKABxlc3Ugy+5VvcBvWDWdb46Yld
	2pDRyikNAd0FcCSQb5MVdpXtL7ofQeKwm8hc3wtz+avUllZNvLkQGh3ed5raFTqOjA+ZFtIF2rK
	iz8cslkQAGIXyQjQCMtSSIksCJ7YPpoPxMKVK5NO4s7kZsu26gvPrQ9qqAGr3YZgxSg8RXU1JxN
	8jRq1syKMo=
X-Received: by 2002:a17:902:ebc2:b0:2cf:bf32:b754 with SMTP id d9443c01a7336-2d05219f1cfmr29858925ad.8.1785575557981;
        Sat, 01 Aug 2026 02:12:37 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:c329:7b28:fe02:5dc8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae60139sm16175285ad.29.2026.08.01.02.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 02:12:37 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: alibuda@linux.alibaba.com,
	dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com,
	wenjia@linux.ibm.com,
	kuba@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com
Cc: Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	sashiko-reviews@lists.linux.dev,
	horms@kernel.org,
	mjambigi@linux.ibm.com,
	tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com,
	guangguan.wang@linux.alibaba.com,
	kees@kernel.org,
	gustavoars@kernel.org,
	gor@linux.ibm.com,
	hca@linux.ibm.com,
	agordeev@linux.ibm.com,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v4 2/3] net/smc: bound the peer rkey counts in SMC-Rv2 LLC messages
Date: Sat,  1 Aug 2026 18:10:47 +0900
Message-ID: <20260801091109.1933145-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260801070548.365231F00AC4@smtp.kernel.org>
References: <20260731070509.1818665-1-yhlee@isslab.korea.ac.kr> <20260731070509.1818665-3-yhlee@isslab.korea.ac.kr> <20260801070548.365231F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sashiko-bot@kernel.org wrote:
> Does this early return cause a permanent protocol failure for devices
> with a single receive SGE?

The buffer part is right, but smc_llc_save_add_link_rkeys() does not
read that buffer.  Without a shared v2 rxbuf its llc_msg argument is
&qentry->msg.add_link, and smc_llc_enqueue() copies only
sizeof(union smc_llc_msg) into the qentry -- 44 bytes, which is where
the extension starts.  Same for the delete side.

I logged what smc_llc_fill_ext_v2() writes on the sender against what
smc_rtoken_set() gets on the receiver, over rxe with max_recv_sge
forced to 1.  Unpatched, the sender wrote four distinct rkeys and the
receiver called smc_rtoken_set() 427 times, not once with one of them.
With 1/3 and 2/3 the path is not entered; with 3/3 as well it registers
six values, all the sender's.

So nothing is lost -- what mainline registers there is heap past a
72-byte kmalloc, which is the out-of-bounds 2/3 fixes.

The changelog is wrong to say "nothing beyond the 44 inline bytes was
received": it is received, it just never reaches the queue entry.  I
will fix the wording in a v5.

Best regards,
Yehyeong Lee
