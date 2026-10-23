Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792749732;
	b=NEu73gIBApwbxgw4d9X6H0aAbVoQb/QUys9ReWL2LHtpHj11rWo5tofCpXIjCJxJ1418
	 Nhn5WFNWiZhY6FIXOkRevvBDfXr6p/ehN++i1zvatQbefFAUspJDPHbBn1vyXPWPa4qS7
	 NKdwrjn06Xe08DP3n8JKZikoqoN7aUOyFkBh1W9vwu6Qgj/FP8ldzz1yQqZY1Pzmp9IAZ
	 2q9kyf0w03TZ02nvUuX6b1ZFLB2WfXC+C9JyuvH6Rz3fI8wr4RS7TZB0ZMtC3OIJGYxRF
	 I4WPCsXca4BWnaCrEV3wCz2/Rh/nVGxWeSWDu8fLI4Jh6YgAOvpRVMsY7esxVW+IVjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792749732;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=NSR56nnQnUR0d6l59Po8MuoMPblQ7AEGRUC1M2Gh/5A=;
	b=ubCf7tIcZGmhUAgSZQZRxCcxIiYBkYm7G2IqLS03zXFnkrlWX0REfDeEj/Crp7HSCEMf
	 +7INsA1pGeL0KCuD9tZNz1l3xhE/n1dSLcw3+w8NQMfL09xfbK6Hv8co6iWK9FzzITOzr
	 HXpX3MLrTaM2eYgV8oKYxrjuIXPRXeeHTUy89YWORzur1I8si+zR28x8I/8SiEN5E1xyJ
	 iSVBDhVXWXSG8XpIAjrAsl0exRcpghjo8S7FBH4LvRll1EX1iuHnufuKl7T26vgqV1pma
	 xroEmW9IX9TwRAGMflKvQr0gCZSJ871ujtM0j/RJtBqh4VR0EplEY+i1+wPslu6DvVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="e/VonHDs";
	arc=none smtp.remote-ip=209.85.221.43
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653C3606A31A
	for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 10:02:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 653C3606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=e/VonHDs
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-48e20ed3b9dso568583f8f.2
        for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 03:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792749731; x=1793354531; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NSR56nnQnUR0d6l59Po8MuoMPblQ7AEGRUC1M2Gh/5A=;
        b=e/VonHDsRcN+yoJTQWlImqGswC0azS4maOfw8sqzWjYxI6m5YuadKrBI3wsSM3Kdol
         f33SjPRNQxiHbtG11cEW+zNdfA23IggN6VxfY3En5xqzUkNQjoLBFnxZrKC5c9d1F1V7
         86QW95Gbn9QaUG9ctmVajG+TWYF6O4wMl4E9wCXtM/ggiJy83O1M7KoOCEEZhmH6ktC8
         cKid5ORUaDulA4AP9ZuFDgZETyGdnxoMqBJ3o8/L/4TBRe0qbsDDA4MdnpjVbKJXg6rQ
         mYLzpj+FHbvk7j4suWqlh0SE8DUiQ6SOGeFjx11DANc0OWJsFUa+XYK05vE848HgShw5
         xciA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792749731; x=1793354531;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NSR56nnQnUR0d6l59Po8MuoMPblQ7AEGRUC1M2Gh/5A=;
        b=gcA6h21ViiQOzVQXKMv7PO2+2WVR80ZoMKSVTpcCz6xgz8X47b2idMsCr2MJHzsU4F
         qq1v6s242a73oSaYqy5+GEb+9MiyK5CAJmgUeTxGsOo4LwBoHssmt11YaaE5TE+4rFNU
         4CuBxYFSu9VFKxCMLC09oQ85eF3ndH/C/Su8GnJwzQzwmwJlRxJ9tAtQ7zCGe+fzenyP
         ESnDC3rRsh9NwbzT8wEc3g/YIoUzy4xGLTs6BBVkMHdJZpDOQBi3U5TTkWLR1/pJuDCe
         72yFM+CiPmHiKRkCsdf9m+iqy6s4QVFSs1qS5QsuSaaiKnwtiTvd4J05kAGCfGcm4JE9
         0L/Q==
