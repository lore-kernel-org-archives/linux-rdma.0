Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858363F99EC
	for <linux-rdma@vger.kernel.org>; Thu, 26 Mar 2026 12:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774528357; cv=none; b=Q1ojAdCBgzvU5hBb7xwPSpKwAEhtcS8kdrn2pazdnJxSqrYCyiSMhGMWtKADIA6vFG82dj2r0szqkaD6JG8fQ/Fg67m6EZhpOIjku3nYUQTTyLz8W1hoqf59wGUTK7jf+KbXsoYSvFSoaFiC9X42+Xrfy0LPfOhCuxwnbR8R33c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774528357; c=relaxed/simple;
	bh=pyr1jSN9tAMToc+rEqDkNjLtVcNjZm4QwjwQj/BCYPQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=M/io1YBTKaJElv6EVXkK7JuaSdgUBeqyjWlXo5pSyQIjSsv09GDbgjOm9o3plgmpvvGCFRxrD6IWCOdEcSqwBDgol4mCX2pXy0I6C9lBdcaictGwWCEwZF2r/WtDHOg2Zw44YBtrawE17eJPcMGnzOjt90TQDcWycq3H0CJ5Cgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gdGCJ4Wb; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gdGCJ4Wb"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48532df52c5so8896565e9.1
        for <linux-rdma@vger.kernel.org>; Thu, 26 Mar 2026 05:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774528354; x=1775133154; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PnUmSvdGrdA8wXtaJVKX+3lGQinclElGewhzWnJqPks=;
        b=gdGCJ4WbSxQLV66Km3qdvbudt1uVNZovHa2K5Mn/OTEwtSt6YqGOPsKzkBLvWE4jn3
         yzsJY3Zfl8L9bHpSHdMA7lvkvR3d2qOD3DitDRbDOaf2zX9GdRcchnw+9Brhhddf/ulJ
         /NBNUXwcKKqBCy4pn8K2yJCuXxbtHEjyg7L3YD+Nq1YRFyBP8Pju6d/q7AQZxMsPLC2Z
         TsBxftzHWDkBlURkM8h1x0AsaAOwjbrw4YTnCxi39qkz57JeRJkAMYnN/JLQbKGATeZC
         R4DhYnaCGKxPH196uaTbeacykvQOgpQqGKJrc0LhX8YDiESheqvUQ4z2UtDqv41v/q9s
         GGlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774528354; x=1775133154;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PnUmSvdGrdA8wXtaJVKX+3lGQinclElGewhzWnJqPks=;
        b=OHvx3eRscMEQ8Q4f/JUbwUJ6nc3ptpR2+V8AtdSFNDz+vkrD7bmbY+xshDMezh6MtS
         ZAXPIeVJQJzzudVrCAn+DYYFdkCfhJD2ABiOKvWv7yJcC3GCuPrW2IARJ2Kv8pma+gEL
         o+32aNGARQqSuUkDvzo7naleMMYpsbwJWSmFtCC0VFfSxsR3LTbnBc67D3AYWo8BsOOp
         WJragUGUXrB5iakR7ZGK5TpAgCSUM1GM8B66sPbFxHqiR9KEmdDEQAyl42ykWzVZjp2B
         P7bg3pHVOjYPfuJGxD6VAGstpZTnmqUCJvWQ9ymGAeKfVZGTxKtcdphbdcqiq3p5u6fB
         v+Iw==
X-Forwarded-Encrypted: i=1; AJvYcCVoCfPOSh92Ua7oJJdb90As2R1TQofervDWo5IgWxByyVS1/5zd5WpkBAkiu7myzkv1GirwU/PrTYJq@vger.kernel.org
X-Gm-Message-State: AOJu0YwSPUY/EpjMgThkj21aglf7AkPQDaYmXWK4BfWa+SLCbE91M4Sl
	Mb+Z6l4ug2qUO4qPqB3euEnrdf14+GiMtoDb1V91seWKLI1vlO4v1y+2ahlWb0vkMl8QuBW/ODP
	98eOMM9f901yRnw==
X-Received: from wmbjr7.prod.google.com ([2002:a05:600c:5607:b0:485:3682:6cf6])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1f95:b0:486:f308:94ec with SMTP id 5b1f17b1804b1-4871606d88cmr107670785e9.24.1774528353854;
 Thu, 26 Mar 2026 05:32:33 -0700 (PDT)
Date: Thu, 26 Mar 2026 12:32:00 +0000
In-Reply-To: <20260326-gfp64-v2-0-d916021cecdf@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260326-gfp64-v2-0-d916021cecdf@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260326-gfp64-v2-4-d916021cecdf@google.com>
Subject: [PATCH v2 4/4] net/rds: Use special gfp_t format specifier
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
 net/rds/tcp_recv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/tcp_recv.c b/net/rds/tcp_recv.c
index 49f96ee0c40f6..ffe843ca219c7 100644
--- a/net/rds/tcp_recv.c
+++ b/net/rds/tcp_recv.c
@@ -275,7 +275,7 @@ static int rds_tcp_read_sock(struct rds_conn_path *cp, gfp_t gfp)
 	desc.count = 1; /* give more than one skb per call */
 
 	tcp_read_sock(sock->sk, &desc, rds_tcp_data_recv);
-	rdsdebug("tcp_read_sock for tc %p gfp 0x%x returned %d\n", tc, gfp,
+	rdsdebug("tcp_read_sock for tc %p gfp %pGg returned %d\n", tc, &gfp,
 		 desc.error);
 
 	if (skb_queue_empty_lockless(&sock->sk->sk_receive_queue) &&

-- 
2.51.2

