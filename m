Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792892295;
	b=JXKCnExkmLq3lANwP7NvcnDuWAaDsihtbMaegycymVQ/UwFrkvZXJJnaUMMYR4eEaPXH
	 juKdjeFgd5GL8yIkBo1y1Nby3rdcs2H8idg2RU+koMiDK/gqRds3r5AvDidalcyLmgpYR
	 /1d5202bYZ7DWY4scAFLwoSOw14S2TxtTx/+ia/Bb+viWlnyGTjMJ1iH66BpnP/lqH4vq
	 Tq8gTdPH24J2/LUaPqoqpKgUwnGOabuyD8KWC1iLJSvq3Hug0i/mfN9mJRYVvd+vW6s/J
	 n8bErJXa3i6BtfIDTMg+03WLvpJ56kU45iwnTO/4r27dR/MziFHOGPX3USQZXQ+bv+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792892295;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OwT87TkRyG6fAEd7ylK/rWIM/7AqJXyhM7Ww/r4lOq4=;
	b=5MTvjXcSNP+I+k2LE8PSrLLZHN9w/n5704IPHkWNOAdMzcipik4SJnbVUc6aI6fFozSn
	 Rq8se8xx1+ol1g0ITldiSRnU/18KRbqoUUbD96olwzNu0NbEVj76P8Zp+p9pXqzNy39ey
	 04SMg6VMEBYPqInhIH7SpXESWPW8bNY9I54FiTxr/z4ceMtDKTpI5aQtNGqwYYp3Pd5oS
	 8DOQAtfj09dGNvWLvDkC+alZwyQNdcwwZFEMCd56x8aIiO4h/tdHI0LxUU37Mx0v2/Hiv
	 tksufYMk2MA0+JnOqsty8HXPj2ZlzoHh43epKFSTlYr/0DTstqZ4eUKzqsK9KbD624Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=VTbCxHGY;
	arc=none smtp.remote-ip=74.125.82.181
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF3A606A33B
	for <linux-rdma@vger.kernel.org>; Sun, 25 Oct 2026 01:38:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DF3A606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=VTbCxHGY
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-3550c917fd3so2998676eec.0
        for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2026 18:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792892289; x=1793497089; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OwT87TkRyG6fAEd7ylK/rWIM/7AqJXyhM7Ww/r4lOq4=;
        b=VTbCxHGYQUc2nGwdMnpE0v024Jod606tsp6LU65Hynq3jQKnV7TiQmEXMJYfDNkDY9
         xTgdOUIEin3x2q7DbzoaHhqH4GiRpvaItmTr4zAzDyD74IVu1Gk2mpdWfhnTF8RZQUTQ
         1ZfnhgsS8eZZttjcd/Okk30Fu1SdD+Yd7T3DF+VQsY9AUjGR606dgv+Ayb/w9F+Lsy49
         KmqVo5mPv6iKQjPULSwRslixWagA//sSHuvgJV5KAQ1v3YEb9bpEoH+iOCeAhBkIbCC/
         uwB9lPkKtT1gB9e20e4ry0YROnMmC/uAsDGq1eBXFZ2UzDDQXjrTHnYhEdIzMeGrzUHh
         7qvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792892289; x=1793497089;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OwT87TkRyG6fAEd7ylK/rWIM/7AqJXyhM7Ww/r4lOq4=;
        b=Dv7cRNqaPCTYJDqBd1fJC7BfFdb5CB8QYZmyJnAoo2qtyOpdEUJDJ3RXhQ/7qQ1u9K
         Bd5zZr052ntkrXkp4cHbULRLsxhiEjoorD2Nyf30IrrbFh/LzQHEezL4F8HAe6tswIpN
         C8TcnTdWmkS/Zr+TNLYWGGF2a5gBNJk2j1QQ1weT+NsrTb3K2FZlY/UneKLZ/eDbvfas
         /QZFFDNH5TCSSvKjdFBsfvsosDdCvb5Wa1m2t6AkCShAueddDW1awy2wiGXN0IxZ6EfJ
         cqfMaH33LsYcT9BLfTSAbke5mm1caUJtGGqPhNaJj9U5l2r/qIoYnDtVPHvG7S+XYcwj
         JUkQ==
