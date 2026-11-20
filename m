Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795132937;
	b=q6t3Uty1OH98djIzKTesafsAaSf/K2o1sVx57cG8HcMcrt3dLAcnmdr+MR3fm0ugbw7C
	 XCfm8e3QArSyT2Wd2axBxVWfwIqehE7jj3P2KCCOeCKkr3ZvR2iVJJoz7H5H1ACtvbGBp
	 ogOBSm5Ms+gdbjShkx8pcqiuU1wmmOQxC0qO0A5XLDJMc2GB+1uz/QWss8ZE678HFhsVv
	 W5fev7Jjn6yIhd74DX+5Ycc8Jfe7nRENrfsjcPkDTAD16RXMUaViaSMZiI/IWbBhN53vq
	 MoDXINsFfaE4lX5WiSTTfugWlCichGLYaDz6q43guxPmMzSqwPTufAtD0kEezsSqeuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795132937;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Sender:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=84tD0PsJv6l6Ov4ThwASTzNvZKHlK3zUmVj0Eq3Ddgw=;
	b=CE3hV5pC6+Gv47KQcy636/5yl2nVcOp6BnXBREfhXYda1kxB5ar42Kzes59nFwatEJZn
	 7ptnKJ5szKYqxZY0FFSx1SYeWW92uLkohnlJAcoAzVM0Gqrk67B0X3oqxoBCdSi+LwUWR
	 XX8oaWQM0mCRgXxvsOhPyIKVfdE5zrUPUbK46UBO0Hm8dJe6jAMJKVGNVJJThnRzrLopl
	 pjPW8JrGgYB9RjQDQvM2ygIaJ7Kbrdl0sbKyY3Nk20xDI0yOoeV9FC61dlMD8qOPKByhF
	 77J5IukQfc+MI+7UPM1pCIS8JExXJTNw+Xg9tegXGi0tWXDoUSTGzv+S3lpZaBdQ6iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=stellman-greene.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LSibu5eG;
	arc=none smtp.remote-ip=209.85.160.181
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3390F606A320
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 00:02:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3390F606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stellman-greene.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LSibu5eG
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-55d360ca878so2630471cf.2
        for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 16:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795132936; x=1795737736; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=84tD0PsJv6l6Ov4ThwASTzNvZKHlK3zUmVj0Eq3Ddgw=;
        b=LSibu5eG+B9bGZQiphsS4mZTkdkfLEX0be8mxdxpvtNevnhhTNlSATJSbbhjbSKmo9
         eLUkOqOF3a5WoIlDNO8EEEEZcGyA0d55HHkcMFxZ5NiHNmnRRTXcZwFKKjE5EyFPOfEZ
         aFNed9FC/lrVcH8sBRAr4sDX+xf9Dj3T4dpZUnsw3HcZEhARr9ffskNS5LVXtK8xB80Q
         q6hylW5EwOiGIu0zyq0/9fH+lhfOntlikBOC8bsiklG/57IH8zkq33bNChuxkoD2fjQY
         bo/pGVj5XoeckqArivVZ0rnfSXpD9KnfkXNTaYFgNwXc9FZQXIdzkc+qEebnxjqebSNc
         02Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795132936; x=1795737736;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=84tD0PsJv6l6Ov4ThwASTzNvZKHlK3zUmVj0Eq3Ddgw=;
        b=v+2j6bcllgcIFJO2NwixeS4QAd1rjK24ehQVlS55N4zj51rmT2aCM+hCVwNu/XnK+3
         X2TVpGawbQlC1mqsux51lPJ7G2s8lkY/SeGX6kab1gdMGi86eY/gAt3oMdY7/rv52CyP
         uTi2pOmVL9wlowrt0vmY/XUeJwIKSKSL7ir3pYi8FJ4DTVja02d3qf1vCrFEmkx67NbD
         srT3osYzJlqamm1DttrrOFYnupXoeX+O2fiuyXG7nvrT8HoI5WitL4+caYaCN374dN6O
         HpVm3D3fai7p5rtknn48S5mLcRGDVMVjdtpzZN5ht8O/ZuYauFg4Res3BJ+F3LxqJzeH
         MoEQ==
X-Forwarded-Encrypted: i=1; AL+hErF7dXXyECibVI8B3tUUaQo6PCpS5FMRBGDLV99wuvga3O+jCYNW4VliSSAvqAMt41e+EHuQdqMA9jIe@vger.kernel.org
X-Gm-Message-State: APuU4Z8F7dK0nhQ8jJrotLzAyViSmaZdPmQFZ34HkynUNtgb1ubx2k3P
	qLn3hLyZ9HU4yJN3nANfQI8pDjTI7GajT0cYg7mNxpOASsgC+F65kI9p
