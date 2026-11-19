Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795101215;
	b=2aH5++PXcu5FN9RGHj15xUrEngfeBmx6pk5WxiptKFBdecSIMo5WY4bhH8tTfd1xYcoB
	 bsKORlwgeLok1lIne9GMngB1Xg5m4Rl1yS8fUaXedHjwAVi6xmpvldYfZ/2YO4x0GL+kL
	 1a4ekm/0QCk43FJuKkjQkqF2Y+QNKqPHxRKoYR2Ux968KVbaHQ1voAxReE0FNzHbdUt8k
	 AdamwOAVTLDioan53dMuWJkrRHB5Gxd8wwjYwnROmgE+NPagOLsX3rNpfiuPr07d6/F/7
	 nxnC/HZCaFKGIF+6V+yF3OBv/azzv8onThf8+9DRl0va1dHVWl3L82v+JA0Xbq4Smyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795101215;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Sender:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=unOxuddyQ8CkRU4QDdC1UIs7kvHHG3wzvhCsDgFWKqo=;
	b=1AKRq8MAnZQ6eH2El/iDNs7rZ7R2oSD1eMqAeHPc90ifRDVSaVOzUBpVY3ozYP5CsvTP
	 DKHGCd94RierhASonlCRRbsB0WiZJZr1aIRKeVjH9eLiUIPAOfqYdFReKqLZG+UNE8Wf+
	 HvCxR3QFhER4DiOgnv+RvbpSrgOOnu2FNXW2jGpjF6W6Pwlud5bUqBnOhveVxwgMoBtLl
	 8vavc9A3Qkx3yGnP63ycDYE4buP5R1bNGbeXYw83q3y0lECP3NoHArdNJlBiViiRscBtN
	 NG2j6BT/WE/GemEqLBlabMJsVmrnr/TFEWXWVoEI0OxZ/6e6vbcAloMds/qKy0Lqtrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=stellman-greene.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dfJY0cBl;
	arc=none smtp.remote-ip=209.85.160.171
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEB1606A326
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 15:13:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3AEB1606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stellman-greene.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dfJY0cBl
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-55d2b4a99d4so21063991cf.1
        for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 07:13:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795101214; x=1795706014; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=unOxuddyQ8CkRU4QDdC1UIs7kvHHG3wzvhCsDgFWKqo=;
        b=dfJY0cBlzNaKteZvUBuUIpyRrv6yr4aci12uXEBETp5AfC1XQ6kCMLwfpOvZjSw60X
         RjtoAywWYFcj4SrrgXnHkW7rhqzb7pol0qc1FQ72XWyjB7ei1xTxb/oHjKoYWXpfso3x
         lmrp9sbZjkB4f3DL/2w8w3imPop2vap2L/rfSbLYOJenytj5sBXULjYoMMkz8BY2DiwU
         8olC9UBAbsJB5Be55lfRqgQQ/gnRxqtee5u44U5Ia3LNwb8ORh2t4A0BoXyFS5W3y5NM
         c2a/OVkRaEHKzvjKd1brSCcVBQBa23QdFkeLPh5J1UhepZbzUNsLBLn0do4L0DhquJQd
         48Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795101214; x=1795706014;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=unOxuddyQ8CkRU4QDdC1UIs7kvHHG3wzvhCsDgFWKqo=;
        b=2J7+KDzAB05x1ue9wdSOCwgDlDF2NMxk0K6g4jebINfAIL30Q9EbY7lpm69peJpM09
         /gWnjrK+9qDsXJ2eRcgCL95NTrTv4gmBWPFshj14hT0C8FFot5ELIvz0JTESwodRPGUZ
         0/2ImcAHTvQlCtRO614+DoOOauiOrczYkhOOUfGEGZ4vqIbJFj4G+smn7j1fmuP5vw28
         vyj9ASKXGuUB/jUQ+gDlC99qv0VY3RCIlnIqy5hTKFMUMItgy9AyxMPKbMXzPY0E7Oq2
         2hIUUxYwzJ4Bxxb/P7yfNXz+8Ga64F9XQsRkitzOO5T4Fws0Q5wCcZJPwPdrhMWEC+dQ
         yURg==
X-Forwarded-Encrypted: i=1; AL+hErFUXEEtt1Ac05WAJno70t41YqNVE05UQfQUKZUUeNJKUUMYmD9WH4XN+FoHhnIoDNe5kQxBVQvk2KSn@vger.kernel.org
X-Gm-Message-State: APuU4Z/mj0ZnO6yqLXceL9IhV6pgSsIMJxKJh+rzV2A1igc7Bcpv0KGM
	GT0I3lPL5wejcVoTlsUPKBe3xfHa8pwIha94KGB6PhSyBQlJn0wtIc0s
