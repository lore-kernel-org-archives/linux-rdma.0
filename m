Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794193893;
	b=3V/PjOipHxIxchoka50gXYej+oGc1gWyT6fDuqAnT2a84zW20FeXJfodDbpKsMj3Ayzh
	 PFwwoMRbe958eEER5Ah6mUM/w9li5VG86tO0F4WdTwO2I7LRm5Aw27KM0nBSBZAt/rnLF
	 +DJzs1Jr7chWs/DJ0M0R9ju92pvH7Bo2EBrAPWkKGnBLWdfYh4afNwAMyxleyNHECwTA1
	 Qw0XXXnlAvZaRG1PPT04bGckdBXHrVTqi8B8cvYdHwx4Ui36IWY+ArZU+ZFqOwd3O6PCD
	 AlMZWsL1W/Bqi3Xdq/OoH7Ko/oyjMif44d4cwIb/SqaH4F5wAovGoeMvUrNTAjPE/mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794193893;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=LxvhX6D660lQXzUGa8I5eF6b15FauA7MZ73QeBbt07Y=;
	b=sIf4Lfae9skjF2Vvb/V/UBYscaslvnhKTV0Ob4nFoWv9qYPOKpSpqFCzj4qRf/OggkSi
	 ADfg2hdfllk2qj/XF+0GXK17wiCT1QG4eWgDQyZPk4H1xObXAjQ/rJNuJoKQmfxOk89zj
	 5W/L+W4S3hqRh9v0myG0w/09gA/c4e/JdHGgdJ+DEYNYEwmqfp5R1YTtRfdhgB1BMvTCV
	 s+OgGZvs27MpmlRLxyrMMQU4egpx3KRRHhSU1kOFUqGds7vZ0DBP1mleQYTe1ZoZYrBHW
	 qBMPjUkWQmZP+oylChsYYoPwPfmVM+XITHHYdB1jBh0hB/2MahhD4GKHWq+gvl0Uirg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=oH83u2TW;
	arc=none smtp.remote-ip=111.22.67.139
Received: from cmccmta6.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74C21606A31C;
	Mon,  9 Nov 2026 03:11:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74C21606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=oH83u2TW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=oH83u2TWY+S+91EgJarkOXE2FuUQ/jYsS5Yex2glvwxF5agqcygcVBiTxR7N7kxdokliJm61uRi5v
	 vbTUmWuPt/EO3hvalG0f1PQiOG7eGwhJ+rKn9M+fx8EF6ReBO8h5GpjLEO0yN6etTXga3iXqQ11E29
	 BXBNMADryCDBSux0=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app09-12009 (RichMail) with SMTP id 2ee96af139de199-c5420;
	Mon, 09 Nov 2026 11:11:28 +0800 (CST)
X-RM-TRANSID:2ee96af139de199-c5420
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from cmss.chinamobile.com (unknown[10.55.1.72])
	by rmsmtp-syy-appsvr04-12004 (RichMail) with SMTP id 2ee46af139de545-7eee1;
	Mon, 09 Nov 2026 11:11:28 +0800 (CST)
X-RM-TRANSID:2ee46af139de545-7eee1
From: Yuehong Wu <wuyuehong@cmss.chinamobile.com>
To: linux-rdma@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH rdma-rc] RDMA/ucma: free a queued CONNECT_REQUEST with its new context
Date: Mon, 09 Nov 2026 11:20:00 +0800
Message-ID: <20261109-ucma-conn-req-ctx-1-yuehongwu@cmss.chinamobile.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8bit

ucma_cleanup_ctx_events() only frees the events that belong to the
context being destroyed.  A CONNECT_REQUEST uevent that has not been
delivered to user space belongs to the listening context, but it also
keeps the newly created connection context in uevent->conn_req_ctx, and
that context is already reachable from user space because
ucma_finish_ctx() published its id before the event was queued.

If user space destroys the new id while the event is still queued, i.e.
before it fetches it with get_event, the event is skipped here and stays
in the listener's event list with a pointer to a context that
ucma_destroy_private_ctx() then frees.  Destroying the listener later
(which is what closing its file does) reaches the
uevent->conn_req_ctx->id lookup in the xa_cmpxchg() below with a
dangling pointer, and when the freed context was reallocated the
comparison can match an unrelated live context, which is then detached
from the id table and freed.

The match in commit 8ae291cc95e4 ("RDMA/ucma: Do not miss ctx
destruction steps in some cases") replaced "uevent->ctx == ctx ||
uevent->conn_req_ctx == ctx" with a plain "uevent->ctx != ctx" test and
lost the case where the new context is the one being destroyed.

Free the event in that case and return the backlog slot it consumed: it
was never delivered to user space, so it can no longer be acted upon.

Fixes: 8ae291cc95e4 ("RDMA/ucma: Do not miss ctx destruction steps in some cases")
Cc: <stable@vger.kernel.org>
Signed-off-by: Yuehong Wu <wuyuehong@cmss.chinamobile.com>
---
Validated in a QEMU/KVM guest running this tree with CONFIG_KASAN=y and
CONFIG_RDMA_RXE=y.  A reproducer creates an rxe device, queues a
CONNECT_REQUEST, sees it with poll() without fetching it, finds the new
connection id by trying the small integer ids that belong to its own
file, destroys that id and then the listener.  The unpatched kernel
reports

  BUG: KASAN: slab-use-after-free in ucma_destroy_private_ctx+0x1c0/0x4f0
  Read of size 4 at addr ff11000102295a00 by task c9repro/302
  Allocated by task 12:
   ucma_alloc_ctx+0x2b/0x170
   ucma_event_handler+0x1ad/0x3a0
  Freed by task 302:
   ucma_destroy_private_ctx+0x468/0x4f0
   ucma_destroy_id+0x180/0x1e0

With this patch the same sequence run four times produces no report, and
a probe shows the queued event is dropped when the new context is
destroyed.

Note: ucma_migrate_id() can move the new context to another file, which
leaves its queued CONNECT_REQUEST in the original file's event list.
That cross-file case predates 8ae291cc95e4 and is left for a separate
fix.

 drivers/infiniband/core/ucma.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -534,8 +534,23 @@ static int ucma_cleanup_ctx_events(struct ucma_context *ctx)
 	/* Cleanup events not yet reported to the user.*/
 	mutex_lock(&ctx->file->mut);
 	list_for_each_entry_safe(uevent, tmp, &ctx->file->event_list, list) {
-		if (uevent->ctx != ctx)
+		/*
+		 * A CONNECT_REQUEST that has not been delivered to user
+		 * space belongs to the listening context but also holds the
+		 * new one.  If the new context is destroyed first, the id it
+		 * was published under is gone, so drop the event instead of
+		 * leaving a dangling conn_req_ctx in the event list.
+		 */
+		if (uevent->ctx != ctx) {
+			if (uevent->resp.event == RDMA_CM_EVENT_CONNECT_REQUEST &&
+			    uevent->conn_req_ctx == ctx) {
+				list_del(&uevent->list);
+				/* Return the slot taken for this request. */
+				atomic_inc(&uevent->ctx->backlog);
+				kfree(uevent);
+			}
 			continue;
+		}

 		if (uevent->resp.event == RDMA_CM_EVENT_CONNECT_REQUEST &&
 		    xa_cmpxchg(&ctx_table, uevent->conn_req_ctx->id,



