From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: failure to get gid with rdma_bind_addr with >= 3.10 kernels
Date: Mon, 11 Nov 2013 17:40:43 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CF6F78@ORSMSX109.amr.corp.intel.com>
References: <527F6896.1080802@mellanox.com> <527F69B1.9070701@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <527F69B1.9070701-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> $ ./rb 192.168.20.47
> event_channel: 0x6093c0
> cm_id: 0x602cb0
> sgid: fe 80 00 00 00 00 00 00 00 02 c9 03 00 e9 c0 81
> 
> --> with 3.12
> 
> $ ./rb 192.168.20.17
> event_channel: 0x6093c0
> cm_id: 0x6034c0
> sgid: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 
> There many commits for the 3.11 AF_IB merge, hope you can dig it out
> quickly..
> 
> Or.
> 
> linux-2.6]# git log --oneline v3.10.. drivers/infiniband/core/cma.c
..
> edaa7a5 RDMA/ucma: Add ability to query GID addresses

As part of the AF_IB changes, additional queries were introduced that separated out retrieving the different kernel data -- assigned address, GID mappings, and IB PR data.  (New queries were necessary, since sockaddr_ib is larger than sockaddr_in6, and we want to eventually handle non-reversible paths.)   The librdmacm 1.0.17 changed which query was called after rdma_bind_addr was invoked to only retrieve the assigned address, versus retrieving everything.  I think this is why you see an SGID of all 0's after calling rdma_bind_addr.

librdmacm 1.0.16 does not enable AF_IB for user space, and should return the SGID.  Assuming that this interpretation of the problem is correct, a fix for 1.0.17 would be to add a call to ucma_query_gid() from rdma_bind_addr2() - note '2' - if the specified address is not 'any address'.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