X-Gm-Gg: AYBFou1MxGc/4ycDuQRkXUyxPZ5ruLye5RE1kw9mQACRY1I+Q4R/qVNixvJIutHhoAD
	YR1cN1V58nN480EgM4Aqun/XYeKekdXPEW7eQj+2cJRKx8fsVbKaVvmPyvxnkRf35Zh9lbv4Bj0
	BsRT9q8OhzmEcigK5RkN4RgwpUlRg1HWgP6l42Y6B9k6xWfBNclOGwZ9EZ1Mw6Px68BO46LzPv3
	Gl7atCkoV17k16C6BVs6jAeHwUyZVJ7k9tz975T5YNsObBS2ezh2BIDzxUILWe9zyqoYJMuo7s+
	LU7oW2BmCnsdM39f8dl+8xa7X8RhsVA2g1WGDK8ufUON9e7VroawPIk1Qdu9tY1PHFjJDbAGRw0
	gf9CvGGaEJNlS89OF3s6GGh5/CoqXyrUgPP57uTrm6kBVFKHbQBzOGTlwmSLn0w8R3pkbjdKjL6
	5XQEUVqQZdY2yEFvxvoGzBcgzitnRTxWWIzgJBH+HMiS0Bi0vWAwpEHOR2utKdSPHTBtfMF2djv
	xr+927gQ5y856yNRjMz1KSaVK9zB03EqPbR77jd6rtDEoExTnN5bc2jYqbdmHh8TvNeqOim0zRb
	RlKxSWQi1uzCpIRNmAPGERU8DPh7Vn3pJWVxIp4aNdiBjBRp7SUzIYcFEjxOo/0PwsK2z/g/P4X
	hHQQe76n6aKAiHyyt+hizBMSNfYow7IQMIoyOhQXWkzEuFRXvuFZbIDIpaDz3ZZaho9YrNf3HSs
	On7PKPM4CSJ/rbS+DIO5LBBrVMCqk=
X-Received: by 2002:a05:622a:30a:b0:536:51d2:1e44 with SMTP id d75a77b69052e-55d76a16dcfmr3245161cf.22.1795101213870;
        Thu, 19 Nov 2026 07:13:33 -0800 (PST)
Received: from Mac.mynetworksettings.com ([2600:4041:5c28:200:c935:f347:a919:9f78])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-92134050859sm994356d6.43.2026.11.19.07.13.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 19 Nov 2026 07:13:33 -0800 (PST)
Sender: Andrew Stellman <stellman@gmail.com>
From: Andrew Stellman <astellman@stellman-greene.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next] RDMA/rxe: Require a responder resource for FLUSH
Date: Thu, 19 Nov 2026 10:13:32 -0500
Message-ID: <20261119151332.95466-1-astellman@stellman-greene.com>
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

process_flush() keeps its state in a responder resource from
rxe_prepare_res(), as READ and ATOMIC requests do. check_resource()
refuses those requests when max_dest_rd_atomic is 0, but it does not
check FLUSH. With max_dest_rd_atomic 0, qp->resp.resources is
ZERO_SIZE_PTR, and rxe_prepare_res() writes through it in
free_rd_atomic_resource().

A FLUSH sent to an RC QP with max_dest_rd_atomic 0 oopses the
responder:

  KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
  Workqueue: rxe_wq do_work
  RIP: 0010:free_rd_atomic_resource+0x15/0x50
  Call Trace:
   rxe_receiver+0x5f6e/0x9a20
   do_work+0x144/0x470

The responder task dies, and destroying the QP later warns on a timeout
in __rxe_cleanup() and then hangs.

Add RXE_FLUSH_MASK to the check, so a FLUSH gets the same Invalid
Request NAK a READ would, and the requester sees IB_WC_REM_INV_REQ_ERR.

The issue was found by Claude Opus 5.5 running Quality Playbook, an
LLM-driven code review tool:
https://github.com/andrewstellman/quality-playbook
The fix and this changelog were drafted with the same tool and reviewed
by me.

Fixes: ea1bb00ee9a5 ("RDMA/rxe: Implement flush execution in responder side")
Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>
---

Tested in QEMU with KASAN on v7.4-rc3, and on v7.4-rc3 with the RDMA
code from rdma for-next (7404c82cbf12). The reproducer is a short
libibverbs program; I can send it off-list.

 drivers/infiniband/sw/rxe/rxe_resp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 1b7f31737225..38b5b0c2abe3 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -340,7 +340,8 @@ static enum resp_states check_resource(struct rxe_qp *qp,
 {
 	struct rxe_srq *srq = qp->srq;
 
-	if (pkt->mask & (RXE_READ_OR_ATOMIC_MASK | RXE_ATOMIC_WRITE_MASK)) {
+	if (pkt->mask & (RXE_READ_OR_ATOMIC_MASK | RXE_ATOMIC_WRITE_MASK |
+			 RXE_FLUSH_MASK)) {
 		/* it is the requesters job to not send
 		 * too many read/atomic ops, we just
 		 * recycle the responder resource queue

base-commit: 7404c82cbf1246e0e84e2ec21834d23c26f9a8ed
-- 
2.43.0

