Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C457368D41
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 09:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791883076; cv=none; b=BvcwRrHCCSmT2xVU0nt/SBxrUzaA8qZunTmHtPIszDDzl4te3uEpUpq4h2EM8ueGp6w87rB/XutLFEOVNgMHzKOfto7Urd/Ef06M0oqZbT80zP/SUEKJhe5a2ESVAFr322rV17CqwOIfUoYbN5aOVkVNGhYVmNuC1ChhQySeaeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791883076; c=relaxed/simple;
	bh=b0WouZwkIzP19EsEq0Zzmc3OoBcJHUB8MdkLHNx6RI8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X87Gp1t+ICaYXbisRqmZyqMYXJjVikDhiXQPNzaEzL9TSAjjGfJX0N4/aegRpRPJAneRZ8BMsn0f3cX2dihLgG4nakNKICvcBM5E1elTOogRPKM6ZgJ7/q7nSZ0kQZIIXGhHShRHgXR/oD8jrEuHyuzbXmYMVvWybkiTyYhUQUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f0WfxoEw; arc=none smtp.client-ip=74.125.82.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f0WfxoEw"
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-33bb5afa736so292326eec.1
        for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 02:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791883074; x=1792487874; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=MIhtYvHUWNyU/lt1efJRDPOudyxWKfzxLqq2jTOG1dg=;
        b=f0WfxoEwmmLYF4PLxdosm/HQ23XDjboFttsfEtyuUgup0BM76NJvHlbraYakKLdb9Y
         jRaD3Y+sX7GU6DVzuJQ6hHZTJp0TpogKFDWzVZxaY8WF3qIFMCsvWFIhk/YQ3wrood1F
         N9PMlmRjdhxJwWKRlLXs1OjOmLe6QRTrTRk3BFKlHnm2H+Tbjcx+ngDbEgj8/c02p0nX
         R5obAX97644MNco9DL8KhBbW1H3dj5a1rPXvtMeyL5bUuIDcGnywXU0yDj/PO5l2Cb7E
         OnpTKxONiAQO1j7dZU33EbF8dAf4uv6384N/aH5aiMm1SPQ1Uzx9uIGQjVpVvlMwrDUA
         hrtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791883074; x=1792487874;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MIhtYvHUWNyU/lt1efJRDPOudyxWKfzxLqq2jTOG1dg=;
        b=px1aSCot5xizeMpL2n+ShVLEZwCF/DYWgMxLrPLOtTH1tMwCmw83mg134eQT7pCi7D
         06D+OUb2kmVX8xreJcaaEQ3qqWs4CtoeT3jWc5gq6BMoeVS+ezq8HIruJf9n6uDZEkTd
         NhhxPJmJ+RaE/UdJsd0Yx3fjNBPQl14JgWJ/YKKA6HmDgrxtfINRgvvgK95TlCqmkAg0
         nNqQQMBfOOBsbdBcvV9kk5G8FB06+tUBqFrzxWJPCBWHjA0PAaeoHjDsDx3DJXzcJ+b8
         ODJIlAZfqL91pN/oTUC0w9th2qAbLhVJOLP48roeCexfKd2HPBRJ6I3jTQI2gBeXKYpy
         3KcA==
X-Forwarded-Encrypted: i=1; AKwUvByFUQo87PNMlYBwZNVxUgw5bXQdOvVoykNhnUzu7H5AfwNdvI6MhpqCI16ZYzChDFu5ZVljT5AVbGw8@vger.kernel.org
X-Gm-Message-State: AFq9FYKv5aHuPNCv3PvmE/OxHQpC5O9DvlAU027eMlHD2tHpJAxtyOkU
	5GirVBjsy3AkQvLNv/CrW74/hbicWEa5dHmqVhtnhQTphzQPUfPDiRSTT7D6DGfJ
