Received: from cvsmtppost17.nm.naver.com (cvsmtppost17.nm.naver.com [114.111.35.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DF33B27E8
	for <linux-rdma@vger.kernel.org>; Tue,  6 Oct 2026 09:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.111.35.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791278580; cv=none; b=jBY3QVWCLlgx10IyhP8kBpJt6E7fyJKZZXe4H8RL8MO4sJYg5lHdDFCyCbz18M1/tBzt75C4DoEZntUfr6vCVnkA9M8QAPv+dhDlNZfVVMQK17oN4zyPBbEUggOIOqq16GYmxYi2ZrCk5faKEuELvWiii5Tv+F5kI7JpR9Pa33M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791278580; c=relaxed/simple;
	bh=u70vmCFNRRCUyEOMZps5Ceo9Y7+ojjZxIOYXADUr1eE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l4d0YiNMCT+R5v9+AuYXMAhYhyofDOZ8nyiLVaBF+Q5Ob8zImt55IkEPJMTYdnfZH1pSV1TRydGL9ce7DjWAGt1qRE85pDUqfhAPqLNK2GnJ646tFXVQZQNsV3Ewz73O/k6YbQoCFqXj6wa3tgNVvuIKCLJXcwxrdnouYLFk60w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com; spf=pass smtp.mailfrom=naver.com; dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b=E9bXdJfd; arc=none smtp.client-ip=114.111.35.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=naver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b="E9bXdJfd"
Received: from cvsendbo019.nm ([10.112.22.34])
  by cvsmtppost17.nm.naver.com with ESMTP id iaYGBBOtS-O3jg-0yL17fQ
  for <linux-rdma@vger.kernel.org>;
  Tue, 06 Oct 2026 09:12:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=naver.com; s=s20171208;
	t=1791277966; bh=u70vmCFNRRCUyEOMZps5Ceo9Y7+ojjZxIOYXADUr1eE=;
	h=From:To:Subject:Date:Message-ID:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=E9bXdJfd2ZK0h1gLsOEyzn8y4TNHqQ5PT7298FAml7pWm3QXmn6kAVt8piOffvfya
	 tjmlE3goyXcRDb6Om2uH3RH91mcnvCYAGIzvtOv6h/y5Lxg4P+oo09onr4L/+ttpfd
	 hwdDsQ2UlNnrUXewFd3w/RBZnb2hxr/J1C0BxpJmnuf5tyCO3q6wl+XyPpPMsJAx7c
	 brMrJY20DXrybfWyUHEUasKGV+fDbG5XtDYyCxRDwgr1tEIP/P3x+rS7x6VbZ/lEem
	 iRj3UqYVz+eRr4ubNMmumypwyq8LUkf2zDG1SI12Npp7lX01UW133rpS9I2T62D+Dz
	 BrisiPS3nNoVQ==
X-Session-ID: XYgqS7LURMK24ZUS3I5ETw
X-Works-Send-Opt: OPRwpzGdjHmdKHFOMr39Ko3YKHmrjAudFqM9KqMqFxIYkEljxBmwjAg=
X-Works-Smtp-Source: /dndKoulFqJZ+HmrFoE9+6E=
Received: from localhost.localdomain ([115.136.205.4])
  by cvnsmtp010.nm.naver.com with ESMTP id XYgqS7LURMK24ZUS3I5ETw
  for <multiple recipients>
  (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
  Tue, 06 Oct 2026 09:12:46 -0000
From: sungbyeongchan <tjdqudcks0424@naver.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: [BUG] RDMA/rxe: unchecked receive WQE cursor causes OOB access
Date: Tue,  6 Oct 2026 18:12:38 +0900
Message-ID: <20261006091239.828415-1-tjdqudcks0424@naver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

I found a receive-WQE validation gap in RXE after the WQE is copied from
a userspace-mapped receive queue.

rxe_get_recv_wqe() bounds dma.num_sge and uses it to size the private
snapshot, but it does not validate dma.cur_sge.  For a nonempty receive,
copy_data() later uses cur_sge to select SGE metadata without proving
that the cursor is below num_sge.  The equivalent omission also exists
in get_srq_wqe().

I reproduced this twice on commit
ff47652a4b66c067c765a7ad464d930b5a9367cc.  An unprivileged uid 65534
RXE queue owner published num_sge=1, resid=8, and
cur_sge=UINT32_MAX.  An ordinary inline SEND from a connected peer then
caused the same OOB metadata access and fatal kernel fault in copy_data()
in both runs.  Changing only cur_sge to zero delivered the expected
eight-byte payload without a sanitizer report or oops.

The demonstrated impact is an unprivileged kernel denial of service.
I did not demonstrate a valid bogus lkey/address, controlled kernel
write, information disclosure, code execution, or privilege escalation.

I tested validating num_sge and cur_sge on the immutable receive-WQE
snapshot in both the per-QP and SRQ paths.  The malformed WQE was
rejected and the normal receive still completed.  Fixed A/B validation
passed.

This is related to the earlier RXE receive-WQE TOCTOU work associated
with CVE-2026-74377, but appears to be a residual invariant: copying the
WQE prevents subsequent mutation while leaving the copied cur_sge value
unchecked.  I found no exact public patch for this residual check in a
best-effort search through 2026-10-06.

This report was prepared with AI assistance and is being treated as
public under Documentation/process/security-bugs.rst.  A tested source
reproducer, logs, configuration, and proposed patch are available to the
maintainers on request; the reproducer is intentionally not attached to
this public report.

Assisted-by: LLM

Regards,
sungbyeongchan

