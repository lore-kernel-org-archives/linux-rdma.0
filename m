From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 17/17] svcrdma: use offset_in_page() macro
Date: Tue, 30 May 2017 14:16:18 -0400
Message-ID: <20170530181618.2992.39799.stgit@klimt.1015granger.net>
References: <20170530175808.2992.60365.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170530175808.2992.60365.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up: Use offset_in_page() macro instead of open-coding.

Reported-by: Geliang Tang <geliangtang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/svc_rdma_rw.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_rw.c b/net/sunrpc/xprtrdma/svc_rdma_rw.c
index d91ef56..4276c1c 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_rw.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_rw.c
@@ -371,8 +371,9 @@ static void svc_rdma_pagelist_to_sg(struct svc_rdma_write_info *info,
 	struct scatterlist *sg;
 	struct page **page;
 
-	page_off = (info->wi_next_off + xdr->page_base) & ~PAGE_MASK;
-	page_no = (info->wi_next_off + xdr->page_base) >> PAGE_SHIFT;
+	page_off = info->wi_next_off + xdr->page_base;
+	page_no = page_off >> PAGE_SHIFT;
+	page_off = offset_in_page(page_off);
 	page = xdr->pages + page_no;
 	info->wi_next_off += remaining;
 	sg = ctxt->rw_sg_table.sgl;

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
