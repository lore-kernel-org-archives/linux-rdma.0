Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793280690;
	b=0O64Ui4217geBqY6p/3pCG7QAYzHKxmNM/YczoeKtlly7v9q0TLmJtKWqXSU1NKbj36h
	 DOfRUXKzCjt4YDQyWG9C4/w9zDWl8QdC8bhTNqLgLITK4qLJG1rBF1qRdPVtwPQYzTipe
	 Veu8yW+ptJpIGai1d8t1pWj9+1BUSwFKCSJtJmLh3n/ncX8Abrc5PCP1u9jz0QiZ7MesL
	 j0tFDzIbRcEHFhHFYmV1F+9Ggvm8su54yVAhAcSTmVUPsPwpyObhi4a/0H2QyjQyiC9F1
	 x5hQEPob/0wT0itclCvQCAqQpZ30HDXG4JPo47qnKv9xMePlnHe2LvkgASG/zuJ/S1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793280690;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=NHMxQIKiYL3Vq8m2u6aV+SomYp0bJW7RrrWV+cHooos=;
	b=RyYdwPpS2Iccbr9th2T5BwuOfjqD4qJvi2dFojX9/8BDpn48T/K0/6756QHX/qv2yuqu
	 /gj9+1bGaNuCdrQzb0VgDgCFttpjflq1ttFaw5MDfg4MFAEKWwrxXc2TxJ+M5rX+FjBYU
	 c7ytxcJs9trYT4ZCcgPVVT2YUGvR5UrUu1tnUQHnBhtUe7KJ4ltU+PYJOutJsP//wLsdI
	 UOXN25JrrmuU7gNSphJRpq4eyYChsN7RVeMxytelCjdu5nNETcGQt7aOYFHzs5hJpZXxV
	 cpZfEbDOqYQ6QPRjvnG8HYXNsvPklytNIJ0jKoqEUU91qmmJ6gGfaDkxFOUBN4KCJXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=PocFez0t;
	arc=none smtp.remote-ip=74.125.224.69
Received: from mail-yx1-f69.google.com (mail-yx1-f69.google.com [74.125.224.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06020606A31A
	for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 13:31:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06020606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=PocFez0t
Received: by mail-yx1-f69.google.com with SMTP id 956f58d0204a3-6756044f260so1264350d50.0
        for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 06:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793280689; x=1793885489; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NHMxQIKiYL3Vq8m2u6aV+SomYp0bJW7RrrWV+cHooos=;
        b=PocFez0tZYGXz09FW6IDr5c7k2LOACzMx1IpLRbXOlguWiYNzkdFfQBw5SFi4fnVH/
         mFyKB/cDZ233bSqBOe5H3aUEOGkepzCWQv983YwX3wIfWf5p9HHcpgiI8TaNpTv9GUuv
         8EOoGfqA9eyop+/5VIsuYSMYG/whFJV6cycnPQfza2OW4zk1eJrktxYo4ZONGz//iZ45
         CQddQdeDI1mS+WDXNpD27XnwvP1tDmwYmRFnxyK+hZDw1x9pPnpd9/7VbfTFx19sDZAf
         NvZE35hEvOrlhtn/N6THs8wSQzHY4lG0hqL+p4wuUPloP2tiadumnhNb1OMx3TJrTBGc
         /8Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793280689; x=1793885489;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NHMxQIKiYL3Vq8m2u6aV+SomYp0bJW7RrrWV+cHooos=;
        b=y4OZGBBHADLF0WhRWNhQfNfhmYpafeTjBu8HR3Npa5M8pI6i6YmqlFRR3EH3zOKQMh
         RhsLQsgEUXs81pwS0oH7yo8O8IRroH3AQNd4vdOsDTF8JTUASapVzI9VQoA6LK2ujgGd
         VCc6nB/vncpmp94k2DxhNJ1pxmAKFbO5/uoO4xHwQ4rcKcfzEYWtUB5CNpQ0596VH4ZN
         obksBbA0t2f9PsrgDIBGKrEtBUOTH6izjFuSdEdko1XhSbwg9qK2XnLdwmk8GMHQvCaH
         vAA7gLwuptPJ8Nc3En0iJujp+jG/NqC37qaiPmDfTfC3BX0xFbyRAxjnhBV7oJPjQTrq
         G4Lg==
X-Gm-Message-State: AFq9FYLu4TKFtWS4cLVr1T7ekB4N0MyAy9SaKiUyjb1syQ8mk+79haDW
	KkgYYMhCaIisIeQS6Ky84AADAJjWwVOFf+tL/bmeDXIlSho2rnq2ZG2SA4rbspX9luVi65L280j
	opI6WywFcvg==
X-Received: from yxsj1.prod.google.com ([2002:a53:eac1:0:b0:677:b337:6db0])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:690e:1918:b0:679:ad2f:3fbf
 with SMTP id 956f58d0204a3-67a8d0047a5mr1967992d50.8.1793280688738; Thu, 29
 Oct 2026 06:31:28 -0700 (PDT)
Date: Thu, 29 Oct 2026 13:31:21 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261029133121.1204636-1-jmoroni@google.com>
Subject: [PATCH rdma-next 2/3] RDMA/irdma: Do not allow rereg_mr to revive
 defunct MRs
From: Jacob Moroni <jmoroni@google.com>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

An MR can become "defunct" if a previous rereg_mr happened
to fail in between deregistering the old MR in HW and
reregistering it (e.g., due to ib_umem_get_va() failing
in the IB_MR_REREG_TRANS case).

In this case, the MR is left in a state where the umem may
have already been released.

If rereg_mr then runs again, but without IB_MR_REREG_TRANS,
it will end up reregistering the MR with stale translation
info.

Fix this by rejecting any attempt to reregister an MR that
has previously failed during rereg_mr after the point where
the MR has been deregistered in HW.

Fixes: 5ac388db27c4 ("RDMA/irdma: Add support to re-register a memory region")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
---
 drivers/infiniband/hw/irdma/verbs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index c91c55917de9..fd1b1454f026 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -3873,6 +3873,9 @@ static struct ib_mr *irdma_rereg_user_mr(struct ib_mr *ib_mr, int flags,
 	if (ret)
 		return ERR_PTR(ret);
 
+	if (!iwmr->is_hwreg)
+		return ERR_PTR(-EINVAL);
+
 	ret = irdma_hwdereg_mr(ib_mr);
 	if (ret)
 		return ERR_PTR(ret);
-- 
2.56.0.313.g2479322e68-goog

