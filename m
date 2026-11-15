Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794752968;
	b=mUhqTrf6Nc9M+prYKVizOOJ8XfPO3NPZ4GQmE53fp3wqQSjtskm0MiAjD7T+MKHbwSTC
	 hgJu5HqJczntEK//F6+JWZ/X6J/SxzaUBdGTx9JcMHpIEFS+K+tpJi0m2MIvmB5c6ubIh
	 tqooeVZqreqnJUozBp5te+VOAfJdrOugY9k+jDJkQ9yp56/z4l7tcDaxUz92tvLj/iU6c
	 hdklfum03QimOEIevAxNbgopI34HGTqAa1fRHe+qXwmUMhCPtmVthtpdrjGqOQ5cuZKd1
	 0nPPrweNlVOfrqBAGWYn4spER0Zy7OCPYHKFoDLDGKedqf+oT5LjHGQfBfpfVfsBVrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794752968;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=WjclKcwplx9taVvKi16krzdNqwtk4wWsBv60eOBTtB8=;
	b=Nfnr8autOaARztFN3R7Q2RIRPC1ytEVSAbdIxbVoiRen5mJr+kQhQ8IvZ7Up0Iv+gvWf
	 618vahWLkTJdF4c+1O9X32waNCWfmbpSJMjVr7h97iQkbwTkBL06SKTNZHQnRiXI81A65
	 Wm2nP0cedCOmVfhdw2ZGrBRbpDQCw8B31d0z9lAxyta4Z2Z7+CQXQT4z4XW51DMC02rZf
	 AYrAzXYgMUqmgeeEvEDHT+obA4y3JTUDt/pZbK1Urh1jmLepgaPO4QfA8n6eWGTJHEL2a
	 y8GL9UFuxdChlTwZdkTbVou+CdruHKQu6bAd3ZzKOqscEZfMZuqGhLSNH9lRwip2nsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kugfSTGR;
	arc=none smtp.remote-ip=74.125.82.170
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B321606A31A
	for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 14:29:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B321606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kugfSTGR
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-37f14feca60so220594eec.1
        for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 06:29:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794752966; x=1795357766; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WjclKcwplx9taVvKi16krzdNqwtk4wWsBv60eOBTtB8=;
        b=kugfSTGRtKxyvNeQnU3q+Btfs6ZHx5iwC1Xh2t7EovosTN575u61PHsnW9cyVobBSI
         t0yOMUFkp/DrbzcdY9xnFTWaq4ZoWJXFTwMjQNRZ+rzZfzNE/xZOn5ArLMMdAW1XoOqJ
         ZXV2lD/ATD6+SL99heT5/BGbT8U1aC/MnFZaYQ7+OUJAYLbeMCiDNPbLzHroIirv1OkF
         SAWp3RxdcPUVtzjqHr2Ce1OVSafrFuAHvjR6eOXMaF7XtXYOvvf0d9mG6tMFLlFyMVAQ
         W5EZBj9NKVBYIrx2iT42byGb/cFz2F2tBzE6PKLm2S+huRsmZW6PIJ3hNobyhLfHtQwL
         Qs0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794752966; x=1795357766;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WjclKcwplx9taVvKi16krzdNqwtk4wWsBv60eOBTtB8=;
        b=a6m1ZuZCYNOD87a4vlyWmWNYggnCpnT9ggan5SnAP7mUZlIWojrHr9wopeL+C3FoJq
         110lpTmQWSgv57srSAB+PyMKXEfMEsQPxnp2zrF1BpkXZSAArJweEfaqobguxRMA9eaZ
         TYzXhkPURUWH77jHpN67OMrrpSXiTcLfuQyYtgGOvcFzK7NZbyl/XGkrDo54zzPvsqu3
         9UVK8T3FArRm/B+c/FqtytAH/ZQAuh8GN4mb04Ig1OI5a/kW0ZAMy4j3IRia6bHyONL7
         oFWa0cyohsjky/58Ci2ncndcSp7kqlo9DP24XqEqNOzaPdtxq9G1dFY0oPbQni/rrTHm
         kNyw==
X-Forwarded-Encrypted: i=1; AL+hErFoKdQimbFN09dOkknTwSkkfd8xX/5fOl0jZ680sKWlifqjYEW+fayu7k+HFThXZEKPoDd/Yc4nh5bU@vger.kernel.org
X-Gm-Message-State: APuU4Z9LZKvcvOt0JjtZ5cQqZ3qCGTqp5QthVwU+5T0Bw4xg8Z47dF45
	bclhHOZJqhR36Bf0Hk69Cwueim1ypvUGgVkush8BXAb40gUy3/j/YIln
