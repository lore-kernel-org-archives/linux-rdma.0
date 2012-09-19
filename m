From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: how to preserve QP over HA events for librdmacm applications
Date: Wed, 19 Sep 2012 18:43:42 +0300
Message-ID: <5059E82E.9020600@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Alex Rosenbaum <Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sean,

We have a case here where an app which uses librdmacm wants to preserve its
QP over HA events such IB link down/up, specifically the sequence of 
operations
done by the app is the following:

1. rdma_create_id using the IPoIB  port space
2. rdma_bind _addr
3. rdma_create_qp  using UD QP type.

We are looking for a way to reset this QP such that any pending send 
buffers will be flushed
out and then the QP returns to be functional (in RTS state) - eventually 
with the same QPN.

Using rdma_disconnect indeed moves the QP to the error state and the 
buffers are flushed,
however, there's no way to modify the QP state again to RTS, etc via 
librdmacm.

Can this flushing be somehow done with the current librdmacm/libibverbs APIs
or we need some enhancement?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
