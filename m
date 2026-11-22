Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795325554;
	b=jVp8Up9eeo/w/BFNB1x4nsQgTJmTyNtvSBDNx2g0ZZGd9WLE1KzLyV3n0nSX8btzpRnl
	 +0aNiujRWGaH6BuK+oTbh2G72yy6C7PKdPvuxov3EgNv2HFaRNB1LIwJKIdd/1w+62bOH
	 9fyXB8XCrdaplwKj//d6Mf8xiWQ+OjQgqwXz41joB0ZKlejbufHcNgCkV5abI6sPNv+NL
	 Umn0+jMZM6Y7VyiE66Rm9U6q+z3mitXikr7voLeiXmYDIdHvvTje87LCuu2o2YKZyyww6
	 F4w2Zff5XsH2vVGc5mI/xzOidZ1X4g1XEaVXXiQOcoqWpB8ygZZUB86zmCIzxOeq5cA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795325554;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=kmj+nrDmJf/nt8k5l8za4Rv321FM1aLPUbg8EmSjASY=;
	b=XYYF3OJ3236IOjfHM8WexLqWJLTAKXkVqu397xUnQA1LNdcX5F4tfuJaA1ELnmNVSyT4
	 ZgSo42tPd2dYVZstr96ViRpYUCm8BcY1fezCUOSVom3dMPGO56RaTRvdi59kSmznnVB8z
	 TgQhdVI6sfnFYJca5luLA1zqyd20a7j8wCGUrwP0IRoWLYjUBCsh+YEb2DfVzRzzR7K7p
	 2TDjy5zV2Me7y3J0M4XmvLrNpgBXgh71sihJ5FjD7nrCvP/h4dwJsjgy6f0wdZzhCM+Lc
	 RSeX8h5/yd8yetK1HIIfns0s/9ibW4w22N9aQO4u+fi4yKWa0ZHMn+INAVzHhUrSYQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iiitd.ac.in;
	spf=pass smtp.mailfrom=iiitd.ac.in;
	dkim=pass header.d=iiitd.ac.in header.i=@iiitd.ac.in header.a=rsa-sha256 header.s=google header.b=cGmC9+HR;
	arc=none smtp.remote-ip=209.85.216.54
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF46606A32C
	for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 05:32:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2CF46606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iiitd.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iiitd.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iiitd.ac.in header.i=@iiitd.ac.in header.a=rsa-sha256 header.s=google header.b=cGmC9+HR
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3b0bbdeae06so1076957a91.1
        for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 21:32:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=iiitd.ac.in; s=google; t=1795325551; x=1795930351; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kmj+nrDmJf/nt8k5l8za4Rv321FM1aLPUbg8EmSjASY=;
        b=cGmC9+HRXOvfEi+XbJuDZzzSyZ9UdraQVb/v52QWWGmRuFXxQLd09TpYDFA8UWisgT
         3KGt9q+KMrwYFrtsA1+r9XVfSwmoNFc2c00IYtxXJ4gFb2+44jEmNXcpvmXOOjkDoLm8
         pgByTnc7NCeVGi9sk5iDaVmFZQK+nVzejr6zU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795325551; x=1795930351;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kmj+nrDmJf/nt8k5l8za4Rv321FM1aLPUbg8EmSjASY=;
        b=VSmb9+oBY+E65NuRj94g7uQ2MP68Cj+AgmG+bbrHScDqncix+va/EX8P1QJum7NzZx
         0fAaP4LIOTeqIJ+IMb9GEWFkl/gCn8u1AuVAEdLRExUpv0R0QBCX7QAo3KYK99/LLK+5
         ywSDoqFarSl7859b4q0ETmONb6+ZpfZnFvNLvwlaBoYoQ7Y/RcmyjE7SYF3j3cXMuZ3N
         lo5wA5sYDDlu4NopmSJsM2qFPWn2uOJKxC+wVGB3ZoSn2iPNcEY6FpRCoE5OzOPuJrtk
         jMdWFM8XQrMDU77xwEKD85K9cTTxc05eKagu0lgAr6OaAupW11vBX38itLFmMHBMpFXc
         e8Ow==
