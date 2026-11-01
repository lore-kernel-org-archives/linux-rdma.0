Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793530588;
	b=n8qWwr/4RQMJdcf7NZ6Ti6hKiZ6ZNPGTpl4PgOcfCUc9Dy8fTLpNpelAhUVjyGt1JKHv
	 kDKJjT2dSFqD4hFCHh/tIRQ7Z8bgxNEzHtQkm3neM8p1HAC1GFPMR3juW3t5+ftQrduRF
	 rdd4t2liXZA3Rw28oxDBInwHqSXEYh0IGD6rhIh+HhQXPJnpXDRCCcolsVIDNTCjV6Gop
	 BnfZdBZxk79g1ZPWYnP3HXkQsHrHBSqEgXMSr1f1jikHwFvpIEi0bpGxNFeLXBBzsik5Y
	 /eSYaDNZyT3EnbR7kTjRP+QXIiZd7rNqInXBKVVpBTOcRqryzocNo+cQNTlJdZziVwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793530588;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=IaPEFj9f1Egxu858cRUniTuz6CxllUIciOWlHqTg4Jk=;
	b=eqgVKdsC9wPBe2UIKb1O94UnXAFUrIibVDkS0fLqTlRpDRfMSL4Ob+DF6aC74dMgsWJi
	 G068uP7k5yxWyFT8wTbXijQMAEBlEY0p5DhrSb3oTsRK43p00nwMRU1ZqhxZt34xKuJAo
	 Wz5aE8dtMLO1YIitgk9oAjWtnswc+ySSWJoK57VD9rC7YigBG4e+M85hlIJ3mRvz9hxt8
	 wH+XkUUd3nRL2wwQkNjkFZkEMlJ0s6NTLYFnkdC0s8n4k8d+GXLaS9PZFPsMsJ5L7OIeF
	 eskXzBhRt8BOcRibErhzJRZbtRVlRjKsXlFuJG1qv0OD/Fgzl7rDw3u5ns+ZIxNlLlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sRvWi9G3;
	arc=none smtp.remote-ip=74.125.82.169
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08134606A324
	for <linux-rdma@vger.kernel.org>; Sun,  1 Nov 2026 10:56:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 08134606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sRvWi9G3
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-33fb4680717so2706907eec.1
        for <linux-rdma@vger.kernel.org>; Sun, 01 Nov 2026 02:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793530587; x=1794135387; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=IaPEFj9f1Egxu858cRUniTuz6CxllUIciOWlHqTg4Jk=;
        b=sRvWi9G3GlbEiuE/IwPiDqaspOqyMuib+beHwvy8q+05xUVGrB1i+im4MlQcInspT4
         PfMvRpn3IvcO/oG1RUIcvA7hC9rVn7T3QxwUeTB1gQajxdig2OpSYj4Js5n+p9a1o3Zh
         qO/SmqS8m+z0/TyalflAdzTFBQowKPtiniOqFNJWv6WJYNtK1RhNuw7+o6uHjOayF5y7
         MuXGytZzSs46//cC8MvAZUqnkvRAyx3bVVJXf44fFoyyrE2i/gFokl8NAxkmiX9AKsKP
         rj9MTKgQJgbjFhrTK2rUQTsnzxhxlozNv2NEUKqH2yedm5eZZw0Lw8yylYQQ6k39K2RH
         mAPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793530587; x=1794135387;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IaPEFj9f1Egxu858cRUniTuz6CxllUIciOWlHqTg4Jk=;
        b=t8XBsMOxJLsnkK7u8NkRyMxoaUVR8eqbXd39G7M43/N4mdz/vY7lVQ4cwbkuYIS3B5
         GNnh6CjzE5AyUSjMvIUQ/I9eajM1Phctcl+tvnmOuBu+0yNTCTmHxmI1pWanGsTds3iz
         LAfg8ECKrTDupKW0nvTPQ/Ghh8FO6KStezxlRozwhM6XVHT4pvGotvIWcUEdikmIRV+m
         8sESmUfAUg8RKDS6Moe87vQFrqEQ+xaqngkwVExQE+YqZDJMQACWiu2bLJKFrIL34xXU
         2dfntvAh7JNebpv/yBerVXeXnm67V3hPKmNnLEAtgyrMkTHQ/3cq3oMhefmOUYyl/mU9
         n9MQ==
X-Forwarded-Encrypted: i=1; AKwUvByEdwXTE4tjwOfcanXhGRCie92dJYwBtmfQeqPJF3X+IpPU8pbittGCkJk7+O9zFjQar40e58VLu9Pu@vger.kernel.org
X-Gm-Message-State: APuU4Z98/3rkTJR5mlNV1D/o0qhE3A1w1CJnkYVwWh61Rqnl97aBO2WW
	vmpzzIrH4HevR0diMyva11bpJL+cuiSmJHJPIbyqW5gL4Erw4/fEqaH1OcgRDw==
