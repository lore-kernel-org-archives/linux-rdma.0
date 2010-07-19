From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch 2/2] infiniband/cxgb4: add null check
Date: Mon, 19 Jul 2010 13:15:24 -0700
Message-ID: <adalj97qlcz.fsf@roland-alpha.cisco.com>
References: <20100531140152.GU5483@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100531140152.GU5483@bicker> (Dan Carpenter's message of "Mon,
	31 May 2010 16:01:52 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Since we agreed the NULL check probably wasn't needed, I added this:

[PATCH] RDMA/cxgb4: Remove unneeded NULL check

The rest of the code seems to assume that ep->com.cm_id can't be NULL,
so remove an unneeded test.

Reported-by: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index b5e676c..4185c3b 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -780,11 +780,11 @@ static void connect_reply_upcall(struct c4iw_ep *ep, int status)
 		event.private_data_len = ep->plen;
 		event.private_data = ep->mpa_pkt + sizeof(struct mpa_message);
 	}
-	if (ep->com.cm_id) {
-		PDBG("%s ep %p tid %u status %d\n", __func__, ep,
-		     ep->hwtid, status);
-		ep->com.cm_id->event_handler(ep->com.cm_id, &event);
-	}
+
+	PDBG("%s ep %p tid %u status %d\n", __func__, ep,
+	     ep->hwtid, status);
+	ep->com.cm_id->event_handler(ep->com.cm_id, &event);
+
 	if (status < 0) {
 		ep->com.cm_id->rem_ref(ep->com.cm_id);
 		ep->com.cm_id = NULL;
-- 
1.7.1.1


-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