X-Gm-Gg: AYBFou2/5UQbHu+2ZlN075KLalB1kL9kkkHh0EtMQ586am3xEse46lBTJo/nW6LxHxe
	vpDrMwmhIT26RiKEpuUfwQ7HQ9bPzcxLUtYNox882ahgcZSjaScFfK2ay68T/Xfd2hSEFHnEbaG
	jQhVYjdH0lnmO+gAu5RvdfzSl1uFY/GjyDOUSpXG8mhfNYXjcSyknPP8E/czC9SubIFkWwF8CXG
	klDnrD6R0Cfw1dgEd+ffabyKMRW0PGssApi7f5noiR9HFLX9m/ohvTfFZc4AASWCcz1fhuF4rhv
	hoWIIyUicdj4W/rRVPERvyGnqxmXV4YFNWjGrPYPr9e2FHoJxS8PWVZGdPGdWWORCuqGQXfH4Fe
	NaLpfEqkSUb5UZNh42yUkLr2CAJrhmy6CoEz5ORjLEruX1ejHmORP9slXJvLV7BWmiGr4gQwn2Z
	rGWFUbMQjEHhvs0D9i2vbKKGF37Bxn9eS5igrI/sLlI2XLMvkR7zDDG9AHSc5blZ9v3q5HJQ2dT
	3DETtNc/Cxv2yAoLBMo/FYX74hrVsqNxnUBAVTo72oJ6dCUqOKi6GNu6ykU7bfeWQdxmcUHJvtq
	IW2BrQACwk3NrVSHyFL1IdmbgEicXJhKqeCchZj6XZGe7xp32wANpWkMCiLR0JIvDMEG32UkfJO
	ptGlv/1yX0vC2nkPh2GYZN0Lbarzh0wbETU64v59xXSEEMnV1yhsQOkO9+/vfCJ4tBi19OjUvvL
	DIj8TcOmn+XZxbIecn3rHJhVHdVhg=
X-Received: by 2002:a05:622a:2609:b0:55a:df3b:38d4 with SMTP id d75a77b69052e-55d76b5b9b8mr27871611cf.75.1795132935854;
        Thu, 19 Nov 2026 16:02:15 -0800 (PST)
Received: from Mac.mynetworksettings.com ([2600:4041:5c28:200:c935:f347:a919:9f78])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d78807b5fsm8110401cf.6.2026.11.19.16.02.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 19 Nov 2026 16:02:15 -0800 (PST)
Sender: Andrew Stellman <stellman@gmail.com>
From: Andrew Stellman <astellman@stellman-greene.com>
To: Bernard Metzler <bernard.metzler@linux.dev>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-rc] RDMA/siw: Reject opcodes a user send queue may not use
Date: Thu, 19 Nov 2026 19:02:11 -0500
Message-ID: <20261120000211.63217-1-astellman@stellman-greene.com>
X-Mailer: git-send-email 2.53.0
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

A user QP's send queue is mapped into the process, and
siw_activate_tx_from_sq() only checks that an SQE's opcode is below
SIW_NUM_OPCODES. siw-abi.h marks SIW_OP_INVAL_STAG and SIW_OP_REG_MR as
valid for in-kernel clients only, but a user process can still post
them. For SIW_OP_REG_MR, siw_fastreg_mr() then uses the user supplied
base_mr value as a kernel pointer to a struct ib_mr.

The uverbs device is mode 0666, so once an administrator has created a
siw device any local user can trigger this. With an unmapped base_mr,
as an unprivileged user under KASAN:

  Oops: general protection fault, probably for non-canonical address 0xe000042828282002: 0000 [#1] SMP KASAN NOPTI
  KASAN: probably user-memory-access in range [0x0000414141410010-0x0000414141410017]
  RIP: 0010:siw_qp_sq_process+0x38b/0x3c10
  Call Trace:
   <TASK>
   siw_post_send+0xecf/0x20b0
   ib_uverbs_post_send+0xf28/0x1610
   ib_uverbs_write+0x899/0xd30
   vfs_write+0x227/0xcd0
   ksys_write+0x17c/0x1c0
   do_syscall_64+0xdf/0x4c0

The task is killed, and then hangs in siw_destroy_qp() when its files
are closed on exit. Posting an unsupported atomic or SIW_OP_RECEIVE
instead hits the WARN(1, "undefined WQE type") in siw_qp_sq_process()
and leaves the memory region named in the SQE pinned after the process
exits.

No opcode from SIW_OP_FETCH_AND_ADD up is valid on a user send queue,
so reject them all.

The issue was found by Claude Opus 5.5 running Quality Playbook, an
LLM-driven code review tool:
https://github.com/andrewstellman/quality-playbook
The fix and this changelog were drafted with the same tool and reviewed
by me.

Fixes: f29dd55b0236 ("rdma/siw: queue pair methods")
Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>
---

Tested in QEMU with KASAN on v7.4-rc3. The patch applies unchanged to
rdma for-rc. With this patch the post returns -EINVAL for REG_MR,
INVAL_STAG, FETCH_AND_ADD and RECEIVE from a user QP, user SEND and RDMA
WRITE still complete, and rping over siw works.
A reproducer is available on request.

 drivers/infiniband/sw/siw/siw_qp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/infiniband/sw/siw/siw_qp.c b/drivers/infiniband/sw/siw/siw_qp.c
index bb780e3904a2..10876cefc0bb 100644
--- a/drivers/infiniband/sw/siw/siw_qp.c
+++ b/drivers/infiniband/sw/siw/siw_qp.c
@@ -869,6 +869,12 @@ static int siw_activate_tx_from_sq(struct siw_qp *qp)
 		rv = -EINVAL;
 		goto out;
 	}
+	/* No opcode from FETCH_AND_ADD up is valid on a user SQ */
+	if (!rdma_is_kernel_res(&qp->base_qp.res) &&
+	    wqe->sqe.opcode >= SIW_OP_FETCH_AND_ADD) {
+		rv = -EINVAL;
+		goto out;
+	}
 	if (wqe->sqe.flags & SIW_WQE_INLINE) {
 		if (wqe->sqe.opcode != SIW_OP_SEND &&
 		    wqe->sqe.opcode != SIW_OP_WRITE) {

base-commit: e7732ec135b501e87ab060d992b3b5f2ec4396c9
-- 
2.43.0

