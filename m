Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.178
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795377099;
	b=5QSL4lxhjvoe15Dq/IoCmgezkEMjVerehJwMY0J4H0/qh4T6wNRXhJWdxbWonlicSpQH
	 Pd0dLztFlK+c7lY9P8/1H38MSxgtasgRcoMcbCjAXpf6NuVQEulh6+chRZ5Ao6PGjrZCz
	 ta60SUeVbHXCCRZdU/FzAcystQeVtsFtSdmPp7OMk0/nHiKDxZWTd7ZKqYU5xshUnMFZO
	 QQNe78qy4BhxQLkxfVPFhtXPobaIdPw40U6/BShTm4kSsgCsU2AcFi/CC40TdDfUnTMQf
	 MOTR6F2pxhS8CdryIa1M43JqRDclfjyaBPqLwjLbR7v6+uODOKyY4YBy3otJ/DpFhYg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795377099;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=yzd8QCFAl0vOSBpuVvvQBboo6tfWr4C+v8GEnmxO4sQ=;
	b=iq4Kld9RtFrL7FTYtMNOgmjWgpr18fKDhuLxdNGB0PiqZi1VuLrPix6BQdMDDthzFtXH
	 AkKlnlWww77UsZKWkEoC7L4J/6yZoq4MUJr8NwGm+vdVm7g1S+tYuKi3u9FC+cfwf9k6g
	 2megmsHqt3LIt/9isD24WDSmrOGlepdCRwJvX1T7URaZ3K0tGW4i+9OT8+3/vh3Mjic3z
	 ehVFujAuSXltKlbvQKUo9Y7oyEjGgFO6fr1oHIdyKxjiinsw0KxtJyEizQGyLUnbAtRK7
	 B75OsaxBI7R1raFZijoLwhsue3yh+O74t6Baj4tvUa7fdM/Jr1M0OfmXVDHHERy0Zjg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=stellman-greene.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=stellman-greene-com.20260707.gappssmtp.com header.i=@stellman-greene-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=pJS7QhlU;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.178
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A925606A31D
	for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 19:51:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6A925606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stellman-greene.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=stellman-greene-com.20260707.gappssmtp.com header.i=@stellman-greene-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=pJS7QhlU
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5363316fa0cso31019021cf.3
        for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 11:51:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795377097; cv=none;
        d=google.com; s=arc-20260327;
        b=b6JhaYk9BxhIY4ywQPHPbzndqStpgVc3/iA560lcPLL4xZR3hw/1mRpGNLGvHWOKGq
         a/01caG2blrEjX6cFKFD9pjMmp/i1mQZqmUrIZDUb1lTYYclUhfKfSzDgU2EYWTl8i8x
         fwe4fVnxesBsBf8/Nx1wCZjcZ5aTOn9s9C4hRJgKSUhzWen/BjICgNbfePk/++4JvBQ6
         +fRE1oESLxbwSNVe/XB1GR34ovYDOX8WBMDwqV3HIlTuNb5dfXnP3i81Lpry2qsSubmn
         Zh6sVBv1Jy5pTGLSxRxiJUZtaLlBGkrw//jugJHZypzB2iOSSTo882W8gaCQz9L63rqv
         F5RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yzd8QCFAl0vOSBpuVvvQBboo6tfWr4C+v8GEnmxO4sQ=;
        fh=YG1aj1i7IIzurQ46oUMfwsx7YXGQjKtztzNuhP6doqg=;
        b=enbFC+uOkLB8rpfOGYCQCmwpE1MyrIqkOJ9FteR7eMUuAeEFlqpjFGXlyOILxJUhGY
         yc1j2YOWRJyJQ+y2Gf7XqnU3CQ+qMs77c8SyOf/CfkOuzQcMu8PJWqAkJufX1GFEcKM3
         kpbahOKLjtC7qUduIhfpMWIo70od9TlFTbRoHoAJIY8p+QpoDSQUd97dLvDwSh46NaFE
         2mSj5PGYH4mrjCjjq2GqBk9xu7h/UD9G23lmb9g8kzTqkY5VLgAFoSfMRaMZ3RToxDTI
         9T5yiKrfZeaQiDRneodzJIUeWL/CG6RlwQ2GtvQqhm1Ge5cMdk0H9pFGYbProM35Q5B8
         xSgA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=stellman-greene-com.20260707.gappssmtp.com; s=20260707; t=1795377097; x=1795981897; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yzd8QCFAl0vOSBpuVvvQBboo6tfWr4C+v8GEnmxO4sQ=;
        b=pJS7QhlUOPxQ9mJA7nXLa+hJQfk0d8W1dIY8ZbQ6dAaXCJBHlNX8Qr+ugAPpkxL9s2
         cYM7tAOrlwP2AvIfmR2v6FXRHgpZYc0jxmaTX3yJVebP59cts5ClN/nMH1wS7Dz52w4o
         9S0Vi3cJZuptygscYNCwUNdjUqP85yb+1A0IXJCpIibFLXVoqwOfAlKCDvvnZfLk1f5b
         d/CWfbmYnkhXExbSlNcp4ljVSUbkt3UuWsD7nSEFlG608h1ww2SC90TsK4jtMXW4BVGS
         BRQW2GS9OdVx/wubdXtcpQ6LpKPK9nggPPyWg01WruLPdpgEl/ThduV/AXgtQdWjmivV
         aiqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795377097; x=1795981897;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yzd8QCFAl0vOSBpuVvvQBboo6tfWr4C+v8GEnmxO4sQ=;
        b=sDMe02o7Bx4kboHDNSiEhThRUP7+qnKtjrxEqA0+rjhpEGbwf7iiRafffmP6gB7pX8
         WdMmxKXnOvawFD03Dtek/imdmI8iDtvuu9r+Gcw+AKldSZvgowCAl3Y0wvqa2tsLkmZx
         C/kQ2GbG4kJwU5+mypfub20lkkzt0XDtW8h56H8dwXnnPA6BZVFOgMIxbU76TSyPb1ux
         Xh0qoZkiUK53IqBNxXomYa7wqZWRAa4HRtnC4njKXkStzBVOEw9usjCfnw+uQCFMmx9O
         XwxycL7aHHL5q0YbknVehCjPaQu4C1BRMds9jXuVENjbcajjd1wcsO/B9Tt2TN2yumw/
         1s0w==