X-Forwarded-Encrypted: i=1; AKwUvBw+/5y5qGnaorpMP5rpvT+M53lTi26yTgOB91qy16NxNMvCexMGxotc63GS/It7ZWye8g9Kc7DDdLpM@vger.kernel.org
X-Gm-Message-State: AFq9FYJt8cU+lC4gJ6teXpFyt9JDW4cyj6Vt0aFJhKaGz0hM+nQ/W7Bh
	Eu/MsJcNrMLPG33h/J4sQLG82xA9M3XUzuaO5k7xvKuYVDk3frDoPNS2
X-Gm-Gg: AYBFou2VO5sozbEoH5OiCTlsVbqQJSJklpasWucyoXz77hIdW/dRKgSitDCGPm1H46F
	UB01wsMsebUKcJbVhfKWGRn9Apn6WYrdkNPX0ZXP2E7RILS0n5ee4nj9UYWCyfgyjAHWhsBvvz3
	0Z6QmHI4RO8lxv7MqCZZaKm4/m/oPaZxGId+oJ7OIbDc3My+mO8u7z1t7iXP0sgdp5k6BaXn/g2
	wTFPA6UCQEp6bx/pJNhgkUf6VGGVQSb2kjdWYx2caOjukMZVN+yAv1czvt9V0mNy9IiaSx64sTr
	94nGgD4Z6PL6gsoRt/DzQhHmXapdJr+fSLiQ2/ytnsvpELpd/1FsBPCswR1mG553l+3svlnXZ8F
	IOLbbs/2Qumhi0Raf/sNPwCAA+lllqqPaoBfci5SVTSgnTLmozmzKGUyVwU+7cth5elce0bQasl
	BWlwUoMBwWp+db6ZxOvcW0A0lBxJQYQrVTnW1CSLBjQv6KqE6haGiaY5c0UR4pGwWcwy+qm5NHP
	tDkdTpuGes37RDEpXWSrjM3ydPJgG/QDCLTEdJD5/jm6/kQLG1SoAFJDg==
X-Received: by 2002:adf:e805:0:b0:48d:f996:1814 with SMTP id ffacd0b85a97d-48e385c0cf9mr1868754f8f.57.1792749730555;
        Fri, 23 Oct 2026 03:02:10 -0700 (PDT)
Received: from localhost ([205.147.201.218])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e38062dc6sm3902320f8f.55.2026.10.23.03.02.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 03:02:09 -0700 (PDT)
From: Eduard Zateev <hackerowskiy@gmail.com>
To: achender@kernel.org
Cc: davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org,
	Eduard Zateev <hackerowskiy@gmail.com>,
	syzbot+221e213bf17f17e0d6cd@syzkaller.appspotmail.com
Subject: [PATCH] net/rds: hold IB device reference through deferred cleanup
Date: Fri, 23 Oct 2026 12:02:06 +0200
Message-ID: <20261023100206.126692-1-hackerowskiy@gmail.com>
X-Mailer: git-send-email 2.55.0
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

RDS device teardown queues rds_ib_dev_free() on rds_wq. Hold a
reference to the underlying IB device until deferred cleanup releases
its resources. This prevents device removal from freeing it while the
work is running.

Reported-by: syzbot+221e213bf17f17e0d6cd@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=221e213bf17f17e0d6cd
Signed-off-by: Eduard Zateev <hackerowskiy@gmail.com>
---
 net/rds/ib.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/rds/ib.c b/net/rds/ib.c
index 786f39169bc..597872e4fe9 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -115,6 +115,7 @@ static void rds_ib_dev_free(struct work_struct *work)
 
 	kfree(rds_ibdev->vector_load);
 
+	ib_device_put(rds_ibdev->dev);
 	kfree(rds_ibdev);
 }
 
@@ -142,6 +143,12 @@ static int rds_ib_add_one(struct ib_device *device)
 				 ibdev_to_node(device));
 	if (!rds_ibdev)
 		return -ENOMEM;
+	/* Keep the device registered until the deferred cleanup completes. */
+	if (!ib_device_try_get(device)) {
+		kfree(rds_ibdev);
+		return -ENODEV;
+	}
+	rds_ibdev->dev = device;
 
 	spin_lock_init(&rds_ibdev->spinlock);
 	refcount_set(&rds_ibdev->refcount, 1);
@@ -180,7 +187,6 @@ static int rds_ib_add_one(struct ib_device *device)
 		goto put_dev;
 	}
 
-	rds_ibdev->dev = device;
 	rds_ibdev->pd = ib_alloc_pd(device, 0);
 	if (IS_ERR(rds_ibdev->pd)) {
 		ret = PTR_ERR(rds_ibdev->pd);
-- 
2.55.0