X-Forwarded-Encrypted: i=1; AL+hErFXDR6O0FiYNf9bn81CpPt/Ngn6RwA+xJ2ogGzNCL6amR8L54HtK5q1zHCyHkcyVz4H/GVznDPZ4jbm@vger.kernel.org
X-Gm-Message-State: APuU4Z8Ao+ERFR7aszTVTtpYilLf3wJYMqriWmc3BC0eAJIKqCEHePJK
	tZtF11MsWNT17nSFFIsXEjgxK3qK14KKQHjG/kPbbJw23cf/dpX6rCyD7VaeRilSqG4=
X-Gm-Gg: AZFdTZfdxXpiiWRKV1yNK5AATYkAL7XkmdpUDv4qrUAWrw3etVj/rgckg0wFOJJtUzv
	OgQ/26oq64Q3Vk9Agb1/6kIGFVueQgONDkQfGtI5cGMpNO9CG9dBnfoehhqryUD8MIWC2R70Mm7
	R2RJE3vdeB4QfrmtaDkWAUr4UGbQlJ5CLKrQyXmaVoYAlddhJb3AQSeNuH0jsJkKYIom26PCyAf
	MCLB5kZoEtNxrMPe/LQtGCu9braSlvoSG4vRnqwoyTtq8V7RO1y86DDDfNLJEfapcEls/gpS1Ye
	d/9wcoUv9HA+C1yAqrjlZLjYKYjKC/B6coBNfgSI5PtYRA3Ngj62otNdxTOqGCaYybtJfc3ijp/
	85cBu/OUVsNrUqDKmDdI04d+tXnYVVH6oXhJUHZP9PHOzIUxepJsmqEuIBbEt1sxfOFo5e6VuUf
	2ng7jaBdEubI4BFWzDblytZPVoeXcfXLnkfF/J5AggILVGfyCBQ5Oc6mOHxbajQuu2vx1j3unFS
	4xjxBTWmJqfQpnQqVvJHWAjiyAtAz8tk60kPFJgeoVngshiJTM7nZZkTi/p09Qe4FQcmN91V4WS
	GddgDIfvjOK0yOT92wSlSoj9+k0684f9GgEM/Mbjw3EmHW+XiiEjhtmaWlRY+To9ApjALGBqAns
	IdvsdVVzbaZvclk2pigXCz8zuI/O5x4Jdl8UlDKlY0EDZX51sRKE98B+mkNV9J9E4
X-Received: by 2002:a17:90b:1802:b0:3ac:a139:1b13 with SMTP id 98e67ed59e1d1-3b41c93ccf9mr7444107a91.29.1795325551382;
        Sat, 21 Nov 2026 21:32:31 -0800 (PST)
Received: from iiitd-S2600STB.iiitd.edu.in ([103.25.231.160])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405d135e9sm14076748a91.4.2026.11.21.21.32.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 21:32:30 -0800 (PST)
From: Piyus Kedia <piyus@iiitd.ac.in>
To: alibuda@linux.alibaba.com,
	Dust Li <dust.li@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	netdev@vger.kernel.org
Cc: Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kapil Vaswani <kapil@presceralabs.ai>
Subject: [BUG] net/smc: out-of-bounds WRITE of 869056 bytes into a 65504-byte send buffer, from a peer-credited sndbuf_space (SMC-D DMB-nocopy)
Date: Sun, 22 Nov 2026 11:02:22 +0530
Message-Id: <20261122053223.2497832-1-piyus@iiitd.ac.in>
X-Mailer: git-send-email 2.34.1
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

Hi,

A second finding in net/smc, on the transmit side this time.  

Summary
=======

Affected: net.git main at d5b89d55a322 and the 7.3.1 tree we work on.

Problem: smc_tx_sendmsg() clamps the first of its two ring chunks against
the send buffer and the second not at all, so the copy is bounded only by
conn->sndbuf_space.  On the SMC-D DMB-nocopy path that counter is credited
from the peer's consumer cursor.  A peer that reports an oversized cursor
therefore makes memcpy_from_msg() write sendmsg() data past the end of the
send buffer.

Relationship to the other report: the cursor itself is what our other patch
("net/smc: validate the peer's CDC cursors against our own buffers", v2)
validates, and with that applied the known way to inflate this counter is
closed.  We are still reporting this separately because the bound
smc_tx_sendmsg() needs is its own: nothing at the copy says the length fits
the buffer, and a reader of the second chunk has to go and prove it
elsewhere.  Take this as hardening if you prefer - we would rather send it
than assume the cursor check is the last word.


1. Root cause
=============