X-Forwarded-Encrypted: i=1; AL+hErHFeHRHJVT0kXyoMxFNluObw4qyfhuOjZbb/hq7CLuoW+jChB/HZzG5SQ863+ZbgXTTcNlSw9ABcy9Y@vger.kernel.org
X-Gm-Message-State: APuU4Z9q+cxHTfhKn+J83ys8KeezR9XF73us/kaNpVTHNigxrzgSSeEa
	tdnX+aABIylgzalqb4oTHpzeyxp6hm841OsuhDgOo2tb+TvZpjoTeVArludFsVTJxshtHZ0fCPl
	Z7s11s5nzh0ZpKtXJcOa74bSLW2XV2lU=
X-Gm-Gg: AZFdTZevPUUz41j5aKRL0G4vdnho/gxFYD1tZ2CL/y0z4RM+V69SqxD3Egd07EP3ek5
	Rzub3gaL13FLSnZe0rVnXT2Y/AMbaKQ9DN/FBzpheoM2Te1REw4nggQ6qdL5RMVqoL72506OAoq
	PvtbCOMXH6T2mwDnU02NKM/9ESwB85ImDFpqR4VKjI1mePPGEd+X8YPk1TAaOr1/BCemvaVCwQR
	mVJg+sabUYf9hjEqVRgSBzfqnsu6zZg5+Z7koKLpbyIeWKWCr7ZOrqdYKUWVrf3bG69PHUUAR6c
	Wn75BgGOtxBlc0w7lqx5s5OEo8AlyCb77lcq/1hIbpPbJvrcmeJMSYE1MgkaFwWcta0xD9/6+w8
	aLlNDEkkUN63jba2PHYBvw0yxCV0C18f9ckdnc9WDFtxiM8D3DTP98yPFrqkJGnj0TnWZBnGbf1
	D8oxIGELhKY1tL6R1XqXVwTvlB7teo7k2v1BAsEEHa1nWP9FNe4TqeokRsJ7wZaXbHDEqpPtiOB
	/5YWlAFVVfeCZk=
