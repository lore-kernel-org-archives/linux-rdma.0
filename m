From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] libibverbs/doc: clarify selective signaling (Re: using IBV_SEND_SIGNALED)
Date: Tue, 30 Nov 2010 13:56:13 +0200
Message-ID: <4CF4E65D.4070205@Voltaire.com>
References: <alpine.LNX.2.00.1011291128190.31687@postal.iol.unh.edu>	<4CF3DDF0.2070907@opengridcomputing.com>	<alpine.LNX.2.00.1011291233540.5810@postal.iol.unh.edu> <4CF3E5FA.6010308@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CF3E5FA.6010308-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Robert D. Russell" <rdr-zcUZCMB5SQOVc3sceRu5cw@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Steve Wise wrote:
> On 11/29/2010 11:34 AM, Robert D. Russell wrote:
> See section 8.2.1 of the iWARP Verbs draft at:
> http://tools.ietf.org/html/draft-hilland-rddp-verbs-00#section-8.2.1.
> The last big paragraph in 8.2.1 spells it all out.
> There should be a similar requirement in the IBTA IB Verbs specification...

Yes, I think the below patch to the man page can help people understand how to work 
with the thing

>>> You must signal one WR for every SQ-depth worth of WRs posted.  IE:
>>> If your SQ depth is 16, you must signal at least one out of every 16
>>> This ensures proper flow control for HW resources.


clarify selective signaling usage

Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>

---

 man/ibv_post_send.3 |    6 ++++++
 1 file changed, 6 insertions(+)

Index: libibverbs/man/ibv_post_send.3
===================================================================
--- libibverbs.orig/man/ibv_post_send.3
+++ libibverbs/man/ibv_post_send.3
@@ -112,6 +112,12 @@ request is fully executed and a work com
 from the corresponding completion queue (CQ). However, if the
 IBV_SEND_INLINE flag was set, the buffer can be reused immediately
 after the call returns.
+.PP
+Applications which use selective signaling should make sure to post
+a signaled WR (i.e one for which the IBV_SEND_SIGNALED flag is set) from
+time to time - depending on the requirements of the underlying rdma device.
+Typically the number of consecutive unsignaled WRs should not exceed the
+size of the send queue specified when the QP was created.
 .SH "SEE ALSO"
 .BR ibv_create_qp (3),
 .BR ibv_create_ah (3),
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
