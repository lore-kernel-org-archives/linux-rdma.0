Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.205.221.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795232546;
	b=rM3zlNZOAcmrTlpelhK0d7nhIA2LEMMaA61XxWWzS3RVUtEPPMk/FyKq1VZfJfLmQW7X
	 M8XoL7k4CRCs5wBfSO12qXFs+hpDljdXrN1JVyiUhVUpwfr1IxKC7G2DoGFucqGzjwgVc
	 NkkCvbkdYF5B2y/nSv1N6wcpfj70OqEkfoYogBr16BGu7zNQtSyjTMg+DOAnOFCL+9SF1
	 oJ4WtnCzEdvj5b4p0y2niZ4XMo22TAakoSMEaRGHZyFT6DN06u1jsUF1zPi5spCi/V2aK
	 SrcuPcMPJvOL/LdYMqqz/Nx1dXi1GwOPATlezpMDS5IoCxDg0jgw2wuFZC9whioW5Vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795232546;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=55KLg5TPytdDc9hoRdxs/pCCWjQgeOkyFylwJEOUFYM=;
	b=CGToarPNIzRQABPU/In8ioReSdLJI+oTNqSN+LcRcWW0bJ9rGCGY5IkKVGG9tA7SVVnu
	 oWuix7Z1D1hkwadCzjCzsBhKZm7QeMXREpsNnBn30cALD6sYHaqel618QrDI9koc28VCa
	 X6sNY5H+AqWNHGe+nUZxSdCRP5SdD5bE5xrdwe75WVJ6kXWtIsun1/r/cJZ5B0wtJqGF/
	 O4Lan0ffyRnH4yr65rG+a9XV/uj8E8xUlvSOptAyhkK9tm9zVQm3jXBqs4ckVU/3HAZ3q
	 qatwTg5vzY9Nnmj257IUbAcX/tuCm/4XgHMp06oNglCsn7PIvI0ZkpWnWeIATb3k9UA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=gSBnsy61;
	arc=none smtp.remote-ip=203.205.221.173
Received: from out203-205-221-173.mail.qq.com (out203-205-221-173.mail.qq.com [203.205.221.173])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D10606A688;
	Sat, 21 Nov 2026 03:42:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 20D10606A688
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=gSBnsy61
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1795232527; bh=55KLg5TPytdDc9hoRdxs/pCCWjQgeOkyFylwJEOUFYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gSBnsy611qLxqFl1wexhgR24XXTIztko8drty2NoomMsxYsHGc3jdcA9fTTk5vatQ
	 99v+3mBtP5jTvEaCwmgoEOVpX1pK/AvHDwftVztYy+bpejNC3qmUGPndnhYOPHpw4+
	 1NtRbc0e3l0Zusiqrq5Z5QURALfv0BA4WbSE/6Dg=
Received: from shuai-VMware-Virtual-Platform.. ([117.158.156.198])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id A8519672; Sat, 21 Nov 2026 11:42:05 +0800
X-QQ-mid: xmsmtpt1795232525tzzj93r6y
Message-ID: <tencent_03B85262EE136CEE83D2012CA5F2704D2008@qq.com>
X-QQ-XMAILINFO: M2SvzgchpLqfjYSr+5qdYkljKTTtIvN4a3FibtIAt8oLjS96ZPgz3DmVMCHhak
	 W/pRi1TRZGfHkjI2UjU5XtoVe0iFVtzKbA1117KiF8yQPcFK3bIJtOOoW9j6U4zkC3BaafjnVvT1
	 o7XTN6JGzdR3vOPqI1ApfMVJuZpkUw8z1LSWG11NbgxUoxe2G37SPCMLK1RVP4GUNJAuoocL8h6+
	 tCxm0H+Ht2bZLHwfxnLtct58J/xV2LICZe9lVVHGBuubJDtaw6oS0ixb7TtPHIxlkR4+RNoucvms
	 TgGsFOn6/nhFZYbq5iIxeCO/5a7HYoBqE/w5KV47S8fWtVW98giueoPgxadnUbP2fZxp4dqrrrBo
	 DhBtH6aq9/uBE77Pn9rjl2CWCukpaBcWxORmduytHqeph9VTeoJ6rVPSytPXkOtlMlFj0xxqIzMB
	 6tRCA3MTTq80uC1CylJ3kZfXns/b91C0ShJR2j5GmFoEmUOIatnOeAWse551NyKBRKxiWu+H8IyV
	 wm0QS5dJZwFsInYq6fxmGCUb/ImYjb+Il3W8Vtrjc5EnkgDUSTwd2h8jA/IZ1+TTYg28WlqU3gTN
	 HT0lLkI1rFyN2rSd3xWwj24DqQbDnlNyusTslYBGWyFcLWxBwKRCMw4mv389diZHOj3mQSR8LJaH
	 6J7duQiifL4B420cFlOjq2ZlCimi5knD10OHBabzZDVs2pKHcfMrdgsQzXjdGoarPuhBMIIu0OJJ
	 qiYqHiDkuJ6px3IsdyzU6MorYjcaDXFKYpC2p93DlrRRzKPb6sT1jpZMduRnqCn3sqU8FMNfGhoA
	 4JEmFI2BsBaIkNZZ1mHNONDAuy8evjj8eAid8KAB2NtDJSlyp4TwVxqPRA9WosvoHz5oxLB+Sc/Z
	 mTFRJjIBFA2/3S/Ly+KBql7Cq8mqLApTwNZWexfI6sOlfqVVf6VRNWgy3zjx67DrJ6Yvsbzu7PbT
	 7OLJeRTIOHDMpQOhx7DDjMYrQ7Z4Rx7hTdEcTjxT7l2puCDHaiB9Zo/R+ZLlGZqGXYG5uV/6vp52
	 kmfXjyF46JvH8a7CGNWSC0dGC068Wx/Sh34YVjW6NaK58TZiwLGBMViIHn0Ap5zkbOFJ1I2B+nvM
	 lhYltv
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
From: Shuai Liu <847807867@qq.com>
To: linux-rdma@vger.kernel.org
Cc: yanjun.zhu@linux.dev,
	zyjzyj2000@gmail.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	rpearsonhpe@gmail.com,
	syzbot+fef38133c495aeb48297@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com,
	linux-kernel@vger.kernel.org,
	sashiko-reviews@lists.linux.dev