X-Received: by 2002:a05:622a:1646:b0:536:5bb2:545d with SMTP id
 d75a77b69052e-55d76a5c656mr170900931cf.56.1795377097130; Sun, 22 Nov 2026
 11:51:37 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261122170551.19582-1-astellman@stellman-greene.com> <59e93766-fb4f-43de-a721-4ad544264730@linux.dev>
In-Reply-To: <59e93766-fb4f-43de-a721-4ad544264730@linux.dev>
From: Andrew Stellman <astellman@stellman-greene.com>
Date: Sun, 22 Nov 2026 14:51:26 -0500
X-Gm-Features: Aa3M54pQc2CB7HhHmMEOt-TFLHlsf7C7CKHbgquXo_9zTp30T--7jRS6F5FN8MI
Message-ID: <CAChPuV9vPzV8k4SR-nn4O6N3Ld4g0uxA4qdahDUhJxZWnzNn7Q@mail.gmail.com>
Subject: Re: [PATCH rdma-next v2] RDMA/rxe: Require a responder resource for FLUSH
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Zhu,

Thanks for looking at it.

> (1) RXE_FLUSH_MASK takes the same error/NAK path here without later
> responder states assuming a valid qp->resp.res or non-ZERO_SIZE_PTR
> qp->resp.resources, and

Yes. With the change, check_resource() returns
RESPST_ERR_TOO_MANY_RDMA_ATM_REQ for a FLUSH, the same state READ and
ATOMIC use. That state calls do_class_ac_error() and moves to
RESPST_COMPLETE and then acknowledge(), which sends the NAK because
aeth_syndrome is set. None of those read qp->resp.res or
qp->resp.resources, and process_flush() and rxe_prepare_res() are not
reached. A retransmitted FLUSH goes to duplicate_request(), where
find_resource() loops over max_dest_rd_atomic entries, so with 0 it
returns NULL and the packet is dropped without touching the array.

In the QEMU test with the fix, the requester's FLUSH completed with
status 9 (IB_WC_REM_INV_REQ_ERR), and the test program then exited
normally (closing its QPs) with no oops or warning. Without the fix,
closing the QP hit the __rxe_cleanup() timeout warning and hung.

> (2) no other RXE_READ_OR_ATOMIC_MASK / RXE_ATOMIC_WRITE_MASK checks in
> rxe_resp.c for max_dest_rd_atomic or responder resources missed
> RXE_FLUSH_MASK.

check_resource() is the only place in rxe_resp.c that checks those
masks against max_dest_rd_atomic. The other places that test them
(check_op_valid(), rxe_resp_check_length(), execute() and
acknowledge()) already handle RXE_FLUSH_MASK, and the only users of
qp->resp.resources are rxe_prepare_res() and find_resource().

Andrew


