From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 0/6] IB/usnic: usNIC UDP Support
Date: Fri, 20 Dec 2013 12:38:17 -0800
Message-ID: <1387571903-9398-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch depends on http://www.spinics.net/lists/linux-rdma/msg18189.html.

This set of patches add UDP transport support on usNIC. Libusnic,
a libibverbs driver, allocates a UDP socket in the kernel via the
userspace socket API at ibv_create_qp time.  Then, the socket file
descriptor is pushed down to usnic_verbs.ko via ibv_create_qp_cmd.
Usnic_verbs bumps up the reference count on the socket, creates the qp,
and programs the forwarding classifier in the NIC to forward UDP traffic on
the socket fd, to the associated qp.  The forwarding classifier entry is
released whenever the qp is destroyed.  The reference count on the socket
is decremented after the forwarding classifier entry has been released.

The socket reference count is incremented in the first place to cover this
case: A malicious user returns the UDP port to the kernel but does not
destroy the qp or the associated forwarding entry in the NIC. Subsequently,
the kernel may give the UDP port to another application, but because
of the classifier entry in the NIC, the former user of the UDP port continues
to receive the traffic.  Increasing the reference count on the socket
guarantees that the socket will not go back to the kernel's free pool until
both the application closes the socket and the forwarding entry in the NIC
has been deleted.

[PATCH for-next 1/6] IB/usnic: Update ABI and Version file for UDP
[PATCH for-next 2/6] IB/usnic: Add UDP support to usnic_fwd.[hc]
[PATCH for-next 3/6] IB:usnic: Add UDP support to
[PATCH for-next 4/6] IB/usnic: Add UDP support in u*verbs.c, u*main.c
[PATCH for-next 5/6] IB/usnic: Add UDP support in
[PATCH for-next 6/6] IB/core: Rename RMDA_TRANSPORT_USNIC
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
