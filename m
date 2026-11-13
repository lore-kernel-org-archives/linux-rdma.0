Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794559223;
	b=ldsYhnJ1CN5O8wRdGKo9ky4c2CL5HQUslBmUgrWh3q5xVRe3zZEec6kvWpovzheAslwT
	 +b9KhYIjfvyLF4DFCIPeGro+e6CJdt1f3EnIT8fpQCEZBdAx3zURBGAsAd39Wxcb4XHEc
	 JiX+4fvch5XVyueRrZjD/f6VT+So9ONjieVoMuLuZVpYz/dLYw64jAaoeT94d7gm7TupO
	 ABTa+CGyhgKEp648b1eUh1Jilw3Mgty0hE9O1l/ewCFGk9xkSJwDB+qRepUpXEyIPzUGM
	 PHJvRcpKY/PSXUEIlbinyRXqYqB6+Db7OnMLRO1po7oNvlS2ze5OzpLHApsmsZR40qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794559223;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lQZj+I5onjkuCEafsJ6iaagMsGU3FXN3YvHwXS5E/ks=;
	b=fkG3FEj8QOlzLSPJkD5Jp6KWz+mScOWSo6iqOKPImAlrKWD4AXi7SlAuhPDDB7axtcXb
	 uQxz0fc3YQ+swS+N1wgWRpFAhRf0d4Y8/OqL2U73naULt6URUvCBtTXpsaQGRfnr49OyD
	 kJKf4SrB+1MsV2F1GwruG2lYeH7oM74IR2/XOgzSJiKPX+WKJD0hqWzyHTdBGcBwbm2rO
	 dJOIAPtRs3YQRY0VAlAolZ0oSCntgRPKYNWnHGFX89UCWq0i5IAfZv7lAYJ+rX6jlCxGN
	 pQyvHNi1/K/tf4n1naQFSRUePLZh+a1BeinpTcNsPCylR2xgjoLK8fbeKadpxeNde9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vMPn8R5V;
	arc=none smtp.remote-ip=209.85.216.42
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8985E606A330
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 08:40:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8985E606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vMPn8R5V
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3ac9f49b984so362985a91.1
        for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 00:40:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794559222; x=1795164022; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lQZj+I5onjkuCEafsJ6iaagMsGU3FXN3YvHwXS5E/ks=;
        b=vMPn8R5VMR9iI0ko8VJph2JIkdkn5kHcbotl71V6RBCRzZ4xd+JdtnHZcwclEOOlY/
         ihl0rygCUBMSiarvtTlBqqMxkfY9u2CClFgwurx1TK6eKare1vnVRAbexXkzeYIh46SV
         QBmJ1zWroreUI5Fzah7tNXOGTJ49iiIe/KtjQF0YlrplHBFRmwCcAIMZfL8vJRjiQ+ca
         7H9i3Hf4bT5R4NybB0h2twif9li5VoE42xYo2GJwYc24FbcbQw2OB4p3uTSZnbb3qqaI
         aMPWa6E4FT+mG8x74fpTtNJmAz8QYIfmmsQxJcv2IQ2XJk4eU+1//UWlcQlI0bDVtwUa
         yIvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794559222; x=1795164022;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lQZj+I5onjkuCEafsJ6iaagMsGU3FXN3YvHwXS5E/ks=;
        b=W5e8RDHze39n7TCzkJSKXVJKeqErpMSw8RsghGI2hSzyzyFn9Q3ibPRZmyLWnUxccD
         0CsQOSyrTpM3kDFAkBdj1tMBNVnmgL+oZ7EF/vPRiivcJ68uGSJycv1dToJfeQwugnla
         cxPp6QB0WL1jugPzVcRtotQOcc9hGtwqqvk/tBW5wvvqhiV2/T91orcboonrHuSlFfXr
         jZBrTvvzoYaRDr0vTxBp0pKdUeBIt96wJfvNvfBt5o9Fe0/rHabwembjEApVWAbNgs4b
         SLLPXTXMVryIqhbkYQLLnfZoiEHvldP1qiKC+p0+AUh77mYl8nNXifO5i7kXYZp1lu5D
         wdFQ==
X-Forwarded-Encrypted: i=1; AL+hErEelgJx54+c977d/faa1eYvDWSPOqE44lgfl6AG1kvptIQgadzBYi+suUooYjVQFwoLHjwYkWvtL4C4@vger.kernel.org
X-Gm-Message-State: APuU4Z/1cpSBIxmmUPxQLrus1PG1XL4U6BSBTEcELeTxRn+ZhpTgaiaF
	deL0u6JGYQLQzgvXSgAZLjKywloxHyuzeyTuf1Ng1N2kFJjVfsceVDGG
