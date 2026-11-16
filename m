Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794870413;
	b=XaNmUfsVgPE1OM4576Req/amqVlUo18rI7SqiT+lMCh0wWIrg7BrFWfJB9K6PSgAIlcP
	 05BRAYSWIpt+woZziL/Ywr0ziNrmZuEGsajUG6XUnGOM4zA6p7jqWQro7EyrbpUgTOaY/
	 XW+0rlD/7kBmUQnV54WAvGzuraZyeL6iFl6rvMjd95gBtk3dUZRT+4AqPdBU0fq/n89if
	 rgu5DBZq/hIqx0zqUVGt5kwlIs+28tVxlLPOE/M6xKt5eEREaWQtYISOo98asT3Zg6b+V
	 apED/04LCdG1AOg+V3kyFXPg/TLiFaV24MW3RQvg7K2SAXlCg2W8T/yxqFo1eyASt9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794870413;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=04YMYN0F09iXpQbtyDGXKPSGIzq5fh/Gsn7Dty8ViAw=;
	b=eAFmYU9FTuLhgCoLDA+ms8vMIkRWfnI32wzf+wdKG5Q+uDJIQ1FkMGnQzmmc4vlWxgAo
	 Do248xzlMxvA7xsu4ygLMOx2pHu01SCZSGP2ecIRm5wCuQ1+fPtndAKBa0PS0d3jilboS
	 FM0UdwABbgniDXM3ZZM2kyD5E3qANl8th+uDaR6TjbMjMwjhDh9VnYXNP2Dr9sfv4LlzA
	 1K7m44U4WwqaKR8lCnYyejZL8Cj/7FGwsqMb/RPZgFlV7lyJPvT0Z0/rahOJYuy8V6jGp
	 jeeC3XSs6RGr9YvoEMvjDFuQOcx3W0ocwnINXraugVp/CL3qaY8gkp8BmH8rp8mHJjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chromium.org;
	spf=pass smtp.mailfrom=chromium.org;
	dkim=pass header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=Vw4q3+7J;
	arc=none smtp.remote-ip=209.85.216.52
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D93D60A260F
	for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 23:06:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D93D60A260F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=Vw4q3+7J
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3b18bae2d56so594573a91.1
        for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 15:06:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794870410; x=1795475210; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=04YMYN0F09iXpQbtyDGXKPSGIzq5fh/Gsn7Dty8ViAw=;
        b=Vw4q3+7J0GTgcSWFxg4Zuev6Td1Csd2F1YArOtz+EmHp+gxPgNOgtp4qGE5OPD4j8d
         8kMC/9FQsVFuqTXrWeUl/o210OhRp59ba5RQZzU7CkwS6iWkfFaXLl9A8QIJBFxoY1SP
         bjUYPHwoaCqN1KjkM+WmK83bXCgnxSkp1hmfY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794870410; x=1795475210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=04YMYN0F09iXpQbtyDGXKPSGIzq5fh/Gsn7Dty8ViAw=;
        b=Sk/JdT8fs0t5BWmJ7n2AmzzWj19vfDxi9uYR/+FapZHYBdCq1W8rhfnd8D+el4EG6J
         693VcIET8CeNG3DIBOmtcd95vVAyGVZOgi9v9Wycre3tdSM4me6/eqzmoLL+dqOXcYB9
         9KeQsb0FKpzxgLbCapCPPv8fjLA7U4fxgYShNhplEp+ZO3Uj7FoNXP4NrlPwhuAz89hS
         YOgY++O8oq9J7Eim1MfYgJ+SILbfYUQ2tjA+x0sQxmf3FgcD1if6K2hg3GrXU0ydPyNS
         Rwo2AxlVOMGl+amjzcX6PlCJFGx///VU+b1dii9xx1YoaitVwkrnTQNPfqjLuV0Fk4it
         ESmg==
X-Forwarded-Encrypted: i=1; AL+hErGCiG+q76MFdBuuaGlaRC885n47xKi/aZlGNAXmn5rp+sHA9vnOXtjoVc8ol1oQxvq7Lj9MUA6FBozv@vger.kernel.org
X-Gm-Message-State: APuU4Z+A7qSrFqS9fudYbwYxJqKcrf2KpkQ/3pBKFXKs7YH1YduaVCde
	nJuIISe0kwfupnaYVlQM+tTTOY3OKljtqkmCeu713/rqMiR/HbubbRLrLLuoTRLgPg==
