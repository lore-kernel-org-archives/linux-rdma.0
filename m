Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795092120;
	b=fXSSXSgv8TGzTgYWGwHwKyxWGUQXoJqfOfp7jVsR7mXfkpz3DSPHLfxLt+SwWPo7rz0i
	 zR+P3NkTQrIWWflN6YAd5+A+Sixb6vFKCpZPIOpmBbRFXPa6CU3esJbAJ9uwK0YKZtZhz
	 ctzgeMSj2dhj12SxEoH6HJiWLBqD6Qb16ZO5c1DR3MJpBgS8zwP89bzVMjhAGF15mb8rA
	 hXT8htjvNTKQSt8jp6g01uJlH8FE/+T90LmdxL3pMTpdZdVGaB+oDf66Hb4wUU1Nr5pry
	 hAi0OCHeadNI/S2zZcuHpXaWjaeG3quLoEivDmvLALkYISC0G39Fryp0t3xpUnChBuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795092120;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=mOE3Rbuw9z95CS+e89nm2qahBlkxcAeUx3ho/7BXMuo=;
	b=jgvNHMdhriobr9VAwJrwv3OuzS5Rh3B0Ejptpcrwbvb5k+KA8Waj0YsddcU/Z85C1eDE
	 CWy7sBzKl3dux1zvTYuyGDR9hMlFAX8yYa7GIwwkCjouGCgOQppHh50jPsXw4mFOYKbt0
	 THYOb/YFXnCL800qFZWwttle9P/iEVWKH6oaGlVvtX/h9zuwnVJRIUs+ZKJjECSm5fqRZ
	 Llz78A28sPK8c9ud8C+0JlQb0y7y/KvJA8v8xt+rwj1CzZXk5/JVwgalthSd5HaiQbNOC
	 kPKzjKz0Gd5o12I65Iiu9oyJXhHqiDOUuiwhecbXUVqkMkZ59gHiUpi0g2RsQZfyHlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cloudlinux.com;
	spf=pass smtp.mailfrom=cloudlinux.com;
	dkim=pass header.d=cloudlinux.com header.i=@cloudlinux.com header.a=rsa-sha256 header.s=google header.b=Y+hvqyrA;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277C2606A325
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 12:41:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 277C2606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cloudlinux.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudlinux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cloudlinux.com header.i=@cloudlinux.com header.a=rsa-sha256 header.s=google header.b=Y+hvqyrA
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-4a3e706b5dfso1399444f8f.2
        for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 04:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudlinux.com; s=google; t=1795092118; x=1795696918; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mOE3Rbuw9z95CS+e89nm2qahBlkxcAeUx3ho/7BXMuo=;
        b=Y+hvqyrAvGs1ec1QqlTmDLvfzSnWLZKXPNuQfzHstZzH6CQDJajImBeCM9q8kNfhlC
         mMAu4BmEHpD0TWRgFv0ncKdEXUrid59k9CHQPoHAMYq9YUV1cDOgePkSgyZT3CWwo8mc
         zb315Ys+BB30Y9yA9VQwZiroXOyIPodeVJ4YXiN1Mxs9HizQO9omoJIqcaK66mYpkH3b
         7ClQZBJRXaMrhdPPhMO8lizh0XGQEGU5arOWoQo8pvyFM6INoa4ENeB+tAj8m1VS0C0p
         xB5rgeun8fSdPb49E6voZgYy/s8YPz9GYSlN6SoxpO61zrNHQzMsX96yraVB55dIPoRN
         N78w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795092118; x=1795696918;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mOE3Rbuw9z95CS+e89nm2qahBlkxcAeUx3ho/7BXMuo=;
        b=rQXcAD1dJoysdbs3xkimPwfXD0hlnrY9h6EXreYDKzU0PzYau2whsjrU1sZ9uJkiF/
         uNw0zGGMsfoy57FKIQb2Yp75wS9wQkKJ/yi0tRkff8txnO/gWA+zrfScYweTvrW7oIEv
         TXsu+bI4HyULqbDksew++G1owVz1m/nog3cs2Z1BF45dzWjRN6wMXtW2YItD5DO6Wi7W
         kcf1i5CXAVmDO7E1zo5tdojKlLQjX+MDLZGHyN2akqAj2hj+f3uf6XMA8NL+zuctpjy5
         wI8R2lA+XjA9PiUX6v96Qn4h/ZfcC8Z6nUjGM9kLy21nC+Xnx8ZyfPDYl0KPaObExrxJ
         5vEg==
X-Gm-Message-State: APuU4Z/iqqk6+h9diNEMhcda/o14qZlJA22XoWz24gbnjlFxERX0FN6C
	u3WPYIL6Eitg+4V89ogPQwvigYPIcbDL4PymcCNjnNxNj5/qVprU3rT5b6d65i17FqI=