X-Gm-Gg: AYBFou1tCCn3hqCJaYxJSyZCKVsmXVZ08PDrRPtN27KP0IEkvT3p2OusJ0Va3Sdt/nZ
	9qQl6LY5xALzmMkmQCc4J8WJZk/8xpbk99kxraYg658vWOG9qPKlyCGLnz2wzKRlY/hydVguuo+
	rbi6E2ZmHUNyaadxhgTdjBm7+XDz+7UCDNGQZWGcoDqDz7mO4K6fws2NVDbnhANLZ1NyUTF7jZw
	To7uoHfQVq9FvsF4A8rQw8MmMeWnJwYaRVbXKAnjuz3jukFgorsXAFlW4if2mmAQWJdZxxQO2xe
	/Q7ZYUiyUteuQa1rle//zfAZQOu8baEwP4gewRUy4kLysJWGuAkAroU98XiV8mHSkM0xS9n8/9R
	W0OQbq1bjfLiMPpi+dxk9iqlJrJ915LAODZHNEBzqmP1XOISsJRQlzCkpUCGt0KUFemGTzcrQtQ
	vhI19Hb4/mYQ7IPPiySCy1rueIGF/I2nZhhbUrZutuOiYoXoFF70+XD6f9v2DSeXzPZTiuQ0rdS
	EnHQVvivnXcb/qKp9S7L/7mFjbSGsWQDWLSEOBHq9uGliqP3nwwNXHvBrYPrvHZ
X-Received: by 2002:a05:7301:428b:b0:358:7ed4:a049 with SMTP id 5a478bee46e88-3587ee40938mr18688457eec.0.1791883074227;
        Tue, 13 Oct 2026 02:17:54 -0700 (PDT)
Received: from localhost.localdomain (45.78.65.84.16clouds.com. [45.78.65.84])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537cb6a279sm41437975eec.30.2026.10.13.02.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 02:17:53 -0700 (PDT)
From: Chengfeng Ye <nicoyip.dev@gmail.com>
To: alibuda@linux.alibaba.com,
	dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com,
	mjambigi@linux.ibm.com,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com,
	horms@kernel.org,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH net v3 0/3] net/smc: fix link group scheduling, registration and work lifetime
Date: Tue, 13 Oct 2026 17:17:13 +0800
Message-ID: <20261013091716.1210420-1-nicoyip.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This revises the two-patch v2 series and adds a separate fix for the
running-free_work lifetime issue identified during review.

Patch 1 serializes delayed-work admission with the freeing transition.
Patch 2 gives early cleanup a single teardown owner, pins its callers,
and rejects first registration after teardown has claimed a new group.
Patch 3 gives queued/running free work its own group reference while
retaining asynchronous cancellation to avoid the existing wait cycle.

Each patch is a complete logical change. The work-reference acquisition,
cancellation and release changes all appear together in patch 3. Patches
2 and 3 record their prerequisites in their permanent commit messages.
The pre-existing callback issue remains until patch 3; no earlier commit
acquires a work reference that needs a later patch to release it.

The original KASAN excerpts in patches 1 and 2 came from instrumented
runs. The registration and running-callback gaps were identified by
source review. No new runtime reproduction is claimed.

Changes since v2:
- Serialize first registration with the freeing claim, and clear conn->lgr
  when registration is rejected before it acquires a connection reference.
- Add the running-work lifetime fix as a separate third patch.
- Correct the cancellation comment and document commit dependencies.
- Rebase onto current net/main and validate each cumulative revision.

Validation:
- Applied the exported patches one at a time in a clean worktree; each
  resulting tree and commit message matches the corresponding source commit.
- Built net/smc/ with W=1 after each patch, with CONFIG_IPV6=y and disabled
  (six successful builds; CONFIG_SMC, DIBS and INFINIBAND enabled).
- Strict checkpatch: zero errors, warnings and checks for all three patches.
- Runtime and SMC hardware testing have not been performed.

v2: https://lore.kernel.org/r/20261003183237.2284245-1-nicoyip.dev@gmail.com/
v1 scheduling: https://lore.kernel.org/r/20260927074520.3694663-1-nicoyip.dev@gmail.com/
v1 early cleanup: https://lore.kernel.org/r/20260927063607.3691520-1-nicoyip.dev@gmail.com/

Chengfeng Ye (3):
  net/smc: serialize link group free work scheduling
  net/smc: serialize early link group cleanup with termination
  net/smc: hold a link group reference for free work

 net/smc/af_smc.c   |  8 +++++--
 net/smc/smc_core.c | 59 +++++++++++++++++++++++++++++++++++-----------
 net/smc/smc_core.h |  2 +-
 3 files changed, 52 insertions(+), 17 deletions(-)


base-commit: aaaaf87ea99b8766c9a8aa0e71aa42e6bc8a5320
-- 
2.43.0

