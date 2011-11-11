From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Linux 3.2-rc1 vs. OFED 1.5.4-rc4: Packets are looped back
Date: Fri, 11 Nov 2011 10:14:59 -0600 (CST)
Message-ID: <alpine.DEB.2.00.1111111007550.10404@router.home>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We have an app here that runs fine with OFED. But if I try to use the
kernel IB subsystem in 3.2 it complains about packets being looped back to
the application.

That seems to be controlled by IB_DEVICE_BLOCK_MULTICAST_LOOPBACK and
IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK.

Why does it not work in the kernel IB stack?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
