From: Frank Zago <frank-6OywahBdSro@public.gmane.org>
Subject: [patch 0/6] post_send/recv fixes (v2)
Date: Wed, 02 Dec 2009 20:35:42 -0600
Message-ID: <4B1723FE.8060900@zago.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello,

This series fixes a few bugs in several IB drivers regarding their
ib_post_send() and ib_post_recv() implementation.

Regards,
  Frank.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