On Sun, Nov 22, 2026 at 2:42=E2=80=AFPM Zhu Yanjun <yanjun.zhu@linux.dev> w=
rote:
>
> =E5=9C=A8 2026/11/22 9:05, Andrew Stellman =E5=86=99=E9=81=93:
> > process_flush() keeps its state in a responder resource from
> > rxe_prepare_res(), as READ and ATOMIC requests do. check_resource()
> > refuses those requests when max_dest_rd_atomic is 0, but it does not
> > check FLUSH. With max_dest_rd_atomic 0, qp->resp.resources is
> > ZERO_SIZE_PTR, and rxe_prepare_res() writes through it in
> > free_rd_atomic_resource().
> >
> > A FLUSH sent to an RC QP with max_dest_rd_atomic 0 oopses the
> > responder:
> >
> >    Oops: general protection fault, probably for non-canonical address 0=
xdffffc0000000002: 0000 [#1] SMP KASAN NOPTI
> >    KASAN: null-ptr-deref in range [0x0000000000000010-0x000000000000001=
7]
> >    CPU: 0 UID: 0 PID: 13 Comm: kworker/u8:0 Not tainted 7.4.0-rc3-gaebb=
72744764 #1 PREEMPT(lazy)
> >    Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix=
, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> >    Workqueue: rxe_wq do_work
> >    RIP: 0010:free_rd_atomic_resource+0x15/0x50
> >    Code: 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90=
 0f 1f 40 d6 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 =
02 84 c0 74 04 3c 03 7e 0b c7 07 00 00 00 00 c3 cc cc cc
> >    RSP: 0018:ff110000013479f8 EFLAGS: 00000202
> >    RAX: dffffc0000000000 RBX: 0000000000000010 RCX: ff110000059f9760
> >    RDX: 0000000000000002 RSI: 0000000000000000 RDI: 0000000000000010
> >    RBP: 0000000000000001 R08: ff110000024a2180 R09: ffe21c0000268f2c
> >    R10: 0000000000000003 R11: ff110000059f9298 R12: ff1100000592dc00
> >    R13: 0000000000000040 R14: ff110000059f9000 R15: ff110000024a2168
> >    FS:  0000000000000000(0000) GS:ff110000e18da000(0000) knlGS:00000000=
00000000
> >    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >    CR2: dffffc0000000002 CR3: 00000000052ca000 CR4: 0000000000751ef0
> >    PKRU: 55555554
> >    Call Trace:
> >     <TASK>
> >     rxe_receiver+0x5f6e/0x9a20
> >     ? flush_workqueue_prep_pwqs+0x1a4/0xe80
> >     ? kthread+0x2b0/0x3b0
> >     ? __pfx_rxe_receiver+0x10/0x10
> >     ? update_cfs_rq_load_avg+0x5a/0x560
> >     ? pick_task_fair+0x468/0x1a60
> >     ? __pfx_rxe_receiver+0x10/0x10
> >     ? _raw_spin_lock_irqsave+0x86/0xe0
> >     ? __pfx_rxe_receiver+0x10/0x10
> >     do_work+0x144/0x470
> >     process_one_work+0x6fc/0x1180
> >     ? __pfx___schedule+0x10/0x10
> >     ? __pfx_process_one_work+0x10/0x10
> >     ? _raw_spin_lock_irq+0x81/0xe0
> >     ? __pfx_do_work+0x10/0x10
> >     ? assign_work+0x11d/0x410
> >     worker_thread+0x45b/0xd10
> >     ? __pfx_worker_thread+0x10/0x10
> >     kthread+0x2c8/0x3b0
> >     ? recalc_sigpending+0x15c/0x1e0
> >     ? __pfx_kthread+0x10/0x10
> >     ret_from_fork+0x36e/0x5a0
> >     ? __pfx_ret_from_fork+0x10/0x10
> >     ? __switch_to+0x572/0xdc0
> >     ? __switch_to_asm+0x33/0x70
> >     ? __pfx_kthread+0x10/0x10
> >     ret_from_fork_asm+0x1a/0x30
> >     </TASK>
> >    Modules linked in:
> >    ---[ end trace 0000000000000000 ]---
> >    RIP: 0010:free_rd_atomic_resource+0x15/0x50
> >    Code: 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90=
 0f 1f 40 d6 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 =
02 84 c0 74 04 3c 03 7e 0b c7 07 00 00 00 00 c3 cc cc cc
> >    RSP: 0018:ff110000013479f8 EFLAGS: 00000202
> >    RAX: dffffc0000000000 RBX: 0000000000000010 RCX: ff110000059f9760
> >    RDX: 0000000000000002 RSI: 0000000000000000 RDI: 0000000000000010
> >    RBP: 0000000000000001 R08: ff110000024a2180 R09: ffe21c0000268f2c
> >    R10: 0000000000000003 R11: ff110000059f9298 R12: ff1100000592dc00
> >    R13: 0000000000000040 R14: ff110000059f9000 R15: ff110000024a2168
> >    FS:  0000000000000000(0000) GS:ff110000e18da000(0000) knlGS:00000000=
00000000
> >    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >    CR2: dffffc0000000002 CR3: 00000000052ca000 CR4: 0000000000751ef0
> >    PKRU: 55555554
> >
> >    ------------[ cut here ]------------
> >    WARNING: drivers/infiniband/sw/rxe/rxe_pool.c:212 at __rxe_cleanup+0=
x21b/0x290, CPU#0: t028/87
> >    Modules linked in:
> >    CPU: 0 UID: 0 PID: 87 Comm: t028 Tainted: G      D             7.4.0=
-rc3-gaebb72744764 #1 PREEMPT(lazy)
> >    Tainted: [D]=3DDIE
> >    Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix=
, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> >    RIP: 0010:__rxe_cleanup+0x21b/0x290
> >    Code: f7 fe ff ff 4c 89 e7 e8 43 99 ad fd 84 c0 0f 85 6f ff ff ff be=
 50 c3 00 00 4c 89 e7 e8 9e 22 f3 00 85 c0 0f 85 5a ff ff ff 90 <0f> 0b 90 =
eb 04 90 0f 0b 90 bd 92 ff ff ff e9 48 ff ff ff 90 0f 0b
> >    RSP: 0018:ff110000053f78f8 EFLAGS: 00000246
> >    RAX: 0000000000000000 RBX: ff110000059f9160 RCX: ffe21c0000a7ef08
> >    RDX: 0000000000000000 RSI: ff110000053f7860 RDI: ff110000059f9190
> >    RBP: 0000000000000001 R08: 0000000000000001 R09: ffe21c0000a7eef5
> >    R10: 0000000000000003 R11: ffffffff89c14700 R12: ff110000059f9188
> >    R13: ff110000059f9170 R14: ff11000004794ea0 R15: 1fe2200000a7ef1f
> >    FS:  0000000000000000(0000) GS:ff110000e18da000(0000) knlGS:00000000=
00000000
> >    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >    CR2: dffffc0000000002 CR3: 000000001b872000 CR4: 0000000000751ef0
> >    PKRU: 55555554
> >    Call Trace:
> >     <TASK>
> >     ? __pfx___rxe_cleanup+0x10/0x10
> >     ? rxe_qp_chk_destroy+0x61/0xc0
> >     rxe_destroy_qp+0x2f/0x180
> >     ib_destroy_qp_user+0x30f/0x4f0
> >     ? __pfx_ib_destroy_qp_user+0x10/0x10
> >     ? stack_trace_save+0x8e/0xc0
> >     uverbs_free_qp+0x7c/0x150
> >     ? put_files_struct+0x181/0x310
> >     destroy_hw_idr_uobject+0x7e/0x130
> >     ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >     uverbs_destroy_uobject+0xdf/0x770
> >     __uverbs_cleanup_ufile+0x18b/0x390
> >     ? __pfx___uverbs_cleanup_ufile+0x10/0x10
> >     ? __pfx_down_write+0x10/0x10
> >     uverbs_destroy_ufile_hw+0x6d/0x260
> >     ib_uverbs_close+0x46/0x270
> >     __fput+0x2f8/0x9e0
> >     fput_close_sync+0xe2/0x190
> >     ? __pfx_fput_close_sync+0x10/0x10
> >     filp_close_sync+0x18/0x30
> >     put_files_struct+0x181/0x310
> >     do_exit+0x6ab/0x25f0
> >     ? __pfx_do_exit+0x10/0x10
> >     ? zap_other_threads+0xb9/0x300
> >     ? __pfx_zap_other_threads+0x10/0x10
> >     ? handle_mm_fault+0x13d/0x420
> >     do_group_exit+0xab/0x220
> >     __x64_sys_exit_group+0x39/0x40
> >     x64_sys_call+0x1962/0x1970
> >     do_syscall_64+0xdf/0x4c0
> >     entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >    RIP: 0033:0x7f34f928a21d
> >    Code: Unable to access opcode bytes at 0x7f34f928a1f3.
> >    RSP: 002b:00007ffeed584088 EFLAGS: 00000202 ORIG_RAX: 00000000000000=
e7
> >    RAX: ffffffffffffffda RBX: 00007f34f93a0fa8 RCX: 00007f34f928a21d
> >    RDX: 00000000000000e7 RSI: ffffffffffffff88 RDI: 0000000000000000
> >    RBP: 00007ffeed5840e0 R08: 00007ffeed584030 R09: 0000000000000000
> >    R10: 000055d8b71c93e0 R11: 0000000000000202 R12: 0000000000000001
> >    R13: 0000000000000000 R14: 0000000000000000 R15: 00007f34f93a0fc0
> >     </TASK>
> >    ---[ end trace 0000000000000000 ]---
> >
> > The responder task dies, and when the test exits, destroying the QP
> > warns on a timeout in __rxe_cleanup() (the WARNING above) and then
> > hangs.
> >
> > Add RXE_FLUSH_MASK to the check, so a FLUSH gets the same Invalid
> > Request NAK a READ would, and the requester sees IB_WC_REM_INV_REQ_ERR.
> >
> > The issue was found by Claude Opus 5.5 running Quality Playbook, an
> > LLM-driven code review tool:
> > https://github.com/andrewstellman/quality-playbook
> > The fix and this changelog were drafted with Claude Opus 5.5 and
> > reviewed by me.
> >
> > Fixes: ea1bb00ee9a5 ("RDMA/rxe: Implement flush execution in responder =
side")
> > Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>
> > ---
> >
> > v2: the full kernel log of the oops and the later WARNING, as Leon
> > asked (timestamps removed). The code change is the same as v1.
> > v1: https://lore.kernel.org/r/20261119151332.95466-1-astellman@stellman=
-greene.com
> >
> > Tested in QEMU with KASAN on v7.4-rc3, and on v7.4-rc3 with the RDMA
> > code from rdma for-next (7404c82cbf12). The reproducer is a short
> > libibverbs program; I can send it off-list.
> >
> >   drivers/infiniband/sw/rxe/rxe_resp.c | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/=
sw/rxe/rxe_resp.c
> > index 1b7f31737225..38b5b0c2abe3 100644
> > --- a/drivers/infiniband/sw/rxe/rxe_resp.c
> > +++ b/drivers/infiniband/sw/rxe/rxe_resp.c
> > @@ -340,7 +340,8 @@ static enum resp_states check_resource(struct rxe_q=
p *qp,
> >   {
> >       struct rxe_srq *srq =3D qp->srq;
> >
> > -     if (pkt->mask & (RXE_READ_OR_ATOMIC_MASK | RXE_ATOMIC_WRITE_MASK)=
) {
> > +     if (pkt->mask & (RXE_READ_OR_ATOMIC_MASK | RXE_ATOMIC_WRITE_MASK =
|
> > +                      RXE_FLUSH_MASK)) {
>
> This looks sensible to me=E2=80=94adding RXE_FLUSH_MASK here avoids
> rxe_prepare_res() / free_rd_atomic_resource() touching ZERO_SIZE_PTR
> when max_dest_rd_atomic =3D=3D 0 and returns the expected Invalid Request=
 NAK.
>
> Just worth confirming:
> (1) RXE_FLUSH_MASK takes the same error/NAK path here without later
> responder states assuming a valid qp->resp.res or non-ZERO_SIZE_PTR
> qp->resp.resources, and
>
> (2) no other RXE_READ_OR_ATOMIC_MASK / RXE_ATOMIC_WRITE_MASK checks in
> rxe_resp.c for max_dest_rd_atomic or responder resources missed
> RXE_FLUSH_MASK.
>
> Thanks a lot.
>
> Zhu Yanjun
>
> >               /* it is the requesters job to not send
> >                * too many read/atomic ops, we just
> >                * recycle the responder resource queue
> >
> > base-commit: 7404c82cbf1246e0e84e2ec21834d23c26f9a8ed
>
