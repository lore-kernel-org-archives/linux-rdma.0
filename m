From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: RE: failure to get gid with rdma_bind_addr with >= 3.10 kernels
Date: Mon, 11 Nov 2013 18:14:49 +0000
Message-ID: <00000142485f86e5-c3027528-9892-4d5c-8d72-0ed5f98666c4-000000@email.amazonses.com>
References: <527F6896.1080802@mellanox.com> <527F69B1.9070701@mellanox.com> <1828884A29C6694DAF28B7E6B8A8237388CF6F78@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388CF6F78-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 11 Nov 2013, Hefty, Sean wrote:

> As part of the AF_IB changes, additional queries were introduced that
> separated out retrieving the different kernel data -- assigned address,
> GID mappings, and IB PR data.  (New queries were necessary, since
> sockaddr_ib is larger than sockaddr_in6, and we want to eventually
> handle non-reversible paths.)  The librdmacm 1.0.17 changed which query
> was called after rdma_bind_addr was invoked to only retrieve the
> assigned address, versus retrieving everything.  I think this is why you
> see an SGID of all 0's after calling rdma_bind_addr.

Is there another call that allows the retrieval of the SGID?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
