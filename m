Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792892838;
	b=SZhaEVCZ05Ik9BM8pUabPLd7XVdPFqnVs4hjUIpw4f14+bsT/oHmPmtw1ft7aC5DPkrX
	 nWKCcJLRO0Fvwe1FLQ/1KeJ2pWVDXPatFYo5dPw8LR7UlQA2QcSaeO+6qFDoS9PTR2529
	 sg8QH7Vt+1DuVFBlgf2PvEeHnLYy0STLJMm/zWiLAxtnNKOeBxsgQofyR2ncvIb8FETbp
	 XZOSXV5LnFMtzqDfcUyH/Pc9M3sJY3aeUnS52yw8bqegBjHRFDkButpSe6n9hXg5l3SH6
	 w4d3OeYd5vhJq/9WJWve/E6bmoyLUYTYTSBqg6Zi3IoEM1qBUN441h162OAVGOLqZoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792892838;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m2TX/K6jADp5DrZJjz8JnHFJ2oJhNK/mzbZjK4Sp/uA=;
	b=Lc0AKPkpL17Y5hiXSkCOkY1e2C2PrPc61TRaLsqJDBSQgNsG/HrxmJYuBgT2la4Ordui
	 q43+0Otds4BYQJHWpUwwO/u3lPNu2yZHbIIr/S+QgRv9DgSYEg59QzpqI9NvfNmwT17Vv
	 2Eu0uLMoh1uIEe+15vFsyF4fvQYZDPuUQrwPNOmTFtEFN0HJ7u8m3dgFpQstvZ4L8G1jZ
	 +EgZJH92I9e5XVjNnYVWx+0Tb3SUeQ4hsdIlgJCcBOd6NRc2NM/iGi3HrrhD8ILsJ8GYf
	 9VtyKljhUjpD6cNciFHV1VAWah0L893BJCKPeUh2uSer8ZtK2evlsSKdLhhPPDaHhKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=QEwtf0Ie;
	arc=none smtp.remote-ip=74.125.82.52
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD99B606A31D
	for <linux-rdma@vger.kernel.org>; Sun, 25 Oct 2026 01:47:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD99B606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=QEwtf0Ie
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-18cdcfc05ffso2314302c88.1
        for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2026 18:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792892837; x=1793497637; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m2TX/K6jADp5DrZJjz8JnHFJ2oJhNK/mzbZjK4Sp/uA=;
        b=QEwtf0IezA6YHXZvOT2zMKXka+shhhjpqW8zp0xZjbo9RoGWXKtazpU052jMq4aikY
         P1aOfJD5pn7YBUIAYTpmN5JvIXl9UcAxtgoNP0Wuum0zsCFn0KVIcDlYaFH61Oh3JOGa
         J0Xo4Ks+/eXAjVdS4K59kMW9Jd7Q+/uaimoLmuhIOsQwAINSiCEVezjJJb1DNMjJEDrC
         CRa8VwUHJ2u+OsJaVnwhK4XD6nzQS9bPxMB3ecqG4O0PPYPKIBa23odvI5psIfGrmZMn
         wQFighkpO/PCaKaz+x0KcLOp4LtxiHu9yidXdfUbHb3w9mSjGRfGYaA3NA1Jl5Bi6PP3
         O0nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792892837; x=1793497637;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=m2TX/K6jADp5DrZJjz8JnHFJ2oJhNK/mzbZjK4Sp/uA=;
        b=W//sttP638gD0ha7hkYZi9hfQOPgxS1BMfufjZRYHEYhRscP+v1ANH3XhF6kxOwu7V
         JqZSgZHEPMKIQO2n/uod96RoICyVYB5SVbPeq+mdFpspNlKnbOIIhRHIOBqsBIjqDELp
         7QLdlfdHoEsWzIBx266TlwnuAXBDtTBnCGUOdPwsuvATmXponzko/1G9y437q081NTky
         o8KkYa9ED9WvyfcN+p6bQTQXiMGJzdGe2D0vt4txDHAr5QtKifTh8PjIDxyiff6k7HQh
         KvykhlcOf1xALFsrMLGCSPTyu75hddBWi+PC4Xxglc/feWsr+wp8XQ7ZeQu4HbBP7jkN
         RsYQ==
