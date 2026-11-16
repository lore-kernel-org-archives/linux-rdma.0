Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794870414;
	b=vx3/2q8R5lnScUc7sD793AWP4l3rU2QtYfr7NU0gVlmC6v1cdF86yJDY0aYoA/uJSh4R
	 XnVIVivqd55+OFlsSMp6UG7D+Q9lb1vECrlNyKOawZXGinn7JA2/opdQIjbxjmn47ny3j
	 3AZ3XMBwHGHS1Ne/Z4TZJiNCIkUwfs810snbtMofXX1htaf1rphvUXiH9SV5Y1vWygXkU
	 PthGm5LHH8ploE+sdffOFegfczEFztis1iVkMlfKjbw84p3DoGjqOxQ3npNG5A5Xdivwk
	 wbHMUeuJOp2YJgNM287/vlY+I0Kkhz/wqmDw0ocW7Z9aCjO0cqRMdiJrr4CRVqkZwOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794870414;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AjhVL/tzJIhPQa9pnWiA/Lzn5A7WcpHhkbmWbBd9Z/A=;
	b=Zg7zAQVkBIGXnkaqfg9tnasvzr+6yiN6VPCMJDSGfRi7Q4/BZUcB+xw3O17Z4Ida9l9e
	 L3WpKuliyKxy+EYVYl5klRZHUsrhysZJIUf6dKWcabmfSeBgDs42dcUnYV4XnA/U+GzJN
	 MRubc5smP12IuQ+33Ej5iPaRmm4ioaOYSRSvyomw4wXYh/THCTtfPIsrFblELV6yU6svp
	 AbdsGB788UzPaAHUfnvMIggpjoF9uTVkwdbvr9bFBeuS9nliS7knxmGwXyq+7rFtqE5ed
	 zZm8IoDLQrKuMchCXyaa1uyDCfJpqqDAnQFBsi/LUZIP5QZLEB2hQCEYXORmcctMrmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chromium.org;
	spf=pass smtp.mailfrom=chromium.org;
	dkim=pass header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=OEasZFiC;
	arc=none smtp.remote-ip=209.85.210.179
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD328606A89B
	for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 23:06:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD328606A89B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=OEasZFiC
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8b5e147f101so405790b3a.3
        for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 15:06:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794870413; x=1795475213; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AjhVL/tzJIhPQa9pnWiA/Lzn5A7WcpHhkbmWbBd9Z/A=;
        b=OEasZFiCCXd7n/M/UcduiXgq0vhYk4srVVnzKHpXRqoD95nlXtUP3TeLNkX0JweEo9
         DxSjeVsQyDj3Vhdhc9KfpT8C8oXNfziWnGdNY++4B+7gzbqkQMK37k0UZd5fFUA9gqnx
         UyWgZrw0eNM/Fg/dLZoy8VwoY7prhxICFZjNQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794870413; x=1795475213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AjhVL/tzJIhPQa9pnWiA/Lzn5A7WcpHhkbmWbBd9Z/A=;
        b=VMVPtxbpIu3kZkrWyO37AxeuvdarmZn/Ydv17ijO63XtiPGDS6nbBmC65s+d6fa0Xv
         Rx+z1eBkgxrY6lEHQ2C9tYtMNIL5FaEi0W6nPmM9PuBEabd8DcAMofFf2fVbEhQ/Em2b
         dot6qNSVyEox8kPIBxEsZYDxGqB5YgCHGeyzrHs0WOG5WK/DjLlSkcedDWOV8MRSEDSa
         PHKyirMBDdgERaNmNngOLUd+tS8cK7UiCAbEhoRStsHEkX5WnPCDB8Vr9aEC2CR4t8bJ
         LNZHpYD7VjubHrdllwCo+EhnfsF7g4X83ZlFNiErnyBMzv5PysneaqsApjjKSiAdPlrx
         3V1Q==
