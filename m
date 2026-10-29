Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793280471;
	b=NTWlp966YDr+UCu3zk01AdYlELMjEdriIxC/0xi+wmdSeOhNfn7aIdx7ptZ5k/7o/Tiu
	 w+VWIssys62gbl+1EVbEmYfoAqqoEeZ4vMdGIhZb+v4JsbC1wnxb/5X2boS52FfbAUxbV
	 f3EGNOG1b+H7VtXM8wVxk6RWHlmYSx8qZSyQqKjsByK8+Kcmtj3lBbchJj7mt6ZWvLp3B
	 LbHbRZn+cl6YLV2tdpockpi/k3z6iHp5J0JK2wBR98+g73wd26XZeJObUWipAWFFVZ8PH
	 7g7EyBjRSZf6fcVwWSTuYrP40q+4Yqbws4x5xEGId0BawdigVNkZtPvvAhAbDslk3aA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793280471;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=3CzqAH4xSsnmGsmzTYz5f2Dn8UH9l1H/VmV5jrqfT88=;
	b=28ajkym4JfFDaMnpjAXHVjbXrlfvRy4pxvDbCelBpxIgs8Q9sngpc7EHNtF70j9yQ1xo
	 KgYJsBkT329DT5dHMQLj0INUatzLNstZ0XB8J7dgw598HZ16cBRyP7Dk6i8aPpW5AOoXI
	 HrvhMMcJUUQxEG26qRzdNl4s3BW0CbnOu74FlGx6dnrnPDgMOa0o+VtpCjF90OCo/ywQL
	 +4BCiwszd2V7yC1NhBkoGdRLELSGvxPJ6j9l0P0D/w/BVnEYrYGM+ScpNPQWh9kIYMBD0
	 RfKYuWFsT7/H32yO1VVTHNUVr5u0NalfMeO+d7Vof4ABQaOWCjZFiUChFPXqryBvEuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=KE2fdXN3;
	arc=none smtp.remote-ip=209.85.219.72
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC63606A31A
	for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 13:27:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8CC63606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=KE2fdXN3
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-91c7a0f8250so45380246d6.2
        for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 06:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793280469; x=1793885269; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3CzqAH4xSsnmGsmzTYz5f2Dn8UH9l1H/VmV5jrqfT88=;
        b=KE2fdXN3vRYtCSIasNPUPCcYcSzYdDcxcShCJJhGvCkoYTeLvUJecPCvxHyQKQOKIX
         TWjNVPtUZ+EQ6+F0NMbzRmpRSZrmxLG6LdkQ8qzygGGpUeBPUd9gqxdhC1XkAFIZRD/y
         TdB2ZHrv1iojpzKDimFEFZGOaS6i4FrqkcupcCvE8Q0gjqmhTrg9KpFDec+D32lv1ISu
         bjXYeuvSissOgfCMN7nZk00TsNJQe5idSmSGtLzvy8NS1N9VuwCWHoill6j7OjpN4M1k
         sZ8WAsMUxPxjxV+PUZc24yk5m3oB0GOnYMsLReWzHesj8IVMOpXh2QbGwu8G1F702SfW
         XpLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793280469; x=1793885269;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3CzqAH4xSsnmGsmzTYz5f2Dn8UH9l1H/VmV5jrqfT88=;
        b=UWtpzGHnJ1L8aoGauX5oDA53Zudsp2B9KgvsGkAl+MbU6yPn9LYtq1Y1N2zVqs64ld
         kEzjSA0AXdjoquRPsAIAJZMCOwJF2O+pKqURJgJLVYhgZHFxdQpIkmB7/VtH0/Ji482g
         Ruu3B3hXIamNXXaQMkkODafbYsNKlRSj1nhj70RWbOeUL+amIvDpr8g4ijkmTkmKGr8K
         oppQb/n+7EQSN4hIAoG10W2dWLv0Evg9yOsw0bB3wVjgO0x8DOUZxBMHWcsE7OwN5OlX
         gjHgINCrAQEauY4PO1THBtatO02FULp3erinq0UiiJLy4JAdO0vO2UqUxnU7MTC2lJGz
         E0CQ==
X-Gm-Message-State: AFq9FYJQm/YgRkxAsLRfYxDiQKyaEj8BOrKNQE+Q6fCEX+TNHYAKe0kM
	tjM1dLAawGPjwTuM6K2DqASfBPBHwU+oidBahJD4WgSfp8Qdkukg0b+0ix2Yjv5NfAkdTrNDous
	Z0gzwTR4U0w==
X-Received: from qknvr8.prod.google.com ([2002:a05:620a:55a8:b0:93a:221b:f869])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:620a:8393:b0:93a:11a4:223c
 with SMTP id af79cd13be357-944089385damr723777885a.9.1793280469130; Thu, 29
 Oct 2026 06:27:49 -0700 (PDT)
Date: Thu, 29 Oct 2026 13:27:40 +0000
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
Message-ID: <20261029132740.1169950-1-jmoroni@google.com>
Subject: [PATCH rdma-next 1/3] RDMA/mlx4: Fix stale umem and MTT state after
 rereg_mr failures
From: Jacob Moroni <jmoroni@google.com>
To: yishaih@nvidia.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

During rereg_mr, the umem is released in various failure cases
but mmr->umem was left pointing to a freed umem, so it could end
up getting double-freed when the MR is finally deregistered, or
cause a UAF in ib_umem_check_rereg() if another rereg_mr attempt
is made.

Fix this by setting mmr->umem to NULL after ib_umem_release().

Additionally, when mlx4_mr_rereg_mem_write() fails, mtt.order is
left set but with an invalid offset, so during dereg,
mlx4_mtt_cleanup() ends up freeing an MTT range that was never
allocated. Fix this by resetting mtt.order to -1 in that path.

Fixes: 9376932d0c26 ("IB/mlx4_ib: Add support for user MR re-registration")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
---
 drivers/infiniband/hw/mlx4/mr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index a6b4abce1bfe..e7f524c28f1e 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -268,6 +268,8 @@ struct ib_mr *mlx4_ib_rereg_user_mr(struct ib_mr *mr, int flags, u64 start,
 					      *pmpt_entry);
 		if (err) {
 			ib_umem_release(mmr->umem);
+			mmr->mmr.mtt.order = -1;
+			mmr->umem = NULL;
 			goto release_mpt_entry;
 		}
 		mmr->mmr.iova       = virt_addr;
@@ -277,6 +279,7 @@ struct ib_mr *mlx4_ib_rereg_user_mr(struct ib_mr *mr, int flags, u64 start,
 		if (err) {
 			mlx4_mr_rereg_mem_cleanup(dev->dev, &mmr->mmr);
 			ib_umem_release(mmr->umem);
+			mmr->umem = NULL;
 			goto release_mpt_entry;
 		}
 	}
-- 
2.56.0.313.g2479322e68-goog

