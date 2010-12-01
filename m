From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] libibverbs/doc: clarify selective signaling (Re: using
 IBV_SEND_SIGNALED)
Date: Wed, 01 Dec 2010 11:01:04 +0200
Message-ID: <4CF60ED0.6000502@Voltaire.com>
References: <alpine.LNX.2.00.1011291128190.31687@postal.iol.unh.edu>	<4CF3DDF0.2070907@opengridcomputing.com>	<alpine.LNX.2.00.1011291233540.5810@postal.iol.unh.edu>	<4CF3E5FA.6010308@opengridcomputing.com> <4CF4E65D.4070205@Voltaire.com> <20101130185744.GK16788@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101130185744.GK16788-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Robert D. Russell" <rdr-zcUZCMB5SQOVc3sceRu5cw@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe wrote:
> Applications which use selective signaling can only assume that
> unsignaled WRs are complete once a completion for a later signaled WR
> is received. In practice this means that a signaled WR must be
> used periodically, and that the send queue should never be filled with unsignaled WRs.

clarify selective signaling usage

Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>

---

Jason, how's this?

 man/ibv_post_send.3 |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: libibverbs/man/ibv_post_send.3
===================================================================
--- libibverbs.orig/man/ibv_post_send.3
+++ libibverbs/man/ibv_post_send.3
@@ -112,6 +112,15 @@ request is fully executed and a work com
 from the corresponding completion queue (CQ). However, if the
 IBV_SEND_INLINE flag was set, the buffer can be reused immediately
 after the call returns.
+.PP
+Applications which use selective signaling can only assume that
+unsignaled WRs are complete once a completion for a later signaled WR
+is received. In practice this means that a signaled WR must be
+used periodically, and that the send queue should never be filled with
+unsignaled WRs. Such periodic signaling is also a requirement of most rdma
+devices. In the presence of completion with error, WCs are generated
+also for unsignaled WRs, so applications should make sure to provide a valid
+id (cookie) for all posted WRs.
 .SH "SEE ALSO"
 .BR ibv_create_qp (3),
 .BR ibv_create_ah (3),
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