X-Forwarded-Encrypted: i=1; AL+hErFrSxiTIuczEDxobqgpQKMXW6hLAVg6bHuNnUXpeOI8bua11UrjCIL8IpJaz9LeAprASSJ+OhdiA0X9@vger.kernel.org
X-Gm-Message-State: APuU4Z9wkKN7RRDXi6dlcwR0FydK31Y8gybaldCXIDAS7CaAnDyz6pdM
	HSJwvS004SMOdBbF7a/NvudxaFeIsrxKgZCI0o9JaiiV1A7aFTde7AglFwdnhj9V/Q==
X-Gm-Gg: AZFdTZeGDEipSJRZZXksG1OCKxyXvJAyg3xv2ut+vy1YHaR5YZZqCloZ4EanmbuERhu
	E7YZ5hFIJRW1KPxeHM1Dkj0HuvC82nBmXwCTsDC0bQ0LvmaYriOg9pYBI5p3Syn+1eqAWktOZck
	p+cPwGN4h1a/v3l0lBSFjTU6G6EpOxWLbMwKojuPmf1LBFTrkzBc+2iZ1HUMHr4PNtB1CRu+nVW
	VHZkTUPCrL3AStccQjIZ7tyulCKYNOdLfp822Hd1oFRgdAuEKLw2H5dxOZq417Kh+AF+G/qai8K
	ISEYv64hxSIQpt/MGnzWfzqrv8+JSINmQJVlYJ5+eiDNS6wqD4UjfIrlm/9wtgdwYMaFIlEGDqx
	en4bmF+ZTW9cGzHH0pE76uleqlQqTpB32N9vSBXwxEGz12BRwoyyE9f2slHaby2Po5yTFiAvAjU
	Cno99dhJ1KKCNlFBi82gjsKliF+LNvIXApNp9iG1iPjMpJuoEOzX6qUwD2ERzNYvUHJqnb2G4G8
	MUUrqO59jLBCL6oZF0T72/L7fayLcAvFRPQ4duIcsPs99cNC2KV447MEP8b00asjkJu9qtwGd3k
	QRvGfYyKdEmZ4v+oW6BwRkWMLbOaisgwinZxE0PU2YTJ7M3GhvAJ3t1Gu5M85sAaagLZcZs=
X-Received: by 2002:a17:90a:9f98:b0:3b3:b15f:eb89 with SMTP id 98e67ed59e1d1-3b3b15feeb1mr322004a91.1.1794870413060;
        Mon, 16 Nov 2026 15:06:53 -0800 (PST)
Received: from localhost (221.247.125.34.bc.googleusercontent.com. [34.125.247.221])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-3b3abe8b263sm1120450a91.13.2026.11.16.15.06.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 15:06:52 -0800 (PST)
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
Subject: [PATCH v1 3/7] kexec: use GFP_HIGHUSER_KASAN for segment pages
Date: Mon, 16 Nov 2026 15:06:23 -0800
Message-ID: <20261116230627.3537051-4-jeffxu@chromium.org>
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

kimage_load_normal_segment() allocates the pages that hold the segments
of the next kernel. The kernel clears and fills them through
kmap_local_page(), and they are never mapped into userspace.

Allocate them with GFP_HIGHUSER_KASAN, so that they keep their KASAN
tagging when GFP_HIGHUSER starts to skip it later in this series.

No functional change: GFP_HIGHUSER_KASAN has the same value as
GFP_HIGHUSER at this point. Build tested only.

Assisted-by: LLM
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: kexec@lists.infradead.org
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
---
 kernel/kexec_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index f4a31565c447..a3abbb6a2d75 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -839,7 +839,7 @@ static int kimage_load_normal_segment(struct kimage *image, int idx)
 		char *ptr;
 		size_t uchunk, mchunk;
 
-		page = kimage_alloc_page(image, GFP_HIGHUSER, maddr);
+		page = kimage_alloc_page(image, GFP_HIGHUSER_KASAN, maddr);
 		if (!page) {
 			result  = -ENOMEM;
 			goto out;
-- 
2.56.0.611.g1030f0b940-goog

