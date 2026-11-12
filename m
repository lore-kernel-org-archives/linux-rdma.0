Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794447731;
	b=3PouSjwg/GUJCOCQu9aY4LO5R+nlEpunexz39KuJ0dGcGk4+Z+7ju2ADy4cUuYqg5LaC
	 V7qpnuRWczz3KnyuAaEK3Ny71hV3JVxju00seJTOwHlOApG/pauFICuLC2M4XLdaK+Hy2
	 fjWJA0Fe7FspKCCQmREsmo/9jP33xdn3WHN47jIpNXfvK/+imz3PNIRiX4jVYS/p5Mn8S
	 p+qbmd4/r4X+D4/O0EDxSAIGVkKQpHtnqp139R5xM6gb2ejVndk5KRL3gaO6uYHPSpNdM
	 NFt8Cecgc/YoIwG67nhe/aFVxGGRHhc/Vmkjt81/xSdWVJGDcrZZdbWq+pbX5BYz2gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794447731;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=iSd2zSo1N1Pm35h0fHX6fcAqOJSX19GjWZlbKEMeygc=;
	b=a40nTHE1SomBUb5fY557gut2g2nWdVi/1njPcFCueL6Ik1aMnS9NUBT4pY81UB3z8+9A
	 Sep/ux2Uhd10h2FM1ACI1Qpi+m/5WeBoZoqb7W2vlcs+Q0h/CJXNGm0hCDfdcXqbQOAcK
	 l5afLiLmaD72CLIhND9P5CqdVJ6rWmJhCFa/OxB8oiBS9UKczclY5Fa8UpEnrYmfr4NyP
	 RvGoc+MTkaXsziyW9awOHLeHWoyXCIwYK0CISXmARrsqxZI1T2/g9Devw65gn77O9+QzQ
	 WP+fy6Q1bEMc5jdCcRKHWbhf+m2w1PiNfSGvEiEyanBYgKdI9lB2cMQO6RXXOEddiuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b="Cgp/SdiL";
	arc=none smtp.remote-ip=111.22.67.139
Received: from cmccmta6.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAFC1606A31C;
	Thu, 12 Nov 2026 01:42:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DAFC1606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=Cgp/SdiL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=Cgp/SdiLOfY5yWVmQcYVZT+htmnAqCcPxP5wFEI6FYizbT2rF1ti/wpUS9pbgUDL6Mi731eDB9IH+
	 htw/yLI4/7J/5YVeoXv77/j5Zjm0x0cYLqhPlYHd0GdgCZTXWpZr5w5AI8EkKJ5TBQQDfLs/+DqG31
	 +qWUH+qtJnQzeoQ8=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app05-12005 (RichMail) with SMTP id 2ee56af5196fd9c-d946d;
	Thu, 12 Nov 2026 09:42:07 +0800 (CST)
X-RM-TRANSID:2ee56af5196fd9c-d946d
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from cmss.chinamobile.com (unknown[10.55.1.72])
	by rmsmtp-syy-appsvr03-12003 (RichMail) with SMTP id 2ee36af5196e785-ecb06;
	Thu, 12 Nov 2026 09:42:07 +0800 (CST)
X-RM-TRANSID:2ee36af5196e785-ecb06
From: Yuehong Wu <wuyuehong@cmss.chinamobile.com>
To: linux-rdma@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 rdma-rc] RDMA/ucma: free a queued CONNECT_REQUEST with its new context
Date: Thu, 12 Nov 2026 09:42:00 +0800
Message-ID: <20261112-ucma-conn-req-ctx-v2-1-yuehongwu@cmss.chinamobile.com>
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
delivered to user space is queued on the listening context, but it also
stores a plain pointer to the newly created connection context in
uevent->conn_req_ctx.  That context is already live in ctx_table because
ucma_finish_ctx() runs before the event is queued, so it can be
destroyed without ever fetching the event: the ids are allocated from a
global xarray starting at the lowest free value, and DESTROY_ID only
requires the context to belong to the same ucma file.

If user space destroys that context while the event is still queued, i.e.
before it fetches it with get_event, the event is skipped here and stays
in the listener's event list with a pointer to the freed context.
Destroying the listener later
(which is what closing its file does) reaches the
uevent->conn_req_ctx->id lookup in the xa_cmpxchg() below with a
dangling pointer, and when the freed context was reallocated the
comparison can match an unrelated live context, which is then detached
from the id table and freed.

The match in commit 8ae291cc95e4 ("RDMA/ucma: Do not miss ctx
destruction steps in some cases") replaced "uevent->ctx == ctx ||
uevent->conn_req_ctx == ctx" with a plain "uevent->ctx != ctx" test and
lost the case where the new context is the one being destroyed.

Free the event in that case and return the backlog slot it consumed.

Fixes: 8ae291cc95e4 ("RDMA/ucma: Do not miss ctx destruction steps in some cases")
Cc: <stable@vger.kernel.org>
Signed-off-by: Yuehong Wu <wuyuehong@cmss.chinamobile.com>
---
v2: no code change.  Reword the comment that was unclear and correct the
description of how the context is reached before get_event: its id is
predictable, not disclosed to user space.  Also mention both directions
of the ucma_migrate_id() cross-file case.

Validated in a QEMU/KVM guest running this tree with CONFIG_KASAN=y and
CONFIG_RDMA_RXE=y.  A reproducer uses an rxe device, queues a
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

Note: ucma_migrate_id() only moves queued events whose uevent->ctx is
the migrated context.  Moving the new context away leaves the event on
the listener's file, while moving the listener moves the event away but
leaves the connection context behind; both cross-file cases predate
8ae291cc95e4 and are left for a separate fix.

 drivers/infiniband/core/ucma.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -534,8 +534,25 @@ static int ucma_cleanup_ctx_events(struct ucma_context *ctx)
 	/* Cleanup events not yet reported to the user.*/
 	mutex_lock(&ctx->file->mut);
 	list_for_each_entry_safe(uevent, tmp, &ctx->file->event_list, list) {
-		if (uevent->ctx != ctx)
+		/*
+		 * A CONNECT_REQUEST that has not been delivered to user
+		 * space is queued on the listening context but stores a
+		 * pointer to the new connection context.  The new context is
+		 * live in ctx_table before the event is queued, so it can be
+		 * destroyed before the event is fetched; the event can then
+		 * no longer be acted upon.  Drop it instead of leaving a
+		 * dangling conn_req_ctx in the event list.
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



