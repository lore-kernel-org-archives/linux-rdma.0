Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793388760;
	b=a9WVWkEWjTP96B7wgFuOEKP1KPuv4sdE/YqlFENgfH1QAdfl5AV+pqtLXaYhvuK5whK3
	 m4REaJUOmcN7fIVB/J0nE1YRZv9feuMN98nVvA90W0Qp/vRHbqgyRfSzP7+8JBE0cj3h1
	 ozOIAZSHcN/quQmgPHYSjfgL1f6f3a3mg53bMO5FfRCGcIwrpoV93ScbGmp6Nvxyf6Cui
	 g5YbQ82hPe8QKyUD+EHmTUde1JhXRM5ihZRGSuLaqIDsri+rHUZXKMEbsQOgDzOLfjO+K
	 p8fRDGdVBpz4utnTjF09EIQB4FpKWckW8a6jcD9fKH5+6tQpjZXEa4UWkcDYcaXtlVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793388760;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UricF8dhHQUK8+p9bWTkhzvIESEgdx4WPZL4PB3uCxs=;
	b=ItqI7tR+o12BFAIg3F3yJQZjcxgeqmkh/Cp0fksATga74qKRYEg0sMkeVS6McC814Qjh
	 Loqsnxaza657VXtqK5eBRVmiBggqbIledH6zivC2LLVuwotaN04nzALyFXkuK68ocQwDu
	 CbjPznxF8HOwxzR8LFSjpX8wFRynaVxnjbDetyMwMNbaE11qcF+xuwdu2HgmVbUVa9RZ/
	 13Nro+cINZL30pJHPbGAvCv6+PtwNj3G+1hrW63bENYyqAfsVqgXlGp+swVEFTaR3Myuj
	 pKgGp2B/XNyj3QwSwq+2EjL2fMDZQcJpVy0wwT9BYQ4TE9y+FDdDLrpGXzjGEhtStJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Fcnx4+Rr;
	arc=none smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6D9606A31C
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 19:32:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F6D9606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Fcnx4+Rr
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48b042c0728so316887f8f.1
        for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 12:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793388759; x=1793993559; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=UricF8dhHQUK8+p9bWTkhzvIESEgdx4WPZL4PB3uCxs=;
        b=Fcnx4+Rrjm/nDD6WRKlaJ/WARw8uNp8dwMJ8dIK2HrDazIIxcNwGPqJYgQReAIIYZp
         923FMZkGWT45Hw5bE0d3rw0vckjors7BLX52pO+3Td0x4Svb4WybDyyfL5NHykodrDVi
         JvbBN1DstKTvCagQOTCT/doNsjyybEF1DsDxMviyPE1r64cght6GZzG418wE7Ec8dmdb
         nlHm37TVAG0GA/dJCeaikSZbZyFGR+cAG7LZvVQFlMfNSdT797XvhSOgu/TDnM/qLYVd
         mVj2h+9/xRbB8hTYNpl7KHCB9g1lecWiGvIIWU/lIJbGQCMxzgsQv2a3IWkywnhCKDRV
         MZuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793388759; x=1793993559;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UricF8dhHQUK8+p9bWTkhzvIESEgdx4WPZL4PB3uCxs=;
        b=WsDi3faECT/OKan3X7FXOSLGYTwMiuoW4jGX5ZwXzdmb8blik51XnBjAmFuOGTaIgg
         U51VoYp8N6iZ5YbpHKg2Bpzt5XJ0jeZvPY+Xh6dY0CCaxhKwrSrtBVxBN/CQ84tk9aS1
         mMNBXgDkbpfBUqyNIHx9U1IAUhM3qMaSWxoS9No5kh9dAOpYswGy8sSCbfchliO1W+9i
         Fvv/txy6dQCQNOk/ki1GGcOipFARcaI6uEOuSTez0VuqKNQImCdQldgMVpDwMDsm4SZf
         Mq5W9sUTG7jI3g2ulwfHVVyDqL14GO8b3gxO2u3PrLs5ExWiW5VrIimP1ofOOMltsk+T
         jG2A==
