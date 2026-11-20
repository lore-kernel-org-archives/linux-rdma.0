Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795133316;
	b=A6RcCchzhdu9IVcnOtsTd9sB6pipBlDlC1a8xwffyFmEfclyR3HXYg4y/sH/wFu5Ks49
	 Tr3xn1bTHHG5B+c9/G9L/K4rsq/eo9tmHkMkgISWqv4es0ejE9ivWHos/uJToIyk+U0nh
	 QSuRteYt01O2CXBtib2rVqSYYxI5E1UUvFspqoT8MjURBTMXB0uVtARVDMS1PJbX2rrcd
	 +IeWurYz3AYjhVj1RenBzizhrlHXPoaWXqA8/DbZYj4fQuCkW+pEg99e/+Y4t/5xW+H2g
	 G/ltkwQGoBZfZtFCglarbwy6xty3X8q2XYbPeE8pUeNH9stSQo+QBSfPWUJEo8LCMQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795133316;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Sender:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=kfpfHmsXunUBWQlKkF97XoBgLUmLhk3tSJt0eKigJrw=;
	b=jAmEl8JoswCXZWfJ4Ay7Vi0NE0/jRHDordbrs4o303Atu+hfoZwomZ2asvMMrKwRRz7t
	 cgUuP53uV15s0J7lKDcarYeuPPrWZNjxrcfbimolN446BigldgCMPjjcuomQxfZH0QaJg
	 Mxie37Zuw98xrqNuVlKQTKK6N87ByR6vu2NNx6zuA6+SOChX6/di0UNEQRqYWAMc7CTRU
	 28hGc8fvJ5uUK0PQAiPecRc10J+oMCjQ50j1ESMSfEDVbBZJFa9Kw+VX1pJ4eARM7zP/P
	 Qlp9fDlaOE6BH8G9j+psChh4QCGXiYcdjzqeMgPgmbr6dc4d8WF+95DTHo+8ZoPjJ0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=stellman-greene.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=svKQ7KF7;
	arc=none smtp.remote-ip=209.85.219.42
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBAF606A75A
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 00:08:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9CBAF606A75A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stellman-greene.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=svKQ7KF7
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-91e8a05ec5aso4562246d6.1
        for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 16:08:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795133312; x=1795738112; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kfpfHmsXunUBWQlKkF97XoBgLUmLhk3tSJt0eKigJrw=;
        b=svKQ7KF78TJhmDtwiUwNaWzI3exRBzt25b3xVqSTz4YuqP/MvP+Ko7xROPLffJCFyd
         bjjBRzeS3l8YH1QPTT28QNA4doLppjLR7gOLl5RymhvG16KGh+57wmVNI9IVKG5mwDLG
         84zYZPyYQ5/ViVj2Nl1MV09RzzV5PjTXrnThmdK9LLV2JTdpxU4vmZZ9akWQMzhXpxL2
         3PJZCbzFHxO+kO8qVC9jjEyejrCXBZpDqqy0KJYQe8nxPj7h8Cfci/EuIbUf4hgHLtyJ
         IDLkhPUpcib8OcCZnjIClQHI1RGllMRLD9R/e6l6KG00uyQ8ZcKttDywgUpF2ksnW2NL
         fKCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795133312; x=1795738112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kfpfHmsXunUBWQlKkF97XoBgLUmLhk3tSJt0eKigJrw=;
        b=oh+N3fDqVebv0RLIe4AoiGNr9kDU3CbVrK8vd9xm/G116ki9rA+UobCcwYKZDkOxQv
         6f1f9DwJJ9SPx9oT2ihOpsZSq9iS3OaxlWgODSMhnSzOKN2JJaYvVWf1pCJ6ueyrLHft
         JNNYDPe940FsXBngo4MWlkC/JXzn8+7i09TgwKRYXIrTAEGYLYbDYMZz9vgMKYERuf2X
         AOU/n5SSOX6/Und9mE+YEAfAE8x8YZvqEDAjKxWbRqWGML793BnfKJ8DkTj7wHHg9ZzS
         udtKr/3GoHgMGx0WS18ZId0tSq0aCEso1m3PhiQKJFJW4Q1X2vv5wPHM2c2s+WMm4VYr
         788Q==
X-Forwarded-Encrypted: i=1; AL+hErHmopGxutpxnaplsVYzIdRUPXKUcpCgnhDZsgjnRKha1ETbUA9xpxsNMVJwydiVJd005bWD9mdnXZai@vger.kernel.org
X-Gm-Message-State: APuU4Z+bDUmW6Z+zoXmo5qBAfN65XrV6EkXw5z1Xbj0yoefzeWef8LqO
	JPJLIKycDLbdlnuNz4Aoq2Pu+GQx6hkL3F3YZjXTF7MsX1/M08zjFV3L