X-Forwarded-Encrypted: i=1; AKwUvBzhh/anmncBLDHBRRPTA01wjbgUnAVnCiCezTRahIOYNZIZneRg1ul7iQeR+368sJ7dqHEyvtppqAG7@vger.kernel.org
X-Gm-Message-State: AFq9FYLhhx1mtG21joxBLYHGLlzArjKUf8v8Ryhi3oTUe49nNlOX5COe
	HKn6jmKdC1SH+8Sr70a+N4NnGnUeTEjCVm1D7Eiqkh7xCj/0q1IHR3HDschh74dvDa0=
X-Gm-Gg: AYBFou16QKNm6YGv4kvuEfXJTadXaryoW1Xqgc1ZpDfneuk26YmE4zq4uB3YkSeLLLr
	GvMIcWXCY7yZ65UIVdh7BGpkyH+6gDFPun/pVY22RQZotv83hyv6qjV89jli+PiR0K2/PVytRdQ
	0ElUnpQOVfmihXMqtyOTOweSskDrGeP1TRHvuaQjK7FEcksD2LVmTUZ9p6vJLzMviKXdDj+8GvM
	MZNmr+lqyXpaFXevhgPHdWWl5IMueGhJJRTpJTPVPv6AHeL2abFz5TOrgTyQmUravK37UqGmMb6
	Etj07b0M+P5X9O5GbMf2/04lWCeg+banQlVN/pvjfunD7SJISBmsuqtClfX3Db+PC4XwEbimNZ/
	pTbSfxvAs4TAcROu1erZE+cX+DbMkT0tccRT9m+HFhPBHBuprPVcPaVXN26w8BisKXMr4MUnYRX
	iB7vrAYp6CEfsCaS4nDXTQ3MDLk6qTaC+qvSA56E8HYEflXPi3+HTrwXJr7CwkvH6yRmmkZC1wj
	hwY+KXskBgWbW4e4SPD8ttu3IUNQNh/nscPWI4+9rxwLoyPm1xz/3XuEKguSdjHA9LQdf4a4/rI
	cn81PtNZIwwE/1M/P+RQ4dC82mzzoYspaDIOru8mFEFg9qj5qcxMxh9ej3VvxIh/
X-Received: by 2002:a05:693c:65d5:b0:359:8492:20ff with SMTP id 5a478bee46e88-369e842bda4mr4860522eec.12.1792892289422;
        Sat, 24 Oct 2026 18:38:09 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:dba3:be57:a674:a67f])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8dbaa42sm13724329eec.21.2026.10.24.18.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 18:38:09 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v5 2/3] RDMA/srpt: reject zero-length buffer descriptors
Date: Sun, 25 Oct 2026 10:37:47 +0900
Message-ID: <20261025013748.3755639-3-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261025013748.3755639-1-yhlee@isslab.korea.ac.kr>
References: <20261025013748.3755639-1-yhlee@isslab.korea.ac.kr>
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

srpt_alloc_rw_ctxs() takes each buffer descriptor length straight from the
wire and hands it to target_alloc_sgl(), which has no length check of its
own.

