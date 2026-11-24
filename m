Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795505349;
	b=X+V/RbFM5GfcSVjPDqRJwuvk7um1W+9PpI8LpgwZhx02suu4UitEVE5rclQPSmrsOuvS
	 76PkO4jji5ADO0+MtfHzus2TKjeWa+GLcMBCRg/krqjiasQsitwR+ZX9rBtWWW/t4weMk
	 x8RqT4f4qRBhnZtse5Z/4v2in6z8eLG2f+Kb0GEIshyGfUWru8KSnSat1wArU/+QVpoKT
	 T27KlrIZf36zfo6EMj0VI2VCVUbXbngB4wylFWhGCQSLEPYPNV7dSu5a56Io3xhgcER48
	 xEz88/tK7lNngvFb+ySvogWG5mBQV9V+7oKl0fCRWeIZhxr1dq0rLdJBHaQdQkfIg8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795505349;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=i5K60fmvwEmavzV2HbQ6y0ufvklNifD+2bmJJtU7uFY=;
	b=wIvLCSq3LqPhrJSD8789P6bbxponXvQ4wHPy7C7ZK+scP4/PpbwJD8N5xd1BhiBE5bzk
	 MvpQ4MnodUa+H7CThmVU7VOb0rII4IbDRlo1CtZjJHuO2bC+uHvQEJek0hN2CBB3mGNf/
	 Y1u8hvnCX7xMC7Ud4/yXJiDdDIfrX1oj8Nvh6d4qWynj08Rd/rAhV0Qux9NibGiKfY1eR
	 7gViWKU43eA0DVjcIO4n27whHmY0doYtLC1epFk+U+Ydz/omSXuM7G1gV9z1SNheiaGcH
	 tsatNgtCk5zFH1RsZmjU59uUkNE0mLf/EBMa6q682IyWhRWm0B66a8SvkGnI0+RphRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IplZS4yt;
	arc=none smtp.remote-ip=209.85.215.180
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE81606A322
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 07:29:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1FE81606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IplZS4yt
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cc4be0e5351so3537677a12.0
        for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 23:29:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795505348; x=1796110148; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=i5K60fmvwEmavzV2HbQ6y0ufvklNifD+2bmJJtU7uFY=;
        b=IplZS4yt7iFWiBqF1sGzXXNr28tAyTBxelnjRoW/R38BsaGGufHVy2e+F1z78g1RLO
         SE3BbI6T10JIDGX4rET1dFhR+52jdiJiYlG8cdqGx2jDUGpesVM5XyqZKQ5MgeSiACpV
         vc2MeTpHte4eAE8DJxKn9bvqUOFpNfMb9VqvsNC/iJ3NYFFIXS0BsJyaXaijg7f8fqYB
         mNsWDyUj/66KHjAJ/SOW4uLZVULMi73UQ8xEm9UR4Oj19QjPkpo0BnJ8npx3OrqoqK/h
         mIQ9vagSqrPiY2tkm+ax321dapyNyZ09Ifboz2Sfqv7x+qPy8PvcE8EafAs8AFkXbr0r
         WmTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795505348; x=1796110148;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i5K60fmvwEmavzV2HbQ6y0ufvklNifD+2bmJJtU7uFY=;
        b=pVyL/F93bvtZPM7V3UBDa/185P3bRdBOjhXsqRqNinh/L9cUd4hbNve5A32ad2PmrU
         sOtqCCE+sj1iqcvylTTIohyK7BlVOuq2J6B2187uwZAOv1kttI9eBF6+8+GR/HuO35IZ
         MSr6LrpT6+tff/exaH+wTNj+EFHUy5cteXzmtoYCrM7if6hS+JqGOXCTwxoFlEQMK/Gx
         HUDCQpfzH4EGuk4tBt77z8j3oTQAGvSHa6GobdLriaYuojXEVigNJ/EE8K0hmIZ6/H/D
         uoDEVWbewLKXZn6kqlGGBOInLao7t3sFQuw64qS4b7f+PK6+eCTx6W4r75te8YG1KMOq
         kz0A==
