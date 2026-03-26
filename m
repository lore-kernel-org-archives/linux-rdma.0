Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4329438B121
	for <linux-rdma@vger.kernel.org>; Thu, 26 Mar 2026 12:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774528353; cv=none; b=pujmRp6hRsXBO67nxHaFi2XKhgVq9DVtR5GLdRiPOEyPSBcn2jno1xiD7kkNnMeVwm3EKJ21bvPH6l+XSM1Bq3EvFh992k8qwGNQ7hrwQclErzv6xl7iqg25g0RLCBoUHFkv04ktXZ1khEO8oAHmR80kxDZv3DfqyUpwDZPdfAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774528353; c=relaxed/simple;
	bh=F8oqCmkP/6+S3unZUrGJradusnHwYnXxZNdCp5PCplM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oLW8X6v5vPut1XUN1QQHPepd3eoBpQhnHTWy0iJs8a7KcRAEEd/afgIPe9txPnTemqgj91h7nO3npZGuqWnvkEBFJVPwQv92TQQOiq85NmbJ2ibxwfFDzNQJ7YVyh5hGtdNgRLsWGV5rApowXWfP97roexfD+4xJIwh+pwa7wK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hmunPZa8; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hmunPZa8"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48535f4d5e1so12930975e9.0
        for <linux-rdma@vger.kernel.org>; Thu, 26 Mar 2026 05:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774528351; x=1775133151; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PW5D3P/yH7ZM4fd9U5FDHBCN6E6TiesVaLAHRbrJtkU=;
        b=hmunPZa8cT4ULUZRQI/sDcQFZ6qlbcECXWW8r2N/OEqIeNSVunjTssQAwywrNjehpz
         NyW4AlEcUOeopHPTb2KzICoTTKoI0meELd7OKrKWcLflRyAcg2R24WLKU5niAygyZcce
         9pKoUC0EdbQgO07c1h3hySyDWL6QQL1VAhBzv3t/T5vT1wIpUCMasnDdGy5YTQ0BKH2F
         QX16/WD4X3aKZsQ/6Z6vQoNoAjcBGR0vKyyVeqN43+x3SLXq4aU3q7NlHTmLq2SeqSQE
         MrMHxz32DpDUNu/g+jp+tN18aPx6jjZ5lbtVOAGf7mv8a3Hd9zRFdww4MpEgfsqk+2Qo
         z11A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774528351; x=1775133151;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PW5D3P/yH7ZM4fd9U5FDHBCN6E6TiesVaLAHRbrJtkU=;
        b=LFBoocsxLBMi7L2cJhP7aznwRhipkm8c6fg/OV3RrLyBRlVqNHenW6POBiwKIE0LDv
         bBW21xsazBmBHp8wxZjJHQjei3YwxbTTSScDZEuIwCg8KS3m8UdUmSmUMAGfC/biHDpx
         sRrbEwxfXkhA4iYoHaQTjcnrUiky9+Ut7cLWq5hwSijPMASHmKKcTi4K3ZopTRUfv9Pl
         pU4cAMVjlgrJ41L1Gc9pm5U35mTq6x/DTvV4EAeFWmg+uVM07LwbjWQpSNPFBKjwNY0m
         zHUHu47L2SkICvT27qQ566vE9tBfS8u1p1xPSCrigX6/aUYIai2xKzxSe3XHRFseFaPW
         UHkQ==
X-Forwarded-Encrypted: i=1; AJvYcCXFCCozFiJC050gcNYAXHDdv4KR0b4fDlt0dDJp7DiYebIxU8rAbZ7CVRedAuMefEvUdKpfdYrwgOTD@vger.kernel.org
X-Gm-Message-State: AOJu0Yyac8UdIb0HN+6fil/3o1oN2cCD+NDIqsHaLHbSrzIWI4DPGdVF
	kHn8gSeRgBJAj+c9tU+Xvj8RQhLByRfPQeKiBNmawrGAd4CPfGhVbXLS2PDvJLyfEAPQLZlHUEm
	Fy2Fdooa56w3/Rw==
X-Received: from wmoq3.prod.google.com ([2002:a05:600c:46c3:b0:482:ef72:5793])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1394:b0:485:4388:348b with SMTP id 5b1f17b1804b1-48715f0389dmr114277655e9.0.1774528350455;
 Thu, 26 Mar 2026 05:32:30 -0700 (PDT)
Date: Thu, 26 Mar 2026 12:31:57 +0000
In-Reply-To: <20260326-gfp64-v2-0-d916021cecdf@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260326-gfp64-v2-0-d916021cecdf@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260326-gfp64-v2-1-d916021cecdf@google.com>
Subject: [PATCH v2 1/4] drm/managed: Use special gfp_t format specifier
From: Brendan Jackman <jackmanb@google.com>
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Stanislaw Gruszka <stf_xl@wp.pl>, Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Allison Henderson <allison.henderson@oracle.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, 
	linux-wireless@vger.kernel.org, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
	rds-devel@oss.oracle.com, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"

%pGg produces nice readable output and decouples the format string from
the size of gfp_t.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 drivers/gpu/drm/drm_managed.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_managed.c b/drivers/gpu/drm/drm_managed.c
index 247f468731de0..a9da94319b052 100644
--- a/drivers/gpu/drm/drm_managed.c
+++ b/drivers/gpu/drm/drm_managed.c
@@ -232,8 +232,8 @@ void *drmm_kmalloc(struct drm_device *dev, size_t size, gfp_t gfp)
 
 	dr = alloc_dr(NULL, size, gfp, dev_to_node(dev->dev));
 	if (!dr) {
-		drm_dbg_drmres(dev, "failed to allocate %zu bytes, %u flags\n",
-			       size, gfp);
+		drm_dbg_drmres(dev, "failed to allocate %zu bytes, %pGg\n",
+			       size, &gfp);
 		return NULL;
 	}
 	dr->node.name = kstrdup_const("kmalloc", gfp);

-- 
2.51.2

