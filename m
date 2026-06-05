Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3276E37703A
	for <linux-rdma@vger.kernel.org>; Fri,  5 Jun 2026 17:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780679065; cv=none; b=T5vGYsFJ+b89tDByqAGTwwrD1zHKjOGG+Ul3qzhiAA3VIiYQruHtrv9ph3gSfEKVCZbUwMBYeQJkrwp69koZRBluN/AOnMGAVoiXoNP+HGgkQOfd9atR2pKe/9PZhA6thDiyYCUEiLlf4aBJC3IEszyScDbyJclzrMwHgRKwpH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780679065; c=relaxed/simple;
	bh=qlOqJCumkmHJfJLiXXOXhCO/dxGSCrwCfvho3e9vArQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IDu9zBn/QjDIeuMc9iPDyIl/NDv/dGjAQYyaRQVWAyQ4S4/3ukqEac8UymkJLy4QIW3N/vZOGH2YL2R/0rVQrTTl3vBaHGroE7EZGE1sf24Sf7LuYObHkCZsTo3cF3BHtX1bUXAWd0Qdv3hry9w+z3dcvnEfd2/ghJ90dWpPA1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K+c8TiKF; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K+c8TiKF"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-3966388b388so19773891fa.1
        for <linux-rdma@vger.kernel.org>; Fri, 05 Jun 2026 10:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780679062; x=1781283862; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EB08X2I3fy3wrkRM6VsdXZolE8SRqefSruMLGUvZ7UY=;
        b=K+c8TiKFsFhtazVJVRNzywEeWp31xZHpogsefp63IVsiZNG0J3VMXaj5HLrErarTpK
         melF8isolHsoW2o7ypPKwXLnVbfSbnuSWnwLOdeWc6p9ZY7MZK+pbfLm3maUTHG4zyl5
         geyZjjPNhZdmbNDDXsnkSFDg5aTBbpiI+dm2S9UtFj8QNkQA00bd08+4S257XstnlFCj
         RxbP4IdFiNJnU9T0SKkrt9SC+yXfCnUS7E7FDdvU4miqCzQai0qXN9nKqRp5zsJUjQ45
         sDoZKGc4xMMBLLxtDZFv1HKtpnUaYCKa3iyUPdNz3I9LgvE1W/Ai9lZHh6232m9jklWb
         4MGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780679062; x=1781283862;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EB08X2I3fy3wrkRM6VsdXZolE8SRqefSruMLGUvZ7UY=;
        b=ehrzocDudj3JMKbD3EK4dyIFm6CrZ5OMQrRe6nCgPRrKw+ccuuJQqRMBJQoKJjBCmH
         n6wh5yV6TCWCfgN/pUk9OSeD/hJGV4sGjXwdIWx8kXPcL2Zv9Diqt2Y9rr7+e0fCbkpw
         NyT4zr0eTinE1GwrjhVexnsM4s+n0geOAKOQ8m6LIQ11yNi2EDmJPNLS7XF7tNQhLFbu
         I4/kjrpvfmy6ilfmWdPV6wduFTM8/D4tLXQo0nhVaNnB5OVKdcmW3lyljFtzR76fDNxY
         vZK9nk5mu7VjFs9CKuFmJJBLph9eMWxB/d8xn2rINwerl6zaEffUl5ib9d2z2wM4hDQW
         amyA==
X-Forwarded-Encrypted: i=1; AFNElJ/KPWsh9nw0UxMDTwUjOL91E0eu0wsMrevBE31DPKFqZGVqz2pzrQfYGijMY4PBVg2kejMkJAeUzzJX@vger.kernel.org
X-Gm-Message-State: AOJu0YxgcfaqFJ1er/M1e6GJ0okCJuDgpIVPejo46u8pJZXg7pgSP0lI
	j+Pp+8yhYfLgtmxSnmXxnfPmvV60LcMbg1fIcfHsgkzN64WMT3unYQqh
