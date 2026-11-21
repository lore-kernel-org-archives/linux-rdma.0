Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795289639;
	b=dljsLXld2Lx2wTYqfCZJ2PdZGh8GhgQcutXBu9t6BnqqRVzdY3yD+eb3GiCEDdzR1REe
	 vvU95qLT0J5p1X5K6fO8Kbh4zn0hWddMJrbgCqIJGg1FhZUD56PcypvPN5C91hfx44Rwl
	 liFLqaYohecsoKrCEeKkOrZuz+JvDfFupl9EGLgkreUleBirpR5g3eeK6HtkcwtdOBWSX
	 FMkG5U+eYtZR7EXujS2iJb4li1S2gjP56LDROW0HdtP7UapccvTS7/6Pi7Enpaz/nB2+a
	 vK9CYyGZi+NwyRpcQFXQmRZrZgg7BjXi88qOgtpiwwg0NgWZ1uJMEj6mRDRV0W7ZPrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795289639;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=if0ew/z5STCpjefJ5fbSLDa//gw5WIwzKQdST4SZPW0=;
	b=feZXt5koTZvb5Pk4AA+MIbKHye6NBvyy7MK3bDuZIVf2twdpkT7IbTRxRALQh/HSrb4c
	 vv8zRTxtG8ZcyWzgtCJGpqV1yUSv4A5CiLf4oc4h95unKBOm4AAYR8mlyT1slJwZp2AM0
	 GabYeN2SHqqBwtiPrVpl5OW8tTXyqtQsxtIrruVLa4RkCcCHc80FfgxmlerqAV/lJH1zO
	 9RR4RweqarpgnzIuDCr4j1Ej3GP5XhC8/a2wUje5jImYEZxgYrRzQimwf1Rm6Llg7VQQy
	 cO8XBKdOWg2j/kBi29mlpw6C6SgLVPrhbvSxjG4tfWCJmjxX3FLbSG30e6w0MQrmZQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iiitd.ac.in;
	spf=pass smtp.mailfrom=iiitd.ac.in;
	dkim=pass header.d=iiitd.ac.in header.i=@iiitd.ac.in header.a=rsa-sha256 header.s=google header.b=UHmKFWjG;
	arc=none smtp.remote-ip=209.85.216.52
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F589606A32A
	for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 19:33:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1F589606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iiitd.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iiitd.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iiitd.ac.in header.i=@iiitd.ac.in header.a=rsa-sha256 header.s=google header.b=UHmKFWjG
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3b44bdcea8aso476870a91.1
        for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 11:33:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=iiitd.ac.in; s=google; t=1795289634; x=1795894434; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=if0ew/z5STCpjefJ5fbSLDa//gw5WIwzKQdST4SZPW0=;
        b=UHmKFWjG8sv2BETgsXhvCjTd1ql+kCBbp9vU2mejZOKVRwi0tsDhUNzxIMeoK+cmiV
         n/22awPWVTjx2bkt52g79Ys7RPxIyrPeIqFuFFp/OjcRMTw8E8BlRBGVQWxkucBAJ2ao
         a6f6nBP2OpBuehTN5Oa2UmhnsiJXBWZVkLwuY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795289634; x=1795894434;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=if0ew/z5STCpjefJ5fbSLDa//gw5WIwzKQdST4SZPW0=;
        b=YMmy499IupHqyDrpBb2jgdNQ2eVm9CO73HXM7xX6b6hpyNs8bMpMfaagLXlY7voaW7
         Q5DYUSxsE9yZNSMXfK62LeiExPI52DC0Da2C79mAIZvG1rWMG8sGVZ1YXB+N9fa7o74X
         cwzFS3BxfAfQjYpH3upBVFiIDkqocuIAXr0kX+UbP4ZCiakYXpkEhz7LKCckMO3kXfUr
         MehcAVpoj/DQ0gjZow19JuaG3lUFHwRjlUZIJ5BWO71qhK/kUMm5gwysxKqpAp8ZZ2hQ
         K65rPIu2Q64FHqOGJETzrHZX75Mo4QOUAsd8zn5OtkLlacuUH1iBewiJQF7+rDW9PKo0
         KpVw==
