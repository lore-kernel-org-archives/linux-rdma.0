From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: IB/documentation: fix typo in include/rdma/ib_verbs.h
Date: Wed, 20 Jan 2010 13:56:13 +0100
Message-ID: <e2e108261001200456r470e7e51p67504454acbc3258@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 09509ed..00f5d26 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1534,7 +1534,7 @@ int ib_peek_cq(struct ib_cq *cq, int wc_cnt);
  *   Must contain exactly one of %IB_CQ_SOLICITED or %IB_CQ_NEXT_COMP
  *   to request an event on the next solicited event or next work
  *   completion at any type, respectively. %IB_CQ_REPORT_MISSED_EVENTS
- *   may also be |ed in to request a hint about missed events, as
+ *   may also be passed in to request a hint about missed events, as
  *   described below.
  *
  * Return Value:
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