X-Gm-Gg: Acq92OErUh5WM9kNUCV8n/deRcyPiTYrw2aEqmLmiGz58luwPXP5X8NM+jt4Rq4/VK8
	96cK2vH8ILpFTGFY2dJtC6F0UUcYTCszh3BwDm0DIWpX6mXJMfSWnxKp4bzEytkWm2dWNyvtoaO
	nnLOFZjdD7+pWdfAkcjGtI/newkjNgtHNATxtHcOiSSsIx7hf9zGwIdMNlCRvXdx7EPYlUtNVkL
	h48+jS+ADZ/f9oUGGVmgoW82kwgG5ndR9IJ8v8adusEiI3GHEX/G4kxOZjChuzLyhO/h8REuQr+
	qlkTsmkdOHiBnCAtq4VghX/crlIZJsCNJ3jp2CC6zW4/H7GwAI099uwcleXO5vZ/HA97l/Wb1rA
	Beg9S1yh874L+2cquljOQtN3y+YZPcUYipEXVdvAdsLxguEJ+QsRTAp1zc+hwkmUKb99cZHUhN8
	TeHO36bGQP1510iBaICklEumnQsalg1+d/yctEk7YPF47uIXf9bweaeGc4O3Cu2YmU739wslCeP
	KjfPtM=
X-Received: by 2002:a2e:a58a:0:b0:394:8fc:8c3d with SMTP id 38308e7fff4ca-396d2892d2fmr10213551fa.4.1780679062303;
        Fri, 05 Jun 2026 10:04:22 -0700 (PDT)
Received: from c0624c666cc5.devsec.astralinux.ru ([93.188.205.42])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-396ac07b66asm26931161fa.11.2026.06.05.10.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 10:04:20 -0700 (PDT)
From: Vladislav Nikolaev <vlad102nikolaev@gmail.com>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Vladislav Nikolaev <vlad102nikolaev@gmail.com>,
	Zhu Yanjun <zyjzyj2000@gmail.com>,
	Doug Ledford <dledford@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Haggai Eran <haggaie@mellanox.com>,
	Kamal Heib <kamalh@mellanox.com>,
	Amir Vadai <amirv@mellanox.com>,
	Moni Shoua <monis@mellanox.com>,
	Yonatan Cohen <yonatanc@mellanox.com>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhu Yanjun <yanjunz@nvidia.com>,
	lvc-project@linuxtesting.org
Subject: [PATCH 6.1 1/3] Revert "RDMA/rxe: Fix the error "trying to register non-static key in rxe_cleanup_task""
Date: Fri,  5 Jun 2026 20:03:27 +0300
Message-ID: <20260605170349.1524-2-vlad102nikolaev@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260605170349.1524-1-vlad102nikolaev@gmail.com>
References: <20260605170349.1524-1-vlad102nikolaev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit 3236221bb8e4de8e3d0c8385f634064fb26b8e38.

The reverted commit is an incomplete backport of upstream
commit b2b1ddc45745. It added guards for req.task and comp.task
cleanup, but missed resp.task cleanup and left it before the RC timer
cleanup, unlike the upstream fix. Revert it first so the correct
backport can be applied cleanly in the following patch.

Signed-off-by: Vladislav Nikolaev <vlad102nikolaev@gmail.com>
---
 drivers/infiniband/sw/rxe/rxe_qp.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 709c63e9773c..05e4a270084f 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -788,11 +788,8 @@ static void rxe_qp_do_cleanup(struct work_struct *work)
 		del_timer_sync(&qp->rnr_nak_timer);
 	}
 
-	if (qp->req.task.func)
-		rxe_cleanup_task(&qp->req.task);
-
-	if (qp->comp.task.func)
-		rxe_cleanup_task(&qp->comp.task);
+	rxe_cleanup_task(&qp->req.task);
+	rxe_cleanup_task(&qp->comp.task);
 
 	/* flush out any receive wr's or pending requests */
 	if (qp->req.task.func)
-- 
2.43.0