Subject: [PATCH] RDMA/rxe: Mask the SQ producer index read from user space
Date: Sat, 21 Nov 2026 11:42:04 +0800
X-OQ-MSGID: <20261121034204.102626-1-847807867@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <tencent_5B9FB1BCC8EF36C5E2128B7D4D54B867480A@qq.com>
References: <tencent_5B9FB1BCC8EF36C5E2128B7D4D54B867480A@qq.com>
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

The send queue producer index of a user space QP is stored in the
queue buffer which is shared with and written by user space. The
requester reads it without any validation in req_retry() and
__req_next_wqe() and compares it against its own local index which
is always masked.

The requester stops processing WQEs when its local WQE index equals
the producer index. If user space writes an out of range producer
index into the queue buffer, that comparison can never become true.
Once the QP is put into the error state, rxe_requester() then keeps
flushing WQEs forever: the flush path advances the WQE index with the
masked queue_next_index() but the producer index stays out of range,
and each pass calls rxe_qp_error() which reschedules the send task,
so the loop never converges. The send task holds a reference to the
QP for as long as this lasts, so ib_destroy_qp() waits for the QP
reference to drop until it times out after 50 seconds and the
WARN_ON(!ret) fires in __rxe_cleanup():

  WARNING: drivers/infiniband/sw/rxe/rxe_pool.c:212 at __rxe_cleanup
  Call Trace:
   __rxe_cleanup
   rxe_destroy_qp
   ...
  rxe0: qp#17 rxe_destroy_qp: cleanup failed, err = -110

Fix this by masking the producer index with q->index_mask when reading
it in queue_get_producer() for QUEUE_TYPE_FROM_CLIENT. This restores
what producer_index() did before commit ae6e843fe08d ("RDMA/rxe: Add memory
barriers to kernel queues") replaced it with queue_get_producer() and
dropped the mask, and keeps the requester, the completer and the queue
helpers, which all compare the difference of the two indices modulo
index_mask, consistent. rxe_qp_init_req() also initializes
qp->req.wqe_index from this value so it gets validated as well.

Masking the index in queue_get_producer() instead of checking it at
the two requester call sites was suggested by the Sashiko AI review of
v1 of this patch.

Verified with the syzbot reproducer in QEMU: without this patch every
destroy_qp hangs for 50 seconds and hits the WARNING above; with this
patch the reproducer runs cleanly.

Reported-by: syzbot+fef38133c495aeb48297@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=fef38133c495aeb48297
Fixes: ae6e843fe08d ("RDMA/rxe: Add memory barriers to kernel queues")
Signed-off-by: Shuai Liu <847807867@qq.com>
---
Changes since v1:
- Mask the producer index in queue_get_producer() for
  QUEUE_TYPE_FROM_CLIENT instead of checking it at the two requester
  call sites, as suggested by the Sashiko AI review of v1. This also
  covers rxe_qp_init_req(), which initializes qp->req.wqe_index from
  the same value, and keeps the requester, the completer and the queue
  helpers consistent with each other.
- Point Fixes at commit ae6e843fe08d, which dropped the mask that
  producer_index() had, instead of commit 5bcf5a59c41e.
- Reword the commit message: the flush loop never converges because
  the WQE index is advanced with the masked queue_next_index() while
  the producer index stays out of range; the req_retry() reset detail
  in the v1 description was inaccurate.
- Update the subject to describe the actual mechanism.

 drivers/infiniband/sw/rxe/rxe_queue.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_queue.h b/drivers/infiniband/sw/rxe/rxe_queue.h
index c711cb98b9496..fe65aecc60464 100644
--- a/drivers/infiniband/sw/rxe/rxe_queue.h
+++ b/drivers/infiniband/sw/rxe/rxe_queue.h
@@ -106,6 +106,7 @@ static inline u32 queue_get_producer(const struct rxe_queue *q,
 	case QUEUE_TYPE_FROM_CLIENT:
 		/* used by rxe, client owns the index */
 		prod = smp_load_acquire(&q->buf->producer_index);
+		prod &= q->index_mask;
 		break;
 	case QUEUE_TYPE_TO_CLIENT:
 		/* used by rxe which owns the index */
-- 
2.43.0