X-Gm-Message-State: AFq9FYIzIjCgN718jEi3616hwOVOp9U38UX82qnriQ7t+MqQNxH+IftM
	FhlMrVExTu0QfeHzz1luhzXaQx+LurIDFol25vfvThyuyd5kTRgrORM=
X-Gm-Gg: AYBFou3FLxTrimrljgyesoeui5R6FCt7gochaEzJIM+UGVo8FUbjEUMxE85Nv4PlpW1
	4nkr07UT6dQySi2cs0Zsau3pYRW44oCM8lTMib4CkOUl/7VDe13BmqGUyTtp02VTY6Vg7drgooU
	jywBMIgGVfFs5WQOvxjZQIwerrWDKUI1edpLDtIf1xLVuysu5oBWfIoO72y3fVxnbi/tGUbeLgn
	g0+QoFZVb4QQtYSktr/Le/tIw98LqS4HILGj3UwZlN841a2pFkPAKPYHTi695P/cDlSEJ0vG4uz
	SM5+y0+rjgieOfSmFKOWoaXanXKZTfJHDoDrLdzws1tDsMDwUoLklRrZe1eRPyAVsmC7PirfoR7
	nVkW5F8TVkzS+bTE5cQExhUQ6kTHPxlFLXUe8BpPKnq3boqnepYKvgPfagIR8oCf2ocHHDs0ea2
	HFYOmp7mKLaE4xM5ajkbvWDMXqY+2MIZLmohMjpn7f2o7tT/nl683w/EO0f3puKgdKlrc60FOhW
	TS4MucQ5nVxARlaofpZeK9nMjqGg9LBad4bnBgA8vFu5Z531jsS+maOEnGY2K2zY2fhrzdydtXB
	jitbCGOn314=
X-Received: by 2002:a05:6000:615:b0:48e:5b50:9c52 with SMTP id ffacd0b85a97d-48e6e4fca88mr7640794f8f.57.1793388758641;
        Fri, 30 Oct 2026 12:32:38 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b78a6bsm4799150f8f.27.2026.10.30.12.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 12:32:36 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH v10 0/2] RDMA/rxe: copy send WQE to kernel buffer (TOCTOU hardening)
Date: Fri, 30 Oct 2026 19:32:33 +0000
Message-ID: <20261030193235.3470653-1-tristan@talencesecurity.com>
X-Mailer: git-send-email 2.47.3
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

The SoftRoCE (rxe) send queue is mmap-ed into userspace, allowing
the requester and completer to process work queue entries (WQEs)
whose fields can change between kernel reads.

This series copies each WQE to a kernel-private buffer before
processing: patch 1 for the requester, patch 2 for the completer.
Both paths validate opcode bounds and SGE indices after copying,
preserve DMA progress across multi-packet operations, and write
back updated fields to the shared queue via WRITE_ONCE / smp_store_release.

Changes since v9:
  - Patch 1: check dma.resid != sizeof(u64) instead of just > to
    also catch undersized resid that leaks uninitialized pad bytes.
  - Bisection fix: move qp->comp.comp_wqe_valid invalidation from
    patch 1 to patch 2, where the field is first defined.

Tristan Madani (2):
  RDMA/rxe: copy send WQE to kernel buffer before processing
  RDMA/rxe: copy send WQE to kernel buffer in completer path

 drivers/infiniband/sw/rxe/rxe_comp.c  | 76 ++++++++++++++++++++++++++-
 drivers/infiniband/sw/rxe/rxe_qp.c    |  2 +
 drivers/infiniband/sw/rxe/rxe_req.c   | 72 +++++++++++++++++++++++--
 drivers/infiniband/sw/rxe/rxe_verbs.h | 12 +++++
 4 files changed, 155 insertions(+), 7 deletions(-)

-- 
2.47.3