X-Gm-Gg: AZFdTZeyblOx77UEDLXHAyPQPR3BrBgdiqPYBw3XX4Giw53U5GVXexX8nS1OLx+oPHX
	0GTUCf16LbOV8Biydzt+MZytWjpZwcFKp0KPzamgQB9Eg8qKGwEicUbV4HixfIcmBV+UFFDuNQB
	kK4IrWNsqlcXKEVQHnhxuDJ5gPxYef9x8ZgA52Z7XRkTPKrR0UQBwkHDbB+3XZgnI2X0nXCCJPd
	r06ZfoOJTmGOqVXotFBL6MKGjs48LZg5JzJlLhemxz61YPE+qGAxepQgEWTcOl58iYXk4+6h2m1
	F3Dp6Crxe5juQhCCkmdjtl9LABX2jNsSAynMhDiTcqbjeB/mexUOvLZMiiXT9Ay3riwMAuzdQu2
	EkmvumRPTUjkYghJIPy2V1r7nPL1qTJt2gkxqjZjHuXtTxAcFPmb+q7S/PeTPxb26zJql4oGZSm
	x1Hz2L0vdP5roakI63Fhp9isGXlTm6ArhNF7nu0OBgjc7rTwJxqp3dTVfbDohIuumGBB4k25bXi
	7oA9l5MrnjDmAj2h4IjXSvp0O5Gxkc4NYIPSQALkPid1fBQsxeVzA2iTHsaCg1aJ6hb5pC2Ba3D
	Z2+O6ADZvJbn/gxHl6KpTHN8mCg2PSyS0CJVRKFZcgkFK2FVcqOFwktMIiWY4tTTzWGJsSw=
X-Received: by 2002:a17:90b:1650:b0:3a0:c162:51af with SMTP id 98e67ed59e1d1-3b1b05fccc2mr17699416a91.0.1794870410469;
        Mon, 16 Nov 2026 15:06:50 -0800 (PST)
Received: from localhost (221.247.125.34.bc.googleusercontent.com. [34.125.247.221])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-3b3abe8b263sm1120355a91.13.2026.11.16.15.06.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 15:06:50 -0800 (PST)
From: Jeff Xu <jeffxu@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Jeff Xu <jeffxu@chromium.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Marco Elver <elver@google.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chia-I Wu <olvaffe@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Evgenii Stepanov <eugenis@google.com>,
	Ian Rickards <ian.rickards@arm.com>,
	Jann Horn <jannh@google.com>,
	Jeff Vander Stoep <jeffv@google.com>,
	Jeff Xu <jeffxu@google.com>,
	Kees Cook <kees@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Collingbourne <peter@pcc.me.uk>,
	=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?= <ptosi@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Tomasz Figa <tfiga@chromium.org>,
	Will Deacon <will@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Baoquan He <baoquan.he@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Allison Henderson <achender@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kexec@lists.infradead.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/7] pipe, fuse: use GFP_HIGHUSER_KASAN for pipe buffer pages
Date: Mon, 16 Nov 2026 15:06:22 -0800
Message-ID: <20261116230627.3537051-3-jeffxu@chromium.org>
X-Mailer: git-send-email 2.56.0.679.gc527c65306-goog
In-Reply-To: <20261116230627.3537051-1-jeffxu@chromium.org>
References: <20261116230627.3537051-1-jeffxu@chromium.org>
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

Pipe buffer pages hold data in transit. Pipe writes allocate them, and
the kernel fills and drains them through kmap_local_page(). The same
holds for the page fuse_copy_fill() allocates when a request is spliced
from /dev/fuse into a pipe.

Allocate them with GFP_HIGHUSER_KASAN, so that they keep their KASAN
tagging when GFP_HIGHUSER starts to skip it later in this series.

No functional change: GFP_HIGHUSER_KASAN has the same value as
GFP_HIGHUSER at this point.

Assisted-by: LLM
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org
Cc: fuse-devel@lists.linux.dev
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
---
 fs/fuse/dev.c | 2 +-
 fs/pipe.c     | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 3641abb90d6b..fdcb11679dbb 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1044,7 +1044,7 @@ static int fuse_copy_fill(struct fuse_copy_state *cs)
 			if (cs->nr_segs >= cs->pipe->max_usage)
 				return -EIO;
 
-			page = alloc_page(GFP_HIGHUSER);
+			page = alloc_page(GFP_HIGHUSER_KASAN);
 			if (!page)
 				return -ENOMEM;
 
diff --git a/fs/pipe.c b/fs/pipe.c
index 4fa69192e6fb..87792ef63564 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -155,7 +155,7 @@ static void anon_pipe_prefill_and_lock(struct pipe_inode_info *pipe, size_t tota
 	}
 
 	while (n < need) {
-		struct page *page = alloc_page(GFP_HIGHUSER | __GFP_ACCOUNT);
+		struct page *page = alloc_page(GFP_HIGHUSER_KASAN | __GFP_ACCOUNT);
 
 		if (!page)
 			break;
@@ -201,7 +201,7 @@ static struct page *anon_pipe_get_page(struct pipe_inode_info *pipe)
 		return page;
 
 	/* FWIW: This is called with pipe->mutex held */
-	return alloc_page(GFP_HIGHUSER | __GFP_ACCOUNT);
+	return alloc_page(GFP_HIGHUSER_KASAN | __GFP_ACCOUNT);
 }
 
 static void anon_pipe_put_page(struct pipe_inode_info *pipe,
-- 
2.56.0.611.g1030f0b940-goog

