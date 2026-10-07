Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEBF3AFD11
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 21:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791408462; cv=none; b=mNNTTWOuN8+WpRlpwHPVI6TCVPjvoTcb/NBX2cOFdMy0hLrYZhdP/FQ6cbGbv1Jx0npIwfPEomtEqs5Eu9WHQpwxjPQvqJ39avTjMlEpm+Pg3hzteQ3TLhE8lyHPyiatKCFN2GruyMjje6gbOitMPkOeyDRuRodqhFtas1asalE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791408462; c=relaxed/simple;
	bh=a5rLoGhEHqlxmRZ/JOfMOOp0jB6HErznintsx8K7+PE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oOI/RTJvYHJ8sbUS9JJWnS2jal0ZhxeTkkYQFFZY7Pli+zkWNCoE+qyhVCD1q0XSE6v4e1/yc4Gw62zwri8BZjm85xr0sgorcboa3VZ2c7z6wx+aKGFF/4XpuWILPkuHY6pcHc6S7aDNW4FjbxOJTQQaO/YcXIIUMk4l0WHVr4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hmamRnqW; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hmamRnqW"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48b042c0728so763428f8f.1
        for <linux-rdma@vger.kernel.org>; Wed, 07 Oct 2026 14:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791408459; x=1792013259; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Co0U3IIGvGBciCjtD7Ot3o1hC8jdmJVyR340U2yvkE4=;
        b=hmamRnqWbH8+KVCerjdFjFuO6DXdncC0AfbGh5HemT+3VQzMC0ir9nwOpD/0X1SSqp
         y3kEXWZp54HZKNLlzEds/ayMEAResmmftTYAmMMsdYmHV1jJuQ1Z/bf+n1YnTnoPytOU
         85ou+9F4WbGOavKGqPzSX+4thJ77B+uC3gfQhBgjiMqs720r9/woU2+7YQbzyr8uZk/p
         RCBwtvvvnJRjDauEztXJVXzx1+YdDQhTxHVZ0/uqRh9YdZ69Oz8vaIgfrdJLif9u6qyw
         OFSWBLlO0QdLM3KE2gs6ZVRKixRGQXv0i0PvrBs4yD0OjCpZyvRM9aWpipH+EIUHvQ8U
         7+IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791408459; x=1792013259;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Co0U3IIGvGBciCjtD7Ot3o1hC8jdmJVyR340U2yvkE4=;
        b=bbOpuwBlVGjIa7k7wDUjU4bw7qiQG8ocUczeOBrRjRhPHikENgWxEXBtW99B0RUyP5
         2a7Z+b4UqiYdc5J3Abv4DFzmdWuvqiQnW4UMRNQyoFiiTjVG/gYlniypbT7a6cppgN3z
         RsKn/gkXa8hJ4/W2yy5pNTFv0Y7VpYSmfunVocxYSYrY2kxHuSq8qoJMafyIjHx1OdLk
         UgZcPAWtf8WlDdj7kLk3/PimptY2lCsXmba7OwCpa64B2yd4wgPysTqSDdX+FqcwnRV7
         CcJGg2UFXTuIvsxuaxIoaykhIHqQidpOVWwhgEVEGZWtZX2m0tCcNer1UcqFA4LDbACU
         mZnw==
X-Gm-Message-State: AFuF++mWiwp6SQSgIGciFpzDEB8yNIskaz2AbjNi+yiKxa7qoWIYx8c3
	xbI5sl0nGFlUAj5lXhD97yntvgtzpCKZTeuEgxjb5GL4GoH4XWUw5oc=
X-Gm-Gg: AYBFou3kreQIrOQq5Gcgb5CNMYde8R4s48TT2YZlCZqCNwzCDYKUWMs++6UTsfzh9PJ
	ppPyjntEAR36Dy/Ds0sdVw+IRaDIhlZ5AYlCqLPE3jG/xEFYG7M3cwtP+BngQQPC+ZE3pWwcjoc
	nbONXeZSZeB8qJ7W2ky+yyBRG0g3U6h4KEZbMW1Sxg5D7B9PZrZkD4Byjd1ELrZlcFZsSXnCbum
	FKbB9t2aueZycaOnBR02Kto7N31vChzVf7o5YydmV6/pgG7taPm9DXR5cVnYXQ1mpT4OkQnVj+e
	/7ZO/MI39WJcoJkh39+jcWigB3XVYAzlvoq7NKc1qSuw7LR/r9fNI0CnZRNVIZ1QgV66RYz2Y/R
	jqiCaOS1hfvE0UtiBgJKZ4ig6NiVbBT5aaQfxeudrJJZS8R48Rog6/GreITp4KufJEkfDepIIt4
	A5ZDf0UVjZFcvdxjkr8fL8SD13FU4+7JBA2igIKUc=
X-Received: by 2002:a05:600c:540f:b0:49e:6249:268b with SMTP id 5b1f17b1804b1-4a180648fe6mr64635805e9.32.1791408458681;
        Wed, 07 Oct 2026 14:27:38 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1843cb261sm20466395e9.3.2026.10.07.14.27.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 14:27:38 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Moni Shoua <monis@mellanox.com>,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH v3 0/2] RDMA/rxe: Fix TOCTOU races on mmap'd send queue
Date: Wed,  7 Oct 2026 21:27:35 +0000
Message-ID: <20261007212737.1989004-1-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tristan Madani <tristan@talencesecurity.com>

The rxe driver maps the send queue into userspace via mmap. Both the
requester and completer process Work Queue Entries (WQEs) directly from
this shared buffer without first copying them to kernel memory. This
allows userspace to modify WQE fields concurrently, causing inconsistent
state in the kernel.

This series fixes both paths:
  - Patch 1/2: requester (rxe_req.c) - copy WQE before processing,
    with WRITE_ONCE per-field writeback
  - Patch 2/2: completer (rxe_comp.c) - same treatment, with reuse
    across multi-packet operations to preserve DMA progress

This is the send-path counterpart to the receive-path fixes:
  - commit 22b8fbded65b8 ("RDMA/rxe: Fix TOCTOU heap overflow in
    get_srq_wqe")
  - commit d6ab440240a04 ("RDMA/rxe: Copy WQE to local buffer in
    non-SRQ receive path")

Changes since v2:
  - Replaced bulk memcpy() writeback with targeted WRITE_ONCE() for
    individual fields and smp_store_release() for state transitions,
    avoiding the tearing risk of bulk memcpy on the shared queue
  - Added smp_load_acquire() in the completer to pair with the
    requester's smp_store_release() for state ordering

Changes since v1:
  - Same as v2 changes (v2 only covered patch 2/2)

Tristan Madani (2):
  RDMA/rxe: copy send WQE to kernel buffer before processing
  RDMA/rxe: copy send WQE to kernel buffer in completer path

 drivers/infiniband/sw/rxe/rxe_comp.c  | 58 +++++++++++++++++++++++++--
 drivers/infiniband/sw/rxe/rxe_req.c   | 61 +++++++++++++++++++++++++----
 drivers/infiniband/sw/rxe/rxe_verbs.h | 12 ++++++
 3 files changed, 119 insertions(+), 12 deletions(-)

-- 
2.39.5