X-Gm-Gg: AYBFou0xAKSHC7fKZ/IxK3UXqJEnibAUvSg5pAB8bnNYkb2l1Nl2PFJ2Nb2X1hGUvvn
	Gr+diT5uRT7AKOOEuAVJ1gCXr9hvabeZ0ZuBO75pVeAYlXOB2rO0Mw/xcTrR8xAqd9k4SW66MOa
	Cg6tf7aUH/U3bQhSz6ODx4gXEjkJ8b7N+BovdiTg3FicyR74mTX6yPcMqWx3MFzUKbl1I5f5Op4
	B4EpOGLPOT/d0uXacNqrr9v0KsvtdThZmQeBA02yITUNmavnHe6vYiXdNk3z/P3ckK0KphlP1sX
	2FS5Y6z0Sf5nQBVj0Ps1WZ7TgRqO3mqIUztn669tGjR0oRFUeZ9g6dUCR7dRLAPnWePmhJ8R7TS
	a/cSrCa6cxj8CjtRBzcaJt0OO+7tYnOKLxnWKVOt1s1/CjGiC4tTcxcZfu0y4BbyHLihJAvKAA9
	Tp2zUeKcPAyJVvPhj6es95v1tHBoDkxA0FyBN+K1X6ALGTOeTS8tfy8Ps5KUmBrPfuzwnH3PDnW
	mWhSJIWy7rEOguP7V1qzdpOPODLzZBM3d+DhNyqp9Ax2wYyN6R2+tmLH+QzoZ4Ad3hE22mWbhWA
	F6dLnCMHVtsPlisbMzfSSBpHbuy4PObY3IxcgsOwbP85l4rFgbCzBihH1ubKvDY=
X-Received: by 2002:a17:90b:4f41:b0:3b0:a1c6:95ae with SMTP id 98e67ed59e1d1-3b1b0ccfbfcmr894078a91.31.1794559221886;
        Fri, 13 Nov 2026 00:40:21 -0800 (PST)
Received: from localhost.localdomain ([183.62.176.219])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b25a365asm1264855a91.1.2026.11.13.00.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 00:40:21 -0800 (PST)
From: Yong Liu <pkfxxxing@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: [PATCH v5 0/3] RDMA/srpt: Fix command initialization and read buffer disclosure
Date: Fri, 13 Nov 2026 16:38:39 +0800
Message-ID: <20261113083848.1517595-1-pkfxxxing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <92a82300-a454-4ee5-a191-0ce5a2ee58c7@acm.org>
References: <20261110030809.913063-1-pkfxxxing@gmail.com> <20261110030809.913063-2-pkfxxxing@gmail.com> <20261110052827.963143-1-pkfxxxing@gmail.com> <20261111065342.1282709-1-pkfxxxing@gmail.com> <20261112094138.1390409-1-pkfxxxing@gmail.com> <92a82300-a454-4ee5-a191-0ce5a2ee58c7@acm.org>
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

Hi Bart,

Thanks for the review and suggestions. This revision separates the BUSY
initialization fix and the target core control-read buffer fix from the
SRPT descriptor validation and read-tail clearing fix. Together they
address the NULL pointer dereference on descriptor parsing errors and
uninitialized target kernel memory disclosure to an initiator.

Changes in v5:
- Move BUSY command initialization into patch 1 and explain why the
  target_init_cmd() return value is ignored.
- Clear all control-read SG entries in target core in patch 2.
- In patch 3, log inconsistent descriptor lengths and zero the read tail
  with one sg_zero_buffer() call through the command's chained SG list.
  Remove the SRPT-specific DMA synchronization.

> Do the SRP tests from https://github.com/linux-blktests/blktests still
> pass?

I ran the following against this v5 series in an x86-64 QEMU VM using RXE,
with blktests commit 79c32fb31b7bca6a4383b749030128683cf6b6b4:

    USE_RXE=1 ./check srp

Results: 13 passed, 2 skipped, 0 failed. Tests srp/003 and srp/004 require
legacy single-queue device mapper support, which is absent from this
kernel. The multiqueue test, srp/002, passed. The kernel and modules also
build successfully.

This series is based on commit:
f66469d9905b39d2c260a15d7d6db450f4db67c1

Regards,
Yong Liu
360 Vulnerability Research Institute

Yong Liu (3):
  RDMA/srpt: Initialize commands before returning BUSY
  scsi: target: Clear all control read scatterlist entries
  RDMA/srpt: Prevent uninitialized read buffer disclosure

 drivers/infiniband/ulp/srpt/ib_srpt.c  | 24 ++++++++++++++++++++++++
 drivers/infiniband/ulp/srpt/ib_srpt.h  |  2 ++
 drivers/target/target_core_transport.c | 19 ++++++-------------
 3 files changed, 32 insertions(+), 13 deletions(-)

-- 
2.43.0

