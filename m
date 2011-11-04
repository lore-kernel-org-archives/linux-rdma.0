From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/5] rdma/cm: Add support for native Infiniband addressing
Date: Fri, 4 Nov 2011 06:59:54 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E8D0FC@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The following patches are the first 5 in a series of 25 total that
adds the ability to handle native Infiniband addressing to the rdma_cm.
I'm hoping by submitting only a small subset of the patches at a time,
they will be easier to review.

Adding support for native IB addressing allows us to offload name
and/or address translation services to a user space daemon and
provide the user greater control over path selection.  A
primary motivation is to support a call rdma_getaddrinfo,
functionally equivalent to getaddrinfo, without duplicating address
resolution work or tying the implementation to specific IP services,
such as ARP.  It also allows an MPI application to exchange job
node addressing though a process manager using native network
addressing, which can avoid the need for most translations.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
