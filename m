Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792679992;
	b=P7K1q/HGL4uipm9nmnqUB/+Ocw7Krj5yxPXwsqKgDm5nkX1+qN5smvUX4o3b+Zc5I26c
	 JSLPBYiOa/6bVmzHzOi8QJwQ812GUS1ztDDYZQFY2k55E+N2ctFOp/nwCF/RCIsZ73pmw
	 RgLbAhh1+VqamoNI6EyHbvY7IGt++7LxP72uku/jzLmSlsjDyZc/qk1qy+SshZKUiY3uS
	 x9KAE/vdmtOUXSK7GJHn9E7D7IPtFiNiBS0j2bhH6mxSlsgRCLnhVLkUEOm5ZBHPKQtJs
	 XMESmsEJ5AILIIvtgAqEl0MbRmJBmQObYEqq6fIMRh5EYLivE4wg4J6lg91B9ofVgkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792679992;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SOI7yT0OHrSyCHbtS6CSym+qiCE7LQk8h/07mNJ/aRI=;
	b=j5EEB75qVoZLPqDRzxlhcdCXHZD76qfwdOQDkAhYgq8oE0K0c1MTTjFBdhnm7Elsg74N
	 ztHEXvqN7+gYh9+/74aUFlKBzshP1I4tp0HIutQ/h458nfxzOWspfNqtb6DbWdDpqevdP
	 Xo0a3wnLEXAgNriiV8RMnz8fXeaFXWnB/IG5pDXkL02iEIKEsFv11udab9MVXz0Fc/A6M
	 CHGWkQnk89Zq2QB7Z5/+5hIuECoGezhj6x7TesBKRcS0MBfzj8yrk+30Z3I2nRPI3T0tM
	 wP20sWb1MUdrjzFqg3aRSWf9lZpEzHHPL8dZQJmdALnIbRwZd0+u8LbXrSU0BThWJ1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b="HPC/DVkB";
	arc=none smtp.remote-ip=209.85.216.51
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36902606A31B
	for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 14:39:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36902606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=HPC/DVkB
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3ac7c7b3a90so942674a91.3
        for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 07:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792679990; x=1793284790; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SOI7yT0OHrSyCHbtS6CSym+qiCE7LQk8h/07mNJ/aRI=;
        b=HPC/DVkBo4HcbBXil45ZFefmZkRsZyJkf3WYjjWDRzkhswnw0IxNmsVw/vWBCZmtpL
         GfdrFrThBDAB15NBTdsVsGxhZ49VDftZoWjPsXHPPXBQt/bnhHp3WHvZbjWolg9rrmJb
         rVJx8p+uCVT1r+6J+5jrppkkxchpu8L6zqSdMJk6rSCThBnfXMYWZBH4a9V220QNexTi
         LTQrfnJEr0ZCGQ/4+GEqCOdOQgA2C5MDpb6ncaOU8rrbCEKr0gcP/5qr0F39vqXTyyvf
         TCSwVfEWwVUqRPS/v+ao7k0KAHkCrAUTaz+4BH2eGa7JqttC+rCRT3HVbHDfoQDfEKKQ
         CJbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792679990; x=1793284790;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SOI7yT0OHrSyCHbtS6CSym+qiCE7LQk8h/07mNJ/aRI=;
        b=u+JAB17fjZte5W60ln9DUzEEVhDluQECQ/zzYz6aHDTkZdFnXQSsm7g3KN4OL5NlkS
         khmyNxFJA6gkL4Er/nFGpOgWBXzj8SUgyRzpHiKu+LfDFDcLGeDLZ46qYU4pllUJUNed
         DfQ8srRy7uV5ZRzJlYdqgoTQrWCoCipP+jw/R5UBFHQLxcWhg8Pr0Zsn0wnAdLKUFO53
         9n3CKx2GjVjXroWS7DOtQYriPcvk3NEXFO2xFrXEOBTo1+1ZrlATetfQivd3dEMWftU9
         Qk4BdLf9lPEkjEtcFrsJuEYQnCoMpLN2ziMngEKXR2AazP7T3OElNAMEQGij1Lw+OKCN
         m0ug==