X-Gm-Gg: AYBFou0IZLt3YiXu0joVFRscT2QNsykZEaAtpUcRtnkzdwBndHjar8q9GtF/gdNElaz
	L5XooMvohKFbQWcBnJefltJ8l/6i88qsIzwvFS/h94KAt17d4c06IcvSrzh809DVgf1yy0KCtrZ
	IrnrLheifizqZjI2AESRItB/Uh/0nGR7VjXEYK1xtI+/Gd/jhhsI2DeT7nwfEjwpy45RJdDhJKg
	iDyjMOQM9wbkDoOTJayvNcFPs+xNZJwE4rLtGqHGh4UOw6Z1pi88LTw6XxSyDiznMVqRHnyH8Y/
	ifdlvAdeoDEY5BL6GBR7iyg7jImsuwbMAEPKVZhwA7UHaeRNfD6xAzMtC5gLeaeSYu+z58kS0Wi
	ZCXPqYgwbkMgmQqBpx21mFT+rhfclQsywU2RIVnFt6KpE0EZKBPYMHyMYADnkBUGGrIVAL6Ol4r
	X/9Q6EYOymb1x/4DuHpm9W0SLqd0XGxcTUFyFMWtOy3+bO2zw7uYlb9QitTuIcKb7Y/U3GFlLoO
	Fy8OFGcdtP6rarV/lLI0Oc3g1yhNcKAsY4Ltqt9ftZ6QOuBIaYwdeg7x2HViweMT1hMqfbFc5rQ
	POjV0T4SeJvpm6CdxLsmKcs0gnFrQHSRR3BFW5jMZ4nMBsDXwtTtKoXvUHw06ShoinkRShJYJ3L
	tMu3mz2FGLuGsxCqhGb3SJPkCV07p4Puc/FNCBKNfDW9X9d9FN1ECPfDtwLXkG3oPPjnWyesKuy
	B6
X-Received: by 2002:a05:693c:880e:10b0:369:779c:6e0b with SMTP id 5a478bee46e88-36a4241bcc0mr11972021eec.36.1793530586957;
        Sun, 01 Nov 2026 02:56:26 -0800 (PST)
Received: from deepanshu-Legion-Pro-5-16AFR10.. ([2405:201:682f:383f:8e3f:ca13:23cc:b148])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a4239ca82sm25088155eec.0.2026.11.01.02.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 02:56:25 -0800 (PST)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: metze@samba.org,
	stfrench@microsoft.com,
	xiongweimin@kylinos.cn,
	yanjun.zhu@linux.dev,
	ammrat13@gmail.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+6699995b421c8ec7d2fe@syzkaller.appspotmail.com
Subject: [PATCH] RDMA/cma: Don't warn when device removal races with rdma_resolve_addr()
Date: Sun,  1 Nov 2026 16:26:15 +0530
Message-ID: <20261101105615.20253-1-kartikey406@gmail.com>
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

rdma_resolve_addr() on an unbound ID (RDMA_CM_IDLE) first binds it with
cma_bind_addr() and then moves it from RDMA_CM_ADDR_BOUND to
RDMA_CM_ADDR_QUERY with a second cma_comp_exch(). These are two
separate steps. Once the ID is bound it is attached to the device, so
cma_send_device_removal_put() can find it and set RDMA_CM_DEVICE_REMOVAL
before the second step runs. The exchange then fails and hits the
WARN_ON() added by the commit below.

syzbot triggers this with RDS over rxe, where rds_connect_worker()
calls rdma_resolve_addr() while the rxe device is being deleted:

  WARNING: drivers/infiniband/core/cma.c:4120 at resolve_prepare_src
  Call Trace:
   rdma_resolve_addr
   rds_ib_conn_path_connect
   rds_connect_worker

This is a valid race and not a kernel bug. If removal wins before the
bind, cma_bind_addr() already fails and the error is returned to the
caller, and err_state in the same function already ignores a failed
state exchange. The caller gets -EINVAL, and RDS destroys the ID on any
error from rdma_resolve_addr(), so nothing is leaked.

Drop the WARN_ON() and keep returning -EINVAL, and document in a comment
that the state may change because of device removal.

Reported-by: syzbot+6699995b421c8ec7d2fe@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6699995b421c8ec7d2fe
Fixes: 732d41c545bb ("RDMA/cma: Make the locking for automatic state transition more clear")
Tested-by: syzbot+6699995b421c8ec7d2fe@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
 drivers/infiniband/core/cma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 337a49d1acf7..46741c1fd34b 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -4117,8 +4117,8 @@ static int resolve_prepare_src(struct rdma_id_private *id_priv,
 		ret = cma_bind_addr(&id_priv->id, src_addr, dst_addr);
 		if (ret)
 			return ret;
-		if (WARN_ON(!cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND,
-					   RDMA_CM_ADDR_QUERY)))
+		if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND,
+				   RDMA_CM_ADDR_QUERY))
 			return -EINVAL;
 
 	} else {
-- 
2.43.0

