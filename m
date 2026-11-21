Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.205.221.240
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795232829;
	b=D65nob0jsGxf8LTQJqQIhAtGJFFqgvIpx9swuHu5ny8YJ6Lipigu8mT+nndaCPwOR3h9
	 t0Y+NRFx6iae5BeFA56UvgxKUWs/2yexYcaEnQ9H7dDERK1nhV5zR/jmODavMC1CGqrsn
	 4Da0Hc1aOHnT+U9c0/Tt6GKWalXceL4m3m8NeoBafYc52GWCBZwmiLfFwEmlw1eFXWPMC
	 +LGzXW62wJ0uFp9+rd4BirhcPg6aIlbXoibiniu1YJ8Jvs6NmdBqJ9yRwQwvdm5d4QhK8
	 cRBQgvBxBtqnrBsn9b0c9jMfqGqgft32r+9DBgptmbFROgcVf7pC+PeNcDl0J/DIWuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795232829;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=55KLg5TPytdDc9hoRdxs/pCCWjQgeOkyFylwJEOUFYM=;
	b=29gvnBaLgF3FWy6hl3YnzwLiy3OMy5MCmZGvS6+npyqUV4P24WdIyCM7N/tXOo37kgw/
	 N5ZmAN3xtrCKcR3tvIx5ZBZoEL2ozIwpv9TZGXJeWjWFRX9D+nqki4VfGQeaWJrXQVvnb
	 Cs7Ta5Wr20JjSJOtLNZOvcUVBKZ4KfR96NsTseYzeNLcaBzsVAxH/7nwliLQGZQ9GRnqg
	 x0zo9snPEIgJ2mtRDXHlnugEHjttzuHyFXW/irCqKyF8gnI26WITbQNEe9oHDr0yjHvS3
	 t1ktRc+2zDwHGQMSCLrbmN2iCsqkoSbo+YNfRD/g+9v7SPIJujUFgu0zSfncocm10jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=dG2HUSdQ;
	arc=none smtp.remote-ip=203.205.221.240
Received: from out203-205-221-240.mail.qq.com (out203-205-221-240.mail.qq.com [203.205.221.240])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6223606A681;
	Sat, 21 Nov 2026 03:47:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6223606A681
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=dG2HUSdQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1795232820; bh=55KLg5TPytdDc9hoRdxs/pCCWjQgeOkyFylwJEOUFYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dG2HUSdQhYQ31EV1xGTKYYPlZP7ERlgt98Sp88uCoqIOKa6KXTxM6skT9dZ0Z6QPY
	 8q9C0jSsMX0xxL/7XGhfrmfb6J1r19NTgCLbZoKSAKhFCRC6/ekcSSHBeoRVQPS0ou
	 sjHrQ7EbUv+CSJVWqM5QQurVBp8SLbcFJE7OPATc=
Received: from shuai-VMware-Virtual-Platform.. ([117.158.156.198])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id BB907498; Sat, 21 Nov 2026 11:46:57 +0800
X-QQ-mid: xmsmtpt1795232817tlowbldga
Message-ID: <tencent_BEE58D9BBE7109C47C2796DDF5A4B958F609@qq.com>
X-QQ-XMAILINFO: M7dxyDFn9MPm+gLasOjeHd6TvQMTi/jgnSlIlpHD7GcN+Qj/LAXTFLTCVvjHGD
	 0/JIsOPDasevI4zNmiFCdqHBASY0bix5NQUnE8vPWaIsiIiQV3I3/IMWTuS1pe91xTlRCIcspRw3
	 CrgvfPR+W59eB4pwE/SgbKzOZgBFNHtdMMZdzb6tlGRQOGEGfoO4T8wf3fehpTkjx8uU0MK+hoK/
	 O1Y8hd4Txpl4GSBhIOx+kBqtXS9J0Kz1s92pqQckpZJdB3vW7wlMW3iWV5sfoiE1kQ9otAc7VSK+
	 IWPSbSzK+iQE/2E7/ScxTRURW67i/19iQr+htR95gCITRr9UvWh/5/AF7cQFKLJsDCVL21kPWc5S
	 ZaIeF8YGwUV+YAVNMNvmsbuFwSfv9IDLrucb+A5FE7FS+yYljr40LeNSaCa3ESjJVjmQGVLwrDpV
	 Fv343QUdq6cyZKruth+nw7MIZEheTXDK5Os3XSg5ISuGkGEqlDQ0eWSmejMNLeVyz7Uk0iZXLPRV
	 rYsSa3WczsQSgcImhHghxrZFIf8waTu42+ivBEy5/oPI7Q9+wFBrhSNbFtl5Emt1NQ1QhLrm7OPJ
	 SschA9xn7VuJl9fOONOVhSDjwDEuOSMPxxYyyL1+CrBtDlFN9OUFqS5sb+uMcw68eIE8eKg31mFh
	 3chk17qUIIVG3ZemJEUDUv2LGEIpfWvbh9nJzy2z539EldC44mClm9RVRXVZ6u40QY4ntXMPxysq
	 9Ol8RslBSrZ4g7p7tRnXtzyQvG4dUL+cWucd0yumOTj81AJYt2kl7P18mfBOxgtG5W8nmRyrVkzK
	 mRqISuY4X8ME99yu5lH/L5dQnHJRSlvXodYWg52+nPlds+pB6E8mT0RdXxyT9Y0VsHhkekC6Z9Fn
	 Hz5a934dnEdio/rARmKiBh/nNSKgKesN0tqHgYEpNyff7LgS3DlKn99eNW50uKZPIPZ+mihciDAD
	 CFYwd1MShJ3gacghg9L13pjFgjpVmEcTKJWGiMlyjwNg8bbqdaMvHmZsVit4NTqcI4qeJ1ejPotX
	 EBtwUWkDQ1biSSxIIdvkifBef3bgXCBP3/uMXB8dNvIaXtUi2+DALlsuY9beRdxgvHmhiaVTBvaj
	 s6Rwp2byc663SiKc3fZwo4r9rrfKGzljH1Jc0G
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
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
Subject: [PATCH rdma-next v2] RDMA/rxe: Mask the SQ producer index read from user space
Date: Sat, 21 Nov 2026 11:46:57 +0800
X-OQ-MSGID: <20261121034657.104531-1-847807867@qq.com>
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

