From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/3] best practice for setting IB_CQ_REPORT_MISSED_EVENTS
Date: Wed, 31 Mar 2010 10:57:42 -0700
Message-ID: <20100331175742.24522.17850.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The following patches update ISER, SRP and core to use the
IB_CQ_REPORT_MISSED_EVENTS when calling ib_req_notify_cq()
similar to the patch I sent out for RDS.

Since the QLogic HCAs use a separate thread to generate the CQ callback,
it is important to make sure it isn't delayed more than necessary.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
