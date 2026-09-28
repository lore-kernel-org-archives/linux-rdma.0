Received: from mail-pj2-f40.google.com (mail-pj2-f40.google.com [74.125.227.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9824E0202
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 15:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.168
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790610839; cv=none; b=a5GOWa4jvsfsLVVN+y6ZgD73QObmfRNIZHJaR0K510cXNCKIR5Yn9O2IQU3vwORbfStBeOaUJ/r92B0kdMckzYz7pwb5eULCZlRHE3BJlVnU+NH4nc3yo2FKxZtHJGm4TKjX0H1CbgC49KTFSJseQaPjod9pOeC1w9rB+I9TWCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790610839; c=relaxed/simple;
	bh=4gppzRtfi+OooFdc4Jlje8h5Xg6dJP0tobF5btgOxgs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UnakYCcHwauL0KWQ70l2neiLayfQWfqUwY+AyP2DVfFqHq1QAeDtDZALMAiXyvmvuQgXgfC9CI31GmZhP4ZyI8lf/4ZsTPCM+rYPq3yRQacsLJIVD9c1ivKG7qdPV4vA5JdDrBpNU8DxgytOc56qFTR0lUyyscixmTpE5TzhPqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HrnaA7T7; arc=none smtp.client-ip=74.125.227.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HrnaA7T7"
Received: by mail-pj2-f40.google.com with SMTP id 98e67ed59e1d1-3a2adb9bc3cso812708a91.2
        for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 08:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790610837; x=1791215637; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zP4g8lXekauiwqdnSJjEc30nFtkgnAZ2P40l4bqb96k=;
        b=HrnaA7T7E+8CbuFAv1zuCqrgD7WstNAUn8a7HYU8Yytc29T74j0MW20pUEJzscF/KG
         Onz/Nlsyn0R3MdKdNOC8UfhHJ1dIpkbOtM00YpFYryJ037K/W4oJMlw6PAQpIoQwWled
         ptbmIF19hGDYS35oF824tJBEvO/yLG/GzhksTot40y0/cLJSMhkpLtfd64UdA+vi7wu7
         Xo3wx68Uw9BrvsgPnt6YTJCMcmiUzFDjK32XMENeCJuKzao3gRNPm7Iug8glqZb8EmeQ
         92HXaJLkjp/0Xc9pjuG/ADZnIi1HvCZA85oT4n7Pdu9/pLokqh0zpABL8fpA7YDYB144
         ceUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790610837; x=1791215637;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zP4g8lXekauiwqdnSJjEc30nFtkgnAZ2P40l4bqb96k=;
        b=TBefTyqw1SpFSXphWWIxZB8s9iumA2mgHfKKpBz3v5U/Iaa5D6ppIU48BpPRoDYTae
         uzO/8HjbA3dk4HenUFpMX4ZKrL1c6IsbLdiNdy/aLQbw9BNerVhvZYNkw6g80tEtskFn
         aYwKgG2+q6gobkHsi9ECksXZtI0bKJVH3aYZwDAAbD59t0CqyrcMbVyARPUAzwEQAb/G
         BX+v84Kj0M7or14lc/YsutYua3kzdK7h7WNXsR3pp9X587oA5XTYlWTFhKUE8NR6/3CV
         UHa2UgVf+XBfM+g/ubztzm61R+ka/VGwkCJoIvdrgpmftQgAN40ICK9OfOvh8okTRytL
         3xOw==
X-Forwarded-Encrypted: i=1; AKwUvByvcnVLwwCxwfNd3Q0AtcORrBaJDLP0wBCcGSSLA8giJGHgCYIa4rPqwOLs+bY617SX9hdmY6Sn0RT+@vger.kernel.org
X-Gm-Message-State: AFq9FYJdxFEbEZZE8WZW3qzKzr3rNpllvywShRloEFPnJuX9Ga+vJQDq
	+8sqcp4U2toQZ422mnlt9ohgvJIidH5mZu5T25hFaIDagzd7l7vW78nO
X-Gm-Gg: AYBFou25tePh36HTUvLwaeYelOIuBtMVRevKtuv0eu6bZeOD5uYjyJxgRH6P6M7sEea
	DxxxajA7XzqXBQawl9lq82T7Du/tdMPC4baenMXz127wRepDs0ZOTJmpN/CEC1ak6n19VhWCMyP
	XfRdhrgQZdxjVyuNa9JEUp/5b+0ZeDREBSJd4Pt3aq/qi5ixd1AmEii9rXNC3En++wegjywQ3T+
	rHuOl88fEKDzijSihzO2xo4Sqs5AT+aoDZgzszQ5MpAFYngedZO3K68D/tQ3463luuNu4s2lupg
	Uh6EkDAN/l8TOLAcdcBpMcsEYQHwtiFwHKk7GtuBq4sJDN26A1EPyaphD0vxAdxeGWNGGtCVwS2
	TWq6vqQw2XnpFENOJBC1PCuw4ZAeinqlH6itbx+bqdMR5e6R04VbEJOssP+xN9+NjFFVOy+6Zcp
	H/Tmy4Vu2pm5Sc+azWZqIwHSmQRb28XbgKgKNn8TA6YZ5G2f0j8l7oeBgfjxVMqKlHQjMFnW969
	6DFf2SeJrquFEe0TKBzoSCs2DF1Mrpb7/Q=
X-Received: by 2002:a17:90a:e7cf:b0:3a0:e243:28fd with SMTP id 98e67ed59e1d1-3a0e243355cmr3530151a91.36.1790610837089;
        Mon, 28 Sep 2026 08:53:57 -0700 (PDT)
Received: from localhost.localdomain ([43.224.245.233])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4986a1905sm44269a91.13.2026.09.28.08.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 08:53:56 -0700 (PDT)
From: Dongliang Qin <cccccccccccc777777@gmail.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: Dongliang Qin <cccccccccccc777777@gmail.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bob Pearson <rpearsonhpe@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 0/4] RDMA/rxe: Fix MW/MR lifetime races
Date: Mon, 28 Sep 2026 23:53:47 +0800
Message-ID: <20260928155351.3222978-1-cccccccccccc777777@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Soft-RoCE keeps MW-to-MR bindings and type-2 MW-to-QP references across
verbs operations and responder packets. Several paths currently assume
those references remain stable without taking the MW lock or reserving
the MR state. As a result, the responder can acquire a zero reference,
a bind can race with MR invalidation or deregistration, a type-2 MW can
outlive its QP, or the pool can force-free an object with outstanding
references. An unprivileged user with access to an RXe device can use these
races to corrupt kernel memory and escalate privileges.

This series fixes those races with four focused, individually
revertible changes:

1. Move MW lookup, validation, and MR reference acquisition under
   mw->lock.
2. Use num_mw as an atomic state reservation while an MR changes state.
3. Invalidate type-2 MWs bound to a QP before destroying that QP.
4. Stop force-freeing sleepable pool objects after a timeout.

Patch 4 is hardening: it prevents pool cleanup from turning an outstanding
reference into a use-after-free, rather than fixing the reported bind and
deregistration race directly.

Before the fix, a concurrent MW bind and MR deregistration reproducer made
KASAN report a slab use-after-free in rxe_mr_copy() from rxe_receiver() on
the RXe responder workqueue. With this series, the same 120-second test no
longer triggers KASAN. MW READ, WRITE, partial READ, invalidate, and rebind
still pass.

Dongliang Qin (4):
  RDMA/rxe: Take MR reference under MW lock
  RDMA/rxe: Reserve MR state during MW binding
  RDMA/rxe: Invalidate MWs on QP destroy
  RDMA/rxe: Do not force cleanup on pool timeout

 drivers/infiniband/sw/rxe/rxe_loc.h   |  8 ++-
 drivers/infiniband/sw/rxe/rxe_mr.c    | 70 +++++++++++++++++--
 drivers/infiniband/sw/rxe/rxe_mw.c    | 99 +++++++++++++++++++--------
 drivers/infiniband/sw/rxe/rxe_pool.c  | 14 +---
 drivers/infiniband/sw/rxe/rxe_resp.c  | 38 +---------
 drivers/infiniband/sw/rxe/rxe_verbs.c | 15 +++-
 6 files changed, 159 insertions(+), 85 deletions(-)

base-commit: 93f51579e7df2
-- 
2.43.0
