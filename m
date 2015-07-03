From: Christopher Mitchell <christopher-1z5WdJkP5Frk1uMJSBkQmQ@public.gmane.org>
Subject: IBV_SEND_INLINE Behavior Differing from Spec
Date: Fri, 3 Jul 2015 17:50:56 -0400
Message-ID: <CAPb9-SECy6OJ5S8SCv_3y18MC4NVGJprtNFmimq5MkxK4xg6jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey all,

The manpage for ibv_post_send indicates that if you specify the
IBV_SEND_INLINE flag, that you can immediately re-use the buffer after
ibv_post_send() returns. However, I have found that if I modify the
buffer immediately after ibv_post_send(), the changes are rarely
reflected in the presumably already-posted message. I'm using
ConnectX-3 cards and RC connections, if that's relevant. Is this a
known issue, and/or is it possible I'm missing something obvious?

Cheers,
Christopher
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