X-Forwarded-Encrypted: i=1; AL+hErGvti60IHCrLEYhWKQwD9s8boi3OnmAVyCsomRlKs+HDRAprtgN6VvWT98zYGAT0YfrIMPRVQCRiSPA@vger.kernel.org
X-Gm-Message-State: APuU4Z/OCp8Vl2yjcm7LRHYQm4Y8y7Kw72vEQi/ZzG2Ni5O5MhhamsMb
	BZGOvXwG+r4FWrKZ5juqUe++MQfalWVsp37HsN5lyubsKfac2BpFKGL5
X-Gm-Gg: AZFdTZdQkbqpC5X6b6/kZztG4liL7CxcMMM5AT4g0r3ebbT/VQrMYN/lhxuUWZTuPUD
	q16FCsXvfYwRCzWwTGdKg43uH2VfAywOr+JgQ8MDUM98qICuTrgjsTTBcvn+zu7Mf/b+83BGJAM
	ZWc4gHF5JSYcUjZwp9NMIM2sl/pxwR1AQGm8z69xcnZeylI0C6r7nXFvhB3CV7PIrfzw4yoRyh/
	uTsVsC3X+cVKp48FVdkB+aKTRl2UaVGZm92YNSLdCvV4j7AwGDOQiCwj1XCE+PYZMo8/yN48IFn
	C5KNtl22UDUfkMRUFqrQS/sXnSVOAXkO6cYgT0n8Db38F0rbnXaIFAe2MdhJt7zoAgdhu+nVn/O
	7dctcnTPsrwXiSU10bs3hMuUsBTM7r3zuCZoSdMtdJLdz/4+A0FOt+liumfyI0cTLp9ZpSCsa+n
	poASnTADf7XiIHonY7uKKp04DAFsK1cQm3yHzrEXvLdw1T2eSf2aM/mRy2hPvWx/96n9ifHRqJc
	rn7pmkjywgNSqY2jxzZFyy05BWzw3+RcmctU4rCFtn7musgn9XHfN9Hw/T7PdUJ0GNRZik2fxX4
	1r3dT2JxunJ2C8PFq5+h6InHtD2ojOkWalI4Ftqndcf45NND4VB43aReHzsYbU8J8O5bDJpx2Zo
	zuDaIlmUBOiRoISuios+ogyUC1evPiQBFGsUx
X-Received: by 2002:a05:6a21:4cc7:b0:3dd:85aa:4524 with SMTP id adf61e73a8af0-4014b56547dmr13760885637.31.1795505348209;
        Mon, 23 Nov 2026 23:29:08 -0800 (PST)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa ([43.224.245.233])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6cfe9bb9sm6296177a12.12.2026.11.23.23.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 23:29:07 -0800 (PST)
From: Qican Ma <goonsomeway@gmail.com>
To: dust.li@linux.alibaba.com, alibuda@linux.alibaba.com,
 sidraya@linux.ibm.com, mjambigi@linux.ibm.com
Cc: tonylu@linux.alibaba.com, guwen@linux.alibaba.com, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
 netdev@vger.kernel.org
Subject:
 Re: [PATCH net] net/smc: serialize clcsock release against CDC receive path
Date: Tue, 24 Nov 2026 15:29:02 +0800
Message-ID: <179550534286.21006.10155127387498208795@gmail.com>
In-Reply-To: <awURtCvesMgSBQY2@linux.alibaba.com>
References:
 <CA+OT+OPkNsk2QHczVmb6KVJ+z_1tpH9DXm8JmACc5E6x-YFwPA@mail.gmail.com>
 <awURtCvesMgSBQY2@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi Dust,

Apologies for the trouble - our v1 mail had the 95-char hunk header on
smc_cdc_msg_recv() line-wrapped by the Gmail HTTP gateway.

Note that this clcsock release vs CDC receive race is an independent
issue from Bryam Vargas's CDC cursor bounds series, and I have verified
that it applies cleanly with zero conflicts both directly on net/main
(4392bb809812) and on top of his 6-patch v9 series.

I am sending a clean [PATCH net v2] via direct SMTP right away.

Best regards,
Qican Ma
