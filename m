Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB709339719
	for <linux-rdma@vger.kernel.org>; Thu, 13 Aug 2026 06:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786601764; cv=none; b=cfPUwmQkwrrf3+51imwmgPYIHdPd1+qk6HpjZCc/qVvO5BY5ggL/qag03vY8fZEbIsmP62oeeX68t3q33qm51T6t413ATEF9Rb7pgGecokeNyNy2JksUGKW9I+EtaU8fjmb3Rgn5n7Dy09QHzy2T3oetVZgh+NVhk08N3SMmSgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786601764; c=relaxed/simple;
	bh=sOnC6X6Gs/SA1VdEoaAslErXkIuBHbfJ2Vid+d8k1n0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cb1yN6fX8hacI7Pg18u0wZ2ALke2SIjB/4TBiGZeaimwKH243IQyjDVpt7F34BDzkKbljjfRECA5Rq8MPlIrV9C8BX62R9pXmXxXNqwt4mevCKIXIL9/YZIf+WFNu2U6TT9t5T0qHTv4cccnvz+SWUlABFgLUmzgua5KaJ0dfcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=nkF9rRIL; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="nkF9rRIL"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-382ef647e20so419802a91.1
        for <linux-rdma@vger.kernel.org>; Wed, 12 Aug 2026 23:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1786601762; x=1787206562; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G+XeDMuFDGYhAwuT7KIqlxZA1fecELK4uMec11zcI1A=;
        b=nkF9rRILICfxAhXmOghJN1CFrfx5ollkaOc/RxNcfzD6E4fO2uuJnKH6+wjHtxKQsW
         ZdoPWAW0rsX01rLe0afhMhVLRA1X5bdGmB/EVG1XEpDd/aweV7Tp1d45+nD9EW7FcNwA
         739PO/TNdodg0l/we3y+H8WBi2PFai/8mN7vqAnCTW3DRbT+hjpFTQi7ebmmBlSMlknv
         K59oGmATJT2UlWtFj5faz+t8bvhagpD1sV4WQ3Jl1nZyBWY+tkNZPU6XXwSmZ2ubVXzn
         bTuJefcCPX+9pDsUDy9BxilMZOfuP2AKVMavnZWy9Y4q79gzxglzcFocdqAt6H2BXOE6
         nTjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786601762; x=1787206562;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=G+XeDMuFDGYhAwuT7KIqlxZA1fecELK4uMec11zcI1A=;
        b=GaiVUesAbK1wb46wJshOkc3OtdfeV6m+eEOm75MR6Fs/3aSuNEqCHSxQnvK2eBnpBH
         h2Vb+w+FZLApLOCVklYazX5CNJ1DUMcpBBCGa2qFeAozEDvQoyFeFqQMMhqmBiLf9xFD
         7BoM3qOMDW8McSUQs0xqeNHzsgQw5aTpgSaRnsFA48tStbXK6PGDJHPJ2zXdeTJy+vMs
         TwjK/73MczYXVSoJiiAdJ60v2n2Ljc10PEi7zQOwVZvHThSkRN5sytVYGmx8bV6R5KM4
         5ljA0dhdp3MvM6mB68oi1BgSe1aVU1WbxudgNr3fhXBt/AIzX2CYMxR2iWv8mSpZp6wP
         W4eA==
X-Forwarded-Encrypted: i=1; AHgh+Rr53Uz269Xonmgjl1lEqn3b1eH2TqcgjYS8JyMBosbbmjYwhnWwGOl/ViUEtWfv2CiKKKg3G2rOwpVC@vger.kernel.org
X-Gm-Message-State: AOJu0YwgfNleUk0IN7unLl2FHvEh1mobstecN4kWRXnXDONL+mdM20Iy
	1JMTQXdrNgn7919xaeZUYH3nJmx1DJshCg07+SbSedMh6W2J99IKdKMU2KkSZArvCA0=
X-Gm-Gg: AR+sD10Bp7VnrkDj9s1qHDHpakyViPRtNS3+OZ4S0bvOupt7o7kLswJtHtwgHtF4jP9
	IAOvJ8EF4buGQg33aCPjCH13AK9nw0SY9SITSFG8GegQyl0JTelSLuaqAWhbx4UDb3oVi5E+5Ct
	gORkWi4862f16KYKJjeVINc5oDZyvInZLN5neVP81i0vUASM0j4S6zHb5QTb4jlLNEvpDOX/HVW
	jofCzz6XJLpMKnCzVMlqiKZaXgbN9nw3Yfa/uYFhtMamgZCvZgp7OJkd45IUw2etyJSHDxdRr2M
	pSftd4uJIjuBAOnUtYh2/lTICN0VjOSt36cZVhOjoivAN9U4PtLi33XE1fCHVStIRt+qwdvdEMs
	Csof3YcqCcP16uaSO8x6PL5HhVS9BqFqa3CwsKW+TUoyZRn3GMOiYBUFLjgkt21/r7pOnTZ8Reb
	hH8Y0HNgI+s56AnVtJZ2D2nkW0byn/M6ri7ULpjKcgqk1268RM2SIY5Y+NTNOIM5n9Z+45
X-Received: by 2002:a17:90b:1c87:b0:38e:67e1:15b with SMTP id 98e67ed59e1d1-3931e076282mr3739607a91.6.1786601762107;
        Wed, 12 Aug 2026 23:16:02 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3931db4eaeesm533018a91.2.2026.08.12.23.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 23:16:01 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: wenjia@linux.ibm.com,
	alibuda@linux.alibaba.com,
	dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com,
	kuba@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com
Cc: Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	leitao@debian.org,
	horms@kernel.org,
	mjambigi@linux.ibm.com,
	tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com,
	guangguan.wang@linux.alibaba.com,
	kees@kernel.org,
	gustavoars@kernel.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v6 0/3] net/smc: fix out-of-bounds and use-after-free in SMC-Rv2 LLC processing
Date: Thu, 13 Aug 2026 15:15:17 +0900
Message-ID: <20260813061517.5380-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260811231902.47089-1-yhlee@isslab.korea.ac.kr>
References: <20260811231902.47089-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Answering the Sashiko comments on all three patches here.

1/3: yes, applying it alone leaves the out-of-bounds read reachable.  The
commit message says so, and all three patches carry Cc: stable for that
reason.  The three are a set.

2/3: patch 2 does restrict that path on its own, and it is not meant to
stand alone.  It takes away no working behaviour either: before the series
the same path did not save the peer's rkeys, because smc_llc_enqueue()
copied only the 44-byte base message and the loop then read past the queue
entry rather than the extension.  3/3 copies the tail into qentry->body, and
both the add_link and the delete_rkey loop take the rkeys from there, so the
complete series saves every rkey the peer sent.

3/3: the tail is copied in smc_llc_enqueue(), next to the 44-byte copy that
has always been there, so the extension is no longer read from the shared
receive buffer later, from the worker.  Its length comes from wc->byte_len
rather than from the length the peer declared, so a short message leaves an
empty body instead of stale bytes.

The other two points, the ownership of the shared receive buffer and the
locking in smc_rtoken_delete(), are about code this series does not change.

Best regards,

Yehyeong Lee