net/smc/smc_tx.c:235-265, smc_tx_sendmsg():

	writespace = atomic_read(&conn->sndbuf_space);
	/* not more than what user space asked for */
	copylen = min_t(size_t, send_remaining, writespace);
	/* determine start of sndbuf */
	sndbuf_base = conn->sndbuf_desc->cpu_addr;
	smc_curs_copy(&prep, &conn->tx_curs_prep, conn);
	tx_cnt_prep = prep.count;
	/* either unwrapped case, or 1st chunk of wrapped case */
	chunk_len = min_t(size_t, copylen, conn->sndbuf_desc->len -
			  tx_cnt_prep);
	chunk_len_sum = chunk_len;
	chunk_off = tx_cnt_prep;
	for (chunk = 0; chunk < 2; chunk++) {
		rc = memcpy_from_msg(sndbuf_base + chunk_off, msg, chunk_len);
		...

and for the second iteration (:263-265):

		chunk_len = copylen - chunk_len_sum;	/* remainder */
		chunk_len_sum += chunk_len;
		chunk_off = 0;				/* modulo offset in send ring buffer */

The first chunk cannot pass the end of the buffer because it is clamped to
sndbuf_desc->len - tx_cnt_prep.  The second is the remainder of copylen with
no clamp, written at offset 0.  So the total written is copylen, and copylen
is bounded only by writespace.


2. Why sndbuf_space is not ours
===============================

For SMC-R, and for SMC-D in the copying mode, the counter is credited from
cursors this side computed - smc_cdc_tx_handler() and the tail of
smc_cdc_msg_send() use conn->tx_curs_sent - and is safe.

The exception is the DMB-nocopy path.  net/smc/smc_cdc.c:356-370:

	if (conn->lgr->is_smcd &&
	    smc_ism_support_dmb_nocopy(conn->lgr->smcd)) {
		diff_tx = smc_curs_diff(conn->sndbuf_desc->len,
					&conn->tx_curs_fin,
					&conn->local_rx_ctrl.cons);
		smp_mb__before_atomic();
		atomic_add(diff_tx, &conn->sndbuf_space);
		/* guarantee 0 <= sndbuf_space <= sndbuf_desc->len */

conn->local_rx_ctrl.cons is the peer's consumer cursor, taken from the CDC
message.  The comment states the invariant smc_tx_sendmsg() depends on; the
add does not establish it, and before our other patch nothing on the way
here compared that cursor with any buffer length.  On SMC-D in particular
smcd_cdc_rx_tsklet() reads the cursors out of the DMB the peer writes into
with no validation at all.

Two details that matter for judging it:

  - The nocopy sndbuf is the peer's DMB.  smcd_buf_attach()
    (net/smc/smc_core.c:2622-2650) attaches the peer's DMB and then does

	buf_desc->cpu_addr = (u8 *)buf_desc->cpu_addr +
			     sizeof(struct smcd_cdc_msg);
	buf_desc->len -= sizeof(struct smcd_cdc_msg);

    so an overflow of this buffer runs off the end of that DMB mapping, and
    sndbuf_desc->len equals the peer's RMB size - which is why a single
    bound on the consumer cursor covers both uses of it.
  - The data written is the local application's own sendmsg() payload.  The
    peer chooses the length; the sender chooses the bytes.

CONFIG_DIBS_LO advertises nocopy support (dibs_lo_support_dmb_nocopy()
returns DIBS_LO_SUPPORT_NOCOPY), so the branch is live on an ordinary
x86_64 kernel, not only on s390 ISM hardware.


3. What we observed
===================

A hostile peer is what the bug needs, and the only SMC-D device we have is
the loopback-ISM (dibs) device, where both ends are the same kernel and every
cursor is therefore kernel-generated and in range.  Userspace cannot write
the cursor either: the CDC sits at the base of the DMB, smcd_buf_attach()
starts the ghost sndbuf past it, and SMC sockets are .mmap = sock_no_mmap.

So we stood the peer in with a debug patch that overrides the consumer cursor
in smcd_cdc_rx_tsklet() AFTER validation - nothing else is changed, and that
is precisely the state the send path has to survive on its own: a credit it
did not compute.  simulated-peer-debug.patch in this directory is that patch
plus the two pr_info()s quoted below.

The credit goes out of range exactly as the code says it can:

  SMC2DBG diff_tx=1000000 space_before=65504 sndlen=65504 cons=1000000
  SMC2DBG diff_tx=1065504 space_before=0     sndlen=65504 cons=1000000

conn->sndbuf_space reaches 1065504 on a 65504-byte send buffer.  One
sendmsg() of 4 MB then turns that into an oversized copy, and the second
chunk is written at offset 0 with the remainder:

  SMCTXDBG chunk=0 off=0 len=65504  sndlen=65504  in bounds
  SMCTXDBG chunk=1 off=0 len=869056 sndlen=65504  past the end

  ==================================================================
  BUG: KASAN: use-after-free in _copy_from_iter+0x197/0xfd0
  Write of size 869056 at addr ffff888057980020 by task b/9467

   _copy_from_iter+0x197/0xfd0
   smc_tx_sendmsg+0x1011/0x12c0
   smc_sendmsg+0x1a2/0x2a0
   sock_sendmsg+0x19d/0x270
   __sys_sendto+0x22a/0x300

The full report is in
kasan-smc-tx-sendmsg-oob-write-mainline-7.4-rc3.txt.

With the patch applied and the same injected credit, every chunk stays inside
the buffer (len 65504 or less, and no second chunk past the end), KASAN is
silent, and an 8 MB transfer over the same connection completes with its
contents verified - so the clamp does not break a correct sender.

What this does and does not establish.  It establishes that an out-of-range
credit becomes an out-of-bounds write of attacker-chosen length, and that the
patch stops it.  It does not establish that a real SMC-D peer can produce
that credit - for that you need an ISM device, and the cursor's path from
the wire is the one our other patch validates.  We would rather you weigh
this knowing exactly which half was simulated.


4. Impact
=========

Stating only what the code shows, since we have no run to point at:

  - An out-of-bounds WRITE, not a read: memcpy_from_msg() into
    sndbuf_base + chunk_off for a length the peer influences - 869056 bytes
    into a 65504-byte buffer in our run.
  - The attacker is the remote SMC-D peer.  No local privilege is involved;
    the local application is an ordinary sender.
  - The bytes written are the local sender's payload rather than the peer's,
    which limits what a peer can place there but not where it lands.
  - Reachable only with CONFIG_SMC, an ISM/dibs device whose
    support_dmb_nocopy() is true, and an SMC-D connection to that peer.

We are not claiming an exploit, and we have not looked at what follows the
DMB mapping.


5. Reproducer
=============

There is no reproducer that uses only unmodified kernel interfaces, for the
reasons in section 3: the cursor cannot be forged from userspace on the one
SMC-D device we have.

What we can send, to anyone who wants to repeat the run: the debug patch that
stands in for the peer (simulated-peer-debug.patch, 70 lines, including the
two pr_info()s) and the SMC-D bulk-transfer program it is driven with.  The
program needs CONFIG_SMC, CONFIG_DIBS_LO and KASAN, and a registered UEID -
without one the SMC-Dv2 handshake declines with 0x03030008
(SMC_CLC_DECL_NOUEID) and silently falls back to TCP.


6. Suggested fix
================

Attached: 0001-net-smc-bound-a-send-against-the-send-buffer-not-aga.patch

One line: clamp copylen to conn->sndbuf_desc->len after it has been clamped
to what userspace asked for.  That bounds the copy at the point the copy is
made, whatever the credit says, and changes nothing for a correct peer.

The alternative is to cap the credit at the atomic_add(), which would
enforce the invariant the comment there states.  We are happy to send that
instead, or both; we chose the clamp because it is local to the code that
has to be safe.


7. What was and was not checked
===============================

  - The patch builds and net/smc/smc_tx.o compiles clean on net.git main at
    d5b89d55a322 with clang and KASAN.
  - SMC-D traffic over loopback-ISM works with it applied (section 3).
  - The three receive-side faults in our other report still do not fire on
    the kernel carrying both patches.

Not checked:

  - Real ISM hardware, or any SMC-D peer that is not this kernel.
  - The write side on SMC-R, where sndbuf_space is credited from our own
    cursors; we believe it is not reachable there and are not claiming it
    is.
  - Whether a peer can steer what the overflow lands on.

How this was found: by AI-driven fuzzing built on top of syzkaller.  Its analysis was then checked by hand against the code, and the credit inflation in
section 3 measured.  The out-of-bounds write was not reproduced.


Thanks,
Piyus Kedia
Kapil Vaswani