X-Forwarded-Encrypted: i=1; AL+hErF6MbgnlOpr72+6rZEc0EWQlOzTJUnl0UMOIX7H9ISNPb+55MLAHsslbf3P3t627XF+1I23riKn1i4C@vger.kernel.org
X-Gm-Message-State: APuU4Z9AOzx/ujR5rXSH3InAv39r8wjO938gXnL2DMwsvWjM3nqcni/x
	isBRcpcGiEJKSTLzq98iC9kalyjwgyY93q2lyaamYuvqNq/UWV6uGrZkwRa11FBVJec=
X-Gm-Gg: AZFdTZeySXcFYu0iTOUdBHOdR6e2tpVHCEe4nQbyhYK2X2KjsiDm+kZwuHjdaSw7s5L
	At2JqnE4N0rhmJ+w52ZNx20/5eXWwOialMWCMaAREukho9al7J5niDJRPWuHnkS6nIT5Z/fzfAc
	bdGRU4BOxR5NI/CDoyCZYeBxtvwQ1plLQk8iq+RLoC/wdLbKcavIf/L5z3kU4CuCBq7k6mUQLjO
	nHjINSZW93tK15h3P10ZsKenGdu/dDJ4nsHypwuy65WKGbPXVZDDAEaDiwkAKrdAdDUk4xOqvue
	Z+M2Nm/XH2bCSh7AKUAFTv0W4IQ5j7oULKQFMF3Ogd9VjMxsxr9VYnCQ2sIs9vE/+1RhXrrt0Xv
	03epBcA+TIgpYAQQWDIFuXOOc1BmZp4rjkDOwKQH6OEToY1Tq4wOj0YZCsHuniCClew9EBqDMsA
	vQol2QiKGnQEz08BzUQJi7P/FN2uuRw4X3dsy6TRGtA3doJtiwMMaD7arB0wR9GV4oNCIHJC/TD
	sRCUrm9xLA5xJa4/QVt/ytcFleOgvEFXwOu1L5beZR/xRlBL1OQ/hjA8d5hjppuroCbJ+xiEfRF
	2FXdzZZKsX+88T+TUSqa4M0DKyqUSUy79aKlg8UFi/j9gCwnOX7aD52kfIobCSyxYqmQoEzvquh
	x5Eu6WEX/h1S5lm3uLAfEesoCo64j6SdxJTwPlGTWXuNAy7+jaxjLOUwowfNNGMO5
X-Received: by 2002:a17:90b:2e4b:b0:3ab:330d:6e47 with SMTP id 98e67ed59e1d1-3b41c8e0ce5mr4208739a91.10.1795289634351;
        Sat, 21 Nov 2026 11:33:54 -0800 (PST)
Received: from iiitd-S2600STB.iiitd.edu.in ([103.25.231.160])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b44b217a5bsm2686818a91.0.2026.11.21.11.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 11:33:53 -0800 (PST)
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
Subject: [BUG] net/smc: out-of-bounds read of up to 128 KiB past the RMB from an unvalidated peer CDC cursor, reaching userspace via recvmsg (seen on 7.4.0-rc3)
Date: Sun, 22 Nov 2026 01:03:44 +0530
Message-Id: <20261121193345.2148966-1-piyus@iiitd.ac.in>
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

We would like to report two out-of-bounds reads in the SMC-R CDC receive
path, both from the same cause.

Summary
=======

Affected: reproduced directly on net.git main at d5b89d55a322, i.e. on
7.4.0-rc3, as well as on the 7.3.1 tree the bug was first seen on.  The
relevant code is unchanged between the two.

Problem: a CDC message carries two cursors that are offsets into buffers on
*our* side.  The producer cursor counts the bytes the peer has written into
the RMB we published to it; the consumer cursor counts the bytes it has
taken from the RMB it published to us (conn->peer_rmbe_size).  Neither is
validated anywhere.  Three separate
consumers then treat them as trustworthy, and the worst case is a 128 KiB
read past a 64 KiB RMB whose bytes are copied to userspace by recvmsg().


