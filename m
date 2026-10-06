Received: from cvsmtppost01.nm.naver.com (cvsmtppost01.nm.naver.com [114.111.35.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46278380FFD
	for <linux-rdma@vger.kernel.org>; Tue,  6 Oct 2026 09:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.111.35.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791278011; cv=none; b=Vxo4scsvoJ/lvkS7V83Col4WzslmHLA3zDlD5w1l7ANoQtWRkRMY/5ClJSQyxfucdOuyh8TAtt4C4WZbpPGxDSqmSayRJGXOEVx2eH5JRGgJqerQsfAaNWOQymfYc/En89k1igTWrqZQe7IPAoSkbBFFod4DWJ7uikkjkXkTxh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791278011; c=relaxed/simple;
	bh=PU+ZyxuYGXyzQQNWTPOUliq2v/lmX2k2uQkzVxaUQVA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dH7FQvnTivRLsk5OokZ5EDEWojiOrfjqlRAptibJ0F/PHzRNzL+TP9X1WTznJNbq/yAtqCzHHcCVrKTPQAxYXCARUgdBGMzuq05f8lewQ42IU3ffUbPYGi1c0Watm9+Yg9tI34dbFTMuvfsifnu5aqQPifbwFQgphhp+7sXVVCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com; spf=pass smtp.mailfrom=naver.com; dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b=jeie+f21; arc=none smtp.client-ip=114.111.35.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=naver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b="jeie+f21"
Received: from cvsendbo013.nm ([10.112.18.56])
  by cvsmtppost01.nm.naver.com with ESMTP id Gr0i7Lr3TQK2uIGlW08D3g
  for <linux-rdma@vger.kernel.org>;
  Tue, 06 Oct 2026 09:13:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=naver.com; s=s20171208;
	t=1791278000; bh=PU+ZyxuYGXyzQQNWTPOUliq2v/lmX2k2uQkzVxaUQVA=;
	h=From:To:Subject:Date:Message-ID:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=jeie+f21WytJUuPhQHhHo35vGz7zXOmmShbYnexPWUdzUgA3Dw2Wf/AwSpd5E5pPa
	 fTGkuPkVmx9whzZ66q+LiYxv2U1qHxFT8Rw0UWBPe64JtyDM+G3b8MNNTgLlPbUgtd
	 vnaI6ykLf0wA/wfbHYjKfhLIXRF45Vgsx625UhdjMEc8wMyXelqVovdcsGNV4vzA10
	 GYcWtrED8egIpxPwIXOx7KQpaa5HGif7BcwoxvylNdNZG1jPCz8B8QBUTJR5R4U597
	 YK/4WtE5eZbjezTseai6QDfcxJQzG1774VrYNmLiClGK5LF89HZQWfvH/cTeg5xgit
	 NDDoCnzwpwfVA==
X-Session-ID: 7RqxH39cQJ+zi7Pz4xzw6g
X-Works-Send-Opt: OPRwpzGdjHmdKHFOMr39Ko3YKHmrjAudFqM9KqMqFxIYkEljxBmwjAg=
X-Works-Smtp-Source: /wYdKoulFqJZ+HmmKAM9+6E=
Received: from localhost.localdomain ([115.136.205.4])
  by cvnsmtp007.nm.naver.com with ESMTP id 7RqxH39cQJ+zi7Pz4xzw6g
  for <multiple recipients>
  (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
  Tue, 06 Oct 2026 09:13:20 -0000
From: sungbyeongchan <tjdqudcks0424@naver.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: [BUG] RDMA/rxe: user QP can submit kernel-only REG_MR opcode
Date: Tue,  6 Oct 2026 18:13:08 +0900
Message-ID: <20261006091312.828662-1-tjdqudcks0424@naver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

I found a raw kernel-pointer dereference reachable from an RXE user
send queue.

RXE user QPs expose their send queues through mmap.  A userspace client
can publish opcode IB_WR_REG_MR even though that opcode and its struct
ib_mr pointer are kernel-only.  The RXE opcode table enables the local
operation on RC QPs, and rxe_do_local_ops() passes the shared WQE to
rxe_reg_fast_mr().  The latter interprets reserved userspace union bytes
as a struct ib_mr pointer without a handle lookup or acquired reference.

I reproduced this twice on commit
ff47652a4b66c067c765a7ad464d930b5a9367cc.  An unprivileged uid/gid
65534 client published IB_WR_REG_MR with zero pointer bytes in its mapped
SQ.  Both runs produced a fatal fault in rxe_reg_fast_mr() and a kernel
panic.  A control using IB_WR_LOCAL_INV traversed the same local-operation
dispatcher without a sanitizer report or oops.

The demonstrated impact is a deterministic unprivileged denial of
service through a raw-pointer type confusion.  Although the source has
conditional MR field writes after several checks, I did not reach those
writes and do not claim arbitrary write, information disclosure, code
execution, or privilege escalation.

I tested rejecting IB_WR_REG_MR on user QPs before rxe_reg_fast_mr() is
called.  Kernel QPs retain the existing path.  The malicious case and
normal control were both clean after the change, and fixed A/B testing
passed.

I performed a best-effort public duplicate search through 2026-10-06
and found no exact public report for submission of kernel-only REG_MR
through an RXE user-mapped SQ.

This report was prepared with AI assistance and is being treated as
public under Documentation/process/security-bugs.rst.  A tested source
reproducer, logs, configuration, and proposed patch are available to the
maintainers on request; the reproducer is intentionally not attached to
this public report.

Assisted-by: LLM

Regards,
sungbyeongchan