X-Gm-Gg: AZFdTZdeQJWPo/5+8EKVbZJ4J0tzIm/cfiCL1MBMgWv3RCDfVmlJZn3ygDUHmzV9Npu
	KkZD8ulx5TmAqPv/I+LThuj5xdM6oPByGdfSXjoJ35GP6YE+Dj6M5pB1q1xEaHmLkuGwQXvpelW
	N1BDEObhXNNrxXMqwEpHYGSqyCfZ3/uFhOMl8CHcLiPQFz9rgLd0eRt0x8PY0UWMOFqsS+fikRm
	SPDDNhHTzbX6kLjsGRtlK9M9l9LFQa3NuSOwZsRzdl95rgEF2CVFBa6dbSktvymjR98nppba26S
	DfifeZdbeSuJ0GF4fqSoEcCa+Yu97h8b09AyA23YlZBhFDH3rCXQ2jLbxrtyQIN4hiKMkmvWaNZ
	KHjwx9HGtHoAqQynhAQIC0ubaCqeTwlBa9NnaUaCxGEyvnG8RAk5LYTlBQGXHi+42+hQZgku0dg
	39G/uFMDqNzJT/QZMfJcIw/wBH+MwSesuTVmzNTS7d8jjH5rbS/WKBAXdX0/Mq1JsdRZvhYR8W1
	WD8TzrX4aK33uBfvA9m7OsAn4h8vjlqjh42JhhI4/wxOxa6s7COb4VhfsvrE76Oqo92qTPSx5Ae
	1YUefpp1ZGC5kC1BH1dxEv07bWRDEWaSjY5hUe5l66gp3/ZH0X4uDkSWzyBovN1gVRubDcHeHSa
	1hunbezlCFrALtjHaRI84T5klvmE6WfFttV2Rw6BSvH9GZ5skPUVV9iBgPVmY/O/XQi4JDAIJBc
	tYR5ntHfw/oTu2Hhep2OCLkI1OFH0=
X-Received: by 2002:a05:6214:488d:b0:921:37a7:d1a8 with SMTP id 6a1803df08f44-92137a7d247mr6425726d6.1.1795133312417;
        Thu, 19 Nov 2026 16:08:32 -0800 (PST)
Received: from Mac.mynetworksettings.com ([2600:4041:5c28:200:c935:f347:a919:9f78])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-92134a0c33fsm10976546d6.36.2026.11.19.16.08.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 19 Nov 2026 16:08:32 -0800 (PST)
Sender: Andrew Stellman <stellman@gmail.com>
From: Andrew Stellman <astellman@stellman-greene.com>
To: Bernard Metzler <bernard.metzler@linux.dev>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-rc] RDMA/siw: Reject a zero length WRITE segment that announces more segments
Date: Thu, 19 Nov 2026 19:08:29 -0500
Message-ID: <20261120000829.64597-1-astellman@stellman-greene.com>
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

siw_proc_write() returns early for a zero length tagged segment, before
it looks up the sink STag. If that first segment has the L bit clear,
the next segment is handled as a continuation of the same message and
siw reads mem->stag through rx_mem, which was never set. A remote peer
on an established siw connection can trigger this, and it panics the
host:

  Oops: general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] SMP KASAN NOPTI
  KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
  RIP: 0010:siw_proc_write+0x175/0x9c0
  Call Trace:
   <IRQ>
   siw_tcp_rx_data+0x20e/0x2040
   __tcp_read_sock+0x1ab/0x810
   siw_qp_llp_data_ready+0x185/0x2e0
   tcp_data_queue+0x1f2d/0x4b70
   tcp_rcv_established+0x8a8/0x3990
   tcp_v4_do_rcv+0x45b/0x970
   tcp_v4_rcv+0x223d/0x3b90
  Kernel panic - not syncing: Fatal exception in interrupt

A zero length DDP message consists of exactly one segment (RFC 5041,
section 5.2), so terminate the connection with a tagged buffer error
when a zero length first segment announces more segments.

The issue was found by Claude Opus 5.5 running Quality Playbook, an
LLM-driven code review tool:
https://github.com/andrewstellman/quality-playbook
The fix and this changelog were drafted with the same tool and reviewed
by me.

Fixes: 8b6a361b8c48 ("rdma/siw: receive path")
Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>
---

Tested in QEMU with KASAN on v7.4-rc3. The patch applies unchanged to
rdma for-rc. With this patch siw sends a TERMINATE and closes the
connection, a normal two segment WRITE is still placed, and rping over
siw works.
A reproducer is available on request.

 drivers/infiniband/sw/siw/siw_qp_rx.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_qp_rx.c b/drivers/infiniband/sw/siw/siw_qp_rx.c
index e5b641c8d694..9b7e52906764 100644
--- a/drivers/infiniband/sw/siw/siw_qp_rx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_rx.c
@@ -550,8 +550,16 @@ int siw_proc_write(struct siw_qp *qp)
 	int bytes, rv;
 
 	if (srx->state == SIW_GET_DATA_START) {
-		if (!srx->fpdu_part_rem) /* zero length WRITE */
+		if (!srx->fpdu_part_rem) { /* zero length WRITE */
+			/* A zero length DDP message is a single segment. */
+			if (unlikely(frx->first_ddp_seg && frx->more_ddp_segs)) {
+				siw_init_terminate(qp, TERM_ERROR_LAYER_DDP,
+						   DDP_ETYPE_TAGGED_BUF,
+						   DDP_ECODE_T_INVALID_STAG, 0);
+				return -EINVAL;
+			}
 			return 0;
+		}
 
 		rv = siw_write_check_ntoh(srx, frx);
 		if (unlikely(rv)) {

base-commit: e7732ec135b501e87ab060d992b3b5f2ec4396c9
-- 
2.43.0