For the single descriptor of a DIRECT request, and for the last descriptor
of an INDIRECT table, chainable is false, so a zero length makes
sgl_alloc_order() compute nalloc zero. kmalloc_objs() answers that with
ZERO_SIZE_PTR, which is not NULL, so the allocation looks like it
succeeded and sg_init_table(sgl, 0) runs. That reaches sg_init_marker(),
which does sg_mark_end(&sgl[nents - 1]) with nents unsigned, so the index
is 4294967295 rather than minus one and the read modify write of page_link
lands far outside any allocation.

  Oops: general protection fault, probably for non-canonical address 0xdffffc03fffffffe: 0000 [#1] KASAN PTI
  KASAN: probably user-memory-access in range [0x0000001ffffffff0-0x0000001ffffffff7]
  CPU: 0 UID: 0 PID: 43 Comm: kunit_try_catch Tainted: G                 N   7.3.0-12378-g6fba331225f5-dirty #1 PREEMPT(lazy)
  Tainted: [N]=TEST
  RIP: 0010:sgl_alloc_order+0xb6/0x370
  Code: ef 01 4c 89 e2 49 89 c4 31 f6 49 c1 e7 05 48 89 c7 e8 ae e0 cb ff 4d 01 e7 48 b8 00 00 00 00 00 fc ff df 4c 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 6b 02 00 00 49 bc 00 00 00 00 00 fc ff df 49 8b
  RSP: 0000:ffff888002d4fa38 EFLAGS: 00010202
  RAX: dffffc0000000000 RBX: 0000000000001000 RCX: 0000000000000000
  RDX: 00000003fffffffe RSI: 0000000000000000 RDI: 0000000000000010
  RBP: 0000000000000000 R08: ffff888002b158a0 R09: 0000000000000000
  R10: 0000000000000010 R11: 0000000000000037 R12: 0000000000000010
  R13: ffff888002d6803c R14: 0000000000000000 R15: 0000001ffffffff0
  FS:  0000000000000000(0000) GS:0000000000000000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: ffff88802f1c8000 CR3: 000000002e458000 CR4: 00000000000006f0
  Call Trace:
   <TASK>
   target_alloc_sgl+0x2b/0x70
   srpt_alloc_rw_ctxs+0x2ef/0x870
   srpt_test_parse+0x114/0x580
   ? __pfx_srpt_test_parse+0x10/0x10
   ? srpt_test_ctx_init_direct+0x17d/0x280
   srpt_direct_len0_test+0xa4/0x280
   ? __pfx_srpt_direct_len0_test+0x10/0x10
   ? __set_cpus_allowed_ptr+0x181/0x240
   ? __pfx_read_tsc+0x10/0x10
   ? ktime_get_ts64+0x192/0x250
   kunit_try_run_case+0x1ca/0x4b0
   ? __pfx_kunit_try_run_case+0x10/0x10
   ? kthread_affine_node+0x24b/0x370
   ? __pfx_kthread_affine_node+0x10/0x10
   ? __pfx_kunit_try_run_case+0x10/0x10
   ? __pfx_kunit_generic_run_threadfn_adapter+0x10/0x10
   kunit_generic_run_threadfn_adapter+0x7b/0xe0
   kthread+0x36e/0x500
   ? __pfx_kthread+0x10/0x10
   ret_from_fork+0x34d/0x620
   ? __pfx_ret_from_fork+0x10/0x10
   ? __switch_to+0x22/0xdd0
   ? __pfx_kthread+0x10/0x10
   ret_from_fork_asm+0x19/0x30
   </TASK>

The KUnit harness that forces this is not part of this patch.

A zero length descriptor elsewhere in a table is chainable, so one entry
is allocated and that write does not happen, but the entry count comes
back zero and the mapping in rdma_rw_ctx_init() then refuses it.

The target core never hands the same allocator a zero length. Its own call
in transport_generic_new_cmd() sits behind a cmd->data_length test.

Reject a descriptor whose length is zero. The existing unwind label covers
the first iteration, where its loop body does not run because nothing has
been allocated yet.

Fixes: b99f8e4d7bcd ("IB/srpt: convert to the generic RDMA READ/WRITE API")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 40d796840befc..dfcecbe3a47c7 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -979,6 +979,12 @@ static int srpt_alloc_rw_ctxs(struct srpt_send_ioctx *ioctx,
 		u32 size = be32_to_cpu(db->len);
 		u32 rkey = be32_to_cpu(db->key);
 
+		if (size == 0) {
+			pr_err("received SRP_CMD buffer descriptor with zero length\n");
+			ret = -EINVAL;
+			goto unwind;
+		}
+
 		ret = target_alloc_sgl(&ctx->sg, &ctx->nents, size, false,
 				i < nbufs - 1);
 		if (ret)
-- 
2.43.0

