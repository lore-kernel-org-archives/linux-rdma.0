From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: PATCH [0/3] mlx4: Add counters support for IBoE
Date: Wed, 10 Nov 2010 14:23:23 +0200
Message-ID: <20101110122323.GA12037@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The following three patches provide support for IBoE counters for mlx4
devices. The counters can be read through sysfs files in the same
manner it is done of IB link layer IB ports. The patches provide the
following functionality:

1. Extend the device capability flags from 32 bit to 64 bit variable
for easier manipulation of the flags.

2. Provide a generic API at the mlx4 layer for allocating general
purpose counters sets. ConnectX has a number of counter sets that you
can allocate and assign to QPs so that traffic that goes through that
QP is counted.

3. For IBoE ports, make use of the generic counters to count traffic
that goes through IPoE ports. We allocate one set per port and assign
this set to all QPs of the port.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