X-Gm-Gg: AZFdTZehUb8DJO2D3GoFweWtTe6qMBUbGSgrU5DVFy5qLxLEAMv0uFB1YoIVpWLAs0/
	97G9Ll1mc0N3MeucEVA+8i/c1VK+7f3RceU1SG3PMMGHRN2MRJFHepfo6CRk7luggkJSrplnE/h
	jr62XH1viqJ7a6JTK8Xtac/k/sqnmX9iP8ismpsvLNEII/ByHAhHM/9MsL3zTizuuAQbcmx9l8J
	mZ5nH6dstD0nvB20n6JQNVJTRynIAXZT9RIJshHXHbIaQnFb6sg3+vWopQ6Rd8u2Azn1PFb/RhM
	SD2Ewe0zN7YVnnvfZLTRMWz8rx2DKBUlZht11Zq7517jXbay/ntm34olpMasPB0tLUtPzZUbw+u
	CIVyIr+4REr7UxMZt74TNjfU10WyspbzfRxnA3mNhteKxL3SZ/r07iU2dQTpkpjQ0gGgzRwGFpK
	d0YbHeql2DR0dTDqghg1HbjSPmkMBBsPCVGnYG+QpMl143sFENXXLPIyzB+zluw+ChkhYPdeJiY
	GajVq+KQRBzBDMkKlLWQFhaEAzJ9CRLbt2blL9LbIakpaJST9yV56P2RZ4gJg7WOHDQvnIldb4B
	iGfB14rpGxQRhFBVnhf8xcrP
X-Received: by 2002:a05:6000:25c6:b0:49d:7e8c:e89c with SMTP id ffacd0b85a97d-4a63d985dc9mr11927185f8f.42.1795092118533;
        Thu, 19 Nov 2026 04:41:58 -0800 (PST)
Received: from dev1.kernelcare.com ([2a01:4f8:172:1c85::2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a656a28b8esm10787266f8f.50.2026.11.19.04.41.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 04:41:58 -0800 (PST)
From: Andrey Misiurov <amisiurov@cloudlinux.com>
To: Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>
Cc: linux-rdma@vger.kernel.org,
	Quanye Yang <quanyeyang@proton.me>,
	linux-kernel@vger.kernel.org,
	Andrey Misiurov <amisiurov@cloudlinux.com>,
	stable@vger.kernel.org
Subject: [PATCH] RDMA/ucma: reject a second join of the same multicast address
Date: Thu, 19 Nov 2026 13:41:53 +0100
Message-ID: <20261119124153.1745521-1-amisiurov@cloudlinux.com>
X-Mailer: git-send-email 2.43.7
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

ucma_process_join() lets one cm_id join the same multicast address twice,
creating two ucma_multicast objects (A and B) and, via
rdma_join_multicast(), two cma_multicast entries that both point back at
the ucma object.

rdma_leave_multicast() matches a leave only by sockaddr and destroys the
first entry it finds. So LEAVE_MCAST on A destroys B's cma_multicast and
frees ucma object A, while A's cma_multicast stays on the list with a
context pointing at freed memory. The next event for it is a use-after-free:

  BUG: KASAN: slab-use-after-free in ucma_create_uevent+0xb11/0xb70 [rdma_ucm]
  Workqueue: rdma_cm cma_iboe_join_work_handler [rdma_cm]
  Call Trace:
   ucma_create_uevent+0xb11/0xb70 [rdma_ucm]
   ucma_event_handler+0xd5/0xa10 [rdma_ucm]
   cma_cm_event_handler+0x98/0x310 [rdma_cm]
   cma_iboe_join_work_handler+0xac/0x170 [rdma_cm]
   process_scheduled_works+0xb59/0x1890
   worker_thread+0x470/0xe40
   kthread+0x33a/0x450
   ret_from_fork+0x59/0x90
   ret_from_fork_asm+0x1a/0x30

Any user with access to /dev/infiniband/rdma_cm can trigger it.

Reject a second join of an address already joined on the same cm_id. The
incomplete fix 662ade4de9ff ("RDMA/ucma: Serialize join and leave on
copy_to_user failure") left this path open.

Fixes: 662ade4de9ff ("RDMA/ucma: Serialize join and leave on copy_to_user failure")
Cc: stable@vger.kernel.org
Signed-off-by: Andrey Misiurov <amisiurov@cloudlinux.com>
---
Found during a backport review.

Reproduced on debian13 6.12.88 debug (KASAN=y) over Soft-RoCE: two joins of
one address on a cm_id, then LEAVE -> the KASAN use-after-free above within
one run. With the fix the second join returns -EADDRINUSE and the run is clean.

 drivers/infiniband/core/ucma.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1509,7 +1509,7 @@
 {
 	struct rdma_ucm_create_id_resp resp;
 	struct ucma_context *ctx;
-	struct ucma_multicast *mc;
+	struct ucma_multicast *mc, *tmp;
 	struct sockaddr *addr;
 	int ret;
 	u8 join_state;
@@ -1544,6 +1544,13 @@
 	memcpy(&mc->addr, addr, cmd->addr_size);
 
 	xa_lock(&multicast_table);
+	/* leave matches by address only; refuse a duplicate */
+	list_for_each_entry(tmp, &ctx->mc_list, list)
+		if (!memcmp(&tmp->addr, addr, cmd->addr_size)) {
+			ret = -EADDRINUSE;
+			goto err_free_mc;
+		}
+
 	if (__xa_alloc(&multicast_table, &mc->id, NULL, xa_limit_32b,
 		     GFP_KERNEL)) {
 		ret = -ENOMEM;