1. Root cause
=============

smcr_cdc_msg_to_host() (net/smc/smc_cdc.h:241-252) copies both cursors out
of the wire message into the connection as they arrive:

	smc_cdc_cursor_to_host(&local->prod, &peer->prod, conn);
	smc_cdc_cursor_to_host(&local->cons, &peer->cons, conn);

smc_cdc_cursor_to_host() byte-swaps and copies.  It compares the new cursor
with the old one to drop a stale update, but it never compares either with
the length of the buffer that cursor indexes.  Nothing else does either, and
from there three users consume the value:

  (a) net/smc/smc_cdc.c:376-386, smc_cdc_msg_recv_action():

	diff_prod = smc_curs_diff(conn->rmb_desc->len, &prod_old,
				  &conn->local_rx_ctrl.prod);
	if (diff_prod) {
		if (conn->local_rx_ctrl.prod_flags.urg_data_present)
			smc_cdc_handle_urg_data_arrival(smc, &diff_prod);
		atomic_add(diff_prod, &conn->bytes_to_rcv);
		/* guarantee 0 <= bytes_to_rcv <= rmb_desc->len */

      The comment states the invariant the rest of the path relies on.  The
      code does not establish it: diff_prod is a difference of two cursors,
      one of which the peer chose, so it is only bounded by rmb_desc->len if
      the peer's cursor was.

  (b) net/smc/smc_cdc.c:300-302, smc_cdc_handle_urg_data_arrival():

	base = (char *)conn->rmb_desc->cpu_addr + conn->rx_off;
	if (conn->urg_curs.count)
		conn->urg_rx_byte = *(base + conn->urg_curs.count - 1);

      An unbounded index into the RMB, read in softirq context.

  (c) net/smc/smc_rx.c:506-537, smc_rx_recvmsg().  The first of the two ring
      chunks is clamped to the buffer:

	chunk_len = min_t(size_t, copylen, conn->rmb_desc->len - cons.count);

      and the remainder, used for the second chunk, is not:

	chunk_len = copylen - chunk_len;	/* remainder */
	chunk_off = 0;

      copylen derives from bytes_to_rcv, i.e. from (a), so an inflated
      producer cursor becomes a copy length.

So one unchecked field yields a one-byte read at an attacker-chosen offset
and a bulk read whose length the attacker also chooses.


2. Why the peer's cursor is not already bounded
===============================================

The natural objection is that cursors are ring positions and therefore
self-bounding, so we want to be explicit about why they are not.

A cursor is a {wrap, count} pair, and count is an absolute byte offset into
the buffer, not a value reduced modulo its length.  smc_curs_diff() and
friends take rmb_desc->len as an argument precisely because the arithmetic
needs the length supplied from outside the cursor; nothing in the cursor
itself constrains count.  On the wire it is a plain __be32
(union smc_cdc_cursor, net/smc/smc_cdc.h:27-38), so every value up to
2^32-1 is representable.

The receive handler does validate the message, which is what makes the
omission visible: smc_cdc_rx_handler() (net/smc/smc_cdc.c:477-503) checks
wc->byte_len, rejects cdc->len != SMC_WR_TX_SIZE, drops a connection that is
out_of_sync, and compares seqno for staleness and failover.  The cursors are
the one attacker-controlled field in the message that is carried through
unchecked.

We also want to be clear that this is not a trusted-input argument.  The
cursor arrives in a CDC message from the remote end of the connection.
Writing an oversized producer cursor is not a protocol violation a peer has
to work at; it is one field in the message it already sends normally.


3. KASAN reports
================

Both from 7.4.0-rc3-01151-gd5b89d55a322, x86_64, KASAN, under qemu.  The
parts that matter are quoted here; we kept the full logs, including the
allocation traces and the shadow-memory dumps, and will send them to anyone
who wants them rather than attach them to this mail.

The receive path, consumer (c) above.  This is the one that reaches
userspace:

  BUG: KASAN: slab-use-after-free in _copy_to_iter+0x1be/0xff0
  Read of size 131072 at addr ffff888063540000 by task r/9455

    _copy_to_iter+0x1be/0xff0
    smc_rx_recvmsg+0x10ae/0x25a0
    smc_recvmsg+0x1f1/0x360
    sock_recvmsg+0x116/0x140

The urgent-data path, consumer (b), read in softirq context:

  BUG: KASAN: slab-use-after-free in smc_cdc_msg_recv+0xb58/0x11d0
  Read of size 1 at addr ffff888024420000 by task ksoftirqd/0/16

   >ffff888024420000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb

smc_cdc_handle_urg_data_arrival() is inlined into smc_cdc_msg_recv() in this
build, which is why the symbol in the trace is the caller.

Two notes on reading these reports:

  - KASAN says "slab-use-after-free" rather than "out-of-bounds".  The RMB
    is a 64 KiB order-4 page allocation, so the memory immediately past it
    is not a redzone of the same object but a separate, freed page.  The
    access is nonetheless simply past the end of the RMB.

  - Both reports carry "Tainted: G W".  That W is unrelated to this bug and
    to our changes: it is a warning at arch/x86/kernel/smpboot.c:718
    (topology_num_nodes_per_package() == 1) that this qemu machine type
    trips at 0.068s on every boot, including pristine kernels.  We mention
    it so it is not mistaken for a side effect of the test.


4. Impact
=========

Stating only what we verified, and our reading of
Documentation/process/threat-model.rst - please correct it:

  - The cursor is peer-supplied.  The attacker in the threat model is the
    remote end of an established SMC-R connection, or anyone able to inject
    RoCEv2 to the queue pair.  That requires no privilege on the victim; it
    is the peer's ordinary role in the protocol.

  - The receive-path read is delivered to userspace.  _copy_to_iter() is the
    copy into the application's buffer, so the out-of-bounds bytes - up to
    128 KiB past the RMB in our run - are returned by recvmsg() to a local
    process that needs no privilege at all and has done nothing unusual.
    We treat that as an information disclosure of whatever follows the RMB,
    not merely a crash.

  - The urgent-data read is one byte, taken in softirq context into
    conn->urg_rx_byte, and is exposed to the application only as
    out-of-band data.  Its practical value to an attacker is an oracle
    rather than a bulk leak, but the index is attacker-chosen.

  - Our reproducer simulates the peer locally, and that does need privilege:
    CAP_NET_ADMIN to create the rxe device (RDMA_NLDEV_CMD_NEWLINK is
    RDMA_NL_ADMIN_PERM) and to add the SMC UEID (GENL_ADMIN_PERM), and
    CAP_NET_RAW to inject the forged RoCEv2 frame.  So the reproducer's own
    path does not cross a privilege boundary; the remote peer's does.

  - We checked whether a sandbox could do this instead, and report the
    result rather than a conclusion.  An ordinary user in its own user and
    network namespace cannot: netlink_capable() resolves CAP_NET_ADMIN
    against &init_user_ns, so rxe creation is refused and the reproducer
    never reaches SMC at all.  A container holding real CAP_NET_ADMIN and
    CAP_NET_RAW did reach an established SMC connection inside its own
    network namespace, but SMC_DIAG reported mode=SMC_DIAG_MODE_SMCD there,
    i.e. it had picked the loopback-ISM device rather than RoCE, so our
    forged RoCEv2 frame was simply irrelevant to that connection and no
    conclusion about the namespace follows.  We have not demonstrated the
    container case and are not claiming it.

We are not claiming an exploit beyond the disclosure above, and we have not
attempted to influence what is placed after the RMB.


5. Reproducer
=============

Tested, and deliberately not included.  security-bugs.rst says an
AI-assisted finding must be treated as public but its reproducer must not
be, so we are happy to send it to any maintainer who asks.

So you can judge whether to ask for it: two short C programs, no external
dependencies and no RDMA hardware.  Each stands up soft-RoCE (rxe) over lo,
opens an SMC-R connection to itself, reads the connection's tokens via
SMC_DIAG and the queue pair's QPN and PSN via RDMA netlink, then injects one
forged RoCEv2 RC SEND carrying a CDC message whose producer cursor exceeds
rmb_desc->len.  One then calls recvmsg() (the 128 KiB read), the other sets
the urgent-data flag (the one-byte read).  They need CONFIG_SMC,
CONFIG_RDMA_RXE and KASAN.


6. Suggested fix
================

Attached: 0001-net-smc-validate-the-peer-s-CDC-cursors-against-our-.patch

It validates both cursors in smc_cdc_rx_handler(), beside the existing
length and seqno checks, and drops the message if either is outside the
buffer it indexes.  A cursor equal to the buffer length is a legitimately
full ring, so only a larger one is rejected.

We chose one check at the point of acceptance over clamping in the three
consumers deliberately: the cursor is attacker-controlled input, the three
current users are not obviously the last, and a clamp leaves each future
reader to remember the bound.  It also keeps the fix away from the receive
fast path.

Two choices in it you may want to overrule:

  - We drop the malformed message (goto out), following the precedent of the
    cdc->len check a few lines above.  Treating an impossible cursor as a
    protocol error and aborting the connection - as the seqno failover check
    does via conn->out_of_sync - is equally defensible and arguably better,
    since a peer that sends one is broken or hostile.
  - We placed the check after the seqno comparison, so a stale message is
    still dropped as stale rather than as invalid.

We did not add a WARN or a ratelimited log; if you would like the event
counted, say where you would prefer it.


7. What was and was not checked
===============================

Verified at runtime on net.git main itself.  The kernel was built from
d5b89d55a322 with the config we use for this work plus KASAN, CONFIG_SMC,
CONFIG_SMC_DIAG, CONFIG_RDMA_RXE and CONFIG_INFINIBAND_USER_ACCESS, clang,
and no instrumentation beyond KASAN, so net/smc is exactly as shipped.  It
was booted by hand under qemu against the same unmodified rootfs image each
time, with the image opened read-only (-snapshot).  The only difference
between the two kernels is net/smc/smc_cdc.c:

  unpatched  7.4.0-rc3-01151-gd5b89d55a322      #3
  patched    the same tree plus the attached patch  #5

                       recvmsg reproducer   urgent-data reproducer
    unpatched (#3)     KASAN                KASAN
    patched   (#5)     no report            no report

The clean runs are not setup failures, which is the thing worth checking:
each reproducer prints every step it takes, and in all four runs SMC_DIAG
reported the connection established as SMC-R on both ends - state=1,
mode=0 (SMC_DIAG_MODE_SMCR), fb_reason=0x0, so nothing fell back to TCP -
with the tokens exchanged in both directions, and each injected the same
forged frame.  The only difference between the rows is the report.  The
patched kernel also carried ordinary SMC-R traffic in those runs, so the
new check does not reject the cursors of a correct peer.

Also checked, and not being reported:

  - SMC-D.  smcd_cdc_msg_to_host() takes the same cursors from a different
    transport, and the consumers (a)-(c) are shared, so we expect the same
    exposure there.  We have no ISM device to test with and are not
    reporting what we cannot run; the attached patch deliberately touches
    only the SMC-R handler, and if you want the SMC-D path covered too we
    would rather you say where.

No Fixes: tag, deliberately.  The missing bound is not a regression from a
single commit: smc_cdc_cursor_to_host() has never checked the cursor, and the
three consumers arrived at different times.  If you would rather have a
specific commit named - the one that introduced the consumer you consider the
bug, or the original SMC-R merge - say which and we will add it in v2.

Not checked:

  - Real RoCE hardware.  Everything here is soft-RoCE over lo.
  - Whether the disclosed bytes can be steered to anything chosen by the
    attacker.
  - Any kernel older than 7.3.1.

Both reproducers and the full console logs are available on request.

Thanks,
Piyus Kedia
Kapil Vaswani
