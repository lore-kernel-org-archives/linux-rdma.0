Received: from cvsmtppost33.nm.naver.com (cvsmtppost33.nm.naver.com [114.111.35.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B318E19B3CB
	for <linux-rdma@vger.kernel.org>; Tue,  6 Oct 2026 09:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.111.35.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791277877; cv=none; b=UGXmOpjtjJu9PUu50SK25r5dR3iI0Iy61u/hxXNfFDlpq3L4DF9RKn+HiGWbKXLvjHSbcFWhgpmIrC3X8iuClH1RAG6gUvWC3t1ZrOxYoEItcc2ACXzOV8g80dNy4MX+jXn9uMUzhr7CxJefFl06F92kAEvdQEj/k8uOJGyW0cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791277877; c=relaxed/simple;
	bh=vSNHTD+dPCv2xEtQ52r2jcGC3tPg7oclUecwXiN2h0I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=d10Ugc350T0KwpURd4WVXzpjxCg/wZL/QctigJqOslaBYOJsK4x3VrliAuMd5IOLhYWzaiMRoMTd+/AQQFD8MGoD1IxIsqSyfoO7BUFqeDNkHn7HazySciCJSxnUdSxPMYQs0/LXc3cApVgbL54swnQM3wmJNOYQP/5Uyn0V29o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com; spf=pass smtp.mailfrom=naver.com; dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b=URdv7Jlo; arc=none smtp.client-ip=114.111.35.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=naver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b="URdv7Jlo"
Received: from cvsendbo022.nm ([10.112.20.47])
  by cvsmtppost33.nm.naver.com with ESMTP id j3VU70BFTHycEkzP72Yydg
  for <linux-rdma@vger.kernel.org>;
  Tue, 06 Oct 2026 09:11:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=naver.com; s=s20171208;
	t=1791277873; bh=vSNHTD+dPCv2xEtQ52r2jcGC3tPg7oclUecwXiN2h0I=;
	h=From:To:Subject:Date:Message-ID:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=URdv7JloOPNt2oadQ/LZtIGB0SfvrFOjEJyy+Ol5cFSm7dO/MO5bqp4Igt3eUh53e
	 S6lUiO9EsxRFGkeNpgfaFtAQ2SCCFUZNurAd3GiBwVagNZHYlXja69YqDbB1rxSF7f
	 nldhriPYIXI/RDjst0L9wlfifP6FqUbtZ/+6wlRXPzOz3ne7bqT3DvFL9F3rpNzmO+
	 5Bbr9ppJIiz0/P8jZ4ImB7wwpVjKsxr6NcLaKtxzG/Ghu39GutHwRqktk7GFPpGU4r
	 3PvZkO2h5tV7nL6St2WyZQlS7indxsyyaIn36QWSc+TJLWA32ffL3WRSQalZYOZNJO
	 ilu2t8XWt/qwg==
X-Session-ID: t2sidC+JSpuZ+jfPGS3U9w
X-Works-Send-Opt: OPRwpzGdjHmdKHFOMr39Ko3YKHmrjAudFqM9KqMqFxIYkEljxBmwjAg=
X-Works-Smtp-Source: /qndKoulFqJZ+HmZFqt9+6E=
Received: from localhost.localdomain ([115.136.205.4])
  by cvnsmtp002.nm.naver.com with ESMTP id t2sidC+JSpuZ+jfPGS3U9w
  for <multiple recipients>
  (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
  Tue, 06 Oct 2026 09:11:12 -0000
From: sungbyeongchan <tjdqudcks0424@naver.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: [BUG] RDMA/rxe: MW rkey authorizes accesses outside the bound range
Date: Tue,  6 Oct 2026 18:11:03 +0900
Message-ID: <20261006091105.827719-1-tjdqudcks0424@naver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

I found a memory-window range authorization bug in the RXE responder.

A peer with a valid type-2 MW rkey can issue RDMA READ or WRITE outside
the interval authorized by the MW bind, provided the request remains
inside the wider backing MR.  rxe_lookup_mw() validates the key, PD, QP,
access rights, state, and nonzero length, but check_rkey() checks the
request address only against the backing MR.  It never checks the full
request extent against mw->addr and mw->length.

I reproduced this twice on commit
ff47652a4b66c067c765a7ad464d930b5a9367cc.  A 64-byte type-2 MW at
offset 1024 in a 4096-byte MR allowed a valid connected peer to read an
eight-byte sentinel at offset 2048 and replace it with peer-selected
bytes.  In-window READ and WRITE succeeded, while a request crossing the
backing-MR end was rejected.

The demonstrated impact is disclosure and modification of registered
userspace memory outside the delegated MW.  I did not demonstrate kernel
memory access, a kernel crash, code execution, or privilege escalation.

The affected path is:

  rxe_responder()
    -> check_rkey()
      -> rxe_lookup_mw()
      -> mr_check_range() against only the backing MR

I tested an overflow-safe MW interval check immediately after MW lookup.
With that change, outside-window READ and WRITE return a remote-access
error, while valid in-window operations continue to work.  Fixed A/B
testing passed with the same kernel configuration.

I performed a best-effort public duplicate search through 2026-10-06.
The public RXE MW/MR lifetime-race series addresses reference and object
lifetime races, not this missing MW range check; I found no exact public
report of this range bypass.

This report was prepared with AI assistance and is being treated as
public under Documentation/process/security-bugs.rst.  A tested source
reproducer, logs, configuration, and proposed patch are available to the
maintainers on request; the reproducer is intentionally not attached to
this public report.

Assisted-by: LLM

Regards,
sungbyeongchan

