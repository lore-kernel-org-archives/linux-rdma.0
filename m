From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 0/4] IB/srp: add SRP_CRED_REQ support
Date: Mon, 2 Aug 2010 17:32:30 +0200
Message-ID: <201008021732.30253.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This series of four patches adds SRP_CRED_REQ support in ib_srp, which is a
feature defined by the SRP (draft) standard. Compared to an earlier patch for
implementing this functionality that I posted a few months ago I have done my
best to address all comments that were posted to this mailing list, especially:
- Split the big patch into multiple patches, which makes reviewing easier.
- Instead of defining separate queues for transmitting requests and responses,
  a single queue is now used.

These patches depend on the "IB/srp receive buffer handling robustness improvement"
patch posted a few days ago.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
