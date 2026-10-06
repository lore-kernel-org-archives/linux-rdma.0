Received: from cvsmtppost12.nm.naver.com (cvsmtppost12.nm.naver.com [114.111.35.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA7038331F
	for <linux-rdma@vger.kernel.org>; Tue,  6 Oct 2026 09:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.111.35.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791278031; cv=none; b=TWSvkOCOuK3GuZE6eIQwWiwdT7J0P2iEMl3kCiZTnK+H/U472jmS+tkJ3U0/f2XfHAJKazPHbi47LfPxMhxZkU3o/3lpxFrgVSC/F6YdZvSwVcBsv+DKcTyqMd9/XsDJnQq68s38vDCkN7TupUk+olrTqOF/KIDKEu8WU/Sj3Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791278031; c=relaxed/simple;
	bh=gctVEGpOf55hwdl58t+HTQhT5gCOh5kd2dk3y2EwGa8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G46NWZOedjBwLsPRIMKTRodgYQR/px3DLo0ugJwYmWTxcVWRqRBJHeuIwemfDC5nipOYeqcW1QR/HqTWKKlXUGNrKl4ta6UsJVqlYfiU1NFO+v5iA+IOwlKmUfCcDkJQg1L7X2htXiaoOArdbF0Ns4C6u1kseXLD2IN81LPHbns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com; spf=pass smtp.mailfrom=naver.com; dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b=Am7MuhiV; arc=none smtp.client-ip=114.111.35.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=naver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b="Am7MuhiV"
Received: from cvsendbo030.nm ([10.112.20.49])
  by cvsmtppost12.nm.naver.com with ESMTP id oiQZ2+2TSwqpHLzCf0aJSQ
  for <linux-rdma@vger.kernel.org>;
  Tue, 06 Oct 2026 09:13:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=naver.com; s=s20171208;
	t=1791278027; bh=gctVEGpOf55hwdl58t+HTQhT5gCOh5kd2dk3y2EwGa8=;
	h=From:To:Subject:Date:Message-ID:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=Am7MuhiVDmMGzqmyySuTsdqfvPJpdPO1Kdk4zSGawI4pTM3buHCN7y3vL/e7sl6or
	 Ce1tkZ+uDBnScURnczgpMr9nOtk9SKoA6GV/KN2xMbBigHc4EfQRndk97R1OZA6Zhx
	 khqc3a7DjByYBzqSLV5Ak/9scCG4EkB7/Aij27cYXOH0VECF+lQ6LSniuEfCuJwRR4
	 AyDvc6AryJ7vw0QOPIoXZuCF8gQZ/NNNpPyyb04SORtBgQMrMmesIuR3yulipHM9Ig
	 JyFWhGJvQHnBnm/L/vF1A6hgoZprovjOxRy1qHsue/FxVAbcYEfGJNvl7dkQ4+c9lV
	 FSAe2sb0NGRAg==
X-Session-ID: IvdhAuDFTiiE0Ff3WRPz+A
X-Works-Send-Opt: OPRwpzGdjHmdKHFOMr39Ko3YKHmrjAudFqM9KqMqFxIYkEljxBmwjAg=
X-Works-Smtp-Source: /dKdKoulFqJZ+HmXKoM9+6E=
Received: from localhost.localdomain ([115.136.205.4])
  by cvnsmtp010.nm.naver.com with ESMTP id IvdhAuDFTiiE0Ff3WRPz+A
  for <multiple recipients>
  (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
  Tue, 06 Oct 2026 09:13:47 -0000
From: sungbyeongchan <tjdqudcks0424@naver.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: [BUG] RDMA/rxe: mapped SQ opcode indexes past opcode table
Date: Tue,  6 Oct 2026 18:13:38 +0900
Message-ID: <20261006091339.828901-1-tjdqudcks0424@naver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

I found an unchecked opcode-table index in the RXE requester path.

An RXE user QP exposes its send queue through mmap.  req_next_wqe()
passes the userspace-controlled WQE opcode to wr_opcode_mask(), which
indexes rxe_wr_opcode_info[] before checking whether the opcode is in
range or implemented.

I reproduced this twice on commit
ff47652a4b66c067c765a7ad464d930b5a9367cc.  An unprivileged uid/gid
65534 client published UINT32_MAX as the opcode and woke the production
requester.  Both KASAN boots reported the same four-byte global
out-of-bounds read.  Changing only the opcode to a normal SEND reached
the same requester without KASAN or an oops.

The demonstrated impact is a kernel memory-safety violation detected by
KASAN.  I did not demonstrate disclosure of the read value, a write
primitive, a reliable crash on a non-instrumented kernel, code execution,
or privilege escalation.

I tested an unsigned upper-bound check before the opcode table lookup.
It rejects negative signed values and values beyond the implemented
table while preserving the normal invalid-WQE path.  The malicious case
and normal SEND control were clean on the fixed kernel, and fixed A/B
testing passed.

I performed a best-effort public duplicate search through 2026-10-06
and found no exact public report for this RXE opcode-table bounds issue.

This report was prepared with AI assistance and is being treated as
public under Documentation/process/security-bugs.rst.  A tested source
reproducer, logs, configuration, and proposed patch are available to the
maintainers on request; the reproducer is intentionally not attached to
this public report.

Assisted-by: LLM

Regards,
sungbyeongchan

