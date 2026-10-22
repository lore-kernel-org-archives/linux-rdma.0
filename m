Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792680355;
	b=zQeihv+e44PNlwnz3Bkufy11kkWZ7vEqvEHidRoAikoPZ7ZB6B2QeHnTcoLOUdT+RSK1
	 wlXz6wJExb7VqAK3SIxlakpga1t3pdtDSaeAoQcPbzi5Qi6Sq1pARke2RMi89n173BDzM
	 n9959Q9htrlQhV+V/TFJEpJiZNhv9tb6usCCp1xRdlKlvsDIu2J4an0yRN1Da5cozjbfO
	 4RlTHKbGP3uQOA4YilZ0ETa7pwzqnsULCKb42v1qWTXtY24hHI0plzTuUkjIQNTt+S9Y/
	 BVSICjVYROoq6T3X7Zi12/dzNIJ1pB2LRh7tF8Sfc7txYTTRihvqTJjSE+prA+rYekA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792680355;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HS2nYUP5ow9Zp0MfzPStFKFHiEiipsNUBE3EourQz5U=;
	b=34Qn0F24C7Dx+g1OcgJUywX5JmbAQKvywDC6g+illW11+AxqtxObuT7RMKuhc+ffryat
	 eJ+la4N7ko8cRM64JsiZPgLJPYqU/c7+mWVHDJJDKQSq1GoztliF0EQq7TUcsqwQlUwCb
	 +HmoBHjDgCfMlowoUPgA2u8qgsh+irOt387MQ32eWmoJ/J6pStA9VO1tcyOJoGfX4BaXN
	 BLLC0mf5clfIV9e5/W7RVzCl619qVbw1IxWKIWNNn5Ep/XIzG0qNmza7NDNeW6HVJdyAY
	 c+6gtV29qcxNCGMe8osssQdlWjhxR6pjJ0zS10htcjJzq1NKUx9xgFHADG/6m73PPTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=qBNLJbzy;
	arc=none smtp.remote-ip=209.85.216.52
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56054606A31B
	for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 14:45:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56054606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=qBNLJbzy
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3ac78f4c10bso970113a91.1
        for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 07:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792680355; x=1793285155; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HS2nYUP5ow9Zp0MfzPStFKFHiEiipsNUBE3EourQz5U=;
        b=qBNLJbzyQ2fv9FJJZOr8XO2+DYEM9XBI3CpfM2+b/SPLKiMsDlJZQrMSr++dmOT1LS
         OxzwP8FIXM5d/9mkVTFj6in4DKBcl8IsYD3pldGLfLoOYLfFv0zVF8+1oqWZVYLOHPh6
         z5KS1ApsTdd5TJFmv6N3bjVE/QZz4IDsrCRjFue/lWVRZPMjYWCzez7jjNwnQWZUfxyP
         bBA3zd4jd7iWBpgb24N62Cc7h/nlKVB8tMHrLZOk7D4ZVcUhtvsjhzkP2eFPWbe3vKnU
         glLIe/5+aQutul0CSUe+RWL4WB9TbRonzcS4ZMaAYffs7UOPI4Qt05s5PX98DtoF14Xp
         gtiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792680355; x=1793285155;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HS2nYUP5ow9Zp0MfzPStFKFHiEiipsNUBE3EourQz5U=;
        b=2ArN5b6BxSi2NuXCX0zN0IqF3m7VNr/KI21aiIMmtovx2I0k1JC6J79EfvuRQ2w+95
         glUwks8a3QOZPdGasOVCjXvrka60CEEstk3f/1vPVdgt9D7hzB1/fTpSGABdReqFy0eB
         OsGCBtlEX0Ipu7UBIqjevvk5vzNSDZmYWcueQWUotChdpGwxdvIy2sS/YwEAvi6t8nyr
         BEMrkxt7VmFMmY2LLqW3DA2tC7Hxtbjgeng6hHNMD3xEj+njxg5U98JncCbu07By+bNG
         OrNmVOmhR/ac9RTVPxjGvSPRbk5i9Pe+l9Wl7b5Rh+pwsrlUiqhbn6WiXuEJCvyW3V//
         yo2Q==
X-Forwarded-Encrypted: i=1; AKwUvByeI6VotAqmCF5ycKWSeg2jv7X2g0iu28uPhgjB2KFH5MPNtCC2T3LgW0NnN6egIwwB9JkBhfAi9LJa@vger.kernel.org
X-Gm-Message-State: AFq9FYLEisHMhhsTMd7N6j2fEbfMYV8VD8lWmtImLbiJP7ZCarkQbHRr
	y6A3iqRyh5V8yfU/4ZqoWda0BjMF6OlNKGUpiHyigA/wbHy/8//bXQ9iy2rZq2Lp7XI=
X-Gm-Gg: AYBFou3Ttg6GhyZRNnKYOTBYLieak8ZDUcDRuKP606/LMiuvhaam3tElGG8/JqQaudm
	RGGGj6rOTUijTHcDm/cNQh6g911yq/wh2xsDbgTmYIfzQB+ma1LJkQj7h0P7gNiVvI47LqsghGi
	u4k5thQ5k3OkypYGuJIOy/05kJJWnJQD9zyay5e/xq3k5xWnW+3RtiUcbEX0hTb2WJhLzzXCEIx
	b3Bi/A50cz1FhS3/SgN1EkSkoNYsYg7ni/E0a1nkwlU+sjz+Od9Mcyzol1xNIPfcufpaQrX9HMm
	bh9yYFK4qokLIbpVkg7st97g9fh8dtixEIShgwIB1TxfOr3ghC0Xwy91Q14p+oT8e/UaUV9rYFs
	p0D/Wtyoodc4Xezeuudzpz/d6MBG87Xo9YSko7alV+AAR1eI/7v0zRjZejkno3jy+4MfgvRnFiW
	F+HKUnS/csN7LutfRdN1g/IRFawp+YMXh/b9FaifMgVbmTiXf07Gk1KDbPkx34xtKn1hkBqvM2R
	RuzG20Ty27dxAoMFC9LbLS1AFpnrFkFJAKLHyiQsFdX3R3ynVybzkUl7Mrunt+AN6qjEH3cqZYN
	tkA=
X-Received: by 2002:a17:90b:4d85:b0:3a7:250:333e with SMTP id 98e67ed59e1d1-3ad86ccc8a6mr4599506a91.11.1792680354722;
        Thu, 22 Oct 2026 07:45:54 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:13e0:b266:5a7d:e119])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada48ed74bsm4551444a91.3.2026.10.22.07.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 07:45:54 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH v2] RDMA/srpt: bound the indirect descriptor table and widen the counters
Date: Thu, 22 Oct 2026 23:45:18 +0900
Message-ID: <20261022144518.2991452-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261021001854.2343027-1-yhlee@isslab.korea.ac.kr>
References: <20261021001854.2343027-1-yhlee@isslab.korea.ac.kr>
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

Thanks, all three are addressed in v3.

It is two patches now, the descriptor-table bound and the counter
widening, each with its own Fixes tag. The widening patch says that
n_rdma accumulates the rdma_rw_ctx_init() work request counts, so it can
pass 255 with a handful of descriptors rather than only at 256
descriptors. The separate header pre-check is gone, folded into the one
room test after the existing count guard, since the header never falls
outside the buffer.

v3 is at
https://lore.kernel.org/r/20261022143901.2991062-1-yhlee@isslab.korea.ac.kr