X-Forwarded-Encrypted: i=1; AKwUvBzh3H/6IVpl9YowKay1kcYBxRcbFOe7f0Yzar1PhuleGnZFm6FwEtwPnxQTwRvXyUPvotsr2OS/gJoU@vger.kernel.org
X-Gm-Message-State: AFq9FYKHiTqmCyuTMJq3kU6/+far/LT1sWJ7hmmWdb001K/EA5UIryj+
	iFTylIQCvMhKVleZqhHL7YsXSAXl8oM2+SnfI0bUxfxuGDhp/20O0wIcK+1fNEbG/7Q=
X-Gm-Gg: AYBFou2pU1rQYGKg6b3mKyrvCDgbYjY0sRPL7bDvelF5Ky0CwJzuKhikbEDKWZs2Uih
	/0/HqOKhp0GNM7KMl3g8nW7d9D3/jFxLkefQMYanvTWCeDQ8rS58NzEjZXro7K3W60Rg+OraBZp
	bfJF+TYU2JevCsUEpbplLR/zTkWUaCowBOQiEU6qaiZGEdjN+VrkyOl/HPIPkueuYTKVcI3IbCm
	rWYk8DzE+fYFx0BxqOdcqTtKyS5isQF7B3a5f3lrAa38pflscv1bC0flJw/sJ4PwLXNRa9fJw9d
	rUfdW8wcNeQ+ypPvZYMQAY5xif76iGAfczz8i4JshETHs7LQHo5nW5A6uxgWzikBRok8iiT8iVT
	kHLdOQXBihhylo2EkCkSpyTrM75zK0slxiulCEp+zzOIDPiupt73w+h/MVD3klHpJxaLkskKnlm
	C20WM+W5HxwHQ0Ei6g6Yuml2NAKW1q29ocBDkkgOhmeYDUBGn3PNldfVO91uZSwkjehdgmnqAix
	gqKzsw8nr4X+PyFDebFMMQUdYfbOuy0zboq3L1K0I/LmHnd0gQeOzYhpk2VlSopE2UePk9n8rtr
	Lc4Epee0+f3PgCp/AzsdmapXIddPTDbIb9IYBrZkgiMM01r3AKcrelm7+oE9/NqV
X-Received: by 2002:a05:7022:3d81:b0:144:e38d:8e52 with SMTP id a92af1059eb24-199374f32d3mr5050179c88.37.1792892836882;
        Sat, 24 Oct 2026 18:47:16 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:dba3:be57:a674:a67f])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8c572bbsm11981252eec.2.2026.10.24.18.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 18:47:16 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: sashiko-reviews@lists.linux.dev,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH v4 1/2] RDMA/srpt: bound the indirect descriptor table to the IU
Date: Sun, 25 Oct 2026 10:47:03 +0900
Message-ID: <20261025014703.3756487-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <01fb5172-3f8f-47be-99f2-20f2c9a5244f@acm.org>
References: <20261024162852.3528224-1-yhlee@isslab.korea.ac.kr> <20261024162852.3528224-2-yhlee@isslab.korea.ac.kr> <sashiko-outbox-183819@kernel.org> <01fb5172-3f8f-47be-99f2-20f2c9a5244f@acm.org>
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

Thanks. v5 removes the size_t casts, uses struct_size(idb, desc_list, nbufs),
and rejects nbufs == 0, so the code does what the commit message says.

v5 is now three patches. While working out why nbufs == 0 reached
ib_post_send() I found that a zero-length descriptor is not rejected either
and faults the same allocator, so I added that as a new 2/3 that still needs
review. The counters patch is 3/3 and carries your Reviewed-by. Both are
described in the cover letter.

v5: https://lore.kernel.org/linux-rdma/20261025013748.3755639-1-yhlee@isslab.korea.ac.kr

Thanks,
Yehyeong