X-Gm-Gg: AYBFou2nKAtQTSTSNtwy+wUUr/g/lXY7wwDD2GAH6i/NZYVskrgNHsInEoLcfiq/2Ak
	mHPddN1R8l1Fk0le6oIHXTP2ZtKkonRVO9wGoW0EDy0yEUbtzfk46+vS//PL//g0sWL7TPJGFuG
	m9D1/w75LKguczyZWoS/K3sqtf6OiLfKM5Hlm4U+JA8MwwKORqV663BVDqI0jnshCadmhcr/YSW
	K7E+z22sajfVTnmrZXCGTpynLPcxIBMMKlZpYjT0SCRqwHOKMEW/Ys7yFJr6zc+rsjburRZBf4o
	ZMRitpwN8G09L/zVAG1tkg4VVYRdqZyflr4+FHrLlFmngIoUmoZH60I52g5p++2IgXaX8WA70kz
	tGXIHrBPL9l5Bh4mK5RGFEdCRIyxpvrexxMCXkJnL2w4z4V/2KZBuUTk17nSh1yx8AwHMvWp/2Y
	pi9wNOXItAjo3v/0hwIISQEb4X06a+OT12PDs6XVxrAGU5L9UWAq9Wz5gTd4EBFJOhhbXiyZ7vb
	9lWnTHeepl3NF0BwvHZ15xJD/jCJ/huoZhAKV/MpN2uVfoMWdQBsaqAjrzMZCxtFmixMIbJ7FNF
	GgTPYxT/XOsbFJ/kYrTNndOFg4uUrTWeZ5O48OIF7vXEx9hSZc4YfwgBjwYxNIWUxQqahUxQ24l
	2hmbQwn5Sf7zICy6p648Jh+n3ZzP+tLPgaaopO2dbxUMh9viAG+CZgTCjjurjpy2gicKeYxK/g1
	g=
X-Received: by 2002:a05:693c:83d2:10b0:377:2663:5fa4 with SMTP id 5a478bee46e88-3796676b191mr9341645eec.20.1794752965210;
        Sun, 15 Nov 2026 06:29:25 -0800 (PST)
Received: from deepanshu-Legion-Pro-5-16AFR10.. ([2401:4900:416b:f7:3763:c5b1:411c:ff3b])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379558231eesm25168019eec.12.2026.11.15.06.29.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 06:29:24 -0800 (PST)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: ynachum@amazon.com,
	yishaih@nvidia.com,
	edwards@nvidia.com,
	mrgolin@amazon.com,
	hemanth.selam@gmail.com,
	michael.j.ruhl@intel.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+d60be66dd00b4490fa96@syzkaller.appspotmail.com
Subject: [PATCH v2] RDMA/uverbs: Free all radix tree nodes in uverbs_destroy_api()
Date: Sun, 15 Nov 2026 19:59:11 +0530
Message-ID: <20261115142911.21321-1-kartikey406@gmail.com>
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

syzbot reported a memory leak of radix_tree_node objects allocated
while registering a siw device:

  radix_tree_node_alloc+0x81/0x1a0 lib/radix-tree.c:276
  radix_tree_insert+0x140/0x390 lib/radix-tree.c:712
  uapi_add_elm+0x61/0x140 uverbs_uapi.c:41
  uverbs_alloc_api+0x85/0xc50 uverbs_uapi.c:659
  siw_newlink+0x36a/0x3f0 siw_main.c:433

radix_tree_insert() can fail with -ENOMEM after it has already linked
intermediate nodes into the tree, leaving them with no entries.
uverbs_destroy_api() only removes populated slots through
uapi_remove_range(), and radix tree nodes are freed only as a side
effect of deleting an entry, so these empty nodes are leaked when the
uapi is destroyed.

Call xa_destroy() after removing the entries so that all remaining
nodes are freed.

Reported-by: syzbot+d60be66dd00b4490fa96@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d60be66dd00b4490fa96
Fixes: 9ed3e5f44772 ("IB/uverbs: Build the specs into a radix tree at runtime")
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
Changes in v2:
- Drop the dummy insert/delete workaround in uapi_add_elm()
- Call xa_destroy() in uverbs_destroy_api() to free all remaining
  nodes, as suggested by Jason

Compile tested only.
---
 drivers/infiniband/core/uverbs_uapi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/core/uverbs_uapi.c b/drivers/infiniband/core/uverbs_uapi.c
index b67db3790f03..77a4eb494936 100644
--- a/drivers/infiniband/core/uverbs_uapi.c
+++ b/drivers/infiniband/core/uverbs_uapi.c
@@ -621,6 +621,7 @@ void uverbs_destroy_api(struct uverbs_api *uapi)
 		return;
 
 	uapi_remove_range(uapi, 0, U32_MAX);
+	xa_destroy(&uapi->radix);
 	kfree(uapi->write_methods);
 	kfree(uapi);
 }
-- 
2.43.0

