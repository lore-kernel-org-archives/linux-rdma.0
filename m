From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: ?Re: RE: infiniband RDMA connection to server is rejected when client reboot
Date: Wed, 17 Mar 2010 08:20:18 -0700
Message-ID: <E9813D16FB6A491E9D4BEEEE940F9516@amr.corp.intel.com>
References: <MAILt3HvoFOAmEaJswF0004deaa@mail.langchao.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <MAILt3HvoFOAmEaJswF0004deaa-hsiVscFSYOJrXVYLWy1CrgC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "'J.G Yang'" <yangjg-6gUaA8visnnQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>yes.when the client rebooted and failed to connect the server,  the
>event.status is
>'IB_CM_REJ_STALE_CONN' . On the client ,when I created a QP using the old
>rdma_cm_id which  failed in the first connection to retry connection to server,
>the call to function rdma_create_qp() returned    -22(-EINVAL) all the time.

This is expected.  The rdma_cm_id can only be used for a single connection.  The
underlying state machine does not reset.

>My question: Are there some methods that the server can be notifed when it lose
>the connection such as the client's reboot?So the server can destroy the
>rdma_cm_id and pass the stale connection check. The client needs no retry for
>new rdma_cm_id after reboot.

If the server isn't using the connections, then they could stay around.  I don't
know how you can avoid this for a general case short of keep-alive messages.

For actual stale connections, it would require a kernel change, but the kernel
detects this and _could_ force a disconnect on the local side. 

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
