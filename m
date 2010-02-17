From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: IPoIB memory use after free
Date: Wed, 17 Feb 2010 12:02:36 -0800
Message-ID: <1266436956.30078.23.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I have been tracking down a kernel panic while running qperf udp_bw
tests and it looks like ib_ipoib is using memory after freeing it.

The problem is with connected mode. I don't see the panic with
datagram mode. Looking at the source code, I see that the process
of creating the QP with the connection manager, ipoib_cm_create_tx(),
has pointers to struct ipoib_neigh and struct ipoib_path but there
doesn't seem to be a reference count or struct completion similar to
the way the SA path record look up process has to prevent this.

I'm working on a patch to test this theory but wanted to post
this before going too far in case others are already aware
of the problem and working on it.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
