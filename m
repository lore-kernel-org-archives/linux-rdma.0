From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: how to re-use a QP for a new connection
Date: Fri, 20 Jun 2014 14:06:03 -0400
Message-ID: <36E48CE3-3FB6-4985-9CA5-4D6B800EE3DC@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi-

I=92m considering a change to xprtrdma that would re-use the QP and
rdma_cm_id after a transport disconnect.

I use rdma_disconnect() and then wait for the TIMEWAIT_EXIT upcall.
But after that, rdma_resolve_addr() always fails (-EINVAL).

What does xprtrdma need to do to get the rdma_cm_id back to the
RDMA_CM_IDLE state so I can reset the QP?

=46eel free to tell me this doesn=92t make sense.

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
