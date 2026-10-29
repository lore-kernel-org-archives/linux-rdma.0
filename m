Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793283536;
	b=qyyl3aa2e0wbkZsDqPGRemqur326ZZH0MmZ7BERK8TONGT7Sxo/61uPnQT0dJKMDVgWh
	 9eKiMfN/oVkEv3A2guDorHOsThTooNSU7l/EwSOeZVMrx4uMqh8Z+XTe7tubg9z7lK/9M
	 sgWd+H7x05TTMpyEW5ghKuX1/6t9bcude+7Im9ZvMA5TnV/PV9F4vcRdg+lA2IbVwwMQ4
	 UYr8oY7dpb+yAiCYg6EfyvUwAWqkUniYiRw9H8g1cNkLJeLuNWQEQeAJkeU4+96DeX4rl
	 ukGrwlY4n3Jx7D/I/P0+OerGXiaM4WRIj36DHnjBIoD6jpuI3+5rNTEpCKSILb6Ey6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793283536;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=6eYrrFCL/YXcx5LxCzfZ5IJYGvHNLayxhBaO1y4wwFM=;
	b=pRf9FXP/9Baf/2ZKbUzo4c5lLzcLJpmL083+bsYT2Ug5DuSiNMXOP0a77oSFyaKvwxyl
	 CaEjd4bTRP12vsW8cAjVGWY1+cVRmXUishawtI11PZhGAfq3PNPWE23tWLQgCFmo/Seqd
	 ee0cQ+1DhwCxF6t/a/BiWQMIpYo9+Col14xz+xQZMbLKr4VL/DUpWcTeMRetZ4iV1WzKk
	 NHuJinzHAQm5oDe0W6kQssmia9gSmUo3Rm00xZsnDZPlDQOh+uqOUkXeGULcTfmoIT3GZ
	 +bmluMx9LE59Eqvdt5aMRnYNG9sLdLCe5UFXTlqSFZwmTO4xKZtWiAWLpoDpKMHcSHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=iWVCDvKC;
	arc=none smtp.remote-ip=209.85.128.197
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com [209.85.128.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CD160A261E
	for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 14:18:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 05CD160A261E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=iWVCDvKC
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-8b12b209c4dso24075577b3.2
        for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 07:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793283535; x=1793888335; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6eYrrFCL/YXcx5LxCzfZ5IJYGvHNLayxhBaO1y4wwFM=;
        b=iWVCDvKC/0mQ4f/F1u7/YX/jQEEVfifZL89qLDXeq7617992RyD10qB7loK29d/NSE
         mm82vHUDg+AGvEbS1UeBejNHi5Q0xIywQO2RQnMjq6nedM02hqX4xRPpSRvUEvMrZIwO
         W5F/jZXO7F1jXojVJUlpD5Rh6vCDV4keSudvHcoKQWrFoSQqzZeLLy/dX8DnyGdg8Bvi
         tPZz1eLX22qkIE/8vJYruZHF9yosE9x2Kg+OC+dLtGkrhBinW9jVJj8XMHeCEjDxMQmX
         60+SWzyMRIL8ooF4P7SvN73apjU2ImPGrbTGMQkuxHq5n1Jm0js/9DswvtsAbqVkfkZP
         i3FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793283535; x=1793888335;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6eYrrFCL/YXcx5LxCzfZ5IJYGvHNLayxhBaO1y4wwFM=;
        b=e0BMG0g0qKYs2c7ScqT0Skk2taLB7xNYVD0DDADOCC1LliOU1PLH46TlCt90kwuyis
         KQhCxUbJwH7/0bmikEbjEVOrOGNv0mtcXzhyccCUISqGxATRJuY949dY9qXjONPDvj+L
         +3kCXGxwjLzixniKJmhNhCpOegAoYzDHZasrzhdhpEXdjPtLBRhqi0VSoVZgZRjsgXBD
         jl20I0G0BTZdx4+Eq858t9Mus/mdBngSCqRrCB9tB6jeelZ3UfXcm4Y442B8IP+7gfQb
         dNxtDGfZsFaDosqOYQotO0+nl2i3VQ4nQ6+HikDoqa8yIGq8xcqsVM27fKIvac7Esw9m
         RkgQ==
X-Gm-Message-State: AFq9FYKSh/MzaobDA0LI2J7JBYdQ6L+XCTqqKBtc3dHZkzYWextqOw8Z
	HluEeESMHY/A64IB/UO3thezPsWjLrDyZ7gejN9OiwrHqXwynxkpnXuiFvUhHNaidAbwhsX8t6S
	aGR8cptcOPg==
X-Received: from ywpp9.prod.google.com ([2002:a05:690c:a4c9:b0:8a7:40a2:1f99])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:690c:c1d0:b0:8ae:a5b5:e97a
 with SMTP id 00721157ae682-8b1b5b5b748mr31284037b3.13.1793283534913; Thu, 29
 Oct 2026 07:18:54 -0700 (PDT)
Date: Thu, 29 Oct 2026 14:18:47 +0000
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
Message-ID: <20261029141849.1575012-1-jmoroni@google.com>
Subject: [PATCH RESEND rdma-next 1/2] RDMA/irdma: Do not allow rereg_mr to
 revive defunct MRs
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

base-commit: c3e8e9451e6f1b69f685b75e0fbf14f3d0fb2539
prerequisite-patch-id: 6e527df00a7bd3c3941ab1af65ab5d7115264bb6
-- 
2.56.0.313.g2479322e68-goog

