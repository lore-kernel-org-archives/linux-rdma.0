Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793755448;
	b=UQihLSKE3RIMOyAySuOE5mmQJMcnsxftSFQNIu5V7t4s3pdiHocENXdfEfz6WlXpU9eA
	 f9xPwl/27pNeCvdpFU2th8SYRhzdb1WL//IhNRgx0Lq3eS0cnx3Nl7dgpLL6LfhZwkpfn
	 8ST0xMoMaazj0qSmRX1BRAtrPA+8BvZJrISzb5d5mD2WTHe1U/gnfhekQE7Rwp4Wq3zDF
	 szyEnBbVQeGBlOtuHcm2jh2oihcXlvVJMqWkjtsAiSy1o3Z5nhKEGtlR/hQetTnVWjHq2
	 ulGZ7QQHv3MRO3ypA+2Y4WCqe64wvTppWiiDhpZtRDL+8ilyaL7VGMPOMpykDnotZzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793755448;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CyEBod8U9yrktbOchdQg2w94UgrKibnqgXSxsY325+s=;
	b=3ImAffSV2vVQaWlgztWiTHx287wO4TXl1NcUZK1JzFpbl8LCFXDZB1GKS2GBbSe8rPME
	 jZBs4MF91Ui44q6wlBb6CxQPLfuR9OFuI+P9bPhcLnICl+xxDyaJSj9fa6fWVEO+Xjum/
	 bfCx14xVwwb6xIm6cfHUbtGBtddwhS+pviAaAs883O8srI4zRs6oUPi5b+gxHxg/CFIXv
	 XA71Odh3Dnrnb0l0BQYnyo3tLdk7YLd11WoXaa6nmL76gG6cACgCy5KUDUyeazJE1qDnB
	 YRlfzXH9y0iFMxk6pTNLeI/lwr2D1rGK2y9DgtXNau7u11oleUPFPXGNKGi76dQAs6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ERR3wnij;
	arc=none smtp.remote-ip=209.85.210.171
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1323C606A32F
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 01:24:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1323C606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ERR3wnij
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-89d6bd67045so57431b3a.0
        for <linux-rdma@vger.kernel.org>; Tue, 03 Nov 2026 17:24:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793755447; x=1794360247; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CyEBod8U9yrktbOchdQg2w94UgrKibnqgXSxsY325+s=;
        b=ERR3wnijf1jsNe9Qdqkrh2JIJmXEevbKnf+o4/cuu88tzR0YfjP9dSlA4F57zxQb4D
         QKivwgmy/GbarHTPLM4iSd9WnrR1MwjBJP8Go5n66xS0H6BTDiRl8FmeH4U2j0YIgNs5
         RAGMiAZMw5EKRNQ+jAayyZSuSwQLTJTXdQtQ0+yxM1BVSy2V7vrx6yGE0Z9iHhLtn2Ly
         0reh6wCVlx7p4D4JTMBW23HwxJdfvFIs1r83PgfUZqgCK+MmPnIy/SW+WBUDYvUBAyrz
         qouD5g2fA9eRU+ZgVWGJkX7Ej3TpGus9gKsbG9bCfOLLWinmafn69IlIkNGvsHRxH7rf
         hh6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793755447; x=1794360247;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CyEBod8U9yrktbOchdQg2w94UgrKibnqgXSxsY325+s=;
        b=sgkPVyJFO/7xnAZa05kvB4etLNB7BZr3WxedegDcRa2erzXJ7loVm11O8sw5rBgUfT
         HsD731y2/SJVrW1tYe6l0aeUZRanwSTVgYSkQkhvlgYeFbdtps/52jxosNJ0M+8Zh6Dl
         H6oPXnWer8tEz9X3ID5cMIQUniPLdk5Cdno5T6H8ivJPiPNmfYFl3tpLbX2Q4lUT/cw3
         /6V70SqWKEL4gnne2yrX2tyoAcy4nplakZZBaedt5ryYfNWv+cp0c0vMj4N317QFOdb7
         kTcbM4qK8YQ5bLGQF2+tFuCWe+FqXP6qp2I5iOFUiiOmRS8+9ReM/Ju+604qiIw2qzJz
         th3Q==
X-Forwarded-Encrypted: i=1; AKwUvBzHpskfc74XPieceBosZLaQCo1UXul2K7isDC8w4Brv5Z2snpc92K64kW+gzAP8136Xb8YINEbpw6uJ@vger.kernel.org
X-Gm-Message-State: APuU4Z/DEO/53KaOMd86A4gnNIBk+6pjVDt2O+JPjzkWhCyh4ZT2Qejy
	8OAx9eOl2zMB9iJIOLxoy+Dp1jdvOxbRR9xT2S4ZhaLrW9KxBW/NNpHF2/xPC1n+5xg=
X-Gm-Gg: AYBFou3wR0QlAzbtCAQL0zaqOqwPpKYLOiQvMy8bsk50I03DH6c1O0TFZOlxVMnKnQJ
	XUQDrciPF8GL+RheUKBhwQA9XtnXBTuoYPvcRAWrYjiHBvdy4H3wt/C2nKBFNnMbFsyLcee5WaJ
	H5jDDZ1uRBM/zl6HMujYDdFHisXsHJvcis3KjJ0rGBsDgF6+kxjBvg2krnx1wV8KQ9A8FxfXSk5
	7qQpFvVnpds1k8hPl0dqy+2McVk+gLKWYFHazmyrxviVQkXkU41F62EXdzgUglF2JLVEx4IYOKP
	7PRwfqN4MBbKsyaCU4GxXsLQa5ZWmvkrQTD18KJ786mFEuOJ2fbxEAmhofP/mujgSrjwBToHwd2
	4j+8kKVlOEkcP363CMqloCMBToM6J3FTVaodkFmYV2GiaBPjE0JSWCxmpnLSQkBEXDdnl9hYY7s
	Wo9d+YHiSz1vN1YDPG6vVXmS3Ehte0UqtD0Sr2wkdROVIth/yr2AL2VVimenUE6Kv/v54ER37KU
	fpk2EK+WyzJpIAZmq2Hg3ouDDyPxL8oCTlu/4SNhrCGGBZ+a+IVvqIOzyfi8G5vwVx5c8F5Oftv
	6kwLkcYTTLcYDhYgci71S8YvNlpsl3PXVgLmwKRODlsw8rbgTFXZGJPLjzaO8nbUCIm6IS0JGo1
	q27Wj2WWhNCDV9GpkQjNZ6JaO4nvw97E9eK0+
X-Received: by 2002:a05:6a00:a256:b0:882:2195:5a73 with SMTP id d2e1a72fcca58-8a9bfde0494mr7910507b3a.29.1793755447467;
        Tue, 03 Nov 2026 17:24:07 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:744:cf40:a7b2:e78f])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8b09a7cc082sm197577b3a.12.2026.11.03.17.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 17:24:06 -0800 (PST)
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
Subject: Re: [PATCH v6 0/6] IB/isert: fix the device removal use-after-free
Date: Wed,  4 Nov 2026 10:23:58 +0900
Message-ID: <20261104012358.1759607-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261103223802.1697607-1-yhlee@isslab.korea.ac.kr>
References: <20261103223802.1697607-1-yhlee@isslab.korea.ac.kr>
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

This series is superseded by v7, which addresses the Sashiko review of
5/6: isert_remove_one() now sets the removing flag in the same critical
section that clears the client data.

  https://lore.kernel.org/r/20261104012219.1759523-1-yhlee@isslab.korea.ac.kr