X-Forwarded-Encrypted: i=1; AKwUvBz77MmlszjozyOM+MIQN6DzoH1/GOuE2gcmrAPQUBldzX6Xf/FqYKC4yCC+V3Xp5cnp5Pd7otfKwf88@vger.kernel.org
X-Gm-Message-State: AFq9FYKAWPyvNef7dzBQ+XD9mmtT6ERRVPxoYm3CREAq8WIOwVgyA4c6
	nGRP+aT1KBcelxVP4Rhwe/tdSb2us9s4IIW1fb8+Kepb/FP4F7yKl9FdFSezPL9G5j8=
X-Gm-Gg: AYBFou1d5ofJzjlqCDg0/APju1J+S6WKeVmq7BhMw5F929nFLMvrLtc/OtWyMlf/RQO
	VeH6NYMQmbvaiowFwXKBLD+v5uqWaOrtSfin1iLl1c/XosDIJGDCdrxdoy4io/FnKVJ8l1E+ZHc
	UcIzNCbzSbZGzP4KQHlKNgA7P02leEhTZtM17cwAFLpok7sa03XKkT1jmf3fzKhbDDijHq2GMVE
	61d3992Ah4uJqqCTQuhNxewHZAx5HjQXk5g0vAP9J2YpVX69B22n2ADGS1vfkdTJqY9ru3HpGXb
	1QJFm5L1F6gL7VwbYZ6d7SZb6UXhM61d8YtjuYrN1yfCdOfthZFhJ4+TQ8khYvfIeFj6VJfIzy/
	qwMxEirwMlhN9Fz3F5pNC5g9YS0H8MxEPsb6eZfXgBabzZHesXBrDjlV4PYxgrBF7XZ78n2H5XV
	EuqnYLROwLaqmNjwa4UrYSYqhwMVmzPB8+h/xEn7k6S+Ywx+HI0uHvRGx/nnGdoUTRZWZp4H/ZW
	NXVcqFk1RsDHj9ZqedxBaNeeiDM69MLDfu500hi+Os3avFkcRvk5fTqRjWKw5djBV4tdnJ5SSH0
	dmI=
X-Received: by 2002:a17:90b:1dc1:b0:3ac:80dc:f407 with SMTP id 98e67ed59e1d1-3ad86dd7f06mr4369996a91.60.1792679990283;
        Thu, 22 Oct 2026 07:39:50 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:13e0:b266:5a7d:e119])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada4887669sm4719043a91.2.2026.10.22.07.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 07:39:49 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v3 0/2] RDMA/srpt: fix the indirect descriptor table bound and the context counters
Date: Thu, 22 Oct 2026 23:38:59 +0900
Message-ID: <20261022143901.2991062-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
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

Both changes are needed, and they fix different things.

A 510 entry table fits in the default 8276 byte IU when the additional CDB
is empty, so the bound accepts it and the counters then have to hold it.
With only the bound, a conforming command carrying 256 or more descriptors
still wraps n_rw_ctx and leaks every context it allocated. With only the
wider counters, a command that sets ADDITIONAL CDB LENGTH to its maximum
still walks a descriptor table that runs past the receive buffer.

The two defects also come from different commits, which is why they are
split here.

Changes since v2, all from Bart's review. The two fixes are separate
patches now. The widening patch says that n_rdma accumulates the
rdma_rw_ctx_init() work request counts, so it can pass 255 with only a
handful of descriptors, which is more than the 256 descriptor wrap. The
separate descriptor header pre-check is gone, folded into one room test
placed after the existing count guard, because the header can never fall
outside the buffer.

Yehyeong Lee (2):
  RDMA/srpt: bound the indirect descriptor table to the IU
  RDMA/srpt: widen the indirect RDMA context counters

 drivers/infiniband/ulp/srpt/ib_srpt.c | 12 +++++++++++-
 drivers/infiniband/ulp/srpt/ib_srpt.h |  4 ++--
 2 files changed, 13 insertions(+), 3 deletions(-)


base-commit: c03c1a14507dfaf8b856c2608f9ac216021fc222
-- 
2.43.0

